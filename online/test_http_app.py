import io
import json
from pathlib import Path
import secrets
import tempfile
import unittest
from http_app import Application
from server import MAX_BODY, Service


class GatewayTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.service = Service(Path(self.temporary.name) / "private.sqlite3")
        self.app = Application(self.service, "game.example.test", "healthcheck.railway.app")

    def tearDown(self):
        self.temporary.cleanup()

    def call(self, method="GET", path="/health", data=None, token="", **overrides):
        payload = json.dumps(data).encode() if data is not None else b""
        environ = {"REQUEST_METHOD": method, "PATH_INFO": path, "HTTP_HOST": "game.example.test",
                   "wsgi.url_scheme": "https", "wsgi.input": io.BytesIO(payload),
                   "CONTENT_LENGTH": str(len(payload)), "CONTENT_TYPE": "application/json",
                   "HTTP_AUTHORIZATION": "Bearer " + token}
        environ.update(overrides)
        response = {}
        def start(status, headers):
            response.update(status=int(status.split()[0]), headers=dict(headers))
        body = b"".join(self.app(environ, start))
        return response["status"], json.loads(body) if body else None, response["headers"]

    def test_host_tls_and_health_probe(self):
        status, data, headers = self.call()
        self.assertEqual(status, 200)
        self.assertFalse(data["development"])
        self.assertEqual(headers["Cache-Control"], "no-store")
        self.assertEqual(self.call(HTTP_HOST="other.example.test")[0], 403)
        self.assertEqual(self.call(**{"wsgi.url_scheme": "http", "HTTP_X_FORWARDED_PROTO": "https"})[0], 403)
        self.assertEqual(self.call(HTTP_ORIGIN="https://game.example.test")[0], 403)
        probe = {"HTTP_HOST": "healthcheck.railway.app", "wsgi.url_scheme": "http"}
        self.assertEqual(self.call(**probe)[0], 200)
        self.assertEqual(self.call(path="/lobby", **probe)[0], 403)
        self.assertEqual(self.call("HEAD")[1], None)
        self.assertEqual(self.call("DELETE")[0], 405)
        self.assertEqual(self.call(QUERY_STRING="token=not-accepted")[0], 400)

    def test_json_boundaries_and_private_errors(self):
        self.assertEqual(self.call("POST", "/login", CONTENT_LENGTH=str(MAX_BODY + 1))[0], 413)
        self.assertEqual(self.call("POST", "/login", CONTENT_TYPE="text/plain")[0], 415)
        self.assertEqual(self.call("POST", "/login", data=[])[0], 400)
        self.assertEqual(self.call("POST", "/login", CONTENT_LENGTH="invalid")[0], 400)
        self.assertEqual(self.call("POST", "/login", CONTENT_LENGTH="12")[0], 400)
        self.assertEqual(self.call("POST", "/login", data={"n": float("nan")})[0], 400)
        self.assertEqual(self.call(path="/lobby")[0], 401)
        def unavailable(*args):
            raise RuntimeError("private database password must not escape")
        self.service.request = unavailable
        status, data, headers = self.call()
        self.assertEqual(status, 503)
        self.assertNotIn("password", json.dumps(data))
        self.assertIn("Retry-After", headers)

    def test_invited_registration_and_persistent_session(self):
        invite = self.service.bootstrap()
        registration = {"username": "owner", "name": "Owner", "password": secrets.token_urlsafe(18), "invite": invite}
        status, account, _ = self.call("POST", "/register", registration)
        self.assertEqual(status, 200)
        token = account["token"]
        self.app = Application(Service(self.service.path), "game.example.test")
        self.assertEqual(self.call(path="/lobby", token=token)[1]["user"], account["user"])
        registration["username"] = "second"
        self.assertEqual(self.call("POST", "/register", registration)[0], 403)


if __name__ == "__main__":
    unittest.main()
