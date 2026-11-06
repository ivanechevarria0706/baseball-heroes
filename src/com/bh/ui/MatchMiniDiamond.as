package com.bh.ui {
    import flash.display.*;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.utils.getTimer;

    /** Presentation only. Runner destinations come from the resolved game state. */
    public class MatchMiniDiamond extends Sprite {
        private const PATH:Array=[[67,96],[104,65],[67,35],[30,65],[67,96]];
        private var occupied:Array=[false,false,false],runners:Array=[],moving:Array=[];
        private var ball:Shape=new Shape(),tracer:Shape=new Shape(),clock:Function;
        private var started:int=-1,ballStarted:int=-1,accent:uint,result:String="",active:Boolean=false;
        private var destination:Point=new Point(94,27);
        private var runnerDuration:int=2400,ballDuration:int=2600;
        private var fielders:Array=[],serial:int=0,lane:int=0,activeFielder:int=0;
        private var catchRing:Shape=new Shape();
        public function MatchMiniDiamond(color:uint,timeSource:Function=null,classic:Boolean=false) {
            accent=color;clock=timeSource!=null?timeSource:getTimer;mouseEnabled=mouseChildren=false;
            var g:Graphics=graphics;g.lineStyle(1.5,0xe0f0f2,.7);g.beginFill(0x315765,.58);if(classic){g.endFill();g.lineStyle();g.beginFill(0x3b7f30,.60);g.drawCircle(67,57,57);}else g.drawRoundRect(0,0,134,105,4);g.endFill();g.lineStyle();
            g.beginFill(0x419849);g.moveTo(67,96);g.curveTo(-10,49,33,24);g.curveTo(67,-2,105,24);g.curveTo(148,49,67,96);g.endFill();
            g.beginFill(0xc29459);g.moveTo(67,35);g.lineTo(104,65);g.lineTo(67,96);g.lineTo(30,65);g.lineTo(67,35);g.endFill();
            g.beginFill(0x4c994c);g.moveTo(67,44);g.lineTo(94,65);g.lineTo(67,86);g.lineTo(40,65);g.lineTo(67,44);g.endFill();
            g.lineStyle(1,0xfff8df,.85);g.moveTo(20,55);g.lineTo(67,96);g.lineTo(114,55);g.lineStyle();
            for(var i:int=0;i<4;i++){g.beginFill(0xffffff);g.drawRect(PATH[i][0]-2,PATH[i][1]-2,4,4);g.endFill();}
            for each(var p:Array in [[32,37],[67,20],[103,38],[48,50],[86,49],[67,66]]){var dot:Shape=new Shape();dot.graphics.lineStyle(1,0x12455b);dot.graphics.beginFill(0x66c6ef);dot.graphics.drawCircle(0,0,2.3);dot.graphics.endFill();dot.x=p[0];dot.y=p[1];dot.name='minimap-fielder-'+fielders.length;addChild(dot);fielders.push({view:dot,x:p[0],y:p[1]});}g.lineStyle();
            catchRing.name='minimap-catch-ring';addChild(catchRing);
            addChild(tracer);
            for(i=0;i<3;i++){var runner:Sprite=marker();runner.name='runner-'+['first','second','third'][i];runner.x=PATH[i+1][0];runner.y=PATH[i+1][1];runners.push(runner);addChild(runner);}
            ball.name='minimap-ball';ball.graphics.lineStyle(1,0x87552a);ball.graphics.beginFill(0xfff7b2);ball.graphics.drawCircle(0,0,3);ball.graphics.endFill();ball.visible=false;addChild(ball);
            setBases(occupied);
        }
        private function marker():Sprite {var s:Sprite=new Sprite();s.graphics.lineStyle(1.1,0x1b3541);s.graphics.beginFill(0xf4cea2);s.graphics.drawCircle(0,0,4);s.graphics.endFill();s.graphics.beginFill(accent);s.graphics.drawRoundRect(-5,-6,10,5,4);s.graphics.endFill();return s;}
        public function setBases(value:Array):void {occupied=value.concat();if(started<0)paintOccupied();}
        private function paintOccupied():void {for(var i:int=0;i<3;i++)Sprite(runners[i]).visible=Boolean(occupied[i]);}
        public function pitch(progress:Number):void {if(ballStarted>=0)return;ball.visible=progress>0&&progress<1;ball.x=67;ball.y=66+30*progress;}
        public function ballInPlay(value:String,duration:int=2600,route:int=-1):void {
            ballDuration=Math.max(200,duration);result=value;ballStarted=int(clock());lane=route<0?serial++%3:Math.max(0,Math.min(2,route));resetFielders();
            destination.x=[35,67,99][lane];destination.y=value=='HOME RUN'?6:value=='GROUND OUT'?53:value=='DOUBLE'||value=='TRIPLE'?19:34;
            if(value=='TRIPLE')destination.x=lane==2?112:22;
            activeFielder=value=='GROUND OUT'?(lane==0?3:lane==2?4:5):lane;wake();
        }
        public function play(before:Array,after:Array,batter:Object,bases:int,duration:int=2400):void {
            runnerDuration=Math.max(200,duration);clearMoving();started=int(clock());
            for(var i:int=0;i<3;i++)if(before[i]!=null)addTrack(before[i],i+1,after);
            addTrack(batter,0,after);for each(var r:Sprite in runners)r.visible=false;wake();
        }
        private function addTrack(player:Object,start:int,after:Array):void {
            var end:int=4;
            for(var i:int=0;i<3;i++)if(after[i]===player){end=i+1;break;}
            if(end<start)end=4;
            var s:Sprite=marker();s.name='advancing-runner';addChild(s);moving.push({sprite:s,from:start,to:end});place(s,start);
        }
        private function place(s:Sprite,base:Number):void {var i:int=Math.min(3,int(base)),p:Number=base-i;s.x=PATH[i][0]+(PATH[i+1][0]-PATH[i][0])*p;s.y=PATH[i][1]+(PATH[i+1][1]-PATH[i][1])*p;}
        private function wake():void {if(active)return;active=true;addEventListener(Event.ENTER_FRAME,frame);}
        private function frame(e:Event):void {advance();}
        public function advance():void {
            var now:int=int(clock());
            if(started>=0){var delay:Number=runnerDuration*(160/2400),p:Number=Math.max(0,Math.min(1,(now-started-delay)/(runnerDuration-delay)));p=p*p*(3-2*p);for each(var t:Object in moving)place(t.sprite,t.from+(t.to-t.from)*p);if(now-started>=runnerDuration){clearMoving();paintOccupied();}}
            if(ballStarted>=0)paintBall(Math.max(0,Math.min(1,(now-ballStarted)/ballDuration)));
            if(started<0&&ballStarted<0){removeEventListener(Event.ENTER_FRAME,frame);active=false;}
        }
        private function ballPoint(p:Number):Point {
            var pickup:Number=.58,fly:Boolean=result=='FLY OUT',ground:Boolean=result=='GROUND OUT',deep:Boolean=result=='DOUBLE'||result=='TRIPLE',homeRun:Boolean=result=='HOME RUN';
            if(homeRun||deep){var height:Number=homeRun?23:14;return new Point(67+(destination.x-67)*p,96+(destination.y-96)*p-Math.sin(p*Math.PI)*height);}
            if(p<=pickup){var flight:Number=p/pickup,bounce:Number=ground?Math.abs(Math.sin(flight*Math.PI*3))*3*(1-flight):0;return new Point(67+(destination.x-67)*flight,96+(destination.y-96)*flight-(ground?bounce:Math.sin(flight*Math.PI)*(fly?17:8)));}
            var returnP:Number=Math.max(0,Math.min(1,(p-.68)/.28)),target:Array=ground?PATH[1]:PATH[2];
            if(fly)return new Point(destination.x,destination.y);
            return new Point(destination.x+(target[0]-destination.x)*returnP,destination.y+(target[1]-destination.y)*returnP-Math.sin(returnP*Math.PI)*4);
        }
        private function paintBall(p:Number):void {
            var point:Point=ballPoint(p),caught:Boolean=p>=.58&&p<.68,deep:Boolean=result=='DOUBLE'||result=='TRIPLE';ball.x=point.x;ball.y=point.y;
            ball.visible=p<1&&!(result=='FLY OUT'&&p>=.60);ball.alpha=p>.94?(1-p)/.06:1;
            var q:Object=fielders[activeFielder],chase:Number=Math.min(1,p/(deep?.9:.58));chase=chase*chase*(3-2*chase);
            if(result!='HOME RUN'){q.view.x=q.x+(destination.x-q.x)*chase*(deep?.80:1);q.view.y=q.y+(destination.y-q.y)*chase*(deep?.80:1);}
            catchRing.graphics.clear();if(caught&&!deep&&result!='HOME RUN'){catchRing.graphics.lineStyle(1.3,0xffef9b,(.68-p)/.1);catchRing.graphics.drawCircle(destination.x,destination.y,3+(p-.58)*60);catchRing.graphics.lineStyle();}
            tracer.graphics.clear();if(p<1){tracer.graphics.lineStyle(1.2,0xfff1a4,.65);for(var i:int=0;i<5;i++){var t:Number=Math.max(0,p-(4-i)*.035),tail:Point=ballPoint(t);if(i==0)tracer.graphics.moveTo(tail.x,tail.y);else tracer.graphics.lineTo(tail.x,tail.y);}tracer.graphics.lineStyle();}
            else {ballStarted=-1;ball.alpha=1;tracer.graphics.clear();catchRing.graphics.clear();resetFielders();}
        }
        private function resetFielders():void {for each(var q:Object in fielders){q.view.x=q.x;q.view.y=q.y;}}
        private function clearMoving():void {for each(var t:Object in moving)if(t.sprite.parent)removeChild(t.sprite);moving=[];started=-1;}
        public function reset():void {clearMoving();ballStarted=-1;ball.visible=false;ball.alpha=1;tracer.graphics.clear();catchRing.graphics.clear();resetFielders();paintOccupied();removeEventListener(Event.ENTER_FRAME,frame);active=false;}
        public function dispose():void {reset();}
    }
}
