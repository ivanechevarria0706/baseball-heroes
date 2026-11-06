package com.bh.game {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.getTimer;

    public class Ball extends Sprite {
        private var leather:Sprite=new Sprite();
        private var rim:Sprite=new Sprite();
        private var trail:Sprite=new Sprite();
        private var clock:Function;
        private var nextRandom:Function;
        private var hitAnimating:Boolean=false;
        private var hitStarted:int=0,impactAt:int=0,approachStart:int=0,approachMs:int=0;
        private var approachX:Number=0,approachY:Number=0;
        private var startX:Number,startY:Number,startScale:Number,startRotation:Number;
        private var hitVx:Number=0,hitVy:Number=0;
        private const DRAG:Number=.1503762547; // -30 * log(.995), matching the old 30 fps feel.

        public function Ball(px:Number,py:Number,timeSource:Function=null,randomSource:Function=null) {
            mouseEnabled=false;mouseChildren=false;
            clock=timeSource!=null?timeSource:getTimer;nextRandom=randomSource!=null?randomSource:Math.random;
            addChild(trail);addChild(rim);addChild(leather);BaseballArt.draw(leather.graphics,9);
            rim.graphics.lineStyle(2,0x173c37,.85);rim.graphics.drawCircle(0,0,10.4);rim.graphics.lineStyle(1.5,0xfff2aa,.8);rim.graphics.drawCircle(0,0,11.6);rim.mouseEnabled=false;reset(px,py);
        }
        public function hideBall():void {stopHitAnimation();visible=false;trail.graphics.clear();}
        public function reset(px:Number,py:Number):void {
            stopHitAnimation();x=px;y=py;visible=true;alpha=1;rotation=0;
            scaleX=scaleY=.54;trail.graphics.clear();
        }
        private function position(t:Number,sx:Number,sy:Number,ex:Number,ey:Number,curve:Number,vertical:Number):Point {
            // Depth advances continuously; the displayed ball reaches the target at the scoring instant.
            var q:Number=t/BattingSystem.IDEAL_CONTACT,depth:Number=Math.pow(q,1.28);
            var envelope:Number=Math.sin(Math.min(1,q)*Math.PI);
            return new Point(sx+(ex-sx)*depth+curve*envelope*(.35+q*.65),
                sy+(ey-sy)*depth+vertical*envelope*q*q+envelope*Math.min(8,Math.abs(curve)*.08));
        }
        public function setProgress(t:Number,sx:Number,sy:Number,ex:Number,ey:Number,curveStrength:Number=0,verticalBreak:Number=0):void {
            t=Math.max(0,Math.min(1.2,t));
            var p:Point=position(t,sx,sy,ex,ey,curveStrength,verticalBreak);
            var behind:Point=position(Math.max(0,t-.055),sx,sy,ex,ey,curveStrength,verticalBreak);
            var q:Number=t/BattingSystem.IDEAL_CONTACT;
            x=p.x;y=p.y;scaleX=scaleY=Math.min(2.3,.54+1.31*Math.pow(q,1.4));rotation=t*430;
            drawTrail(p.x-behind.x,p.y-behind.y,t>.30?.30:0);
        }
        private function drawTrail(dx:Number,dy:Number,opacity:Number):void {
            var g:*=trail.graphics;g.clear();
            var length:Number=Math.sqrt(dx*dx+dy*dy);
            if(opacity<=0||length<1)return;
            // Cancel the ball's spin and scale so the tail always follows its path.
            var angle:Number=-rotation*Math.PI/180;
            var tx:Number=(-dx*Math.cos(angle)+dy*Math.sin(angle))/scaleX;
            var ty:Number=(-dx*Math.sin(angle)-dy*Math.cos(angle))/scaleY;
            var localLength:Number=Math.sqrt(tx*tx+ty*ty);
            var nx:Number=-ty/localLength*5.5,ny:Number=tx/localLength*5.5;
            g.lineStyle(.6,0x245f52,opacity*.8);g.beginFill(0xffe19a,opacity);g.moveTo(nx,ny);g.curveTo(tx*.6+nx,ty*.6+ny,tx,ty);g.curveTo(tx*.6-nx,ty*.6-ny,-nx,-ny);g.lineTo(nx,ny);g.endFill();
            g.lineStyle();g.beginFill(0xffffff,opacity*.8);g.moveTo(nx*.45,ny*.45);g.lineTo(tx*.7,ty*.7);g.lineTo(-nx*.45,-ny*.45);g.endFill();
        }
        public function launchHit(result:String,power:int=70,holdMs:int=0,leadMs:int=0,impactX:Number=NaN,impactY:Number=NaN):void {
            stopHitAnimation();hitAnimating=true;approachStart=int(clock());approachMs=Math.max(0,leadMs);impactAt=approachStart+approachMs;hitStarted=impactAt+Math.max(0,holdMs);approachX=x;approachY=y;
            startX=isNaN(impactX)?x:impactX;startY=isNaN(impactY)?y:impactY;startScale=scaleX;startRotation=rotation;
            power=Math.max(40,Math.min(99,power));var factor:Number=.70+power/250;
            if(result=='PERFECT'){hitVx=(4+nextRandom()*3)*factor*30;hitVy=(-12.5-nextRandom()*2)*factor*30;}
            else if(result=='GOOD'){hitVx=(3+nextRandom()*3)*factor*30;hitVy=(-10-nextRandom()*2)*factor*30;}
            else{hitVx=(8+nextRandom()*3)*Math.min(1.05,factor)*30;hitVy=-6.7*30;}
            addEventListener(Event.ENTER_FRAME,onHitFrame);
        }
        private function hitPosition(seconds:Number):Point {
            return new Point(startX+hitVx*(1-Math.exp(-DRAG*seconds))/DRAG,startY+hitVy*seconds+171*seconds*seconds);
        }
        private function onHitFrame(e:Event):void {
            var now:int=int(clock());
            if(now<impactAt){var progress:Number=Math.max(0,(now-approachStart)/Math.max(1,approachMs));x=approachX+(startX-approachX)*progress;y=approachY+(startY-approachY)*progress;return;}
            var t:Number=Math.max(0,(now-hitStarted)/1000);
            var p:Point=hitPosition(t),behind:Point=hitPosition(Math.max(0,t-.12));
            x=p.x;y=p.y;rotation=startRotation+t*810;
            scaleX=scaleY=startScale*Math.pow(.993,t*30);
            drawTrail(p.x-behind.x,p.y-behind.y,.62);
            if(t>=82/30||y>650||x>1150||x< -180)hideBall();
        }
        private function stopHitAnimation():void {
            if(hitAnimating)removeEventListener(Event.ENTER_FRAME,onHitFrame);hitAnimating=false;
        }
        public function get contactHeld():Boolean {return hitAnimating&&int(clock())>=impactAt&&int(clock())<hitStarted;}
        public function dispose():void {hideBall();}
    }
}
