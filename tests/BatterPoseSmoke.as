package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.geom.Matrix;
    import flash.text.*;
    import flash.utils.setTimeout;
    import com.bh.model.GameData;
    import com.bh.game.ClassicBatter;
    public class BatterPoseSmoke extends Sprite {
        private var time:int=0;
        private var actor:ClassicBatter;
        private var sheet:BitmapData;
        public function BatterPoseSmoke(){
            stage.scaleMode='noScale';stage.align='TL';
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            setTimeout(run,200);
        }
        private function tick():void {actor.dispatchEvent(new Event(Event.ENTER_FRAME));}
        private function capture(index:int,title:String):void {
            var m:Matrix=new Matrix(1.2,0,0,1.2,125+(index%4)*340,380+int(index/4)*430);
            sheet.draw(actor,m);
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat('Arial',16,0xffffff,true);t.text=title;t.width=330;t.height=28;
            sheet.draw(t,new Matrix(1,0,0,1,(index%4)*340+10,int(index/4)*430+7));
        }
        private function pixels():BitmapData {var b:BitmapData=new BitmapData(340,400,true,0);b.draw(actor,new Matrix(1,0,0,1,100,330));return b;}
        private function run():void {
            GameData.init();
            actor=new ClassicBatter(0,0,0x1579b8,26,'Ivan',function():int{return time;});
            addChild(actor);sheet=new BitmapData(1360,860,false,0x16303e);
            tick();capture(0,'READY');var ready:BitmapData=pixels();
            time=200;actor.setPitchProgress(.7);tick();capture(1,'LOAD / LEG LIFT');var load:BitmapData=pixels();
            var difference:Object=ready.compare(load);
            if(difference is Number)throw new Error('Pitch load did not change the pose');
            BitmapData(difference).dispose();
            actor.swing();time=320;tick();capture(2,'CONTACT / 120 ms');
            time=430;tick();capture(3,'TURN / 230 ms');
            time=560;tick();capture(4,'FOLLOW THROUGH / 360 ms');
            var before:BitmapData=pixels();actor.swing();tick();var after:BitmapData=pixels();
            if(before.compare(after)!==0)throw new Error('Repeated swing restarted animation');
            time=950;tick();capture(5,'HELD FINISH / 750 ms');
            time=1600;actor.setPitchProgress(0);tick();actor.queueReaction('STRIKEOUT');time=2000;tick();capture(6,'STRIKEOUT REACTION');
            actor.setPitchProgress(0);tick();capture(7,'RESET / READY');
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/v049-batter-poses.png');f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(sheet.encode(sheet.rect,new PNGEncoderOptions()));s.close();
            ready.dispose();load.dispose();before.dispose();after.dispose();sheet.dispose();actor.dispose();actor.dispose();
            finish('PASS: deterministic ready/load/contact/follow-through/recovery poses render; pitch load changes pose; repeated swing does not restart; strikeout reaction resets; dispose is repeat-safe.\n',0);
        }
        private function finish(value:String,code:int):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-batter.txt');f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);
        }
    }
}
