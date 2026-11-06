package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.geom.*;import flash.filesystem.*;import flash.utils.*;import flash.net.SharedObject;import flash.desktop.NativeApplication;
    import com.bh.model.GameData;import com.bh.ui.*;import com.bh.online.*;
    public class League065Smoke extends Sprite {
        private var ui:OnlineLobbyScreen,client:OnlineClient,config:Object,accounts:Array,lid:String,data:Object,fixture:Object,saveBefore:String,finished:Boolean=false,steps:int=0,completed:int=0;
        private var waitTimer:Timer;
        public function League065Smoke(){setTimeout(start,100);}
        private function start():void {
            try {
                stage.scaleMode="noScale";stage.align="TL";stage.frameRate=30;
                loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish("FAIL: "+e.error,1);});
                var f:FileStream=new FileStream();f.open(file("qa/league065-config.json"),FileMode.READ);config=JSON.parse(f.readUTFBytes(f.bytesAvailable));f.close();accounts=config.accounts;
                GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;GameData.save();saveBefore=JSON.stringify(SharedObject.getLocal("baseballHeroesRemakeSave").data);
                openAccount(0,function():void{click("online_leagues");until(function():Boolean{return named(ui,"league_create")!=null;},createLeague);});
                setTimeout(function():void{finish("FAIL: global timeout",1);},180000);
            }catch(e:Error){finish("FAIL: startup "+e.message,1);}
        }
        private function file(path:String):File{return (new File(File.applicationDirectory.nativePath)).resolvePath(path);}
        private function check(v:Boolean,m:String):void {if(!v)throw new Error(m);}
        private function named(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=named(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function click(id:String):void {var d:DisplayObject=named(ui,id);check(d!=null,"Missing "+id);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function until(test:Function,next:Function):void {var since:int=getTimer(),t:Timer=new Timer(60);waitTimer=t;steps++;t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{try{if(test()){t.stop();next();}else if(getTimer()-since>17000){t.stop();shot("failure");finish("FAIL: timeout step "+steps,1);}}catch(error:Error){t.stop();finish("FAIL: "+error.message,1);}});t.start();}
        private function openAccount(index:int,next:Function):void {
            if(ui){ui.dispose();removeChild(ui);}client=new OnlineClient(false);client.setServer(config.url);client.token=accounts[index].token;client.user=accounts[index].user;
            ui=new OnlineLobbyScreen(960,720,function():void{},client);addChild(ui);until(function():Boolean{return named(ui,"online_leagues")!=null&&!client.busy;},next);
        }
        private function req(api:OnlineClient,path:String,body:Object,next:Function):void {body.requestId=OnlineClient.requestId();api.request("POST",path,body,next,netFail);}
        private function createLeague():void {
            shot("list");TextField(named(ui,"league_name")).text="Liga de los Amigos";click("league_create");
            until(function():Boolean{return named(ui,"league_start")!=null&&!client.busy;},function():void{client.request("GET","/leagues",null,function(list:Object):void{lid=list.leagues[0].id;joinViaUI();},netFail);});
        }
        private function joinViaUI():void {
            openAccount(1,function():void{click("online_leagues");until(function():Boolean{return named(ui,"league_open_"+lid)!=null;},function():void{click("league_open_"+lid);click("league_join_confirm");until(function():Boolean{return named(ui,"league_leave")!=null&&!client.busy;},function():void{click("league_leave");click("league_confirm_back");check(named(ui,"league_leave")!=null,"Cancel leave changed enrollment");joinOthers(2);});});});
        }
        private function joinOthers(index:int):void {
            if(index==accounts.length){openAccount(0,ownerStart);return;}
            var api:OnlineClient=new OnlineClient(false);api.setServer(config.url);api.token=accounts[index].token;api.user=accounts[index].user;
            req(api,"/leagues/"+lid+"/join",{},function(response:Object):void{api.dispose();joinOthers(index+1);});
        }
        private function ownerStart():void {
            click("online_leagues");until(function():Boolean{return named(ui,"league_open_"+lid)!=null;},function():void{click("league_open_"+lid);until(function():Boolean{return named(ui,"league_start")!=null&&!client.busy;},function():void{shot("enrollment");click("league_start");shot("confirm");click("league_confirm_back");check(named(ui,"league_start")!=null,"Start cancel changed registration");click("league_start");click("league_start_confirm");until(function():Boolean{return named(ui,"league_next_mine")!=null&&!client.busy;},calendar);});});
        }
        private function calendar():void {
            shot("calendar");client.request("GET","/leagues/"+lid,null,function(result:Object):void{
                data=result;check(data.fixtures.length==30&&data.rounds==10,"Six-player schedule incorrect");
                click("league_round_next");click("league_round_prev");click("league_next_mine");
                for each(var f:Object in data.fixtures)if(f.homeId==accounts[0].user.id){fixture=f;break;}
                check(fixture!=null,"No home fixture");click("league_fixture_"+fixture.id);
                until(function():Boolean{return named(ui,"rival_auto")!=null&&!client.busy;},function():void{check(stage.frameRate==60,"Batting frame rate");shot("match");click("rival_cancel");check(named(ui,"rival_cancel_confirm")!=null,"League forfeit confirmation missing");click("rival_cancel_no");autoTurn();});
            },netFail);
        }
        private function autoTurn():void {
            if(named(ui,"rival_box")){shot("result");click("rival_back");until(function():Boolean{return named(ui,"league_next_mine")!=null&&!client.busy;},afterGame);return;}
            click("rival_auto");until(function():Boolean{return !client.busy&&(named(ui,"rival_auto")!=null||named(ui,"rival_box")!=null);},autoTurn);
        }
        private function afterGame():void {
            check(stage.frameRate==30,"League menu frame rate not restored");shot("standings");
            client.request("GET","/leagues/"+lid,null,function(result:Object):void{check(result.completed==1,"Standings not updated after match");data=result;forfeitGame();},netFail);
        }
        private function forfeitGame():void {
            click("league_next_mine");var f:Object;for each(var next:Object in data.fixtures)if(next.homeId==accounts[0].user.id&&next.status!="complete"){f=next;break;}
            click("league_fixture_"+f.id);until(function():Boolean{return named(ui,"rival_auto")!=null&&!client.busy;},function():void{click("rival_cancel");click("rival_cancel_confirm");until(function():Boolean{return named(ui,"rival_box")!=null&&!client.busy;},function():void{shot("forfeit");click("rival_back");until(function():Boolean{return named(ui,"league_next_mine")!=null&&!client.busy;},function():void{client.request("GET","/leagues/"+lid,null,function(updated:Object):void{check(updated.completed==2,"Forfeit did not count once");data=updated;playRemaining(0);},netFail);});});});
        }
        private function playRemaining(index:int):void {
            if(index>=data.fixtures.length){click("league_reload");until(function():Boolean{return !client.busy&&named(ui,"league_next_mine")!=null;},leagueFinished);return;}
            var f:Object=data.fixtures[index];if(f.status=="complete"){playRemaining(index+1);return;}
            var account:Object;for each(var a:Object in accounts)if(a.user.id==f.homeId)account=a;
            var api:OnlineClient=new OnlineClient(false);api.setServer(config.url);api.token=account.token;api.user=account.user;
            req(api,"/leagues/"+lid+"/fixtures/"+f.id+"/play",{},function(match:Object):void{autoAPI(api,match,function():void{api.dispose();playRemaining(index+1);});});
        }
        private function autoAPI(api:OnlineClient,match:Object,next:Function):void {
            if(match.state.status=="complete"){next();return;}
            req(api,"/matches/"+match.id+"/auto",{revision:match.revision},function(updated:Object):void{autoAPI(api,updated,next);});
        }
        private function leagueFinished():void {
            shot("champion");client.request("GET","/leagues/"+lid,null,function(result:Object):void{
                check(result.status=="complete"&&result.completed==30,"League did not complete");check(result.champions.length>=1,"Missing champion");
                for each(var row:Object in result.standings)check(row.played==10,"Wrong games played");
                data=result;check(JSON.stringify(SharedObject.getLocal("baseballHeroesRemakeSave").data)==saveBefore,"League changed offline save");
                openAccount(1,function():void{click("online_leagues");until(function():Boolean{return named(ui,"league_open_"+lid)!=null;},function():void{click("league_open_"+lid);until(function():Boolean{return named(ui,"league_next_mine")!=null&&!client.busy;},function():void{client.request("GET","/leagues/"+lid,null,function(same:Object):void{check(JSON.stringify(same)==JSON.stringify(data),"Different shared classification");shot("friend-view");ui.dispose();finish("PASS: real RIVAL league entry; owner creation; friend joins by UI; cancelled leave/start/forfeit confirmations; six members; 30 fixtures/10 rounds; round navigation; real league match updates standings; all 30 games complete on server; every member has 10 games; champion and same final standings from second account; 60fps match/30fps menu; offline save unchanged. Isolated test accounts and DB.",0);},netFail);});});});
            },netFail);
        }
        private function netFail(message:String,status:int):void {finish("FAIL: "+status+" "+message,1);}
        private function shot(name:String):void {var b:BitmapData=new BitmapData(960,720,false,0);b.draw(this);var out:FileStream=new FileStream();out.open(file("qa/v065-league-"+name+".png"),FileMode.WRITE);out.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));out.close();b.dispose();}
        private function finish(message:String,code:int):void {if(finished)return;finished=true;if(waitTimer)waitTimer.stop();var out:FileStream=new FileStream();out.open(file("qa/smoke-league065.txt"),FileMode.WRITE);out.writeUTFBytes(message);out.close();NativeApplication.nativeApplication.exit(code);}
    }
}
