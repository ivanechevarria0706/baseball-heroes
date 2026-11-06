"""Real visit authorization, canonical cosmetics, receipts and daily claims."""
import json,sqlite3,secrets,tempfile,unittest
from pathlib import Path
from unittest.mock import patch
from server import Service,Problem
from web_app import SCHEMA

class VisitTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.path=Path(self.temp.name)/'test.sqlite3';self.service=Service(self.path)
        self.accounts=[self.service.request('POST','/register',{'username':n,'name':n,'password':'test-password'},open_registration=True) for n in ('alice','bob','charlie')]
        for a in self.accounts:
            team={'name':a['user']['name']+' club','accent':0x123456,'heroIndex':2,'players':[{'id':'p'+str(i),'name':'Player '+str(i),'power':50,'contact':50,'speed':50} for i in range(9)]}
            self.call(a,'/team',{'team':team})
        with self.service.connection() as db:db.executescript(SCHEMA)
    def tearDown(self):self.temp.cleanup()
    def call(self,a,path,data=None):return self.service.request('GET' if data is None else 'POST',path,None if data is None else dict(data,requestId=data.get('requestId',secrets.token_hex(16))),a['token'])
    def connect(self):
        a,b,_=self.accounts;self.call(a,'/social/register',{'friend':b['user']['id'],'player':'p0'});self.call(b,'/social/accept',{'owner':a['user']['id'],'player':'p0'})
    def visit(self,a=None):return self.call(a or self.accounts[0],'/social/visit',{'friend':self.accounts[1]['user']['id']})
    def claim(self,kind='glove',**kwargs):
        day=self.visit()['visit']['day'];return self.call(self.accounts[0],'/social/visit/claim',dict(friend=self.accounts[1]['user']['id'],day=day,object=kind,**kwargs))
    def test_requires_accepted_friend_and_cannot_visit_self(self):
        a,b,c=self.accounts
        with self.assertRaises(Problem):self.visit()
        self.call(a,'/social/register',{'friend':b['user']['id'],'player':'p0'})
        with self.assertRaises(Problem):self.visit()
        self.call(b,'/social/accept',{'owner':a['user']['id'],'player':'p0'})
        with self.assertRaises(Problem):self.visit(c)
        with self.assertRaises(Problem):self.call(a,'/social/visit',{'friend':a['user']['id']})
        self.assertEqual(len(self.visit()['visit']['objects']),5)
    def test_claim_is_once_even_with_different_receipts_and_restart(self):
        self.connect();one=self.claim(requestId='visit-receipt-1');self.assertEqual(one,self.claim(requestId='visit-receipt-1'))
        again=self.claim();self.assertEqual(again['visits']['coins'],20)
        self.service=Service(self.path);self.assertEqual(self.visit()['visits']['coins'],20)
        self.assertTrue(next(o for o in self.visit()['visit']['objects'] if o['id']=='glove')['claimed'])
        with self.service.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM friend_visits').fetchone()[0],1)
    def test_energy_is_shared_and_not_repeated(self):
        self.connect();self.claim('energy');self.claim('energy');a,b,_=self.accounts
        self.assertEqual(self.call(a,'/social')['visits'],{'coins':0,'energy':1})
        self.assertEqual(self.call(b,'/social')['visits'],{'coins':0,'energy':1})
        self.assertEqual(self.call(b,'/social')['totals']['energy'],0)
    def test_reset_utc_and_stale_day_requires_refresh(self):
        self.connect()
        with patch('social.time.time',return_value=200000):self.claim('ball')
        with patch('social.time.time',return_value=300000):
            state=self.visit();self.assertFalse(next(o for o in state['visit']['objects'] if o['id']=='ball')['claimed']);self.claim('ball')
            with self.assertRaises(Problem):self.call(self.accounts[0],'/social/visit/claim',{'friend':self.accounts[1]['user']['id'],'day':2,'object':'bat'})
        self.assertEqual(self.visit()['visits']['coins'],40)
    def test_unknown_object_and_removed_friend_cannot_collect(self):
        self.connect()
        with self.assertRaises(Problem):self.claim('gold')
        a,b,_=self.accounts;self.call(a,'/social/remove',{'owner':a['user']['id'],'player':'p0'})
        with self.assertRaises(Problem):self.claim()
    def test_ten_stadium_limit_allows_remaining_objects_in_existing_visit(self):
        self.connect();a,b,c=self.accounts
        others=[b,c]
        for i in range(9):
            user=self.service.request('POST','/register',{'username':'extra'+str(i),'name':'Extra '+str(i),'password':'test-password'},open_registration=True)
            self.call(user,'/team',{'team':{'name':'Extra club','accent':1,'heroIndex':0,'players':[{'id':'p'+str(n),'name':'Batter '+str(n),'power':20,'contact':20,'speed':20} for n in range(9)]}})
            others.append(user)
        for friend in others[1:]:
            self.call(friend,'/social/register',{'friend':a['user']['id'],'player':'p1'})
            self.call(a,'/social/accept',{'owner':friend['user']['id'],'player':'p1'})
        for friend in others[:10]:
            visit=self.call(a,'/social/visit',{'friend':friend['user']['id']})['visit']
            self.call(a,'/social/visit/claim',{'friend':friend['user']['id'],'day':visit['day'],'object':'ball'})
        last=self.call(a,'/social/visit',{'friend':others[10]['user']['id']})['visit']
        with self.assertRaises(Problem) as error:
            self.call(a,'/social/visit/claim',{'friend':last['id'],'day':last['day'],'object':'ball'})
        self.assertEqual(error.exception.status,409)
        self.assertEqual(self.claim('energy')['visits'],{'coins':200,'energy':1})
    def test_cosmetics_never_expose_private_items_or_save(self):
        self.connect();a,b,_=self.accounts
        save={'coins':999999,'secret':'never-share','level':12,'uniformNumber':42,'leagueIndex':2,'teamCity':'SEATTLE','equipped':{'bat':{'id':'classic_bat','secret':'never-share'},'helmet':{'id':'../../passwords'}},'stadiumActive':{'background':'stadium_background_city'},'stadiumDecorations':[{'id':'stadium_deco_flag','x':float('inf'),'y':5000,'scale':-5,'secret':'never-share'}],'roster':[{'appearance':{'hair':3,'hairColor':19,'skinColor':2}}]}
        with self.service.connection() as db:db.execute('INSERT INTO web_saves VALUES(?,1,?,NULL,0,?,?)',(b['user']['id'],json.dumps(save),secrets.token_hex(16),'test'))
        profile=self.visit()['visit']['profile'];self.assertEqual(profile['number'],42);self.assertEqual(profile['equipment'],{'bat':'classic_bat'});self.assertEqual(profile['stadium']['equipped']['background'],'stadium_background_city')
        self.assertEqual(profile['stadium']['decorations'][0],{'id':'stadium_deco_flag','x':0,'y':720,'scale':.2});self.assertNotIn('never-share',json.dumps(self.visit()));self.assertNotIn('coins',profile)
    def test_upgrade_database_3_creates_verified_backup_without_losing_claims(self):
        self.connect()
        with self.service.connection() as db:db.execute('DROP TABLE friend_visits');db.execute('PRAGMA user_version=3')
        self.service=Service(self.path);self.assertTrue(self.path.with_name('test.before-visits-v4.sqlite3').exists())
        with self.service.connection() as db:self.assertEqual(db.execute('PRAGMA user_version').fetchone()[0],4)
        self.assertEqual(self.claim()['visits']['coins'],20)

if __name__=='__main__':unittest.main()
