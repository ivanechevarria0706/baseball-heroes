import concurrent.futures
import copy
import json
import secrets
import tempfile
import threading
import unittest
import urllib.error
import urllib.request
from pathlib import Path
from server import Service, make_server


def team(name):
    return {"name": name, "accent": 0x2369ab, "heroIndex": 3, "players": [
        {"id": "player-"+str(i), "name": "Player "+str(i+1), "power": 76, "contact": 81, "speed": 60}
        for i in range(9)]}


class PrivateServerTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.db = Path(self.temp.name)/"private.sqlite3"
        self.service = Service(self.db)
        self.start()
        self.a = self.register("alice")
        invitation = self.call("POST", "/invites", {}, self.a)[1]["invite"]
        self.b = self.register("bob", invitation)
        self.call("POST", "/team", {"team": team("Alice Club")}, self.a)
        self.call("POST", "/team", {"team": team("Bob Club")}, self.b)

    def start(self):
        self.http = make_server(self.service, 0)
        self.thread = threading.Thread(target=self.http.serve_forever, daemon=True)
        self.thread.start()
        self.url = "http://127.0.0.1:"+str(self.http.server_port)

    def stop(self):
        self.http.shutdown()
        self.http.server_close()
        self.thread.join(3)

    def tearDown(self):
        self.stop()
        self.temp.cleanup()

    def call(self, method, path, data=None, account=None, headers=None):
        if data is not None:
            data = dict(data)
            data.setdefault("requestId", secrets.token_hex(16))
        h = {"Content-Type": "application/json"}
        if account:
            h["Authorization"] = "Bearer "+account["token"]
        h.update(headers or {})
        req = urllib.request.Request(self.url+path, data=json.dumps(data).encode() if data is not None else None, method=method, headers=h)
        try:
            with urllib.request.urlopen(req, timeout=5) as response:
                return response.status, json.load(response)
        except urllib.error.HTTPError as e:
            return e.code, json.load(e)

    def register(self, name, invitation=None):
        status, result = self.call("POST", "/register", {"username": name, "name": name.title(), "password": "test-only-password", "invite": invitation or self.service.bootstrap()})
        self.assertEqual(status, 200, result)
        return result

    def create(self):
        status, match = self.call("POST", "/matches", {"opponent": self.b["user"]["id"]}, self.a)
        self.assertEqual(status, 200, match)
        return match

    def test_auth_invites_privacy_and_schema(self):
        self.assertEqual(self.call("GET", "/lobby")[0], 401)
        self.assertEqual(self.call("POST", "/login", {"username": "alice", "password": "incorrect-password"})[0], 401)
        self.assertEqual(self.call("POST", "/register", {"username": "mallory", "name": "M", "password": "test-only-password", "invite": "wrong-code"})[0], 403)
        self.assertEqual(self.call("GET", "/health", headers={"Origin": "https://example.test"})[0], 403)
        self.assertEqual(self.call("GET", "/health", headers={"Host": "evil.test"})[0], 403)
        bad = team("Bad");bad["players"][1]["id"] = bad["players"][0]["id"]
        self.assertEqual(self.call("POST", "/team", {"team": bad}, self.a)[0], 400)
        bad = team("Bad");bad["players"][0]["power"] = 99999
        self.assertEqual(self.call("POST", "/team", {"team": bad}, self.a)[0], 400)
        status, lobby = self.call("GET", "/lobby", account=self.a)
        self.assertEqual(status, 200)
        self.assertEqual(len(lobby["members"]), 2)
        self.assertNotIn("password", json.dumps(lobby))
        with self.service.connection() as db:
            self.assertNotIn(self.a["token"], str([tuple(r) for r in db.execute("SELECT * FROM sessions")]))
            self.assertNotIn("test-only-password", str([tuple(r) for r in db.execute("SELECT * FROM users")]))

    def test_snapshots_restart_and_shared_result(self):
        match = self.create()
        self.call("POST", "/team", {"team": team("Bob Changed Later")}, self.b)
        received = self.call("GET", "/matches/"+match["id"], account=self.b)[1]
        self.assertEqual(received["awayTeam"]["name"], "Bob Club")
        self.assertEqual(self.call("POST", "/matches/"+match["id"]+"/auto", {"revision": 0}, self.b)[0], 403)
        third = self.register("charlie")
        self.assertEqual(self.call("GET", "/matches/"+match["id"], account=third)[0], 404)
        self.stop();self.service = Service(self.db);self.start()
        resumed = self.call("GET", "/matches/"+match["id"], account=self.a)[1]
        self.assertEqual(resumed, received)
        for _ in range(400):
            if resumed["state"]["status"] == "complete":
                break
            status, resumed = self.call("POST", "/matches/"+match["id"]+"/auto", {"revision": resumed["revision"]}, self.a)
            self.assertEqual(status, 200, resumed)
        self.assertEqual(resumed["state"]["status"], "complete")
        for side in ("home", "away"):
            self.assertEqual(sum(x or 0 for x in resumed["state"][side+"Line"]), resumed["state"][side])
            self.assertEqual(sum(p["rbi"] for p in resumed["state"]["box"][side]), resumed["state"][side])
        self.assertEqual(self.call("GET", "/matches/"+match["id"], account=self.b)[1], resumed)
        self.assertEqual(self.call("POST", "/matches/"+match["id"]+"/auto", {"revision": resumed["revision"]}, self.a)[0], 409)

    def test_pitch_resume_idempotency_and_concurrent_requests(self):
        body = {"opponent": self.b["user"]["id"], "requestId": secrets.token_hex(16)}
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            replies = list(pool.map(lambda _: self.call("POST", "/matches", body, self.a), range(2)))
        self.assertEqual(replies[0], replies[1])
        match = replies[0][1]
        self.assertEqual(self.call("POST", "/matches", {"opponent": self.b["user"]["id"]}, self.a)[0], 409)
        body = {"revision": match["revision"], "requestId": secrets.token_hex(16)}
        path = "/matches/"+match["id"]
        status, pitch = self.call("POST", path+"/pitch", body, self.a)
        self.assertEqual(status, 200)
        self.assertNotIn("issued", pitch["state"]["pending"])
        self.assertEqual(self.call("POST", path+"/pitch", body, self.a)[1], pitch)
        self.assertEqual(self.call("POST", path+"/auto", {"revision": pitch["revision"]}, self.a)[0], 409)
        self.stop();self.service = Service(self.db);self.start()
        restored = self.call("GET", path, account=self.a)[1]
        self.assertEqual(restored, pitch)
        p = pitch["state"]["pending"]
        body = {"revision": pitch["revision"], "pitchId": p["id"], "elapsedMs": p["duration"]*.84, "requestId": secrets.token_hex(16)}
        invalid = dict(body, elapsedMs=-1)
        self.assertEqual(self.call("POST", path+"/swing", invalid, self.a)[0], 400)
        status, resolved = self.call("POST", path+"/swing", body, self.a)
        self.assertEqual(status, 200, resolved)
        self.assertEqual(self.call("POST", path+"/swing", body, self.a)[1], resolved)
        self.assertEqual(self.call("POST", path+"/swing", dict(body, elapsedMs=0), self.a)[0], 409)
        self.assertEqual(self.call("POST", path+"/swing", dict(body, requestId=secrets.token_hex(16)), self.a)[0], 409)
        self.assertEqual(self.call("GET", path, account=self.b)[1], resolved)

    def test_cancel_invite_consumption_and_logout(self):
        code = self.call("POST", "/invites", {}, self.a)[1]["invite"]
        self.register("charlie", code)
        self.assertEqual(self.call("POST", "/register", {"username": "david", "name": "D", "password": "test-only-password", "invite": code})[0], 403)
        match = self.create()
        status, cancelled = self.call("POST", "/matches/"+match["id"]+"/cancel", {"revision": match["revision"]}, self.a)
        self.assertEqual(status, 200)
        self.assertEqual(cancelled["state"]["status"], "cancelled")
        self.assertNotIn("winner", cancelled["state"])
        self.assertEqual(self.call("POST", "/logout", {}, self.a)[0], 200)
        self.assertEqual(self.call("GET", "/lobby", account=self.a)[0], 401)


if __name__ == "__main__":
    unittest.main(verbosity=2)
