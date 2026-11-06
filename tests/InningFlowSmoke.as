package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.text.TextField;
    import flash.utils.*;
    import com.bh.core.Game;
    import com.bh.model.GameData;
    import com.bh.game.*;
    import com.bh.ui.*;
    import com.bh.audio.AudioManager;
    public class InningFlowSmoke extends Sprite {
        private var game:Game,panel:TeamSimulationPanel,hud:Hud,ball:Ball;
        private var manual:Boolean=false,swung:Boolean=false;
        private var visits:int=0,completed:int=0,thirdOuts:int=0;
        private var lastThird:String='',lastStamp:DisplayObject,stamps:int=0;
        private var captured:Boolean=false,returnedLineupCaptured:Boolean=false;
        public function InningFlowSmoke(){
            stage.scaleMode='noScale';stage.align='TL';stage.frameRate=60;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            AudioManager.setSfxVolume(0);GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
            game=new Game(960,720,function():void{},function():void{});addChild(game);
            panel=findType(game,TeamSimulationPanel) as TeamSimulationPanel;hud=findType(game,Hud) as Hud;ball=findType(game,Ball) as Ball;addEventListener(Event.ENTER_FRAME,tick);
            setTimeout(function():void{finish('FAIL: full inning timeout; visits='+visits+' completed='+completed+' thirdOuts='+thirdOuts+' stamps='+stamps,1);},120000);
        }
        private function findType(c:DisplayObjectContainer,type:Class):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is type)return d;if(d is DisplayObjectContainer){var f:DisplayObject=findType(d as DisplayObjectContainer,type);if(f)return f;}}return null;}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function key():void {stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));}
        private function tick(e:Event):void {
            if(panel.visible){
                if(hud.visible)throw new Error('Simulation and batting HUD overlap');
                if(manual){manual=false;completed++;if(!captured){shot('v052-return-after-manual.png');captured=true;}}
                var stamp:DisplayObject=find(panel,'simulation-result');
                if(stamp&&stamp!==lastStamp){
                    lastStamp=stamp;stamps++;
                    if(!(stamp.parent is SimulationPlayerRow)||!SimulationPlayerRow(stamp.parent).isActive)throw new Error('Result lost its active batter before being presented');
                    if(completed>0&&!returnedLineupCaptured){shot('v052-return-lineup.png');returnedLineupCaptured=true;}
                }
                if(stamp&&stamp.parent&&!SimulationPlayerRow(stamp.parent).isActive)throw new Error('Active row advanced while its result still renders');
                var outText:TextField=find(panel,'simulation-outs') as TextField;
                var inningText:TextField=find(panel,'simulation-inning') as TextField;
                if(outText&&outText.text=='3 OUTS'&&inningText.text!=lastThird){lastThird=inningText.text;thirdOuts++;}
                return;
            }
            var pitch:TextField=find(hud,'pitch-label') as TextField;
            if(hud.visible&&pitch&&pitch.text.indexOf('READY')>=0){
                if(!manual){manual=true;visits++;}
                if(completed>=2&&thirdOuts>=2&&stamps>=6){shot('v052-next-hero-ready.png');finish('PASS: two manual plate appearances return automatically to simulation; third outs remain visible across both halves; '+stamps+' simulated results keep their active row; hero re-enters READY for visit '+visits+'; no overlapping HUDs or manual ENTER required.\n',0);return;}
                swung=false;key();return;
            }
            if(manual&&!swung&&ball.visible){
                var progress:Number=Math.sqrt(Math.max(0,(ball.scaleX-.27)/2.55));
                if(completed%2==0?progress>=.905&&progress<=.95:progress<.25){swung=true;key();}
            }
        }
        private function shot(name:String):void {var b:BitmapData=new BitmapData(960,720,false,0x163229);b.draw(game);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name.replace('v052','v054'));f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();}
        private function finish(value:String,code:int):void {removeEventListener(Event.ENTER_FRAME,tick);if(game)game.dispose();var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-inning-flow.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
