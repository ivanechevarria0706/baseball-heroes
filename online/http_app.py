"""WSGI boundary for the private API behind a configured HTTPS gateway.

Storage and rules are injected so deployment does not change the AIR protocol.
The gateway/WSGI server must set wsgi.url_scheme from a trusted TLS connection;
this application never trusts arbitrary forwarded headers itself.
"""
from http import HTTPStatus
import json
import re
from server import MAX_BODY, Problem, fail


class Application:
    def __init__(self, service, public_host, healthcheck_host=None):
        if not re.fullmatch(r"[a-zA-Z0-9](?:[a-zA-Z0-9.-]*[a-zA-Z0-9])?", public_host):
            raise ValueError("Configure the exact public hostname, without a URL or wildcard.")
        self.service = service
        self.public_host = public_host.lower()
        self.healthcheck_host = healthcheck_host

    def __call__(self, environ, start_response):
        status = 200
        method = environ.get("REQUEST_METHOD", "")
        path = environ.get("PATH_INFO", "")
        try:
            host = environ.get("HTTP_HOST", "").lower()
            probe = (self.healthcheck_host is not None and host == self.healthcheck_host
                     and method in ("GET", "HEAD") and path == "/health")
            if not probe:
                if host not in (self.public_host, self.public_host + ":443"):
                    fail(403, "Unauthorized server.")
                if environ.get("wsgi.url_scheme") != "https":
                    fail(403, "An HTTPS connection is required.")
            if environ.get("HTTP_ORIGIN"):
                fail(403, "Use the game client for this operation.")
            if method not in ("GET", "POST", "HEAD") or (method == "HEAD" and path != "/health"):
                fail(405, "Method not allowed.")
            if environ.get("QUERY_STRING"):
                fail(400, "This API does not accept data in the URL.")
            size = int(environ.get("CONTENT_LENGTH") or "0")
            if not 0 <= size <= MAX_BODY:
                fail(413, "Request too large.")
            data = {}
            if method == "POST":
                content_type = environ.get("CONTENT_TYPE", "").split(";", 1)[0].strip().lower()
                if content_type != "application/json":
                    fail(415, "JSON required.")
                body = environ["wsgi.input"].read(size)
                if len(body) != size:
                    fail(400, "Incomplete request.")
                data = json.loads(body, parse_constant=lambda _: fail(400, "Invalid number."))
                if not isinstance(data, dict):
                    fail(400, "Invalid request.")
            authorization = environ.get("HTTP_AUTHORIZATION", "")
            token = authorization[7:] if authorization.startswith("Bearer ") else ""
            # Stable account-wide throttle behind gateways; do not trust spoofable X-Forwarded-For.
            result = self.service.request("GET" if method == "HEAD" else method, path, data, token, "https")
            if path == "/health":
                result = dict(result, development=False)
        except Problem as error:
            status, result = error.status, {"error": error.message}
        except (ValueError, TypeError, UnicodeError, RecursionError):
            status, result = 400, {"error": "Invalid request."}
        except Exception:
            # No payloads, authorization headers or connection strings in public errors/logs.
            status, result = 503, {"error": "The service is unavailable. Retry the same action."}
        body = json.dumps(result, ensure_ascii=False, allow_nan=False).encode("utf-8")
        headers = [("Content-Type", "application/json; charset=utf-8"),
                   ("Content-Length", str(len(body))), ("Cache-Control", "no-store"),
                   ("X-Content-Type-Options", "nosniff"),
                   ("Strict-Transport-Security", "max-age=31536000")]
        if status == 405:
            headers.append(("Allow", "GET, POST"))
        if status in (429, 503):
            headers.append(("Retry-After", "60"))
        start_response(str(status) + " " + HTTPStatus(status).phrase, headers)
        return [b"" if method == "HEAD" else body]
