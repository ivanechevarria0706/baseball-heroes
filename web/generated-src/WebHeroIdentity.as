package {
    import flash.display.*;import flash.text.*;import flash.events.Event;import flash.geom.Point;import flash.external.ExternalInterface;import com.bh.visual.*;import com.bh.game.*;import com.bh.model.GameData;
    public class WebHeroIdentity extends WebSmoke {
        private var gallery:Sprite=new Sprite(),actors:Array=[],galleryHeads:Array=[];
        private var motion:ClassicBatter,clockTime:int=0;
        private var motionSamples:Array=[];
        private function frozenClock(holder:Object):Function {return function():int{return int(holder.value);};}
        public function WebHeroIdentity(){super();addChild(gallery);ExternalInterface.addCallback("bhHero",hero);}
        private function heads(c:DisplayObjectContainer,out:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is HeroHead)out.push(JSON.parse(HeroHead(d).identity()));else if(d is BatterHead086)out.push(JSON.parse(BatterHead086(d).identity()));else if(d is DisplayObjectContainer)heads(d as DisplayObjectContainer,out);}}
        private function hero(action:String="",arg:int=0):String {
            if(action=="clear"){if(motion){motion.dispose();motion=null;}for each(var oldMotion:ClassicBatter in motionSamples)oldMotion.dispose();motionSamples=[];for each(var old:HeroSprite in actors)old.dispose();for each(var oldHead:HeroHead in galleryHeads)oldHead.dispose();actors=[];galleryHeads=[];while(gallery.numChildren)gallery.removeChildAt(0);gallery.graphics.clear();}
            if(action=="motion-series"){
                hero("clear");gallery.graphics.beginFill(0xe8edf0);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();
                var phases:Array=[0,16,32,64,120,175,250,600,1050,1170,1260,1460];var player:Object=GameData.mainPlayer();
                for(var phase:int=0;phase<phases.length;phase++){
                    var holder:Object={value:0};var actor:ClassicBatter=new ClassicBatter(110+(phase%4)*240,195+int(phase/4)*235,uint(player.accent),8,String(player.name),frozenClock(holder));
                    actor.swing(actor.y-80);actor.queueReaction("HIT");actor.scaleX=actor.scaleY=.65;gallery.addChild(actor);motionSamples.push(actor);
                    for(var at:int=16;at<=phases[phase];at+=16){holder.value=at;actor.dispatchEvent(new Event(Event.ENTER_FRAME));}holder.value=phases[phase];actor.dispatchEvent(new Event(Event.ENTER_FRAME));
                    var time:TextField=new TextField();time.defaultTextFormat=new TextFormat("Arial",16,0x243643,true);time.text=String(phases[phase])+" ms";time.width=150;time.height=24;time.x=84+(phase%4)*240;time.y=199+int(phase/4)*235;gallery.addChild(time);
                }
            }
            if(action=="turns"){
                hero("clear");gallery.graphics.beginFill(0xe8edf0);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();
                for(var turn:int=0;turn<=12;turn++){
                    var same:Object=JSON.parse(JSON.stringify(GameData.heroAppearance()));
                    var direction:HeroHead=new HeroHead(same,HeroArtwork.palette("Hero",0x12699e,same),"",true);
                    direction.setExpression(0);direction.setFacing(turn*15);direction.x=120+(turn%4)*240;direction.y=155+int(turn/4)*175;direction.scaleX=direction.scaleY=.9;gallery.addChild(direction);galleryHeads.push(direction);
                    var degree:TextField=new TextField();degree.defaultTextFormat=new TextFormat("Arial",16,0x243643,true);degree.text=String(turn*15)+"°";degree.width=100;degree.height=24;degree.x=105+(turn%4)*240;degree.y=158+int(turn/4)*175;gallery.addChild(degree);
                }
            }
            if(action=="motion-start"){
                hero("clear");gallery.graphics.beginFill(0xe8edf0);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();clockTime=0;
                var main:Object=GameData.mainPlayer();motion=new ClassicBatter(350,570,uint(main.accent),8,String(main.name),function():int{return clockTime;});gallery.addChild(motion);motion.swing(570+arg);motion.queueReaction("HIT");
            }
            if(action=="motion-step"&&motion){clockTime=arg;motion.dispatchEvent(new Event(Event.ENTER_FRAME));}
            if(action=="poses"||action=="styles"||action=="shapes"||action=="extra-poses"){
                hero("clear");gallery.graphics.beginFill(0xe8edf0);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();
                var p:Object=GameData.mainPlayer();
                for(var j:int=0;j<(action=="poses"?16:8);j++){
                    var a:Object=JSON.parse(JSON.stringify(GameData.heroAppearance()));if(action=="styles")a.hair=j;if(action=="shapes")a.shape=j;
                    var s:HeroSprite=new HeroSprite(String(p.name),uint(p.accent),a,action=="poses"||action=="extra-poses"?"batter":"home",action=="poses"?.52:.95);
                    s.setFrame(action=="poses"?j:action=="extra-poses"?j+16:0);s.x=110+(j%4)*240;s.y=action=="poses"?170+int(j/4)*180:325+int(j/4)*350;gallery.addChild(s);actors.push(s);
                }
            }
            if(action=="contours"){
                hero("clear");gallery.graphics.beginFill(0xe8edf0);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();
                for(var k:int=0;k<8;k++){
                    var shapeAppearance:Object=JSON.parse(JSON.stringify(GameData.heroAppearance()));shapeAppearance.shape=k;
                    var contour:HeroHead=new HeroHead(shapeAppearance,HeroArtwork.palette("Hero",0x12699e,shapeAppearance),"SHAPE");
                    contour.x=120+(k%4)*240;contour.y=220+int(k/4)*340;contour.scaleX=contour.scaleY=1.35;gallery.addChild(contour);galleryHeads.push(contour);
                    var label:TextField=new TextField();label.defaultTextFormat=new TextFormat("Arial",18,0x243643,true);label.text=HeroHead.SHAPE_NAMES[k];label.width=220;label.height=30;label.x=22+(k%4)*240;label.y=240+int(k/4)*340;gallery.addChild(label);
                }
            }
            if(action=="faces"||action=="noses"||action=="mouths"||action=="expressions"){
                hero("clear");gallery.graphics.beginFill(0xe8edf0);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();
                var names:Array=action=="faces"?["Focused","Bright","Calm","Fierce","Sleepy","Sharp","Round","Wide"]:action=="noses"?["Small","Straight","Round","Pointed","Flat","Long","Wide","Button"]:action=="mouths"?["Confident","Smile","Calm","Grin","Serious","Laugh","Relaxed","Cheerful"]:["Neutral","Blink","Disappointed","Celebrate"];
                for(var q:int=0;q<names.length;q++){
                    var variant:Object=JSON.parse(JSON.stringify(GameData.heroAppearance()));
                    if(action=="faces")variant.eyes=q;else if(action=="noses")variant.nose=q;else if(action=="mouths")variant.mouth=q;
                    var sample:HeroHead=new HeroHead(variant,HeroArtwork.palette("Hero",0x12699e,variant));
                    sample.x=120+(q%4)*240;sample.y=220+int(q/4)*340;sample.scaleX=sample.scaleY=1.35;if(action=="expressions")sample.setExpression(q);gallery.addChild(sample);galleryHeads.push(sample);
                    var caption:TextField=new TextField();caption.defaultTextFormat=new TextFormat("Arial",18,0x243643,true);caption.text=names[q];caption.width=220;caption.height=30;caption.x=22+(q%4)*240;caption.y=240+int(q/4)*340;gallery.addChild(caption);
                }
            }
            var identities:Array=[];heads(this,identities);
            var marker:DisplayObject=motion?DisplayObjectContainer(motion.getChildByName("hero-upper")).getChildByName("hero-bat"):null;
            var contact:Point=marker?marker.localToGlobal(new Point()):null;
            return JSON.stringify({appearance:GameData.heroAppearance(),heads:identities,motion:motion?{frame:motion.frameIndex,contactX:contact.x,contactY:contact.y}:null});
        }
    }
}
