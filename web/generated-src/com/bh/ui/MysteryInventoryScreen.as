package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.utils.getTimer;
    import com.bh.model.GameData;import com.bh.model.MysteryInventory;import com.bh.model.MysteryCatalog;import com.bh.model.SpecialCardInventory;import com.bh.visual.GearArtwork;import com.bh.visual.GearPieceArtwork;
    import com.bh.visual.InventoryArtwork;import com.bh.visual.InterfaceSprite;import flash.filters.GlowFilter;
    /** Inventory, confirmation and persistent reveal traced from 11:40–12:00. */
    public class MysteryInventoryScreen extends Sprite {
        private var home:Function,shop:Function,gear:Function,background:LobbyScreen;
        private var layer:Sprite=new Sprite(),modal:Sprite,controls:Array=[],selected:String="",revealAt:int=0;
        private var opening:Boolean=false,disposed:Boolean=false;private var page:int=0;
        private var artDisposables:Array=[],revealArt:Sprite,revealX:Number,revealY:Number,revealScale:Number;
        public function MysteryInventoryScreen(w:Number,h:Number,onHome:Function,onShop:Function,onGear:Function){
            name="mystery-inventory";home=onHome;shop=onShop;gear=onGear;
            background=new LobbyScreen(w,h,null,null,null,null,null,null,null,null,null,null,null,null);
            background.mouseEnabled=background.mouseChildren=false;addChild(background);addChild(layer);render();
            if(GameData.mysteryInventory.pending)detail(String(GameData.mysteryInventory.pending.source),false);
        }
        private function label(p:Sprite,id:String,value:String,x:Number,y:Number,w:Number,h:Number,size:int=14,color:uint=0xffffff,align:String="center"):TextField {
            var t:TextField=ClassicInventorySkin.text(p,value,x,y,w,h,size,color,align);t.name=id;LineupTypography.apply(t,size,color,align,true);t.text=value;return t;
        }
        private function button(p:Sprite,id:String,value:String,x:Number,y:Number,w:Number,h:Number,fn:Function,color:uint=0x74b52c,enabled:Boolean=true):Sprite {
            var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.name=id;b.x=x;b.y=y;b.alpha=enabled?1:.45;b.mouseEnabled=b.buttonMode=enabled;p.addChild(b);
            var f:Function=function(e:MouseEvent):void{e.stopPropagation();if(enabled)fn();};b.addEventListener(MouseEvent.CLICK,f);controls.push({b:b,fn:f});return b;
        }
        private function clear():void {removeEventListener(Event.ENTER_FRAME,onReveal);opening=false;
            revealArt=null;for each(var a:Object in artDisposables)a.dispose();artDisposables=[];
            for each(var c:Object in controls)c.b.removeEventListener(MouseEvent.CLICK,c.fn);controls=[];
            while(layer.numChildren)layer.removeChildAt(0);layer.graphics.clear();modal=null;
        }
        private function render():void {
            clear();var g:Graphics=layer.graphics,s:Object=GameData.mysteryInventory;
            ClassicInventorySkin.panel(g,107,106,482,468);
            button(layer,"mystery-shop","SHOP",124,73,178,34,shop,0x147bb3);
            ClassicInventorySkin.gradient(g,306,70,224,39,0x49c5f5,0x0767a7,10);
            label(layer,"mystery-title","INVENTORY",312,76,213,30,22);
            button(layer,"mystery-close","X",548,90,39,32,home,0xb33a37);
            button(layer,"mystery-gear","GEAR",130,125,103,32,gear,0x1673a8);
            ClassicInventorySkin.icon(layer,"batter",253,123,.8);ClassicInventorySkin.icon(layer,"energy",333,121,.8);
            ClassicInventorySkin.gradient(g,403,114,122,50,0x3e87b4,0x164668,5);
            ClassicInventorySkin.icon(layer,"box",416,119,.8);label(layer,"mystery-tab","MYSTERY",405,144,118,20,11);
            button(layer,"mystery-page-prev","<",131,171,36,23,function():void{page=0;render();},0x1673a8,page>0);
            button(layer,"mystery-page-next",">",530,171,36,23,function():void{page=1;render();},0x1673a8,page<1);
            label(layer,"mystery-page-label",page==0?"MYSTERY BOXES  1 / 2":"SPECIAL BATTER PACKS  2 / 2",174,172,348,22,12,0xd7efff);
            if(page==0){
                for(var i:int=0;i<5;i++){
                    var kind:String=String(MysteryCatalog.KINDS[i]);
                    item(kind,137+(i%3)*140,201+int(i/3)*176,int(s.boxes[kind]),50,"Need "+MysteryInventory.keyCost(kind)+" Keys");
                }
                item("key",417,377,int(s.keys),40,"Key");
            }else{
                for(i=0;i<4;i++){
                    var cls:String=String(MysteryCatalog.CLASSES[i]);
                    item(MysteryCatalog.packKind(cls),137+(i%3)*140,201+int(i/3)*176,int(s.packs[cls]),50,cls+" Pack");
                }
                label(layer,"mystery-help","Gana partidos para conseguir llaves.\nSPECIAL y ROADMAP dan cajas.\nAbre sobres para obtener Special Batters.",274,405,278,87,13,0xc8e6f4);
            }
            label(layer,"mystery-capacity","BOXES / PACKS 50 EACH   ·   KEYS 40",127,553,442,18,10,0x9bc3de);
        }
        private function item(kind:String,x:Number,y:Number,count:int,cap:int,title:String):void {
            var p:Sprite=new Sprite();p.x=x;p.y=y;layer.addChild(p);var g:Graphics=p.graphics;
            var b:Object=MysteryCatalog.box(kind),cls:String=MysteryCatalog.packClass(kind);
            g.lineStyle(2,0x25495d);ClassicInventorySkin.gradient(g,0,0,129,163,0xffffff,0xd5d9d5,10);g.lineStyle();
            ClassicInventorySkin.gradient(g,6,8,117,80,b?uint(b.light):0xd4ecfa,b?uint(b.color):0x799bb4,4);
            if(kind=="key")key(p,44,13,1.1);else if(cls!="")pack(p,36,16,.8,cls);else chest(p,15,25,kind,.76);
            var counter:Sprite=new Sprite();p.addChild(counter);
            ClassicInventorySkin.gradient(counter.graphics,63,3,60,23,0x4a6b78,0x254552,9);
            label(counter,"mystery-count-"+kind,count+" / "+cap,64,5,58,21,12,0xffed9b,"center");
            label(p,"mystery-label-"+kind,title,3,92,123,20,11,0x306a97);
            if(kind!="key")label(p,"mystery-kind-"+kind,cls!=""?"Special Batter":"Mystery Box",3,113,123,18,12,0x4b5050);
            if(kind!="key")button(p,"mystery-open-"+kind,"OPEN",12,136,105,23,function():void{detail(kind,false);},0x75ba29,count>0||GameData.mysteryInventory.pending!=null);
        }
        private function detail(kind:String,animate:Boolean):void {
            render();selected=kind;modal=new Sprite();modal.name="mystery-detail";layer.addChild(modal);
            modal.graphics.beginFill(0x081c2b,.34);modal.graphics.drawRect(0,62,960,658);modal.graphics.endFill();
            ClassicInventorySkin.panel(modal.graphics,301,152,414,384);
            var box:Object=MysteryCatalog.box(kind),cls:String=MysteryCatalog.packClass(kind);
            label(modal,"mystery-dialog-title",cls!=""?cls+" PACK":"MYSTERY BOX",328,164,357,34,25);
            button(modal,"mystery-dialog-close","X",670,159,34,28,function():void{render();},0x697c87);
            var r:Object=GameData.mysteryInventory.pending;
            if(r){
                selected=String(r.source);if(MysteryCatalog.packClass(selected)!="")revealArt=pack(modal,470,304,1.1,MysteryCatalog.packClass(selected));else revealArt=chest(modal,420,304,selected,1.25);
                if(animate){opening=true;revealAt=getTimer()+1050;revealX=revealArt.x;revealY=revealArt.y;revealScale=revealArt.scaleX;revealArt.filters=[new GlowFilter(0xffe779,.75,14,14,1.5)];label(modal,"mystery-opening","OPENING…",339,223,340,38,22,0xffe56b);addEventListener(Event.ENTER_FRAME,onReveal);return;}
                drawReward(r);return;
            }
            if(cls!="")pack(modal,470,246,1.3,cls);else chest(modal,424,254,kind,1.25);
            var cost:int=MysteryInventory.keyCost(kind),keys:int=GameData.mysteryInventory.keys;
            label(modal,"mystery-requirement",cls!=""?"One Special Batter Card inside.":cost+" llaves para abrir esta caja.",326,213,364,35,15,0xcbe1f0);
            label(modal,"mystery-owned",cls!=""?"You have: "+GameData.mysteryInventory.packs[cls]+" "+cls+" Packs":"You have: "+keys+" Keys",327,414,364,28,16,0xffffff);
            button(modal,"mystery-confirm",cls!=""?"OPEN "+cls+" PACK":"OPEN UP WITH KEY ("+cost+")",351,471,314,34,begin,0x74b52c,cls!=""?GameData.mysteryInventory.packs[cls]>0:keys>=cost);
            if(cls==""&&keys<cost)label(modal,"mystery-no-keys","Gana partidos para conseguir más llaves.",327,445,364,22,13,0xffe16a);
        }
        private function begin():void {
            var cls:String=MysteryCatalog.packClass(selected);
            var r:Object=cls!=""?GameData.mysteryOpenPack(cls):GameData.mysteryOpen(selected);
            if(r.status=="OK")detail(selected,true);else if(r.status=="PENDING")detail(selected,false);else render();
        }
        private function drawReward(r:Object):void {
            var prize:Sprite=new Sprite();modal.addChild(prize);prize.x=449;prize.y=227;
            prize.graphics.lineStyle(3,0xe8f7cb);ClassicInventorySkin.gradient(prize.graphics,0,0,122,148,0xffffed,0xdfecbf,10);prize.graphics.lineStyle();
            var item:Object=r.type=="GEAR"?MysteryCatalog.gearById(String(r.itemId)):null;
            if(r.type=="CARD"){
                var card:SpecialBatterCardView=new SpecialBatterCardView(SpecialCardInventory.catalog(String(r.cardId)),122,148);card.mouseEnabled=card.mouseChildren=false;prize.addChild(card);artDisposables.push(card);
            }else{
                if(r.type=="PACK")pack(prize,38,19,1,String(r.packClass||"C"));
                else if(r.type=="GEAR"){
                    var art:Sprite=item.slot=="bat"?new GearArtwork(String(item.name),72):GearPieceArtwork.supports(String(item.name))?new GearPieceArtwork(String(item.name),String(item.slot),72):new BasicGearIcon(item);
                    art.x=61;art.y=48;prize.addChild(art);
                }
                else if(r.type=="KEY")key(prize,42,21,1);
                else ClassicInventorySkin.icon(prize,r.type=="CASH"?"cash":r.type=="ENERGY"?"energy":"coin",40,28,1.45);
                var value:String=r.type=="PACK"?String(r.packClass||"C")+" Pack":item?String(item.name):"+"+r.amount+" "+r.type;
                label(prize,"mystery-prize",value,5,99,112,44,item?11:17,0x435c56);
            }
            if(item&&GameData.ownsShopItem(item))label(modal,"mystery-duplicate","Already owned → "+int(r.duplicateCoins)+" Coins",321,382,375,25,13,0xffe48a);
            var types:Array=["CASH","COINS","CARD","KEY","ENERGY","GEAR"];
            var icons:Array=["cash","coin","batter","key","energy","case"];
            for(var i:int=0;i<types.length;i++){
                var active:Boolean=types[i]==r.type||(r.type=="PACK"&&types[i]=="CARD");ClassicInventorySkin.gradient(modal.graphics,329+i*60,414,55,40,active?0xa5d7f1:0x4b7391,0x143f61,4);
                var icon:Sprite=InventoryArtwork.supports(icons[i])?new InventoryArtwork(icons[i],28,23):new InterfaceSprite(icons[i],28,23);icon.x=342+i*60;icon.y=415;icon.alpha=active?1:.58;modal.addChild(icon);
                label(modal,"mystery-category-"+i,types[i],329+i*60,437,55,16,8,0xd8edf7);
            }
            button(modal,"mystery-collect","COLLECT",351,474,314,34,function():void{var result:Object=GameData.mysteryCollect(String(r.id));if(result.status=="OK")render();},0x74b52c);
        }
        private function onReveal(e:Event):void {
            var remaining:int=revealAt-getTimer();if(remaining>0){if(revealArt){var t:Number=1-remaining/1050;revealArt.x=revealX+Math.sin(t*48)*4*(1-t);revealArt.y=revealY-Math.sin(t*Math.PI)*5;revealArt.rotation=Math.sin(t*36)*3*(1-t);revealArt.scaleX=revealArt.scaleY=revealScale*(1+.045*Math.sin(t*Math.PI));}return;}
            removeEventListener(Event.ENTER_FRAME,onReveal);opening=false;detail(selected,false);
        }
        private function chest(p:Sprite,x:Number,y:Number,kind:String,scale:Number):Sprite {
            var s:Sprite=new Sprite();s.x=x;s.y=y;s.scaleX=s.scaleY=scale;s.mouseEnabled=s.mouseChildren=false;p.addChild(s);
            s.addChild(new InventoryArtwork(InventoryArtwork.supports(kind)?kind:"rookie",128,90));return s;
        }
        private function key(p:Sprite,x:Number,y:Number,scale:Number):void {
            var s:Sprite=new InventoryArtwork("key",49,63);s.x=x;s.y=y;s.scaleX=s.scaleY=scale;p.addChild(s);
        }
        private function pack(p:Sprite,x:Number,y:Number,scale:Number,cls:String="C"):Sprite {
            var s:ClassPackArtwork=new ClassPackArtwork(cls,65,74);s.x=x-10*scale;s.y=y;s.scaleX=s.scaleY=scale;p.addChild(s);artDisposables.push(s);return s;
        }
        public function dispose():void {if(disposed)return;disposed=true;clear();background.dispose();home=shop=gear=null;}
    }
}
