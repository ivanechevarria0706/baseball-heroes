package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.utils.getTimer;
    import com.bh.model.GameData;
    import com.bh.model.SpecialCardEconomy;
    import com.bh.visual.MatchStadium;
    import com.bh.visual.LeagueBadgeView;
    import com.bh.visual.CharacterPortrait;
    /** Inventory shell reconstructed from primer_lugar 12:40 and explicando 10:27.
     * All operations still use the tested v21 inventory; this class is presentation only. */
    public class ClassicCardInventory extends Sprite {
        private var content:Sprite=new Sprite(),backdrop:MatchStadium;
        private var views:Array=[],handlers:Array=[],disposables:Array=[],ownedOnly:Boolean=true;
        private var selected:String,trade:Array=[],cardClass:String="ALL",grade:String="ALL",page:int=0;
        private var mode:String="DETAILS",confirmation:Object,result:Object,message:String="";
        private var onBack:Function,shop:BatterShopOverlay,lastRefresh:int=0,energyText:TextField;
        private var mlbCollection:MLB2026Collection;
        public function ClassicCardInventory(w:Number,h:Number,back:Function,initialMode:String="DETAILS") {
            GameData.init();mode=initialMode=="TRADE"?"TRADE":"DETAILS";onBack=back;name="classic-card-inventory";
            graphics.beginFill(0x9f6c28);graphics.drawRect(0,0,960,720);graphics.endFill();
            backdrop=new MatchStadium(960,540);addChild(backdrop);addChild(content);
            var owned:Array=GameData.ownedSpecialCards();selected=owned.length?owned[0].id:null;
            render();addEventListener(Event.ENTER_FRAME,tick);
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,align:String="left",outline:Boolean=false):TextField {
            return ClassicInventorySkin.text(content,value,x,y,w,h,size,color,align,outline);
        }
        private function button(id:String,title:String,x:Number,y:Number,w:Number,h:Number,color:uint,callback:Function,enabled:Boolean=true):Sprite {
            var b:Sprite=ClassicInventorySkin.button(title,w,h,color);b.x=x;b.y=y;b.name=id;
            b.mouseEnabled=enabled;b.alpha=enabled?1:.45;b.addEventListener(MouseEvent.CLICK,callback);
            content.addChild(b);handlers.push({view:b,callback:callback});return b;
        }
        private function tab(id:String,title:String,x:Number,y:Number,w:Number,active:Boolean,callback:Function,grey:Boolean=false):void {
            var b:Sprite=new Sprite();b.x=x;b.y=y;b.name=id;b.buttonMode=true;b.mouseChildren=false;
            b.graphics.lineStyle(2,0x203744);ClassicInventorySkin.gradient(b.graphics,0,0,w,35,grey?(active?0xffffff:0xa7abad):(active?0x178ac7:0x297fab),grey?(active?0xdededc:0x777f85):0x0662a4,8);
            ClassicInventorySkin.text(b,title,3,7,w-6,25,15,0xffffff,"center",true);
            b.addEventListener(MouseEvent.CLICK,callback);handlers.push({view:b,callback:callback});content.addChild(b);
        }
        private function cleanup():void {
            energyText=null;
            for each(var h:Object in handlers)h.view.removeEventListener(MouseEvent.CLICK,h.callback);handlers=[];
            for each(var v:SpecialBatterCardView in views){v.removeEventListener(MouseEvent.CLICK,choose);v.dispose();}views=[];
            for each(var d:Object in disposables)d.dispose();disposables=[];
            while(content.numChildren)content.removeChildAt(0);content.graphics.clear();
        }
        private function render():void {
            cleanup();drawHud();drawDock();
            ClassicChrome.panel(content.graphics,106,106,474,461);
            ClassicChrome.bar(content.graphics,113,113,460,61);
            tab("batter_shop_open","SHOP",123,69,158,false,openShop);
            tab("inventory_tab","INVENTORY",283,69,191,true,function(e:MouseEvent):void{switchMode("DETAILS");});
            button("players_2026","2026",481,69,82,30,0x208f99,open2026);
            ClassicInventorySkin.icon(content,"case",293,76,.7);
            button("cards_back","X",552,85,34,34,0xae2725,close);
            ClassicInventorySkin.icon(content,"helmet",137,127,1);
            content.graphics.lineStyle(1,0x699cb5);ClassicInventorySkin.gradient(content.graphics,183,118,73,52,0x648faf,0x204c77,6);content.graphics.lineStyle();
            ClassicInventorySkin.icon(content,"batter",201,122,1);label("BATTER",188,153,66,20,12,0xffffff,"center",true);
            ClassicInventorySkin.icon(content,"energy",335,125,.95);ClassicInventorySkin.icon(content,"box",397,127,1);
            label("SPECIAL BATTERS",444,137,119,18,10,0x82c8f0,"right");
            var cs:Array=["ALL","C","B","A","S"];
            for(var i:int=0;i<cs.length;i++)classButton(String(cs[i]),164+i*76,182,70);
            button("collection_scope",ownedOnly?"OWNED":"CATALOG",113,546,85,18,0x1475aa,function(e:MouseEvent):void{if(confirmation||result)return;ownedOnly=!ownedOnly;page=0;render();});
            button("filter_grade","GRADE "+grade,204,546,106,18,0x1475aa,function(e:MouseEvent):void{if(confirmation||result)return;var grades:Array=["ALL","HERO","ELITE","RARE","A"];grade=grades[(grades.indexOf(grade)+1)%grades.length];page=0;render();});
            label("Cards "+GameData.ownedSpecialCards().length,373,549,72,15,9,0x78aac1,"right");
            button("card_unlock",GameData.specialSlotsUnlocked>=5?"5 SLOTS":"SLOT "+GameData.nextSpecialSlotPrice(),448,546,123,18,0x1475aa,function(e:MouseEvent):void{if(confirmation||result)return;var cost:Object=GameData.nextSpecialSlotCost();confirmation={mode:"SLOT",quote:cost,ids:[]};render();},GameData.specialSlotsUnlocked<5&&!GameData.pendingSpecialMatch());
            drawCollection();drawSide();
            if(result)drawResult();
            if(message) {content.graphics.beginFill(0x082d48,.95);content.graphics.drawRoundRect(164,496,380,32,5);content.graphics.endFill();label(message,170,498,367,31,10,0xffdd66,"center");}
        }
        private function classButton(cls:String,x:Number,y:Number,w:Number):void {
            button("filter_class_"+cls,cls=="ALL"?"ALL":"SPECIAL-"+cls,x,y,w,22,cardClass==cls?0x369ecd:0x075183,function(e:MouseEvent):void{cardClass=cls;page=0;message="";render();});
        }
        private function drawHud():void {
            var badge:LeagueBadgeView=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),75);badge.x=105;badge.y=8;content.addChild(badge);disposables.push(badge);
            var g:Graphics=content.graphics;
            g.lineStyle(2,0x96cce2);ClassicInventorySkin.gradient(g,211,17,137,26,0x184369,0x0667a0,26);
            ClassicInventorySkin.gradient(g,378,17,123,26,0x539921,0x266323,26);
            ClassicInventorySkin.gradient(g,527,17,143,26,0x204b66,0x154863,26);
            ClassicInventorySkin.gradient(g,713,17,143,26,0x204b66,0x154863,26);g.lineStyle();
            label("LV",186,25,23,17,9);label(String(GameData.level),209,7,45,36,27,0xffffff,"center",true);
            label(String(GameData.xp),252,20,91,20,14,0xffffff,"center",true);
            ClassicInventorySkin.icon(content,"energy",358,10,1.15);label(GameData.energy+" / "+GameData.maxEnergy,396,20,99,20,13,0xffffff,"center",true);
            ClassicInventorySkin.icon(content,"coin",511,14,1);label(String(GameData.coins),540,20,121,20,14,0xffdf53,"center",true);
            ClassicInventorySkin.icon(content,"cash",697,14,1);label(String(GameData.cash),734,20,113,20,14,0xffe984,"center",true);
        }
        private function drawDock():void {
            ClassicInventorySkin.panel(content.graphics,98,555,764,159);
            var roster:Array=GameData.battingOrderPlayers();
            for(var i:int=0;i<Math.min(7,roster.length);i++) {
                var p:Object=roster[i],x:Number=135+i*80;
                content.graphics.lineStyle(2,0x153647);ClassicInventorySkin.gradient(content.graphics,x,582,75,123,0xffffff,0xb9c3c8,4);content.graphics.lineStyle();
                label(String(p.name),x+2,585,71,16,9,0x475660,"center");
                var face:CharacterPortrait=new CharacterPortrait(p,63,60,true);face.x=x+6;face.y=601;content.addChild(face);disposables.push(face);
                content.graphics.beginFill(0x263640,.9);content.graphics.drawRect(x+3,659,69,42);content.graphics.endFill();
                label("AVG   "+p.avg+"\nHR     "+p.hr+"\nRBI    "+p.rbi,x+6,660,65,42,9,0xffffff);
            }
            button("dock_shop","SHOP",704,580,68,55,0x176894,openShop);
            button("dock_lineup","LINEUP",780,580,68,55,0x176894,close);
            button("dock_back","HOME",704,641,144,60,0x176894,close);
        }
        private function list():Array {
            var source:Array=ownedOnly?GameData.ownedSpecialCards():GameData.specialCardCatalog(),out:Array=[];
            for each(var c:Object in source) {
                if(cardClass!="ALL"&&cardClass!=c.cardClass)continue;
                if(grade!="ALL"&&grade!=c.grade)continue;
                if(!ownedOnly)for each(var o:Object in GameData.ownedSpecialCards())if(o.catalogId==c.id){c=o;break;}
                out.push(c);
            }
            return out;
        }
        private function drawCollection():void {
            var all:Array=list(),pages:int=Math.max(1,Math.ceil(all.length/6));page=Math.max(0,Math.min(pages-1,page));
            for(var i:int=0;i<6;i++) {
                var x:Number=166+(i%3)*119,y:Number=211+int(i/3)*168;
                ClassicChrome.well(content.graphics,x,y,112,164,false,false);
                var index:int=page*6+i;if(index>=all.length)continue;
                var c:Object=all[index],picked:Boolean=mode=="TRADE"?trade.indexOf(c.id)>=0:(mode=="ENHANCE"||mode=="CHARGE")&&c.id==selected;
                if(picked&&!result) {
                    content.graphics.lineStyle(2,0x197aaa);ClassicInventorySkin.gradient(content.graphics,x,y,112,164,0x0a72a7,0x07578f,1);content.graphics.lineStyle();
                    var placeholder:Sprite=new Sprite();placeholder.x=x;placeholder.y=y;placeholder.name="collection_card_"+c.id;placeholder.buttonMode=true;placeholder.mouseChildren=false;
                    placeholder.graphics.beginFill(0x00a0e5,.01);placeholder.graphics.drawRect(0,0,112,164);placeholder.graphics.endFill();
                    ClassicInventorySkin.text(placeholder,"SELECTED\nCARD",9,66,94,42,11,0x92d7fa,"center");content.addChild(placeholder);
                    var callback:Function=selectHandler(c);placeholder.addEventListener(MouseEvent.CLICK,callback);handlers.push({view:placeholder,callback:callback});
                } else card(c,x,y,112,164,true,"collection_card_"+c.id,c.id==selected&&mode=="DETAILS");
            }
            button("collection_previous","‹",113,341,22,66,0x456d8a,function(e:MouseEvent):void{page--;render();},page>0);
            button("collection_next","›",553,341,22,66,0x456d8a,function(e:MouseEvent):void{page++;render();},page<pages-1);
            label((page+1)+" / "+pages,311,549,59,15,9,0x88b7ce,"center");
        }
        private function selectHandler(c:Object):Function {return function(e:MouseEvent):void{select(c);};}
        private function choose(e:MouseEvent):void {select(SpecialBatterCardView(e.currentTarget).data);}
        private function select(c:Object):void {
            if(confirmation||result)return;selected=c.id;message="";
            if(mode=="TRADE") {
                var i:int=trade.indexOf(c.id);
                if(i>=0)trade.splice(i,1);
                else if(!GameData.ownsSpecialCard(c.id))message="Esta carta no está en tu inventario.";
                else if(GameData.isSpecialCardEquipped(c.id))message="Retira las cartas de la alineación para intercambiarlas.";
                else if(c.cardClass=="S")message="La clase S ya es la más alta.";
                else if(trade.length&&GameData.specialCardById(trade[0]).cardClass!=c.cardClass)message="Pon tres cartas de la MISMA CLASE.";
                else if(trade.length>=3)message="Tres elegidas. Pulsa una casilla para retirar su carta.";
                else trade.push(c.id);
            }
            render();
        }
        private function card(c:Object,x:Number,y:Number,w:Number,h:Number,interactive:Boolean=false,id:String="",highlight:Boolean=false):SpecialBatterCardView {
            var v:SpecialBatterCardView=new SpecialBatterCardView(c,w,h);v.x=x;v.y=y;v.name=id;v.mouseEnabled=interactive;
            v.setSelected(highlight);if(interactive)v.addEventListener(MouseEvent.CLICK,choose);views.push(v);content.addChild(v);return v;
        }
        private function switchMode(value:String):void {if(confirmation||result)return;mode=value;message="";render();}
        private function drawSide():void {
            tab("card_trade","TRADE",597,111,68,mode=="TRADE",function(e:MouseEvent):void{switchMode("TRADE");},true);
            tab("card_manage","ENHANCE",665,108,111,mode=="ENHANCE",function(e:MouseEvent):void{switchMode("ENHANCE");},true);
            var g:Graphics=content.graphics;g.lineStyle(3,0x26302f);ClassicInventorySkin.gradient(g,587,135,266,422,0xf8f8f5,0xd5d6d2,13);
            g.lineStyle(1,0xffffff);g.drawRoundRect(591,139,258,414,10);g.lineStyle();
            for(var i:int=0;i<70;i++){g.beginFill(0xffffff,.15);g.drawRect(596+(i*43)%245,147+(i*31)%390,13,8);g.endFill();}
            label("?",819,141,23,24,18,0x2189b7,"center");
            if(confirmation){drawConfirmation();return;}
            if(mode=="TRADE")drawTrade();else if(mode=="ENHANCE")drawEnhance();else drawDetails();
        }
        private function drawTrade():void {
            var coords:Array=[[665,160],[602,330],[727,330]];
            for(var i:int=0;i<3;i++) {
                var x:Number=coords[i][0],y:Number=coords[i][1];
                if(i<trade.length) {
                    var c:Object=GameData.specialCardById(trade[i]);card(c,x,y,110,150);
                    var removeId:String=String(c.id);button("trade_remove_"+removeId,"CANCEL",x+5,y+130,100,22,0xb7babc,removeHandler(removeId));
                } else {
                    content.graphics.lineStyle(1,0x9ca2a1);content.graphics.beginFill(0xc5c9c8,.4);content.graphics.drawRoundRect(x+4,y,102,149,4);content.graphics.endFill();content.graphics.lineStyle();
                    label(i==0?"Pon 3 cartas\nSpecial Batter\nde la misma\nclase":"SELECT\nCARD",x+11,y+42,89,85,11,0x7b8485,"center");
                }
            }
            var q:Object=GameData.specialTradeQuote(trade,"COINS");
            var cls:String=trade.length?GameData.specialCardById(trade[0]).cardClass:"C";
            var coinQuote:Object=SpecialCardEconomy.trade(cls,"COINS"),cashQuote:Object=SpecialCardEconomy.trade(cls,"CASH");
            if(q.status=="OK")label("Si no sube de clase, recibes otra\ncarta de clase "+cls+".",599,483,242,33,10,0x536168,"center");
            button("trade_coins","C "+coinQuote.coins+" / "+Math.round(coinQuote.chance*100)+"%",598,518,120,25,0xe1a926,function(e:MouseEvent):void{prepare("COINS");},q.status=="OK"&&!result);
            button("trade_cash","$ "+cashQuote.cash+" / 100%",723,518,120,25,0x65b736,function(e:MouseEvent):void{prepare("CASH");},q.status=="OK"&&!result);
        }
        private function removeHandler(id:String):Function {return function(e:MouseEvent):void{if(confirmation||result)return;var i:int=trade.indexOf(id);if(i>=0)trade.splice(i,1);render();};}
        private function machine():void {
            var g:Graphics=content.graphics;g.lineStyle(2,0x272d2d);ClassicInventorySkin.gradient(g,659,169,121,292,0xf6f6f1,0x8e9495,6);
            g.lineStyle(1,0xffffff);g.drawRect(663,174,113,282);g.lineStyle(2,0x626d71);g.beginFill(0x8e9da4);g.drawEllipse(680,198,78,78);g.endFill();
            g.lineStyle(2,0xffffff);g.drawEllipse(677,195,84,84);g.lineStyle();
            for(var i:int=0;i<2;i++){g.beginFill(i==0?0xbe5259:0x447eb7);g.drawCircle(711+i*17,188,4);g.endFill();}
            label("BASEBALL\nHEROES",666,405,106,44,14,0x697274,"center");
        }
        private function drawEnhance():void {
            machine();var c:Object=GameData.specialCardById(selected),s:Object=GameData.specialCardState(selected);
            if(c&&s&&!result) {
                card(c,663,237,114,164);
                button("enhance_cancel","CANCEL",668,378,104,22,0xb7babc,function(e:MouseEvent):void{selected=null;render();});
            }
            var q:Object=GameData.specialEnhanceQuote(selected,"COINS"),ok:Boolean=q.status=="OK"&&!result;
            label("+1\n"+(ok?Math.round(q.chance*100)+"%":"—"),599,475,77,40,13,0x9b512b,"center");
            label("+1\n100%",683,475,77,40,13,0x397426,"center");
            label("MAX\n100%",767,475,77,40,13,0x397426,"center");
            var paid:Object=GameData.specialEnhanceQuote(selected,"CASH"),maximum:Object=GameData.specialEnhanceQuote(selected,"CASH",true);
            button("enhance_coins",ok?"C "+q.coins:"COINS",598,518,79,25,0xe1a926,function(e:MouseEvent):void{prepare("COINS");},ok);
            button("enhance_cash",ok?"$ "+paid.cash:"+1",681,518,79,25,0x65b736,function(e:MouseEvent):void{prepare("CASH");},ok);
            button("enhance_max",ok?"$ "+maximum.cash:"MAX",764,518,79,25,0x65b736,function(e:MouseEvent):void{prepare("CASH",true);},ok);
            if(c&&s&&q.status!="OK")label(status(q.status),596,438,249,31,10,0x48565c,"center");
        }
        private function drawDetails():void {
            var c:Object=GameData.specialCardById(selected),s:Object=GameData.specialCardState(selected);
            label(mode=="CHARGE"?"SPECIAL ENERGY":"SELECTED BATTER",599,155,243,25,16,0x587c90,"center");
            if(!c){label("Elige una carta de tu inventario.",610,258,220,75,15,0x7b8588,"center");return;}
            card(c,650,188,140,208);
            energyText=label(s?GameData.specialCardEnergyLabel(selected):"Find this card in BATTER SHOP.",599,405,243,37,11,0x46535d,"center");
            if(s)label("AB "+s.atBats+"    H "+s.hits+"    RBI "+s.rbi,599,447,243,23,11,0x68767b,"center");
            var own:Boolean=s!=null,locked:Boolean=GameData.pendingSpecialMatch();
            if(mode=="CHARGE") {
                label("1 de energía por partido.\nRecupera 1 cada 3 horas.",602,474,238,35,11,0x5c6c70,"center");
                button("charge_cash","CHARGE  $ "+(2-GameData.specialCardEnergy(selected)),607,519,226,27,0x65b736,function(e:MouseEvent):void{prepare("CASH");},own&&!locked&&GameData.specialCardEnergy(selected)<2);
            } else {
                button("card_equip",GameData.isSpecialCardEquipped(selected)?"REMOVE":"EQUIP",601,481,116,27,0x65b736,equip,own&&!locked);
                button("card_charge","CHARGE",724,481,116,27,0xe1a926,function(e:MouseEvent):void{switchMode("CHARGE");},own);
                button("details_enhance","ENHANCE",601,518,239,27,0x218cb3,function(e:MouseEvent):void{switchMode("ENHANCE");},own);
            }
        }
        private function equip(e:MouseEvent):void {
            if(GameData.isSpecialCardEquipped(selected))message=GameData.unequipSpecialCard(selected)?"Removed from starting lineup.":status("MATCH_ACTIVE");
            else {var code:String=GameData.equipSpecialCard(selected);message=code=="OK"?"Added to starting lineup.":status(code);}render();
        }
        private function prepare(payment:String,max:Boolean=false):void {
            if(confirmation||result)return;
            var q:Object=mode=="TRADE"?GameData.specialTradeQuote(trade,payment):mode=="ENHANCE"?GameData.specialEnhanceQuote(selected,payment,max):{status:"OK",coins:0,cash:2-GameData.specialCardEnergy(selected),chance:1};
            if(q.status!="OK"){message=status(q.status);render();return;}
            confirmation={mode:mode,payment:payment,max:max,id:selected,ids:trade.concat(),quote:q};render();
        }
        private function drawConfirmation():void {
            var q:Object=confirmation.quote,action:String=confirmation.mode;label("CONFIRM "+action,600,158,240,30,17,0x516d7c,"center");
            var desc:String=action=="SLOT"?"Desbloquea la casilla Special "+(GameData.specialSlotsUnlocked+1)+" de 5.":action=="TRADE"?"Se consumirán estas tres copias.\n"+(q.chance==1?"Clase "+q.toClass+" garantizada.":Math.round(q.chance*100)+"% clase "+q.toClass+"; "+(100-Math.round(q.chance*100))+"% clase "+q.fromClass+".")+"\nGrados: A 60%, Rare 25%,\nElite 12%, Hero 3%.":action=="ENHANCE"?"Mejorar "+(confirmation.max?"hasta +5":"un nivel")+".\nÉxito: "+Math.round(q.chance*100)+"%.\nSi falla, se paga el costo\ny conservas la carta.":"Recupera esta copia hasta 2/2 de energía.";
            label(desc,603,196,234,109,12,0x536168,"center");
            var ids:Array=action=="SLOT"?[]:action=="TRADE"?confirmation.ids:[confirmation.id];
            for(var i:int=0;i<ids.length;i++)card(GameData.specialCardById(ids[i]),ids.length==1?671:603+i*80,317,ids.length==1?98:74,ids.length==1?147:111);
            label(q.coins?"C "+q.coins:"$ "+q.cash,610,470,220,32,19,0x7f6324,"center");
            button("workshop_confirm","CONFIRM",599,516,120,28,0x65b736,commit);
            button("workshop_cancel","BACK",725,516,118,28,0xb3bbbe,function(e:MouseEvent):void{confirmation=null;render();});
        }
        private function commit(e:MouseEvent):void {
            if(!confirmation)return;var a:Object=confirmation;confirmation=null;
            result=a.mode=="SLOT"?{status:GameData.unlockNextSpecialSlot()}:a.mode=="TRADE"?GameData.tradeSpecialCards(a.ids,a.payment):a.mode=="ENHANCE"?GameData.enhanceSpecialCard(a.id,a.payment,a.max):GameData.chargeSpecialCard(a.id);result.action=a.mode;
            if(result.card)selected=result.card.id;if(a.mode=="TRADE"&&result.status=="OK")trade=[];render();
        }
        private function drawResult():void {
            var shade:Sprite=new Sprite();shade.graphics.beginFill(0x063456,.96);shade.graphics.drawRoundRect(158,207,389,311,8);shade.graphics.endFill();content.addChild(shade);
            var title:String=result.status=="OK"?result.action=="SLOT"?"SLOT UNLOCKED":mode=="TRADE"?(result.promoted?"CLASS UP!":"NEW BATTER / SAME CLASS"):mode=="ENHANCE"?"ENHANCE SUCCESS!":"ENERGY RESTORED":status(result.status);
            label(title,170,214,365,39,17,0xffdd46,"center",true);
            if(result.card)card(result.card,283,255,140,result.status=="FAILED"?196:208);
            if(result.status=="FAILED")label("Conservas la carta y su mejora.",170,455,365,18,10,0xffffff,"center");
            button("workshop_again","OKAY",284,476,138,30,0x6ebb31,function(e:MouseEvent):void{result=null;message="";render();});
        }
        private function status(code:String):String {
            var values:Object={OK:"READY",FAILED:"ENHANCE FAILED",COINS:"Not enough coins.",CASH:"Not enough cash.",MATCH_ACTIVE:"Termina primero el partido pendiente.",GRADE:"Elite / Hero cards only.",MAX:"MAX +5",FULL:"No free slot / energy full.",NOT_OWNED:"Card not owned.",EQUIPPED:"Starting-lineup card.",THREE:"Elige tres cartas.",CLASS:"Same class required.",MAX_CLASS:"La clase S ya es la más alta."};
            return values[code]?values[code]:"Unable to complete this action.";
        }
        private function openShop(e:MouseEvent):void {
            if(shop||confirmation||result)return;
            shop=new BatterShopOverlay(function():void{shop.dispose();removeChild(shop);shop=null;render();},function(c:Object=null):void{if(c){selected=c.id;cardClass=grade="ALL";ownedOnly=true;var all:Array=list();for(var i:int=0;i<all.length;i++)if(all[i].id==selected){page=int(i/6);break;}}render();});
            shop.y=90;shop.graphics.clear();shop.graphics.beginFill(0x000000,.58);shop.graphics.drawRect(0,-90,960,720);shop.graphics.endFill();addChild(shop);
        }
        private function close(e:MouseEvent):void {if(confirmation){confirmation=null;render();return;}if(result){result=null;render();return;}if(onBack!=null)onBack();}
        private function open2026(e:MouseEvent):void {
            if(mlbCollection||shop||confirmation||result)return;
            mlbCollection=new MLB2026Collection(function():void{mlbCollection.dispose();removeChild(mlbCollection);mlbCollection=null;render();});addChild(mlbCollection);
        }
        private function tick(e:Event):void {if(getTimer()-lastRefresh<1000)return;lastRefresh=getTimer();if(energyText&&selected)energyText.text=GameData.specialCardEnergyLabel(selected);for each(var v:SpecialBatterCardView in views)v.refresh();}
        public function dispose():void {removeEventListener(Event.ENTER_FRAME,tick);cleanup();if(mlbCollection){mlbCollection.dispose();mlbCollection=null;}if(shop){shop.dispose();shop=null;}if(backdrop){backdrop.dispose();backdrop=null;}onBack=null;}
    }
}
