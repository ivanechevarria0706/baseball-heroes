import concurrent.futures
from contextlib import closing
import json
import secrets
import sqlite3
import unittest
import test_server
from leagues import schedule, standings
from server import Service


class LeagueTest(unittest.TestCase):
    setUp = test_server.PrivateServerTest.setUp
    tearDown = test_server.PrivateServerTest.tearDown
    start = test_server.PrivateServerTest.start
    stop = test_server.PrivateServerTest.stop
    call = test_server.PrivateServerTest.call
    register = test_server.PrivateServerTest.register

    def league(self, others=None):
        status, league = self.call('POST', '/leagues', {'name': 'Liga de Amigos'}, self.a)
        self.assertEqual(status, 200, league)
        for person in others or [self.b]:
            status, joined = self.call('POST', '/leagues/'+league['id']+'/join', {}, person)
            self.assertEqual(status, 200, joined)
        return league['id']

    def test_schedule_2_through_8_and_ties(self):
        for n in range(2, 9):
            ids = list(range(n)); fixtures = schedule(ids)
            self.assertEqual(len(fixtures), n*(n-1))
            self.assertEqual({(h,a) for _,h,a in fixtures}, {(h,a) for h in ids for a in ids if h!=a})
            for r in {f[0] for f in fixtures}:
                players = [p for round_number,h,a in fixtures if round_number == r for p in (h,a)]
                self.assertEqual(len(set(players)), len(players))
        members = [{'id': i, 'name': str(i), 'teamName': 'Club '+str(i)} for i in range(3)]
        games = [{'homeId': 0, 'awayId': 1, 'status': 'complete', 'home': 2, 'away': 2},
                 {'homeId': 1, 'awayId': 2, 'status': 'playing', 'home': 20, 'away': 0}]
        table = standings(members, games)
        self.assertEqual([r['rank'] for r in table], [1,1,3])
        self.assertEqual([r['pct'] for r in table], ['0.500','0.500','—'])
        self.assertEqual(sum(r['played'] for r in table), 2)

    def test_lifecycle_permissions_concurrency_freeze_and_completion(self):
        outsider = self.register('outsider')
        lid = self.league()
        path = '/leagues/'+lid
        self.assertEqual(self.call('GET',path,account=outsider)[0],404)
        self.assertEqual(self.call('POST',path+'/start',{},self.b)[0],403)
        request = {'requestId': secrets.token_hex(16)}
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            results = list(pool.map(lambda _: self.call('POST',path+'/start',request,self.a),range(2)))
        self.assertEqual(results[0],results[1])
        league = results[0][1]
        self.assertEqual(len(league['fixtures']),2)
        self.assertEqual(self.call('POST',path+'/join',{},outsider)[0],409)
        self.assertEqual(self.call('POST',path+'/leave',{},self.b)[0],409)
        self.call('POST','/team',{'team':test_server.team('Changed after start')},self.b)
        first = next(f for f in league['fixtures'] if f['homeId']==self.a['user']['id'])
        fp = path+'/fixtures/'+first['id']+'/play'
        self.assertEqual(self.call('POST',fp,{},self.b)[0],403)
        request = {'requestId':secrets.token_hex(16)}
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            games = list(pool.map(lambda _:self.call('POST',fp,request,self.a),range(2)))
        self.assertEqual(games[0],games[1])
        match = games[0][1]
        self.assertEqual(match['awayTeam']['name'],'Bob Club')
        self.assertEqual(match['league']['id'],lid)
        self.assertEqual(self.call('POST',fp,{},self.a)[1]['id'],match['id'])
        mp = '/matches/'+match['id']
        self.assertEqual(self.call('POST',mp+'/cancel',{'revision':0},self.a)[0],409)
        self.stop(); self.service=Service(self.db); self.start()
        self.assertEqual(self.call('GET',mp,account=self.b)[1],match)
        for _ in range(400):
            if match['state']['status']=='complete':break
            status,match=self.call('POST',mp+'/auto',{'revision':match['revision']},self.a)
            self.assertEqual(status,200,match)
        self.assertEqual(match['state']['status'],'complete')
        current=self.call('GET',path,account=self.a)[1]
        self.assertEqual(current['completed'],1)
        self.assertEqual(sum(r['played'] for r in current['standings']),2)
        self.assertEqual(self.call('GET',path,account=self.b)[1],current)
        second=next(f for f in current['fixtures'] if f['homeId']==self.b['user']['id'])
        status,other=self.call('POST',path+'/fixtures/'+second['id']+'/play',{},self.b)
        self.assertEqual(status,200,other)
        request={'requestId':secrets.token_hex(16),'revision':other['revision']}
        endpoint='/matches/'+other['id']+'/forfeit'
        status,res=self.call('POST',endpoint,request,self.b)
        self.assertEqual(status,200,res)
        self.assertEqual((res['state']['home'],res['state']['away']),(0,9))
        self.assertEqual(self.call('POST',endpoint,request,self.b)[1],res)
        finished=self.call('GET',path,account=self.a)[1]
        self.assertEqual(finished['status'],'complete')
        self.assertEqual(finished['completed'],2)
        self.assertEqual(sum(r['played'] for r in finished['standings']),4)
        self.assertTrue(finished['champions'])
        self.assertEqual(self.call('GET',path,account=self.b)[1],finished)
        with self.service.connection() as db:
            self.assertEqual(db.execute('SELECT COUNT(*) FROM fixtures WHERE league_id=?',(lid,)).fetchone()[0],2)

    def test_six_players_shared_schedule_and_spectator(self):
        accounts=[self.a,self.b]
        for i in range(4):
            account=self.register('friend'+str(i));accounts.append(account)
            self.call('POST','/team',{'team':test_server.team('Club '+str(i))},account)
        lid=self.league(accounts[1:]);path='/leagues/'+lid
        status,data=self.call('POST',path+'/start',{},self.a)
        self.assertEqual(status,200,data)
        self.assertEqual(len(data['fixtures']),30)
        self.assertEqual(data['rounds'],10)
        for account in accounts:
            self.assertEqual(sum(f['homeId']==account['user']['id'] for f in data['fixtures']),5)
            self.assertEqual(self.call('GET',path,account=account)[1],data)
        fixture=next(f for f in data['fixtures'] if f['homeId']==self.a['user']['id'] and f['awayId']==self.b['user']['id'])
        match=self.call('POST',path+'/fixtures/'+fixture['id']+'/play',{},self.a)[1]
        spectator=accounts[2]
        self.assertEqual(self.call('GET','/matches/'+match['id'],account=spectator)[0],200)
        self.assertEqual(self.call('POST','/matches/'+match['id']+'/auto',{'revision':0},spectator)[0],403)

    def test_enrollment_and_version_one_migration(self):
        status,league=self.call('POST','/leagues',{'name':'Liga Migrada'},self.a)
        path='/leagues/'+league['id']
        self.assertEqual(self.call('POST',path+'/start',{},self.a)[0],409)
        self.call('POST',path+'/join',{},self.b)
        self.call('POST',path+'/leave',{},self.b)
        self.assertEqual(self.call('GET',path,account=self.b)[0],404)
        self.assertEqual(self.call('POST',path+'/leave',{},self.a)[0],409)
        self.assertEqual(self.call('POST',path+'/cancel',{},self.a)[1]['status'],'cancelled')
        status, legacy_match=self.call('POST','/matches',{'opponent':self.b['user']['id']},self.a)
        self.assertEqual(status,200,legacy_match)
        # Build an actual v1 database from the existing user/session/team rows.
        legacy=self.db.with_name('legacy.sqlite3')
        with self.service.connection() as db:
            copy=sqlite3.connect(legacy)
            db.backup(copy);copy.execute('DROP TABLE fixtures');copy.execute('DROP TABLE league_members');copy.execute('DROP TABLE leagues');copy.execute('PRAGMA user_version=1');copy.commit();copy.close()
        migrated=Service(legacy)
        backup=legacy.with_name('legacy.before-leagues-v2.sqlite3')
        self.assertTrue(backup.exists())
        with migrated.connection() as db:
            self.assertEqual(db.execute('PRAGMA user_version').fetchone()[0],4)
            self.assertEqual(db.execute('SELECT COUNT(*) FROM users').fetchone()[0],2)
        with closing(sqlite3.connect(backup)) as db:
            self.assertEqual(db.execute('PRAGMA user_version').fetchone()[0],1)
        result=migrated.request('GET','/lobby',{},self.a['token'])
        self.assertEqual(result['user']['id'],self.a['user']['id'])
        self.assertEqual(len(result['members']),2)
        self.assertEqual(migrated.request('GET','/matches/'+legacy_match['id'],{},self.a['token']),legacy_match)
        future=self.db.with_name('future.sqlite3')
        with closing(sqlite3.connect(future)) as db:
            db.execute('PRAGMA user_version=5')
        with self.assertRaises(RuntimeError):
            Service(future)
        with closing(sqlite3.connect(future)) as db:
            self.assertEqual(db.execute('PRAGMA user_version').fetchone()[0],5)


if __name__=='__main__':
    unittest.main(verbosity=2)
