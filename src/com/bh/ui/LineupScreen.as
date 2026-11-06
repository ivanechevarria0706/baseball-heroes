package com.bh.ui {
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
    import com.bh.audio.AudioCueSequence;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    import com.bh.visual.LeagueBadgeView;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import com.bh.visual.MatchStadium;
    import flash.geom.Point;
    import flash.utils.getTimer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.filters.ColorMatrixFilter;

    import com.bh.model.GameData;
    import com.bh.model.StarterTutorial;
    import com.bh.model.PlayerCondition;
    import com.bh.visual.TeamLogoView;
    import com.bh.visual.CharacterPortrait;

    public class LineupScreen extends Sprite {
        private var screenW:Number;
        private var screenH:Number;
        private var rowStep:Number=44;
        private var backdrop:MatchStadium;
        private var chrome:Sprite=new Sprite();
        private var dossier:PlayerDossier;
        private var friendsOverlay:FriendLineupOverlay;
        private var friendFilter:Boolean=false;
        private var friendsButton:LineupButton,friendRecruitButton:LineupButton;
        private var substitutionPreview:LineupSubstitutionPreview;
        private var feedback:Sprite=new Sprite(),feedbackAt:int=0;
        private var previewSlot:int=-1,previewPlayer:Object;
        private var previewText:TextField;
        private var comparisonChart:Sprite;
        private var chargeOverlay:SpecialChargeOverlay;
        private var rowClock:Timer=new Timer(1000);

        private var onHome:Function;
        private var onPlay:Function;
        private var batterShopCallback:Function;
        private var onTradeEnhance:Function;

        private var cues:AudioCueSequence=new AudioCueSequence();
        private var entrance:MenuEntrance;
        private var selectedSlot:int = 0;
        private var substitutePage:int = 0;
        private var substitutesPerPage:int = 9;
        private var leagueBadge:LeagueBadgeView;
        private var specialFilter:Boolean = false;
        private var starterCoach:StarterCoach;
        private var starterDisposed:Boolean=false;

        private var lineupLayer:Sprite;
        private var substituteLayer:Sprite;
        private var slotHeaderLayer:Sprite;

        private var lineupRows:Array = [];
        private var substituteRows:Array = [];

        private var opponent:Object;
        private var infoText:TextField;
        private var resourceCoins:TextField;
        private var resourceCash:TextField;
        private var teamLogoViews:Array = [];
        private var substituteTitleText:TextField;

        private var homeButton:LineupButton;
        private var autoButton:LineupButton;
        private var playButton:LineupButton;
        private var batterShopButton:LineupButton;
        private var tradeButton:LineupButton;
        private var allButton:LineupButton;
        private var specialButton:LineupButton;
        private var prevButton:LineupButton;
        private var nextButton:LineupButton;

        private var specialOverlay:SpecialBatterSlotOverlay;
        private var batterShopOverlay:BatterShopOverlay;
        private var dragGhost:Sprite;
        private var draggedPlayer:Object;
        private var dragSourceLineup:int = -1;
        private var dragMoved:Boolean = false;
        private var dragStartStageX:Number = 0;
        private var dragStartStageY:Number = 0;
        private var suppressClickUntil:int = 0;
        private var dropMarker:Sprite;

        public function LineupScreen(
            w:Number,
            h:Number,
            homeCallback:Function,
            playCallback:Function = null,
            batterShopCallback:Function = null,
            tradeEnhanceCallback:Function = null,
            timeSource:Function = null
        ) {
            super();
            GameData.allowUnavailableLineup=false;

            screenW = w;
            screenH = h;name="classic-lineup";

            onHome = homeCallback;
            onPlay = playCallback;
            this.batterShopCallback = batterShopCallback;
            onTradeEnhance = tradeEnhanceCallback;

            GameData.init();
            GameData.prepareLineupEditing();

            opponent =
                GameData.currentOpponent();

            drawBackground();
            drawTopBar();
            var headerChrome:Sprite=chrome;chrome=new Sprite();chrome.mouseEnabled=chrome.mouseChildren=false;addChild(chrome);
            drawPanels();
            drawTeamComparison();
            drawBottomButtons();

            renderSpecialSlots();
            renderLineup();
            renderSubstitutes();
            refreshStarterCoach();
            rowClock.addEventListener(TimerEvent.TIMER,tickRows);rowClock.start();

            if (
                GameData.onboardingStep ==
                GameData.ONBOARDING_LINEUP
            ) {
                drawFirstGameLineupTutorial();
            }
            entrance=new MenuEntrance(this,timeSource);
            for(var entryIndex:int=0;entryIndex<numChildren;entryIndex++){var entryChild:DisplayObject=getChildAt(entryIndex);if(entryChild===chrome||entryChild.y>=105&&entryChild!==backdrop&&entryChild.name!="lineup-tint")entrance.track(entryChild,300,320,960,0,1,0,0,false);}
            var veil:Sprite=new Sprite();veil.name="lineup-entry-fade";veil.mouseEnabled=veil.mouseChildren=false;veil.graphics.beginFill(0);veil.graphics.drawRect(0,95,w,h-95);veil.graphics.endFill();addChild(veil);entrance.track(veil,0,280,0,0,1,0,0,true,true);entrance.sound("stadium_lineup.mp3",80,.65);entrance.play();
        }

        private function refreshStarterCoach():void {
            if(starterDisposed)return;
            if(starterCoach){starterCoach.dispose();if(starterCoach.parent)starterCoach.parent.removeChild(starterCoach);starterCoach=null;}
            if(!GameData.tutorialActive()||batterShopOverlay)return;
            var stage:int=int(GameData.starterTutorial.stage),message:String="",action:String="",callback:Function=null;
            if(stage==StarterTutorial.SHOP){message="Recluta a tu primer Special Batter. Abre BATTER SHOP y compra el C Pack por 6,000 Coins.";action="ABRIR BATTER SHOP";callback=openBatterShopOverlay;}
            else if(stage==StarterTutorial.PACK||stage==StarterTutorial.CARD){message="Tu sobre ya está pagado. Ábrelo y pulsa OKAY para conocer a tu nuevo bateador.";action="ABRIR MI SOBRE";callback=openBatterShopOverlay;}
            else if(stage==StarterTutorial.SUBSTITUTE){
                if(int(GameData.starterTutorial.lesson)==1){message="Activa tu carta en Special 1.";action="SUSTITUIR BATEADOR";callback=function():void{GameData.useStarterCard();renderSpecialSlots();renderLineup();refreshStarterCoach();};}
                else message="Arrastra un compañero normal de SUBSTITUTE a una fila de LINE UP. También puedes colocar una carta especial en el puesto elegido.";
            }
            else if(stage==StarterTutorial.REORDER){message="Ahora arrastra la fila amarilla de tu héroe a otra posición para cambiar el orden de bateo.";}
            else if(stage==StarterTutorial.AUTOSORT){message="Haz clic en AUTO SORT si necesitas mi ayuda. Activaré tu nueva carta y prepararé el orden.";}
            else if(stage==StarterTutorial.ORDER){message="Ordena a tus bateadores: arrastra una fila a otra posición o pulsa AUTO SORT.";action="ORDENAR EQUIPO";callback=function():void{onAutoClick(null);};}
            else if(stage==StarterTutorial.PLAY){message="¡Tu equipo está listo! Pulsa PLAY para jugar tu primer partido. Cuesta 5 de energía.";}
            else if(stage==StarterTutorial.MATCH){message="Tu partido ya está pagado. Pulsa PLAY para reiniciarlo sin gastar más energía.";}
            else return;
            if(int(GameData.starterTutorial.lesson)!=1&&stage==StarterTutorial.SHOP){action="";callback=null;}
            starterCoach=new StarterCoach(message,action,callback,function():void{GameData.skipStarterTutorial();refreshStarterCoach();});starterCoach.x=32;starterCoach.y=510;addChild(starterCoach);
            if(int(GameData.starterTutorial.lesson)!=1){
                if(stage==StarterTutorial.SHOP)starterCoach.pointTo(new Rectangle(496,595,174,32),40,445);
                else if(stage==StarterTutorial.SUBSTITUTE)starterCoach.pointTo(new Rectangle(497,165,399,150),36,455);
                else if(stage==StarterTutorial.REORDER)starterCoach.pointTo(new Rectangle(25,165,420,396),464,420);
                else if(stage==StarterTutorial.AUTOSORT)starterCoach.pointTo(new Rectangle(626,655,181,42),40,470);
                else if(stage==StarterTutorial.PLAY||stage==StarterTutorial.MATCH)starterCoach.pointTo(new Rectangle(820,655,124,42),38,470);
            }
        }
        private function drawFirstGameLineupTutorial():void {
            if(infoText)infoText.text="ENTRENADOR: Elige una posición y un suplente, o arrastra para ordenar. Pulsa i para ver al jugador.";
        }

        private function control(id:String,title:String,x:Number,y:Number,w:Number,h:Number,cb:Function,color:uint):LineupButton {
            var b:LineupButton=new LineupButton(title,w,h,color,id=="HOME"||id=="AUTO"||id=="PLAY");
            b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,cb);addChild(b);return b;
        }

        private function openProfile(p:Object,bench:Boolean):void {clearDrag();closeProfile();var usePlayer:Function=null;if(bench)usePlayer=function():void {useSubstitute(p);closeProfile();};dossier=new PlayerDossier(p,screenW,screenH,closeProfile,usePlayer,'USE IN SLOT #'+(selectedSlot+1));addChild(dossier);}
        private function closeProfile():void {if(dossier){dossier.dispose();if(dossier.parent)dossier.parent.removeChild(dossier);dossier=null;}}
        private function drawBackground():void {
            backdrop=new MatchStadium(screenW,screenH);backdrop.name="lineup-stadium";addChild(backdrop);
            var shade:Sprite=new Sprite();shade.name="lineup-tint";shade.mouseEnabled=false;
            shade.graphics.beginFill(0x001d24,.46);shade.graphics.drawRect(0,0,screenW,screenH);shade.graphics.endFill();addChild(shade);
            chrome.mouseEnabled=chrome.mouseChildren=false;addChild(chrome);
        }

        private function resourcePill(px:Number,ww:Number,color:uint,border:uint):void {
            var m:Matrix=new Matrix();m.createGradientBox(ww,30,Math.PI/2,px,20);
            chrome.graphics.lineStyle(1.5,border);
            chrome.graphics.beginGradientFill(GradientType.LINEAR,[border,color,0x103f5c],[1,1,1],[0,105,255],m);
            chrome.graphics.drawRoundRect(px,20,ww,30,25,25);chrome.graphics.endFill();chrome.graphics.lineStyle();
        }

        private function drawTopBar():void {
            leagueBadge=new LeagueBadgeView(GameData.matchLeagueIndex(),GameData.matchLeagueShortName(),86);
            leagueBadge.x=10;leagueBadge.y=12;addChild(leagueBadge);
            resourcePill(128,186,0x086aa4,0x96d4ee);resourcePill(339,167,0x65b509,0xd2f27c);
            resourcePill(543,189,0x163d52,0x98acb5);resourcePill(768,176,0x163d52,0x98acb5);
            addText("LV.",110,23,27,17,10,0xffffff,TextFormatAlign.LEFT);
            var level:TextField=addText(String(GameData.level),136,12,43,37,27,0xffffff,TextFormatAlign.CENTER);
            level.filters=[new GlowFilter(0x193540,1,3,3,6)];
            addText(formatNumber(GameData.xp),176,23,127,23,16,0xffffff,TextFormatAlign.CENTER);
            ClassicInventorySkin.icon(this,"energy",326,10,1.05);var ef:TextField=addText(String(GameData.energy),373,23,119,23,17,0xffffff,TextFormatAlign.CENTER);var ec:EnergyClock=new EnergyClock(ef,175);ec.x=338;ec.y=44;addChild(ec);
            ClassicInventorySkin.icon(this,"coin",520,16,1.1);resourceCoins=addText(formatNumber(GameData.coins),560,23,162,23,16,0xffdf78,TextFormatAlign.CENTER);
            ClassicInventorySkin.icon(this,"cash",742,16,1.1);resourceCash=addText(String(GameData.cash),787,23,147,23,16,0xffffff,TextFormatAlign.CENTER);
            var title:TextField=addText(GameData.postSeasonMode?GameData.competitionTitle():GameData.seasonNumber+ordinalSeasonSuffix(GameData.seasonNumber)+" REGULAR SEASON",123,61,717,42,28,0xffffff,TextFormatAlign.LEFT);
            ClassicChrome.title(title,31,0xffffff,TextFormatAlign.LEFT);
        }

        private function drawPanels():void {
            ClassicChrome.panel(chrome.graphics,20,115,446,580);ClassicChrome.bar(chrome.graphics,26,121,434,38);
            heading("LINE UP",32,122,164,34,23,0xffffff,true);
            addText("SPECIAL",257,134,63,19,10,0x94d9f4,TextFormatAlign.RIGHT);
            slotHeaderLayer=new Sprite();slotHeaderLayer.x=328;slotHeaderLayer.y=130;addChild(slotHeaderLayer);
            lineupLayer=new Sprite();lineupLayer.x=25;lineupLayer.y=165;addChild(lineupLayer);
            ClassicChrome.well(chrome.graphics,477,115,465,522);
            heading("SUBSTITUTE",488,122,148,33,22,0x63635f,true);
            chrome.graphics.beginFill(0x555856);chrome.graphics.drawRect(490,163,415,406);chrome.graphics.endFill();
            for(var i:int=0;i<9;i++) {
                chrome.graphics.beginFill(0x484b48);chrome.graphics.drawRect(497,165+i*rowStep,402,40);chrome.graphics.endFill();
            }
            allButton=control("ALL","ALL",641,126,73,30,onAllFilter,0xcacaca);
            specialButton=control("SPECIAL","SPECIAL",718,126,88,30,onSpecialFilter,0xcacaca);
            friendsButton=control("FRIENDS_FILTER","FRIENDS",810,126,91,30,onFriendsFilter,0xcacaca);
            substituteTitleText=addText("",905,399,30,19,8,0xffffff,TextFormatAlign.CENTER);
            substituteLayer=new Sprite();substituteLayer.x=497;substituteLayer.y=165;addChild(substituteLayer);
            ClassicInventorySkin.gradient(chrome.graphics,913,165,17,403,0xbcbeb9,0x737773,16);
            ClassicInventorySkin.gradient(chrome.graphics,916,194,11,190,0xeceee9,0x919a96,10);
            prevButton=control("PREV","<",908,165,27,28,onPrevPage,0xcacaca);
            nextButton=control("NEXT",">",908,541,27,28,onNextPage,0xcacaca);
            infoText=addText("La flecha indica condición; la barra rosa muestra nivel y XP.",498,572,416,20,11,0x526777,TextFormatAlign.LEFT);
            infoText.wordWrap=true;infoText.name="lineup-message";
            friendRecruitButton=control("LINEUP_FRIENDS","FRIENDS",777,565,122,27,onFriendsClick,0x7cac43);
            infoText.width=275;infoText.y=565;infoText.height=29;
            var friendHintFormat:TextFormat=infoText.defaultTextFormat;friendHintFormat.size=10;infoText.defaultTextFormat=friendHintFormat;infoText.setTextFormat(friendHintFormat);
            if(GameData.pendingSpecialMatch())infoText.text="Partido pagado. Puedes cambiar jugadores; PLAY lo reinicia.";
            previewText=addText("",138,575,205,19,10,0xc4e4f5,TextFormatAlign.CENTER);previewText.name="selected-player-summary";previewText.visible=false;
        }

        private function heading(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,outline:Boolean):TextField {
            var t:TextField=addText(value,x,y,w,h,size,color,TextFormatAlign.LEFT);
            ClassicChrome.title(t,size+3,color,TextFormatAlign.LEFT);return t;
        }

        private function drawTeamComparison():void {
            drawTeamLogo(76,640,GameData.teamCity,GameData.teamAccent,"H");
            drawTeamLogo(398,640,String(opponent.city),uint(opponent.accent),"R");
            heading(String(GameData.seasonRank())+ordinalSeasonSuffix(GameData.seasonRank()),37,579,72,28,20,0xffffff,true);
            addText(GameData.seasonWins+"W "+GameData.seasonLosses+"L",38,677,80,17,12,0xffde63,TextFormatAlign.CENTER);
            addText("NEXT",366,580,71,24,16,0xffffff,TextFormatAlign.CENTER);
            addText(GameData.matchLeagueShortName(),365,675,75,17,10,0xffde63,TextFormatAlign.CENTER);
            var chart:Sprite=new Sprite();chart.name="lineup-comparison";chart.x=241;chart.y=636;addChild(chart);comparisonChart=chart;refreshComparison();
            substitutionPreview=new LineupSubstitutionPreview();substitutionPreview.x=124;substitutionPreview.y=574;addChild(substitutionPreview);
        }
        private function refreshComparison():void {
            if(!comparisonChart)return;var chart:Sprite=comparisonChart;while(chart.numChildren)chart.removeChildAt(0);chart.graphics.clear();
            var g:flash.display.Graphics=chart.graphics;
            g.lineStyle(2,0x154e83);g.beginFill(0x158dc8);g.moveTo(0,-43);g.lineTo(45,0);g.lineTo(0,43);g.lineTo(-45,0);g.lineTo(0,-43);g.endFill();
            g.lineStyle(1,0x7bd2ed,.6);g.moveTo(-45,0);g.lineTo(45,0);g.moveTo(0,-43);g.lineTo(0,43);g.lineStyle();
            var order:Array=GameData.visibleLineupPlayers(),c:Number=0,p:Number=0,v:Number=0,a:Number=0;
            for each(var player:Object in order){c+=GameData.effectiveContact(player);p+=GameData.effectivePower(player);v+=GameData.effectiveSpeed(player);a+=Number(player.avg)*100;}
            var n:Number=Math.max(1,order.length),values:Array=[c/n,a/n,p/n,v/n];
            g.lineStyle(2,0xffe36b);g.beginFill(0xffcf37,.9);
            g.moveTo(0,-Math.min(43,values[0]/100*43));g.lineTo(Math.min(45,values[1]/100*45),0);
            g.lineTo(0,Math.min(43,values[2]/100*43));g.lineTo(-Math.min(45,values[3]/100*45),0);
            g.lineTo(0,-Math.min(43,values[0]/100*43));g.endFill();g.lineStyle();
            addTextTo(chart,"CON",-22,-58,44,17,10,0x84cfef,TextFormatAlign.CENTER);
            addTextTo(chart,"AVG",49,-8,35,18,10,0x84cfef,TextFormatAlign.CENTER);
            addTextTo(chart,"POW",-22,43,44,17,10,0x84cfef,TextFormatAlign.CENTER);
            addTextTo(chart,"SPE",-84,-8,35,18,10,0x84cfef,TextFormatAlign.CENTER);
        }

        private function drawBottomButtons():void {
            batterShopButton=control("BATTER_SHOP","BATTER SHOP",496,595,174,32,onBatterShopClick,0xcacaca);
            tradeButton=control("TRADE","TRADE & ENHANCE",682,595,244,32,onTradeClick,0xcacaca);
            ClassicInventorySkin.icon(batterShopButton,"batter",7,0,.75);
            ClassicInventorySkin.icon(tradeButton,"case",8,1,.75);
            homeButton=control("HOME","HOME",477,655,135,42,onHomeClick,0xcacaca);
            autoButton=control("AUTO","AUTO SORT",626,655,181,42,onAutoClick,0xe3ac36);
            playButton=control("PLAY","PLAY",820,655,124,42,onPlayClick,0x80ce31);
        }

        private function renderSpecialSlots():void {
            while (
                slotHeaderLayer.numChildren > 0
            ) {
                slotHeaderLayer.removeChildAt(0);
            }

            var equipped:Array =
                GameData.equippedSpecialCards();

            for (
                var i:int = 0;
                i < 5;
                i++
            ) {
                var slot:Sprite =
                    new Sprite();

                var unlocked:Boolean =
                    i <
                    GameData.specialSlotsUnlocked;

                slot.graphics.beginFill(
                    unlocked
                    ? (
                        i == 0
                        ? 0x73b744
                        : 0x327eae
                    )
                    : 0x526978
                );

                slot.graphics.drawRoundRect(
                    0,
                    0,
                    23,
                    23,
                    4,
                    4
                );
                slot.graphics.endFill();

                slot.graphics.lineStyle(
                    1,
                    0xd4e8f0
                );
                slot.graphics.drawRoundRect(
                    0,
                    0,
                    23,
                    23,
                    4,
                    4
                );
                slot.graphics.lineStyle();

                var card:Object =
                    unlocked &&
                    GameData.specialEquipped[i]!=null
                    ? GameData.specialCardById(String(GameData.specialEquipped[i]))
                    : null;

                var label:String =
                    !unlocked
                    ? ""
                    : (
                        card
                        ? (GameData.specialCardEnergy(card.id)>0?String(card.cardClass):"0")
                        : "+"
                    );

                var t:TextField =
                    makeText(
                        label,
                        8,
                        0xffffff,
                        23,
                        15,
                        TextFormatAlign.CENTER
                    );

                t.y = 4;
                slot.addChild(t);
                if(!unlocked) {
                    slot.graphics.lineStyle(2,0xd0dce4);slot.graphics.drawRoundRect(8,4,8,10,5);
                    slot.graphics.lineStyle();slot.graphics.beginFill(0xc8d4dd);slot.graphics.drawRect(6,10,12,10);slot.graphics.endFill();
                    slot.graphics.beginFill(0x61778a);slot.graphics.drawRect(11,13,2,4);slot.graphics.endFill();
                }

                slot.x = i * 25;
                slot.name="lineup-special-"+i;
                slot.buttonMode = true;
                slot.useHandCursor = true;
                slot.mouseChildren = false;

                slot.addEventListener(
                    MouseEvent.CLICK,
                    onSpecialSlotClick
                );

                slotHeaderLayer.addChild(
                    slot
                );
            }
        }

        private function renderLineup():void {
            clearRows(
                lineupLayer,
                lineupRows
            );

            var order:Array =
                GameData.battingOrderPlayers();

            if (
                selectedSlot >=
                order.length
            ) {
                selectedSlot = 0;
            }

            for (
                var i:int = 0;
                i < order.length;
                i++
            ) {
                var row:Sprite =
                    createPlayerRow(
                        GameData.lineupCardAt(i)?GameData.lineupSpecialPlayer(GameData.lineupCardAt(i)):order[i],
                        i,
                        true,
                        i ==
                        selectedSlot
                    );

                row.name =
                    "slot_" +
                    i;

                row.y =
                    i * rowStep;

                row.addEventListener(
                    MouseEvent.CLICK,
                    onLineupClick
                );

                row.addEventListener(
                    MouseEvent.MOUSE_DOWN,
                    onLineupDown
                );

                lineupLayer.addChild(
                    row
                );

                lineupRows.push(
                    row
                );
            }
            if(previewText&&order.length){var selectedCard:Object=GameData.lineupCardAt(selectedSlot),selected:Object=selectedCard?GameData.lineupSpecialPlayer(selectedCard):order[selectedSlot];previewText.text=String(selected.name);}
            refreshComparison();
        }

        private function renderSubstitutes():void {
            refreshStarterCoach();
            clearRows(
                substituteLayer,
                substituteRows
            );

            var substitutes:Array =
                filteredSubstitutes();

            var all:Array=GameData.lineupSubstitutes();
            var countSpecial:int=0,countFriends:int=0;for each(var candidate:Object in all){if(isSpecialPlayer(candidate))countSpecial++;if(candidate.friendId)countFriends++;}
            allButton.setLabel("ALL ("+all.length+")");specialButton.setLabel("SPECIAL ("+countSpecial+")");
            friendsButton.setLabel("FRIENDS ("+countFriends+")");allButton.alpha=specialFilter||friendFilter?.72:1;specialButton.alpha=specialFilter?1:.72;friendsButton.alpha=friendFilter?1:.72;

            var pages:int =
                Math.max(
                    1,
                    Math.ceil(
                        substitutes.length /
                        substitutesPerPage
                    )
                );

            if (
                substitutePage >=
                pages
            ) {
                substitutePage =
                    pages - 1;
            }

            if (
                substitutePage < 0
            ) {
                substitutePage = 0;
            }
            substituteTitleText.text=(substitutePage+1)+"/"+pages;
            prevButton.alpha=substitutePage>0?1:.45;nextButton.alpha=substitutePage<pages-1?1:.45;
            prevButton.mouseEnabled=substitutePage>0;nextButton.mouseEnabled=substitutePage<pages-1;

            var start:int =
                substitutePage *
                substitutesPerPage;

            var end:int =
                Math.min(
                    substitutes.length,
                    start +
                    substitutesPerPage
                );

            if(!substitutes.length){
                var empty:Sprite=new Sprite();empty.mouseEnabled=empty.mouseChildren=false;substituteLayer.addChild(empty);
                var art:com.bh.visual.RecruitmentArtwork=new com.bh.visual.RecruitmentArtwork(friendFilter?"friends":"roster",76,76);art.x=162;art.y=98;empty.addChild(art);
                addTextTo(empty,friendFilter?"NO FRIENDS ON THE BENCH":specialFilter?"NO SPECIAL BATTERS ON THE BENCH":"YOUR SUBSTITUTES APPEAR HERE",22,183,356,48,15,0xd9edf0,TextFormatAlign.CENTER);
                var tip:TextField=addTextTo(empty,friendFilter?"Abre FRIENDS para incorporar amigos. Los que ya juegan están en el panel izquierdo.":"Los jugadores que retires de LINEUP aparecerán aquí.",28,237,345,69,12,0xb2c8ce,TextFormatAlign.CENTER);tip.wordWrap=true;LineupTypography.fit(tip,12,0xb2c8ce,TextFormatAlign.CENTER,false,11);substituteRows.push(empty);
            }
            for (
                var i:int = start;
                i < end;
                i++
            ) {
                var local:int =
                    i - start;

                var row:Sprite =
                    createPlayerRow(
                        substitutes[i],
                        i,
                        false,
                        false
                    );

                row.name =
                    "bench_" +
                    i;
                row.addEventListener(MouseEvent.ROLL_OVER,onBenchOver);row.addEventListener(MouseEvent.ROLL_OUT,onBenchOut);

                row.y =
                    local * rowStep;

                row.addEventListener(
                    MouseEvent.CLICK,
                    onSubstituteClick
                );

                row.addEventListener(
                    MouseEvent.MOUSE_DOWN,
                    onSubstituteDown
                );

                substituteLayer.addChild(
                    row
                );

                substituteRows.push(
                    row
                );
            }
        }

        private function createPlayerRow(p:Object,index:int,lineup:Boolean,selected:Boolean):Sprite {
            var rowW:Number=lineup?420:402,row:Sprite=new Sprite();row.buttonMode=true;row.mouseChildren=true;
            var hero:Boolean=p===GameData.mainPlayer(),special:Boolean=Boolean(p.specialCardId),empty:Boolean=special&&GameData.specialCardEnergy(String(p.specialCardId))==0;
            var g:flash.display.Graphics=row.graphics;ClassicChrome.well(g,0,0,rowW,40,selected);
            if(hero&&!empty)ClassicChrome.fill(g,3,3,rowW-6,34,[0xfff9cd,0xffdf63,0xe9b62c],[0,110,255],5);
            if(empty)ClassicChrome.fill(g,3,3,rowW-6,34,[0xdee3e1,0xb5bfbc,0x939f9b],[0,110,255],5);
            var classColor:uint=p.cardClass=="C"?0x7fbd3c:p.cardClass=="B"?0x43a5cf:p.cardClass=="A"?0xe4b53b:0xd95a43;
            var tileX:Number=lineup?27:3,portraitX:Number=lineup?59:37,nameX:Number=lineup?94:78;
            if(lineup){ClassicInventorySkin.gradient(g,0,0,25,40,selected?0x96f3ff:hero?0xfff17a:0xf0f9ff,selected?0x137eb9:hero?0xf2cf34:0x83c9e8,20);addTextTo(row,String(index+1),0,9,24,26,20,selected?0xffffff:0x164a6c,TextFormatAlign.CENTER);}
            if(selected){g.lineStyle(2,0x55ddff,.95);g.drawRoundRect(2,2,rowW-4,36,6);g.lineStyle();}
            g.lineStyle(1,0x334949);ClassicInventorySkin.gradient(g,tileX,3,29,34,special&&!empty?ClassicChrome.blend(classColor,0xffffff,.25):0x94a7a1,special&&!empty?ClassicChrome.blend(classColor,0x132b21,.4):0x49635b,2);g.lineStyle();
            if(special){addTextTo(row,String(p.triggerInning)+(p.triggerInning==1?"ST":p.triggerInning==2?"ND":p.triggerInning==3?"RD":"TH"),tileX,4,29,15,8,0xffffff,TextFormatAlign.CENTER);addTextTo(row,p.guaranteedHit=="SINGLE"?"1B":p.guaranteedHit=="DOUBLE"?"2B":p.guaranteedHit=="TRIPLE"?"3B":"HR",tileX,18,29,16,11,0xffffff,TextFormatAlign.CENTER);}
            else addTextTo(row,String(p.pos),tileX,10,29,22,11,0xffffff,TextFormatAlign.CENTER);
            var portrait:CharacterPortrait=new CharacterPortrait(p,33,37,true);portrait.x=portraitX;portrait.y=1;row.addChild(portrait);
            if(p.friendId){var friendMark:com.bh.visual.RecruitmentArtwork=new com.bh.visual.RecruitmentArtwork("friends",13,13);friendMark.name="lineup-friend-badge";friendMark.x=portraitX+20;friendMark.y=23;row.addChild(friendMark);}
            if(empty)portrait.filters=[new ColorMatrixFilter([.3,.59,.11,0,0,.3,.59,.11,0,0,.3,.59,.11,0,0,0,0,0,1,0])];
            var nameW:Number=special?107:lineup?137:121;
            var nt:TextField=addTextTo(row,String(p.name),nameX,10,nameW,24,13,empty?0x5e6d69:hero?0x8a5125:0x244962,TextFormatAlign.LEFT);nt.name="lineup-player-name";LineupTypography.fit(nt,13,nt.textColor,"left",false,9);
            var meterX:Number=lineup?237:209;
            if(special){
                var gx:Number=lineup?204:188;gradeBadge(row,p,gx,empty);
                g.lineStyle(1,0x245121);g.beginFill(empty?0x6e7b72:classColor);g.drawCircle(portraitX+27,7,7);g.endFill();g.lineStyle();addTextTo(row,String(p.cardClass),portraitX+20,-1,14,16,9,0xffffff,TextFormatAlign.CENTER);
                var energy:LineupCardEnergy=new LineupCardEnergy(String(p.specialCardId),lineup?88:80);energy.x=lineup?240:221;energy.y=11;energy.name="player-energy-"+index;row.addChild(energy);
                if(empty){var charge:LineupButton=new LineupButton("CHARGE",86,24,0x86c737,true);charge.x=rowW-90;charge.y=8;charge.name="lineup-charge-"+p.specialCardId;charge.addEventListener(MouseEvent.MOUSE_DOWN,stopRowDrag);charge.addEventListener(MouseEvent.CLICK,onChargeClick);row.addChild(charge);}
            }else if(p!==GameData.mainPlayer()){
                var progress:Number=Math.max(0,Math.min(1,Number(p.xp)/100));g.lineStyle(1,0x79384f);ClassicChrome.fill(g,meterX,11,91,18,[0xe4b9c7,0x8f3455,0x683248],[0,110,255],18);g.lineStyle();
                if(progress>0)ClassicChrome.fill(g,meterX+17,14,Math.max(1,71*progress),12,[0xffbed5,0xdf789f,0xb9507e],[0,120,255],12);
                g.lineStyle(1,0xa65775);ClassicChrome.fill(g,meterX-2,8,24,24,[0xffd2e2,0xbd5e83,0x74334c],[0,120,255],24);g.lineStyle();var lv:TextField=addTextTo(row,String(p.level),meterX-1,10,22,23,12,0xffffff,TextFormatAlign.CENTER);lv.name="player-level-"+index;
            }
            if(!empty){var avgX:Number=lineup?332:305;addTextTo(row,formatAverage(p.avg),avgX,10,53,23,13,0x414943,TextFormatAlign.CENTER);
                var info:ConditionArrow=new ConditionArrow(GameData.matchCondition(p),function():void{openProfile(p,!lineup);});info.name=(lineup?"info_slot_":"info_bench_")+index;info.x=rowW-27;info.y=7;row.addChild(info);}
            return row;
        }
        private function gradeBadge(row:Sprite,p:Object,x:Number,gray:Boolean):void {
            var count:int=p.grade=="HERO"?3:p.grade=="ELITE"?3:p.grade=="RARE"?2:1,g:flash.display.Graphics=row.graphics;
            for(var j:int=0;j<count;j++){var cx:Number=x+4+j*7,cy:Number=7;g.lineStyle(.5,0x60502b);g.beginFill(gray?0x8a9389:0xffd84d);for(var k:int=0;k<10;k++){var a:Number=-Math.PI/2+k*Math.PI/5,r:Number=k%2==0?3.7:1.6;if(k==0)g.moveTo(cx+Math.cos(a)*r,cy+Math.sin(a)*r);else g.lineTo(cx+Math.cos(a)*r,cy+Math.sin(a)*r);}g.endFill();}g.lineStyle();
            addTextTo(row,p.grade=="A"?"NORM":String(p.grade),x-3,12,35,16,8,gray?0x68736a:0x846123,TextFormatAlign.CENTER);
            if(p.enhancement>0)addTextTo(row,"+"+p.enhancement,x,24,28,14,8,gray?0x68736a:0xc74d52,TextFormatAlign.CENTER);
        }
        private function onFriendsClick(e:MouseEvent):void {clearDrag();closeProfile();hidePreview();if(friendsOverlay)return;friendsOverlay=new FriendLineupOverlay(closeFriends,function(player:Object=null):void{if(player){friendFilter=true;specialFilter=false;substitutePage=0;}renderLineup();renderSubstitutes();},function(player:Object):void{useSubstitute(player);closeFriends();},selectedSlot);addChild(friendsOverlay);}
        private function closeFriends():void {if(friendsOverlay){friendsOverlay.dispose();if(friendsOverlay.parent)friendsOverlay.parent.removeChild(friendsOverlay);friendsOverlay=null;}}
        private function onFriendsFilter(e:MouseEvent):void{friendFilter=true;specialFilter=false;substitutePage=0;hidePreview();renderSubstitutes();}
        private function onBenchOver(e:MouseEvent):void{if(dragGhost||friendsOverlay||dossier)return;var p:Object=playerForBenchRow(e.currentTarget as Sprite);if(p)showPreview(p,selectedSlot);}
        private function onBenchOut(e:MouseEvent):void{if(!dragMoved)hidePreview();}
        private function showPreview(p:Object,slot:int):void{if(!substitutionPreview||slot<0)return;if(substitutionPreview.visible&&previewSlot==slot&&previewPlayer===p)return;var order:Array=GameData.visibleLineupPlayers();if(slot>=order.length)return;previewSlot=slot;previewPlayer=p;substitutionPreview.show(p,order[slot],slot);comparisonChart.visible=false;}
        private function hidePreview():void{previewSlot=-1;previewPlayer=null;if(substitutionPreview)substitutionPreview.visible=false;if(comparisonChart)comparisonChart.visible=true;}
        private function flashSlot(slot:int):void{if(slot<0||slot>8)return;feedback.graphics.clear();feedback.graphics.lineStyle(3,0xffe585);feedback.graphics.drawRoundRect(1,1,418,38,6);feedback.mouseEnabled=feedback.mouseChildren=false;feedback.x=25;feedback.y=165+slot*rowStep;feedback.alpha=1;addChild(feedback);feedbackAt=getTimer();addEventListener(Event.ENTER_FRAME,onFeedback);}
        private function onFeedback(e:Event):void{feedback.alpha=Math.max(0,1-(getTimer()-feedbackAt)/450);if(feedback.alpha<=0){removeEventListener(Event.ENTER_FRAME,onFeedback);if(feedback.parent)feedback.parent.removeChild(feedback);}}
        private function tickRows(e:TimerEvent):void {
            resourceCoins.text=formatNumber(GameData.coins);resourceCash.text=String(GameData.cash);
            if(starterDisposed)return;var changed:Boolean=false;
            for each(var rows:Array in [lineupRows,substituteRows])for each(var row:Sprite in rows)for(var i:int=0;i<row.numChildren;i++){var meter:LineupCardEnergy=row.getChildAt(i) as LineupCardEnergy;if(meter&&meter.refresh())changed=true;}
            if(changed){renderSpecialSlots();renderLineup();renderSubstitutes();GameData.save();}
        }
        private function stopRowDrag(e:MouseEvent):void {e.stopPropagation();}
        private function onChargeClick(e:MouseEvent):void {e.stopPropagation();if(starterDisposed||chargeOverlay)return;clearDrag();var id:String=String(e.currentTarget.name).substr(14);chargeOverlay=new SpecialChargeOverlay(id,closeCharge,onChargeUpdated);addChild(chargeOverlay);}
        private function closeCharge():void {if(chargeOverlay){chargeOverlay.dispose();if(chargeOverlay.parent)chargeOverlay.parent.removeChild(chargeOverlay);chargeOverlay=null;}}
        private function onChargeUpdated():void {renderSpecialSlots();renderLineup();renderSubstitutes();resourceCash.text=String(GameData.cash);}

        private function filteredSubstitutes():Array {
            var base:Array =
                GameData.lineupSubstitutes();
            if(friendFilter){var friends:Array=[];for each(var friend:Object in base)if(friend.friendId)friends.push(friend);return friends;}

            if (!specialFilter) {
                return base;
            }

            var result:Array = [];

            for each (
                var p:Object in base
            ) {
                if (
                    isSpecialPlayer(p)
                ) {
                    result.push(p);
                }
            }

            return result;
        }

        private function isSpecialPlayer(p:Object):Boolean {
            return p&&(p.specialCardId || p.grade=="HERO"||p.grade=="ELITE"||p.grade=="RARE");
        }

        private function onLineupClick(
            e:MouseEvent
        ):void {
            if (
                getTimer() <
                suppressClickUntil
            ) {
                return;
            }

            var row:Sprite =
                e.currentTarget as Sprite;

            if (!row) return;

            cues.enqueue("lineup_select.mp3",0,.7);
            selectedSlot =
                int(
                    row.name.substr(
                        5
                    )
                );

            renderLineup();

            infoText.text =
                "Batting slot #" +
                (selectedSlot + 1) +
                " selected.";
        }

        private function onLineupDown(
            e:MouseEvent
        ):void {
            var row:Sprite =
                e.currentTarget as Sprite;

            if (!row) return;

            var index:int =
                int(
                    row.name.substr(
                        5
                    )
                );

            var order:Array =
                GameData.battingOrderPlayers();

            if (
                index < 0 ||
                index >= order.length
            ) {
                return;
            }

            dragSourceLineup = index;
            var card:Object=GameData.lineupCardAt(index);
            draggedPlayer=card?GameData.lineupSpecialPlayer(card):order[index];
            dragMoved = false;
            dragStartStageX = e.stageX;
            dragStartStageY = e.stageY;

            createDragGhost(
                draggedPlayer,
                true
            );

            stage.addEventListener(
                MouseEvent.MOUSE_MOVE,
                onDragMove
            );

            stage.addEventListener(
                MouseEvent.MOUSE_UP,
                onDragUp
            );
        }

        private function onSubstituteClick(
            e:MouseEvent
        ):void {
            if (
                getTimer() <
                suppressClickUntil
            ) {
                return;
            }

            var player:Object =
                playerForBenchRow(
                    e.currentTarget
                    as Sprite
                );

            if (!player) return;

            useSubstitute(player);
        }

        private function useSubstitute(player:Object):void {
            hidePreview();var result:String=GameData.substituteBattingOrder(selectedSlot,player);applySubstitutionMessage(result,player,selectedSlot);
            renderSpecialSlots();
            renderLineup();renderSubstitutes();
            if(result=="OK"){suppressClickUntil=getTimer()+220;flashSlot(selectedSlot);}
        }

        private function onSubstituteDown(
            e:MouseEvent
        ):void {
            draggedPlayer =
                playerForBenchRow(
                    e.currentTarget
                    as Sprite
                );

            if (!draggedPlayer) {
                return;
            }

            dragSourceLineup = -1;
            dragMoved = false;
            dragStartStageX = e.stageX;
            dragStartStageY = e.stageY;

            createDragGhost(
                draggedPlayer,
                false
            );

            stage.addEventListener(
                MouseEvent.MOUSE_MOVE,
                onDragMove
            );

            stage.addEventListener(
                MouseEvent.MOUSE_UP,
                onDragUp
            );

            onDragMove(e);
        }

        private function createDragGhost(
            p:Object,
            fromLineup:Boolean
        ):void {
            clearDragVisuals();

            dragGhost =
                createPlayerRow(
                    p,
                    fromLineup
                    ? Math.max(
                        0,
                        dragSourceLineup
                    )
                    : 0,
                    fromLineup,
                    true
                );

            dragGhost.alpha = 0.82;
            dragGhost.mouseEnabled = false;
            dragGhost.mouseChildren = false;

            addChild(
                dragGhost
            );

            setChildIndex(
                dragGhost,
                numChildren - 1
            );
        }

        private function onDragMove(
            e:MouseEvent
        ):void {
            if (!dragGhost) return;

            var deltaX:Number =
                e.stageX -
                dragStartStageX;

            var deltaY:Number =
                e.stageY -
                dragStartStageY;

            if (
                Math.sqrt(
                    deltaX * deltaX +
                    deltaY * deltaY
                ) > 5
            ) {
                dragMoved = true;
            }

            var screenPoint:Point =
                globalToLocal(
                    new Point(
                        e.stageX,
                        e.stageY
                    )
                );

            dragGhost.x =
                screenPoint.x -
                dragGhost.width / 2;

            dragGhost.y =
                screenPoint.y -
                15;

            var slot:int =
                slotAtStagePoint(
                    e.stageX,
                    e.stageY
                );

            showDropMarker(
                slot
            );
            if(dragMoved&&dragSourceLineup<0&&slot>=0)showPreview(draggedPlayer,slot);else hidePreview();

            e.updateAfterEvent();
        }

        private function onDragUp(
            e:MouseEvent
        ):void {
            // Keep an ordinary click's target alive until Flash dispatches CLICK.
            // Rebuilding rows on MOUSE_UP swallowed clicks on substitute players.
            if(!dragMoved){clearDrag();return;}
            var changed:Boolean=false;
            var slot:int =
                slotAtStagePoint(
                    e.stageX,
                    e.stageY
                );

            if (
                dragGhost &&
                draggedPlayer &&
                slot >= 0
            ) {
                selectedSlot = slot;

                if (
                    dragSourceLineup >= 0
                ) {
                    if (
                        dragSourceLineup !=
                        slot &&
                        GameData.moveBattingOrder(
                            dragSourceLineup,
                            slot
                        )
                    ) {
                        changed=true;
                        infoText.text =
                            draggedPlayer.name +
                            " moved from #" +
                            (dragSourceLineup + 1) +
                            " to #" +
                            (slot + 1) +
                            ".";
                    }
                    else if (
                        dragSourceLineup ==
                        slot
                    ) {
                        infoText.text =
                            "Batting slot #" +
                            (slot + 1) +
                            " selected.";
                    }
                }
                else {
                    var result:String =
                        GameData.substituteBattingOrder(
                            slot,
                            draggedPlayer
                        );

                    applySubstitutionMessage(
                        result,
                        draggedPlayer,
                        slot
                    );
                    changed=result=="OK";
                }
            }
            else if(dragMoved&&dragSourceLineup>=0&&overSubstitutes(e.stageX,e.stageY)) {
                if(draggedPlayer.specialCardId){
                    var benchStatus:String=GameData.benchSpecialBatter(dragSourceLineup);
                    infoText.text=benchStatus=="OK"?draggedPlayer.name+" volvió a SUBSTITUTE.":"Termina el partido pendiente antes de cambiar la alineación.";
                }else{
                    var replacement:Object=benchAtStagePoint(e.stageX,e.stageY);
                    if(replacement)applySubstitutionMessage(GameData.substituteBattingOrder(dragSourceLineup,replacement),replacement,dragSourceLineup);
                    else infoText.text="Suelta al jugador sobre un suplente para intercambiarlos.";
                }
            }else if(dragMoved)infoText.text="Suelta sobre LINE UP o SUBSTITUTE para mover al jugador.";

            if (dragMoved) {
                suppressClickUntil =
                    getTimer() + 180;
            }

            clearDrag();renderSpecialSlots();
            renderLineup();
            renderSubstitutes();refreshStarterCoach();
            if(changed&&slot>=0){flashSlot(slot);cues.enqueue("lineup_select.mp3",0,.7);}
        }

        private function overSubstitutes(sx:Number,sy:Number):Boolean {
            var pt:Point=substituteLayer.globalToLocal(new Point(sx,sy));return pt.x>=0&&pt.x<=402&&pt.y>=0&&pt.y<9*rowStep;
        }
        private function benchAtStagePoint(sx:Number,sy:Number):Object {
            var pt:Point=substituteLayer.globalToLocal(new Point(sx,sy)),index:int=int(pt.y/rowStep);
            return index>=0&&index<substituteRows.length?playerForBenchRow(substituteRows[index]):null;
        }
        private function slotAtStagePoint(
            stageX:Number,
            stageY:Number
        ):int {
            if (!lineupLayer) {
                return -1;
            }

            var point:Point =
                lineupLayer.globalToLocal(
                    new Point(
                        stageX,
                        stageY
                    )
                );

            var order:Array =
                GameData.battingOrderPlayers();

            if (
                point.x < 0 ||
                point.x > 420 ||
                point.y < 0 ||
                point.y >=
                order.length * rowStep
            ) {
                return -1;
            }

            return Math.max(
                0,
                Math.min(
                    order.length - 1,
                    int(
                        point.y / rowStep
                    )
                )
            );
        }

        private function showDropMarker(
            slot:int
        ):void {
            if (slot < 0) {
                if (dropMarker) {
                    dropMarker.visible = false;
                }
                return;
            }

            if (!dropMarker) {
                dropMarker =
                    new Sprite();

                dropMarker.mouseEnabled = false;
                dropMarker.mouseChildren = false;
                addChild(
                    dropMarker
                );
            }

            dropMarker.graphics.clear();
            dropMarker.graphics.beginFill(
                0xffd642,
                0.16
            );
            dropMarker.graphics.lineStyle(
                3,
                0xffd642,
                0.96
            );
            dropMarker.graphics.drawRoundRect(
                0,
                0,
                420,
                39,
                5,
                5
            );
            dropMarker.graphics.endFill();
            dropMarker.graphics.lineStyle();

            dropMarker.x =
                lineupLayer.x;
            dropMarker.y =
                lineupLayer.y +
                slot * rowStep;
            dropMarker.visible = true;

            setChildIndex(
                dropMarker,
                numChildren - 1
            );

            if (dragGhost) {
                setChildIndex(
                    dragGhost,
                    numChildren - 1
                );
            }
        }

        private function applySubstitutionMessage(
            result:String,
            player:Object,
            slot:int
        ):void {
            if (result == "OK") {
                infoText.text=player.name+" en #"+(slot+1)+". Cambio guardado.";
            }
            else if (result == "HERO") {
                infoText.text="El héroe se puede reordenar, pero debe seguir en LINEUP.";
            }
            else if(result=="MATCH_ACTIVE")infoText.text="Termina el partido pendiente antes de cambiar la alineación.";
            else if(result=="FULL")infoText.text="Reemplaza una carta activa o desbloquea otra ranura SPECIAL.";
            else if (result == "ALREADY") {
                infoText.text =
                    player.name +
                    " ya está en la alineación.";
            }
            else {
                infoText.text =
                    "No se pudo guardar la alineación.";
            }
        }

        private function clearDragVisuals():void {
            disposeRowPortraits(dragGhost);
            if (
                dragGhost &&
                dragGhost.parent
            ) {
                dragGhost.parent.removeChild(
                    dragGhost
                );
            }

            dragGhost = null;

            if (dropMarker) {
                dropMarker.visible = false;
            }
        }

        private function clearDrag():void {
            hidePreview();
            if (stage) {
                stage.removeEventListener(
                    MouseEvent.MOUSE_MOVE,
                    onDragMove
                );

                stage.removeEventListener(
                    MouseEvent.MOUSE_UP,
                    onDragUp
                );
            }

            clearDragVisuals();

            draggedPlayer = null;
            dragSourceLineup = -1;
            dragMoved = false;
        }

        private function playerForBenchRow(
            row:Sprite
        ):Object {
            if (!row) return null;

            var index:int =
                int(
                    row.name.substr(
                        6
                    )
                );

            var list:Array =
                filteredSubstitutes();

            if (
                index < 0 ||
                index >= list.length
            ) {
                return null;
            }

            return list[index];
        }

        private function onSpecialSlotClick(
            e:MouseEvent
        ):void {
            openSpecialOverlay();
        }

        private function openSpecialOverlay():void {
            closeSpecialOverlay();

            specialOverlay =
                new SpecialBatterSlotOverlay(
                    closeSpecialOverlay,
                    onBatterShop,
                    onSpecialSlotsUpdated
                );

            specialOverlay.x =
                screenW / 2;

            specialOverlay.y = 145;

            addChild(
                specialOverlay
            );
        }

        private function closeSpecialOverlay():void {
            if (!specialOverlay) {
                return;
            }

            specialOverlay.dispose();

            if (
                specialOverlay.parent
            ) {
                specialOverlay.parent.removeChild(
                    specialOverlay
                );
            }

            specialOverlay = null;
        }

        private function onAllFilter(
            e:MouseEvent
        ):void {
            specialFilter = false;
            friendFilter=false;hidePreview();
            substitutePage = 0;
            renderSubstitutes();
        }

        private function onSpecialFilter(
            e:MouseEvent
        ):void {
            specialFilter = true;
            friendFilter=false;hidePreview();
            substitutePage = 0;
            renderSubstitutes();
        }

        private function onPrevPage(
            e:MouseEvent
        ):void {
            if (substitutePage <= 0) {
                return;
            }

            substitutePage--;
            renderSubstitutes();
        }

        private function onNextPage(
            e:MouseEvent
        ):void {
            var total:int =
                filteredSubstitutes().length;

            var pages:int =
                Math.max(
                    1,
                    Math.ceil(
                        total /
                        substitutesPerPage
                    )
                );

            if (
                substitutePage >=
                pages - 1
            ) {
                return;
            }

            substitutePage++;
            renderSubstitutes();
        }

        private function onAutoClick(
            e:MouseEvent
        ):void {
            if(GameData.tutorialActive()&&[StarterTutorial.SUBSTITUTE,StarterTutorial.REORDER].indexOf(int(GameData.starterTutorial.stage))>=0&&int(GameData.starterTutorial.lesson)!=1){refreshStarterCoach();return;}
            GameData.autoOptimizeBattingOrder();
            GameData.autoReadyLineup();
            refreshStarterCoach();
            selectedSlot = 0;

            renderLineup();
            renderSubstitutes();

            infoText.text =
                "AUTO SORT completed.";
        }

        private function onBatterShopClick(
            e:MouseEvent
        ):void {
            onBatterShop();
        }

        private function onBatterShop():void {
            closeSpecialOverlay();
            openBatterShopOverlay();
        }

        private function openBatterShopOverlay():void {
            closeBatterShopOverlay();

            batterShopOverlay =
                new BatterShopOverlay(
                    closeBatterShopOverlay,
                    onBatterShopUpdated
                );

            batterShopOverlay.y=(screenH-540)/2;
            // Keep the shop centered while its backdrop covers the classic viewport.
            batterShopOverlay.graphics.clear();
            batterShopOverlay.graphics.beginFill(0x000000,0.58);
            batterShopOverlay.graphics.drawRect(0,-batterShopOverlay.y,screenW,screenH);
            batterShopOverlay.graphics.endFill();
            addChild(batterShopOverlay);
            refreshStarterCoach();
        }

        private function closeBatterShopOverlay():void {
            if (!batterShopOverlay) {
                return;
            }

            batterShopOverlay.dispose();

            if (
                batterShopOverlay.parent
            ) {
                batterShopOverlay.parent.removeChild(
                    batterShopOverlay
                );
            }

            batterShopOverlay = null;
            if(GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.SUBSTITUTE&&int(GameData.starterTutorial.lesson)!=1){specialFilter=false;substitutePage=0;}
            refreshStarterCoach();

            renderSpecialSlots();
            renderLineup();
            renderSubstitutes();

            if (infoText) {
                infoText.text =
                    "Tus cartas compradas están en SUBSTITUTE > SPECIAL. Haz clic para activar un bateador.";
            }
        }

        private function onBatterShopUpdated(
            card:Object = null
        ):void {
            resourceCoins.text=formatNumber(GameData.coins);resourceCash.text=String(GameData.cash);
            if(card){specialFilter=true;substitutePage=0;var cards:Array=filteredSubstitutes();for(var i:int=0;i<cards.length;i++)if(cards[i].specialCardId==card.id)substitutePage=int(i/substitutesPerPage);}
            renderSpecialSlots();
            renderLineup();
            renderSubstitutes();

            if (
                card &&
                infoText
            ) {
                infoText.text =
                    String(
                        card.name
                    ) +
                    " está en SUBSTITUTE > SPECIAL. Haz clic para activarlo.";
            }
        }

        private function onTradeClick(
            e:MouseEvent
        ):void {
            if (
                onTradeEnhance != null
            ) {
                onTradeEnhance();
            }
        }

        private function onHomeClick(
            e:MouseEvent
        ):void {
            if (onHome != null) {
                onHome();
            }
        }

        private function onPlayClick(
            e:MouseEvent
        ):void {
            if(GameData.tutorialActive()&&[StarterTutorial.SHOP,StarterTutorial.PACK,StarterTutorial.CARD,StarterTutorial.SUBSTITUTE,StarterTutorial.ORDER,StarterTutorial.REORDER,StarterTutorial.AUTOSORT].indexOf(int(GameData.starterTutorial.stage))>=0){refreshStarterCoach();return;}
            GameData.refreshEnergy();if(!GameData.specialMatch&&GameData.energy<5){showLowEnergy();return;}
            if(GameData.unstartablePlayers().length>0){showUnstartable();return;}
            if (onPlay != null) {
                onPlay();
            }
        }

        private var unavailableOverlay:Sprite;
        private function showLowEnergy():void {
            if(unavailableOverlay)return;unavailableOverlay=new Sprite();unavailableOverlay.name="insufficient-energy";addChild(unavailableOverlay);
            var g:flash.display.Graphics=unavailableOverlay.graphics;g.beginFill(0x031728,.65);g.drawRect(0,0,screenW,screenH);g.endFill();ClassicInventorySkin.panel(g,160,194,640,320);
            ClassicInventorySkin.text(unavailableOverlay,"NECESITAS 5 DE ENERGÍA",184,224,592,45,29,0xffe374,"center",true);
            var body:TextField=ClassicInventorySkin.text(unavailableOverlay,"Energía actual: "+GameData.energy+" / "+GameData.maxEnergy+"\nRecuperas 1 de energía cada 5 minutos.\n"+GameData.energyCountdown(),195,295,570,110,19,0xffffff,"center",true);body.wordWrap=true;addOverlayButton("energy-back","BACK",405,closeUnavailable);
        }
        private function showUnstartable():void {
            if(unavailableOverlay)return;
            unavailableOverlay=new Sprite();unavailableOverlay.name="unstartable-batter";addChild(unavailableOverlay);
            var g:flash.display.Graphics=unavailableOverlay.graphics;g.beginFill(0x031728,.65);g.drawRect(0,0,screenW,screenH);g.endFill();
            ClassicInventorySkin.panel(g,160,194,640,320);
            var names:Array=[];for each(var p:Object in GameData.unstartablePlayers())names.push(p.name);
            var title:TextField=ClassicInventorySkin.text(unavailableOverlay,"BATEADOR AGOTADO",184,214,592,40,28,0xffe374,"center",true);
            var body:TextField=ClassicInventorySkin.text(unavailableOverlay,names.join(", ")+"\n\nAUTO SORT busca suplentes disponibles. SKIP conserva el equipo: los agotados dan OUT. Recuperan 1 de energía cada 30 minutos.",195,269,570,145,17,0xffffff,"center",true);body.wordWrap=true;
            addOverlayButton("unstartable-auto","AUTO SORT",206,function():void{closeUnavailable();onAutoClick(null);});
            addOverlayButton("unstartable-skip","SKIP",420,function():void{closeUnavailable();GameData.allowUnavailableLineup=true;if(onPlay!=null)onPlay();});
            addOverlayButton("unstartable-back","BACK",634,closeUnavailable);
        }
        private function addOverlayButton(id:String,title:String,x:Number,fn:Function):void {
            var button:LineupButton=new LineupButton(title,150,40,0x8cbd36,true);button.name=id;button.x=x;button.y=448;
            button.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{e.stopPropagation();fn();});unavailableOverlay.addChild(button);
        }
        private function closeUnavailable():void {if(unavailableOverlay&&unavailableOverlay.parent)removeChild(unavailableOverlay);unavailableOverlay=null;}

        private function drawTeamLogo(
            px:Number,
            py:Number,
            city:String,
            color:uint,
            letter:String
        ):void {
            var logo:TeamLogoView =
                new TeamLogoView(
                    city,
                    color,
                    letter,
                    78
                );
            logo.x = px - 39;
            logo.y = py - 39;
            addChild(logo);
            teamLogoViews.push(logo);
        }

        private function clearRows(
            layer:Sprite,
            rows:Array
        ):void {
            for each (
                var row:Sprite in rows
            ) {
                disposeRowPortraits(row);
                row.removeEventListener(
                    MouseEvent.CLICK,
                    onLineupClick
                );

                row.removeEventListener(
                    MouseEvent.MOUSE_DOWN,
                    onLineupDown
                );

                row.removeEventListener(
                    MouseEvent.CLICK,
                    onSubstituteClick
                );

                row.removeEventListener(
                    MouseEvent.MOUSE_DOWN,
                    onSubstituteDown
                );
                row.removeEventListener(MouseEvent.ROLL_OVER,onBenchOver);row.removeEventListener(MouseEvent.ROLL_OUT,onBenchOut);
            }

            while (
                layer.numChildren > 0
            ) {
                layer.removeChildAt(0);
            }

            rows.length = 0;
        }

        private function onSpecialSlotsUpdated():void {
            renderSpecialSlots();renderLineup();renderSubstitutes();
            resourceCoins.text=formatNumber(GameData.coins);
            resourceCash.text=String(GameData.cash);
        }

        private function disposeRowPortraits(row:Sprite):void {
            if(!row) return;
            for(var i:int=0;i<row.numChildren;i++) {
                var portrait:CharacterPortrait=row.getChildAt(i) as CharacterPortrait;
                if(portrait) portrait.dispose();
                var icon:com.bh.visual.RecruitmentArtwork=row.getChildAt(i) as com.bh.visual.RecruitmentArtwork;if(icon)icon.dispose();
                var arrow:ConditionArrow=row.getChildAt(i) as ConditionArrow;if(arrow)arrow.dispose();
                var button:LineupButton=row.getChildAt(i) as LineupButton;if(button){button.removeEventListener(MouseEvent.MOUSE_DOWN,stopRowDrag);button.removeEventListener(MouseEvent.CLICK,onChargeClick);button.dispose();}
            }
        }

        private function ordinalSeasonSuffix(
            n:int
        ):String {
            var mod100:int =
                n % 100;

            if (
                mod100 >= 11 &&
                mod100 <= 13
            ) {
                return "TH";
            }

            var mod10:int =
                n % 10;

            if (mod10 == 1) return "ST";
            if (mod10 == 2) return "ND";
            if (mod10 == 3) return "RD";

            return "TH";
        }

        private function ordinalRankSuffix(
            n:int
        ):String {
            return ordinalSeasonSuffix(
                n
            ).toLowerCase();
        }

        private function formatAverage(
            value:*
        ):String {
            var s:String =
                String(value);

            if (
                s.indexOf(".") ==
                0
            ) {
                return s;
            }

            var n:Number =
                Number(s);

            if (!isNaN(n)) {
                if (n >= 1) {
                    return "1.000";
                }

                var digits:int =
                    int(
                        n * 1000
                    );

                var result:String =
                    String(digits);

                while (
                    result.length < 3
                ) {
                    result =
                        "0" +
                        result;
                }

                return "." +
                       result;
            }

            return s;
        }

        private function formatNumber(
            value:int
        ):String {
            var s:String =
                String(value);

            var result:String = "";

            while (
                s.length > 3
            ) {
                result =
                    "," +
                    s.substr(
                        s.length - 3
                    ) +
                    result;

                s =
                    s.substr(
                        0,
                        s.length - 3
                    );
            }

            return s + result;
        }

        private function makeText(
            text:String,
            size:int,
            color:uint,
            w:Number,
            h:Number,
            align:String
        ):TextField {
            var field:TextField =
                new TextField();

            var format:TextFormat =
                new TextFormat(
                    "Arial",
                    size,
                    color,
                    true
                );

            format.align = align;

            field.defaultTextFormat =
                format;

            field.text = text;
            LineupTypography.apply(field,size,color,align);
            field.width = w;
            field.height = h;
            LineupTypography.fit(field,size,color,align);
            field.selectable = false;
            field.mouseEnabled = false;

            return field;
        }

        private function addText(
            text:String,
            x:Number,
            y:Number,
            w:Number,
            h:Number,
            size:int,
            color:uint,
            align:String
        ):TextField {
            var field:TextField =
                makeText(
                    text,
                    size,
                    color,
                    w,
                    h,
                    align
                );

            field.x = x;
            field.y = y;

            addChild(field);

            return field;
        }

        private function addTextTo(
            parent:Sprite,
            text:String,
            x:Number,
            y:Number,
            w:Number,
            h:Number,
            size:int,
            color:uint,
            align:String
        ):TextField {
            var field:TextField =
                makeText(
                    text,
                    size,
                    color,
                    w,
                    h,
                    align
                );

            field.x = x;
            field.y = y;

            parent.addChild(
                field
            );

            return field;
        }

        public function dispose():void {
            removeEventListener(Event.ENTER_FRAME,onFeedback);if(substitutionPreview)substitutionPreview.dispose();
            if(friendsButton){friendsButton.removeEventListener(MouseEvent.CLICK,onFriendsFilter);friendsButton.dispose();}
            if(friendRecruitButton){friendRecruitButton.removeEventListener(MouseEvent.CLICK,onFriendsClick);friendRecruitButton.dispose();}
            closeFriends();
            if(entrance)entrance.dispose();cues.dispose();
            starterDisposed=true;rowClock.stop();rowClock.removeEventListener(TimerEvent.TIMER,tickRows);closeCharge();
            if(starterCoach){starterCoach.dispose();starterCoach=null;}
            closeUnavailable();
            closeProfile();
            if(backdrop){backdrop.dispose();backdrop=null;}
            if(leagueBadge) {leagueBadge.dispose();leagueBadge=null;}
            for each (var logo:TeamLogoView in teamLogoViews) {
                logo.dispose();
            }
            teamLogoViews = [];
            clearDrag();
            closeSpecialOverlay();
            closeBatterShopOverlay();

            if (
                dropMarker &&
                dropMarker.parent
            ) {
                dropMarker.parent.removeChild(
                    dropMarker
                );
            }
            dropMarker = null;

            clearRows(
                lineupLayer,
                lineupRows
            );

            clearRows(
                substituteLayer,
                substituteRows
            );

            if (slotHeaderLayer) {
                for (
                    var i:int = 0;
                    i < slotHeaderLayer.numChildren;
                    i++
                ) {
                    Sprite(
                        slotHeaderLayer.getChildAt(i)
                    ).removeEventListener(
                        MouseEvent.CLICK,
                        onSpecialSlotClick
                    );
                }
            }

            if (homeButton) {
                homeButton.removeEventListener(
                    MouseEvent.CLICK,
                    onHomeClick
                );
                homeButton.dispose();
            }

            if (autoButton) {
                autoButton.removeEventListener(
                    MouseEvent.CLICK,
                    onAutoClick
                );
                autoButton.dispose();
            }

            if (playButton) {
                playButton.removeEventListener(
                    MouseEvent.CLICK,
                    onPlayClick
                );
                playButton.dispose();
            }

            if (batterShopButton) {
                batterShopButton.removeEventListener(
                    MouseEvent.CLICK,
                    onBatterShopClick
                );
                batterShopButton.dispose();
            }

            if (tradeButton) {
                tradeButton.removeEventListener(
                    MouseEvent.CLICK,
                    onTradeClick
                );
                tradeButton.dispose();
            }

            if (allButton) {
                allButton.removeEventListener(
                    MouseEvent.CLICK,
                    onAllFilter
                );
                allButton.dispose();
            }

            if (specialButton) {
                specialButton.removeEventListener(
                    MouseEvent.CLICK,
                    onSpecialFilter
                );
                specialButton.dispose();
            }

            if (prevButton) {
                prevButton.removeEventListener(
                    MouseEvent.CLICK,
                    onPrevPage
                );
                prevButton.dispose();
            }

            if (nextButton) {
                nextButton.removeEventListener(
                    MouseEvent.CLICK,
                    onNextPage
                );
                nextButton.dispose();
            }
        }
    }
}
