package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    import com.bh.game.BaseballArt;
    /** Four illustrated poses per scene, interpolated with a time based camera. */
    public class HomeRunStory extends Sprite {
        [Embed(source="../../../../assets/reference/cinematics093/characters.png")] private static const Atlas:Class;
        private static var source:BitmapData,poses:Array=[],serial:int=0;
        private static const BOXES:Array=[[29,41,354,301],[423,132,402,189],[861,55,390,282],[1286,67,347,297],[36,405,376,227],[452,414,369,221],[855,438,376,200],[1258,403,389,234],[84,696,273,207],[487,693,269,211],[914,691,272,216],[1339,681,274,227]];
        private var actor:Bitmap=new Bitmap(),ball:Shape=new Shape(),feathers:Sprite=new Sprite(),console:Shape=new Shape();
        private var w:Number,h:Number,variant:int;private var streaks:Shape=new Shape(),impactFlash:Shape=new Shape();
        public static function warm():void {if(source)return;source=Bitmap(new Atlas()).bitmapData;for each(var box:Array in BOXES){var b:BitmapData=new BitmapData(box[2],box[3],true,0);b.copyPixels(source,new Rectangle(box[0],box[1],box[2],box[3]),new Point());poses.push(b);}}
        public function HomeRunStory(width:Number,height:Number){w=width;h=height;warm();mouseEnabled=mouseChildren=false;addChild(console);actor.smoothing=true;addChild(actor);addChild(feathers);BaseballArt.draw(ball.graphics,40);addChild(ball);addChild(streaks);addChild(impactFlash);visible=false;}
        public function begin():void {variant=serial++%3;drawSky();name="home-run-story-"+variant;visible=true;}
        public function at(ms:Number):void {
            var i:int;
            var impact:Boolean=ms>=2200,pose:int=variant*4+(impact?3:ms>=1400?2:int(ms/160)%2);actor.bitmapData=poses[pose];
            var scale:Number=variant==1?.72:variant==2?.85:.74;var zoom:Number=Math.max(0,Math.min(1,(ms-650)/1550));zoom=zoom*zoom*(3-2*zoom);var camera:Number=1+zoom*.27;actor.scaleX=actor.scaleY=scale*camera;
            actor.x=w*(variant==0?.50:.47)-actor.width*.5+(impact&&ms<2480?Math.sin(ms*.09)*(1-(ms-2200)/280)*6:0);actor.y=h*.69-actor.height+(variant==0?Math.sin(ms/130)*7:Math.sin(ms/250)*2);
            actor.rotation=variant==0&&impact?Math.sin((ms-2200)/120)*11:variant==0?Math.sin(ms/160)*2:0;
            console.graphics.clear();
            if(variant>0){var g:Graphics=console.graphics;g.beginFill(variant==1?0xe1e3e6:0x202b3a);g.drawEllipse(-w*.1,h*.68,w*1.2,h*.4);g.endFill();g.lineStyle(4,0x175983);g.beginFill(0x54b7ed);g.drawRoundRect(w*.34,h*.70,w*.32,58,8);g.endFill();g.lineStyle();for(i=0;i<4;i++){g.beginFill(impact?0xf45155:0x54f1ff);g.drawCircle(w*.37+i*78,h*.735,9);g.endFill();}}
            var p:Number=Math.max(0,Math.min(1,(ms-1200)/1000));
            var hitX:Number=actor.x+actor.width*(variant==0?.70:.55),hitY:Number=actor.y+actor.height*(variant==0?.35:.40);
            ball.x=w+95+(hitX-w-95)*p;ball.y=h*.30+(hitY-h*.30)*p*p;
            if(impact){ball.x=hitX-(ms-2200)*.25;ball.y=hitY-(ms-2200)*.18+(ms-2200)*(ms-2200)*.0003;}
            ball.scaleX=ball.scaleY=ms<1200?0:impact?Math.max(.08,1-(ms-2200)/750):1.9-p*.8;ball.rotation=ms*.45;
            feathers.graphics.clear();if(impact&&variant==0){for(i=0;i<14;i++){var angle:Number=i*Math.PI*2/14,r:Number=(ms-2200)*.22;feathers.graphics.beginFill(0xffffff,.95);feathers.graphics.drawEllipse(hitX+Math.cos(angle)*r,hitY+Math.sin(angle)*r+(ms-2200)*(ms-2200)*.000035,18,7);feathers.graphics.endFill();}}
            streaks.graphics.clear();if(ms>1400&&ms<2200){for(i=0;i<6;i++){streaks.graphics.lineStyle(2+i%2,0xffffff,.26);streaks.graphics.moveTo(ball.x+35+i*13,ball.y-4+i*4);streaks.graphics.lineTo(ball.x+92+i*20,ball.y-4+i*4);}streaks.graphics.lineStyle();}
            impactFlash.graphics.clear();if(impact&&ms<2340){impactFlash.graphics.beginFill(0xffffff,.65*(1-(ms-2200)/140));impactFlash.graphics.drawRect(0,52,w,h-106);impactFlash.graphics.endFill();}


        }
        private function drawSky():void {
            graphics.clear();var matrix:Matrix=new Matrix();matrix.createGradientBox(w,h,Math.PI/2);
            graphics.beginGradientFill("linear",[0x37afe4,0xc9f6fa],[1,1],[0,255],matrix);graphics.drawRect(0,52,w,h-106);graphics.endFill();
            var i:int;
            if(variant==0){for(i=0;i<7;i++){var x:Number=((i*210)%(w+250)+w+250)%(w+250)-130;graphics.beginFill(0xffffff,.65);graphics.drawEllipse(x,120+(i%3)*115,180,35);graphics.endFill();}}
            else {
                graphics.beginFill(variant==1?0x375060:0x25384b);graphics.drawRect(0,52,w,h-106);graphics.endFill();
                graphics.lineStyle(12,0x879eaa);graphics.beginFill(0x101e39);graphics.drawRoundRect(w*.13,83,w*.74,h*.43,70);graphics.endFill();graphics.lineStyle();
                for(i=0;i<42;i++){var sx:Number=w*.16+(i*127)%(w*.68),sy:Number=103+(i*63)%(h*.34);graphics.beginFill(0xd6eafb,.4+(i%3)*.2);graphics.drawCircle(sx,sy,i%5==0?2.3:1.2);graphics.endFill();}
                graphics.beginFill(0x5ba0c9);graphics.drawCircle(w*.73,h*.24,46);graphics.endFill();graphics.beginFill(0x367b99);graphics.drawEllipse(w*.70,h*.18,45,40);graphics.endFill();
                graphics.lineStyle(3,0x142d40);graphics.beginFill(0x68828e);graphics.drawRect(0,h*.64,w,h*.29);graphics.endFill();graphics.lineStyle();
            }
        }
        public function stop():void {visible=false;actor.bitmapData=null;impactFlash.graphics.clear();streaks.graphics.clear();}
        public function dispose():void {stop();}
    }
}
