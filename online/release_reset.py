"""One explicitly authorized reset, applied atomically before the service opens.

The marker lives in SQLite, so restarts and later releases never repeat it.
The old file is backed up privately; no old user/session/save remains active.
"""
from contextlib import closing
from pathlib import Path
import hashlib
import json
import re
import sqlite3
import time

RESET_ID = "release-1.0.38-2026-10-24"


def reset_once(path):
    path = Path(path).resolve()
    if path.name != "private.sqlite3" or not path.parent.is_dir():
        raise RuntimeError("Unexpected reset database target.")
    with closing(sqlite3.connect(path, timeout=30)) as db:
        db.execute("CREATE TABLE IF NOT EXISTS release_resets(id TEXT PRIMARY KEY, completed REAL NOT NULL, report TEXT NOT NULL)")
        db.commit()
        if db.execute("SELECT 1 FROM release_resets WHERE id=?", (RESET_ID,)).fetchone():
            return {"reset": False, "id": RESET_ID}
        tables = [r[0] for r in db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name<>'release_resets'")]
        if any(not re.fullmatch(r"[a-z_]+", name) for name in tables):
            raise RuntimeError("Unknown database table; reset stopped before deletion.")
        folder = path.parent / "backups"
        folder.mkdir(exist_ok=True)
        backup = folder / ("before-reset-1.0.38-" + str(int(time.time())) + ".sqlite3")
        with closing(sqlite3.connect(backup)) as copy:
            db.backup(copy)
            if copy.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
                raise RuntimeError("Reset backup failed integrity verification.")
        db.execute("PRAGMA foreign_keys=OFF")
        db.execute("PRAGMA secure_delete=ON")
        db.execute("BEGIN IMMEDIATE")
        # Another process may have completed this reset while the backup ran.
        if db.execute("SELECT 1 FROM release_resets WHERE id=?", (RESET_ID,)).fetchone():
            db.rollback()
            return {"reset": False, "id": RESET_ID}
        counts = {}
        for table in tables:
            counts[table] = db.execute('SELECT COUNT(*) FROM "' + table + '"').fetchone()[0]
            db.execute('DELETE FROM "' + table + '"')
        report = {"id": RESET_ID, "reset": True, "cleared": counts, "backup": backup.name,
                  "backupSha256": hashlib.sha256(backup.read_bytes()).hexdigest()}
        db.execute("INSERT INTO release_resets VALUES(?,?,?)", (RESET_ID, time.time(), json.dumps(report)))
        db.commit()
        if db.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
            raise RuntimeError("Reset database integrity verification failed.")
        db.execute("PRAGMA wal_checkpoint(TRUNCATE)")
        db.execute("VACUUM")
        return report
