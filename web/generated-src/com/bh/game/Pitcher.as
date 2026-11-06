package com.bh.game {
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.getTimer;
    import com.bh.visual.PitcherBodySprite;
    import com.bh.visual.FieldingSprite;

    /** Set/lift/stride/release/follow poses share a clock with the gameplay. */
    public class Pitcher extends Sprite {
        private var fieldArt:FieldingSprite,uniform:uint,actorName:String,identity:Object;
        private var art:PitcherBodySprite,heldBall:Sprite=new Sprite();
        private var clock:Function,alive:Boolean=true,throwing:Boolean=false,released:Boolean=false,fielding:Boolean=false;
        private var started:int=0,releasedAt:int=0,reactionAt:int=0,releaseMs:Number=800;
        private var releasePoint:Point,reaction:String="";
        private var homeX:Number,homeY:Number,chaseX:Number=0,chaseY:Number=0,highCatch:Boolean=false,externallyDriven:Boolean=false;
        private var readyAt:int=-1,readyDuration:Number=800,idlePhase:Number;
        private static const RUN:Array=[1,12,1,13];
        public function Pitcher(px:Number,py:Number,color:uint=0xd84f42,name:String="Pitcher",timeSource:Function=null,initialFielding:Boolean=false,playerIdentity:Object=null) {
            identity=playerIdentity;actorName=name;uniform=color;x=homeX=px;y=homeY=py;this.name="pitcher-actor";clock=timeSource!=null?timeSource:getTimer;mouseEnabled=mouseChildren=false;
            idlePhase=px*3+py;
            graphics.beginFill(0x142a22,.24);graphics.drawEllipse(-35,46,79,12);graphics.endFill();
            if(!initialFielding)makePitcher();
            heldBall.name="held-ball";BaseballArt.draw(heldBall.graphics,5);addChild(heldBall);
            if(initialFielding)setFieldingMode(true);else pose(0);addEventListener(Event.ENTER_FRAME,onFrame);
        }
        private function makePitcher():void {if(art)return;art=new PitcherBodySprite(uniform,actorName,identity);art.warmAll();art.name="pitcher-sprite";art.y=52;addChildAt(art,0);}
        public function get frameIndex():int {return fielding&&fieldArt?fieldArt.frameIndex:art?art.frameIndex:0;}
        private function pose(frame:int):void {
            if(!art)return;art.setFrame(frame);heldBall.visible=false;
            // The last cocked pose owns its painted ball; the release pose has an empty hand.
            var point:Point=art.releaseAnchor();var projected:Point=globalToLocal(art.localToGlobal(point));heldBall.x=projected.x;heldBall.y=projected.y;
        }
        private function windup(p:Number):void {pose(com.bh.visual.PitcherBodySprite.windupFrame(p));}
        private function onFrame(e:Event):void {
            if(!alive||(!visible&&!throwing&&reaction==""))return;var now:int=int(clock());
            if(fielding){
                if(externallyDriven)return;
                if(reaction!=""){
                    var age:Number=Math.max(0,now-reactionAt),p:Number=Math.min(1,age/900),ease:Number=p*p*(3-2*p);
                    x=homeX+chaseX*ease;y=homeY+chaseY*ease;
                    if(reaction=="SUCCESS")fieldArt.setFrame(age<160?11:15);
                    else if(age<520){fieldArt.setFrame(RUN[int(age/95)%4]);fieldArt.rotation=Math.max(-3,Math.min(3,chaseX/9));fieldArt.y=52-Math.abs(Math.sin(age/190*Math.PI))*1.6;}
                    else {var reach:Number=Math.max(0,Math.min(1,(age-520)/420));fieldArt.rotation=0;fieldArt.y=52-(highCatch?Math.sin(reach*Math.PI)*9:0);fieldArt.setFrame(highCatch?(reach<.30?3:reach<.58?8:reach<.82?9:10):(reach<.32?3:2));}
                    if(age>=1150){reaction="";fieldArt.y=52;fieldArt.rotation=0;fieldArt.setFrame(15);}
                }else if(readyAt>=0){
                    // A short split step follows the pitcher's release, then a low ready stance.
                    var ready:Number=Math.max(0,(now-readyAt)/readyDuration),hop:Number=Math.max(0,1-Math.abs((ready-.91)/.14));
                    fieldArt.setFrame(ready<.65?15:16);fieldArt.y=52-hop*3;fieldArt.rotation=0;
                    if(ready>1.35)readyAt=-1;
                }else{
                    fieldArt.setFrame(16);fieldArt.rotation=Math.sin((now+idlePhase)/1700)*.65;fieldArt.y=52+Math.sin((now+idlePhase)/720)*.45;
                }
                return;
            }
            art.y=52;art.x=0;art.rotation=0;
            if(throwing) {
                if(!released){var lift:Number=Math.min(1,(now-started)/releaseMs);art.rotation=-1.8*Math.sin(lift*Math.PI*2);windup(lift);art.y=52-Math.sin(lift*Math.PI)*2;return;}
                var elapsed:int=now-releasedAt;
                if(elapsed<680){var follow:Number=elapsed/680;art.x=Math.sin(follow*Math.PI)*3;art.rotation=3.5*Math.sin(follow*Math.PI);pose(elapsed<520?Math.min(23,16+int(elapsed/65)):23);return;}
                throwing=false;
            }
            if(reaction!=""&&now-reactionAt<780){pose(reaction=="SUCCESS"?22:20);return;}
            reaction="";pose(int(now/700)%2);art.y=52+Math.sin(now/650)*.65;
        }
        public function setFieldingMode(value:Boolean):void {
            if(!alive)return;fielding=value;if(!value)makePitcher();if(art)art.visible=!value;heldBall.visible=false;
            if(value&&!fieldArt){fieldArt=new FieldingSprite(uniform,actorName,identity);fieldArt.warmAll();fieldArt.y=52;addChild(fieldArt);}
            if(fieldArt){fieldArt.visible=value;fieldArt.y=52;fieldArt.rotation=0;fieldArt.setFrame(0);}
        }
        public function fieldMotion(progress:Number,catching:Boolean=false):void {
            if(!alive||!fieldArt)return;externallyDriven=true;var p:Number=Math.max(0,Math.min(1,progress));
            fieldArt.rotation=0;fieldArt.y=52;
            if(catching){fieldArt.setFrame(p<.20?22:p<.48?8:p<.78?9:10);fieldArt.y=52-Math.sin(p*Math.PI)*8;}
            else if(p<.62){fieldArt.setFrame(RUN[int(p/.62*8)%4]);fieldArt.rotation=-2*Math.sin(p/.62*Math.PI);fieldArt.y=52-Math.abs(Math.sin(p/.62*Math.PI*4))*1.5;}
            else fieldArt.setFrame(p<.78?3:p<.90?2:17);
        }
        public function prepareDefense(releaseSeconds:Number):void {if(!alive||!fielding)return;readyAt=int(clock());readyDuration=Math.max(100,releaseSeconds*1000);externallyDriven=false;reaction="";}
        public function fieldAttempt(progress:Number):void {
            if(!alive||!fieldArt)return;externallyDriven=true;var p:Number=Math.max(0,Math.min(1,progress));
            fieldArt.rotation=p<.18?-p/.18*12:p<.82?-12-58*Math.sin((p-.18)/.64*Math.PI/2):-70*(1-(p-.82)/.18);
            fieldArt.y=52-Math.sin(p*Math.PI)*20;fieldArt.setFrame(p<.18?12:p<.82?3:14);
        }
        public function fieldAnchor(throwingHand:Boolean=false):Point {
            var point:Point=fieldArt?fieldArt.anchor(throwingHand):new Point();
            var global:Point=fieldArt?fieldArt.localToGlobal(point):localToGlobal(point);
            return parent?parent.globalToLocal(global):global;
        }
        public function fieldThrow(progress:Number):void {if(fieldArt){externallyDriven=true;var p:Number=Math.max(0,Math.min(1,progress));fieldArt.setFrame(p<.16?18:p<.5?19:p<.73?20:p<.94?21:23);fieldArt.y=52-Math.sin(p*Math.PI)*1.5;fieldArt.rotation=p>=.5?Math.sin((p-.5)*Math.PI)*2:0;}}
        public function throwPitch(releaseSeconds:Number=.80):void {
            if(!alive||throwing)return;started=int(clock());releaseMs=Math.max(.1,releaseSeconds)*1000;
            throwing=true;released=false;releasePoint=null;reaction="";windup(0);
        }
        /** Hold release pose until consumed, even when a render frame is late. */
        public function releasePosition():Point {
            if(released&&releasePoint)return releasePoint.clone();
            if(throwing){art.x=0;art.y=52;art.rotation=0;windup(1);}
            var global:Point=heldBall.localToGlobal(new Point());releasePoint=parent?parent.globalToLocal(global):global;
            if(throwing){released=true;releasedAt=int(clock());heldBall.visible=false;}
            return releasePoint.clone();
        }
        public function reactSuccess():void {if(!alive)return;reaction="SUCCESS";reactionAt=int(clock());if(fielding){homeX=x;homeY=y;chaseX=chaseY=0;}}
        public function reactHit(direction:Number=1,fly:Boolean=false):void {if(!alive)return;externallyDriven=false;reaction="HIT";reactionAt=int(clock());chaseX=Math.max(-1,Math.min(1,direction))*26;chaseY=-5;highCatch=fly;}
        public function resetReady():void {if(!alive)return;readyAt=-1;externallyDriven=false;reaction="";throwing=false;released=false;releasePoint=null;x=homeX;y=homeY;if(fieldArt){fieldArt.y=52;fieldArt.rotation=0;fieldArt.setFrame(0);}if(art){art.x=0;art.y=52;art.rotation=0;pose(0);}}
        public function dispose():void {if(!alive)return;alive=false;throwing=false;removeEventListener(Event.ENTER_FRAME,onFrame);if(art)art.dispose();if(fieldArt)fieldArt.dispose();}
    }
}
