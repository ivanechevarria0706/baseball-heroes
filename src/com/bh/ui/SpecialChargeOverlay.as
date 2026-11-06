package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.utils.Timer;
    import com.bh.model.GameData;import com.bh.visual.SpecialCardIllustration;
    /** Direct lineup recharge, with an explicit quote and a single guarded commit. */
    public class SpecialChargeOverlay extends Sprite {
        private var id:String,closeAction:Function,updateAction:Function,dead:Boolean=false,settled:Boolean=false;
        private var confirm:LineupButton,cancel:LineupButton,energy:TextField,price:TextField,message:TextField,art:SpecialCardIllustration;
        private var timer:Timer=new Timer(1000),quoted:int=-1;
        public function SpecialChargeOverlay(cardId:String,onClose:Function,onUpdate:Function){
            id=cardId;closeAction=onClose;updateAction=onUpdate;name="special-charge-dialog";
            graphics.beginFill(0x001824,.74);graphics.drawRect(0,0,960,720);graphics.endFill();ClassicChrome.panel(graphics,215,164,530,392);ClassicChrome.bar(graphics,223,172,514,43);
            ClassicChrome.title(label("SPECIAL BATTER ENERGY",233,174,494,38,26,0xffffff),26);
            ClassicChrome.well(graphics,234,232,162,227);var c:Object=GameData.specialCardById(id);art=new SpecialCardIllustration(c);art.x=252;art.y=257;art.scaleX=art.scaleY=1.02;addChild(art);
            label(String(c.name),242,236,146,25,15,0x234d65,"center");label("CLASS "+c.cardClass+" / "+c.grade,242,423,146,25,11,0x315e76,"center");
            energy=label("",414,239,299,29,20,0xffe36c);energy.name="charge-energy";price=label("",414,277,299,28,18,0xffffff);price.name="charge-price";
            label("Consume 1 de energía por partido.\nLa recarga natural recupera 1 cada 3 horas.\nEsta copia conserva sus mejoras.",414,319,295,76,13,0xcceaf4).wordWrap=true;
            message=label("Revisa el precio y confirma la recarga.",414,406,295,61,13,0xffe3a1);message.wordWrap=true;message.name="charge-message";
            confirm=new LineupButton("CHARGE",224,39,0x83bc35,true);confirm.name="charge-confirm";confirm.x=241;confirm.y=490;confirm.addEventListener(MouseEvent.CLICK,commit);addChild(confirm);
            cancel=new LineupButton("CANCEL",224,39,0xc9d0cc,true);cancel.name="charge-cancel";cancel.x=490;cancel.y=490;cancel.addEventListener(MouseEvent.CLICK,close);addChild(cancel);
            addEventListener(MouseEvent.MOUSE_DOWN,block);addEventListener(MouseEvent.CLICK,block);refresh();timer.addEventListener(TimerEvent.TIMER,tick);timer.start();
        }
        private function label(s:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String="left"):TextField{return ClassicInventorySkin.text(this,s,x,y,w,h,size,color,align,true);}
        private function block(e:MouseEvent):void {e.stopPropagation();}
        private function refresh():void {if(dead)return;var e:int=GameData.specialCardEnergy(id);quoted=2-e;energy.text="ENERGY  "+e+" / 2";price.text=quoted>0?quoted+" HERO COIN"+(quoted==1?"":"S"):"FULL ENERGY";if(e<2)energy.appendText("   +1 "+LineupCardEnergy.countdown(id));LineupTypography.fit(energy,20,0xffe36c,"left",false,12);confirm.mouseEnabled=!settled&&quoted>0&&!GameData.pendingSpecialMatch();confirm.alpha=confirm.mouseEnabled?1:.45;if(!settled&&GameData.pendingSpecialMatch())message.text="Termina el partido pendiente antes de recargar sus cartas.";else if(!settled&&e==2)message.text="La carta está llena. No se realizará ningún cobro.";}
        private function tick(e:TimerEvent):void {refresh();}
        private function commit(e:MouseEvent):void {e.stopPropagation();if(dead||settled)return;var current:int=2-GameData.specialCardEnergy(id);if(current!=quoted){refresh();message.text="El precio cambió por la recuperación natural. Confirma el precio actualizado.";return;}var r:Object=GameData.chargeSpecialCard(id);if(r.status=="OK"){settled=true;cancel.setLabel("CLOSE");message.text="¡Recarga completa! Esta copia vuelve a tener 2/2 de energía.";if(updateAction!=null)updateAction();}else message.text=r.status=="CASH"?"No tienes suficientes Hero Coins.":r.status=="MATCH_ACTIVE"?"Termina el partido pendiente antes de recargar.":"La carta ya está llena; no se realizó ningún cobro.";refresh();}
        private function close(e:MouseEvent):void {e.stopPropagation();if(!dead&&closeAction!=null)closeAction();}
        public function dispose():void {if(dead)return;dead=true;timer.stop();timer.removeEventListener(TimerEvent.TIMER,tick);removeEventListener(MouseEvent.MOUSE_DOWN,block);removeEventListener(MouseEvent.CLICK,block);confirm.removeEventListener(MouseEvent.CLICK,commit);cancel.removeEventListener(MouseEvent.CLICK,close);confirm.dispose();cancel.dispose();art.dispose();closeAction=updateAction=null;}
    }
}
