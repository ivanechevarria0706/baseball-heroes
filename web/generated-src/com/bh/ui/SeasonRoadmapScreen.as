package com.bh.ui {
    import flash.display.Sprite;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import com.bh.model.GameData;
    import com.bh.audio.AudioCueSequence;
    import com.bh.visual.TeamLogoView;
    import com.bh.visual.LeagueBadgeView;

    /** Five-card carousel and season strip observed at 05:10 in the supplied video.
     * Browsing is read-only; Continue always uses GameData.currentOpponent(). */
    public class SeasonRoadmapScreen extends Sprite {
        private var standings:SeasonStandingsOverlay;
        private var entrance:MenuEntrance;
        private var onHome:Function;
        private var onContinue:Function;
        private var cardLayer:Sprite=new Sprite();
        private var progressLayer:Sprite=new Sprite();
        private var logos:Array=[];
        private var buttons:Array=[];
        private var badge:LeagueBadgeView;
        private var previous:LineupButton;
        private var next:LineupButton;
        private var detail:TextField;
        private var matchup:SeasonMatchBanner;
        private var pageLabel:TextField;
        private var startGame:int=1;
        private var selectedGame:int;
        private const COUNT:int=5;

        public function SeasonRoadmapScreen(w:Number,h:Number,homeCallback:Function,continueCallback:Function,timeSource:Function=null) {
            super();name="classic-season";
            onHome=homeCallback;onContinue=continueCallback;GameData.init();
            selectedGame=GameData.seasonGame;
            startGame=Math.max(1,Math.min(26,selectedGame-2));
            drawBackground(w,h);drawHeader();
            addChild(cardLayer);addChild(progressLayer);
            previous=button("season-prev","<",36,417,28,72,0xcacaca,onPrevious);
            next=button("season-next",">",898,417,28,72,0xcacaca,onNext);
            detail=label(this,"",60,285,840,40,13,0xffe8bb,"center");
            detail.multiline=true;detail.wordWrap=true;detail.name="season-detail";
            pageLabel=label(this,"",330,574,300,23,13,0xc5e8a0,"center");pageLabel.name="season-page";
            label(this,"Season\nProgress",9,614,68,38,10,0xd4ebae,"right");
            label(this,"RECORD  "+GameData.seasonRecord()+"     RANK  "+GameData.seasonRank(),87,647,450,23,13,0xffdf6c);
            label(this,GameData.seasonComplete?"SEASON COMPLETE":(30-GameData.seasonWins-GameData.seasonLosses)+" Matches Left",625,644,262,23,13,0xd7eeac,"right");
            button("season-home","HOME",16,674,106,36,0xcacaca,onHomeClick);
            button("season-standings","RECORD",134,674,120,36,0xe3ac36,onStandings);
            button("season-current",GameData.seasonComplete?"LAST GAME":"NEXT MATCH",476,674,174,36,0x7caf30,onCurrent);
            button("season-continue",GameData.postSeasonInProgress()?"POST SEASON":GameData.seasonComplete?"NEXT SEASON":"LINE UP",725,674,164,36,0x7caf30,onContinueClick);
            renderCards();renderProgress();showDetail(selectedGame);
            entrance=new MenuEntrance(this,timeSource,renderEntrance);
            var veil:Sprite=new Sprite();veil.name="calendar-entry-fade";veil.mouseEnabled=veil.mouseChildren=false;veil.graphics.beginFill(0);veil.graphics.drawRect(0,95,w,h-95);veil.graphics.endFill();addChild(veil);entrance.track(veil,0,340,0,0,1,0,0,true,true);
            entrance.track(progressLayer,80,220,0,12);for(var i:int=0;i<cardLayer.numChildren;i++)entrance.track(cardLayer.getChildAt(i),250+i*110,270,0,16,.14,72,206);
            entrance.track(detail,1050,220,0,10);entrance.track(pageLabel,900,200);entrance.track(matchup,2200,420,0,0,1,0,0,false);entrance.sound("calendar_open.mp3");entrance.play();
        }

        private function renderEntrance(ms:int):void {if(matchup)matchup.setEntrance(Math.max(0,Math.min(1,(ms-2200)/420)));}
        private function settleEntrance():void {if(entrance)entrance.finish();}
        private function drawBackground(w:Number,h:Number):void {
            var m:Matrix=new Matrix();m.createGradientBox(w*1.6,h*2,0,-w*.25,0);
            graphics.beginGradientFill(GradientType.RADIAL,GameData.leagueIndex==0?[0xa66a0d,0x6c3106,0x190c07]:[0x85c918,0x347f09,0x000900],[1,1,1],[0,150,255],m);
            graphics.drawRect(0,0,w,h);graphics.endFill();
            // Static grid and sweep lines; no frame listener or bitmap rebuilding.
            graphics.lineStyle(1,GameData.leagueIndex==0?0xb37420:0x254d09,GameData.leagueIndex==0?.06:.18);
            for(var x:int=0;x<w;x+=27){graphics.moveTo(x,95);graphics.lineTo(x,h);}
            for(var y:int=125;y<h;y+=40){graphics.moveTo(0,y);graphics.lineTo(w,y);}
            graphics.lineStyle(4,GameData.leagueIndex==0?0xe9b25a:0xaadd43,.08);
            for(var i:int=0;i<4;i++){
                graphics.moveTo(0,250+i*26);graphics.curveTo(w*.48,-30+i*30,w,220+i*43);
            }
            graphics.lineStyle(2,0xc2ef65,.1);graphics.moveTo(0,685);graphics.curveTo(300,532,960,593);graphics.lineStyle();
        }

        private function pill(x:Number,w:Number,a:uint,b:uint):void {
            graphics.lineStyle(1.5,0xacd8d9);ClassicInventorySkin.gradient(graphics,x,20,w,27,a,b,27);graphics.lineStyle();
        }
        private function drawHeader():void {
            badge=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),82);badge.x=8;badge.y=9;addChild(badge);
            pill(135,179,0x289bd3,0x075780);pill(341,166,0xa6e23e,0x426b0a);
            pill(550,179,0x203c32,0x102820);pill(775,170,0x203c32,0x102820);
            label(this,"LV.",109,25,29,19,10);label(this,String(GameData.level),139,8,47,38,27,0xffffff,"center",true);
            label(this,formatNumber(GameData.xp),182,22,120,23,16,0xffffff,"center");
            ClassicInventorySkin.icon(this,"energy",320,9,1.05);label(this,GameData.energy+" / "+GameData.maxEnergy,367,22,128,23,16,0xffffff,"center");
            ClassicInventorySkin.icon(this,"coin",519,13,1.1);label(this,formatNumber(GameData.coins),561,22,155,23,16,0xffdf78,"center");
            ClassicInventorySkin.icon(this,"cash",741,13,1.1);label(this,String(GameData.cash),790,22,138,23,16,0xffffff,"center");
            label(this,GameData.seasonNumber+ordinal(GameData.seasonNumber)+" REGULAR SEASON",129,58,790,40,28,0xffffff,"left",true);
        }

        private function renderCards():void {
            clearCards();
            for(var i:int=0;i<COUNT;i++){
                var n:int=startGame+i,card:Sprite=createCard(n);card.x=89+i*159;card.y=350;cardLayer.addChild(card);
            }
            pageLabel.text="GAMES "+startGame+" - "+(startGame+COUNT-1)+" / 30";
            previous.alpha=startGame==1?.35:1;previous.mouseEnabled=startGame>1;
            next.alpha=startGame==26?.35:1;next.mouseEnabled=startGame<26;
        }
        private function createCard(n:int):Sprite {
            var r:Object=GameData.seasonResultForGame(n),o:Object=opponent(n,r);
            var current:Boolean=n==GameData.seasonGame&&!GameData.seasonComplete;
            var card:Sprite=new Sprite();card.name="game_"+n;card.mouseChildren=false;card.buttonMode=true;
            card.graphics.beginFill(0x080c09,.4);card.graphics.drawRoundRect(2,4,144,206,13);card.graphics.endFill();
            card.graphics.lineStyle(n==selectedGame?3:2,n==selectedGame?0xf2d03c:0x121f16);
            ClassicInventorySkin.gradient(card.graphics,0,0,144,206,current?0xaff4ff:0xffffff,current?0x43bbd1:0xb2b9b9,13);
            card.graphics.lineStyle(2,0xe6f0de,.75);card.graphics.drawRoundRect(3,3,138,200,10);card.graphics.lineStyle();
            card.graphics.lineStyle(1.5,0x879b91);ClassicInventorySkin.gradient(card.graphics,47,-22,50,43,0xe2efeb,current?0x52ccec:0x9eaaa4,43);card.graphics.lineStyle();
            label(card,String(n),48,-21,48,39,22,0x485f66,"center",true);
            var logo:TeamLogoView=new TeamLogoView(String(o.city),uint(o.accent),String(o.teamName).substr(0,1),76);
            logo.x=64;logo.y=30;card.addChild(logo);logos.push(logo);
            var vs:TextField=label(card,"VS",12,57,45,29,23,0x45606c,"center",true);ClassicChrome.title(vs,25,0x314a58);vs.filters=[];
            // The original's home/away and opponent ranks are not in this model.
            // Show existing opponent data in the same compact band instead.
            ClassicInventorySkin.gradient(card.graphics,24,128,96,20,0xb8ca60,0x778a2b,20);
            label(card,String(o.city),5,130,134,19,10,0x324620,"center");
            ClassicChrome.well(card.graphics,7,163,57,34,false,false);
            ClassicChrome.well(card.graphics,80,163,57,34,false,false);
            var known:Boolean=r&&(r.scoreKnown===undefined||Boolean(r.scoreKnown));
            label(card,known?String(r.homeScore):"-",8,163,55,36,25,r?0xffc03b:0x7f8983,"center",true);
            label(card,":",64,165,16,30,21,0x33452c,"center");
            label(card,known?String(r.awayScore):"-",81,163,55,36,25,r?0xffffff:0x7f8983,"center",true);
            if(r||current){
                drawStamp(card,r?(Boolean(r.win)?"WIN":"LOSE"):"NEXT MATCH",r?34:16,r?(Boolean(r.win)?0xffdc49:0xf7806b):0xbbf5ff);
            }
            var kind:String=GameData.seasonEventType(n);
            if(kind!="REGULAR")label(card,kind,8,107,128,20,12,kind=="SPECIAL"?0x9b3b12:0x175292,"center",true);
            card.addEventListener(MouseEvent.CLICK,onCard);return card;
        }
        private function drawStamp(card:Sprite,value:String,size:int,color:uint):void {
            // Offset embedded glyphs keep the hard outline readable in both
            // browser renderers, where TextField blur filters vary.
            var group:Sprite=new Sprite();group.x=-3;group.y=28;group.rotation=-7;group.mouseEnabled=false;card.addChild(group);
            var offsets:Array=[[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]];
            for(var layer:int=0;layer<2;layer++)for each(var p:Array in offsets){
                var border:TextField=label(group,value,p[0]*(layer==0?3:1),p[1]*(layer==0?3:1),150,43,size,layer==0?0x102318:0xffffff,"center",true);
                border.wordWrap=false;border.multiline=false;border.filters=[];
            }
            var face:TextField=label(group,value,0,0,150,43,size,color,"center",true);face.wordWrap=false;face.multiline=false;face.filters=[];
        }
        private function opponent(n:int,r:Object):Object {
            var o:Object=GameData.opponentForGame(n);
            if(r){
                if(r.opponentCity!==undefined)o.city=r.opponentCity;
                if(r.opponentTeam!==undefined)o.teamName=r.opponentTeam;
                if(r.opponentAccent!==undefined)o.accent=r.opponentAccent;
            }
            return o;
        }

        private function renderProgress():void {
            while(progressLayer.numChildren){var old:Sprite=progressLayer.getChildAt(0) as Sprite;old.removeEventListener(MouseEvent.CLICK,onProgress);progressLayer.removeChild(old);}
            for(var n:int=1;n<=30;n++){
                var r:Object=GameData.seasonResultForGame(n),s:Sprite=new Sprite();s.name="season-progress-"+n;s.x=82+(n-1)*27.1;s.y=617;
                s.mouseChildren=false;s.buttonMode=true;
                s.graphics.lineStyle(1,n==selectedGame?0xefffd3:0x689333,n==selectedGame?1:.55);
                s.graphics.beginFill(r?(Boolean(r.win)?0xeabb36:0xb74232):0x2c6310,.82);s.graphics.drawRect(0,0,26,25);s.graphics.endFill();s.graphics.lineStyle();
                label(s,r?(Boolean(r.win)?"W":"L"):String(n),0,4,26,20,11,r?0x1e3918:0x98b970,"center");
                if(n==GameData.seasonGame&&!GameData.seasonComplete){s.graphics.beginFill(0x70e6ff);s.graphics.moveTo(8,-9);s.graphics.lineTo(18,-9);s.graphics.lineTo(13,-3);s.graphics.lineTo(8,-9);s.graphics.endFill();}
                s.addEventListener(MouseEvent.CLICK,onProgress);progressLayer.addChild(s);
            }
        }
        private function showDetail(n:int):void {
            var r:Object=GameData.seasonResultForGame(n),o:Object=opponent(n,r);
            if(matchup){matchup.dispose();removeChild(matchup);}
            matchup=new SeasonMatchBanner(o,n,r);matchup.y=110;addChild(matchup);
            if(GameData.seasonComplete&&n==GameData.seasonGame){
                var summary:Object=GameData.lastSeasonSummary;
                var league:String=summary&&Boolean(summary.promoted)?"PROMOTED TO "+String(summary.league)+" · ":GameData.leagueName()+" LEAGUE · ";
                detail.text="SEASON COMPLETE   "+GameData.seasonWins+" W / "+GameData.seasonLosses+" L   RANK "+GameData.seasonRank()+"\n"+league+(GameData.postSeasonInProgress()?"POST SEASON · Gana tres partidos para pasar de ronda.":"NEXT SEASON: fija tus metas antes del partido 1.");
                LineupTypography.fit(detail,13,0xffe8bb,"center",false,11);return;
            }
            var known:Boolean=r&&(r.scoreKnown===undefined||Boolean(r.scoreKnown));
            detail.text=r?"GAME "+n+"   "+(Boolean(r.win)?"WIN":"LOSS")+"   "+(known?r.homeScore+" : "+r.awayScore:"SCORE --"):(n==GameData.seasonGame?"NEXT MATCH":"GAME "+n)+"   PITCHER "+o.pitcherName+"   OVR "+o.rating;
            var kind:String=GameData.seasonEventType(n),hint:String=kind=="SPECIAL"?"SPECIAL · Gana una Mystery Box y ábrela en INVENTORY.":kind=="RIVAL"?"RIVAL · Premio por ganar: 2,000 Coins.":"";
            if(n!=GameData.seasonGame)hint+=(hint?"  ":"")+(GameData.seasonComplete?"NEXT SEASON inicia un calendario nuevo.":"LINE UP continúa en el partido "+GameData.seasonGame+".");
            if(hint)detail.appendText("\n"+hint);LineupTypography.fit(detail,13,0xffe8bb,"center",false,11);
        }
        private function select(n:int,jump:Boolean):void {
            settleEntrance();selectedGame=n;if(jump)startGame=Math.max(1,Math.min(26,n-2));
            renderCards();renderProgress();showDetail(n);
        }
        private function onCard(e:MouseEvent):void {select(int(e.currentTarget.name.substr(5)),false);}
        private function onProgress(e:MouseEvent):void {select(int(e.currentTarget.name.substr(16)),true);}
        private function onPrevious(e:MouseEvent):void {settleEntrance();if(startGame>1){startGame--;renderCards();}}
        private function onNext(e:MouseEvent):void {settleEntrance();if(startGame<26){startGame++;renderCards();}}
        private function onCurrent(e:MouseEvent):void {select(GameData.seasonGame,true);}
        private function onStandings(e:MouseEvent):void {settleEntrance();if(standings)return;standings=new SeasonStandingsOverlay(closeStandings);addChild(standings);}
        private function closeStandings():void {if(standings){standings.dispose();if(standings.parent)removeChild(standings);standings=null;}}
        public function handleEscape():Boolean {if(!standings)return false;closeStandings();return true;}
        private function onHomeClick(e:MouseEvent):void {if(onHome!=null)onHome();}
        private function onContinueClick(e:MouseEvent):void {if(onContinue!=null)onContinue();}
        private function button(id:String,value:String,x:Number,y:Number,w:Number,h:Number,c:uint,cb:Function):LineupButton {
            var b:LineupButton=new LineupButton(value,w,h,c,true);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,cb);addChild(b);buttons.push({view:b,handler:cb});return b;
        }
        private function label(p:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint=0xffffff,align:String="left",heavy:Boolean=false):TextField {
            var t:TextField=ClassicInventorySkin.text(p,value,x,y,w,h,size,color,align);
            LineupTypography.apply(t,size,color,align,heavy);if(heavy)t.filters=[new GlowFilter(0x183128,1,3,3,6)];return t;
        }
        private function ordinal(n:int):String {if(n%100>=11&&n%100<=13)return "TH";if(n%10==1)return "ST";if(n%10==2)return "ND";if(n%10==3)return "RD";return "TH";}
        private function formatNumber(n:int):String {var s:String=String(n),r:String="";while(s.length>3){r=","+s.substr(s.length-3)+r;s=s.substr(0,s.length-3);}return s+r;}
        private function clearCards():void {
            for each(var logo:TeamLogoView in logos)logo.dispose();logos=[];
            while(cardLayer.numChildren){var card:Sprite=cardLayer.getChildAt(0) as Sprite;card.removeEventListener(MouseEvent.CLICK,onCard);cardLayer.removeChild(card);}
        }
        public function dispose():void {closeStandings();if(entrance)entrance.dispose();
            if(matchup){matchup.dispose();matchup=null;}
            clearCards();if(badge){badge.dispose();badge=null;}
            while(progressLayer.numChildren){var s:Sprite=progressLayer.getChildAt(0) as Sprite;s.removeEventListener(MouseEvent.CLICK,onProgress);progressLayer.removeChild(s);}
            for each(var b:Object in buttons){b.view.removeEventListener(MouseEvent.CLICK,b.handler);b.view.dispose();}buttons=[];
            onHome=null;onContinue=null;
        }
    }
}
