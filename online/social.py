"""Private account friendships and bounded gifts, with transactional receipts.

Only profile names, published teams and accepted friends' bounded career views
are shared. Visits never publish an exhibition lineup. No Facebook data.
Gift rewards are server-defined cumulative counters: lost/repeated responses cannot
produce a second grant when the client reconciles its saved counters.
"""
import json
import math
import secrets
import time

SCHEMA = """
CREATE TABLE IF NOT EXISTS account_friends(
 id TEXT PRIMARY KEY, a TEXT NOT NULL REFERENCES users(id),
 b TEXT NOT NULL REFERENCES users(id), requester TEXT NOT NULL REFERENCES users(id),
 status TEXT NOT NULL, created REAL NOT NULL, UNIQUE(a,b));
CREATE TABLE IF NOT EXISTS friend_links(
 owner TEXT NOT NULL REFERENCES users(id), player TEXT NOT NULL,
 friend TEXT NOT NULL REFERENCES users(id), status TEXT NOT NULL,
 created REAL NOT NULL, PRIMARY KEY(owner,player), UNIQUE(owner,friend));
CREATE TABLE IF NOT EXISTS social_gifts(
 id TEXT PRIMARY KEY, sender TEXT NOT NULL REFERENCES users(id),
 receiver TEXT NOT NULL REFERENCES users(id), day INTEGER NOT NULL,
 kind TEXT NOT NULL, claimed INTEGER NOT NULL DEFAULT 0, created REAL NOT NULL,
 UNIQUE(sender,receiver,day));
CREATE INDEX IF NOT EXISTS gifts_inbox ON social_gifts(receiver,created);
CREATE TABLE IF NOT EXISTS friend_visits(
 visitor TEXT NOT NULL REFERENCES users(id), friend TEXT NOT NULL REFERENCES users(id),
 day INTEGER NOT NULL, object TEXT NOT NULL, coins INTEGER NOT NULL, energy INTEGER NOT NULL,
 created REAL NOT NULL, PRIMARY KEY(visitor,friend,day,object));
CREATE INDEX IF NOT EXISTS visit_shares ON friend_visits(friend,object);
"""

