package com.bh.visual {
    import flash.display.*;
    import flash.geom.*;
    import flash.text.TextField;
    import com.bh.ui.LineupTypography;

    /** Small retained layers over the measured park. The match owns the clock. */
    public class StadiumAtmosphere extends Sprite {
        private var crowds:Array=[],flags:Array=[],glows:Array=[],scoreHome:TextField,scoreAway:TextField,inningText:TextField,batterText:TextField;
        private var layout:Object;
        private var lastTick:int=-1,lastNow:int=-1,visualTime:Number=0,cheerUntil:Number=0,dead:Boolean=false;
        private var home:int=0,away:int=0,inning:int=1,side:String="",batterName:String="",hasScore:Boolean=false;
        public function StadiumAtmosphere(rookie:Boolean=true,defaultBoard:Boolean=true,profile:Object=null) {
            name="stadium-atmosphere";mouseEnabled=mouseChildren=false;
            scrollRect=new Rectangle(0,0,960,355);layout=profile||StadiumAtmosphereLayout.create("stadium_background_mountain",rookie);
            var detail:Shape=new Shape();addChild(detail);var g:Graphics=detail.graphics;
            // Rail depth and wall joints follow the existing image, never the strike zone.
            if(layout.rail){g.lineStyle(2,0x173e34,.65);g.moveTo(0,354);g.lineTo(960,354);
            g.lineStyle(1,0xe7f1c9,.65);g.moveTo(0,327);g.lineTo(960,327);g.lineStyle();
            for(var j:int=0;j<12;j++){g.lineStyle(1,0x082e29,.4);g.moveTo(j*80,330);g.lineTo(j*80,353);g.lineStyle();}}
            detail.cacheAsBitmap=true;
            if(rookie){var locations:Array=[[20,249],[39,281],[60,308],[179,278],[244,291],[300,313],[940,249],[921,281],[900,308],[781,278],[716,291],[660,313]];for(j=0;j<locations.length;j++)makeCrowd(locations[j][0],locations[j][1],j);}
            else makeSeatedCrowds();
            for each(var lamp:Array in layout.lights)makeGlow(lamp[0],lamp[1]);
            for each(var flag:Array in layout.flags)makeFlag(flag[0],flag[1],uint(flag[2]));
            var board:Sprite=new Sprite();board.name="live-outfield-scoreboard";board.visible=defaultBoard;addChild(board);
            if(layout.screen){var screen:Array=layout.screen;board.graphics.beginFill(uint(layout.ink)==0x94fff0?0x142a40:0x223f27);board.graphics.drawRect(screen[0],screen[1],screen[2],screen[3]);board.graphics.endFill();}
            scoreHome=scoreCell(board,layout.board.home,"HOME",uint(layout.ink));scoreAway=scoreCell(board,layout.board.away,"AWAY",0xe8f5d0);
            scoreHome.name="outfield-home-score";scoreAway.name="outfield-away-score";
            inningText=smallCell(board,layout.board.inning,"1");inningText.name="outfield-inning";
            batterText=smallCell(board,layout.board.batter,"PLAY BALL");batterText.name="outfield-batter";
        }
        private function scoreCell(parent:Sprite,r:Array,title:String,color:uint):TextField {
            parent.graphics.lineStyle(.8,0x70896a,.8);parent.graphics.beginFill(0x102b27,.97);parent.graphics.drawRect(r[0],r[1],r[2],r[3]);parent.graphics.endFill();parent.graphics.lineStyle();
            label(parent,title,r[0]-2,r[1]-8,r[2]+4,10,6,0xe0e5aa);return label(parent,"0",r[0],r[1]-1,r[2],r[3]+1,r[4],color);
        }
        private function smallCell(parent:Sprite,r:Array,title:String):TextField {
            if(!r||!r.length)return new TextField();parent.graphics.lineStyle(.7,0x50705e);parent.graphics.beginFill(0x112b25,.96);parent.graphics.drawRect(r[0],r[1],r[2],r[3]);parent.graphics.endFill();parent.graphics.lineStyle();return label(parent,title,r[0],r[1],r[2],r[3],r[4],0xe2efb7);
        }
        private function makeGlow(x:Number,y:Number):void {
            var glow:Sprite=new Sprite(),g:Graphics=glow.graphics,m:Matrix=new Matrix();glow.name="stadium-light-"+glows.length;glow.x=x;glow.y=y;m.createGradientBox(84,40,0,-42,-20);
            g.beginGradientFill(GradientType.RADIAL,layout.torch?[0xffbc54,0xff762b]:[0xfff6c5,0xffefaa],[.62,0],[0,255],m);g.drawEllipse(-42,-20,84,40);g.endFill();glow.cacheAsBitmap=true;glow.alpha=layout.night?.36:.15;addChild(glow);glows.push(glow);
        }
        private function inside(x:Number,y:Number,poly:Array):Boolean {
            var hit:Boolean=false;for(var i:int=0,j:int=poly.length-2;i<poly.length;j=i,i+=2)if((poly[i+1]>y)!=(poly[j+1]>y)&&x<(poly[j]-poly[i])*(y-poly[i+1])/(poly[j+1]-poly[i+1])+poly[i])hit=!hit;return hit;
        }
        private function makeSeatedCrowds():void {
            var tiles:Object={},keys:Array=[];
            for each(var poly:Array in layout.polygons)for(var row:int=0;row<47;row++)for(var col:int=0;col<133;col++){
                var x:Number=3+col*7.25+(row%2)*3.6,y:Number=3+row*7;
                if(!inside(x-3,y-5,poly)||!inside(x+3,y+3,poly))continue;
                var tx:int=int(x/64),ty:int=int(y/48),key:String=tx+":"+ty;
                if(!tiles[key]){tiles[key]={x:tx*64,y:ty*48,points:[]};keys.push(key);}
                tiles[key].points.push([x-tx*64,y-ty*48]);
            }
            for each(key in keys){var t:Object=tiles[key];makeCrowd(t.x,t.y,crowds.length,t.points);}
        }
        private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):TextField {
            var t:TextField=new TextField();t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=t.mouseEnabled=false;LineupTypography.fit(t,size,color,"center",false,6);parent.addChild(t);return t;
        }
        private function makeCrowd(x:Number,y:Number,seed:int,points:Array=null):void {
            if(!points){points=[];for(var k:int=0;k<8;k++)points.push([(k%4)*5.1,int(k/4)*7.2]);}
            var group:Sprite=new Sprite();group.name="stadium-crowd-"+crowds.length;group.x=x;group.y=y;addChild(group);var poses:Array=[];
            for(var pose:int=0;pose<3;pose++){
                var s:Shape=new Shape(),g:Graphics=s.graphics;
                s.name="crowd-pose-"+pose;
                for(var i:int=0;i<points.length;i++){
                    var px:Number=points[i][0],py:Number=points[i][1],shirt:uint=(layout.night?[0x9db7d5,0xe0bb5f,0xb86c65,0x65aaa9]:[0xffcf68,0x4ca4bf,0xf1e6c6,0xca5845])[(i+seed)%4],raise:Number=pose==0?0:pose==1?-2.5:-4;
                    g.lineStyle(1,0xe1ae83);g.moveTo(px-1,py+2);g.lineTo(px-2,py+raise);g.moveTo(px+1,py+2);g.lineTo(px+3,py+raise);g.lineStyle();
                    g.beginFill(shirt);g.drawRect(px-1,py+1,3,3);g.endFill();g.beginFill(0xeac29a);g.drawCircle(px+.5,py-.5,1.3);g.endFill();
                }
                s.cacheAsBitmap=true;s.visible=pose==0;group.addChild(s);poses.push(s);
            }
            crowds.push({poses:poses,index:0,phase:seed*137,delay:Math.abs(x-480)*.32});
        }
        private function makeFlag(x:Number,y:Number,color:uint):void {
            var pole:Shape=new Shape();pole.graphics.lineStyle(2,0x637b76);pole.graphics.moveTo(x,y);pole.graphics.lineTo(x,y-35);pole.graphics.lineStyle(1,0xe9e7ce);pole.graphics.moveTo(x-1,y);pole.graphics.lineTo(x-1,y-36);pole.graphics.lineStyle();addChild(pole);
            var group:Sprite=new Sprite();group.name="stadium-flag-"+flags.length;group.x=x;group.y=y-35;addChild(group);var poses:Array=[];
            for(var frame:int=0;frame<8;frame++){
                var s:Shape=new Shape(),g:Graphics=s.graphics,a:Number=frame*Math.PI/4,wave:Number=Math.sin(a)*2;
                g.lineStyle(.7,0x193f47);g.beginFill(color);g.moveTo(0,0);g.curveTo(10,-4+wave,21,wave);g.lineTo(17,6+wave);g.lineTo(21,12+wave);g.curveTo(10,8+wave,0,12);g.lineTo(0,0);g.endFill();g.lineStyle(.8,0xffffff,.6);g.moveTo(2,2);g.curveTo(11,-1+wave,18,2+wave);g.lineStyle();s.cacheAsBitmap=true;s.visible=frame==0;group.addChild(s);poses.push(s);
            }
            flags.push({poses:poses,index:0,phase:int(x)});
        }
        public function setMatch(homeScore:int,awayScore:int,currentInning:int,half:String,playerName:String):void {
            if(dead)return;
            if(hasScore&&(homeScore>home||awayScore>away))cheer(2100);
            if(home!=homeScore){scoreHome.text=String(homeScore);LineupTypography.fit(scoreHome,layout.board.home[4],uint(layout.ink),"center",false,6);}
            if(away!=awayScore){scoreAway.text=String(awayScore);LineupTypography.fit(scoreAway,layout.board.away[4],0xe8f5d0,"center",false,6);}
            home=homeScore;away=awayScore;hasScore=true;
            if(inning!=currentInning||side!=half){inning=currentInning;side=half;inningText.text=(half=="AWAY"?"T ":"B ")+inning;LineupTypography.fit(inningText,layout.board.inning[4],0xe2efb7,"center",false,6);}
            if(batterName!=playerName){batterName=playerName;var words:Array=playerName.split(" ");batterText.text=String(words[words.length-1]).toUpperCase();if(layout.board.batter.length)LineupTypography.fit(batterText,layout.board.batter[4],0xe2efb7,"center",false,6);}
        }
        public function cheer(duration:int=1600):void {if(!dead)cheerUntil=Math.max(cheerUntil,visualTime+duration);}
        public function advance(now:int,active:Boolean=true):void {
            if(dead)return;
            if(lastNow<0)lastNow=now;
            var dt:Number=Math.max(0,Math.min(100,now-lastNow));lastNow=now;
            if(!active)return;visualTime+=dt;
            var tick:int=int(visualTime/100);if(tick==lastTick)return;lastTick=tick;
            for each(var group:Object in flags)show(group,int((visualTime+group.phase)/140)%8);
            for each(group in crowds){var at:Number=visualTime+group.phase,cheering:Boolean=visualTime+group.delay<cheerUntil,pose:int=cheering?1+int(at/180)%2:at%4200<500?1:0;show(group,pose);}
            for(var i:int=0;i<glows.length;i++)glows[i].alpha=(layout.night?.36:.15)+(layout.torch?.08:.025)*Math.sin(visualTime/(layout.torch?130:1100)+i*1.3);
        }
        private function show(group:Object,index:int):void {if(index==group.index)return;group.poses[group.index].visible=false;group.poses[index].visible=true;group.index=index;}
        public function dispose():void {dead=true;crowds=[];flags=[];glows=[];while(numChildren)removeChildAt(0);}
    }
}
