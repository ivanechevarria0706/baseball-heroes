package {
    import flash.display.*;
    import flash.events.*;
    import flash.text.TextField;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.utils.*;
    import com.bh.model.GameData;
    import com.bh.core.Game;
    import com.bh.game.Ball;
    import com.bh.game.HitCinematic;
    import com.bh.game.GameplayCallout;
    import com.bh.ui.Hud;
    import com.bh.audio.AudioManager;
    public class ContactSmoke extends Sprite {
        private var game:Game;
        private var ball:Ball;
        private var cine:HitCinematic;
        private var callout:GameplayCallout;
        private var mode:String='ready';
        private var contactAt:int;
        private var retries:int=0;
        public function ContactSmoke() {
            stage.scaleMode='noScale';stage.align='TL';stage.frameRate=60;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{
                e.preventDefault();finish('FAIL: '+e.error,1);
            });
            AudioManager.setSfxVolume(0);GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
            game=new Game(960,540,noop,noop);addChild(game);
            ball=find(game,Ball) as Ball;cine=find(game,HitCinematic) as HitCinematic;callout=find(game,GameplayCallout) as GameplayCallout;
            addEventListener(Event.ENTER_FRAME,tick);
            setTimeout(function():void{finish('FAIL: contact test timeout '+mode,1);},60000);
        }
        private function find(c:DisplayObjectContainer,type:Class):DisplayObject {
            for(var i:int=0;i<c.numChildren;i++){
                var d:DisplayObject=c.getChildAt(i);if(d is type)return d;
                if(d is DisplayObjectContainer){var found:DisplayObject=find(d as DisplayObjectContainer,type);if(found)return found;}
            }return null;
        }
        private function textOf(c:DisplayObjectContainer):String {
            var s:String='';for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);
                if(d is TextField)s+=TextField(d).text;else if(d is DisplayObjectContainer)s+=textOf(d as DisplayObjectContainer);}
            return s;
        }
        private function key(code:int):void {stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,code));}
        private function tick(e:Event):void {
            var hud:Hud=find(game,Hud) as Hud;
            if(mode=='ready'&&hud.visible&&textOf(hud).indexOf('READY')>=0){mode='pitch';key(32);return;}
            if(mode=='pitch'&&ball.visible){
                // Observe the actual rendered perspective, then exercise the real SPACE input.
                var progress:Number=Math.sqrt(Math.max(0,(ball.scaleX-.27)/2.55));
                if(progress>=.905&&progress<=.95){
                    key(32);
                    if(!callout.visible||textOf(callout).indexOf('NICE')<0){
                        if(retries++>3)throw new Error('Unable to reach a good contact through real input');
                        mode='ready';return;
                    }
                    contactAt=getTimer();mode='hold';shot('contact-field');
                    if(cine.visible||!ball.parent.visible)throw new Error('Contact skipped the batting view');
                }
            } else if(mode=='hold'&&getTimer()-contactAt>=700){
                key(13);key(32);key(13);
                if(cine.visible||!ball.parent.visible||!callout.visible)throw new Error('Repeated input skipped the contact hold');
                var label:TextField=find(callout,TextField) as TextField;
                if(label.textColor!=0xd8fbff||Math.abs(callout.rotation+8)>.1)throw new Error('NICE styling mismatch: '+label.textColor.toString(16)+' / '+callout.rotation);
                var rendered:Bitmap=find(callout,Bitmap) as Bitmap;
                if(!rendered||!rendered.bitmapData||rendered.bitmapData.getColorBoundsRect(0xff000000,0,false).isEmpty())throw new Error('NICE did not render visible pixels');
                shot('contact-hold');mode='transition';
            } else if(mode=='transition'&&cine.visible){
                var elapsed:int=getTimer()-contactAt;
                if(elapsed<1190||elapsed>2000)throw new Error('Incorrect camera delay '+elapsed);
                if(ball.parent.visible)throw new Error('Field did not hide at cinematic start');
                shot('contact-tracking');key(13);
                if(textOf(cine).length==0)throw new Error('ENTER no longer reveals result');
                shot('contact-result');
                mode='result';
            } else if(mode=='result'&&cine.canContinue()){
                key(13);mode='continued';
                if(cine.visible)throw new Error('Result did not clear after second ENTER');
                finish('PASS: real SPACE contact holds field and NICE through 700 ms; repeated ENTER/SPACE cannot skip; camera begins after 1200 ms; ENTER reveals result and continues after its display beat; isolated save.\n',0);
            }
        }
        private function shot(name:String):void {
            var b:BitmapData=new BitmapData(960,540,false,0x102b3a);b.draw(game);
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/v052-'+name+'.png');f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();
        }
        private function finish(value:String,code:int):void {
            removeEventListener(Event.ENTER_FRAME,tick);
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-contact.txt');f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();if(game)game.dispose();
            NativeApplication.nativeApplication.exit(code);
        }
        private function noop(...args):void {}
    }
}
