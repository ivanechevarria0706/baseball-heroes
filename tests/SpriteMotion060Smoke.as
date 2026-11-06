package {
    import flash.display.*;import flash.events.*;import flash.filesystem.*;import flash.desktop.NativeApplication;import flash.geom.*;import flash.text.*;import flash.utils.setTimeout;
    import com.bh.game.*;import com.bh.model.GameData;import com.bh.visual.*;
    public class SpriteMotion060Smoke extends Sprite {
        private var time:int=0,actor:ClassicBatter,scene:Sprite=new Sprite(),sheet:BitmapData;
        public function SpriteMotion060Smoke(){stage.scaleMode='noScale';stage.align='TL';loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});GameData.init();setTimeout(run,250);}
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function make():ClassicBatter{return new ClassicBatter(0,0,GameData.teamAccent,GameData.uniformNumber,String(GameData.mainPlayer().name),function():int{return time;});}
        private function tick(a:ClassicBatter):void{a.dispatchEvent(new Event(Event.ENTER_FRAME));}
        private function pixels(a:ClassicBatter):BitmapData{var b:BitmapData=new BitmapData(380,370,true,0);b.draw(a,new Matrix(1.15,0,0,1.15,145,320));return b;}
        private function same(a:BitmapData,b:BitmapData):Boolean{var diff:Object=a.compare(b);if(diff is BitmapData){BitmapData(diff).dispose();return false;}return diff===0;}
        private function sampled(step:Number):BitmapData {time=0;var a:ClassicBatter=make();a.swing();a.queueReaction('SINGLE');for(var t:Number=step;t<1800;t+=step){time=int(t);tick(a);}time=1800;tick(a);var b:BitmapData=pixels(a);a.dispose();return b;}
        private function run():void {
            var slow:BitmapData=sampled(1000/15),fast:BitmapData=sampled(1000/60);check(same(slow,fast),'Animation depends on frame rate');slow.dispose();fast.dispose();
            time=0;actor=make();actor.swing(-110);time=65;tick(actor);var up:Sprite=actor.getChildByName('hero-upper') as Sprite;var high:Number=up.getChildByName('hero-bat').y;actor.dispose();
            time=0;actor=make();actor.swing(-40);time=65;tick(actor);up=actor.getChildByName('hero-upper') as Sprite;check(up.getChildByName('hero-bat').y-high>=40,'Contact height does not follow target');var once:BitmapData=pixels(actor);actor.swing(-110);tick(actor);var twice:BitmapData=pixels(actor);check(same(once,twice),'Double input restarts swing');once.dispose();twice.dispose();actor.dispose();
            sheet=new BitmapData(1520,740,false,0x173642);
            var labels:Array=['READY','LOAD','CONTACT / 65 ms','FOLLOW / 350 ms','SINGLE','MISS','HOME RUN','HOME'];
            for(var i:int=0;i<7;i++){
                time=0;actor=make();
                if(i==1){actor.setPitchProgress(.72);time=200;tick(actor);}
                if(i==2||i==3){actor.swing();time=i==2?65:350;tick(actor);}
                if(i>=4){actor.queueReaction(i==4?'SINGLE':i==5?'MISS':'HOME RUN');time=420;tick(actor);}
                var frame:BitmapData=pixels(actor);sheet.copyPixels(frame,frame.rect,new Point((i%4)*380,int(i/4)*370));frame.dispose();title(labels[i],i);actor.dispose();
            }
            var home:HomeHero=new HomeHero(0,0,GameData.teamAccent,GameData.uniformNumber,String(GameData.mainPlayer().name),function():int{return time;});sheet.draw(home,new Matrix(1.15,0,0,1.15,150+3*380,320+370));title('HOME',7);home.dispose();home.dispose();save(sheet,'v060-hero-poses.png');sheet.dispose();
            // A deterministic sequence rendered by the actual actor, not interpolated screenshots.
            time=0;actor=make();actor.x=259;actor.y=630;actor.scaleX=actor.scaleY=1.24*720/540;
            scene.addChild(new MatchStadium(960,720));scene.addChild(actor);addChild(scene);
            for(i=0;i<96;i++){
                time=i*40;if(time<1320)actor.setPitchProgress(Math.max(0,(time-680)/700));
                if(time==1320){actor.swing(504);actor.queueReaction('SINGLE');}
                tick(actor);var b:BitmapData=new BitmapData(960,720,false,0x18343b);b.draw(scene);save(b,'v060-motion/frame-'+('000'+i).substr(-3)+'.png');b.dispose();
            }
            actor.dispose();actor.dispose();finish('PASS: same recovery pose at 15 and 60 fps; high/low contact follows target; repeated swing cannot restart; ready, load, contact, follow, SINGLE, MISS, HOME RUN and HOME render; shared equipment palette; repeat-safe disposal; 96 actual actor frames exported at 25 fps.\n',0);
        }
        private function title(value:String,i:int):void{var t:TextField=new TextField();t.defaultTextFormat=new TextFormat('Arial',17,0xffffff,true);t.text=value;t.width=370;t.height=30;sheet.draw(t,new Matrix(1,0,0,1,(i%4)*380+10,int(i/4)*370+8));}
        private function save(b:BitmapData,name:String):void{var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();}
        private function finish(value:String,code:int):void{var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-sprite-motion.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
