package com.bh.ui {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    import com.bh.model.GameData;
    import com.bh.model.SpecialCardEconomy;

    /** Select actual copies, review the transaction, then commit it once. */
    public class CardWorkshopOverlay extends Sprite {
        private var layer:Sprite=new Sprite(),buttons:Array=[],views:Array=[];
        private var mode:String,selectedId:String,selectedTrade:Array=[],page:int=0;
        private var onClose:Function,onUpdate:Function;
        private var confirmation:Object=null,result:Object=null,message:String="";
        private var energyText:TextField,lastTick:int=0;
        public function CardWorkshopOverlay(id:String,tab:String,close:Function,update:Function) {
            selectedId=id;mode=tab;onClose=close;onUpdate=update;
            var owned:Array=GameData.ownedSpecialCards();
            for(var i:int=0;i<owned.length;i++)if(owned[i].id==id){page=int(i/5);break;}
            graphics.beginFill(0x000b15,.87);graphics.drawRect(0,0,960,720);graphics.endFill();
            addChild(layer);name="card_workshop";render();
            addEventListener(Event.ENTER_FRAME,tick);
        }
        private function text(value:String,x:Number,y:Number,w:Number,h:Number,size:int=14,color:uint=0xc5d9e6):TextField {
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("Arial",size,color,true);
            t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.wordWrap=true;t.multiline=true;t.selectable=false;t.mouseEnabled=false;
            layer.addChild(t);return t;
        }
        private function button(id:String,label:String,x:Number,y:Number,w:Number,action:Function,enabled:Boolean=true):void {
            var b:UIButton=new UIButton(label,w,36,0x315e80,0x4a86a7,0x87c6df);
            b.name=id;b.x=x;b.y=y;b.alpha=enabled?1:.4;b.mouseEnabled=enabled;b.mouseChildren=false;
            b.addEventListener(MouseEvent.CLICK,action);buttons.push({view:b,action:action});layer.addChild(b);
        }
        private function clear():void {
            energyText=null;
            for each(var item:Object in buttons){item.view.removeEventListener(MouseEvent.CLICK,item.action);item.view.dispose();}
            buttons=[];
            for each(var view:SpecialBatterCardView in views){view.removeEventListener(MouseEvent.CLICK,choose);view.dispose();}views=[];
            while(layer.numChildren)layer.removeChildAt(0);layer.graphics.clear();
        }
        private function render():void {
            clear();layer.graphics.lineStyle(2,0x7aa9bb);layer.graphics.beginFill(0x102d42);
            layer.graphics.drawRoundRect(26,30,908,662,18);layer.graphics.endFill();
            text("SPECIAL BATTERS  /  "+mode,48,44,590,34,23,0xffda66);
            text("C "+GameData.coins+"     $ "+GameData.cash,650,51,250,26,16,0xffffff);
            button("workshop_close","CLOSE",786,639,122,close);
            if(result){renderResult();return;}
            if(confirmation){renderConfirmation();return;}
            button("workshop_trade","TRADE",48,92,180,function(e:MouseEvent):void{switchTab("TRADE");});
            button("workshop_enhance","ENHANCE",240,92,180,function(e:MouseEvent):void{switchTab("ENHANCE");});
            button("workshop_charge","CHARGE",432,92,180,function(e:MouseEvent):void{switchTab("CHARGE");});
            var all:Array=GameData.ownedSpecialCards(),pages:int=Math.max(1,Math.ceil(all.length/5));
            page=Math.max(0,Math.min(pages-1,page));
            if(selectedId==null&&all.length)selectedId=all[0].id;
            for(var i:int=page*5;i<Math.min(all.length,(page+1)*5);i++) {
                var c:Object=all[i],v:SpecialBatterCardView=new SpecialBatterCardView(c);
                v.x=63+(i%5)*174;v.y=151;v.name="workshop_card_"+c.id;
                v.setSelected(mode=="TRADE"?selectedTrade.indexOf(c.id)>=0:c.id==selectedId);
                v.addEventListener(MouseEvent.CLICK,choose);layer.addChild(v);views.push(v);
            }
            button("workshop_previous","<",638,92,50,function(e:MouseEvent):void{page--;render();},page>0);
            text((page+1)+" / "+pages,703,100,90,24,14,0xffffff);
            button("workshop_next",">",839,92,50,function(e:MouseEvent):void{page++;render();},page<pages-1);
            if(mode=="TRADE")renderTrade();else renderSelected();
            text(message,48,593,850,40,14,0xffd06a);
            if(GameData.pendingSpecialMatch())text("Partido en curso: las cartas quedan reservadas hasta el resultado.",48,646,725,32,13,0xffd06a);
        }
        private function switchTab(value:String):void {mode=value;message="";render();}
        private function choose(e:MouseEvent):void {
            var c:Object=SpecialBatterCardView(e.currentTarget).data;selectedId=c.id;message="";
            if(mode=="TRADE") {
                var index:int=selectedTrade.indexOf(c.id);
                if(index>=0)selectedTrade.splice(index,1);
                else if(GameData.isSpecialCardEquipped(c.id))message="Retira esta carta de la alineación antes de intercambiarla.";
                else if(c.cardClass=="S")message="La clase S ya es la más alta.";
                else if(selectedTrade.length&&GameData.specialCardById(selectedTrade[0]).cardClass!=c.cardClass)message="Elige tres cartas de la MISMA CLASE. Pueden tener cualquier personaje o grado.";
                else if(selectedTrade.length==3)message="Tres seleccionadas. Pulsa una para retirarla.";
                else selectedTrade.push(c.id);
            }
            render();
        }
        private function renderTrade():void {
            text("Pon 3 cartas de la misma clase. Retíralas de la alineación antes de intercambiarlas.",48,389,850,26,16,0xffffff);
            var names:Array=[];
            for each(var id:String in selectedTrade){var c:Object=GameData.specialCardById(id);names.push(c.name+" +"+c.enhancement);}
            text(selectedTrade.length+" / 3 selected: "+names.join("  /  "),48,424,850,46,15,0xffd66e);
            var cls:String=selectedTrade.length?GameData.specialCardById(selectedTrade[0]).cardClass:"C";
            var coinQuote:Object=SpecialCardEconomy.trade(cls,"COINS"),cashQuote:Object=SpecialCardEconomy.trade(cls,"CASH");
            text("CLASS "+cls+" · C "+coinQuote.coins+": "+Math.round(coinQuote.chance*100)+"% de subir de clase. $ "+cashQuote.cash+": subida garantizada.\nSe consumen las tres copias; si no sube la clase, recibes otra carta de la misma clase.",48,478,850,54,14);
            button("trade_coins","C "+coinQuote.coins+" / "+Math.round(coinQuote.chance*100)+"%",48,542,250,function(e:MouseEvent):void{prepare("COINS");},selectedTrade.length==3&&!GameData.pendingSpecialMatch());
            button("trade_cash","$ "+cashQuote.cash+" / 100%",312,542,250,function(e:MouseEvent):void{prepare("CASH");},selectedTrade.length==3&&!GameData.pendingSpecialMatch());
        }
        private function renderSelected():void {
            var c:Object=GameData.specialCardById(selectedId),s:Object=GameData.specialCardState(selectedId);
            if(!c||!s){text("Elige una carta de tu colección.",48,399,820,50,18);return;}
            text(c.name+"  +"+s.enhancement+"     CLASS "+c.cardClass+" / "+c.grade,48,389,845,28,19,0xffd66e);
            energyText=text(GameData.specialCardEnergyLabel(selectedId),48,425,850,28,16,0xffffff);
            if(mode=="CHARGE") {
                text("Gasta 1 de energía por partido; recupera 1 cada 3 horas, incluso al cerrar.\nCon 0/2, juega un compañero normal. Un partido pagado conserva su carta.",48,470,850,59,15);
                var price:int=2-GameData.specialCardEnergy(selectedId);
                button("charge_cash","FULL CHARGE  $ "+price,48,542,310,function(e:MouseEvent):void{prepare("CASH");},price>0&&!GameData.pendingSpecialMatch());
            } else {
                var q:Object=GameData.specialEnhanceQuote(selectedId,"COINS"),allowed:Boolean=q.status=="OK";
                text("AVG ."+c.avg+"  /  COMBO +"+int(c.combo)+"     "+(allowed?"Next: AVG ."+(int(c.avg)+10):status(q.status)),48,465,840,32,16);
                text("Solo Elite / Hero, hasta +5. Si falla, conservas la carta y su mejora actual.",48,505,850,28,13);
                var paid:Object=GameData.specialEnhanceQuote(selectedId,"CASH"),maximum:Object=GameData.specialEnhanceQuote(selectedId,"CASH",true);
                button("enhance_coins",allowed?"C "+q.coins+" / "+Math.round(q.chance*100)+"%":"COINS",48,542,255,function(e:MouseEvent):void{prepare("COINS");},allowed);
                button("enhance_cash",allowed?"+1  $ "+paid.cash+" / 100%":"+1",316,542,255,function(e:MouseEvent):void{prepare("CASH");},allowed);
                button("enhance_max",allowed?"MAX  $ "+maximum.cash+" / 100%":"MAX +5",584,542,305,function(e:MouseEvent):void{prepare("CASH",true);},allowed);
            }
        }
        private function prepare(payment:String,max:Boolean=false):void {
            var q:Object;
            if(mode=="TRADE")q=GameData.specialTradeQuote(selectedTrade,payment);
            else if(mode=="ENHANCE")q=GameData.specialEnhanceQuote(selectedId,payment,max);
            else q={status:"OK",coins:0,cash:2-GameData.specialCardEnergy(selectedId),chance:1};
            if(q.status!="OK"){message=status(q.status);render();return;}
            confirmation={mode:mode,id:selectedId,ids:selectedTrade.concat(),payment:payment,max:max,quote:q};render();
        }
        private function renderConfirmation():void {
            var q:Object=confirmation.quote,names:Array=[];
            var ids:Array=mode=="TRADE"?confirmation.ids:[confirmation.id];
            for(var i:int=0;i<ids.length;i++) {
                var c:Object=GameData.specialCardById(ids[i]);names.push(c.name+" +"+c.enhancement);
                var v:SpecialBatterCardView=new SpecialBatterCardView(c);v.x=mode=="TRADE"?220+i*170:410;v.y=144;layer.addChild(v);views.push(v);
            }
            text("CONFIRM "+mode+"     "+(q.coins?"C "+q.coins:"$ "+q.cash),70,394,810,35,23,0xffd66e);
            var summary:String=names.join(" / ")+"\n";
            if(mode=="TRADE")summary+="Se consumirán estas tres copias. "+(q.chance==1?"Clase "+q.toClass+" garantizada.":Math.round(q.chance*100)+"% clase "+q.toClass+"; si falla, clase "+q.fromClass+".")+" Grados: A 60%, Rare 25%, Elite 12%, Hero 3%.";
            else if(mode=="ENHANCE")summary+="Mejorar "+(confirmation.max?"hasta +5":"un nivel")+". Éxito: "+Math.round(q.chance*100)+"%. El costo se paga aunque falle; conservas la carta.";
            else summary+="Recupera esta copia hasta 2/2 de energía.";
            text(summary,70,440,810,100,17,0xffffff);
            button("workshop_confirm","CONFIRM",70,556,300,commit);
            button("workshop_cancel","BACK",388,556,220,function(e:MouseEvent):void{confirmation=null;render();});
        }
        private function commit(e:MouseEvent):void {
            if(!confirmation)return;
            var action:Object=confirmation;confirmation=null; // Ignore repeated events from a removed button.
            if(action.mode=="TRADE")result=GameData.tradeSpecialCards(action.ids,action.payment);
            else if(action.mode=="ENHANCE")result=GameData.enhanceSpecialCard(action.id,action.payment,action.max);
            else result=GameData.chargeSpecialCard(action.id);
            if(result.card)selectedId=result.card.id;
            if(action.mode=="TRADE"&&result.status=="OK")selectedTrade=[];
            if(onUpdate!=null)onUpdate();render();
        }
        private function renderResult():void {
            var title:String=status(result.status);
            if(result.status=="OK")title=mode=="TRADE"?(result.promoted?"CLASS UP!":"NEW CARD / SAME CLASS"):mode=="ENHANCE"?"ENHANCE SUCCESS!":"ENERGY RESTORED";
            text(title,70,100,820,55,26,0xffd66e);
            if(result.card) {
                var v:SpecialBatterCardView=new SpecialBatterCardView(result.card,210,330);v.x=375;v.y=185;layer.addChild(v);views.push(v);
            }
            text(result.status=="FAILED"?"Se pagó el intento. Conservas la carta y su mejora actual.":"",70,536,820,55,17,0xffffff);
            button("workshop_again","CONTINUE",70,622,250,function(e:MouseEvent):void{result=null;message="";render();});
        }
        private function status(value:String):String {
            var messages:Object={OK:"READY",FAILED:"ENHANCE FAILED",COINS:"Not enough coins.",CASH:"Not enough cash.",
                MATCH_ACTIVE:"Termina el partido antes de cambiar las cartas especiales.",GRADE:"Solo puedes mejorar cartas Elite y Hero.",
                MAX:"MAX +5 reached.",FULL:"Energy is already full.",EQUIPPED:"Retira primero estas cartas de la alineación.",
                THREE:"Elige tres copias.",CLASS:"Las tres deben ser de la misma clase.",DUPLICATE:"Elige tres copias distintas.",MAX_CLASS:"La clase S ya es la más alta.",NOT_OWNED:"Esta copia ya no está en tu colección."};
            return messages[value]?String(messages[value]):"Unable to complete this action.";
        }
        private function tick(e:Event):void {
            if(getTimer()-lastTick<1000)return;lastTick=getTimer();
            if(energyText)energyText.text=GameData.specialCardEnergyLabel(selectedId);
            for each(var v:SpecialBatterCardView in views)v.refresh();
        }
        private function close(e:MouseEvent):void {if(onClose!=null)onClose();}
        public function dispose():void {removeEventListener(Event.ENTER_FRAME,tick);clear();onClose=onUpdate=null;}
    }
}
