"""Start an isolated test server; no personal data or production database used."""
import json
from pathlib import Path
import secrets
import tempfile
from http.server import ThreadingHTTPServer
from server import Service, Handler


class LostResponseHandler(Handler):
    def reply(self, status, data):
        # Commit the first publication normally, then lose its response body.
        # The AIR UI must retry with the original request ID, not publish twice.
        if status == 200 and self.path == "/team" and self.server.drop_team_reply:
            self.server.drop_team_reply = False
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", "2")
            self.end_headers()
            self.wfile.write(b"{?")
            return
        super().reply(status, data)

root = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix="bh-online-qa-") as temporary:
    service = Service(Path(temporary)/"private.sqlite3")
    http = ThreadingHTTPServer(("127.0.0.1", 8766), LostResponseHandler)
    http.service = service
    http.drop_team_reply = True
    configuration = {"url": "http://127.0.0.1:8766", "invite": service.bootstrap(),
                     "password": secrets.token_urlsafe(18), "usernameA": "alice", "usernameB": "bob"}
    path = root/"build"/"qa"/"online064-config.json"
    path.write_text(json.dumps(configuration), encoding="utf-8")
    print("Isolated AIR QA server ready on 8766", flush=True)
    try:
        http.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        http.server_close()
        path.unlink(missing_ok=True)
