package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.geom.Matrix;
    import com.bh.model.GameData;import com.bh.model.PostSeason;
    import com.bh.visual.TeamLogoView;
    /** Bracket composition reconstructed from the supplied Ciguena gameplay 20:22. */
    public class PostSeasonScreen extends Sprite {
        private var back:Function,play:Function,nextSeason:Function,buttons:Array=[],logos:Array=[],header:TravelHeader;
        public function PostSeasonScreen(w:Number,h:Number,onBack:Function,onPlay:Function,onNext:Function) {
            name="post-season";back=onBack;play=onPlay;nextSeason=onNext;
            var m:Matrix=new Matrix();m.createGradientBox(w*1.5,h*1.8,0,-w*.2,0);
            graphics.beginGradientFill(GradientType.RADIAL,[0x8ad016,0x397d0c,0x031b03],[1,1,1],[0,155,255],m);graphics.drawRect(0,0,w,h);graphics.endFill();
            graphics.lineStyle(1,0x244b12,.18);for(var i:int=0;i<w;i+=28){graphics.moveTo(i,98);graphics.lineTo(i,h);}graphics.lineStyle();
            header=new TravelHeader(false,GameData.postSeason?GameData.ordinalNumber(int(GameData.postSeason.season))+" POST SEASON":"POST SEASON");addChild(header);
            button("post-home","HOME",20,672,115,back);
            var s:Object=GameData.postSeason;
            if(!GameData.ensurePostSeason()&&!s){
                title("POST SEASON",230,220,500,60,46,0xffe351);
                title("Termina entre los cuatro primeros\ntras los 30 partidos de temporada.",160,320,640,100,24);
                title("Empiezas en nivel 1, en ROOKIE.\nVuelve a REGULAR SEASON para jugar.",175,459,610,86,18,0xd9edae);
                return;
            }
            s=GameData.postSeason;
            var opponent:Object=PostSeason.opponent(s),round:Object=PostSeason.activeSeries(s);
            if(opponent){
                ClassicInventorySkin.gradient(graphics,0,108,480,112,0x1976b0,0x0b385e,0);
                ClassicInventorySkin.gradient(graphics,480,108,480,112,0xef9c18,0x9b4d07,0);
                logo(GameData.teamCity,GameData.teamAccent,153,132,62);logo(opponent.city,uint(opponent.accent),747,132,62);
                title(GameData.teamName,220,124,205,26,16,0xffffff,"right");title(opponent.teamName,535,124,203,26,16);
                title("VS",433,135,94,53,39,0xffffff,"center");
                title(PostSeason.label(s)+" · GAME "+(round.games.length+1),220,178,520,26,16,0xffe374,"center");
            }else title(s.status=="champion"?"WORLD CHAMPION!":"POST SEASON COMPLETE",160,137,640,62,41,s.status=="champion"?0xffe35d:0xd9edae,"center");
            title("N-LEAGUE",34,244,200,30,20,0xd6efff);title("A-LEAGUE",726,244,200,30,20,0xffdbbb,"right");
            drawBracket(s);
            if(round){
                var heroWins:int=round.home==s.hero?round.homeWins:round.awayWins,rivalWins:int=round.home==s.hero?round.awayWins:round.homeWins;
                var hint:String=heroWins+" — "+rivalWins+"  ·  3 Wins Required";
                if(GameData.pendingPostSeasonPayment())hint+="\nPartido pagado: reinícialo sin gastar más energía ni cartas.";
                else if(GameData.energy<5)hint+="\nNecesitas 5 de energía para continuar.";
                else hint+="\nRevisa tu alineación antes del próximo partido.";
                title(hint,185,628,590,64,16,0xffe981,"center");
                if(GameData.energy>=5||GameData.pendingPostSeasonPayment())button("post-next",GameData.pendingPostSeasonPayment()?"RESUME":"NEXT",799,672,141,play);
                button("post-record","RECORD",148,672,115,record);
            }else{
                var champ:Object=int(s.champion)>=0?s.teams[s.champion]:null;
                title(s.status=="champion"?"¡Ganaste el campeonato! Tu título quedó guardado.":"Tu equipo quedó eliminado. Campeón: "+(champ?champ.teamName:"—"),180,633,610,40,16,0xffe981,"center");
                button("post-record","RECORD",148,672,115,record);
                if(GameData.seasonComplete&&s.season==GameData.seasonNumber)button("post-next-season","NEXT SEASON",760,672,180,nextSeason);
            }
        }
        private function title(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint=0xffffff,align:String="left"):TextField {
            var t:TextField=ClassicInventorySkin.text(this,value,x,y,w,h,size,color,align);
            LineupTypography.apply(t,size,color,align,true);t.text=value;return t;
        }
        private function logo(city:String,accent:uint,x:Number,y:Number,size:Number):void {var l:TeamLogoView=new TeamLogoView(city,accent,"",size);l.x=x;l.y=y;addChild(l);logos.push(l);}
        private function node(s:Object,index:int,x:Number,y:Number):void {
            var club:Object=s.teams[index];ClassicInventorySkin.gradient(graphics,x,y,228,61,club.isHero?0x7ca938:0x2c730f,0x144608,8);
            logo(club.city,uint(club.accent),x+7,y+4,52);
            title(club.seed+" · "+club.city,x+65,y+3,157,23,14,club.isHero?0xffe875:0xffffff);
            title(club.teamName,x+65,y+25,157,20,11,0xd7ebbe);
        }
        private function winner(s:Object,id:int,x:Number,y:Number):void {
            var series:Object=s.series[id];
            ClassicInventorySkin.gradient(graphics,x,y,134,51,0x528e17,0x1f500a,8);
            if(series&&int(series.winner)>=0){var club:Object=s.teams[series.winner];logo(club.city,uint(club.accent),x+3,y+3,44);title(club.city,x+47,y+2,85,24,10);title(series.homeWins+" — "+series.awayWins,x+47,y+23,85,23,15,0xffe273);}
            else title(series?series.homeWins+" — "+series.awayWins:"?",x+7,y+8,120,35,23,0xffe273,"center");
        }
        private function drawBracket(s:Object):void {
            var ys:Array=[289,357,477,545];
            graphics.lineStyle(3,0xe7efcb,.88);
            for(var side:int=0;side<2;side++){
                var edge:int=side==0?264:696,joint:int=side==0?289:671,tip:int=side==0?304:522;
                for(var pair:int=0;pair<2;pair++){
                    var y1:int=ys[pair*2]+30,y2:int=ys[pair*2+1]+30,mid:int=(y1+y2)/2;
                    graphics.moveTo(edge,y1);graphics.lineTo(joint,y1);graphics.lineTo(joint,y2);graphics.lineTo(edge,y2);graphics.moveTo(joint,mid);graphics.lineTo(tip,mid);
                }
                for(var i:int=0;i<4;i++)node(s,side*4+i,side==0?36:696,ys[i]);
                winner(s,side*2,side==0?304:522,327);winner(s,side*2+1,side==0?304:522,515);
            }
            graphics.lineStyle(3,0xe7efcb,.88);graphics.moveTo(371,378);graphics.lineTo(371,431);graphics.lineTo(432,431);graphics.moveTo(371,515);graphics.lineTo(371,478);graphics.lineTo(432,478);
            graphics.moveTo(589,378);graphics.lineTo(589,431);graphics.lineTo(528,431);graphics.moveTo(589,515);graphics.lineTo(589,478);graphics.lineTo(528,478);graphics.lineStyle();
            winner(s,4,304,431);winner(s,5,522,431);
            // The reference centers a gold trophy between the league brackets.
            var g:Graphics=graphics;g.lineStyle(3,0x80541a);g.beginFill(0xffd34a);g.moveTo(450,264);g.lineTo(510,264);g.curveTo(508,298,486,306);g.lineTo(486,323);g.lineTo(506,327);g.lineTo(506,337);g.lineTo(454,337);g.lineTo(454,327);g.lineTo(474,323);g.lineTo(474,306);g.curveTo(452,298,450,264);g.endFill();g.lineStyle(5,0xffda63);g.moveTo(449,269);g.curveTo(417,272,450,293);g.moveTo(511,269);g.curveTo(543,272,510,293);g.lineStyle();
            title("WORLD",438,348,84,23,13,0xffe36a,"center");
            if(int(s.champion)>=0){var champ:Object=s.teams[s.champion];logo(champ.city,uint(champ.accent),451,371,58);}
            else title("?",449,371,62,47,33,0xffe36a,"center");
        }
        private function record():void {
            if(getChildByName("post-record-panel"))return;
            var s:Object=GameData.postSeason,items:Array=[];
            for each(var history:Object in GameData.postSeasonHistory)items.push("SEASON "+history.season+" · "+(history.status=="champion"?"WORLD CHAMPION: "+history.teamName:"ELIMINATED · Champion: "+history.championName));
            if(items.length)items.push("─────────────────────");
            for each(var series:Object in s.series)if(series.home==s.hero||series.away==s.hero){
                var opponent:Object=s.teams[series.home==s.hero?series.away:series.home];
                for(var i:int=0;i<series.games.length;i++){var g:Object=series.games[i];items.push(PostSeason.ROUND_NAMES[series.round]+" · "+opponent.city+" · "+(i+1)+": "+g.homeScore+" — "+g.awayScore+(g.draw?" (TIE)":""));}
            }
            var panel:Sprite=new Sprite();panel.name="post-record-panel";panel.graphics.beginFill(0x0c3854,.99);panel.graphics.drawRoundRect(151,229,658,377,14);panel.graphics.endFill();addChild(panel);
            ClassicInventorySkin.text(panel,"POST SEASON · RECORD",174,244,590,35,23,0xffdf73);
            var t:TextField=ClassicInventorySkin.text(panel,items.length?items.join("\n"):"No games played yet.",174,291,590,298,14);t.mouseEnabled=true;t.selectable=true;
            var close:Sprite=ClassicInventorySkin.button("CLOSE",94,32);close.x=689;close.y=244;panel.addChild(close);
            close.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void {if(panel.parent)panel.parent.removeChild(panel);});
        }
        private function button(id:String,value:String,x:Number,y:Number,w:Number,callback:Function):void {
            var b:Sprite=ClassicInventorySkin.button(value,w,36);b.name=id;b.x=x;b.y=y;addChild(b);
            var handler:Function=function(e:MouseEvent):void {callback();};b.addEventListener(MouseEvent.CLICK,handler);buttons.push({view:b,handler:handler});
        }
        public function dispose():void {for each(var b:Object in buttons)b.view.removeEventListener(MouseEvent.CLICK,b.handler);for each(var l:TeamLogoView in logos)l.dispose();header.dispose();buttons=[];logos=[];}
    }
}
