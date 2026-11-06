package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.filesystem.*;import flash.desktop.NativeApplication;import flash.utils.*;
    import com.bh.core.Game;import com.bh.game.Ball;import com.bh.model.GameData;import com.bh.ui.*;import com.bh.audio.AudioManager;
    public class FullMatchResultSmoke extends Sprite {
        private var game:Game,ball:Ball,hud:Hud,panel:TeamSimulationPanel,result:GameResultPanel;
        private var swung:Boolean=false,pitches:int=0,initialGame:int,wins:int,losses:int,resultAt:int=-1,next:int=0,done:Boolean=false;
        public function FullMatchResultSmoke(){
            stage.scaleMode='noScale';stage.align='TL';stage.frameRate=60;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            AudioManager.setSfxVolume(0);GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;GameData.seasonGame=1;GameData.seasonComplete=false;GameData.levelProgress=0;
            initialGame=GameData.seasonGame;wins=GameData.seasonWins;losses=GameData.seasonLosses;
            game=new Game(960,720,function():void{},function():void{next++;});addChild(game);ball=type(game,Ball) as Ball;hud=type(game,Hud) as Hud;panel=type(game,TeamSimulationPanel) as TeamSimulationPanel;
            addEventListener(Event.ENTER_FRAME,tick);setTimeout(function():void{finish('FAIL: full match timeout; pitches='+pitches,1);},300000);
        }
        private function type(c:DisplayObjectContainer,t:Class):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is t)return d;if(d is DisplayObjectContainer){var r:DisplayObject=type(d as DisplayObjectContainer,t);if(r)return r;}}return null;}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var r:DisplayObject=find(d as DisplayObjectContainer,id);if(r)return r;}}return null;}
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function key():void{stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));}
        private function tick(e:Event):void {
            result=type(game,GameResultPanel) as GameResultPanel;
            if(result){if(resultAt<0)resultAt=getTimer();if(getTimer()-resultAt<1450)return;verify();return;}
            if(panel.visible)return;
            var pitch:TextField=find(hud,'pitch-label') as TextField;
            if(hud.visible&&pitch&&pitch.text.indexOf('READY')>=0){swung=false;pitches++;key();return;}
            if(!swung&&ball.visible){var progress:Number=Math.sqrt(Math.max(0,(ball.scaleX-.27)/2.55));if(pitches%3==0?progress>=.905&&progress<=.95:progress<.25){swung=true;key();}}
        }
        private function verify():void {
            var s:Object=GameData.lastGameSummary;check(s!=null&&s.game==initialGame,'Wrong completed match');check(s.awayLine.length>=9&&s.homeLine.length>=8,'Match ended before nine innings');
            check(s.boxScore.length==9,'Nine batters missing');var hits:int=0,hr:int=0,rbi:int=0,ab:int=0;
            for(var i:int=0;i<9;i++){var row:Object=s.boxScore[i];hits+=row.hits;hr+=row.homeRuns;rbi+=row.rbi;ab+=row.atBats;check(TextField(find(result,'result-player-'+i)).text==row.name,'Result lost batting order');}
            check(hits==s.hits&&hr==s.homeRuns&&rbi==s.rbi&&ab==s.atBats,'Box score does not reconcile: '+[hits,s.hits,hr,s.homeRuns,rbi,s.rbi,ab,s.atBats]);
            check(!panel.visible&&hud.mask!=null,'Result overlaps simulation / live scoreboard');
            check(GameData.seasonGame==initialGame+1&&GameData.seasonWins+GameData.seasonLosses==wins+losses+1,'Season advanced more than once');
            var close:DisplayObject=find(result,'LEVEL_CONTINUE');if(close)close.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));shot();
            var coins:int=GameData.coins,xp:int=GameData.xp;var button:DisplayObject=find(result,'RESULT_NEXT');button.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));button.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));
            check(next==1&&GameData.coins==coins&&GameData.xp==xp,'Repeated next changed rewards');
            GameData.lastGameSummary=null;GameData.load();check(GameData.lastGameSummary.boxScore[0].hits==s.boxScore[0].hits,'Real match totals not saved');
            finish('PASS: full live match of '+s.awayLine.length+' innings and '+pitches+' manual pitches (home halves: '+s.homeLine.length+'); all nine score rows reconcile hits, HR, RBI and at-bats with game totals; saved result reload; season advanced once; HUD isolation; NEXT callback once with no duplicate reward.\n',0);
        }
        private function shot():void {var b:BitmapData=new BitmapData(960,720,false,0x193849);b.draw(game);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/v056-full-match.png');f.parent.createDirectory();var stream:FileStream=new FileStream();stream.open(f,FileMode.WRITE);stream.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));stream.close();b.dispose();}
        private function finish(value:String,code:int):void {if(done)return;done=true;removeEventListener(Event.ENTER_FRAME,tick);if(game)game.dispose();var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-full-match-result.txt');f.parent.createDirectory();var stream:FileStream=new FileStream();stream.open(f,FileMode.WRITE);stream.writeUTFBytes(value);stream.close();NativeApplication.nativeApplication.exit(code);}
    }
}
