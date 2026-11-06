package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.text.TextField;
    import flash.utils.*;
    import flash.geom.Point;
    import com.bh.game.ClassicBatter;
    import com.bh.game.Ball;
    import com.bh.game.Pitcher;
    import com.bh.ui.HomeRunDerbyScreen;
    import com.bh.model.GameData;
    public class SpriteDerby060Smoke extends Sprite {
        private var scene:HomeRunDerbyScreen;
        private var ball:Ball;
        private var state:String='ready';
        private var launched:int=0;
        private var swung:int=0;
        private var coins:int;
        private var lastProgress:Number=0;
        public function SpriteDerby060Smoke(){
            stage.scaleMode='noScale';stage.align='TL';stage.frameRate=60;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            GameData.init();coins=GameData.coins;scene=new HomeRunDerbyScreen(960,720,function():void{});addChild(scene);
            ball=find(scene,Ball) as Ball;addEventListener(Event.ENTER_FRAME,tick);
            setTimeout(function():void{finish('FAIL: Derby timeout, '+launched+' pitches / '+state+' / progress '+lastProgress,1);},60000);
        }
        private function find(c:DisplayObjectContainer,type:Class):DisplayObject {
            for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is type)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,type);if(f)return f;}}return null;
        }
        private function has(c:DisplayObjectContainer,value:String):Boolean {
            for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is TextField&&TextField(d).text==value)return true;if(d is DisplayObjectContainer&&has(d as DisplayObjectContainer,value))return true;}return false;
        }
        private function key():void {stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));}
        private function tick(e:Event):void {
            if(has(scene,'DERBY COMPLETE')){
                if(launched!=10||swung!=10||!has(scene,'HR 10'))throw new Error('Not all ten pitches reached a successful swing');
                if(GameData.coins!=coins+3000)throw new Error('Incorrect Derby reward');
                key();key();if(GameData.coins!=coins+3000)throw new Error('Repeated input duplicated reward');
                shot('v060-derby-complete.png');finish('PASS: ten real SPACE pitches release, fly and produce home runs; second/next throws recover; completion pays exactly 3000 coins once; isolated QA save.\n',0);return;
            }
            if(state=='ready'&&has(scene,'READY')){key();launched++;state='windup';if(ball.visible)throw new Error('Ball visible during Derby windup');return;}
            if(state=='windup'&&ball.visible){state='flight';}
            if(state=='flight'){
                var p:Number=Math.sqrt(Math.max(0,(ball.scaleX-.27)/2.55));
                lastProgress=p;
                if(has(scene,'READY'))throw new Error('QA missed flight input window; last progress '+p);
                if(p>=.78&&p<=.91){var atContact:Point=new Point(ball.x,ball.y);key();swung++;state='ready';if(launched==1)setTimeout(function():void{
                    var hitter:ClassicBatter=find(scene,ClassicBatter) as ClassicBatter;hitter.dispatchEvent(new Event(Event.ENTER_FRAME));
                    var upper:DisplayObjectContainer=hitter.getChildByName('hero-upper') as DisplayObjectContainer;
                    var tip:Point=scene.globalToLocal(upper.getChildByName('hero-bat').localToGlobal(new Point()));
                    if(Point.distance(tip,atContact)>65)throw new Error('Derby flight misses bat: '+Point.distance(tip,atContact));
                    shot('v060-derby-contact.png');
                },65);}
            }
        }
        private function shot(name:String):void {
            var b:BitmapData=new BitmapData(960,720,false,0x142e37);b.draw(scene);
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();
        }
        private function finish(value:String,code:int):void {
            removeEventListener(Event.ENTER_FRAME,tick);if(scene)scene.dispose();
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-sprite-derby.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);
        }
    }
}
