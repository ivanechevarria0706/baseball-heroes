from contextlib import closing
import json
from pathlib import Path
import sqlite3
import tempfile
import unittest
from production import PublicService
from server import Problem
from release_reset import reset_once, RESET_ID
from web_app import SCHEMA as WEB_SCHEMA


class ReleaseResetTests(unittest.TestCase):
    def test_reset_revokes_old_sessions_and_cannot_repeat_after_new_registration(self):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / 'private.sqlite3'
            service = PublicService(path)
            alice = service.request('POST', '/register', {'username':'oldalice','name':'Old Alice','password':'test-password'}, open_registration=True)
            bob = service.request('POST', '/register', {'username':'oldbob','name':'Old Bob','password':'test-password'}, open_registration=True)
            with service.connection() as db:
                db.executescript(WEB_SCHEMA)
                db.execute('INSERT INTO web_saves VALUES(?,?,?,?,?,?,?)', (alice['user']['id'],3,json.dumps({'level':99}),None,1,'old-request','old-fingerprint'))
            result = reset_once(path)
            self.assertTrue(result['reset'])
            self.assertEqual(result['cleared']['users'],2)
            self.assertEqual(result['cleared']['web_saves'],1)
            with closing(sqlite3.connect(path.parent/'backups'/result['backup'])) as db:
                self.assertEqual(db.execute('SELECT COUNT(*) FROM users').fetchone()[0],2)
                self.assertEqual(db.execute('PRAGMA integrity_check').fetchone()[0],'ok')
            for account in (alice,bob):
                with self.assertRaises(Problem):service.request('GET','/lobby',{},account['token'])
            with self.assertRaises(Problem):service.request('POST','/login',{'username':'oldalice','password':'test-password'})
            with service.connection() as db:
                for name in result['cleared']:self.assertEqual(db.execute('SELECT COUNT(*) FROM "'+name+'"').fetchone()[0],0,name)
                self.assertEqual(db.execute('SELECT id FROM release_resets').fetchone()[0],RESET_ID)
                self.assertEqual(db.execute('PRAGMA foreign_key_check').fetchall(),[])
            fresh = service.request('POST','/register',{'username':'oldalice','name':'New Hero','password':'fresh-password'},open_registration=True)
            self.assertNotEqual(fresh['user']['id'],alice['user']['id'])
            self.assertFalse(reset_once(path)['reset'])
            self.assertEqual(service.request('GET','/lobby',{},fresh['token'])['user']['id'],fresh['user']['id'])

    def test_unexpected_path_is_rejected(self):
        with tempfile.TemporaryDirectory() as folder:
            path=Path(folder)/'other.sqlite3'
            with self.assertRaises(RuntimeError):reset_once(path)
            self.assertFalse(path.exists())
