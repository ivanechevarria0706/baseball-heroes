package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.filesystem.*;import flash.desktop.NativeApplication;import flash.utils.*;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.visual.MatchStadium;
    public class ResultFlowSmoke extends Sprite {
        private var result:GameResultPanel,scene:Sprite=new Sprite(),summary:Object,home:int=0,next:int=0,coins:int,xp:int,done:Boolean=false;
        public function ResultFlowSmoke(){
            stage.scaleMode='noScale';stage.align='TL';addChild(scene);
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
            GameData.leagueIndex=0;GameData.seasonNumber=3;GameData.seasonGame=12;GameData.seasonWins=7;GameData.seasonLosses=4;GameData.seasonComplete=false;
            var lineup:Array=GameData.battingOrderPlayers(),box:MatchBoxScore=new MatchBoxScore(lineup);
            box.record(0,lineup[0],'SINGLE',0);box.record(0,lineup[0],'HOME RUN',3);box.record(0,lineup[0],'STRIKE OUT',0);
            box.record(1,{name:'Special Batter',accent:0x345678,specialCardId:'qa'},'DOUBLE CARD TRIGGER',2);
            box.record(2,lineup[2],'WALK',1);box.record(3,lineup[3],'TRIPLE',1);box.record(4,lineup[4],'GROUND OUT',0);
            var rows:Array=box.snapshot();check(rows[0].hits==2&&rows[0].homeRuns==1&&rows[0].atBats==3,'Hero hit/out totals');
            check(rows[1].hits==1&&rows[1].specialCardId=='qa','Special trigger totals');check(rows[2].walks==1&&rows[2].atBats==0&&rows[2].rbi==1,'Bases-loaded walk totals');
            rows[0].hits=99;check(box.snapshot()[0].hits==2,'Snapshot shared live data');
            summary=GameData.completeSeasonGame(7,4,4,1,6,7,[0,1,0,0,1,0,0,2,3],[1,0,0,1,0,0,2,0,0],box.snapshot());
            rows=summary.boxScore;box.record(0,lineup[0],'SINGLE',1);check(rows[0].hits==2,'Saved summary followed later events');
            GameData.lastGameSummary=null;GameData.load();summary=GameData.lastGameSummary;check(summary.boxScore[1].name=='Special Batter','Saved box score missing');
            summary.levelUp=null;coins=GameData.coins;xp=GameData.xp;
            var stadium:MatchStadium=new MatchStadium(960,720);scene.addChild(stadium);show(summary);setTimeout(win,1100);
            setTimeout(function():void{finish('FAIL: result test timeout',1);},20000);
        }
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var r:DisplayObject=find(d as DisplayObjectContainer,id);if(r)return r;}}return null;}
        private function field(id:String):TextField{return find(result,id) as TextField;}
        private function click(id:String):void{var d:DisplayObject=find(result,id);check(d!=null,'Missing '+id);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function show(data:Object,w:int=960,h:int=720):void {if(result){result.dispose();scene.removeChild(result);}result=new GameResultPanel(w,h,data,function():void{home++;},function():void{next++;});scene.addChild(result);}
        private function win():void {
            check(field('result-coins').text=='+'+String(summary.rewardCoins).replace(/\B(?=(\d{3})+(?!\d))/g,','),'Coin count incomplete');
            check(field('result-hits-0').text=='2'&&field('result-rbi-2').text=='1','Displayed stats differ');
            check(!field('result-coins').getBounds(result).intersects(find(result,'RESULT_NEXT').getBounds(result)),'Rewards covered by next button');
            check(GameData.coins==coins&&GameData.xp==xp,'Rendering awarded twice');shot('win');
            click('RESULT_NEXT');click('RESULT_NEXT');click('RESULT_HOME');check(next==1&&home==0,'Navigation dispatched twice');
            var loss:Object=JSON.parse(JSON.stringify(summary));loss.win=false;loss.homeScore=2;loss.awayScore=3;loss.homeLine=[0,0,0,0,0,0,1,0,1,0,0,0];loss.awayLine=[0,0,0,0,0,0,2,0,0,0,0,1];loss.rewardCoins=1100;loss.rewardXp=80;
            show(loss);setTimeout(extra,1000);
        }
        private function extra():void {
            check(field('inning-header-11').text=='12'&&field('inning-away-11').text=='1','Extra innings omitted');check(field('result-title').text=='YOU LOSE','Loss title');shot('extra-innings');
            click('RESULT_HOME');click('RESULT_HOME');check(home==1,'HOME repeated');
            var old:Object=JSON.parse(JSON.stringify(summary));delete old.boxScore;show(old,960,540);setTimeout(legacy,900);
        }
        private function legacy():void {
            check(find(result,'legacy-result')!=null,'Old save fabricated batter stats');check(find(result,'RESULT_NEXT').getBounds(result).bottom<=540,'Short viewport clipped footer');shot('legacy-540');
            var season:Object=JSON.parse(JSON.stringify(summary));season.seasonComplete=true;season.promoted=true;season.levelUp={toLevel:9,unlocked:['LIGHTNING','BOMBER','ITEM'],skillPoints:1,coins:1000,maxEnergy:2};show(season);click('RESULT_NEXT');check(next==1,'Skipped pending level-up');setTimeout(levelUp,1200);
        }
        private function levelUp():void {
            check(find(result,'LEVEL_CONTINUE')!=null,'Level-up missing');check(find(result,'LEVEL_CONTINUE').getBounds(result).bottom<720,'Level-up outside viewport');shot('level-up');click('RESULT_NEXT');check(next==1,'Navigation behind modal');click('LEVEL_CONTINUE');click('RESULT_NEXT');click('RESULT_NEXT');check(next==2,'Season navigation duplicated');
            check(GameData.coins==coins&&GameData.xp==xp,'Presentation changed rewards');
            finish('PASS: match-local hits, HR, RBI, walks and special triggers; detached snapshots; saved box score reload; accurate visible totals; no reward/button overlap; one-shot HOME/NEXT callbacks; extra innings; legacy summaries and 540px viewport; level-up blocks navigation until confirmed; rendering never awards coins or XP.\n',0);
        }
        private function shot(name:String):void {var b:BitmapData=new BitmapData(960,720,false,0x193849);b.draw(scene);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/v056-'+name+'.png');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();}
        private function finish(value:String,code:int):void {if(done)return;done=true;if(result)result.dispose();var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-result-flow.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
