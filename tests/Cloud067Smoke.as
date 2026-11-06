package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.geom.*;import flash.filesystem.*;import flash.utils.*;import flash.net.SharedObject;import flash.desktop.NativeApplication;
    import com.bh.Main;import com.bh.model.GameData;import com.bh.ui.*;import com.bh.online.*;
    public class Cloud067Smoke extends Sprite {
        private var ui:OnlineLobbyScreen,config:Object,invitation:String,alice:Object,bob:Object,mid:String,result:Object,saveBefore:String,finished:Boolean=false,steps:int=0;
        private var client:OnlineClient,peer:OnlineClient,waitTimer:Timer; private var league:Object,pausedPitch:String;
        public function Cloud067Smoke(){
            setTimeout(start,100);
        }
        private function start():void {
            try {
            checkpoint("start");
            stage.scaleMode="noScale";stage.align="TL";stage.frameRate=30;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish("FAIL: "+e.error,1);});
            var f:FileStream=new FileStream();f.open((new File(File.applicationDirectory.nativePath)).resolvePath("qa/cloud067-config.json"),FileMode.READ);config=JSON.parse(f.readUTFBytes(f.bytesAvailable));f.close();
            GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;GameData.teamName="Kediri QA";GameData.save();
            saveBefore=JSON.stringify(SharedObject.getLocal("baseballHeroesRemakeSave").data);
            checkpoint("offline initialized");
            client=new OnlineClient(false);client.forget();client.setServer(config.url);
            checkpoint("client initialized");
            ui=new OnlineLobbyScreen(960,720,function():void{},client);addChild(ui);
            checkpoint("screen initialized");
            shot("login");fill("online_server",config.url);fill("online_username",config.usernameA);fill("online_password",config.password);fill("online_name","Alice QA");click("online_login");
            until(function():Boolean{return named(ui,"online_publish")!=null&&!client.busy;},aliceReady);
            setTimeout(function():void{finish("FAIL: overall timeout",1);},900000);
            }catch(e:Error){finish("FAIL: startup "+e.message+" "+e.getStackTrace(),1);}
        }
        private function checkpoint(value:String):void {var f:FileStream=new FileStream();f.open((new File(File.applicationDirectory.nativePath)).resolvePath("qa/cloud067-progress.txt"),FileMode.WRITE);f.writeUTFBytes(value);f.close();}
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function named(c:DisplayObjectContainer,id:String):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=named(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function typed(c:DisplayObjectContainer,t:Class):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is t)return d;if(d is DisplayObjectContainer){var f:DisplayObject=typed(d as DisplayObjectContainer,t);if(f)return f;}}return null;}
        private function fill(id:String,value:String):void {var t:TextField=named(ui,id) as TextField;check(t!=null,"Missing input "+id);t.text=value;}
        private function click(id:String):void {var d:DisplayObject=named(ui,id);check(d!=null,"Missing control "+id);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function until(condition:Function,next:Function):void {
            var started:int=getTimer();waitTimer=new Timer(70);var current:Timer=waitTimer;
            current.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{try{if(condition()){current.stop();next();}else if(getTimer()-started>35000){current.stop();shot("failure");finish("FAIL: timed out at step "+steps,1);}}catch(error:Error){current.stop();finish("FAIL: "+error.message,1);}});steps++;current.start();
        }
        private function aliceReady():void {
            alice={token:client.token,user:client.user};
            click("online_publish");shot("publish");click("online_publish_confirm");
            until(function():Boolean{return named(ui,"online_logout")!=null&&!client.busy;},function():void{
                click("online_logout");until(function():Boolean{return named(ui,"online_username")!=null;},registerBob);
            });
        }
        private function registerBob():void {fill("online_username",config.usernameB);fill("online_password",config.password);fill("online_name","Bob QA");click("online_login");until(function():Boolean{return named(ui,"online_publish")!=null&&!client.busy;},function():void{bob={token:client.token,user:client.user};click("online_publish");click("online_publish_confirm");until(function():Boolean{return named(ui,"online_logout")!=null&&!client.busy;},function():void{click("online_logout");until(function():Boolean{return named(ui,"online_username")!=null;},loginAlice);});});}
        private function loginAlice():void {fill("online_username",config.usernameA);fill("online_password",config.password);click("online_login");until(function():Boolean{return named(ui,"online_challenge_"+bob.user.id)!=null&&!client.busy;},function():void{alice={token:client.token,user:client.user};var restored:OnlineClient=new OnlineClient();check(restored.token==client.token&&restored.baseURL==config.url,"Encrypted session did not restore");restored.dispose();shot("lobby");click("online_challenge_"+bob.user.id);until(function():Boolean{return named(ui,"rival_pitch")!=null&&!client.busy;},playPitch);});}
        private function playPitch():void {check(stage.frameRate==60,"Rival batting needs 60fps");shot("match");click("rival_pitch");until(function():Boolean{return named(ui,"rival_swing")!=null&&!client.busy;},function():void{shot("pitch");click("rival_swing");until(function():Boolean{return named(ui,"rival_pitch")!=null&&!client.busy;},resumeTest);});}
        private function resumeTest():void {
            click("rival_pitch");until(function():Boolean{return named(ui,"rival_swing")!=null&&!client.busy;},function():void{
                client.request("GET","/lobby",null,function(data:Object):void{
                    for each(var game:Object in data.matches)if(game.state.status=="playing"&&game.homeId==client.user.id){mid=game.id;pausedPitch=game.state.pending.id;}
                    check(mid!=null&&pausedPitch!=null,"No persisted pitch before restart");
                    var marker:FileStream=new FileStream();marker.open((new File(File.applicationDirectory.nativePath)).resolvePath("qa/cloud067-restart-ready.txt"),FileMode.WRITE);marker.writeUTFBytes(mid);marker.close();
                    ui.dispose();removeChild(ui);ui=null;
                    var deadline:int=getTimer();waitTimer=new Timer(300);waitTimer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
                        if((new File(File.applicationDirectory.nativePath)).resolvePath("qa/cloud067-resume.txt").exists){waitTimer.stop();resumeAfterRestart();}
                        else if(getTimer()-deadline>300000)finish("FAIL: waiting for server restart",1);
                    });waitTimer.start();
                },netFail);
            });
        }
        private function resumeAfterRestart():void {
            client=new OnlineClient();
            client.request("GET","/matches/"+mid,null,function(saved:Object):void{
                check(saved.state.pending.id==pausedPitch,"Pending pitch changed across remote restart");
                continueAfterRestart();
            },netFail);
        }
        private function continueAfterRestart():void {
                check(stage.frameRate==30,"Menu frame rate was not restored");ui=new OnlineLobbyScreen(960,720,function():void{},client);addChild(ui);
                until(function():Boolean{return !client.busy&&findMatchButton()!=null;},function():void{var b:DisplayObject=findMatchButton();mid=b.name.substr("online_match_".length);click(b.name);until(function():Boolean{return named(ui,"rival_pitch")!=null&&!client.busy;},function():void{click("rival_pitch");until(function():Boolean{return named(ui,"rival_take")!=null;},function():void{click("rival_take");until(function():Boolean{return named(ui,"rival_pitch")!=null&&!client.busy;},autoUntilEnd);});});});
        }
        private function findMatchButton():DisplayObject {return prefix(ui,"online_match_");}
        private function prefix(c:DisplayObjectContainer,id:String):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name.indexOf(id)==0)return d;if(d is DisplayObjectContainer){var f:DisplayObject=prefix(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function autoUntilEnd():void {
            if(named(ui,"rival_box")){shot("result");click("rival_box");shot("box");sharedResult();return;}
            click("rival_auto");until(function():Boolean{return !client.busy&&(named(ui,"rival_auto")!=null||named(ui,"rival_box")!=null);},autoUntilEnd);
        }
        private function sharedResult():void {
            client.request("GET","/matches/"+mid,null,function(data:Object):void{
                result=data;check(data.state.status=="complete","Match incomplete");peer=new OnlineClient(false);peer.setServer(config.url);
                peer.request("POST","/login",{username:config.usernameB,password:config.password},function(login:Object):void{
                    peer.token=login.token;peer.user=login.user;
                    peer.request("GET","/matches/"+mid,null,function(same:Object):void{
                        check(JSON.stringify(same)==JSON.stringify(result),"Different remote match results");
                        post(client,"/leagues",{name:config.leagueName},function(created:Object):void{
                            league=created;post(peer,"/leagues/"+league.id+"/join",{},function(joined:Object):void{
                                post(client,"/leagues/"+league.id+"/start",{},function(started:Object):void{league=started;check(league.fixtures.length==2,"Wrong double round robin");leagueGame(0);});
                            });
                        });
                    },netFail);
                },netFail);
            },netFail);
        }
        private function post(api:OnlineClient,path:String,body:Object,next:Function):void {body.requestId=OnlineClient.requestId();api.request("POST",path,body,next,netFail);}
        private function leagueGame(index:int):void {
            if(index==league.fixtures.length){verifyTable();return;}
            var fixture:Object=league.fixtures[index],who:OnlineClient=fixture.homeId==client.user.id?client:peer;
            post(who,"/leagues/"+league.id+"/fixtures/"+fixture.id+"/play",{},function(match:Object):void{
                post(who,"/matches/"+match.id+"/forfeit",{revision:match.revision},function(done:Object):void{check(done.state.status=="complete"&&done.state.forfeit,"Forfeit failed");leagueGame(index+1);});
            });
        }
        private function verifyTable():void {
            client.request("GET","/leagues/"+league.id,null,function(table:Object):void{
                check(table.status=="complete"&&table.completed==2,"League completion failed");
                peer.request("GET","/leagues/"+league.id,null,function(same:Object):void{
                    check(JSON.stringify(table)==JSON.stringify(same),"Standings differ between remote accounts");
                    peer.dispose();check(JSON.stringify(SharedObject.getLocal("baseballHeroesRemakeSave").data)==saveBefore,"Offline save changed");
                    ui.dispose();removeChild(ui);ui=new OnlineLobbyScreen(960,720,function():void{},client);addChild(ui);
                    until(function():Boolean{return named(ui,"online_leagues")!=null&&!client.busy;},function():void{
                        click("online_leagues");until(function():Boolean{return named(ui,"league_open_"+league.id)!=null&&!client.busy;},function():void{
                            click("league_open_"+league.id);until(function():Boolean{return named(ui,"league_next_mine")!=null&&!client.busy;},function():void{
                                shot("league-final");ui.dispose();removeChild(ui);verifyMain();
                            });
                        });
                    });
                },netFail);
            },netFail);
        }
        private function verifyMain():void {
            client.forget();var app:Main=new Main();addChild(app);var modes:DisplayObject=named(app,"MODES");check(modes!=null,"HOME modes missing");modes.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));var rival:DisplayObject=named(app,"mode_rival");check(rival!=null,"RIVAL route missing");rival.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));check(typed(app,OnlineLobbyScreen)!=null,"Main RIVAL route failed");stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,27));check(typed(app,LobbyScreen)!=null,"ESC RIVAL failed");
            finish("PASS: Windows captive AIR runtime connected to the real Railway HTTPS endpoint; two temporary accounts logged in and published teams through UI; manual pitch/swing; encrypted session recovery; same pending pitch after remote server restart; complete nine-inning match; identical result and box score from both accounts; two-team league with shared final standings; RIVAL route and offline save unchanged. QA accounts isolated from personal accounts.",0);
        }
        private function netFail(message:String,status:int):void {finish("FAIL: "+status+" "+message,1);}
        private function shot(id:String):void {var b:BitmapData=new BitmapData(960,720,false,0);b.draw(this);var bytes:ByteArray=b.encode(b.rect,new PNGEncoderOptions());var f:FileStream=new FileStream();f.open((new File(File.applicationDirectory.nativePath)).resolvePath("qa/cloud067-"+id+".png"),FileMode.WRITE);f.writeBytes(bytes);f.close();b.dispose();}
        private function finish(message:String,code:int):void {if(finished)return;finished=true;if(waitTimer)waitTimer.stop();var f:FileStream=new FileStream();f.open((new File(File.applicationDirectory.nativePath)).resolvePath("qa/smoke-cloud067.txt"),FileMode.WRITE);f.writeUTFBytes(message);f.close();NativeApplication.nativeApplication.exit(code);}
    }
}
