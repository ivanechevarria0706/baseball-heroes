"""Loopback-only development service for private Baseball Heroes exhibitions.

Python 3.12+, standard library. Internet deployment requires a configured HTTPS
gateway; this development launcher intentionally listens only on 127.0.0.1.
"""
import argparse
from contextlib import contextmanager, closing
import hashlib
import hmac
import json
import math
from pathlib import Path
import re
import secrets
import sqlite3
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlsplit
import rules
import leagues
import social
import scores

MAX_BODY = 32768
SCHEMA = """
CREATE TABLE IF NOT EXISTS users(id TEXT PRIMARY KEY, username TEXT UNIQUE NOT NULL, name TEXT NOT NULL, salt TEXT NOT NULL, password TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS sessions(token TEXT PRIMARY KEY, user_id TEXT NOT NULL REFERENCES users(id), expires REAL NOT NULL);
CREATE TABLE IF NOT EXISTS invites(code TEXT PRIMARY KEY, expires REAL NOT NULL, used_by TEXT);
CREATE TABLE IF NOT EXISTS teams(user_id TEXT PRIMARY KEY REFERENCES users(id), version INTEGER NOT NULL, data TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS matches(id TEXT PRIMARY KEY, home_id TEXT NOT NULL, away_id TEXT NOT NULL, home TEXT NOT NULL, away TEXT NOT NULL, state TEXT NOT NULL, revision INTEGER NOT NULL, created REAL NOT NULL);
CREATE TABLE IF NOT EXISTS receipts(user_id TEXT NOT NULL, request_id TEXT NOT NULL, fingerprint TEXT NOT NULL, response TEXT NOT NULL, PRIMARY KEY(user_id,request_id));
"""


class Problem(Exception):
    def __init__(self, status, message):
        self.status, self.message = status, message


def fail(status, message):
    raise Problem(status, message)


def text_value(data, key, minimum=1, maximum=40):
    value = data.get(key)
    if not isinstance(value, str) or not minimum <= len(value.strip()) <= maximum or any(ord(c) < 32 for c in value):
        fail(400, "Invalid field: " + key)
    return value.strip()


def integer(data, key, low, high):
    n = data.get(key)
    if type(n) is not int or not low <= n <= high:
        fail(400, "Invalid number: " + key)
    return n


def clean_team(data):
    team = {"name": text_value(data, "name", 1, 28), "accent": integer(data, "accent", 0, 0xffffff),
            "heroIndex": integer(data, "heroIndex", 0, 8), "players": []}
    players = data.get("players")
    if not isinstance(players, list) or len(players) != 9:
        fail(400, "The lineup must contain nine players.")
    identifiers = set()
    for p in players:
        if not isinstance(p, dict):
            fail(400, "Invalid player.")
        row = {"id": text_value(p, "id", 1, 60), "name": text_value(p, "name", 1, 32)}
        if row["id"] in identifiers:
            fail(400, "Duplicate player in the lineup.")
        identifiers.add(row["id"])
        for stat in ("power", "contact", "speed"):
            row[stat] = integer(p, stat, 1, 200)
        team["players"].append(row)
    team["heroAverage"] = integer(data,"heroAverage",0,1000) if "heroAverage" in data else 0
    return team


def digest(value):
    return hashlib.sha256(value.encode()).hexdigest()


def password_hash(password, salt):
    return hashlib.scrypt(password.encode(), salt=bytes.fromhex(salt), n=16384, r=8, p=1, maxmem=64*1024*1024).hex()


