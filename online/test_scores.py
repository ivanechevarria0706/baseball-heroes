"""Ranking authorization, saved-result receipts and weekly boundaries."""
import json,secrets,tempfile,unittest
from pathlib import Path
from unittest.mock import patch
from server import Service,Problem
from web_app import SCHEMA

class ScoreTests(unittest.TestCase):
 def setUp(self):
  self.tmp=tempfile.TemporaryDirectory();self.path=Path(self.tmp.name)/'scores.sqlite3';self.s=Service(self.path)
  self.users=[self.s.request('POST','/register',{'username':n,'name':n,'password':'test-password'},open_registration=True) for n in ('alice','bob','charlie')]
  with self.s.connection() as db:db.executescript(SCHEMA)
  for a in self.users:self.call(a,'/team',{'team':{'name':a['user']['name'],'accent':0x123456,'heroIndex':0,'players':[{'id':'p'+str(i),'name':'Player '+str(i),'power':50,'contact':50,'speed':50} for i in range(9)]}})
 def tearDown(self):self.tmp.cleanup()
 def call(self,a,path,data=None):return self.s.request('GET' if data is None else 'POST',path,None if data is None else dict(data,requestId=secrets.token_hex(16)),a['token'])
 def save(self,a,data):
  with self.s.connection() as db:db.execute('INSERT OR REPLACE INTO web_saves VALUES(?,1,?,NULL,0,?,?)',(a['user']['id'],json.dumps(data),secrets.token_hex(16),'test'))
 def score(self,a,key,points):
  self.save(a,{'lastGameSummary':{'fixtureKey':key,'leagueIndex':0,'scoring':{'total':points}}});return self.call(a,'/scores',{'fixture':key,'points':9999999})
 def test_scores_derive_from_saved_summary_and_fixture_is_idempotent(self):
  a=self.users[0]
  with self.assertRaises(Problem):self.call(a,'/scores',{'fixture':'missing','points':900000})
  self.assertEqual(self.score(a,'0:1:12',320000)['best'],320000)
  self.save(a,{'lastGameSummary':{'fixtureKey':'0:1:12','scoring':{'total':999999}}})
  self.assertEqual(self.call(a,'/scores',{'fixture':'0:1:12'})['best'],320000)
  self.s=Service(self.path);self.assertEqual(self.call(a,'/scores')['best'],320000)
  with self.s.connection() as db:self.assertEqual(db.execute('SELECT COUNT(*) FROM score_results').fetchone()[0],1)
 def test_friend_acceptance_and_removal_limit_visibility(self):
  a,b,c=self.users;self.score(a,'a',100);self.score(b,'b',200);self.score(c,'c',300)
  self.call(a,'/social/register',{'friend':b['user']['id'],'player':'p1'})
  self.assertEqual(len(self.call(a,'/scores')['entries']),1)
  self.call(b,'/social/accept',{'owner':a['user']['id'],'player':'p1'})
  self.assertEqual({r['name'] for r in self.call(a,'/scores')['entries']},{'alice','bob'})
  self.call(a,'/social/remove',{'owner':a['user']['id'],'player':'p1'})
  self.assertEqual(len(self.call(a,'/scores')['entries']),1)
 def test_weekly_claims_cannot_repeat_or_claim_other_account(self):
  a,b,_=self.users
  with patch.object(self.s.scores,'period',return_value=('2026-W41',123)):
   self.score(a,'one',520000)
   for _ in range(2):self.assertEqual(self.call(a,'/scores/claim',{'target':300000})['rewardTotal'],1000)
   with self.assertRaises(Problem):self.call(b,'/scores/claim',{'target':300000,'user':a['user']['id']})
   with self.assertRaises(Problem):self.call(a,'/scores/claim',{'target':600000})
  with patch.object(self.s.scores,'period',return_value=('2026-W42',999)):
   state=self.call(a,'/scores');self.assertEqual(state['weeklyBest'],0);self.assertEqual(state['best'],520000);self.assertEqual(state['rewardTotal'],1000)
   self.score(a,'two',400000);self.assertEqual(self.call(a,'/scores/claim',{'target':300000})['rewardTotal'],2000)
 def test_malformed_and_postseason_summary(self):
  a=self.users[0]
  for bad in ([],{'lastGameSummary':[]},{'lastGameSummary':{'fixtureKey':'bad','scoring':{'total':True}}},{'lastGameSummary':{'fixtureKey':'bad','scoring':{'total':-1}}}):
   self.save(a,bad)
   with self.assertRaises(Problem):self.call(a,'/scores',{'fixture':'bad'})
  self.save(a,{'postSeason':{'lastResult':{'fixtureKey':'post:1','leagueIndex':2,'scoring':{'total':12345}}}})
  self.assertEqual(self.call(a,'/scores',{'fixture':'post:1'})['best'],12345)
 def test_old_receipt_keeps_paid_value_and_high_tiers_claim_once(self):
  a=self.users[0]
  with patch.object(self.s.scores,'period',return_value=('2026-W41',123)):
   self.score(a,'new-high',1200000)
   with self.s.connection() as db:
    db.execute('INSERT INTO score_claims VALUES(?,?,?,?)',(a['user']['id'],'2026-W41',300000,100))
   state=self.call(a,'/scores/claim',{'target':300000})
   self.assertEqual(state['rewardTotal'],100)
   old=next(t for t in state['tiers'] if t['target']==300000)
   self.assertEqual(old['paidCoins'],100);self.assertTrue(old['claimed']);self.assertFalse(old['eligible'])
   for _ in range(2):
    self.assertEqual(self.call(a,'/scores/claim',{'target':1200000})['rewardTotal'],40100)
   with self.assertRaises(Problem):self.call(self.users[1],'/scores/claim',{'target':1200000})

if __name__=='__main__':unittest.main()
