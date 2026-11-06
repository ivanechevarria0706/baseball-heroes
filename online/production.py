"""Single-process service behind Railway's HTTPS edge, with a mounted volume."""
from contextlib import closing
from datetime import datetime, timezone
import os
from pathlib import Path
import re
import sqlite3
import threading
import time

from http_app import Application
from server import Service, digest, fail


class PublicService(Service):
    def __init__(self, path):
        super().__init__(path)
        self.budgets = {}
        self.budget_lock = threading.Lock()

    def request(self, method, path, data, token="", peer="https", *, open_registration=False):
        if path != "/health":
            now = int(time.time() // 60)
            # Bounded global rates also limit attempts that rotate usernames/tokens.
            with self.budget_lock:
                category = "auth" if path in ("/login", "/register") else "api"
                limit = 60 if category == "auth" else 1200
                minute, count = self.budgets.get(category, (now, 0))
                count = count if minute == now else 0
                if count >= limit:
                    fail(429, "Too many requests. Wait one minute.")
                self.budgets[category] = (now, count + 1)
        return super().request(method, path, data, token, peer, open_registration=open_registration)


def initialize_invite(service, code):
    with service.lock, service.connection() as db:
        if db.execute("SELECT COUNT(*) FROM users").fetchone()[0]:
            return
        if not re.fullmatch(r"[A-Za-z0-9_-]{24,80}", code or ""):
            raise RuntimeError("An empty server requires a secret BH_BOOTSTRAP_INVITE (24-80 URL-safe characters).")
        # A restart must never reactivate an expired/consumed invitation.
        db.execute("INSERT INTO invites VALUES(?,?,NULL) ON CONFLICT(code) DO NOTHING",
                   (digest(code), time.time() + 72 * 3600))


def snapshot(service):
    folder = service.path.parent / "backups"
    folder.mkdir(exist_ok=True)
    name = "daily-" + datetime.now(timezone.utc).strftime("%Y-%m-%d") + ".sqlite3"
    target = folder / name
    if target.exists():
        return target
    temporary = target.with_suffix(".partial")
    with service.lock, service.connection() as source, closing(sqlite3.connect(temporary)) as destination:
        source.backup(destination)
        if destination.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
            raise RuntimeError("Backup integrity check failed.")
    temporary.replace(target)
    for previous in sorted(folder.glob("daily-????-??-??.sqlite3"))[:-7]:
        previous.unlink()
    return target


def build_application(environment=None):
    environment = os.environ if environment is None else environment
    directory = environment.get("RAILWAY_VOLUME_MOUNT_PATH") or environment.get("BH_DATA_DIR")
    if not directory or not Path(directory).is_absolute() or not Path(directory).is_dir():
        raise RuntimeError("A mounted persistent data directory is required before startup.")
    host = environment.get("RAILWAY_PUBLIC_DOMAIN") or environment.get("BH_PUBLIC_HOST")
    if not host:
        raise RuntimeError("Create the HTTPS domain or configure BH_PUBLIC_HOST before startup.")
    from release_reset import reset_once
    reset_once(Path(directory) / "private.sqlite3")
    service = PublicService(Path(directory) / "private.sqlite3")
    public = Path(__file__).resolve().parent / "web"
    browser_enabled = (public / "index.html").exists()
    if not browser_enabled:
        initialize_invite(service, environment.get("BH_BOOTSTRAP_INVITE"))
    api = Application(service, host, "healthcheck.railway.app")
    if browser_enabled:
        from web_app import WebApplication
        return WebApplication(api, public)
    return api


def make_http_server(app, host="0.0.0.0", port=8080):
    from waitress import create_server
    # Only Railway's HTTP edge may publish this port; do not add a public TCP proxy.
    return create_server(app, host=host, port=port, threads=4, connection_limit=64,
                         channel_timeout=15, cleanup_interval=5, backlog=64,
                         max_request_body_size=528384, max_request_header_size=8192,
                         trusted_proxy="*", trusted_proxy_count=1,
                         trusted_proxy_headers={"x-forwarded-proto"},
                         clear_untrusted_proxy_headers=True, ident="BHPrivate")


def main():
    app = build_application()
    snapshot(app.service)
    stopped = threading.Event()
    def backups():
        while not stopped.wait(3600):
            try:
                snapshot(app.service)
            except Exception:
                print("Backup failed; inspect volume capacity and permissions.", flush=True)
    thread = threading.Thread(target=backups, daemon=True)
    thread.start()
    server = make_http_server(app, port=int(os.environ.get("PORT", "8080")))
    print("Baseball Heroes service ready; browser accounts register without an invitation.", flush=True)
    try:
        server.run()
    finally:
        stopped.set()
        server.close()


if __name__ == "__main__":
    main()
