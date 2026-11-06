"""Same-origin browser shell, HttpOnly sessions and versioned per-account saves.

Desktop API remains unchanged. Browser requests never expose its bearer token
to JavaScript. A save is a private client snapshot, not proof of earned stats.
"""
from http import HTTPStatus
from http.cookies import SimpleCookie
from pathlib import Path
import hashlib
import io
import json
import mimetypes
import re
import time
from server import Problem, fail

COOKIE = "bh_web_session"
SAVE_LIMIT = 512 * 1024
SCHEMA = """CREATE TABLE IF NOT EXISTS web_saves(
user_id TEXT PRIMARY KEY REFERENCES users(id), revision INTEGER NOT NULL,
data TEXT NOT NULL, previous TEXT, updated REAL NOT NULL,
request_id TEXT NOT NULL, fingerprint TEXT NOT NULL);"""


class WebApplication:
    def __init__(self, api, public_dir, development=False):
        self.api, self.service = api, api.service
        self.root = Path(public_dir).resolve()
        self.development = development
        self.origin = ("http://" if development else "https://") + api.public_host
        self.files = {"/" + p.relative_to(self.root).as_posix(): p
                      for p in self.root.rglob("*") if p.is_file()}
        self.file_etags = {}
        with self.service.connection() as db:
            db.executescript(SCHEMA)

    def token(self, env):
        cookie = SimpleCookie()
        try:
            cookie.load(env.get("HTTP_COOKIE", ""))
            return cookie[COOKIE].value if COOKIE in cookie else ""
        except Exception:
            return ""

    def authorize(self, token):
        with self.service.connection() as db:
            return self.service.authorize(db, token)

    def body(self, env, limit=32768):
        if env.get("CONTENT_TYPE", "").split(";", 1)[0] != "application/json":
            fail(415, "JSON required.")
        size = int(env.get("CONTENT_LENGTH") or 0)
        if not 0 < size <= limit:
            fail(413, "Request too large.")
        raw = env["wsgi.input"].read(size)
        if len(raw) != size:
            fail(400, "Incomplete request.")
        value = json.loads(raw, parse_constant=lambda _: fail(400, "Invalid number."))
        if not isinstance(value, dict):
            fail(400, "Invalid request.")
        return value

    def save(self, token, method, data):
        with self.service.lock, self.service.connection() as db:
            db.execute("BEGIN IMMEDIATE")
            # A logout or release reset may revoke a session between the route
            # check and this transaction. Authenticate the snapshot transaction.
            uid = self.service.authorize(db, token)["id"]
            row = db.execute("SELECT * FROM web_saves WHERE user_id=?", (uid,)).fetchone()
            revision = row["revision"] if row else 0
            if method == "GET":
                return {"revision": revision, "data": json.loads(row["data"]) if row else None}
            snapshot = data.get("data")
            if not isinstance(snapshot, dict) or snapshot.get("version") not in (21, 22, 23, 24):
                fail(400, "Unsupported save format.")
            if not isinstance(snapshot.get("roster"), list) or not 1 <= len(snapshot["roster"]) <= 1000:
                fail(400, "The save does not contain a valid roster.")
            def check(value, depth=0):
                if depth > 40:
                    fail(400, "Save too complex.")
                if isinstance(value, dict):
                    for key, item in value.items():
                        if key in ("__proto__", "constructor", "prototype"):
                            fail(400, "Invalid save field.")
                        check(item, depth + 1)
                elif isinstance(value, list):
                    for item in value:
                        check(item, depth + 1)
            check(snapshot)
            encoded = json.dumps(snapshot, ensure_ascii=False, allow_nan=False, separators=(",", ":"))
            if len(encoded.encode()) > SAVE_LIMIT:
                fail(413, "Save too large.")
            request_id = data.get("requestId", "")
            if not isinstance(request_id, str) or not re.fullmatch(r"[a-zA-Z0-9_-]{8,80}", request_id):
                fail(400, "Invalid save identifier.")
            fingerprint = hashlib.sha256(json.dumps(data, sort_keys=True, allow_nan=False).encode()).hexdigest()
            if row and row["request_id"] == request_id:
                if row["fingerprint"] != fingerprint:
                    fail(409, "This identifier has already saved different progress.")
                return {"revision": revision}
            if type(data.get("revision")) is not int or data["revision"] != revision:
                fail(409, "Your save changed in another tab or computer. Reload to continue with the cloud copy.")
            if row and snapshot["version"] < json.loads(row["data"]).get("version", 21):
                fail(409, "The game was updated in another tab. Reload to keep the latest tutorial and progress.")
            db.execute("INSERT INTO web_saves VALUES(?,?,?,?,?,?,?) ON CONFLICT(user_id) DO UPDATE SET "
                       "revision=excluded.revision,data=excluded.data,previous=excluded.previous,updated=excluded.updated,"
                       "request_id=excluded.request_id,fingerprint=excluded.fingerprint",
                       (uid, revision + 1, encoded, row["data"] if row else None, time.time(), request_id, fingerprint))
            return {"revision": revision + 1}

    def __call__(self, env, start_response):
        path, method = env.get("PATH_INFO", ""), env.get("REQUEST_METHOD", "")
        browser = path.startswith(("/web/", "/game/", "/ruffle/")) or path in ("/", "/app.js", "/startup.js", "/game-cache.js", "/recovery.js", "/style.css", "/version.json", "/welcome.png", "/amigos.html")
        if not browser:
            return self.api(env, start_response)
        status, extra, cache_control = 200, [], "no-store"
        content_type = "application/json; charset=utf-8"
        try:
            if env.get("HTTP_HOST", "").lower() not in (self.api.public_host, self.api.public_host + ":443"):
                fail(403, "Unauthorized server.")
            if env.get("wsgi.url_scheme") != ("http" if self.development else "https"):
                fail(403, "An HTTPS connection is required.")
            if method not in ("GET", "HEAD", "POST"):
                fail(405, "Method not allowed.")
            origin = env.get("HTTP_ORIGIN")
            if origin and origin != self.origin:
                fail(403, "Unauthorized origin.")
            if method == "POST" and origin != self.origin:
                fail(403, "Open the game from its website.")
            public_navigation = method in ("GET", "HEAD") and path in ("/", "/amigos.html")
            if env.get("HTTP_SEC_FETCH_SITE") == "cross-site" and not public_navigation:
                fail(403, "Open the game from its website.")
            token = self.token(env)
            if path.startswith("/web/"):
                if method == "HEAD" or env.get("QUERY_STRING"):
                    fail(400, "Invalid request.")
                if method == "POST" and path in ("/web/login", "/web/register"):
                    result = self.service.request("POST", path[4:], self.body(env), peer="browser",
                                                  open_registration=path == "/web/register")
                    cookie = COOKIE + "=" + result["token"] + "; Path=/; HttpOnly; SameSite=Strict; Max-Age=2592000"
                    if not self.development:
                        cookie += "; Secure"
                    extra.append(("Set-Cookie", cookie))
                    result = {"user": result["user"]}
                else:
                    user = self.authorize(token)
                    expected_account = env.get("HTTP_X_BH_ACCOUNT")
                    if expected_account is not None and expected_account != user["id"]:
                        fail(409, "Another account is active in this browser. Reload before continuing; your local copy is preserved.")
                    if path == "/web/session" and method == "GET":
                        result = {"user": user}
                    elif path == "/web/save":
                        result = self.save(token, method, self.body(env, SAVE_LIMIT+4096) if method == "POST" else {})
                    elif path.startswith("/web/api/"):
                        route = path[len("/web/api"):]
                        if route in ("/register", "/login", "/health"):
                            fail(404, "Route unavailable.")
                        result = self.service.request(method, route, self.body(env) if method == "POST" else {}, token, "browser")
                        if route == "/logout" and method == "POST":
                            extra.append(("Set-Cookie", COOKIE + "=; Path=/; HttpOnly; SameSite=Strict; Max-Age=0" + ("" if self.development else "; Secure")))
                    else:
                        fail(404, "Route unavailable.")
                body = json.dumps(result, ensure_ascii=False, allow_nan=False).encode()
            else:
                if method not in ("GET", "HEAD"):
                    fail(405, "Method not allowed.")
                if path.startswith("/game/"):
                    self.authorize(token)
                target = self.files.get("/index.html" if path == "/" else path)
                if target is None:
                    fail(404, "File unavailable.")
                content_type = {".wasm": "application/wasm", ".js": "text/javascript", ".swf": "application/x-shockwave-flash"}.get(target.suffix) or mimetypes.guess_type(target.name)[0] or "application/octet-stream"
                # Revalidate static game/art/runtime files. Authentication above
                # still runs before a protected asset can return 304. Account
                # data, HTML, scripts and version checks remain no-store.
                cacheable = path.startswith(("/game/", "/ruffle/"))
                stamp = (target.stat().st_mtime_ns, target.stat().st_size)
                metadata = self.file_etags.get(path)
                body = None
                if cacheable:
                    if metadata is None or metadata[0] != stamp:
                        body = target.read_bytes()
                        metadata = (stamp, '"' + hashlib.sha256(body).hexdigest() + '"')
                        self.file_etags[path] = metadata
                    cache_control = "private, no-cache"
                    extra.append(("ETag", metadata[1]))
                    if env.get("HTTP_IF_NONE_MATCH") in (metadata[1], "*"):
                        status, body = 304, b""
                if body is None:
                    body = target.read_bytes()
        except Problem as error:
            status, body = error.status, json.dumps({"error": error.message}, ensure_ascii=False).encode()
        except (ValueError, TypeError, UnicodeError, RecursionError):
            status, body = 400, b'{"error":"Invalid request."}'
        except Exception:
            status, body = 503, b'{"error":"The service is unavailable. Try again."}'
        headers = [("Content-Type", content_type), ("Content-Length", str(len(body))),
                   ("Cache-Control", cache_control if status in (200, 304) else "no-store"), ("X-Content-Type-Options", "nosniff"),
                   ("Referrer-Policy", "same-origin"), ("X-Frame-Options", "DENY"),
                   ("Content-Security-Policy", "default-src 'self'; script-src 'self' 'unsafe-eval' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob:; media-src 'self' blob:; connect-src 'self'; object-src 'none'; base-uri 'none'; frame-ancestors 'none'")]
        if not self.development:
            headers.append(("Strict-Transport-Security", "max-age=31536000"))
        if status == 304:
            headers = [(key, value) for key, value in headers if key != "Content-Length"]
        start_response(str(status) + " " + HTTPStatus(status).phrase, headers + extra)
        return [b"" if method == "HEAD" else body]
