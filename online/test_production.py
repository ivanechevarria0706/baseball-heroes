from contextlib import closing
import json
from pathlib import Path
import secrets
import sqlite3
import tempfile
import threading
import unittest
from unittest.mock import patch
import urllib.error
import urllib.request

from production import build_application, initialize_invite, make_http_server, snapshot
from server import Problem, Service, digest


class ProductionTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.invite = secrets.token_urlsafe(24)
        self.environment = {"BH_DATA_DIR": self.temporary.name,
                            "BH_PUBLIC_HOST": "game.example.test", "BH_BOOTSTRAP_INVITE": self.invite}
        self.app = build_application(self.environment)

    def tearDown(self):
        self.temporary.cleanup()

    def test_required_persistence_and_bootstrap_never_reopens(self):
        for changes in ({"BH_DATA_DIR": ""}, {"BH_PUBLIC_HOST": ""}):
            with self.assertRaises(RuntimeError):
                build_application(dict(self.environment, **changes))
        with self.app.service.connection() as db:
            db.execute("UPDATE invites SET expires=1")
        initialize_invite(self.app.service, self.invite)
        with self.app.service.connection() as db:
            self.assertEqual(db.execute("SELECT expires FROM invites").fetchone()[0], 1)
            self.assertNotIn(self.invite, str([tuple(r) for r in db.execute("SELECT * FROM invites")]))
        with self.assertRaises(Problem):
            self.app.service.request("POST", "/register", {"username": "owner", "name": "Owner",
                                     "password": "test-password", "invite": self.invite})

    def test_consistent_backup_restores_accounts_and_limits(self):
        service = self.app.service
        account = service.request("POST", "/register", {"username": "owner", "name": "Owner",
                                  "password": "test-password", "invite": self.invite})
        backup = snapshot(service)
        self.assertEqual(snapshot(service), backup)
        restored_path = Path(self.temporary.name) / "restored.sqlite3"
        with closing(sqlite3.connect(backup)) as source, closing(sqlite3.connect(restored_path)) as target:
            source.backup(target)
        restored = Service(restored_path)
        self.assertEqual(restored.request("GET", "/lobby", {}, account["token"])["user"], account["user"])
        with restored.connection() as db:
            self.assertIsNotNone(db.execute("SELECT used_by FROM invites WHERE code=?", (digest(self.invite),)).fetchone()[0])
        with patch("production.time.time", return_value=2000000000):
            service.budgets.clear()
            for _ in range(60):
                with self.assertRaises(Problem):
                    service.request("POST", "/login", {})
            with self.assertRaises(Problem) as rejected:
                service.request("POST", "/login", {})
            self.assertEqual(rejected.exception.status, 429)
            self.assertEqual(service.request("GET", "/health", {})["protocol"], 1)

    def test_real_wsgi_server_gateway_and_shared_state(self):
        http = make_http_server(self.app, "127.0.0.1", 0)
        thread = threading.Thread(target=http.run, daemon=True)
        thread.start()
        def call(method, path, data=None, token="", tls=True):
            headers = {"Host": "game.example.test", "Content-Type": "application/json",
                       "Authorization": "Bearer " + token, "X-Forwarded-For": "forged-client-address"}
            if tls:
                headers["X-Forwarded-Proto"] = "https"
            request = urllib.request.Request("http://127.0.0.1:" + str(http.effective_port) + path,
                                             method=method, headers=headers,
                                             data=json.dumps(data).encode() if data is not None else None)
            try:
                with urllib.request.urlopen(request, timeout=5) as response:
                    return response.status, json.load(response)
            except urllib.error.HTTPError as error:
                return error.code, json.load(error)
        try:
            self.assertEqual(call("GET", "/health", tls=False)[0], 403)
            self.assertEqual(call("GET", "/health")[0], 200)
            status, account = call("POST", "/register", {"username": "owner", "name": "Owner",
                                   "password": "test-password", "invite": self.invite})
            self.assertEqual(status, 200)
            self.assertEqual(call("GET", "/lobby", token=account["token"])[1]["user"], account["user"])
            self.assertEqual(call("GET", "/lobby")[0], 401)
            self.assertEqual(call("GET", "/data/private.sqlite3", token=account["token"])[0], 404)
        finally:
            http.close()
            thread.join(3)


if __name__ == "__main__":
    unittest.main()
