package com.bh.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.text.TextField;
    import flash.utils.getTimer;
    import com.bh.model.GameData;
    import com.bh.game.HomeHero;
    import com.bh.visual.MatchStadium;
    import com.bh.visual.LeagueBadgeView;

    /** Shared classic shop framing; catalog preview never changes the saved hero. */
    public class EnergyShopScreen extends Sprite {
        private var onHome:Function,onInventory:Function,onCategory:Function;
        private var backdrop:MatchStadium,hero:HomeHero,chrome:Sprite=new Sprite(),bar:Sprite=new Sprite();
        private var controls:Array=[],tiles:Array=[],items:Array=[],chosen:Object;
        private var coins:TextField,cash:TextField,energy:TextField,capacity:TextField,countdown:TextField;
        private var detail:TextField,result:TextField,buy:Sprite,preview:Sprite=new Sprite();
        private var confirmation:Sprite,confirmationText:TextField,confirmPay:Sprite,confirmControls:Array=[];
        private var clockAt:int=-1000,lastPay:int=-1000,burstAt:int=-1000,burst:Sprite=new Sprite();
        private var disposed:Boolean=false,lastState:String="";

        public function EnergyShopScreen(w:Number,h:Number,homeCallback:Function,inventoryCallback:Function,categoryCallback:Function) {
            onHome=homeCallback;onInventory=inventoryCallback;onCategory=categoryCallback;name="classic-energy-shop";GameData.init();
            backdrop=new MatchStadium(w,h);addChild(backdrop);chrome.mouseEnabled=chrome.mouseChildren=false;addChild(chrome);
            var badge:LeagueBadgeView=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),55);badge.x=13;badge.y=7;addChild(badge);
            ClassicInventorySkin.gradient(chrome.graphics,105,15,171,30,0xb9e5f8,0x086da4,27);
            label("LV "+GameData.level+"   XP "+GameData.xp,113,20,156,22,13);
            ClassicInventorySkin.icon(this,"energy",302,10);energy=label("",338,20,130,22,13);energy.name="energy-shop-total";
            ClassicInventorySkin.icon(this,"coin",492,14);coins=label("",523,20,151,22,14,0xffef87);
            ClassicInventorySkin.icon(this,"cash",742,14);cash=label("",775,20,158,22,14);
            tab("SHOP","energy-shop-tab",29,78,173,33,null,true);
            tab("INVENTORY","energy-inventory",218,78,215,33,onInventoryClick);
            tab("X","energy-close",546,74,34,34,onHomeClick,false,"close");
            ClassicInventorySkin.panel(chrome.graphics,20,111,558,555);
            tab("GEAR","energy-gear",36,129,144,33,onGearClick);
            tab("STADIUM","energy-stadium",187,129,162,33,onStadiumClick);
            tab("ENERGY","energy-category",356,129,202,33,null,true);
            label("ENERGY REFILL",45,177,508,29,20);
            label("Elige una recarga para ver el precio antes de comprar.",48,207,502,31,12,0xcdeeff);
            items=GameData.shopItemsByCategory("ENERGY");
            for(var i:int=0;i<items.length;i++)createTile(items[i],i);
            ClassicInventorySkin.gradient(chrome.graphics,38,506,522,143,0x164f77,0x102f4e,10);
            detail=label("",50,515,498,54,14,0xffffff);detail.name="energy-shop-details";
            buy=button("BUY","energy-buy",151,574,300,37,onBuyClick,0x7caf30);
            result=label("",45,615,508,28,11,0xffe38b);result.name="energy-shop-message";
            ClassicInventorySkin.panel(chrome.graphics,606,101,332,175);
            label("YOUR ENERGY",619,112,306,29,21);
            bar.x=626;bar.y=157;addChild(bar);
            capacity=label("",628,159,288,28,18);capacity.name="energy-capacity";
            countdown=label("",617,204,310,50,12,0xd7f3ff);countdown.name="energy-countdown";
            preview.x=678;preview.y=347;addChild(preview);
            var player:Object=GameData.mainPlayer();
            hero=new HomeHero(781,568,uint(player.accent),GameData.uniformNumber,String(player.name),null,null,player.appearance);addChild(hero);
            label(String(GameData.mainPlayer().name),621,575,311,27,18);
            ClassicInventorySkin.gradient(chrome.graphics,606,611,332,55,0x176e95,0x104360,12);
            label("La energía comprada se conserva aunque supere la capacidad de recuperación.",616,618,312,43,12,0xe3f4ff);
            burst.mouseEnabled=burst.mouseChildren=false;burst.visible=false;addChild(burst);
            select(items[0]);refresh(true);addEventListener(Event.ENTER_FRAME,onFrame);
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,parent:Sprite=null):TextField {
            return ClassicInventorySkin.text(parent||this,value,x,y,w,h,size,color,"center",size>=18);
        }
        private function tab(value:String,id:String,x:Number,y:Number,w:Number,h:Number,handler:Function,selected:Boolean=false,kind:String="tab"):void {
            var b:EquipmentChromeButton=new EquipmentChromeButton(value,w,h,kind);b.name=id;b.x=x;b.y=y;b.setSelected(selected);b.mouseEnabled=b.buttonMode=handler!=null;
            if(handler!=null)b.addEventListener(MouseEvent.CLICK,handler);addChild(b);controls.push({view:b,handler:handler});
        }
        private function button(value:String,id:String,x:Number,y:Number,w:Number,h:Number,handler:Function,color:uint,parent:Sprite=null,list:Array=null):Sprite {
            var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,handler);(parent||this).addChild(b);(list||controls).push({view:b,handler:handler});return b;
        }
        private function createTile(item:Object,index:int):void {
            var tile:Sprite=new Sprite();tile.x=48+index*255;tile.y=244;tile.name="energy-item-"+item.id;tile.mouseChildren=false;tile.buttonMode=tile.useHandCursor=true;addChild(tile);
            var art:EnergyShopArtwork=new EnergyShopArtwork(index>0);art.x=113;art.y=104;tile.addChild(art);
            label(String(item.name),6,177,214,27,17,0x314650,tile);
            label("+"+item.energy+" ENERGY",6,5,214,29,21,0x315b29,tile);
            var price:EquipmentPriceTag=new EquipmentPriceTag(item,GameData.shopPriceLabel(item),true,true,false,220,28);price.x=3;price.y=212;tile.addChild(price);
            tile.addEventListener(MouseEvent.CLICK,onTileClick);tiles.push({view:tile,item:item});
        }
        private function onTileClick(e:MouseEvent):void {if(confirmation)return;for each(var entry:Object in tiles)if(entry.view==e.currentTarget){select(entry.item);return;}}
        private function select(item:Object):void {
            chosen=item;if(result)result.text="";
            for each(var entry:Object in tiles){var g:Graphics=Sprite(entry.view).graphics;g.clear();g.lineStyle(2,entry.item==chosen?0x74e9ff:0x263b45);ClassicInventorySkin.gradient(g,0,0,226,208,entry.item==chosen?0xdeffff:0xf1f2ef,entry.item==chosen?0xa8d9df:0xbdc3c1,8);g.lineStyle(1,0xffffff);g.drawRoundRect(3,3,220,202,6);g.lineStyle();}
            while(preview.numChildren)preview.removeChildAt(0);
            var art:EnergyShopArtwork=new EnergyShopArtwork(String(item.id)=="energy_crate");art.scaleX=art.scaleY=.51;art.rotation=-12;preview.addChild(art);refresh(true);
        }
        private function enabled(b:Sprite,value:Boolean):void {b.mouseEnabled=b.buttonMode=b.useHandCursor=value;b.alpha=value?1:.48;}
        private function price(item:Object):String {return int(item.cashPrice)>0?item.cashPrice+" HERO COINS":String(item.coinPrice).replace(/\B(?=(\d{3})+(?!\d))/g,",")+" COINS";}
        private function refresh(force:Boolean=false):void {
            GameData.refreshEnergy();var state:String=[GameData.coins,GameData.cash,GameData.energy,GameData.maxEnergy,chosen?chosen.id:""].join(":");
            countdown.text=GameData.energyCountdown();
            if(!force&&state==lastState)return;lastState=state;
            energy.text=String(GameData.energy)+" / "+GameData.maxEnergy;coins.text=String(GameData.coins).replace(/\B(?=(\d{3})+(?!\d))/g,",");cash.text=String(GameData.cash);capacity.text=energy.text;
            var g:Graphics=bar.graphics;g.clear();g.lineStyle(2,0x183b46);ClassicInventorySkin.gradient(g,0,0,288,35,0x173b38,0x102d31,18);g.lineStyle();
            var fill:Number=282*Math.min(1,GameData.energy/Math.max(1,GameData.maxEnergy));if(fill>0)ClassicInventorySkin.gradient(g,3,3,fill,29,0xb5ff54,0x40a522,15);
            if(chosen){detail.text=String(chosen.name)+"  ·  +"+chosen.energy+" ENERGY\n"+price(chosen)+"   ·   "+GameData.energy+" + "+chosen.energy+" = "+(GameData.energy+int(chosen.energy));
                enabled(buy,GameData.energy<GameData.maxEnergy&&GameData.shopItemUnlocked(chosen));
                if(GameData.energy>=GameData.maxEnergy)result.text="Tu energía está llena. Vuelve después de jugar.";
            }
            if(confirmation&&chosen){confirmationText.text=String(chosen.name)+"\nENERGY: "+GameData.energy+" + "+chosen.energy+" = "+(GameData.energy+int(chosen.energy))+"\n\n"+price(chosen);enabled(confirmPay,GameData.energy<GameData.maxEnergy);}
        }
        private function onBuyClick(e:MouseEvent):void {
            refresh(true);if(!buy.mouseEnabled||confirmation||!chosen)return;
            confirmation=new Sprite();confirmation.name="energy-confirmation";confirmation.graphics.beginFill(0x071a2c,.65);confirmation.graphics.drawRect(0,0,960,720);confirmation.graphics.endFill();
            confirmation.addEventListener(MouseEvent.CLICK,swallow);ClassicInventorySkin.panel(confirmation.graphics,263,191,434,315);addChild(confirmation);
            label("CONFIRM REFILL",280,209,400,33,24,0xffffff,confirmation);
            confirmationText=label("",282,266,396,126,20,0xffed91,confirmation);confirmationText.name="energy-confirmation-detail";
            label("La recarga se aplica al confirmar la compra.",282,394,396,34,12,0xcdeeff,confirmation);
            button("CANCEL","energy-cancel",281,445,178,38,onCancelClick,0x56758a,confirmation,confirmControls);
            confirmPay=button("BUY","energy-pay",490,445,187,38,onPayClick,0x7caf30,confirmation,confirmControls);refresh(true);
        }
        private function swallow(e:MouseEvent):void {e.stopPropagation();}
        private function onCancelClick(e:MouseEvent):void {e.stopPropagation();closeConfirmation();}
        private function onPayClick(e:MouseEvent):void {
            e.stopPropagation();if(disposed||!confirmation||getTimer()-lastPay<500)return;lastPay=getTimer();
            var before:int=GameData.energy,answer:String=GameData.purchaseShopItem(chosen);closeConfirmation();refresh(true);
            result.text=answer=="OK"?"Recarga aplicada: +"+(GameData.energy-before)+" ENERGY.":answer=="FULL"?"Tu energía está llena. No se realizó ningún cobro.":answer=="COINS"?"No tienes suficientes Coins.":answer=="CASH"?"No tienes suficientes Hero Coins.":"No se pudo aplicar la recarga.";
            if(answer=="OK"){hero.celebrate();while(burst.numChildren)burst.removeChildAt(0);burst.graphics.clear();ClassicInventorySkin.text(burst,"+"+(GameData.energy-before)+" ENERGY",0,0,200,40,26,0xc3ff68,"center",true);burstAt=getTimer();burst.visible=true;}
        }
        private function closeConfirmation():void {
            if(!confirmation)return;clearControls(confirmControls);confirmation.removeEventListener(MouseEvent.CLICK,swallow);if(confirmation.parent)confirmation.parent.removeChild(confirmation);confirmation=null;confirmationText=null;confirmPay=null;
        }
        private function onGearClick(e:MouseEvent):void {if(onCategory!=null)onCategory("EQUIPMENT");}
        private function onStadiumClick(e:MouseEvent):void {if(onCategory!=null)onCategory("STADIUM");}
        private function onHomeClick(e:MouseEvent):void {if(onHome!=null)onHome();}
        private function onInventoryClick(e:MouseEvent):void {if(onInventory!=null)onInventory();}
        private function onFrame(e:Event):void {
            var now:int=getTimer();if(now-clockAt>=1000){clockAt=now;refresh();}
            if(burst.visible){var progress:Number=(now-burstAt)/850;burst.x=680;burst.y=350-48*progress;burst.alpha=1-progress;if(progress>=1){burst.visible=false;while(burst.numChildren)burst.removeChildAt(0);}}
        }
        private function clearControls(list:Array):void {for each(var c:Object in list){if(c.handler!=null)c.view.removeEventListener(MouseEvent.CLICK,c.handler);if(c.view is EquipmentChromeButton)EquipmentChromeButton(c.view).dispose();}list.length=0;}
        public function dispose():void {if(disposed)return;disposed=true;removeEventListener(Event.ENTER_FRAME,onFrame);closeConfirmation();clearControls(controls);for each(var entry:Object in tiles)entry.view.removeEventListener(MouseEvent.CLICK,onTileClick);tiles=[];hero.dispose();backdrop.dispose();}
    }
}
