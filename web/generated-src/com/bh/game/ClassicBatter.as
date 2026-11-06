package com.bh.game {
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.text.*;
    import flash.utils.getTimer;
    import com.bh.visual.HeroSprite;
    import com.bh.visual.HeroArtwork;
    import com.bh.ui.LineupTypography;

    /** Illustrated poses; gameplay still owns input, timing and hit outcomes. */
    public class ClassicBatter extends Sprite {
        private var upper:Sprite=new Sprite(),batMarker:Sprite=new Sprite(),momentumGlow:Sprite=new Sprite();
        private var art:HeroSprite,jersey:TextField=new TextField();
        private var clock:Function,alive:Boolean=true,progress:Number=0;
        private var swingAt:int=-1,reactionAt:int=-1,swingFinishedAt:int=-1;
        private var reaction:String="",targetContact:Number=-80;
        private var lastPoseAt:int=-1;
        private var contact:Point,contactUntil:int=0,contactAt:int=0,holdMillis:int=0;
        private var swingTrail:Shape=new Shape(),groundShadow:Shape=new Shape(),trailPoints:Array=[];
        private var flames:Array=[],embers:Array=[],maxBadge:Sprite=new Sprite();
        private var momentumTier:int=-1,momentumChance:Boolean=false;
        public function ClassicBatter(px:Number,py:Number,accent:uint=0x215895,number:int=8,playerName:String="Hero",timeSource:Function=null,prewarm:Boolean=true) {
            x=px;y=py;name="classic-batter";mouseEnabled=mouseChildren=false;clock=timeSource!=null?timeSource:getTimer;
            momentumGlow.name="combo-fire";addChild(momentumGlow);addChild(maxBadge);maxBadge.x=-100;maxBadge.y=-36;maxBadge.visible=false;swingTrail.name="bat-motion-trail";addChild(swingTrail);upper.name="hero-upper";addChild(upper);
            art=new HeroSprite(playerName,accent,null,"batter",.67);if(prewarm)art.warmAll();art.name="batter-sprite";upper.addChild(art);
            jersey.defaultTextFormat=new TextFormat("Arial",13,accent,true);jersey.text=String(number);
            jersey.width=29;jersey.height=20;jersey.mouseEnabled=jersey.selectable=false;upper.addChild(jersey);
            batMarker.name="hero-bat";upper.addChild(batMarker);
            groundShadow.name="batter-ground-shadow";groundShadow.graphics.beginFill(0x263326,.20);groundShadow.graphics.drawEllipse(-42,-3,91,12);groundShadow.graphics.endFill();addChildAt(groundShadow,0);
            art.setFrame(6);contact=art.contactPoint();art.setFrame(0);pose(0);addEventListener(Event.ENTER_FRAME,onFrame);
        }
        public function setMomentum(tier:int,chance:Boolean=false):void {
            if(tier==momentumTier&&chance==momentumChance)return;momentumTier=tier;momentumChance=chance;var g:Graphics=momentumGlow.graphics;g.clear();
            while(momentumGlow.numChildren)momentumGlow.removeChildAt(0);flames=[];embers=[];maxBadge.visible=tier==3;
            if(tier==0&&!chance)return;
            var color:uint=tier==3?0xffa52c:chance?0x96ec31:0x48c9ff;
            for(var i:int=5;i>0;i--){g.beginFill(color,.07*(6-i));g.drawEllipse(-48-i*5,-8-i*2,96+i*10,19+i*4);g.endFill();}
            g.lineStyle(3,color,1);g.drawEllipse(-53,-9,106,21);g.lineStyle();
            if(tier!=3)return;
            for(i=0;i<7;i++) {
                var flame:Sprite=new Sprite(),fg:Graphics=flame.graphics;
                flame.x=-54+i*18;flame.y=0;var height:Number=56+(i%3)*14;
                fg.beginFill(0xf34712,.88);fg.moveTo(-13,0);fg.curveTo(-20,-height*.35,-6,-height*.62);fg.curveTo(2,-height*.8,-2,-height);fg.curveTo(20,-height*.60,9,-height*.34);fg.curveTo(24,-6,11,0);fg.endFill();
                fg.beginFill(0xffc62e,.96);fg.moveTo(-7,0);fg.curveTo(-12,-height*.25,1,-height*.69);fg.curveTo(12,-height*.3,7,0);fg.endFill();
                fg.beginFill(0xfff7a5);fg.moveTo(-3,0);fg.curveTo(-5,-12,1,-height*.34);fg.curveTo(7,-12,3,0);fg.endFill();
                flame.cacheAsBitmap=true;momentumGlow.addChild(flame);flames.push(flame);
            }
            for(i=0;i<9;i++){var ember:Sprite=new Sprite();ember.graphics.beginFill(i%2?0xffe45a:0xff7f16);ember.graphics.drawCircle(0,0,2+i%2);ember.graphics.endFill();momentumGlow.addChild(ember);embers.push(ember);}
            maxBadge.graphics.clear();maxBadge.graphics.lineStyle(2,0xffe263);maxBadge.graphics.beginFill(0x93370d,.98);maxBadge.graphics.drawRoundRect(-58,12,116,22,10);maxBadge.graphics.endFill();
            if(maxBadge.numChildren==0){var label:TextField=new TextField();label.defaultTextFormat=new TextFormat("Arial",12,0xfff39a,true,null,null,null,null,"center");label.text="MAX COMBO";LineupTypography.apply(label,12,0xfff39a,"center",true);label.x=-58;label.y=13;label.width=116;label.height=22;label.mouseEnabled=false;maxBadge.addChild(label);}
        }
        public function holdContact(milliseconds:int):void {
            if(!alive)return;var now:int=int(clock());if(swingAt<0)swingAt=now;
            holdMillis=Math.max(0,milliseconds);contactAt=swingAt+SwingMotion.CONTACT_MS;contactUntil=contactAt+holdMillis;
        }
        public function get contactDelay():int {return Math.max(0,contactAt-int(clock()));}
        public function contactPosition():Point {return contactAt>int(clock())?aimedContactPosition():parent.globalToLocal(batMarker.localToGlobal(new Point()));}
        private function contactRotation(aim:Number):Number {
            var radius:Number=Math.sqrt(contact.x*contact.x+contact.y*contact.y),reach:Number=Math.max(-.98,Math.min(.98,aim/Math.max(1,radius)));
            return Math.max(-6,Math.min(6,(Math.asin(reach)-Math.atan2(contact.y,contact.x))*180/Math.PI));
        }
        public function aimedContactPosition(targetY:Number=NaN):Point {
            var aim:Number=isNaN(targetY)?targetContact:Math.max(-116,Math.min(-48,(targetY-y)/Math.max(.01,scaleY)));
            var angle:Number=contactRotation(aim)*Math.PI/180,foot:Point=art.swingAnchor(6,"plant"),fixed:Point=art.swingAnchor(4,"plant");
            var px:Number=fixed.x-foot.x*Math.cos(angle)+foot.y*Math.sin(angle),py:Number=fixed.y-foot.x*Math.sin(angle)-foot.y*Math.cos(angle);
            return parent.globalToLocal(localToGlobal(new Point(px+contact.x*Math.cos(angle)-contact.y*Math.sin(angle),py+contact.x*Math.sin(angle)+contact.y*Math.cos(angle))));
        }
        public function get contactHeld():Boolean {return int(clock())>=contactAt&&int(clock())<contactUntil;}
        public function get frameIndex():int {return art.frameIndex;}
        public function setPitchProgress(value:Number):void {
            if(!alive)return;progress=Math.max(0,Math.min(1,value));
            if(value==0&&swingAt<0){reaction="";reactionAt=-1;swingFinishedAt=-1;}
        }
        public function swing(targetY:Number=NaN):void {
            if(!alive||swingAt>=0)return;
            targetContact=isNaN(targetY)?-80:Math.max(-116,Math.min(-48,(targetY-y)/Math.max(.01,scaleY)));
            swingAt=int(clock());contactAt=swingAt+SwingMotion.CONTACT_MS;contactUntil=0;holdMillis=0;reaction="";reactionAt=swingFinishedAt=-1;trailPoints=[];swingTrail.graphics.clear();pose(4);
        }
        public function resetReady():void {swingAt=reactionAt=swingFinishedAt=-1;contactAt=contactUntil=holdMillis=0;progress=0;reaction="";trailPoints=[];swingTrail.graphics.clear();pose(0);}
        public function queueReaction(result:String):void {if(!alive)return;reaction=result;reactionAt=int(clock());}
        private function smooth(value:Number):Number {value=Math.max(0,Math.min(1,value));return value*value*(3-2*value);}
        private function placement(frame:int,aim:Number,now:int):Object {
            var angle:Number=contactRotation(targetContact)*aim;
            if(art.hasReferenceBatter&&frame<4)angle+=Math.sin(now/700)*.65;
            var radians:Number=angle*Math.PI/180,px:Number=0,py:Number=0;
            if(art.hasReferenceBatter||SwingMotion.planted(frame)){
                var key:String=art.hasReferenceBatter?art.supportKey(frame):"plant",foot:Point=art.swingAnchor(frame,key),fixed:Point=art.swingAnchor(key=="rear"?0:4,key);
                px=fixed.x-foot.x*Math.cos(radians)+foot.y*Math.sin(radians);py=fixed.y-foot.x*Math.sin(radians)-foot.y*Math.cos(radians);
            }
            return {x:px,y:py,angle:angle};
        }
        private function swingAim(age:int):Number {var effective:int=age>SwingMotion.CONTACT_MS?Math.max(SwingMotion.CONTACT_MS,age-holdMillis):age;return smooth(age/SwingMotion.CONTACT_MS)*(1-smooth((effective-300)/320));}
        private function trailPoint(age:int):Point {var f:int=SwingMotion.frame(age,holdMillis),at:Object=placement(f,swingAim(age),swingAt+age),tip:Point=art.swingAnchor(f,"tip"),a:Number=at.angle*Math.PI/180;return new Point(at.x+tip.x*Math.cos(a)-tip.y*Math.sin(a),at.y+tip.x*Math.sin(a)+tip.y*Math.cos(a));}
        private function pose(frame:int,aim:Number=0):void {
            // Feet remain the pivot. Load, rotation and recovery move together,
            // including the contact marker, number and all worn accessories.
            upper.rotation=0;art.setFrame(frame,true);var now:int=int(clock());art.advanceHead(lastPoseAt<0?0:now-lastPoseAt);lastPoseAt=now;
            var at:Object=placement(frame,aim,now),angle:Number=at.angle,radians:Number=angle*Math.PI/180;
            art.rotation=angle;art.x=at.x;art.y=at.y;
            groundShadow.x=art.hasReferenceBatter&&frame==3?art.swingAnchor(0,"rear").x:0;groundShadow.scaleX=art.hasReferenceBatter&&frame==3?.62:1;momentumGlow.x=groundShadow.x;
            var barrel:Point=art.swingAnchor(frame,"contact");batMarker.x=art.x+barrel.x*Math.cos(radians)-barrel.y*Math.sin(radians);batMarker.y=art.y+barrel.x*Math.sin(radians)+barrel.y*Math.cos(radians);
            jersey.visible=!art.hasReferenceBatter&&(frame<=5||frame==13||frame==16||frame==17||frame==22||frame==23);
            var jerseyY:Number=frame>=16?-84:frame==3||frame==4?-96:-80;
            jersey.x=art.x-8*Math.cos(radians)-jerseyY*Math.sin(radians);
            jersey.y=art.y-8*Math.sin(radians)+jerseyY*Math.cos(radians);jersey.rotation=art.rotation;
        }
        private function onFrame(e:Event):void {
            if(!alive)return;var now:int=int(clock());
            if(momentumTier==3){
                for(var i:int=0;i<flames.length;i++){flames[i].scaleY=.84+.20*Math.sin(now/105+i*1.8);flames[i].alpha=.85+.15*Math.sin(now/90+i);}
                for(i=0;i<embers.length;i++){var life:Number=(now/650+i/9)%1;embers[i].x=-65+i*16+Math.sin(now/240+i)*7;embers[i].y=-life*105;embers[i].alpha=1-life;}
                maxBadge.alpha=.85+.15*Math.sin(now/150);
            }
            if(now>=contactAt&&now<contactUntil){trailPoints=[];swingTrail.graphics.clear();pose(6,1);return;}
            // Do not flash READY between the follow-through and its result reaction.
            if(swingAt>=0&&now-swingAt>=SwingMotion.END_MS+holdMillis){swingFinishedAt=swingAt+SwingMotion.END_MS+holdMillis;swingAt=-1;progress=0;swingTrail.graphics.clear();}
            if(swingAt>=0) {
                var age:int=now-swingAt;
                var frame:int=SwingMotion.frame(age,holdMillis);
                var aim:Number=swingAim(age);
                pose(frame,aim);
                swingTrail.graphics.clear();
                if(age>=34&&age<holdMillis+300){
                    trailPoints=[];for(var look:int=72;look>=0;look-=18){var sample:int=age-look;if(sample>=0&&!(sample>=SwingMotion.CONTACT_MS&&sample<SwingMotion.CONTACT_MS+holdMillis+45))trailPoints.push(trailPoint(sample));}
                    for(var ti:int=1;ti<trailPoints.length;ti++){swingTrail.graphics.lineStyle(2+ti,0xffefb9,.04+ti*.045);swingTrail.graphics.moveTo(trailPoints[ti-1].x,trailPoints[ti-1].y);swingTrail.graphics.lineTo(trailPoints[ti].x,trailPoints[ti].y);}swingTrail.graphics.lineStyle();
                }
                return;
            }
            var elapsed:int=now-Math.max(reactionAt,swingFinishedAt);
            var sad:Boolean=reaction=="OUT"||reaction=="STRIKEOUT"||reaction=="STRIKE OUT"||reaction=="MISS";
            var happy:Boolean=["HIT","SINGLE","DOUBLE","TRIPLE","HOME RUN"].indexOf(reaction)>=0;
            if(reactionAt>=0&&elapsed>=0&&elapsed<1200&&(sad||happy)) {
                pose(sad?(elapsed<850?12:13):(elapsed<850?14:15));return;
            }
            var load:int=progress<.22?int(now/650)%2:progress<.42?2:progress<.86?3:4;
            if(art.hasReferenceBatter)load=progress<.42?0:3;
            pose(load);
        }
        public function dispose():void {if(!alive)return;alive=false;removeEventListener(Event.ENTER_FRAME,onFrame);art.dispose();}
    }
}
