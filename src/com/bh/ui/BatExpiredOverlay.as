package com.bh.ui {
    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.text.*;
    import flash.filters.GlowFilter;
    import com.bh.model.GameData;
    import com.bh.model.ConsumableBats;
    import com.bh.visual.GearArtwork;

    /** Result/HOME recovery of a persisted notice. Preview is free; only BUY debits. */
    public class BatExpiredOverlay extends Sprite {
        private var board:Sprite=new Sprite(),cards:Sprite=new Sprite();
        private var buttons:Array=[],offers:Array=ConsumableBats.catalog();
        private var selected:String="",status:TextField,balance:TextField;
        private var onClose:Function;
        public function BatExpiredOverlay(w:Number,h:Number,close:Function){
            name="bat-expired-overlay";onClose=close;
            graphics.beginFill(0x102d40,.38);graphics.drawRect(0,0,w,h);graphics.endFill();
            addEventListener(MouseEvent.CLICK,stopClick);
            var scale:Number=Math.min(w/960,h/720);board.scaleX=board.scaleY=scale;board.x=(w-960*scale)/2;board.y=(h-720*scale)/2;addChild(board);
            board.graphics.lineStyle(3,0x314752);ClassicInventorySkin.gradient(board.graphics,180,112,600,476,0xffffff,0xd7dcd8,18);board.graphics.lineStyle();
            var title:TextField=text(board,"YOUR BAT HAS",215,121,530,43,30,0x51bce7);title.filters=[new GlowFilter(0x12394d,1,4,4,5)];
            title=text(board,"EXPIRED!",320,158,340,60,46,0xffd449);title.filters=[new GlowFilter(0x6b3218,1,5,5,5)];title.rotation=-3;
            text(board,"Tu bate permanente vuelve a estar equipado.",202,220,556,24,15,0x495f68);
            ClassicInventorySkin.gradient(board.graphics,206,253,548,248,0x17659d,0x15416e,12);
            cards.x=220;cards.y=265;board.addChild(cards);
            balance=text(board,"",207,505,546,24,14,0x296f91);balance.name="bat-expired-balance";
            status=text(board,"",206,532,548,21,12,0x3e687c);status.name="bat-expired-status";
            var okay:LineupButton=new LineupButton("OKAY",178,35,0x8dcc39,true);okay.name="bat-expired-okay";okay.x=391;okay.y=553;okay.addEventListener(MouseEvent.CLICK,closeNotice);board.addChild(okay);buttons.push({view:okay,fn:closeNotice});
            redraw();
        }
        private function text(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):TextField {
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("Arial",size,color,true,null,null,null,null,"center");t.text=value;LineupTypography.apply(t,size,color,"center");t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=t.mouseEnabled=false;parent.addChild(t);return t;
        }
        private function redraw(message:String="Elige PREVIEW o sigue con tu bate permanente."):void {
            for(var i:int=buttons.length-1;i>=1;i--){var old:Object=buttons.pop();old.view.removeEventListener(MouseEvent.CLICK,old.fn);if(old.view is LineupButton)old.view.dispose();}
            while(cards.numChildren)cards.removeChildAt(0);
            for(i=0;i<offers.length;i++){
                var item:Object=offers[i],x:Number=i*174;
                var card:Sprite=new Sprite();card.name="bat-expired-preview-"+item.id;card.x=x;card.mouseChildren=false;card.buttonMode=true;
                card.graphics.lineStyle(selected==item.id?3:2,selected==item.id?0x78ddff:0x294455);ClassicInventorySkin.gradient(card.graphics,0,0,164,190,selected==item.id?0xdaf9ff:0xffffff,selected==item.id?0x8ad3f0:0xc9cfcb,9);card.graphics.lineStyle();
                var art:GearArtwork=new GearArtwork(String(item.name),112);art.x=79;art.y=67;art.rotation=48;card.addChild(art);
                text(card,"x5",108,79,45,31,24,0xe04545);
                text(card,String(item.name),3,119,158,23,16,uint(item.accent));
                text(card,selected==item.id?"PREVIEW":"TRY ON",3,145,158,22,14,0x176893);
                text(card,GameData.batStock(item)+" LEFT",3,169,158,19,11,0x547181);
                var preview:Function=previewHandler(String(item.id));card.addEventListener(MouseEvent.CLICK,preview);cards.addChild(card);buttons.push({view:card,fn:preview});
                var buy:LineupButton=new LineupButton("BUY 12",150,31,0x8dcc39,true);buy.name="bat-expired-buy-"+item.id;buy.x=x+7;buy.y=198;
                var fn:Function=buyHandler(item);buy.addEventListener(MouseEvent.CLICK,fn);cards.addChild(buy);buttons.push({view:buy,fn:fn});
                buy.alpha=GameData.cash>=12&&GameData.batStock(item)<=ConsumableBats.CAP-5?1:.55;
            }
            balance.text="PREMIUM CURRENCY  "+GameData.cash+"     ·     5 bates por paquete";status.text=message;
        }
        private function previewHandler(id:String):Function {return function(e:MouseEvent):void{selected=id;redraw("PREVIEW · "+ConsumableBats.byId(id).name+" · +400 · 1 bate por partido");};}
        private function buyHandler(item:Object):Function {return function(e:MouseEvent):void{
            var result:String=GameData.purchaseShopItem(item);
            if(result=="OK"){
                GameData.equipItem(item);selected=String(item.id);
                redraw("Equipado: "+item.name+" · "+GameData.batStock(item)+" LEFT");
            }else redraw(result=="CASH"?"No tienes suficientes créditos. Puedes continuar gratis.":result=="FULL"?"No hay espacio para otro paquete de cinco bates.":"Could not buy the pack.");
        };}
        private function stopClick(e:MouseEvent):void {e.stopPropagation();}
        private function closeNotice(e:MouseEvent):void {GameData.acknowledgeBatExpired();if(onClose!=null)onClose();}
        public function dispose():void {
            removeEventListener(MouseEvent.CLICK,stopClick);
            for each(var entry:Object in buttons){entry.view.removeEventListener(MouseEvent.CLICK,entry.fn);if(entry.view is LineupButton)entry.view.dispose();}buttons=[];onClose=null;
        }
    }
}
