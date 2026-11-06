"""Account friendships require consent, not a published exhibition lineup."""
import json,secrets,tempfile,unittest
from pathlib import Path
from server import Service,Problem
from web_app import SCHEMA

class AccountFriendTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.path=Path(self.temp.name)/'friends.sqlite3';self.service=Service(self.path)
        self.a,self.b,self.c=[self.service.request('POST','/register',{'username':n,'name':n,'password':'test-password'},open_registration=True) for n in ('alice','bob','charlie')]
        with self.service.connection() as db:db.executescript(SCHEMA)
    def tearDown(self):self.temp.cleanup()
    def call(self,a,path,data=None):return self.service.request('GET' if data is None else 'POST',path,None if data is None else dict(data,requestId=data.get('requestId',secrets.token_hex(16))),a['token'])
    def request(self):return self.call(self.a,'/social/add',{'friend':self.b['user']['id']})['requests'][0]
    def accept(self):
        r=self.request();return self.call(self.b,'/social/friend/accept',{'friendship':r['id']})
    def save(self,a,career):
        with self.service.connection() as db:db.execute('INSERT OR REPLACE INTO web_saves VALUES(?,1,?,NULL,0,?,?)',(a['user']['id'],json.dumps(career),secrets.token_hex(16),'test'))
    def test_add_and_accept_without_teams_and_without_private_profile_before_consent(self):
        self.save(self.b,{'coins':8888,'level':2,'roster':[{'hr':7,'name':'Bob'}]})
        r=self.request();pending=self.call(self.a,'/social');m=next(m for m in pending['members'] if m['id']==self.b['user']['id'])
        self.assertFalse(m['connected']);self.assertNotIn('profile',m)
        self.assertEqual(r['receiver'],self.b['user']['id']);self.assertEqual(self.call(self.b,'/social')['requests'][0],r)
        self.call(self.b,'/social/friend/accept',{'friendship':r['id']});self.service=Service(self.path)
        for account,other in [(self.a,self.b),(self.b,self.a)]:
            m=next(m for m in self.call(account,'/social')['members'] if m['id']==other['user']['id']);self.assertTrue(m['connected']);self.assertIn('profile',m);self.assertNotIn('coins',m['profile'])
        with self.service.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM teams').fetchone()[0],0)
    def test_no_self_unknown_third_party_or_sender_acceptance(self):
        for other in [self.a['user']['id'],'f'*32]:
            with self.assertRaises(Problem):self.call(self.a,'/social/add',{'friend':other})
        r=self.request()
        for account in (self.a,self.c):
            with self.assertRaises(Problem):self.call(account,'/social/friend/accept',{'friendship':r['id']})
        with self.assertRaises(Problem):self.call(self.b,'/social/friend/cancel',{'friendship':r['id']})
    def test_repeats_and_cross_requests_form_one_consented_friendship(self):
        payload={'friend':self.b['user']['id'],'requestId':'retry-request-001'};first=self.call(self.a,'/social/add',payload);self.assertEqual(first,self.call(self.a,'/social/add',payload))
        self.call(self.a,'/social/add',{'friend':self.b['user']['id']});self.call(self.b,'/social/add',{'friend':self.a['user']['id']})
        with self.service.connection() as db:
            self.assertEqual(db.execute('SELECT COUNT(*) FROM account_friends').fetchone()[0],1);self.assertEqual(db.execute('SELECT status FROM account_friends').fetchone()[0],'accepted')
        self.call(self.a,'/social/add',{'friend':self.b['user']['id']})
        with self.service.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM account_friends').fetchone()[0],1)
    def test_reject_and_cancel_do_not_remove_other_requests(self):
        r=self.request();self.call(self.c,'/social/add',{'friend':self.b['user']['id']});self.call(self.b,'/social/friend/reject',{'friendship':r['id']})
        self.assertEqual(len(self.call(self.b,'/social')['requests']),1)
        r=self.request();self.call(self.a,'/social/friend/cancel',{'friendship':r['id']});self.assertEqual(len(self.call(self.b,'/social')['requests']),1)
    def test_gifts_and_visits_without_publishing_never_change_exhibition_teams(self):
        self.save(self.b,{'onboardingStep':3,'coins':900,'teamName':'Bob Club','teamAccent':0x123456,'roster':[{'name':'Bob','appearance':{'hair':2}}]})
        with self.assertRaises(Problem):self.call(self.a,'/social/visit',{'friend':self.b['user']['id']})
        self.accept();v=self.call(self.a,'/social/visit',{'friend':self.b['user']['id']})['visit'];self.assertEqual(v['team']['name'],'Bob Club');self.assertNotIn('coins',v['profile'])
        self.call(self.a,'/social/gift',{'friend':self.b['user']['id'],'kind':'energy'});gift=self.call(self.b,'/social')['gifts'][0]['id'];self.call(self.b,'/social/claim',{'gift':gift});self.call(self.b,'/social/claim',{'gift':gift});self.assertEqual(self.call(self.b,'/social')['totals']['energy'],1)
        self.call(self.a,'/social/visit/claim',{'friend':self.b['user']['id'],'day':v['day'],'object':'ball'});self.assertEqual(self.call(self.a,'/social')['visits']['coins'],20)
        with self.service.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM teams').fetchone()[0],0)
    def test_legacy_batter_links_stay_connected_without_new_rows(self):
        with self.service.connection() as db:db.execute('INSERT INTO friend_links VALUES(?,?,?,?,0)',(self.a['user']['id'],'p1',self.b['user']['id'],'accepted'))
        self.call(self.a,'/social/add',{'friend':self.b['user']['id']})
        with self.service.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM account_friends').fetchone()[0],0);self.assertEqual(db.execute('SELECT player FROM friend_links').fetchone()[0],'p1')
    def test_legacy_pending_requests_are_not_duplicated_by_quick_add(self):
        with self.service.connection() as db:db.execute('INSERT INTO friend_links VALUES(?,?,?,?,0)',(self.a['user']['id'],'p1',self.b['user']['id'],'pending'))
        self.call(self.a,'/social/add',{'friend':self.b['user']['id']});self.call(self.b,'/social/add',{'friend':self.a['user']['id']})
        with self.service.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM account_friends').fetchone()[0],0);self.assertEqual(db.execute('SELECT status FROM friend_links').fetchone()[0],'accepted')
    def test_recruitment_snapshot_is_bounded_consented_and_read_only(self):
        career={'onboardingStep':3,'level':7,'coins':8888,'roster':[{'name':'Bob','pos':'SS','power':67,'contact':500,'speed':-12,'luck':55,'careerHits':3,'careerAtBats':8,'appearance':{'artVersion':1,'avatarStyle':15,'hairColor':8,'private':'hidden'}}]}
        self.save(self.b,career)
        before=self.call(self.a,'/social');self.assertNotIn('profile',next(m for m in before['members'] if m['id']==self.b['user']['id']))
        self.accept()
        p=next(m['profile'] for m in self.call(self.a,'/social')['members'] if m['id']==self.b['user']['id'])
        self.assertTrue(p['heroReady']);self.assertEqual(p['attributes'],{'power':67,'contact':99,'speed':1,'luck':55});self.assertEqual(p['position'],'SS')
        self.assertEqual(p['appearance'],{'artVersion':1,'avatarStyle':15,'hairColor':8});self.assertNotIn('coins',p)
        with self.service.connection() as db:self.assertEqual(json.loads(db.execute('SELECT data FROM web_saves WHERE user_id=?',(self.b['user']['id'],)).fetchone()[0]),career)
        self.assertNotIn('profile',next(m for m in self.call(self.c,'/social')['members'] if m['id']==self.b['user']['id']))

if __name__=='__main__':unittest.main()
