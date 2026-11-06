"""Friend profile privacy and recommendation gifts through the authenticated API."""
import json,secrets,tempfile,unittest
from pathlib import Path
from server import Service,Problem
from web_app import SCHEMA

class SocialTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.path=Path(self.temp.name)/'test.sqlite3';self.service=Service(self.path)
        self.accounts=[self.service.request('POST','/register',{'username':n,'name':n,'password':'test-password'},open_registration=True) for n in ('alice','bob','charlie')]
        for a in self.accounts:
            team={'name':a['user']['name']+' club','accent':0x123456,'heroIndex':0,'players':[{'id':'p'+str(i),'name':'Player '+str(i),'power':50,'contact':50,'speed':50} for i in range(9)]}
            self.call(a,'/team',{'team':team})
        with self.service.connection() as db:db.executescript(SCHEMA)
    def tearDown(self):self.temp.cleanup()
    def call(self,a,path,data=None):
        return self.service.request('GET' if data is None else 'POST',path,None if data is None else dict(data,requestId=data.get('requestId',secrets.token_hex(16))),a['token'])
    def save(self,a,career):
        with self.service.connection() as db:db.execute('INSERT OR REPLACE INTO web_saves VALUES(?,1,?,NULL,0,?,?)',(a['user']['id'],json.dumps(career),secrets.token_hex(16),'test'))
    def connect(self):
        a,b,_=self.accounts;self.call(a,'/social/register',{'friend':b['user']['id'],'player':'p1'})
        self.call(b,'/social/accept',{'owner':a['user']['id'],'player':'p1'})
    def test_profiles_require_acceptance_and_expose_only_allowed_fields(self):
        a,b,c=self.accounts
        self.save(b,{'coins':999999,'password':'not-public','level':12,'roster':[{'accent':0x223344,'careerHits':3,'careerAtBats':8,'hr':2,'rbi':4,'appearance':{'hair':5,'eyes':3,'skinColor':2,'hairColor':8,'private':'never'}}]})
        self.call(a,'/social/register',{'friend':b['user']['id'],'player':'p1'})
        self.assertNotIn('profile',next(m for m in self.call(a,'/social')['members'] if m['id']==b['user']['id']))
        self.call(b,'/social/accept',{'owner':a['user']['id'],'player':'p1'})
        snapshot=self.call(a,'/social');friend=next(m for m in snapshot['members'] if m['id']==b['user']['id'])
        self.assertEqual(friend['profile'],{'level':12,'avg':375,'hr':2,'rbi':4,'accent':0x223344,'appearance':{'hair':5,'eyes':3,'skinColor':2,'hairColor':8},'heroReady':False})
        self.assertNotIn('profile',next(m for m in snapshot['members'] if m['id']==c['user']['id']))
        self.assertNotIn('not-public',json.dumps(snapshot));self.assertNotIn('coins',friend['profile'])
        self.call(a,'/social/remove',{'owner':a['user']['id'],'player':'p1'})
        self.assertNotIn('profile',next(m for m in self.call(a,'/social')['members'] if m['id']==b['user']['id']))
    def test_letters_daily_cap_receipts_ownership_and_restart(self):
        a,b,c=self.accounts
        with self.assertRaises(Problem):self.call(a,'/social/gift',{'friend':b['user']['id'],'kind':'letter'})
        self.connect();request={'friend':b['user']['id'],'kind':'letter','requestId':'letter-send-0001'}
        first=self.call(a,'/social/gift',request);self.assertEqual(first,self.call(a,'/social/gift',request))
        with self.assertRaises(Problem):self.call(a,'/social/gift',{'friend':b['user']['id'],'kind':'energy'})
        inbox=self.call(b,'/social');self.assertEqual(inbox['totals']['letter'],0);gift=inbox['gifts'][0]['id']
        with self.assertRaises(Problem):self.call(c,'/social/claim',{'gift':gift})
        self.call(b,'/social/claim',{'gift':gift});self.call(b,'/social/claim',{'gift':gift})
        self.service=Service(self.path);self.assertEqual(self.call(b,'/social')['totals']['letter'],1)
        with self.service.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM social_gifts').fetchone()[0],1)
    def test_extended_hair_colors_survive_published_friend_profile(self):
        a,b,_=self.accounts;self.connect()
        self.save(b,{'roster':[{'appearance':{'hair':2,'hairColor':19,'skinColor':4,'eyeColor':7}}]})
        self.service=Service(self.path)
        profile=next(m['profile'] for m in self.call(a,'/social')['members'] if m['id']==b['user']['id'])
        self.assertEqual(profile['appearance'],{'hair':2,'hairColor':19,'skinColor':4,'eyeColor':7})
    def test_creator_styles_and_gender_survive_friend_profiles_with_bounded_ids(self):
        a,b,_=self.accounts;self.connect()
        for gender in ('M','F'):
            for style in range(16):
                appearance={'artVersion':1,'avatarStyle':style,'gender':gender}
                self.save(b,{'password':'never-share','roster':[{'appearance':dict(appearance,private='never-share')}]})
                profile=next(m['profile'] for m in self.call(a,'/social')['members'] if m['id']==b['user']['id'])
                self.assertEqual(profile['appearance'],appearance)
                self.assertNotIn('never-share',json.dumps(profile))
        self.save(b,{'roster':[{'appearance':{'artVersion':999,'avatarStyle':999,'gender':'invalid'}}]})
        self.service=Service(self.path)
        profile=next(m['profile'] for m in self.call(a,'/social')['members'] if m['id']==b['user']['id'])
        self.assertEqual(profile['appearance'],{'artVersion':1,'avatarStyle':15})
    def test_malformed_legacy_profiles_do_not_break_friends(self):
        a,b,_=self.accounts;self.connect()
        for value in ({'roster':[]},{'roster':[None]},{'roster':'bad'},[],{'level':True,'roster':[{'hr':-5,'careerHits':float('nan'),'appearance':{'hair':900,'eyes':True}}]}):
            self.save(b,value);snapshot=self.call(a,'/social');p=next(m['profile'] for m in snapshot['members'] if m['id']==b['user']['id']);self.assertGreaterEqual(p['level'],1);self.assertEqual(p['hr'],0)

if __name__=='__main__':unittest.main()
