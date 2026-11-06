package com.bh.ui {
    import flash.display.Sprite;
    import com.bh.visual.GearArtwork;
    import com.bh.visual.ObservedArtwork;
    import com.bh.visual.GearPieceArtwork;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.Dictionary;

    import com.bh.model.GameData;
    import com.bh.model.ConsumableBats;
    import com.bh.model.StarterTutorial;
    import com.bh.game.HomeHero;
    import com.bh.visual.MatchStadium;
    import com.bh.visual.LeagueBadgeView;

    public class EquipmentScreen extends Sprite {
        private var screenW:Number;
        private var screenH:Number;
        private var onBack:Function;
        private var onShop:Function;
        private var shopMode:Boolean=false;
        private var onInventory:Function,onOtherCategory:Function,onMystery:Function;
        private var coinsText:TextField,cashText:TextField;
        private var backdrop:MatchStadium;
        private var chrome:Sprite=new Sprite();
        private var statsLayer:Sprite=new Sprite();
        private var pointText:TextField,pointButtons:Array=[];
        private var inventoryPage:int=0;
        private var heroKey:String="";
        private var prevButton:LineupButton,nextButton:LineupButton,resetButton:LineupButton;
        private var controls:Array=[];

        private var slots:Array = [
            "bat",
            "glove",
            "belt",
            "helmet",
            "shoes",
            "goggles"
        ];

        private var slotLabels:Object = {
            bat:"BAT",
            glove:"GLOVE",
            belt:"BELT",
            helmet:"HELMET",
            shoes:"SHOES",
            goggles:"GOGGLES"
        };

        private var currentSlot:String = "bat";
        private var consumableOnly:Boolean=false;
        private var stockText:TextField,batFilter:LineupButton;
        private var selected:Object;

        private var categoryButtons:Array = [];
        private var inventoryLayer:Sprite;
        private var itemButtons:Array = [];
        private var itemDataMap:Dictionary = new Dictionary(true);

        private var heroLayer:Sprite;
        private var heroPreview:HomeHero;
        private var previewStatus:TextField;
        private var previewDelta:TextField;
        private var detailsLayer:Sprite;
        private var equippedLayer:Sprite;

        private var titleText:TextField;
        private var gradeText:TextField;
        private var bonusText:TextField;
        private var effectiveText:TextField;
        private var topEffectiveText:TextField;
        private var pageInfoText:TextField;

        private var backButton:EquipmentChromeButton;
        private var equipButton:LineupButton;
        private var shopHintButton:EquipmentChromeButton;

        private var toast:Sprite;
        private var toastText:TextField;
        private var toastLife:int = 0;

        public function EquipmentScreen(
            w:Number,
            h:Number,
            backCallback:Function,
            shopCallback:Function=null,
            shopping:Boolean=false,
            inventoryCallback:Function=null,
            categoryCallback:Function=null,
            mysteryCallback:Function=null
        ) {
            super();

            screenW = w;
            screenH = h;
            onBack = backCallback;onShop=shopCallback;shopMode=shopping;onInventory=inventoryCallback;onOtherCategory=categoryCallback;onMystery=mysteryCallback;
            name=shopMode?"classic-equipment-shop":"classic-equipment";

            GameData.init();

            drawBackground();
            drawTopBar();
            drawCategoryTabs();
            drawInventoryPanel();
            drawHeroPreviewPanel();
            drawDetailPanel();
            createToast();

            selectSlot("bat");

            addEventListener(
                Event.ENTER_FRAME,
                onFrame
            );
        }

        private function drawBackground():void {
            backdrop=new MatchStadium(screenW,screenH);backdrop.name="equipment-stadium";addChild(backdrop);
            chrome.mouseEnabled=chrome.mouseChildren=false;addChild(chrome);
        }

        private function drawTopBar():void {
            var badge:LeagueBadgeView=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),55);badge.x=13;badge.y=7;addChild(badge);
            ClassicInventorySkin.gradient(chrome.graphics,105,15,171,30,0xb9e5f8,0x086da4,27);
            addText("LV "+GameData.level+"   XP "+GameData.xp,113,20,156,22,13,0xffffff,TextFormatAlign.CENTER);
            ClassicInventorySkin.icon(this,"energy",302,10);addText(GameData.energy+" / "+GameData.maxEnergy,338,20,130,22,13,0xffffff,TextFormatAlign.CENTER);
            ClassicInventorySkin.icon(this,"coin",492,14);coinsText=addText(String(GameData.coins),523,20,151,22,14,0xffef87,TextFormatAlign.CENTER);
            ClassicInventorySkin.icon(this,"cash",742,14);cashText=addText(String(GameData.cash),775,20,158,22,14,0xffffff,TextFormatAlign.CENTER);
            shopHintButton=tabControl("SHOP","equipment-shop",29,78,173,33,onShopClick);shopHintButton.setSelected(shopMode);
            shopHintButton.mouseEnabled=shopHintButton.buttonMode=!shopMode&&onShop!=null;
            var inventoryTab:EquipmentChromeButton=tabControl("INVENTORY","shop-inventory",218,78,215,33,onInventoryClick);inventoryTab.setSelected(!shopMode);
            inventoryTab.mouseEnabled=inventoryTab.buttonMode=shopMode&&onInventory!=null;
            backButton=tabControl("X","equipment-back",546,74,34,34,onBackClick,'close');
            topEffectiveText=addText("",611,264,323,20,11,0xffffff,TextFormatAlign.CENTER);topEffectiveText.visible=false;
        }

        private function drawCategoryTabs():void {
            var order:Array=["glove","belt","helmet","shoes","bat","goggles"];
            for(var i:int=0;i<order.length;i++) {
                var tab:EquipmentChromeButton=tabControl(String(slotLabels[order[i]]),"equipment-category-"+order[i],32+i*88,172,84,29,onCategoryClick);
                categoryButtons.push({view:tab,slot:order[i],label:slotLabels[order[i]]});
            }
        }

        private function redrawCategoryTabs():void {
            for each(var entry:Object in categoryButtons)EquipmentChromeButton(entry.view).setSelected(entry.slot==currentSlot);
        }

        private function drawInventoryPanel():void {
            // Layer zero so the tabs remain above the panel.
            ClassicInventorySkin.panel(chrome.graphics,20,111,558,555);
            ClassicInventorySkin.icon(this,"helmet",44,123,.95);addText("GEAR",83,134,114,25,17,0xffffff,TextFormatAlign.CENTER);
            if(shopMode&&onOtherCategory!=null){control("STADIUM","shop-stadium",197,129,82,27,onStadiumClick,0xcacaca);control("ENERGY","shop-energy",282,129,86,27,onEnergyClick,0xcacaca);}
            if(!shopMode&&onMystery!=null)control("MYSTERY","inventory-mystery",203,128,126,29,function(e:MouseEvent):void{onMystery();},0xe1a926);
            batFilter=control("BATS x5","equipment-bats-x5",439,121,120,25,onBatFilter,0x91c844);
            pageInfoText=addText("",345,149,214,19,11,0xc8edff,TextFormatAlign.RIGHT);pageInfoText.name="equipment-page";
            chrome.graphics.lineStyle(1,0x4d96b8);ClassicInventorySkin.gradient(chrome.graphics,39,212,521,333,0x124b78,0x0b365b,12);chrome.graphics.lineStyle();
            inventoryLayer=new Sprite();inventoryLayer.x=48;inventoryLayer.y=222;addChild(inventoryLayer);
            prevButton=control("<","equipment-prev",24,354,27,51,onPrevious,0xcacaca);
            nextButton=control(">","equipment-next",549,354,27,51,onNext,0xcacaca);
        }

        private function drawHeroPreviewPanel():void {
            chrome.graphics.lineStyle(2,0x41636b);ClassicInventorySkin.gradient(chrome.graphics,606,101,332,151,0xffffff,0xe4e8dd,12);chrome.graphics.lineStyle();
            addText("SKILL POINT",617,111,153,23,15,0x21779e,TextFormatAlign.LEFT);
            pointText=addText("",767,113,158,22,12,0xc98d29,TextFormatAlign.RIGHT);pointText.name='equipment-skill-points';
            var core:Array=['contact','power','luck'];for(var pi:int=0;pi<3;pi++)pointButtons.push({stat:core[pi],view:tabControl('+','equipment-point-'+core[pi],907,145+pi*27,19,19,onPointClick,'point')});
            statsLayer.x=619;statsLayer.y=142;addChild(statsLayer);
            ClassicInventorySkin.gradient(chrome.graphics,606,259,332,27,0x176e95,0x104360,12);
            previewStatus=addText("",611,264,323,22,12,0xffed88,TextFormatAlign.CENTER);previewStatus.name="equipment-preview-status";
            heroLayer=new Sprite();heroLayer.x=780;heroLayer.y=554;addChild(heroLayer);
            equippedLayer=new Sprite();equippedLayer.x=626;equippedLayer.y=325;addChild(equippedLayer);
            addText(String(GameData.mainPlayer().name),677,561,207,27,18,0xffffff,TextFormatAlign.CENTER);
            ClassicInventorySkin.gradient(chrome.graphics,606,592,332,55,0x176e95,0x104360,12);
            previewDelta=addText("",604,597,337,51,12,0xffed88,TextFormatAlign.CENTER);previewDelta.name="equipment-preview-delta";previewDelta.multiline=true;
            effectiveText=addText("",604,653,337,18,9,0xffffff,TextFormatAlign.CENTER);effectiveText.visible=false;
        }

        private function drawDetailPanel():void {
            detailsLayer=new Sprite();detailsLayer.visible=false;addChild(detailsLayer);
            titleText=addText("",43,549,513,25,15,0xffffff,TextFormatAlign.CENTER);titleText.name="equipment-selected";
            stockText=addText("",646,295,246,22,13,0xffef87,TextFormatAlign.CENTER);stockText.name="equipment-stock";
            gradeText=addText("",43,578,513,18,10,0xc2e8f6,TextFormatAlign.CENTER);gradeText.visible=false;
            bonusText=addText("",43,577,513,24,11,0xc2e8f6,TextFormatAlign.CENTER);bonusText.name="equipment-selected-bonus";
            equipButton=control("EQUIP","EQUIP_ITEM",95,612,193,36,onEquipClick);
            resetButton=control("CANCEL PREVIEW","equipment-reset",311,612,214,36,onCancelPreview,0xcacaca);
        }

        private function selectSlot(slot:String):void {
            currentSlot = slot;inventoryPage=0;
            selected = null;
            redrawCategoryTabs();
            rebuildInventory();
            if(shopMode){clearDetails();return;}

            var list:Array = itemsForSlot(slot);
            if (list.length > 0) {
                var active:Object=GameData.equipped?GameData.equipped[slot]:null;
                var first:Object=list[0];
                for(var index:int=0;index<list.length;index++)if(active&&list[index].name==active.name){first=list[index];inventoryPage=int(index/8);break;}
                rebuildInventory();
                selectItem(first);
            }
            else {
                clearDetails();
            }
        }

        private function itemsForSlot(slot:String):Array {
            var result:Array = [];

            var source:Array=shopMode?GameData.shopItemsByCategory("EQUIPMENT"):GameData.inventory;
            for each (var item:Object in source) {
                if (item && String(item.slot) == slot && (!consumableOnly||ConsumableBats.isBat(item))) {
                    result.push(item);
                }
            }

            if(shopMode){var observed:Array=[],other:Array=[];for each(var entry:Object in result)(ObservedArtwork.supports(String(entry.id))?observed:other).push(entry);result=observed.concat(other);}
            return result;
        }

        private function rebuildInventory():void {
            for each (var button:Sprite in itemButtons) {
                button.removeEventListener(MouseEvent.CLICK, onItemClick);
            }
            itemButtons = [];
            itemDataMap = new Dictionary(true);

            while (inventoryLayer.numChildren > 0) {
                inventoryLayer.removeChildAt(0);
            }

            var items:Array = itemsForSlot(currentSlot);
            var pages:int=Math.max(1,Math.ceil(items.length/8));inventoryPage=Math.max(0,Math.min(pages-1,inventoryPage));
            pageInfoText.text=items.length+(shopMode?" ITEMS   ":" OWNED   ")+(inventoryPage+1)+" / "+pages;
            prevButton.mouseEnabled=prevButton.buttonMode=inventoryPage>0;prevButton.alpha=inventoryPage>0?1:.48;
            nextButton.mouseEnabled=nextButton.buttonMode=inventoryPage+1<pages;nextButton.alpha=inventoryPage+1<pages?1:.48;

            for (var i:int = inventoryPage*8; i < Math.min(items.length,(inventoryPage+1)*8); i++) {
                var item:Object = items[i];
                var card:Sprite = createItemCard(item);
                card.x = ((i-inventoryPage*8) % 4) * 126;
                card.y = int((i-inventoryPage*8) / 4) * 158;
                card.addEventListener(MouseEvent.CLICK, onItemClick);
                itemDataMap[card] = item;
                inventoryLayer.addChild(card);
                itemButtons.push(card);
            }
            // Empty positions stay visible, as in the original gear inventory.
            for(var empty:int=itemButtons.length;empty<8;empty++) {
                var cell:Sprite=new Sprite();cell.mouseEnabled=cell.mouseChildren=false;
                cell.x=(empty%4)*126;cell.y=int(empty/4)*158;
                cell.graphics.lineStyle(1,0x2b5d7d);cell.graphics.drawRoundRect(0,0,116,153,7);inventoryLayer.addChild(cell);
            }
        }

        private function createItemCard(item:Object):Sprite {
            var card:Sprite=new Sprite();card.name=shopMode?"shop-item-"+item.id:"equipment-item-"+item.name;card.buttonMode=card.useHandCursor=true;card.mouseChildren=false;
            var active:Object=GameData.equipped[currentSlot],applied:Boolean=active&&active.name==item.name,chosen:Boolean=selected&&selected.name==item.name;
            var unlocked:Boolean=!shopMode||GameData.shopItemUnlocked(item),owned:Boolean=shopMode&&GameData.ownsShopItem(item);
            ClassicChrome.well(card.graphics,0,0,116,126,chosen);
            var icon:Sprite=ObservedArtwork.gearKey(item)!=''?new ObservedArtwork(ObservedArtwork.gearKey(item),68,62):item.classicFamily?new BasicGearIcon(item):GearPieceArtwork.supports(String(item.name))?new GearPieceArtwork(String(item.name),String(item.slot),72):item.slot=="bat"?new GearArtwork(String(item.name),72):createEquipmentIcon(String(item.slot),uint(item.accent),29);icon.x=ObservedArtwork.gearKey(item)!=''?24:58;icon.y=ObservedArtwork.gearKey(item)!=''?12:44;card.addChild(icon);
            var name:TextField=addChildText(card,String(item.name),4,76,108,26,10,0x414b4e,TextFormatAlign.CENTER);name.multiline=name.wordWrap=true;
            var stats:Array=['power','contact','luck','speed'],letters:Array=['P','C','L','S'],colors:Array=[0xcc4d5b,0x247bb2,0x5a982d,0x8064a6],bonuses:Array=[];
            for(var bi:int=0;bi<4;bi++)if(int(item[stats[bi]])>0)bonuses.push({value:letters[bi]+' '+item[stats[bi]],color:colors[bi]});
            for(bi=0;bi<Math.min(2,bonuses.length);bi++)addChildText(card,bonuses[bi].value,bonuses.length==1?7:6+bi*53,102,bonuses.length==1?102:52,17,10,bonuses[bi].color,TextFormatAlign.CENTER);
            if(shopMode&&!unlocked){var lock:TextField=addChildText(card,int(item.unlockLevel)>0?"LEVEL "+item.unlockLevel:GameData.requiredLeagueName(item),4,2,108,18,10,0x153e57,TextFormatAlign.CENTER);lock.name='equipment-lock';}
            var footer:String=shopMode?(owned?"OWNED":GameData.shopPriceLabel(item)):applied?"EQUIPPED":chosen?"TRY ON":"SELECT";
            var price:EquipmentPriceTag=new EquipmentPriceTag(item,footer,shopMode&&!owned,unlocked,applied,108,23);price.x=4;price.y=130;price.name='equipment-price-'+(item.id?item.id:item.name);card.addChild(price);
            if(ConsumableBats.isBat(item)){
                var badge:TextField=addChildText(card,shopMode?"x5":GameData.batStock(item)+" LEFT",35,4,78,22,12,shopMode?0xd4363f:GameData.batStock(item)>0?0x086da4:0xc33730,TextFormatAlign.RIGHT);badge.name="bat-stock-"+item.consumableId;
            }
            return card;
        }

        public static function createEquipmentIcon(slot:String,accent:uint,radius:Number):Sprite {
            // Category illustration only; ownership, stats and the equipped hero
            // still come from GameData and the item's own observed artwork.
            var icon:Sprite=new Sprite(),art:Sprite=new com.bh.visual.InterfaceSprite('gear_'+slot,radius*2,radius*2);
            art.x=art.y=-radius;icon.mouseEnabled=icon.mouseChildren=false;icon.addChild(art);return icon;
        }

        private function onItemClick(e:MouseEvent):void {
            var card:Sprite = e.currentTarget as Sprite;
            if (card && itemDataMap[card] != null) {
                selectItem(itemDataMap[card]);
            }
        }

        private function selectItem(item:Object):void {
            if (!item) return;

            selected = item;
            titleText.text = String(item.name);
            gradeText.text = String(item.grade) + "  " + String(slotLabels[item.slot]);
            gradeText.textColor = uint(item.accent);

            bonusText.text =
                "POW +" + statValue(item, "power") +
                "    CON +" + statValue(item, "contact") +
                "    SPD +" + statValue(item, "speed") +
                "    LCK +" + statValue(item, "luck");

            drawDetailIcon(item);
            refreshHeroPreview();rebuildInventory();
        }

        private function drawDetailIcon(item:Object):void {
            // The actual preview is on the field; keep the legacy detail layer empty.
        }

        private function clearDetails():void {
            titleText.text = shopMode?"Elige un artículo":"NO ITEMS";
            gradeText.text = "";
            bonusText.text = shopMode?"Elige un artículo para verlo antes de comprar.":"Visit SHOP to obtain equipment.";
            while (detailsLayer.numChildren > 0) detailsLayer.removeChildAt(0);
            detailsLayer.graphics.clear();
            refreshHeroPreview();
        }

        private function onEquipClick(e:MouseEvent):void {
            if (!selected) return;
            if(shopMode){
                var result:String=GameData.purchaseShopItem(selected);
                showToast(result=="OK"?selected.name+" comprado. Abre INVENTORY para equiparlo.":result=="OWNED"?"You already own this item.":result=="LOCKED"?"Requiere "+(int(selected.unlockLevel)>0?"LEVEL "+selected.unlockLevel:"league "+GameData.requiredLeagueName(selected))+".":result=="COINS"?"Not enough coins.":result=="CASH"?"Not enough premium currency.":result=="FULL"?"No hay espacio para otro paquete de cinco bates.":"Could not complete the purchase.");
                coinsText.text=String(GameData.coins);cashText.text=String(GameData.cash);rebuildInventory();refreshHeroPreview();return;
            }
            var active:Object=GameData.equipped?GameData.equipped[selected.slot]:null;
            if(active&&String(active.name)==String(selected.name))return;

            if (GameData.equipItem(selected)) {
                showToast(String(selected.name) + " equipped");
                rebuildInventory();
                refreshAll();
                if(heroPreview)heroPreview.celebrate();
            }
        }

        private function refreshAll():void {
            refreshHeroPreview();
            refreshEquippedStrip();

            var p:Object = GameData.mainPlayer();

            topEffectiveText.text =
                "POW " + GameData.effectivePower(p) +
                "  CON " + GameData.effectiveContact(p) +
                "  SPD " + GameData.effectiveSpeed(p) +
                "  LCK " + GameData.effectiveLuck(p);

            effectiveText.text =
                "EQUIPMENT BONUS\nPOW +" + GameData.equipmentBonus("power") +
                "  CON +" + GameData.equipmentBonus("contact") +
                "\nSPD +" + GameData.equipmentBonus("speed") +
                "  LCK +" + GameData.equipmentBonus("luck");
        }

        private function refreshHeroPreview():void {
            var gear:Object={},active:Object;
            for each(var slot:String in slots)gear[slot]=GameData.equipped?GameData.equipped[slot]:null;
            if(selected){active=gear[selected.slot];gear[selected.slot]=selected;}
            stockText.text=selected&&ConsumableBats.isBat(selected)?(shopMode?"PACK x5  ·  ":"")+GameData.batStockLabel(selected):"";
            var pending:Boolean=selected&&(!active||String(active.name)!=String(selected.name));
            var player:Object=GameData.mainPlayer();
            var key:String=JSON.stringify(gear);
            if(!heroPreview||key!=heroKey){
                if(heroPreview){heroPreview.dispose();heroLayer.removeChild(heroPreview);}
                heroPreview=new HomeHero(0,0,uint(player.accent),GameData.uniformNumber,String(player.name),null,gear,null,true);
                heroPreview.scaleX=heroPreview.scaleY=1.25;heroLayer.addChild(heroPreview);heroKey=key;
            }
            drawAttributes(selected,active,pending);refreshEquippedStrip();
            previewStatus.text=shopMode?(pending?"PREVIEW  "+selected.name:"EQUIPPED LOOK"):pending?"TRY ON  "+selected.name:"EQUIPPED LOOK";
            previewDelta.text=pending?"CHANGE IF EQUIPPED\n"+previewDifference(selected,active):shopMode?"La vista previa no compra ni equipa.\nCompra y equipa desde INVENTORY.":"La vista previa no gasta ni guarda cambios.\nPulsa EQUIP para aplicar el artículo.";
            resetButton.mouseEnabled=resetButton.buttonMode=pending;resetButton.alpha=pending?1:.48;
            var canApply:Boolean=pending,label:String=selected?(pending?"EQUIP":"EQUIPPED"):"NO ITEM";
            if(shopMode){
                canApply=selected&&GameData.shopItemUnlocked(selected)&&!GameData.ownsShopItem(selected)&&GameData.coins>=int(selected.coinPrice)&&GameData.cash>=int(selected.cashPrice);
                label=!selected?"SELECT ITEM":GameData.ownsShopItem(selected)?"OWNED":!GameData.shopItemUnlocked(selected)?"LOCKED":GameData.coins<int(selected.coinPrice)?"NEED COINS":GameData.cash<int(selected.cashPrice)?"NEED CASH":"BUY "+GameData.shopPriceLabel(selected);
                titleText.text=selected?selected.name+" · "+(GameData.shopItemUnlocked(selected)?GameData.shopPriceLabel(selected):"Requiere "+(int(selected.unlockLevel)>0?"LEVEL "+selected.unlockLevel:GameData.requiredLeagueName(selected))):"Elige un artículo";
            }
            if(selected&&ConsumableBats.isBat(selected)){
                bonusText.text="CONSUMABLE · "+(shopMode?"x5 · ":"")+compactBonus(selected)+" · 1 per game";
                if(!shopMode&&GameData.batStock(selected)<=0){canApply=false;label="EMPTY";}
                if(shopMode&&GameData.batStock(selected)>ConsumableBats.CAP-5){canApply=false;label="STOCK FULL";}
            }
            if(!shopMode&&selected&&selected.slot=="bat"&&GameData.pendingSpecialMatch()){canApply=false;label="IN PLAY";}
            equipButton.mouseEnabled=equipButton.buttonMode=canApply;equipButton.alpha=canApply?1:.6;equipButton.setLabel(label);
        }

        private function previewDifference(next:Object,current:Object):String {
            var labels:Array=["POW","CON","SPD","LCK"],stats:Array=["power","contact","speed","luck"],out:Array=[];
            var hero:Object=GameData.mainPlayer();
            for(var i:int=0;i<stats.length;i++){
                var change:int=int(next[stats[i]])-(current?int(current[stats[i]]):0);
                var before:int=int(hero[stats[i]])+GameData.equipmentBonus(stats[i]);
                var delta:int=Math.max(0,Math.min(9999,before+change))-Math.max(0,Math.min(9999,before));
                out.push(labels[i]+" "+(delta>=0?"+":"")+delta);
            }
            return out.join("  ");
        }

        private function refreshEquippedStrip():void {
            while(equippedLayer.numChildren)equippedLayer.removeChildAt(0);equippedLayer.graphics.clear();
            for(var i:int=0;i<slots.length;i++) {
                var slot:String=String(slots[i]),item:Object=GameData.equipped[slot],x:Number=i<3?0:252,y:Number=(i%3)*76;
                equippedLayer.graphics.lineStyle(2,0x264651);ClassicInventorySkin.gradient(equippedLayer.graphics,x,y,60,62,0xc9e2b2,0x72986b,6);equippedLayer.graphics.lineStyle();
                var original:Boolean=item&&ObservedArtwork.gearKey(item)!='';var icon:Sprite=original?new ObservedArtwork(ObservedArtwork.gearKey(item),42,34):new com.bh.visual.InterfaceSprite('gear_'+slot,42,34);icon.x=x+9;icon.y=y+8;equippedLayer.addChild(icon);
                addChildText(equippedLayer,String(slotLabels[slot]),x,y+43,60,17,8,0x173a44,TextFormatAlign.CENTER);
            }
        }
        private function drawAttributes(next:Object,current:Object,pending:Boolean):void {
            while(statsLayer.numChildren)statsLayer.removeChildAt(0);statsLayer.graphics.clear();
            var p:Object=GameData.mainPlayer(),stats:Array=['contact','power','luck'],letters:Array=['C','P','L'],colors:Array=[0x3ba4d0,0xdb6d77,0x79b943];
            ClassicInventorySkin.gradient(statsLayer.graphics,0,8,65,65,0xffffff,0xbdc8ca,65);
            var total:TextField=addChildText(statsLayer,String(int(p.contact)+int(p.power)+int(p.luck)),3,24,59,35,23,0x1574a8,TextFormatAlign.CENTER);total.name='equipment-core-total';
            pointText.text=int(p.skillPoints)+' '+(int(p.skillPoints)==1?'Point Left':'Points Left');
            for(var i:int=0;i<3;i++) {
                var stat:String=stats[i],raw:int=int(p[stat])+GameData.equipmentBonus(stat),before:int=Math.max(0,Math.min(9999,raw));
                var after:int=Math.max(0,Math.min(9999,raw+(pending?statValue(next,stat)-statValue(current,stat):0)));
                statsLayer.graphics.lineStyle(1,0x6d9cab);ClassicInventorySkin.gradient(statsLayer.graphics,78,i*27+4,15,15,uint(colors[i]),uint(colors[i]),8);statsLayer.graphics.lineStyle();
                addChildText(statsLayer,letters[i],77,i*27+1,17,21,11,0xffffff,TextFormatAlign.CENTER);
                addChildText(statsLayer,String(int(p[stat])),98,i*27,53,23,13,0xc89720,TextFormatAlign.LEFT);
                var t:TextField=addChildText(statsLayer,String(after),232,i*27,47,23,13,after==before?0x446c7c:after>before?0x398f33:0xbd4235,TextFormatAlign.RIGHT);t.name='equipment-stat-'+stat;
                var allowed:Boolean=int(p.skillPoints)>0&&int(p[stat])<99&&!GameData.pendingSpecialMatch()&&(!GameData.tutorialActive()||int(GameData.starterTutorial.stage)>=StarterTutorial.POINT);
                pointButtons[i].view.mouseEnabled=pointButtons[i].view.buttonMode=allowed;pointButtons[i].view.alpha=allowed?1:.45;
            }
            var speed:int=Math.max(0,Math.min(9999,int(p.speed)+GameData.equipmentBonus('speed')+(pending?statValue(next,'speed')-statValue(current,'speed'):0)));
            addChildText(statsLayer,'SPEED',78,84,95,17,9,0x68818a,TextFormatAlign.LEFT);var st:TextField=addChildText(statsLayer,String(speed),232,84,47,17,10,0x68818a,TextFormatAlign.RIGHT);st.name='equipment-stat-speed';
        }
        private function onPointClick(e:MouseEvent):void {
            if(GameData.pendingSpecialMatch())return;
            var stat:String=Sprite(e.currentTarget).name.replace('equipment-point-','');
            if(GameData.allocateHeroStat(stat)){refreshAll();showToast(stat.toUpperCase()+' +1. Punto aplicado.');}
        }

        private function tabControl(value:String,id:String,x:Number,y:Number,w:Number,h:Number,callback:Function,kind:String='tab'):EquipmentChromeButton {
            var b:EquipmentChromeButton=new EquipmentChromeButton(value,w,h,kind);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,callback);controls.push({view:b,callback:callback});addChild(b);return b;
        }
        private function control(value:String,id:String,x:Number,y:Number,w:Number,h:Number,callback:Function,color:uint=0x91c844):LineupButton {
            var b:LineupButton=new LineupButton(value,w,h,color,true);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,callback);controls.push({view:b,callback:callback});addChild(b);return b;
        }
        private function onBatFilter(e:MouseEvent):void {consumableOnly=!consumableOnly;batFilter.setLabel(consumableOnly?"ALL BATS":"BATS x5");selectSlot("bat");}
        private function onPrevious(e:MouseEvent):void {if(inventoryPage>0){inventoryPage--;rebuildInventory();}}
        private function onNext(e:MouseEvent):void {if((inventoryPage+1)*8<itemsForSlot(currentSlot).length){inventoryPage++;rebuildInventory();}}
        private function onCancelPreview(e:MouseEvent):void {selectSlot(currentSlot);}
        private function onShopClick(e:MouseEvent):void {if(onShop!=null)onShop();}
        private function onInventoryClick(e:MouseEvent):void {if(onInventory!=null)onInventory();}
        private function onStadiumClick(e:MouseEvent):void {if(onOtherCategory!=null)onOtherCategory("STADIUM");}
        private function onEnergyClick(e:MouseEvent):void {if(onOtherCategory!=null)onOtherCategory("ENERGY");}

        private function shortName(value:String):String {
            if (value.length <= 12) return value;
            return value.substr(0, 11) + "…";
        }

        private function compactBonus(item:Object):String {
            var parts:Array = [];
            if (statValue(item, "power") > 0) parts.push("P+" + statValue(item, "power"));
            if (statValue(item, "contact") > 0) parts.push("C+" + statValue(item, "contact"));
            if (statValue(item, "speed") > 0) parts.push("S+" + statValue(item, "speed"));
            if (statValue(item, "luck") > 0) parts.push("L+" + statValue(item, "luck"));
            return parts.length > 0 ? parts.join("  ") : "COSMETIC";
        }

        private function statValue(item:Object, stat:String):int {
            if (!item || item[stat] === undefined) return 0;
            return int(item[stat]);
        }

        private function onCategoryClick(e:MouseEvent):void {
            var tab:Sprite = e.currentTarget as Sprite;
            if (tab) {consumableOnly=false;batFilter.setLabel("BATS x5");selectSlot(tab.name.replace("equipment-category-",""));}
        }

        private function onBackClick(e:MouseEvent):void {
            if (onBack != null) onBack();
        }

        private function createToast():void {
            toast = new Sprite();
            toast.visible = false;

            toastText = makeText(
                "", 12, 0xffffff,
                330, 22,
                TextFormatAlign.CENTER
            );
            toastText.x = 0;
            toastText.y = 8;
            toast.addChild(toastText);

            toast.x = 315;
            toast.y = screenH - 45;
            addChild(toast);
        }

        private function showToast(message:String):void {
            toast.graphics.clear();
            toast.graphics.beginFill(0x07111e, 0.96);
            toast.graphics.drawRoundRect(0, 0, 330, 36, 10, 10);
            toast.graphics.endFill();
            toast.graphics.lineStyle(2, 0x74b1d7);
            toast.graphics.drawRoundRect(0, 0, 330, 36, 10, 10);
            toast.graphics.lineStyle();

            toastText.text = message;
            toast.visible = true;
            toast.alpha = 1;
            toastLife = 90;
        }

        private function onFrame(e:Event):void {
            if (toastLife > 0) {
                toastLife--;

                if (toastLife < 18) {
                    toast.alpha = toastLife / 18;
                }

                if (toastLife <= 0) {
                    toast.visible = false;
                    toast.alpha = 1;
                }
            }
        }

        private function addChildText(
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
            var field:TextField = makeText(text, size, color, w, h, align);
            field.x = x;
            field.y = y;
            parent.addChild(field);
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
            var field:TextField = makeText(text, size, color, w, h, align);
            field.x = x;
            field.y = y;
            addChild(field);
            return field;
        }

        private function makeText(
            text:String,
            size:int,
            color:uint,
            w:Number,
            h:Number,
            align:String
        ):TextField {
            var field:TextField = new TextField();
            var format:TextFormat = new TextFormat("Arial", size, color, true);
            format.align = align;
            field.defaultTextFormat = format;
            field.text = text;
            LineupTypography.apply(field,size,color,align);
            field.width = w;
            field.height = h;
            LineupTypography.fit(field,size,color,align);
            field.selectable = false;
            field.mouseEnabled = false;
            return field;
        }

        public function dispose():void {
            if(heroPreview){heroPreview.dispose();heroPreview=null;}if(backdrop)backdrop.dispose();
            removeEventListener(Event.ENTER_FRAME,onFrame);
            for each(var button:Sprite in itemButtons)button.removeEventListener(MouseEvent.CLICK,onItemClick);
            for each(var entry:Object in controls){entry.view.removeEventListener(MouseEvent.CLICK,entry.callback);entry.view.dispose();}controls=[];
        }
    }
}