class Service:
    def __init__(self, path):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.lock = threading.RLock()
        self.attempts = {}
        self.leagues = leagues.Leagues(self, fail, text_value)
        self.social = social.Social(fail, text_value)
        self.scores = scores.Scores(fail, text_value, self.social)
        with self.connection() as db:
            version = db.execute("PRAGMA user_version").fetchone()[0]
            if version > 4:
                raise RuntimeError("The database belongs to a newer server version.")
            if version in (1,2,3):
                backup = self.path.with_name(self.path.stem+({1:".before-leagues-v2.sqlite3",2:".before-social-v3.sqlite3",3:".before-visits-v4.sqlite3"}[version]))
                if not backup.exists():
                    with closing(sqlite3.connect(backup)) as copy:
                        db.backup(copy)
            db.executescript(SCHEMA)
            db.executescript(leagues.SCHEMA)
            db.executescript(social.SCHEMA)
            db.executescript(scores.SCHEMA)
            db.execute("PRAGMA user_version=4")
            db.execute("PRAGMA journal_mode=WAL")

    @contextmanager
    def connection(self):
        db = sqlite3.connect(self.path, timeout=10)
        db.row_factory = sqlite3.Row
        db.execute("PRAGMA foreign_keys=ON")
        try:
            with db:
                yield db
        finally:
            db.close()

    def invite(self, db):
        code = secrets.token_urlsafe(12)
        db.execute("INSERT INTO invites VALUES(?,?,NULL)", (digest(code), time.time()+72*3600))
        return code

    def bootstrap(self):
        with self.connection() as db:
            return self.invite(db)

    def throttle(self, key):
        now = time.time()
        if len(self.attempts) > 2000:
            self.attempts = {k: v for k, v in self.attempts.items() if v[0] > now-600}
        start, count = self.attempts.get(key, (now, 0))
        if now-start > 600:
            start, count = now, 0
        if count >= 15:
            fail(429, "Too many attempts. Wait ten minutes.")
        self.attempts[key] = (start, count+1)

    def session(self, db, uid):
        token = secrets.token_urlsafe(32)
        db.execute("DELETE FROM sessions WHERE expires < ?", (time.time(),))
        db.execute("INSERT INTO sessions VALUES(?,?,?)", (digest(token), uid, time.time()+30*86400))
        user = db.execute("SELECT id,name FROM users WHERE id=?", (uid,)).fetchone()
        return {"token": token, "user": dict(user), "protocol": 1}

    def authorize(self, db, token):
        user = db.execute("SELECT users.id,users.name FROM sessions JOIN users ON users.id=sessions.user_id WHERE token=? AND expires>?", (digest(token), time.time())).fetchone()
        if not user:
            fail(401, "Sign in again.")
        return dict(user)

    def match(self, db, mid, uid):
        row = db.execute("SELECT * FROM matches WHERE id=?", (mid,)).fetchone()
        if not row:
            fail(404, "Challenge unavailable.")
        if uid not in (row["home_id"], row["away_id"]):
            league = self.leagues.for_match(db, mid)
            if not league or not self.leagues.member(db, league["id"], uid):
                fail(404, "Challenge unavailable.")
        return dict(row)

    def public_match(self, m, db=None):
        result = {"id": m["id"], "homeId": m["home_id"], "awayId": m["away_id"],
                "homeTeam": json.loads(m["home"]), "awayTeam": json.loads(m["away"]),
                "state": rules.public_state(json.loads(m["state"])), "revision": m["revision"]}
        if db is not None:
            league = self.leagues.for_match(db, m["id"])
            if league:
                result["league"] = league
        return result

    def ensure_no_active_match(self, db, uid):
        for row in db.execute("SELECT state FROM matches WHERE home_id=?", (uid,)):
            if json.loads(row["state"])["status"] == "playing":
                fail(409, "Finish your pending game before starting another.")

    def request(self, method, path, data, token="", peer="local", *, open_registration=False):
        with self.lock, self.connection() as db:
            db.execute("BEGIN IMMEDIATE")
            if method == "GET" and path == "/health":
                return {"name": "Baseball Heroes Private", "protocol": 1, "rules": rules.RULES, "development": True, "features": ["private-leagues-v1","private-social-v1"]}
            if method == "POST" and path in ("/register", "/login"):
                username = text_value(data, "username", 3, 24).lower()
                if not re.fullmatch(r"[a-z0-9_]{3,24}", username):
                    fail(400, "Username: 3–24 letters, numbers or underscores.")
                password = text_value(data, "password", 8, 128)
                self.throttle(peer + ":" + username)
                if path == "/register":
                    # Only the trusted browser route enables open registration.
                    # Request JSON cannot change the legacy desktop policy.
                    if not open_registration:
                        code = text_value(data, "invite", 8, 80)
                        inv = db.execute("SELECT * FROM invites WHERE code=? AND used_by IS NULL AND expires>?", (digest(code), time.time())).fetchone()
                        if not inv:
                            fail(403, "Invalid, used or expired invitation.")
                    uid, salt = secrets.token_hex(16), secrets.token_hex(16)
                    name = text_value(data, "name", 1, 28)
                    try:
                        db.execute("INSERT INTO users VALUES(?,?,?,?,?)", (uid, username, name, salt, password_hash(password, salt)))
                    except sqlite3.IntegrityError:
                        fail(409, "That username already exists; sign in.")
                    if not open_registration:
                        db.execute("UPDATE invites SET used_by=? WHERE code=?", (uid, digest(code)))
                else:
                    row = db.execute("SELECT * FROM users WHERE username=?", (username,)).fetchone()
                    actual = password_hash(password, row["salt"] if row else "00"*16)
                    if not row or not hmac.compare_digest(actual, row["password"]):
                        fail(401, "Incorrect username or password.")
                    uid = row["id"]
                result = self.session(db, uid)
                self.attempts.pop(peer + ":" + username, None)
                return result
            user = self.authorize(db, token)
            uid = user["id"]
            if method == "GET":
                if path == "/scores":
                    return self.scores.snapshot(db,uid)
                if path == "/social":
                    return self.social.snapshot(db,uid)
                if path == "/lobby":
                    members = [dict(r) for r in db.execute("SELECT u.id,u.name,t.version,t.data FROM users u LEFT JOIN teams t ON t.user_id=u.id ORDER BY u.name")]
                    for m in members:
                        m["team"] = json.loads(m.pop("data")) if m["data"] else None
                        m.pop("data", None)
                    matches = [self.public_match(dict(r), db) for r in db.execute("SELECT * FROM matches WHERE home_id=? OR away_id=? ORDER BY created DESC LIMIT 50", (uid, uid))]
                    return {"user": user, "members": members, "matches": matches}
                if path == "/leagues":
                    return self.leagues.listing(db, uid)
                found = re.fullmatch(r"/leagues/([a-f0-9]{32})", path)
                if found:
                    return self.leagues.detail(db, found[1], uid)
                found = re.fullmatch(r"/matches/([a-f0-9]{32})", path)
                if found:
                    return self.public_match(self.match(db, found[1], uid), db)
                fail(404, "Ruta desconocida.")
            if method != "POST":
                fail(405, "Method not allowed.")
            request_id = text_value(data, "requestId", 8, 80)
            fingerprint = digest(path + json.dumps(data, sort_keys=True, ensure_ascii=False, allow_nan=False))
            previous = db.execute("SELECT * FROM receipts WHERE user_id=? AND request_id=?", (uid, request_id)).fetchone()
            if previous:
                if previous["fingerprint"] != fingerprint:
                    fail(409, "Identifier already used for another action.")
                return json.loads(previous["response"])
            result = self.mutate(db, user, path, data, token)
            db.execute("INSERT INTO receipts VALUES(?,?,?,?)", (uid, request_id, fingerprint, json.dumps(result, allow_nan=False)))
            return result

    def mutate(self, db, user, path, data, token):
        uid = user["id"]
        if path == "/scores" or path.startswith("/scores/"):
            return self.scores.mutate(db,uid,path,data)
        if path.startswith("/social/"):
            return self.social.mutate(db,uid,path,data)
        if path == "/leagues":
            return self.leagues.create(db, uid, data)
        found = re.fullmatch(r"/leagues/([a-f0-9]{32})/(join|leave|start|cancel)", path)
        if found:
            return self.leagues.change(db, found[1], uid, found[2])
        found = re.fullmatch(r"/leagues/([a-f0-9]{32})/fixtures/([a-f0-9]{32})/play", path)
        if found:
            return self.leagues.play(db, found[1], found[2], uid)
        if path == "/logout":
            db.execute("DELETE FROM sessions WHERE token=?", (digest(token),))
            return {"ok": True}
        if path == "/invites":
            return {"invite": self.invite(db), "expiresHours": 72}
        if path == "/team":
            if not isinstance(data.get("team"), dict):
                fail(400, "Missing lineup.")
            team = clean_team(data["team"])
            old = db.execute("SELECT version FROM teams WHERE user_id=?", (uid,)).fetchone()
            version = old[0]+1 if old else 1
            team["version"] = version
            db.execute("INSERT INTO teams VALUES(?,?,?) ON CONFLICT(user_id) DO UPDATE SET version=excluded.version,data=excluded.data", (uid, version, json.dumps(team)))
            return {"team": team}
        if path == "/matches":
            other = text_value(data, "opponent", 32, 32)
            if other == uid:
                fail(400, "Choose a friend's team.")
            home = db.execute("SELECT data FROM teams WHERE user_id=?", (uid,)).fetchone()
            away = db.execute("SELECT data FROM teams WHERE user_id=?", (other,)).fetchone()
            if not home or not away:
                fail(409, "Both players need a published lineup.")
            self.ensure_no_active_match(db, uid)
            home_team, away_team = json.loads(home[0]), json.loads(away[0])
            mid = secrets.token_hex(16)
            state = rules.new_state(home_team, away_team)
            db.execute("INSERT INTO matches VALUES(?,?,?,?,?,?,?,?)", (mid, uid, other, home[0], away[0], json.dumps(state), 0, time.time()))
            return self.public_match(self.match(db, mid, uid))
        found = re.fullmatch(r"/matches/([a-f0-9]{32})/(pitch|swing|auto|cancel|forfeit)", path)
        if not found:
            fail(404, "Ruta desconocida.")
        m = self.match(db, found[1], uid)
        if m["home_id"] != uid:
            fail(403, "Only the challenge creator plays these turns.")
        if integer(data, "revision", 0, 1000000) != m["revision"]:
            fail(409, "The game changed. Refresh to continue.")
        s, home, away = json.loads(m["state"]), json.loads(m["home"]), json.loads(m["away"])
        if s["status"] != "playing":
            fail(409, "The challenge has ended.")
        action = found[2]
        league = self.leagues.for_match(db, m["id"])
        if action == "cancel" and league:
            fail(409, "A league game must be resumed or forfeited with a 0–9 loss.")
        if action == "forfeit" and not league:
            fail(409, "This friendly can be canceled without a result.")
        if action == "pitch":
            rules.pitch(s)
        elif action == "swing":
            if not s["pending"] or data.get("pitchId") != s["pending"]["id"]:
                fail(409, "The pitch was already resolved or does not exist.")
            elapsed = data.get("elapsedMs")
            if elapsed is not None and (type(elapsed) not in (int, float) or not math.isfinite(elapsed) or not 0 <= elapsed <= 2500):
                fail(400, "Invalid swing timing.")
            rules.swing(s, home, away, elapsed)
        elif action == "auto":
            if s["pending"]:
                fail(409, "Resolve the pitch before simulating another turn.")
            rules.autoplay(s, home, away)
        elif action == "forfeit":
            s.update(status="complete", pending=None, winner="away", forfeit=True,
                     home=0, away=9, homeLine=[None]*9, awayLine=[None]*9,
                     box={"home": [], "away": []}, events=[], lastCall="ABANDONO · 0–9")
        else:
            s["status"], s["pending"] = "cancelled", None
        db.execute("UPDATE matches SET state=?,revision=revision+1 WHERE id=?", (json.dumps(s), m["id"]))
        self.leagues.finish_if_complete(db, league["id"] if league else None)
        return self.public_match(self.match(db, m["id"], uid), db)


