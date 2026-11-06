import io,json,tempfile,unittest
from pathlib import Path
from http_app import Application
from production import PublicService
from web_app import WebApplication,COOKIE

class BrowserTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory();self.root=Path(self.temp.name)
        public=self.root/'public';(public/'game').mkdir(parents=True)
        (public/'index.html').write_text('<h1>Club</h1>');(public/'game/main.swf').write_bytes(b'game')
        (public/'amigos.html').write_text('<h1>Friend guide</h1>')
        (public/'startup.js').write_text('window.loaderReady=true;')
        (public/'recovery.js').write_text('window.backupReady=true;')
        (public/'game-cache.js').write_text('window.cacheReady=true;')
        self.service=PublicService(self.root/'test.sqlite3')
        self.app=WebApplication(Application(self.service,'club.test'),public)
        self.accounts=[]
        for name in ('alice','bruno'):
            self.accounts.append(self.service.request('POST','/register',{'username':name,'name':name,'password':'test-password','invite':self.service.bootstrap()}))
        self.cookie=COOKIE+'='+self.accounts[0]['token']
    def tearDown(self):self.temp.cleanup()
    def call(self,path,method='GET',body=None,cookie=None,origin='https://club.test',host='club.test',fetch_site=None,etag=None,account=None):
        raw=json.dumps(body).encode() if body is not None else b''
        env={'PATH_INFO':path,'REQUEST_METHOD':method,'HTTP_HOST':host,'wsgi.url_scheme':'https','wsgi.input':io.BytesIO(raw),'CONTENT_LENGTH':str(len(raw)),'CONTENT_TYPE':'application/json','HTTP_COOKIE':cookie or '', 'QUERY_STRING':''}
        if origin is not None:env['HTTP_ORIGIN']=origin
        if fetch_site is not None:env['HTTP_SEC_FETCH_SITE']=fetch_site
        if etag is not None:env['HTTP_IF_NONE_MATCH']=etag
        if account is not None:env['HTTP_X_BH_ACCOUNT']=account
        seen=[];response=b''.join(self.app(env,lambda status,headers:seen.append((status,dict(headers)))))
        return int(seen[0][0][:3]),seen[0][1],response
    def save_body(self,rev=0,id='request_0001',name='Team'):
        return {'revision':rev,'requestId':id,'data':{'version':21,'roster':[{'name':'Player'}],'teamName':name}}
    def test_login_cookie_and_private_assets(self):
        guide=self.call('/amigos.html',origin=None)
        self.assertEqual(guide[0],200);self.assertIn(b'Friend guide',guide[2])
        self.assertEqual(self.call('/amigos.html',origin=None,fetch_site='cross-site')[0],200)
        self.assertEqual(self.call('/',origin=None,fetch_site='cross-site')[0],200)
        self.assertEqual(self.call('/web/session',origin=None,fetch_site='cross-site',cookie=self.cookie)[0],403)
        code,headers,body=self.call('/web/login','POST',{'username':'alice','password':'test-password'})
        self.assertEqual(code,200);self.assertNotIn('token',json.loads(body))
        self.assertIn('HttpOnly',headers['Set-Cookie']);self.assertIn('Secure',headers['Set-Cookie']);self.assertIn('SameSite=Strict',headers['Set-Cookie'])
        self.assertEqual(self.call('/game/main.swf')[0],401)
        self.assertEqual(self.call('/game/main.swf',cookie=self.cookie)[0],200)
        self.assertEqual(self.call('/game/../test.sqlite3',cookie=self.cookie)[0],404)
    def test_csrf_origin_and_host(self):
        for origin in ('https://evil.test',None,'null'):
            self.assertEqual(self.call('/web/save','POST',self.save_body(),self.cookie,origin)[0],403)
        self.assertEqual(self.call('/web/session',cookie=self.cookie,host='evil.test')[0],403)
        self.assertEqual(self.call('/web/session',cookie=self.cookie)[0],200)
    def test_public_loader_does_not_expose_private_game(self):
        code,headers,body=self.call('/startup.js',origin=None)
        self.assertEqual(code,200);self.assertEqual(body,b'window.loaderReady=true;')
        self.assertEqual(headers['Cache-Control'],'no-store');self.assertIn('javascript',headers['Content-Type'])
        self.assertEqual(self.call('/startup.js',method='HEAD',origin=None)[2],b'')
        self.assertEqual(self.call('/game/main.swf',origin=None)[0],401)
        self.assertEqual(self.call('/web/save',origin=None)[0],401)
    def test_save_conflicts_retry_and_account_isolation(self):
        body=self.save_body();self.assertEqual(self.call('/web/save','POST',body,self.cookie)[0],200)
        self.assertEqual(json.loads(self.call('/web/save','POST',body,self.cookie)[2])['revision'],1)
        self.assertEqual(self.call('/web/save','POST',self.save_body(id='request_0002'),self.cookie)[0],409)
        self.assertEqual(self.call('/web/save','POST',self.save_body(name='Different'),self.cookie)[0],409)
        self.assertEqual(self.call('/web/save','POST',self.save_body(1,'request_0002','New'),self.cookie)[0],200)
        other=COOKIE+'='+self.accounts[1]['token']
        self.assertIsNone(json.loads(self.call('/web/save',cookie=other)[2])['data'])
        with self.service.connection() as db:
            row=db.execute('SELECT * FROM web_saves').fetchone();self.assertEqual(json.loads(row['previous'])['teamName'],'Team')
        reopened=WebApplication(Application(PublicService(self.service.path),'club.test'),self.root/'public')
        self.app=reopened;self.assertEqual(json.loads(self.call('/web/save',cookie=self.cookie)[2])['data']['teamName'],'New')
    def test_recovery_script_is_public_but_saves_are_private(self):
        code,headers,body=self.call('/recovery.js',origin=None)
        self.assertEqual(code,200);self.assertEqual(body,b'window.backupReady=true;')
        self.assertEqual(headers['Cache-Control'],'no-store');self.assertIn('javascript',headers['Content-Type'])
        self.assertEqual(self.call('/recovery.js',method='HEAD',origin=None)[2],b'')
        self.assertEqual(self.call('/web/save',account=self.accounts[0]['user']['id'])[0],401)
        self.assertEqual(self.call('/game-cache.js',origin=None)[0],200)
        self.assertEqual(self.call('/game/main.swf',method='HEAD',origin=None)[0],401)
    def test_changed_cookie_cannot_save_another_tabs_career(self):
        alice=self.accounts[0]['user']['id'];bruno=self.accounts[1]['user']['id']
        other=COOKIE+'='+self.accounts[1]['token']
        self.assertEqual(self.call('/web/save','POST',self.save_body(),self.cookie,account=alice)[0],200)
        self.assertEqual(self.call('/web/save',cookie=other,account=alice)[0],409)
        self.assertEqual(self.call('/web/save','POST',self.save_body(),other,account=alice)[0],409)
        self.assertEqual(self.call('/web/api/logout','POST',{'requestId':'wrong_account'},other,account=alice)[0],409)
        self.assertIsNone(json.loads(self.call('/web/save',cookie=other,account=bruno)[2])['data'])
        self.assertEqual(json.loads(self.call('/web/save',cookie=self.cookie,account=alice)[2])['revision'],1)
    def test_account_header_preserves_existing_save_receipts_and_login(self):
        alice=self.accounts[0]['user']['id'];body=self.save_body()
        self.assertEqual(self.call('/web/save','POST',body,self.cookie)[0],200)
        replay=self.call('/web/save','POST',body,self.cookie,account=alice)
        self.assertEqual(replay[0],200);self.assertEqual(json.loads(replay[2])['revision'],1)
        self.assertEqual(self.call('/web/login','POST',{'username':'bruno','password':'test-password'},account=alice)[0],200)
        self.assertEqual(self.call('/web/register','POST',{'username':'third','name':'Third','password':'test-password'},account=alice)[0],200)
    def test_invalid_save_and_logout(self):
        body=self.save_body();body['data']['version']=25
        self.assertEqual(self.call('/web/save','POST',body,self.cookie)[0],400)
        body=self.save_body();body['data']['__proto__']={}
        self.assertEqual(self.call('/web/save','POST',body,self.cookie)[0],400)
        self.assertEqual(self.call('/web/api/logout','POST',{'requestId':'logout_0001'},self.cookie)[0],200)
        self.assertEqual(self.call('/web/session',cookie=self.cookie)[0],401)

    def test_revocation_between_route_and_save_cannot_write(self):
        original=self.app.authorize
        def revoked(token):
            user=original(token)
            with self.service.connection() as db:
                db.execute('DELETE FROM sessions WHERE user_id=?',(user['id'],))
            return user
        self.app.authorize=revoked
        self.assertEqual(self.call('/web/save','POST',self.save_body(),self.cookie)[0],401)
        with self.service.connection() as db:
            self.assertEqual(db.execute('SELECT COUNT(*) FROM web_saves').fetchone()[0],0)
    def test_tutorial_save_upgrade_and_downgrade_protection(self):
        legacy=self.save_body()
        self.assertEqual(self.call('/web/save','POST',legacy,self.cookie)[0],200)
        upgraded=self.save_body(rev=1,id='tutorial_0022')
        upgraded['data'].update(version=22,starterTutorial={'version':1,'stage':8,'claimed':False},coins=6000)
        self.assertEqual(self.call('/web/save','POST',upgraded,self.cookie)[0],200)
        self.assertEqual(self.call('/web/save','POST',upgraded,self.cookie)[0],200)
        stale=self.save_body(rev=2,id='old_client_21')
        self.assertEqual(self.call('/web/save','POST',stale,self.cookie)[0],409)
        stored=json.loads(self.call('/web/save',cookie=self.cookie)[2])
        self.assertEqual(stored['revision'],2)
        self.assertEqual(stored['data'],upgraded['data'])
    def test_initial_lesson_v24_preserves_progress_and_blocks_old_tabs(self):
        old=self.save_body();old['data'].update(version=23,coins=45678,xp=79,level=2,careerStartVersion=3)
        self.assertEqual(self.call('/web/save','POST',old,self.cookie)[0],200)
        current=self.save_body(rev=1,id='initial_0024');current['data'].update(old['data'])
        current['data'].update(version=24,friendDraft=['friend-a'],starterTutorial={'version':2,'lesson':1,'stage':9,'claimed':True})
        self.assertEqual(self.call('/web/save','POST',current,self.cookie)[0],200)
        self.assertEqual(self.call('/web/save','POST',current,self.cookie)[0],200)
        stale=self.save_body(rev=2,id='stale_0023');stale['data'].update(old['data'])
        self.assertEqual(self.call('/web/save','POST',stale,self.cookie)[0],409)
        stored=json.loads(self.call('/web/save',cookie=self.cookie)[2])
        self.assertEqual(stored['data'],current['data']);self.assertEqual(stored['revision'],2)

    def test_desktop_api_still_works(self):
        env={'PATH_INFO':'/lobby','REQUEST_METHOD':'GET','HTTP_HOST':'club.test','wsgi.url_scheme':'https','wsgi.input':io.BytesIO(b''),'HTTP_AUTHORIZATION':'Bearer '+self.accounts[0]['token']}
        seen=[];body=b''.join(self.app(env,lambda s,h:seen.append(s)));self.assertTrue(seen[0].startswith('200'));self.assertEqual(json.loads(body)['user']['name'],'alice')

    def test_visit_save23_cannot_be_overwritten_by_old22_tab(self):
        body=self.save_body();body['data'].update(version=23,socialState={'visits':{'coins':20,'energy':1}})
        self.assertEqual(self.call('/web/save','POST',body,self.cookie)[0],200)
        old=self.save_body(rev=1,id='old_22_tab');old['data']['version']=22
        self.assertEqual(self.call('/web/save','POST',old,self.cookie)[0],409)
        stored=json.loads(self.call('/web/save',cookie=self.cookie)[2])
        self.assertEqual(stored['data']['socialState']['visits'],{'coins':20,'energy':1})

    def test_static_revalidation_and_changed_content(self):
        code,headers,body=self.call('/game/main.swf',cookie=self.cookie)
        self.assertEqual(code,200);self.assertEqual(body,b'game')
        self.assertEqual(headers['Cache-Control'],'private, no-cache')
        tag=headers['ETag']
        code,headers,body=self.call('/game/main.swf',cookie=self.cookie,etag=tag)
        self.assertEqual(code,304);self.assertEqual(body,b'');self.assertNotIn('Content-Length',headers)
        self.assertEqual(self.call('/game/main.swf',cookie=self.cookie,etag='"different"')[0],200)
        (self.root/'public/game/main.swf').write_bytes(b'updated-game')
        code,headers,body=self.call('/game/main.swf',cookie=self.cookie,etag=tag)
        self.assertEqual(code,200);self.assertEqual(body,b'updated-game');self.assertNotEqual(headers['ETag'],tag)

    def test_revalidation_still_authenticates_and_keeps_account_data_uncached(self):
        tag=self.call('/game/main.swf',cookie=self.cookie)[1]['ETag']
        code,headers,_=self.call('/game/main.swf',etag=tag)
        self.assertEqual(code,401);self.assertEqual(headers['Cache-Control'],'no-store')
        self.assertEqual(self.call('/game/main.swf',cookie=self.cookie,etag=tag,origin='https://evil.test')[0],403)
        for path in ('/','/web/save','/web/session'):
            code,headers,_=self.call(path,cookie=self.cookie,etag='*')
            self.assertEqual(code,200);self.assertEqual(headers['Cache-Control'],'no-store');self.assertNotIn('ETag',headers)
        self.call('/web/api/logout','POST',{'requestId':'cache_logout'},self.cookie)
        self.assertEqual(self.call('/game/main.swf',cookie=self.cookie,etag=tag)[0],401)

    def test_register_without_invitation_and_login(self):
        with self.service.connection() as db:
            before=[tuple(r) for r in db.execute('SELECT * FROM invites')]
        data={'username':'New_Player','name':'Nuevo jugador','password':'test-password'}
        code,headers,body=self.call('/web/register','POST',data)
        self.assertEqual(code,200);self.assertNotIn('token',json.loads(body))
        self.assertEqual(json.loads(body)['user']['name'],'Nuevo jugador')
        cookie=headers['Set-Cookie'].split(';')[0]
        self.assertIn('HttpOnly',headers['Set-Cookie']);self.assertIn('Secure',headers['Set-Cookie'])
        self.assertEqual(self.call('/web/session',cookie=cookie)[0],200)
        self.assertIsNone(json.loads(self.call('/web/save',cookie=cookie)[2])['data'])
        self.assertEqual(self.call('/game/main.swf',cookie=cookie)[0],200)
        self.assertEqual(self.call('/web/register','POST',dict(data,username='new_player'))[0],409)
        self.assertEqual(self.call('/web/login','POST',{'username':'new_player','password':'test-password'})[0],200)
        with self.service.connection() as db:
            self.assertEqual(before,[tuple(r) for r in db.execute('SELECT * FROM invites')])
            self.assertEqual(db.execute("SELECT COUNT(*) FROM users WHERE username='new_player'").fetchone()[0],1)

    def test_open_registration_keeps_validation_origin_and_rate_limits(self):
        data={'username':'new_player','name':'Nuevo jugador','password':'test-password'}
        for changes in ({'username':'bad name'},{'name':'   '},{'password':'short'}):
            self.assertEqual(self.call('/web/register','POST',dict(data,**changes))[0],400)
        for origin in ('https://evil.test',None,'null'):
            self.assertEqual(self.call('/web/register','POST',data,origin=origin)[0],403)
        with self.service.connection() as db:
            self.assertIsNone(db.execute("SELECT id FROM users WHERE username='new_player'").fetchone())
        # A JSON field cannot opt legacy /register into the browser's policy.
        from server import Problem
        with self.assertRaises(Problem):
            self.service.request('POST','/register',dict(data,open_registration=True))
        for _ in range(70):
            code,_,_=self.call('/web/register','POST',{'username':'x'})
            if code==429:break
        self.assertEqual(code,429)

if __name__=='__main__':unittest.main()
