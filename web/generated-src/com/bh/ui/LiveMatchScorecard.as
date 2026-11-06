package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;
    import com.bh.visual.*;
    /** Frozen, read-only snapshot; contains no simulation, payment or save calls. */
    public class LiveMatchScorecard extends Sprite {
        private var views:Array=[],resume:ClassicActionButton,close:Function;
        public function LiveMatchScorecard(w:Number,h:Number,value:Object,onClose:Function){
            name="live-match-scorecard";close=onClose;
            graphics.beginFill(0x032334,.82);graphics.drawRect(0,0,w,h);graphics.endFill();ClassicChrome.panel(graphics,45,22,870,546);
            ClassicChrome.bar(graphics,51,28,858,41);ClassicChrome.title(text("BOX SCORE",67,32,620,33,27),27);
            resume=ClassicInventorySkin.button("RESUME",135,31,0x76ab2c) as ClassicActionButton;resume.x=763;resume.y=33;resume.name="scorecard-resume";addChild(resume);resume.addEventListener(MouseEvent.CLICK,done);
            drawLine(value);drawTeam(value.home,true,67,160,String(value.homeName));drawTeam(value.away,false,493,160,String(value.awayName));
            text("Partido en pausa · Datos de este encuentro · B, Esc o RESUME para volver",68,531,826,25,12,0xffe58f);
            addEventListener(MouseEvent.CLICK,block);
        }
        private function text(value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,align:String="center"):TextField {return ClassicInventorySkin.text(this,value,x,y,w,h,size,color,align);}
        private function drawLine(s:Object):void {
            MatchChrome.score(graphics,67,78,826,70);var first:int=Math.max(1,int(s.inning)-8),x:Number=264;
            text("INNING "+s.inning+" · "+(s.side=="AWAY"?"TOP":"BOTTOM"),72,81,177,19,10,0xa7d9e2);
            for(var i:int=0;i<9;i++){text(String(first+i),x+i*46,80,44,18,10,first+i==s.inning?0xffd968:0xb9d4d7);for(var team:int=0;team<2;team++){
                var line:Array=team==0?s.awayLine:s.homeLine,n:int=first+i,played:Boolean=n<int(s.inning)||n==int(s.inning)&&(team==0||s.side=="HOME");
                if(n==int(s.inning)){graphics.lineStyle(1,0x5db5ce);graphics.beginFill(0x176278,.5);graphics.drawRect(x+i*46,100+team*22,44,20);graphics.endFill();graphics.lineStyle();}
                text(played?String(n<=line.length?int(line[n-1]):0):"-",x+i*46,100+team*22,44,21,13);
            }}
            text(String(s.awayName),72,101,179,21,11);text(String(s.homeName),72,123,179,21,11,0xffdf7b);
            text("R",718,80,60,18,10,0xb9d4d7);text("H",804,80,60,18,10,0xb9d4d7);
            text(String(s.awayScore),718,100,60,21,15);text(String(s.homeScore),718,122,60,21,15,0xffdf7b);text(String(s.awayHits),804,100,60,21,15);text(String(s.homeHits),804,122,60,21,15);
        }
        private function drawTeam(rows:Array,home:Boolean,x:Number,y:Number,title:String):void {
            MatchChrome.paper(graphics,x-3,y-3,403,365);MatchChrome.nameplate(graphics,x+1,y+1,395,23,home);text(title,x+4,y+1,387,24,13);
            var cols:Array=[242,272,302,334,370],keys:Array=["atBats","hits","homeRuns","rbi","walks"],labels:Array=["AB","H","HR","RBI","BB"],totals:Array=[0,0,0,0,0];
            text("PLAYER",x+42,y+25,182,18,9,0x516b66,"left");for(var j:int=0;j<5;j++)text(labels[j],x+cols[j]-12,y+25,29,18,9,0x516b66);
            for(var i:int=0;i<Math.min(9,rows.length);i++){
                var row:Object=rows[i],yy:Number=y+45+i*32,hero:Boolean=home&&row.isHero;
                MatchChrome.row(graphics,x+1,yy,395,30,hero,i%2==1);text(String(i+1),x+1,yy+4,19,23,12,0x385b56);
                var face:Sprite=hero?new CharacterPortrait(row,26,28,false):new LineupPortrait(VisualAssetRegistry.playerSpriteFrame(String(row.name)),26,28,row);face.x=x+20;face.y=yy;addChild(face);views.push(face);
                var player:TextField=text(String(row.name),x+48,yy+5,174,23,12,hero?0x986b18:0x2e4b46,"left");LineupTypography.fit(player,12,hero?0x986b18:0x2e4b46,"left",false,8);
                for(j=0;j<5;j++){totals[j]+=int(row[keys[j]]);text(String(int(row[keys[j]])),x+cols[j]-12,yy+4,29,23,13,0x23443e);}
            }
            text("TOTAL",x+45,y+334,178,23,11,0x325b54,"left");for(j=0;j<5;j++)text(String(totals[j]),x+cols[j]-12,y+334,29,23,12,0x325b54);
        }
        private function block(e:MouseEvent):void {e.stopPropagation();}
        private function done(e:MouseEvent):void {e.stopPropagation();close();}
        public function dispose():void {removeEventListener(MouseEvent.CLICK,block);resume.removeEventListener(MouseEvent.CLICK,done);resume.dispose();for each(var v:Object in views)v.dispose();views=[];close=null;}
    }
}
