package com.bh.ui {
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.filters.ColorMatrixFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.ui.Keyboard;
    import flash.utils.getTimer;

    import com.bh.model.GameData;
    import com.bh.model.StarterTutorial;
    import com.bh.model.SpecialCardCatalog;
    import com.bh.visual.AssetImage;
    import com.bh.visual.SpecialCardIllustration;
    import com.bh.visual.VisualAssetRegistry;

    public class BatterShopOverlay extends Sprite {
        private static const MODE_SHOP:String = "SHOP";
        private static const MODE_OPEN:String = "OPEN";
        private static const MODE_RESULT:String = "RESULT";
        private static const MODE_REVEAL:String="REVEAL";
        private var peel:CardPeelReveal;
        private var revealAt:int;
        private var revealedCard:SpecialBatterCardView;
        private var revealRays:Sprite,revealFlash:Sprite,packet:Sprite;
        private var sparkles:Array=[],openingAt:int;

        private var closeCallback:Function;
        private var updatedCallback:Function;

        private var modal:Sprite;
        private var shopLayer:Sprite;
        private var openingLayer:Sprite;
        private var resultLayer:Sprite;

        private var closeButton:UIButton;
        private var specialTab:UIButton;
        private var regularTab:UIButton;
        private var okayButton:UIButton;

        private var tab:String = "SPECIAL";
        private var mode:String = MODE_SHOP;

        private var packEntries:Array = [];
        private var activeAssets:Array = [];
        private var packetArtwork:Array=[];

        private var pendingMeta:Object;
        private var pendingResult:Object;
        private var messageText:TextField;
        private var currencyText:TextField;

        public function BatterShopOverlay(
            closeHandler:Function,
            updatedHandler:Function = null
        ) {
            super();

            closeCallback = closeHandler;
            updatedCallback = updatedHandler;

            mouseEnabled = true;
            mouseChildren = true;

            drawDimmer();
            drawModal();
            rebuildShop();
            resumeTutorialPack();

            addEventListener(
                Event.ADDED_TO_STAGE,
                onAdded
            );
        }

        private function resumeTutorialPack():void {
            if(!GameData.tutorialActive()||GameData.starterTutorial.stage!=StarterTutorial.PACK&&GameData.starterTutorial.stage!=StarterTutorial.CARD)return;
            var card:Object=GameData.specialCardById(GameData.starterTutorial.cardId);if(!card)return;
            pendingMeta=SpecialCardCatalog.classPacks()[0];pendingResult={status:"OK",card:card,newCard:true};showPackOpening();
        }
        private function onAdded(e:Event):void {
            removeEventListener(
                Event.ADDED_TO_STAGE,
                onAdded
            );

            if (stage) {
                stage.addEventListener(
                    KeyboardEvent.KEY_DOWN,
                    onKeyDown
                );
            }
        }

        private function drawDimmer():void {
            graphics.beginFill(
                0x000000,
                0.58
            );
            graphics.drawRect(
                0,
                0,
                960,
                540
            );
            graphics.endFill();
        }

        private function drawModal():void {
            modal = new Sprite();
            modal.x = 215;
            modal.y = 38;
            addChild(modal);

            ClassicChrome.panel(modal.graphics,0,0,530,514);
            ClassicChrome.bar(modal.graphics,8,8,514,46);
            addTextTo(
                modal,
                "BATTER SHOP",
                22,
                14,
                215,
                32,
                24,
                0xffffff,
                TextFormatAlign.LEFT
            );

            currencyText = addTextTo(
                modal,
                "",
                280,
                18,
                170,
                24,
                11,
                0xffe07a,
                TextFormatAlign.RIGHT
            );

            closeButton =
                new UIButton(
                    "X",
                    42,
                    36,
                    0xa73d3a,
                    0xcb5650,
                    0xffb0a8
                );

            closeButton.x = 474;
            closeButton.name = "shop_close";
            closeButton.y = 12;
            closeButton.addEventListener(
                MouseEvent.CLICK,
                onCloseClick
            );
            modal.addChild(
                closeButton
            );

            specialTab =
                new UIButton(
                    "SPECIAL",
                    118,
                    34,
                    0x4788b4,
                    0x60a6d4,
                    0xa8d6ef
                );

            specialTab.name="pack-tab-special";specialTab.x = 132;
            specialTab.y = 65;
            specialTab.addEventListener(
                MouseEvent.CLICK,
                onSpecialTab
            );
            modal.addChild(
                specialTab
            );

            regularTab =
                new UIButton(
                    "REGULAR",
                    118,
                    34,
                    0x3d6a87,
                    0x5686a2,
                    0xa8d6ef
                );

            regularTab.name="pack-tab-regular";regularTab.x = 260;
            regularTab.y = 65;
            regularTab.addEventListener(
                MouseEvent.CLICK,
                onRegularTab
            );
            modal.addChild(
                regularTab
            );

            shopLayer = new Sprite();
            shopLayer.x = 16;
            shopLayer.y = 108;
            modal.addChild(
                shopLayer
            );

            openingLayer = new Sprite();
            openingLayer.x = 0;
            openingLayer.y = 50;
            openingLayer.visible = false;
            modal.addChild(
                openingLayer
            );

            resultLayer = new Sprite();
            resultLayer.x = 0;
            resultLayer.y = 50;
            resultLayer.visible = false;
            modal.addChild(
                resultLayer
            );

            messageText = addTextTo(
                modal,
                "",
                28,
                477,
                474,
                31,
                10,
                0xdcecf5,
                TextFormatAlign.CENTER
            );
        }

        private function rebuildShop():void {
            clearPackEntries();
            clearSprite(resultLayer);revealedCard=null;peel=null;
            clearSprite(
                shopLayer
            );

            mode = MODE_SHOP;specialTab.visible=regularTab.visible=true;closeButton.mouseEnabled=true;closeButton.alpha=1;specialTab.mouseEnabled=regularTab.mouseEnabled=true;
            shopLayer.visible = true;
            openingLayer.visible = false;
            resultLayer.visible = false;

            specialTab.alpha =
                tab == "SPECIAL"
                ? 1
                : 0.68;

            regularTab.alpha =
                tab == "REGULAR"
                ? 1
                : 0.68;

            currencyText.text =
                "C " +
                formatNumber(
                    GameData.coins
                ) +
                "    $ " +
                GameData.cash;

            messageText.text =
                tab == "SPECIAL"
                ? "Elige una clase. Descubrirás el grado al abrir el sobre."
                : "Elige un sobre de liga para conseguir otro bateador.";

            if (tab == "SPECIAL") {
                drawSpecialPacks();
            }
            else {
                drawRegularPacks();
            }
        }

        private function drawSpecialPacks():void {
            var definitions:Array=SpecialCardCatalog.classPacks();
            for(var i:int=0;i<definitions.length;i++)drawSpecialPackCard(definitions[i],4+(i%4)*124,5+int(i/4)*172);
            ClassicChrome.well(shopLayer.graphics,380,179,113,157,false,false);
            addTextTo(shopLayer,"CLASS + GRADE",384,188,105,23,11,0xffe586,TextFormatAlign.CENTER);
            addTextTo(shopLayer,"La clase y el grado son distintos.\nEl sobre indica qué grados puede contener.",386,220,101,104,10,0xd8e8ee,TextFormatAlign.CENTER);
            addTextTo(shopLayer,"Pasa el cursor por un sobre para consultar sus grados.",8,354,494,22,10,0xc5e4ee,TextFormatAlign.CENTER);
        }
        private function drawSpecialPackCard(data:Object,x:Number,y:Number):void {
            var card:Sprite=new Sprite(),cost:Object=GameData.specialClassPackCost(data.packClass),locked:Boolean=GameData.leagueIndex<int(cost.unlockLeague);
            card.name="pack_class_"+data.packClass;card.x=x;card.y=y;card.buttonMode=true;card.mouseChildren=false;
            ClassicChrome.well(card.graphics,0,0,118,164,false,true);
            drawClassPacket(card,12,8,94,103,data.packClass,uint(data.color));
            addTextTo(card,data.title,3,114,112,19,11,0x324650,TextFormatAlign.CENTER);
            var price:String=cost.coins>0?"C "+formatNumber(cost.coins):"$ "+cost.cash;
            card.graphics.lineStyle(1,0x203e48);ClassicChrome.fill(card.graphics,6,138,106,22,cost.coins>0?[0xffed95,0xf0b62c,0xb88120]:[0xe5ffae,0x8cca45,0x447b1c],[0,120,255],22);card.graphics.lineStyle();
            addTextTo(card,price,8,139,102,20,12,0x314958,TextFormatAlign.CENTER);
            if(locked){card.alpha=.57;var lock:Sprite=new Sprite();lock.x=95;lock.y=6;lock.graphics.lineStyle(2,0x354e60);lock.graphics.drawRoundRect(1,0,10,11,6);lock.graphics.beginFill(0x637c8c);lock.graphics.drawRoundRect(-1,7,14,13,3);lock.graphics.endFill();card.addChild(lock);}
            card.addEventListener(MouseEvent.CLICK,onPackClick);card.addEventListener(MouseEvent.MOUSE_OVER,onPackHover);card.addEventListener(MouseEvent.MOUSE_OUT,onPackOut);
            shopLayer.addChild(card);packEntries.push({view:card,data:data});
        }
        private function onPackHover(e:MouseEvent):void {
            if(mode!=MODE_SHOP)return;var p:Object=metaForView(e.currentTarget as Sprite);if(!p||!p.packClass)return;
            if(p.packClass=="C"&&GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.SHOP){messageText.text="C Pack del tutorial: Aramis Garcia · C HERO.";return;}
            var chances:Array=[];for each(var row:Object in SpecialCardCatalog.packWeights(p.packClass))chances.push(SpecialCardCatalog.gradeLabel(row.grade)+" "+(row.chance*100).toFixed(1)+"%");
            messageText.text="Grados: "+SpecialCardCatalog.packGradeLabel(p.packClass);
        }
        private function onPackOut(e:MouseEvent):void {if(mode==MODE_SHOP)messageText.text="Un bateador por sobre. La clase y el grado son independientes.";}

        private function drawRegularPacks():void {
            var leaguePack:String =
                currentLeaguePack();

            var definitions:Array = [
                {
                    title:"LEAGUE PACK",
                    asset:leaguePack,
                    type:"LEAGUE",
                    cost:"C 20,000",
                    locked:false
                },
                {
                    title:"SPECIAL MATCH",
                    asset:"special_match",
                    type:"LOCKED",
                    cost:"UNLOCK LATER",
                    locked:true
                },
                {
                    title:"HEROES",
                    asset:"heroes",
                    type:"HEROES",
                    cost:"$ 5",
                    locked:false
                }
            ];

            for (
                var i:int = 0;
                i <
                definitions.length;
                i++
            ) {
                drawRegularPackCard(
                    definitions[i],
                    12 + i * 164,
                    3
                );
            }
        }

        private function drawRegularPackCard(
            data:Object,
            x:Number,
            y:Number
        ):void {
            var card:Sprite =
                new Sprite();

            card.x = x;
            card.y = y;
            card.buttonMode =
                !Boolean(
                    data.locked
                );
            card.useHandCursor =
                !Boolean(
                    data.locked
                );
            card.mouseChildren = false;

            card.graphics.beginFill(
                0xe8ecee
            );
            card.graphics.drawRoundRect(
                0,
                0,
                150,
                205,
                12,
                12
            );
            card.graphics.endFill();

            card.graphics.lineStyle(
                3,
                Boolean(
                    data.locked
                )
                ? 0x6d767b
                : 0x79b7d7
            );
            card.graphics.drawRoundRect(
                0,
                0,
                150,
                205,
                12,
                12
            );
            card.graphics.lineStyle();

            var art:AssetImage =
                new AssetImage(
                    VisualAssetRegistry.cardPackPath(
                        String(
                            data.asset
                        )
                    ),
                    126,
                    151,
                    AssetImage.CONTAIN
                );

            art.x = 12;
            art.y = 4;
            card.addChild(
                art
            );
            activeAssets.push(
                art
            );

            addTextTo(
                card,
                String(
                    data.title
                ),
                8,
                157,
                134,
                18,
                10,
                0x354852,
                TextFormatAlign.CENTER
            );

            addTextTo(
                card,
                String(
                    data.cost
                ),
                8,
                180,
                134,
                18,
                9,
                Boolean(
                    data.locked
                )
                ? 0x7b8488
                : 0xc08727,
                TextFormatAlign.CENTER
            );

            if (
                !Boolean(
                    data.locked
                )
            ) {
                card.addEventListener(
                    MouseEvent.CLICK,
                    onPackClick
                );
            }

            shopLayer.addChild(
                card
            );

            packEntries.push({
                view:card,
                data:data
            });
        }

        private function onPackClick(
            e:MouseEvent
        ):void {
            e.stopPropagation();
            if(mode!=MODE_SHOP) return;

            var meta:Object =
                metaForView(
                    e.currentTarget
                    as Sprite
                );

            if(GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.SHOP&&meta&&meta.packClass!="C"){messageText.text="ENTRENADOR: Elige el C Pack para tu primer bateador.";return;}
            if (!meta) {
                return;
            }

            var result:Object;

            if (
                meta.packClass
            ) {
                result =
                    GameData.drawSpecialClassPack(
                        String(
                            meta.packClass
                        )
                    );
            }
            else if (
                String(
                    meta.type
                ) ==
                "LEAGUE"
            ) {
                result =
                    GameData.drawSpecialCardPack(
                        false
                    );
            }
            else if (
                String(
                    meta.type
                ) ==
                "HEROES"
            ) {
                result =
                    GameData.drawSpecialCardPack(
                        true
                    );
            }
            else {
                messageText.text =
                    "That pack is not active yet.";
                return;
            }

            if (
                !result ||
                String(
                    result.status
                ) !=
                "OK"
            ) {
                messageText.text =
                    result &&
                    String(
                        result.status
                    ) ==
                    "COINS"
                    ? "No tienes suficientes monedas."
                    : result&&result.status=="LOCKED"?"Disponible en "+SpecialCardCatalog.packLeagueName(int(result.unlockLeague))+". Sigue avanzando en la temporada.":"No tienes suficientes créditos.";
                refreshCurrency();
                return;
            }

            pendingMeta =
                meta;

            pendingResult =
                result;

            showPackOpening();
        }

        private function showPackOpening():void {
            mode = MODE_OPEN;specialTab.visible=regularTab.visible=false;closeButton.mouseEnabled=false;closeButton.alpha=.45;specialTab.mouseEnabled=regularTab.mouseEnabled=false;
            openingLayer.name="pack-open";

            shopLayer.visible = true;
            openingLayer.visible = true;
            resultLayer.visible = false;

            clearSprite(
                openingLayer
            );

            openingLayer.graphics.beginFill(
                0x06101b,
                0.34
            );
            openingLayer.graphics.drawRoundRect(
                9,
                7,
                512,
                346,
                12,
                12
            );
            openingLayer.graphics.endFill();

            addTextTo(
                openingLayer,
                "CLIC / ESPACIO PARA ABRIR",
                122,
                24,
                286,
                26,
                18,
                0xffdd62,
                TextFormatAlign.CENTER
            );

            packet=new Sprite();packet.x=265;packet.y=156;openingLayer.addChild(packet);
            if (
                pendingMeta &&
                pendingMeta.packClass
            ) {
                drawClassPacket(
                    packet,
                    -75,
                    -118,
                    150,
                    236,
                    String(
                        pendingMeta.packClass
                    ),
                    uint(
                        pendingMeta.color
                    )
                );
            }
            else {
                var assetId:String =
                    pendingMeta &&
                    String(
                        pendingMeta.type
                    ) ==
                    "HEROES"
                    ? "heroes"
                    : currentLeaguePack();

                var art:AssetImage =
                    new AssetImage(
                        VisualAssetRegistry.cardPackPath(
                            assetId
                        ),
                        150,
                        236,
                        AssetImage.CONTAIN
                    );

                art.x = -75;
                art.y = -118;
                packet.addChild(
                    art
                );
                activeAssets.push(
                    art
                );
            }

            openingAt=getTimer();addEventListener(Event.ENTER_FRAME,onPacketFrame);
            openingLayer.buttonMode = true;
            openingLayer.addEventListener(
                MouseEvent.CLICK,
                onOpeningClick
            );

            messageText.text =
                "Sobre comprado. Ábrelo para descubrir al bateador.";
            refreshCurrency();
        }

        private function onOpeningClick(
            e:MouseEvent
        ):void {
            e.stopPropagation();
            revealPendingCard();
        }

        private function revealPendingCard():void {
            if (
                mode != MODE_OPEN ||
                !pendingResult ||
                !pendingResult.card
            ) {
                return;
            }

            openingLayer.removeEventListener(
                MouseEvent.CLICK,
                onOpeningClick
            );

            removeEventListener(Event.ENTER_FRAME,onPacketFrame);
            GameData.tutorialEvent("open");
            mode = MODE_REVEAL;
            openingLayer.visible = true;
            resultLayer.visible = true;resultLayer.scrollRect=new Rectangle(0,0,530,360);
            clearSprite(
                resultLayer
            );

            resultLayer.graphics.beginFill(
                0x06101b,
                0.34
            );
            resultLayer.graphics.drawRoundRect(
                9,
                7,
                512,
                346,
                12,
                12
            );
            resultLayer.graphics.endFill();

            revealRays=new Sprite();revealRays.x=265;revealRays.y=155;revealRays.mouseEnabled=false;
            var color:uint=uint(pendingMeta.color),g:flash.display.Graphics=revealRays.graphics;
            for(var ray:int=0;ray<12;ray++){
                var angle:Number=ray*Math.PI/6;g.beginFill(color,.22);
                g.moveTo(Math.cos(angle)*36,Math.sin(angle)*36);
                g.lineTo(Math.cos(angle-.11)*185,Math.sin(angle-.11)*185);
                g.lineTo(Math.cos(angle+.11)*185,Math.sin(angle+.11)*185);g.endFill();
            }
            resultLayer.addChild(revealRays);sparkles=[];
            for(var n:int=0;n<18;n++){
                var star:Sprite=new Sprite();star.graphics.beginFill(n%2?0xffffff:0xffe166);
                star.graphics.moveTo(0,-5);star.graphics.lineTo(2,-2);star.graphics.lineTo(5,0);star.graphics.lineTo(2,2);star.graphics.lineTo(0,5);star.graphics.lineTo(-2,2);star.graphics.lineTo(-5,0);star.graphics.lineTo(-2,-2);star.graphics.endFill();
                star.mouseEnabled=false;resultLayer.addChild(star);sparkles.push(star);
            }
            var card:Object =
                pendingResult.card;

            var cardView:SpecialBatterCardView =
                new SpecialBatterCardView(
                    card,
                    150,
                    236
                );

            cardView.x = 190;
            cardView.y = 38;
            cardView.mouseEnabled = false;
            var path:String=pendingMeta.packClass?"":VisualAssetRegistry.cardPackPath(String(pendingMeta.type)=="HEROES"?"heroes":currentLeaguePack());
            peel=new CardPeelReveal(cardView,pendingMeta.packClass?String(pendingMeta.packClass):String(card.cardClass),150,236,path);peel.x=190;peel.y=38;resultLayer.addChild(peel);

            addTextTo(
                resultLayer,
                pendingResult.newCard
                ? "NEW BATTER!"
                : "DUPLICATE CARD",
                145,
                18,
                240,
                24,
                16,
                pendingResult.newCard
                ? 0xffdc58
                : 0xbccbd3,
                TextFormatAlign.CENTER
            );

            okayButton =
                new UIButton(
                    "OKAY",
                    132,
                    38,
                    0x62a932,
                    0x7fd03e,
                    0xd9f39a
                );

            okayButton.name="pack-okay";
            okayButton.x = 199;
            okayButton.y = 285;
            okayButton.visible=false;
            revealedCard=cardView;revealAt=getTimer();
            cardView.scaleX=cardView.scaleY=1;cardView.x=cardView.y=0;cardView.visible=true;
            revealFlash=new Sprite();revealFlash.mouseEnabled=false;revealFlash.graphics.beginFill(0xffffff);revealFlash.graphics.drawRoundRect(9,7,512,346,12);revealFlash.graphics.endFill();resultLayer.addChild(revealFlash);
            addEventListener(Event.ENTER_FRAME,onRevealFrame);
            okayButton.addEventListener(
                MouseEvent.CLICK,
                onOkay
            );

            resultLayer.addChild(
                okayButton
            );

            messageText.text =
                String(
                    card.name
                ) +
                (
                    pendingResult.newCard
                    ? " joined your card collection."
                    : " added a duplicate copy."
                );

            if (updatedCallback != null) {
                updatedCallback(
                    card
                );
            }

            refreshCurrency();
        }

        private function onPacketFrame(e:Event):void {
            if(!packet)return;var age:Number=getTimer()-openingAt;
            var pop:Number=Math.min(1,age/320);
            packet.scaleX=packet.scaleY=.85+.15*(1-Math.pow(1-pop,3))+.018*Math.sin(age/230);
            packet.rotation=1.5*Math.sin(age/280);packet.y=156+3*Math.sin(age/240);
        }
        private function onRevealFrame(e:Event):void {
            var age:int=getTimer()-revealAt,t:Number=Math.max(0,Math.min(1,(age-90)/840)),ease:Number=t*t*(3-2*t);
            openingLayer.visible=false;resultLayer.visible=true;peel.progress(ease);
            revealFlash.visible=false;revealRays.rotation=age*.009;revealRays.alpha=.18;
            for(var i:int=0;i<sparkles.length;i++){var star:Sprite=sparkles[i],theta:Number=i*2.399,radius:Number=68+Math.min(1,age/700)*(40+i%3*12);star.x=265+Math.cos(theta)*radius;star.y=156+Math.sin(theta)*radius*.85;star.rotation=age*.08+i*31;star.alpha=Math.max(0,Math.sin(t*Math.PI))*.55;}
            if(age>=1050){removeEventListener(Event.ENTER_FRAME,onRevealFrame);mode=MODE_RESULT;okayButton.visible=true;peel.progress(1);}
        }

        private function onOkay(
            e:MouseEvent
        ):void {
            if(e) e.stopPropagation();
            if(mode!=MODE_RESULT) return;

            if (okayButton) {
                okayButton.removeEventListener(
                    MouseEvent.CLICK,
                    onOkay
                );
                okayButton.dispose();
                okayButton = null;
            }

            var tutorialCard:Boolean=GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.CARD;
            GameData.tutorialEvent("card");
            pendingMeta = null;
            pendingResult = null;
            if(tutorialCard){if(closeCallback!=null)closeCallback();return;}
            rebuildShop();
        }

        private function onSpecialTab(
            e:MouseEvent
        ):void {
            if (
                mode != MODE_SHOP
            ) {
                return;
            }

            tab = "SPECIAL";
            rebuildShop();
        }

        private function onRegularTab(
            e:MouseEvent
        ):void {
            if (
                mode != MODE_SHOP
            ) {
                return;
            }

            tab = "REGULAR";
            rebuildShop();
        }

        private function onCloseClick(
            e:MouseEvent
        ):void {
            if (
                mode != MODE_SHOP
            ) {
                // Match the original pack flow: finish the reveal before
                // closing the shop.
                return;
            }

            if (closeCallback != null) {
                closeCallback();
            }
        }

        private function onKeyDown(
            e:KeyboardEvent
        ):void {
            if(e.keyCode==Keyboard.ESCAPE&&mode==MODE_SHOP){e.stopImmediatePropagation();if(closeCallback!=null)closeCallback();return;}
            if (
                e.keyCode != Keyboard.SPACE &&
                e.keyCode != Keyboard.ENTER
            ) {
                return;
            }

            e.stopImmediatePropagation();

            if (mode == MODE_OPEN) {
                revealPendingCard();
            }
            else if (
                mode == MODE_RESULT
            ) {
                onOkay(null);
            }
        }

        private function drawClassPacket(parent:Sprite,x:Number,y:Number,w:Number,h:Number,packClass:String,color:uint):void {
            var printed:ClassPackArtwork=new ClassPackArtwork(packClass,w,h);printed.x=x;printed.y=y;parent.addChild(printed);packetArtwork.push(printed);
        }

        private function metaForView(
            view:Sprite
        ):Object {
            for each (
                var entry:Object in
                packEntries
            ) {
                if (
                    entry.view ==
                    view
                ) {
                    return entry.data;
                }
            }

            return null;
        }

        private function currentLeaguePack():String {
            if (GameData.leagueIndex <= 1) {
                return "single_a";
            }

            if (GameData.leagueIndex == 2) {
                return "double_a";
            }

            if (GameData.leagueIndex == 3) {
                return "triple_a";
            }

            return "major";
        }

        private function refreshCurrency():void {
            if (!currencyText) {
                return;
            }

            currencyText.text =
                "C " +
                formatNumber(
                    GameData.coins
                ) +
                "    $ " +
                GameData.cash;
        }

        private function clearPackEntries():void {
            for each (
                var entry:Object in
                packEntries
            ) {
                var view:Sprite =
                    entry.view as Sprite;

                if (view) {
                    view.removeEventListener(
                        MouseEvent.CLICK,
                        onPackClick
                    );
                    view.removeEventListener(MouseEvent.MOUSE_OVER,onPackHover);view.removeEventListener(MouseEvent.MOUSE_OUT,onPackOut);
                }
            }

            packEntries = [];
            for each(var artwork:Object in packetArtwork)artwork.dispose();packetArtwork=[];

            for each (
                var asset:AssetImage in
                activeAssets
            ) {
                asset.dispose();
            }

            activeAssets = [];
        }

        private function clearSprite(
            layer:Sprite
        ):void {
            if (!layer) {
                return;
            }

            while (
                layer.numChildren >
                0
            ) {
                var disposable:SpecialBatterCardView=layer.getChildAt(0) as SpecialBatterCardView;
                if(disposable) disposable.dispose();
                var folded:CardPeelReveal=layer.getChildAt(0) as CardPeelReveal;if(folded)folded.dispose();
                layer.removeChildAt(0);
            }

            layer.graphics.clear();
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
            field.width = w;
            field.height = h;
            field.selectable = false;
            field.mouseEnabled = false;
            field.multiline = field.wordWrap = true;
            LineupTypography.fit(field,size,color,align,false,8);
            if(text=="BATTER SHOP")ClassicChrome.title(field,size,color,align);

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

        private function formatNumber(
            value:int
        ):String {
            var s:String =
                String(
                    value
                );

            var result:String = "";

            while (
                s.length >
                3
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

        public function dispose():void {
            removeEventListener(Event.ENTER_FRAME,onRevealFrame);removeEventListener(Event.ENTER_FRAME,onPacketFrame);sparkles=[];
            clearSprite(resultLayer);revealedCard=null;peel=null;
            removeEventListener(
                Event.ADDED_TO_STAGE,
                onAdded
            );

            if (stage) {
                stage.removeEventListener(
                    KeyboardEvent.KEY_DOWN,
                    onKeyDown
                );
            }

            clearPackEntries();

            if (openingLayer) {
                openingLayer.removeEventListener(
                    MouseEvent.CLICK,
                    onOpeningClick
                );
            }

            if (closeButton) {
                closeButton.removeEventListener(
                    MouseEvent.CLICK,
                    onCloseClick
                );
                closeButton.dispose();
            }

            if (specialTab) {
                specialTab.removeEventListener(
                    MouseEvent.CLICK,
                    onSpecialTab
                );
                specialTab.dispose();
            }

            if (regularTab) {
                regularTab.removeEventListener(
                    MouseEvent.CLICK,
                    onRegularTab
                );
                regularTab.dispose();
            }

            if (okayButton) {
                okayButton.removeEventListener(
                    MouseEvent.CLICK,
                    onOkay
                );
                okayButton.dispose();
            }
        }
    }
}