class Social:
    def __init__(self, fail, text):
        self.fail, self.text = fail, text

    def connected(self, db, a, b):
        first,second=sorted((a,b))
        return db.execute("SELECT 1 FROM account_friends WHERE a=? AND b=? AND status='accepted'",(first,second)).fetchone() or db.execute("SELECT 1 FROM friend_links WHERE status='accepted' AND "
                          "((owner=? AND friend=?) OR (owner=? AND friend=?))",
                          (a,b,b,a)).fetchone() is not None

    def visit_totals(self, db, uid):
        own=db.execute('SELECT COALESCE(SUM(coins),0),COALESCE(SUM(energy),0) FROM friend_visits WHERE visitor=?',(uid,)).fetchone()
        shared=db.execute("SELECT COUNT(*) FROM friend_visits WHERE friend=? AND object='energy'",(uid,)).fetchone()[0]
        return {'coins':own[0],'energy':own[1]+shared}

    def visit_profile(self, db, uid, team):
        """Read only bounded cosmetic IDs; never return a career or item objects."""
        profile=self.public_profile(db,uid,team)
        profile.update(number=0,league=0,city='',equipment={},stadium={'equipped':{},'decorations':[]})
        if not db.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name='web_saves'").fetchone():return profile
        row=db.execute('SELECT data FROM web_saves WHERE user_id=?',(uid,)).fetchone()
        if not row:return profile
        try:
            career=json.loads(row[0])
            if not isinstance(career,dict):return profile
            def number(v,low,high,default=0):return max(low,min(high,v)) if type(v) in (int,float) and math.isfinite(v) else default
            def item_id(value):
                import re
                value=value.get('id') if isinstance(value,dict) else value
                return value if isinstance(value,str) and re.fullmatch(r'[A-Za-z0-9_-]{1,80}',value) else None
            profile['number']=int(number(career.get('uniformNumber'),0,99))
            profile['league']=int(number(career.get('leagueIndex'),0,4))
            city=career.get('teamCity','')
            if isinstance(city,str):profile['city']=city[:32]
            equipment=career.get('equipped',{})
            if isinstance(equipment,dict):
                for slot in ('bat','helmet','glove','belt','shoes','goggles'):
                    identifier=item_id(equipment.get(slot))
                    if identifier:profile['equipment'][slot]=identifier
            stadium=career.get('stadiumActive',{})
            if isinstance(stadium,dict):
                for slot in ('background','field','stand','scoreboard','fence','wall','banner','lights'):
                    identifier=item_id(stadium.get(slot))
                    if identifier:profile['stadium']['equipped'][slot]=identifier
            decorations=career.get('stadiumDecorations',[])
            if isinstance(decorations,list):
                for d in decorations[:40]:
                    if not isinstance(d,dict):continue
                    identifier=item_id(d.get('id'))
                    if identifier:profile['stadium']['decorations'].append({'id':identifier,'x':number(d.get('x'),0,960),'y':number(d.get('y'),0,720),'scale':number(d.get('scale'),.2,2.5,1)})
        except (ValueError,TypeError,KeyError,OverflowError):pass
        return profile

    def visit(self, db, uid, other):
        if uid==other or not self.connected(db,uid,other):self.fail(403,'Acepta primero la amistad para visitar su estadio.')
        row=db.execute('SELECT u.name,t.data FROM users u LEFT JOIN teams t ON u.id=t.user_id WHERE u.id=?',(other,)).fetchone()
        team=json.loads(row['data']) if row and row['data'] else self.saved_visit_team(db,other)
        if not row or not team:self.fail(409,'Tu amigo debe terminar de crear su personaje antes de recibir visitas.')
        day=int(time.time()//86400)
        claimed={r[0] for r in db.execute('SELECT object FROM friend_visits WHERE visitor=? AND friend=? AND day=?',(uid,other,day))}
        objects=[{'id':kind,'coins':0 if kind=='energy' else 20,'energy':1 if kind=='energy' else 0,'claimed':kind in claimed} for kind in ('glove','helmet','bat','ball','energy')]
        return {'id':other,'name':row['name'],'team':team,'profile':self.visit_profile(db,other,team),'day':day,'objects':objects}

    def saved_visit_team(self, db, uid):
        # A visit is a read-only view of an accepted friend's career. It never
        # publishes or replaces the lineup used for challenges or leagues.
        if not db.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name='web_saves'").fetchone():return None
        row=db.execute('SELECT data FROM web_saves WHERE user_id=?',(uid,)).fetchone()
        if not row:return None
        try:
            c=json.loads(row[0]);step=c.get('onboardingStep',0)
            if type(step) is not int or step<2:return None
            roster=c.get('roster',[])
            if not isinstance(roster,list) or not roster or not isinstance(roster[0],dict):return None
            players=[]
            for p in roster[:9]:
                if isinstance(p,dict) and isinstance(p.get('name'),str):players.append({'name':p['name'][:32]})
            if not players:return None
            name=c.get('teamName','My Club');accent=c.get('teamAccent',0x247ab2)
            return {'name':name[:28] if isinstance(name,str) else 'My Club','accent':accent if type(accent) is int and 0<=accent<=0xffffff else 0x247ab2,'heroIndex':0,'players':players}
        except (ValueError,TypeError,AttributeError,IndexError):return None

    def public_profile(self, db, uid, team):
        profile={'level':1,'avg':0,'hr':0,'rbi':0,'accent':team.get('accent',0x247ab2) if team else 0x247ab2,'appearance':{},'heroReady':False}
        if not db.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name='web_saves'").fetchone():
            return profile
        row=db.execute('SELECT data FROM web_saves WHERE user_id=?',(uid,)).fetchone()
        if not row:return profile
        try:
            career=json.loads(row[0])
            if not isinstance(career,dict):return profile
            roster=career.get('roster',[])
            hero=roster[0] if isinstance(roster,list) and roster and isinstance(roster[0],dict) else {}
            def count(v,limit):return max(0,min(limit,int(v))) if isinstance(v,(int,float)) and not isinstance(v,bool) and math.isfinite(v) else 0
            profile.update(level=max(1,count(career.get('level',1),10000)),hr=count(hero.get('hr',0),100000000),rbi=count(hero.get('rbi',0),100000000),accent=count(hero.get('accent',profile['accent']),0xffffff))
            profile['avg']=min(1000,round(1000*count(hero.get('careerHits',0),100000000)/max(1,count(hero.get('careerAtBats',0),100000000))))
            appearance=hero.get('appearance',{})
            # Only accepted friends (and self) receive this bounded public snapshot.
            # Wallets, inventory, tokens and the private career never leave this method.
            if type(career.get('onboardingStep')) is int and career['onboardingStep']>=2 and isinstance(appearance,dict) and appearance:
                profile['heroReady']=True
                profile['position']=hero.get('pos') if hero.get('pos') in ('P','C','1B','2B','3B','SS','LF','CF','RF','DH') else 'CF'
                profile['attributes']={key:max(1,count(hero.get(key,50),99)) for key in ('power','contact','speed','luck')}
            if isinstance(appearance,dict):
                for key in ('shape','hair','eyes','nose','mouth','etc','skinColor','hairColor','eyeColor','artVersion','avatarStyle'):
                    if key in appearance:profile['appearance'][key]=count(appearance[key],{'skinColor':4,'hairColor':19,'eyeColor':7,'artVersion':1,'avatarStyle':15}.get(key,7))
                if appearance.get('gender') in ('M','F'):profile['appearance']['gender']=appearance['gender']
        except (ValueError,TypeError,IndexError,KeyError,OverflowError):pass
        return profile

    def snapshot(self, db, uid):
        members=[]
        for row in db.execute("SELECT u.id,u.name,t.data FROM users u LEFT JOIN teams t ON u.id=t.user_id ORDER BY u.name"):
            team=json.loads(row['data']) if row['data'] else None
            connected=row['id']!=uid and self.connected(db,uid,row['id'])
            connected=bool(connected)
            if connected and team is None:team=self.saved_visit_team(db,row['id'])
            member={'id':row['id'],'name':row['name'],'team':team,'connected':connected}
            if connected or row['id']==uid:member['profile']=self.public_profile(db,row['id'],team)
            members.append(member)
        links=[dict(r) for r in db.execute("SELECT * FROM friend_links WHERE owner=? OR friend=?",(uid,uid))]
        requests=[{'id':r['id'],'requester':r['requester'],'receiver':r['b'] if r['requester']==r['a'] else r['a'],'status':r['status']} for r in db.execute('SELECT * FROM account_friends WHERE a=? OR b=?',(uid,uid))]
        # No limit on totals: old claims remain in the ledger, never expire/regrant.
        totals={kind:db.execute("SELECT COUNT(*) FROM social_gifts WHERE receiver=? AND claimed=1 AND kind=?",(uid,kind)).fetchone()[0]
                for kind in ('energy','key','letter')}
        gifts=[dict(r) for r in db.execute("SELECT g.*,u.name AS senderName FROM social_gifts g JOIN users u ON u.id=g.sender WHERE receiver=? ORDER BY claimed,created DESC LIMIT 100",(uid,))]
        sent=[dict(r) for r in db.execute("SELECT id,receiver,kind FROM social_gifts WHERE sender=? AND day=?",(uid,int(time.time()//86400)))]
        return {'members':members,'links':links,'requests':requests,'gifts':gifts,'sent':sent,'totals':totals,'visits':self.visit_totals(db,uid),'userId':uid,'giftsSent':db.execute('SELECT COUNT(*) FROM social_gifts WHERE sender=?',(uid,)).fetchone()[0], 'giftsReceived':totals['energy']+totals['key']+totals['letter']}

    def mutate(self, db, uid, path, data):
        if path=='/social/add':
            other=self.text(data,'friend',32,32)
            if uid==other:self.fail(400,'Esta es tu propia cuenta. Comparte tu enlace con un amigo.')
            if not db.execute('SELECT 1 FROM users WHERE id=?',(other,)).fetchone():self.fail(404,'No se encontró esa cuenta.')
            if not self.connected(db,uid,other):
                legacy=db.execute("SELECT * FROM friend_links WHERE status='pending' AND ((owner=? AND friend=?) OR (owner=? AND friend=?)) ORDER BY created LIMIT 1",(uid,other,other,uid)).fetchone()
                if legacy:
                    if legacy['owner']!=uid:db.execute("UPDATE friend_links SET status='accepted' WHERE owner=? AND player=?",(legacy['owner'],legacy['player']))
                    return self.snapshot(db,uid)
                first,second=sorted((uid,other));row=db.execute('SELECT * FROM account_friends WHERE a=? AND b=?',(first,second)).fetchone()
                if row:
                    # Each side explicitly chose ADD FRIEND: this is mutual consent.
                    if row['status']=='pending' and row['requester']!=uid:db.execute("UPDATE account_friends SET status='accepted' WHERE id=?",(row['id'],))
                else:db.execute('INSERT INTO account_friends VALUES(?,?,?,?,?,?)',(secrets.token_hex(16),first,second,uid,'pending',time.time()))
        elif path in ('/social/friend/accept','/social/friend/reject','/social/friend/cancel'):
            identifier=self.text(data,'friendship',32,32);row=db.execute('SELECT * FROM account_friends WHERE id=?',(identifier,)).fetchone()
            if not row or uid not in (row['a'],row['b']):self.fail(404,'Solicitud no disponible.')
            if path.endswith('/cancel'):
                if uid!=row['requester'] or row['status']!='pending':self.fail(409,'La solicitud ya se resolvió.')
                db.execute('DELETE FROM account_friends WHERE id=?',(identifier,))
            else:
                if uid==row['requester']:self.fail(403,'Solo tu amigo puede responder esta solicitud.')
                if path.endswith('/accept'):db.execute("UPDATE account_friends SET status='accepted' WHERE id=?",(identifier,))
                elif row['status']=='pending':db.execute('DELETE FROM account_friends WHERE id=?',(identifier,))
                else:self.fail(409,'La solicitud ya se aceptó.')
        elif path in ('/social/visit','/social/visit/claim'):
            other=self.text(data,'friend',32,32);visit=self.visit(db,uid,other)
            if path.endswith('/claim'):
                kind=self.text(data,'object',1,12)
                if kind not in ('glove','helmet','bat','ball','energy'):self.fail(400,'Objeto de visita desconocido.')
                day=data.get('day')
                if type(day) is not int or day!=visit['day']:self.fail(409,'Cambió el día de la visita. Actualiza para continuar.')
                # Twenty coins / one energy are visible in the video. Four drops,
                # daily reset and the host's shared energy are private-remake rules.
                visited=db.execute('SELECT COUNT(DISTINCT friend) FROM friend_visits WHERE visitor=? AND day=?',(uid,day)).fetchone()[0]
                exists=db.execute('SELECT 1 FROM friend_visits WHERE visitor=? AND friend=? AND day=?',(uid,other,day)).fetchone()
                if visited>=10 and not exists:self.fail(409,'Hoy ya recogiste premios en diez estadios. Vuelve mañana (UTC).')
                db.execute('INSERT OR IGNORE INTO friend_visits VALUES(?,?,?,?,?,?,?)',(uid,other,day,kind,0 if kind=='energy' else 20,1 if kind=='energy' else 0,time.time()))
                visit=self.visit(db,uid,other)
            result=self.snapshot(db,uid);result['visit']=visit;return result
        elif path=='/social/register':
            other=self.text(data,'friend',32,32);player=self.text(data,'player',1,60)
            if uid==other:self.fail(400,'Choose a friend\'s account.')
            if not db.execute('SELECT 1 FROM teams WHERE user_id=?',(other,)).fetchone():
                self.fail(409,'Your friend must publish their team first.')
            row=db.execute('SELECT data FROM teams WHERE user_id=?',(uid,)).fetchone()
            if not row:self.fail(409,'Publish your lineup before registering a friend.')
            team=json.loads(row[0]);allowed=[p['id'] for i,p in enumerate(team['players']) if i!=team['heroIndex']]
            if player not in allowed:self.fail(400,'Only a published regular batter can be linked.')
            existing=db.execute('SELECT * FROM friend_links WHERE owner=? AND (player=? OR friend=?)',(uid,player,other)).fetchone()
            if existing:self.fail(409,'That player or friend is already linked. Remove the link first.')
            db.execute('INSERT INTO friend_links VALUES(?,?,?,?,?)',(uid,player,other,'pending',time.time()))
        elif path in ('/social/accept','/social/reject','/social/remove'):
            owner=self.text(data,'owner',32,32);player=self.text(data,'player',1,60)
            row=db.execute('SELECT * FROM friend_links WHERE owner=? AND player=?',(owner,player)).fetchone()
            if not row or uid not in (row['owner'],row['friend']):self.fail(404,'Request unavailable.')
            if path=='/social/remove':
                db.execute('DELETE FROM friend_links WHERE owner=? AND player=?',(owner,player))
            else:
                if uid!=row['friend'] or row['status']!='pending':self.fail(409,'The request has already been resolved.')
                if path=='/social/accept':db.execute("UPDATE friend_links SET status='accepted' WHERE owner=? AND player=?",(owner,player))
                else:db.execute('DELETE FROM friend_links WHERE owner=? AND player=?',(owner,player))
        elif path=='/social/gift':
            other=self.text(data,'friend',32,32);kind=self.text(data,'kind',1,12)
            if kind not in ('energy','key','letter'):self.fail(400,'Gift unavailable.')
            if uid==other or not self.connected(db,uid,other):self.fail(403,'Register and accept your friend first.')
            day=int(time.time()//86400)
            if db.execute('SELECT 1 FROM social_gifts WHERE sender=? AND receiver=? AND day=?',(uid,other,day)).fetchone():
                self.fail(409,'You already sent this friend a gift today. Come back tomorrow (UTC).')
            if db.execute('SELECT COUNT(*) FROM social_gifts WHERE sender=? AND day=?',(uid,day)).fetchone()[0]>=10:
                self.fail(409,'You already sent your ten gifts today.')
            if db.execute('SELECT COUNT(*) FROM social_gifts WHERE receiver=? AND claimed=0',(other,)).fetchone()[0]>=100:
                self.fail(409,'Your friend\'s inbox is full.')
            db.execute('INSERT INTO social_gifts VALUES(?,?,?,?,?,0,?)',(secrets.token_hex(16),uid,other,day,kind,time.time()))
        elif path=='/social/claim':
            gift=self.text(data,'gift',32,32)
            row=db.execute('SELECT * FROM social_gifts WHERE id=? AND receiver=?',(gift,uid)).fetchone()
            if not row:self.fail(404,'Gift unavailable.')
            db.execute('UPDATE social_gifts SET claimed=1 WHERE id=?',(gift,))
        else:self.fail(404,'Ruta social desconocida.')
        return self.snapshot(db,uid)
