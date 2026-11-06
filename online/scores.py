"""Private friend score board. Scores derive from saved summaries, not POST numbers.

Client careers remain trusted private-game data; this is not an anti-cheat service.
Weekly periods and milestone rewards are explicit remake rules.
"""
import json
import time
from datetime import datetime, timezone

SCHEMA="""
CREATE TABLE IF NOT EXISTS score_results(
 user_id TEXT NOT NULL REFERENCES users(id), fixture TEXT NOT NULL,
 points INTEGER NOT NULL, league INTEGER NOT NULL, week TEXT NOT NULL,
 created REAL NOT NULL, PRIMARY KEY(user_id,fixture));
CREATE INDEX IF NOT EXISTS scores_week ON score_results(week,points);
CREATE TABLE IF NOT EXISTS score_claims(
 user_id TEXT NOT NULL REFERENCES users(id), week TEXT NOT NULL,
 target INTEGER NOT NULL, coins INTEGER NOT NULL, PRIMARY KEY(user_id,week,target));
"""
TIERS=[(300000,1000),(400000,2000),(500000,3000),(600000,4000),(700000,5000),(800000,10000),(1000000,20000),(1100000,30000),(1200000,40000)]

class Scores:
    def __init__(self,fail,text,social):self.fail,self.text,self.social=fail,text,social
    def period(self):
        now=time.time();d=datetime.fromtimestamp(now,timezone.utc);iso=d.isocalendar()
        remaining=7*86400-((d.weekday()*86400)+d.hour*3600+d.minute*60+d.second)
        return f'{iso.year}-W{iso.week:02d}',remaining
    def snapshot(self,db,uid):
        week,remaining=self.period();entries=[]
        for row in db.execute('SELECT id,name FROM users ORDER BY name'):
            if row['id']!=uid and not self.social.connected(db,uid,row['id']):continue
            alltime=db.execute('SELECT MAX(points) FROM score_results WHERE user_id=?',(row['id'],)).fetchone()[0] or 0
            weekly=db.execute('SELECT MAX(points) FROM score_results WHERE user_id=? AND week=?',(row['id'],week)).fetchone()[0] or 0
            entries.append({'id':row['id'],'name':row['name'],'allTime':alltime,'weekly':weekly})
        own=next((e for e in entries if e['id']==uid),{'allTime':0,'weekly':0})
        paid={r[0]:r[1] for r in db.execute('SELECT target,coins FROM score_claims WHERE user_id=? AND week=?',(uid,week))};claimed=set(paid)
        total=db.execute('SELECT COALESCE(SUM(coins),0) FROM score_claims WHERE user_id=?',(uid,)).fetchone()[0]
        return {'week':week,'remaining':remaining,'entries':entries,'best':own['allTime'],'weeklyBest':own['weekly'],'rewardTotal':total,
                'tiers':[{'target':n,'coins':c,'claimed':n in claimed,'paidCoins':paid.get(n,0),'eligible':own['weekly']>=n and n not in claimed} for n,c in TIERS]}
    def mutate(self,db,uid,path,data):
        week,_=self.period()
        if path=='/scores':
            fixture=self.text(data,'fixture',1,100)
            if not db.execute('SELECT 1 FROM score_results WHERE user_id=? AND fixture=?',(uid,fixture)).fetchone():
                exists=db.execute("SELECT 1 FROM sqlite_master WHERE name='web_saves'").fetchone()
                row=db.execute('SELECT data FROM web_saves WHERE user_id=?',(uid,)).fetchone() if exists else None
                saved=json.loads(row[0]) if row else {}
                if not isinstance(saved,dict):saved={}
                post=saved.get('postSeason') if isinstance(saved.get('postSeason'),dict) else {}
                summaries=[saved.get('lastGameSummary'),post.get('lastResult')]
                summary=next((s for s in summaries if isinstance(s,dict) and s.get('fixtureKey')==fixture),None)
                scoring=summary.get('scoring') if summary else None
                points=scoring.get('total') if isinstance(scoring,dict) else None
                if type(points) is not int or not 0<=points<=10000000:self.fail(409,'Save the game result before publishing it.')
                league=summary.get('leagueIndex',0)
                if type(league) is not int or not 0<=league<=4:self.fail(400,'Invalid league.')
                db.execute('INSERT INTO score_results VALUES(?,?,?,?,?,?)',(uid,fixture,points,league,week,time.time()))
        elif path=='/scores/claim':
            target=data.get('target');tier=next((c for n,c in TIERS if type(target) is int and n==target),None)
            if tier is None:self.fail(400,'Score unavailable.')
            best=db.execute('SELECT MAX(points) FROM score_results WHERE user_id=? AND week=?',(uid,week)).fetchone()[0] or 0
            if best<target:self.fail(409,'You have not reached this weekly score yet.')
            db.execute('INSERT OR IGNORE INTO score_claims VALUES(?,?,?,?)',(uid,week,target,tier))
        else:self.fail(404,'Ruta desconocida.')
        return self.snapshot(db,uid)
