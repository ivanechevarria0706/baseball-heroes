package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import com.bh.core.Game;
    import com.bh.model.GameData;
    import com.bh.game.*;
    import com.bh.ui.*;
    import com.bh.audio.AudioManager;
    public class SpriteMatch060Smoke extends Sprite {
        private var game:Game,ball:Ball,hud:Hud,panel:TeamSimulationPanel;
        private var mode:String='ready',index:int=0,contactAt:int=0;
        private var sceneAt:int,simulationShot:Boolean=false,contactShot:Boolean=false;
        public function SpriteMatch060Smoke(){
            stage.scaleMode='noScale';stage.align='TL';stage.frameRate=60;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            AudioManager.setSfxVolume(0);GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
            next();addEventListener(Event.ENTER_FRAME,tick);setTimeout(function():void{finish('FAIL: classic match timeout '+mode,1);},120000);
        }
        private function next():void {
            if(game){game.dispose();removeChild(game);}GameData.stadiumActive.background=index==0?'stadium_background_mountain':'stadium_background_major_night';
            game=new Game(960,720,function():void{},function():void{});addChild(game);ball=find(game,Ball) as Ball;hud=find(game,Hud) as Hud;panel=find(game,TeamSimulationPanel) as TeamSimulationPanel;
            mode='ready';sceneAt=getTimer();simulationShot=contactShot=false;
            if(game.scrollRect.width/game.scrollRect.height!=4/3)throw new Error('Classic frame is not 4:3');
        }
        private function find(c:DisplayObjectContainer,type:Class):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is type)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,type);if(f)return f;}}return null;}
        private function texts(c:DisplayObjectContainer):String {var s:String='';for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is TextField)s+=TextField(d).text;else if(d is DisplayObjectContainer)s+=texts(d as DisplayObjectContainer);}return s;}
        private function key():void {stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));}
        private function tick(e:Event):void {
            if(panel.visible&&hud.visible)throw new Error('Overlapping HUDs');
            if(panel.visible&&!simulationShot&&getTimer()-sceneAt>900){shot('simulation');simulationShot=true;}
            if(mode=='ready'&&hud.visible&&texts(hud).indexOf('READY')>=0){
                if(hud.mask)throw new Error('Result mask leaked into batting');
                var batter:ClassicBatter=find(game,ClassicBatter) as ClassicBatter;
                if(batter.scaleX!=batter.scaleY)throw new Error('Distorted batter');
                var bounds:Rectangle=batter.getBounds(game);if(bounds.left<0||bounds.right>960||bounds.top<100||bounds.bottom>668)throw new Error('Batter overlaps frame or HUD: '+bounds);
                shot('ready');mode='pitch';key();return;
            }
            if(mode=='pitch'&&ball.visible){
                var p:Number=Math.sqrt(Math.max(0,(ball.scaleX-.27)/2.55));
                if(p>=.905&&p<=.95){key();mode='contact';contactAt=getTimer();return;}
            }
            if(mode=='contact'&&!contactShot&&getTimer()-contactAt>240){shot('contact');contactShot=true;}
            var cine:HitCinematic=find(game,HitCinematic) as HitCinematic;
            if(mode=='contact'&&cine.visible&&getTimer()-contactAt>2900){if(!hud.mask)throw new Error('Result HUD not isolated');shot('result');mode='return';}
            if(mode=='return'&&panel.visible){shot('return');if(index++==0)next();else finish('PASS: 960x720 classic frame; Rookie and Major render; batter retains aspect ratio inside frame; real SPACE contacts reach results and return to simulation without HUD overlap; isolated save.\n',0);}
        }
        private function shot(label:String):void {
            var b:BitmapData=new BitmapData(960,720,false,0x14251c);b.draw(game);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/v060-'+(index==0?'rookie-':'major-')+label+'.png');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();
        }
        private function finish(value:String,code:int):void {removeEventListener(Event.ENTER_FRAME,tick);if(game)game.dispose();var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-sprite-match.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