class Handler(BaseHTTPRequestHandler):
    server_version = "BHPrivate/1"
    def setup(self):
        super().setup()
        self.connection.settimeout(8)

    def log_message(self, fmt, *args):
        pass  # Never log tokens, passwords, invitations or payloads.

    def reply(self, status, data):
        encoded = json.dumps(data, ensure_ascii=False, allow_nan=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("Content-Length", str(len(encoded)))
        self.end_headers()
        self.wfile.write(encoded)

    def handle_api(self):
        try:
            host = self.headers.get("Host", "").split(":")[0]
            if host not in ("localhost", "127.0.0.1") or self.headers.get("Origin"):
                fail(403, "This test service only accepts the local client.")
            if self.headers.get("Transfer-Encoding"):
                fail(400, "Unsupported format.")
            size = int(self.headers.get("Content-Length", "0"))
            if not 0 <= size <= MAX_BODY:
                fail(413, "Request too large.")
            data = {}
            if self.command == "POST":
                if self.headers.get_content_type() != "application/json":
                    fail(415, "JSON required.")
                data = json.loads(self.rfile.read(size), parse_constant=lambda _: fail(400, "Invalid number."))
                if not isinstance(data, dict):
                    fail(400, "Invalid request.")
            auth = self.headers.get("Authorization", "")
            token = auth[7:] if auth.startswith("Bearer ") else ""
            result = self.server.service.request(self.command, urlsplit(self.path).path, data, token, self.client_address[0])
            self.reply(200, result)
        except Problem as e:
            self.reply(e.status, {"error": e.message})
        except (ValueError, UnicodeError, TypeError):
            self.reply(400, {"error": "Invalid request."})
        except (BrokenPipeError, ConnectionResetError, TimeoutError):
            pass
        except Exception:
            self.reply(500, {"error": "Could not complete the operation. Retry the same action."})

    do_GET = do_POST = do_PUT = do_DELETE = handle_api


def make_server(service, port):
    server = ThreadingHTTPServer(("127.0.0.1", port), Handler)
    server.daemon_threads = True
    server.service = service
    return server


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--db", default=str(Path(__file__).parent/"data"/"private.sqlite3"))
    parser.add_argument("--new-invite", action="store_true")
    args = parser.parse_args()
    service = Service(args.db)
    with service.connection() as db:
        empty = db.execute("SELECT COUNT(*) FROM users").fetchone()[0] == 0
    server = make_server(service, args.port)
    print(f"Baseball Heroes: http://127.0.0.1:{server.server_port}", flush=True)
    if empty or args.new_invite:
        print("Single-use invitation (72 hours): " + service.bootstrap(), flush=True)
    print("Local test. Keep this window open. Ctrl+C to stop.", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()
