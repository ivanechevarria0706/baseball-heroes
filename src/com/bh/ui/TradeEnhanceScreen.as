package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.TextField;import flash.utils.getTimer;
    import com.bh.model.GameData;import com.bh.visual.CharacterPortrait;import com.bh.visual.MatchStadium;
    /** Existing development rules with a complete, paged roster and classic chrome. */
    public class TradeEnhanceScreen extends Sprite {
        private var onBack:Function,stadium:MatchStadium,chrome:Sprite=new Sprite(),list:Sprite=new Sprite(),detail:Sprite=new Sprite();
        private var selected:Object,page:int=0,rows:Array=[],controls:Array=[],detailControls:Array=[],portrait:CharacterPortrait;
        private var coins:TextField,message:TextField,pageText:TextField,previous:Sprite,next:Sprite,dead:Boolean=false,leaving:Boolean=false,lastAction:int=-1000;
        public function TradeEnhanceScreen(w:Number,h:Number,backCallback:Function) {
            name="classic-development";onBack=backCallback;GameData.init();stadium=new MatchStadium(w,h);addChild(stadium);
            chrome.mouseEnabled=chrome.mouseChildren=false;chrome.graphics.beginFill(0x052238,.48);chrome.graphics.drawRect(0,0,w,h);chrome.graphics.endFill();addChild(chrome);
            ClassicChrome.panel(chrome.graphics,20,84,442,h-105);ClassicChrome.well(chrome.graphics,476,84,464,h-105);
            ClassicChrome.bar(chrome.graphics,27,91,428,40);ClassicChrome.bar(chrome.graphics,483,91,450,40);
            ClassicChrome.title(text(this,"TRADE & ENHANCE",29,17,471,45,28),31,0xffffff,"left");
            ClassicInventorySkin.icon(this,"coin",578,23);coins=text(this,"",613,27,210,29,16,0xffdf74,"right");coins.name="development-coins";
            button(this,"BACK","development-back",842,23,95,34,back,0x3e7394,controls);
            ClassicChrome.title(text(this,"PLAYER LIST",42,94,227,33,20),25,0xffffff,"left");
            ClassicChrome.title(text(this,"PLAYER DEVELOPMENT",496,94,419,33,20),25,0xffffff,"left");
            text(this,"Selecciona un jugador para mejorar o intercambiar.",280,98,167,31,8,0xd5f0ff,"right");
            list.x=40;list.y=139;addChild(list);detail.x=492;detail.y=139;addChild(detail);
            previous=button(this,"<","development-prev",42,h-62,45,31,prevPage,0x537b92,controls);next=button(this,">","development-next",394,h-62,45,31,nextPage,0x537b92,controls);
            pageText=text(this,"",96,h-57,291,25,12,0xd9f4ff,"center");pageText.name="development-page";
            message=text(this,"",501,h-62,420,36,11,0x435e6e,"center");message.name="development-message";
            selected=GameData.roster.length?GameData.roster[0]:null;render();
        }
        private function text(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,align:String="left"):TextField {return ClassicInventorySkin.text(parent,value,x,y,w,h,size,color,align);}
        private function number(value:int):String {return String(value).replace(/\B(?=(\d{3})+(?!\d))/g,",");}
        private function button(parent:Sprite,value:String,id:String,x:Number,y:Number,w:Number,h:Number,handler:Function,color:uint,list:Array):Sprite {var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,handler);parent.addChild(b);list.push({view:b,handler:handler});return b;}
        private function enable(b:Sprite,value:Boolean):void {b.mouseEnabled=b.buttonMode=b.useHandCursor=value;b.alpha=value?1:.48;}
        private function pages():int {return Math.max(1,Math.ceil(GameData.roster.length/12));}
        private function render():void {
            if(dead)return;page=Math.max(0,Math.min(pages()-1,page));coins.text=number(GameData.coins);clearRows();clearDetails();
            pageText.text="PAGE "+(page+1)+" / "+pages()+"   ·   "+GameData.roster.length+" PLAYERS";enable(previous,page>0);enable(next,page<pages()-1);
            for(var i:int=page*12;i<Math.min(GameData.roster.length,page*12+12);i++)row(GameData.roster[i],i);
            if(!selected||GameData.roster.indexOf(selected)<0)selected=GameData.roster.length?GameData.roster[page*12]:null;
            if(!selected)return;
            ClassicChrome.well(detail.graphics,8,8,116,136);portrait=new CharacterPortrait(selected,100,118,true);portrait.x=16;portrait.y=16;detail.addChild(portrait);
            var title:TextField=text(detail,String(selected.name),137,16,289,37,22,0x284c60);title.name="development-player-title";
            text(detail,selected.grade+"  ·  "+selected.pos,138,60,279,25,13,0x347b9c);
            text(detail,"LEVEL "+selected.level+"    OVR "+selected.rating,138,94,279,26,14,0x536b78);
            text(detail,"XP "+selected.xp+" / 100",138,123,279,23,11,0x536b78);
            var stats:Array=["power","contact","luck"],colors:Array=[0xb76235,0x287dad,0xb48822];
            for(i=0;i<3;i++) {
                var y:Number=166+i*53,value:int=int(selected[stats[i]]);ClassicChrome.well(detail.graphics,9,y,418,46);
                text(detail,String(stats[i]).toUpperCase(),20,y+12,102,25,12,0x33576b);
                ClassicChrome.fill(detail.graphics,130,y+16,213,14,[0x0f3045,0x698492],[0,255],12);
                if(value>0)ClassicChrome.fill(detail.graphics,133,y+19,207*Math.min(1,value/100),8,[ClassicChrome.blend(colors[i],0xffffff,.5),colors[i]],[0,255],8);
                text(detail,String(value),352,y+8,62,31,18,0x315b70,"center");
                var cost:int=GameData.trainingCost(selected,String(stats[i])),b:Sprite=button(detail,"ENHANCE\n"+String(stats[i]).toUpperCase()+"\n"+number(cost)+" COINS","development-"+stats[i],9+i*141,354,135,67,trainClick,uint(colors[i]),detailControls);
                enable(b,value<99&&GameData.coins>=cost);
            }
            var hero:Boolean=String(selected.name)==String(GameData.mainPlayer().name),canTrade:Boolean=!hero&&!selected.friendId&&GameData.roster.length>9;
            text(detail,"Cada mejora añade +1 al atributo y 25 XP.",14,319,411,31,11,0x527285,"center");
            var trade:Sprite=button(detail,hero?"HERO LOCKED":selected.friendId?"FRIEND · NOT FOR SALE":GameData.roster.length<=9?"9 PLAYERS MINIMUM":"TRADE PLAYER  +"+number(GameData.tradeValue(selected))+" COINS","development-trade",55,441,329,39,tradeClick,canTrade?0xa35446:0x70818b,detailControls);enable(trade,canTrade);
            text(detail,"Tu héroe se conserva. El club necesita al menos nueve jugadores.",14,488,411,24,10,0x527285,"center");
        }
        private function row(p:Object,index:int):void {
            var r:Sprite=new Sprite();r.name="player_"+index;r.y=(index%12)*42;r.mouseChildren=false;r.buttonMode=r.useHandCursor=true;
            ClassicChrome.well(r.graphics,0,0,402,38,p==selected);if(p==selected)ClassicChrome.fill(r.graphics,3,3,396,32,[0xfff7ba,0xf2cf56],[0,255],5);
            text(r,String(p.name),12,8,168,24,12,0x284f65);text(r,String(p.pos),179,10,34,21,10,0x456979,"center");text(r,"OVR "+p.rating,216,10,62,21,10,0x456979,"center");text(r,"LV "+p.level,281,10,50,21,10,0x456979,"center");text(r,String(p.avg),335,10,55,21,10,0x456979,"right");
            r.addEventListener(MouseEvent.CLICK,choose);list.addChild(r);rows.push(r);
        }
        private function choose(e:MouseEvent):void {if(dead||leaving)return;var index:int=int(Sprite(e.currentTarget).name.substr(7));if(index>=0&&index<GameData.roster.length){selected=GameData.roster[index];message.text="";render();}}
        private function move(delta:int):void {if(dead||leaving)return;var target:int=Math.max(0,Math.min(pages()-1,page+delta));if(target==page)return;page=target;selected=GameData.roster[page*12];message.text="";render();}
        private function prevPage(e:MouseEvent):void {move(-1);}
        private function nextPage(e:MouseEvent):void {move(1);}
        private function trainClick(e:MouseEvent):void {
            if(dead||leaving||!selected||GameData.roster.indexOf(selected)<0||getTimer()-lastAction<300)return;
            var stat:String=Sprite(e.currentTarget).name.replace("development-",""),cost:int=GameData.trainingCost(selected,stat);
            if(int(selected[stat])>=99||GameData.coins<cost){message.text="No tienes suficientes Coins o el atributo ya está al máximo.";render();return;}
            lastAction=getTimer();var ok:Boolean=GameData.train(selected,stat);message.text=ok?stat.toUpperCase()+" +1   ·   -"+number(cost)+" COINS":"No se pudo aplicar la mejora.";render();
        }
        private function tradeClick(e:MouseEvent):void {
            if(dead||leaving||!selected||GameData.roster.indexOf(selected)<0||String(selected.name)==String(GameData.mainPlayer().name)||GameData.roster.length<=9||getTimer()-lastAction<300)return;
            lastAction=getTimer();var name:String=String(selected.name),value:int=GameData.releasePlayer(selected);
            if(value<=0){message.text="No se pudo intercambiar. Se conserva el mínimo de nueve jugadores.";return;}
            page=Math.min(page,pages()-1);selected=GameData.roster[page*12];message.text=name+"   +"+number(value)+" COINS";render();
        }
        private function back(e:MouseEvent):void {if(dead||leaving||onBack==null)return;leaving=true;onBack();}
        private function clearControls(array:Array):void {for each(var c:Object in array){c.view.removeEventListener(MouseEvent.CLICK,c.handler);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}array.length=0;}
        private function clearRows():void {for each(var r:Sprite in rows)r.removeEventListener(MouseEvent.CLICK,choose);rows=[];while(list.numChildren)list.removeChildAt(0);}
        private function clearDetails():void {clearControls(detailControls);if(portrait){portrait.dispose();portrait=null;}while(detail.numChildren)detail.removeChildAt(0);detail.graphics.clear();}
        public function dispose():void {if(dead)return;dead=true;clearRows();clearDetails();clearControls(controls);stadium.dispose();}
    }
}
