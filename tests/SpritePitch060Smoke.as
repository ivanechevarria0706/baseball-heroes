package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.setTimeout;
    import com.bh.game.*;
    import com.bh.model.GameData;
    public class SpritePitch060Smoke extends Sprite {
        private var time:int=0;
        private var sheet:BitmapData;
        private var pitcher:Pitcher;
        private var checks:Array=[];
        public function SpritePitch060Smoke(){
            stage.scaleMode='noScale';stage.align='TL';
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            setTimeout(run,200);
        }
        private function now():int{return time;}
        private function tick(d:DisplayObject):void {d.dispatchEvent(new Event(Event.ENTER_FRAME));}
        private function assert(value:Boolean,message:String):void {if(!value)throw new Error(message);}
        private function near(a:Number,b:Number):Boolean{return Math.abs(a-b)<.001;}
        private function findName(c:DisplayObjectContainer,name:String):DisplayObject {
            for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==name)return d;
                if(d is DisplayObjectContainer){var f:DisplayObject=findName(d as DisplayObjectContainer,name);if(f)return f;}}
            return null;
        }
        private function textOf(c:DisplayObjectContainer):String {
            var s:String='';for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is TextField)s+=TextField(d).text;else if(d is DisplayObjectContainer)s+=textOf(d as DisplayObjectContainer);}return s;
        }
        private function capturePose(i:int,title:String):void {
            sheet.draw(pitcher,new Matrix(1.45,0,0,1.45,155+(i%4)*310,220+int(i/4)*310));
            var label:TextField=new TextField();label.defaultTextFormat=new TextFormat('Arial',15,0xffffff,true);label.text=title;label.width=305;label.height=24;
            sheet.draw(label,new Matrix(1,0,0,1,10+(i%4)*310,8+int(i/4)*310));
        }
        private function save(name:String,data:BitmapData):void {
            var file:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);
            file.parent.createDirectory();var stream:FileStream=new FileStream();stream.open(file,FileMode.WRITE);stream.writeBytes(data.encode(data.rect,new PNGEncoderOptions()));stream.close();
        }
        private function shot(name:String,d:DisplayObject):void {var b:BitmapData=new BitmapData(960,540,false,0x143427);b.draw(d);save(name,b);b.dispose();}
        private function run():void {
            GameData.init();
            pitcher=new Pitcher(0,0,0x514784,'QA Pitcher',now);addChild(pitcher);
            sheet=new BitmapData(1240,620,false,0x16303e);
            capturePose(0,'SET');pitcher.throwPitch(.8);
            time=380;tick(pitcher);capturePose(1,'KNEE LIFT / 380 ms');
            time=600;tick(pitcher);capturePose(2,'STRIDE / 600 ms');
            time=760;tick(pitcher);capturePose(3,'ARM ACCELERATION / 760 ms');
            time=800;tick(pitcher);capturePose(4,'RELEASE / 800 ms');
            var held:DisplayObject=findName(pitcher,'held-ball');assert(held&&held.visible,'No held ball before release');
            // Nested/scaled transforms must still hand the flight system the exact ball centre.
            pitcher.x=71;pitcher.y=40;pitcher.scaleX=pitcher.scaleY=.63;pitcher.rotation=4;
            var expected:Point=globalToLocal(held.localToGlobal(new Point()));
            var released:Point=pitcher.releasePosition();
            assert(near(expected.x,released.x)&&near(expected.y,released.y),'Release does not match the visible hand');
            assert(!held.visible,'Ball duplicated in hand after release');
            time=960;tick(pitcher);var repeated:Point=pitcher.releasePosition();
            assert(near(released.x,repeated.x)&&near(released.y,repeated.y),'Repeated release changed origin');
            pitcher.x=pitcher.y=pitcher.rotation=0;pitcher.scaleX=pitcher.scaleY=1;
            capturePose(5,'FOLLOW THROUGH / 960 ms');
            time=1450;tick(pitcher);capturePose(6,'RECOVERED');
            pitcher.setFieldingMode(true);pitcher.reactHit();time=1700;tick(pitcher);capturePose(7,'FIELDER REACTION');
            save('v060-pitcher-poses.png',sheet);sheet.dispose();pitcher.dispose();pitcher.dispose();removeChild(pitcher);
            // A delayed render holds the release pose until the game takes the ball.
            time=0;var late:Pitcher=new Pitcher(0,0,0x514784,'QA Pitcher',now);addChild(late);late.throwPitch(.8);
            time=1250;tick(late);held=findName(late,'held-ball');expected=globalToLocal(held.localToGlobal(new Point()));released=late.releasePosition();
            assert(near(expected.x,released.x)&&near(expected.y,released.y),'Late frame moved the release away from the hand');late.dispose();removeChild(late);
            checks.push('PASS: pitcher poses render; transformed hand-to-ball release, one ball after release, stable repeated release and delayed-frame release.');
            physics();cinematics();
            finish(checks.join('\n')+'\n',0);
        }
        private function physics():void {
            var endpoints:Array=[[0,0],[55,32],[-50,-29]];
            var b:Ball=new Ball(0,0,now,function():Number{return .5;});addChild(b);
            for each(var curve:Array in endpoints){
                b.setProgress(0,420,270,490,410,curve[0],curve[1]);assert(near(b.x,420)&&near(b.y,270),'Pitch origin mismatch');
                b.setProgress(1,420,270,490,410,curve[0],curve[1]);assert(near(b.x,490)&&near(b.y,410),'Breaking pitch missed its target');
            }
            var states:Array=[];
            for each(var fps:int in [15,30,60]){
                time=0;b.reset(480,410);b.setProgress(1,420,270,480,410);b.launchHit('GOOD',80);
                for(var f:int=1;f<=fps;f++){time=int(f*1000/fps);tick(b);}
                states.push([b.x,b.y,b.scaleX,b.rotation]);
            }
            for(var i:int=1;i<states.length;i++)for(var j:int=0;j<4;j++)assert(near(states[0][j],states[i][j]),'Hit trajectory depends on frame rate');
            time=3000;tick(b);assert(!b.visible,'Hit never expired');b.reset(11,17);tick(b);assert(b.visible&&b.x==11&&b.y==17,'Old hit animation leaked into reset');
            b.dispose();removeChild(b);
            var e:ContactEffect=new ContactEffect(now);addChild(e);var effects:Array=[];
            for each(fps in [15,30,60]){time=0;e.burst(100,100,'GOOD');for(f=1;f<=fps/3;f++){time=int(f*1000/fps);tick(e);}time=333;tick(e);effects.push([e.scaleX,e.alpha,e.rotation]);}
            for(i=1;i<effects.length;i++)for(j=0;j<3;j++)assert(near(effects[0][j],effects[i][j]),'Contact flash depends on frame rate');
            time=900;tick(e);assert(!e.visible,'Contact flash never expired');e.dispose();removeChild(e);
            checks.push('PASS: straight/breaking pitches preserve start and target; hit and contact effect agree at 15/30/60 fps; animation reset and expiry.');
        }
        private function cinematics():void {
            var c:HitCinematic=new HitCinematic(960,540,now);addChild(c);
            for each(var kind:String in ['SINGLE','DOUBLE','TRIPLE','HOME RUN','FLY OUT','GROUND OUT','STRIKE OUT']){
                time=0;c.play(kind,1,280);assert(!c.canContinue(),'Cinematic starts ready');
                time=450;tick(c);if(kind=='DOUBLE')shot('v060-ball-tracking.png',c);
                time=1800;tick(c);assert(textOf(c).indexOf(kind=='SINGLE'?'ONE BASE HIT':kind=='DOUBLE'?'TWO BASE HIT':kind=='TRIPLE'?'THREE BASE HIT':kind)>=0,'Skipped result threshold: '+kind);
                time=3100;tick(c);assert(c.canContinue(),'Skipped continuation threshold: '+kind);c.clear();
            }
            time=0;c.play('SINGLE',0,170);time=200;c.forceResultVisible();
            assert(!c.canContinue(),'Fast-forward skipped result display beat');
            time=1200;tick(c);assert(!c.canContinue(),'Result beat ended too early');
            c.forceResultVisible();time=1310;tick(c);assert(c.canContinue(),'Repeated fast-forward postponed continuation');
            c.forceResultVisible();assert(c.canContinue(),'Fast-forward locked completed result');c.dispose();removeChild(c);
            checks.push('PASS: seven result types survive skipped frames; grass tracking render; fast-forward preserves its result beat and cannot lock completed playback.');
        }
        private function finish(value:String,code:int):void {
            var file:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-sprite-pitch.txt');file.parent.createDirectory();
            var stream:FileStream=new FileStream();stream.open(file,FileMode.WRITE);stream.writeUTFBytes(value);stream.close();NativeApplication.nativeApplication.exit(code);
        }
    }
}
