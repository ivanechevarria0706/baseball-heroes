package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.utils.*;import flash.geom.Point;
    import com.bh.model.GameData;import com.bh.visual.*;
    import flash.filters.GlowFilter;
    /** Stadium stays visible above the compact dock seen in the supplied video. */
    public class BuildScreen extends Sprite {
        private var back:Function,stadium:MatchStadium,body:Sprite=new Sprite(),decor:Sprite=new Sprite(),header:TravelHeader;
        private var views:Array=[],images:Array=[],timer:Timer=new Timer(1000),mode:String="SHOP",slot:String="background",page:int=0,chosen:Object,selected:int=-1;
        private var toast:TextField,income:TextField,mission:MissionCompleteOverlay,dragging:StadiumDecorationView;
        private var expanded:Boolean=false,dead:Boolean=false,actionAfter:int=0,collectButton:Sprite;
        public function BuildScreen(w:Number,h:Number,onHome:Function,onShop:Function){
            name="build-screen";back=onHome;GameData.init();addChild(decor);addChild(body);render();timer.addEventListener(TimerEvent.TIMER,tick);timer.start();
        }
        private function text(v:String,x:Number,y:Number,w:Number,h:Number=24,size:int=14,c:uint=0xffffff):TextField{return ClassicInventorySkin.text(body,v,x,y,w,h,size,c);}
        private function button(v:String,id:String,x:Number,y:Number,w:Number,fn:Function,c:uint=0x237dae,h:Number=32):Sprite {
            var b:Sprite=ClassicInventorySkin.button(v,w,h,c);b.x=x;b.y=y;b.name=id;body.addChild(b);
            if(h>=40){var label:TextField=b.getChildAt(0) as TextField;if(label){LineupTypography.apply(label,22,0xffffff,"center",true);label.y=8;label.height=h-10;}}
            b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{if(!mission&&!dead)fn();});return b;
        }
        private function clear():void {
            for each(var im:AssetImage in images)im.dispose();images=[];
            if(header){header.dispose();header=null;}
            if(stadium){stadium.dispose();removeChild(stadium);stadium=null;}
            for each(var v:StadiumDecorationView in views)v.dispose();views=[];
            while(body.numChildren)body.removeChildAt(0);body.graphics.clear();while(decor.numChildren)decor.removeChildAt(0);
        }
        private function render():void {
            clear();stadium=new MatchStadium(960,720,StadiumPlacement.profile(chosen),false);addChildAt(stadium,0);
            header=new TravelHeader(false," ");body.addChild(header);drawDecor();
            body.graphics.lineStyle(3,0x163b51);ClassicInventorySkin.gradient(body.graphics,9,585,942,128,0x0b83cc,0x07518c,9);body.graphics.lineStyle();
            button("SHOP","build-shop",18,589,229,function():void{mode="SHOP";page=0;chosen=null;expanded=true;render();},mode=="SHOP"?0x149de0:0x125f97,49);
            button("INVENTORY","build-inventory",255,589,220,function():void{mode="INVENTORY";page=0;chosen=null;expanded=true;render();},mode=="INVENTORY"?0x149de0:0x125f97,49);
            body.graphics.beginFill(0x14251f,.88);body.graphics.drawRoundRect(583,565,330,77,8);body.graphics.endFill();
            collectButton=new Sprite();collectButton.name="build-collect";collectButton.x=483;collectButton.y=567;collectButton.mouseChildren=false;collectButton.buttonMode=true;
            collectButton.graphics.beginFill(0xffffff,0);collectButton.graphics.drawRect(0,0,96,78);collectButton.graphics.endFill();body.addChild(collectButton);
            var ticketArt:InterfaceSprite=new InterfaceSprite("chest",82,57);ticketArt.x=7;collectButton.addChild(ticketArt);
            ClassicInventorySkin.text(collectButton,"TICKET SALES",0,58,96,20,11,0xfff2c6,"center",true);
            collectButton.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{if(!mission)collect();});income=text("",595,573,309,62,16,0xfff4d3);
            var close:Sprite=new Sprite();close.name="build-close";close.x=922;close.y=637;close.mouseChildren=false;close.buttonMode=true;body.addChild(close);
            close.graphics.lineStyle(3,0xfff5dc);ClassicInventorySkin.gradient(close.graphics,0,0,29,29,0xe7615f,0x982832,29);close.graphics.lineStyle(3,0xffffff);close.graphics.moveTo(8,8);close.graphics.lineTo(21,21);close.graphics.moveTo(21,8);close.graphics.lineTo(8,21);close.graphics.lineStyle();close.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{if(!mission)back();});
            var keys:Array=["background","field","scoreboard","stand","fence","lights","decoration","banner","wall"],titles:Array=["BACK GROUND","FIELD","SCORE BOARD","STAND","FENCE","FLOOD LIGHT","DECOR","BANNER","WALL"];
            for(var i:int=0;i<keys.length;i++)category(keys[i],titles[i],22+i*98,653);
            if(expanded){
                ClassicInventorySkin.panel(body.graphics,10,440,940,139);
                var items:Array=catalog(),pages:int=Math.max(1,Math.ceil(items.length/5));page=Math.min(page,pages-1);
                for(i=page*5;i<Math.min(items.length,page*5+5);i++)tile(items[i],60+(i%5)*168,449);
                button("<","build-prev",19,491,33,function():void{page=Math.max(0,page-1);render();});
                button(">","build-next",907,491,33,function():void{page=Math.min(pages-1,page+1);render();});
                text((page+1)+" / "+pages,438,557,84,18,10,0xd3f1fc);
                button("HIDE","build-hide",807,149,135,function():void{expanded=false;chosen=null;render();},0x1a649a,26);
            }
            if(chosen){
                ClassicInventorySkin.panel(body.graphics,22,520,916,60);
                text(chosen.name.toUpperCase(),39,526,443,25,18,0xffe480);
                text(chosen.description||"",39,551,615,24,12,0xcfe6ee);
                text(GameData.ownsStadiumItem(chosen.id)?"OWNED":GameData.shopPriceLabel(chosen),491,527,175,25,18,0xffdf6c);
                var actionName:String=actionLabel(),action:Sprite=button(actionName,"build-action",686,535,232,act,0x6ba52b);
                if(actionName=="ACTIVE"||actionName=="LOCKED"){action.mouseEnabled=false;action.alpha=.60;}
                var explanation:TextField=text(actionName=="ACTIVE"?"Los cambios de este artículo ya están guardados.":"Vista previa: no gasta monedas ni guarda cambios.",35,496,625,24,13,0xffe895);explanation.filters=[new GlowFilter(0x173a35,1,2,2,4)];
                button(actionName=="ACTIVE"?"CLOSE DETAILS":"CANCEL PREVIEW","build-cancel-preview",696,491,242,function():void{chosen=null;render();},0x256d9c,27);
            }
            if(selected>=0){
                button("−","build-scale-down",677,265,47,function():void{scaleDecor(-.1);});button("+","build-scale-up",732,265,47,function():void{scaleDecor(.1);});
                button("REMOVE","build-remove",790,265,143,function():void{GameData.removeStadiumDecoration(selected);selected=-1;render();});
            }
            toast=text("",22,101,918,43,15,0xffe78d);
            if(!chosen){var hint:TextField=text("Arrastra tus decoraciones para colocarlas. Elige una categoría para ver artículos.",31,548,902,30,13,0xfff4cf);hint.filters=[new GlowFilter(0x173a35,1,2,2,4)];}
            tick(null);
        }
        private function category(key:String,title:String,x:Number,y:Number):void {
            var b:Sprite=new Sprite();b.x=x;b.y=y;b.name="build-category-"+key;b.mouseChildren=false;b.buttonMode=true;
            b.graphics.beginFill(0xffffff,0);b.graphics.drawRect(0,0,94,57);b.graphics.endFill();
            if(expanded&&slot==key){b.graphics.lineStyle(2,0x9deaff);b.graphics.beginFill(0x208bca,.8);b.graphics.drawRoundRect(3,0,88,57,6);b.graphics.endFill();b.graphics.lineStyle();}
            var icon:BuildCategoryIcon=new BuildCategoryIcon(key);icon.x=47;icon.y=22;icon.scaleX=icon.scaleY=.70;b.addChild(icon);
            ClassicInventorySkin.text(b,title,1,40,92,16,9,0xffffff,"center",true);body.addChild(b);
            b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{if(mission)return;slot=key;page=0;chosen=null;selected=-1;expanded=true;render();});
        }
        private function catalog():Array {
            var result:Array=[];for each(var item:Object in GameData.shopCatalog())if(item.category=="STADIUM"&&item.slot==slot&&(mode=="SHOP"||GameData.ownsStadiumItem(item.id)))result.push(item);return result;
        }
        private function tile(item:Object,x:Number,y:Number):void {
            var t:Sprite=new Sprite();t.x=x;t.y=y;t.name="build-item-"+item.id;t.buttonMode=true;t.mouseChildren=false;body.addChild(t);
            t.graphics.lineStyle(chosen&&chosen.id==item.id?3:1,chosen&&chosen.id==item.id?0x9ceaff:0x839da5);ClassicInventorySkin.gradient(t.graphics,0,0,156,105,0xf9f8f0,0xd6dfdd,6);t.graphics.lineStyle();
            if(slot=="background"){
                var path:String=VisualAssetRegistry.stadiumPath(item.id);if(path){var im:AssetImage=new AssetImage(path,146,60,AssetImage.CONTAIN);im.x=5;im.y=3;t.addChild(im);images.push(im);}else if(item.id=="stadium_background_mountain"){var rookie:RookieStadiumArtwork=new RookieStadiumArtwork(80,60);rookie.x=38;rookie.y=3;t.addChild(rookie);}else{var bg:BuildCategoryIcon=new BuildCategoryIcon("background");bg.x=78;bg.y=32;t.addChild(bg);}
            }else if(slot=="decoration"){
                var d:StadiumDecorationView=new StadiumDecorationView(item,-1);d.x=78;d.y=38;d.scaleX=d.scaleY=.68;t.addChild(d);views.push(d);
            }else{var icon:BuildCategoryIcon=new BuildCategoryIcon(slot,uint(item.accent));icon.x=78;icon.y=30;t.addChild(icon);}
            ClassicInventorySkin.text(t,item.name,3,62,150,19,10,0x294450,"center");
            var owned:Boolean=GameData.ownsStadiumItem(item.id),active:Object=GameData.activeStadiumItem(slot);
            ClassicInventorySkin.text(t,!GameData.shopItemUnlocked(item)?"LOCKED":active&&active.id==item.id?"ACTIVE":owned?"OWNED":GameData.shopPriceLabel(item),3,82,150,20,12,owned?0x2e7d3d:0x97692b,"center");
            t.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{if(!mission){chosen=item;selected=-1;expanded=false;render();}});
        }
        private function actionLabel():String {
            if(!GameData.ownsStadiumItem(chosen.id))return GameData.shopItemUnlocked(chosen)?"BUY / USE":"LOCKED";
            if(GameData.isPlaceableDecoration(chosen))return "PLACE";var active:Object=GameData.activeStadiumItem(slot);return active&&active.id==chosen.id?"ACTIVE":"USE";
        }
        private function act():void {
            if(!chosen||getTimer()<actionAfter)return;actionAfter=getTimer()+350;
            var result:String=GameData.ownsStadiumItem(chosen.id)?"OWNED":GameData.purchaseShopItem(chosen);
            if(result!="OK"&&result!="OWNED"){toast.text=result=="COINS"?"No tienes suficientes monedas.":result=="CASH"?"No tienes suficiente moneda premium.":"Este artículo todavía está bloqueado.";return;}
            if(GameData.isPlaceableDecoration(chosen)){
                if(!GameData.addStadiumDecoration(chosen)){toast.text="Puedes colocar hasta ocho decoraciones.";return;}selected=GameData.stadiumDecorations.length-1;
            }else GameData.activateStadiumItem(chosen);
            render();checkMission();
        }
        private function drawDecor():void {
            for(var i:int=0;i<GameData.stadiumDecorations.length;i++){
                var entry:Object=GameData.stadiumDecorations[i],item:Object=GameData.shopItemById(entry.id);if(!item)continue;
                var v:StadiumDecorationView=new StadiumDecorationView(item,i);v.name="stadium-decoration-"+i;StadiumPlacement.place(v,entry);v.setSelected(i==selected);decor.addChild(v);views.push(v);v.addEventListener(MouseEvent.MOUSE_DOWN,startDragDecor);
            }
        }
        private function startDragDecor(e:MouseEvent):void {
            if(mission||dead||!stage)return;dragging=e.currentTarget as StadiumDecorationView;selected=dragging.decorationIndex;chosen=null;
            for each(var v:StadiumDecorationView in views)v.setSelected(v===dragging);
            dragging.startDrag(false,StadiumPlacement.dragBounds());stage.addEventListener(MouseEvent.MOUSE_UP,stopDragDecor);stage.addEventListener(Event.MOUSE_LEAVE,stopDragDecor);
        }
        private function stopDragDecor(e:Event):void {
            if(!dragging)return;if(stage){stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragDecor);stage.removeEventListener(Event.MOUSE_LEAVE,stopDragDecor);}
            dragging.stopDrag();var entry:Object=GameData.stadiumDecorations[selected],p:Point=StadiumPlacement.stored(new Point(dragging.x,dragging.y));
            GameData.updateStadiumDecoration(selected,p.x,p.y,entry.scale);dragging=null;render();
        }
        private function scaleDecor(delta:Number):void {var entry:Object=GameData.stadiumDecorations[selected];GameData.updateStadiumDecoration(selected,entry.x,entry.y,Number(entry.scale)+delta);render();}
        private function tick(e:TimerEvent):void {
            if(income)income.text="Collect +"+GameData.gateIncomeAmount()+" Coin / 6 Hours\nUp to +"+GameData.gateIncomeDailyAmount()+" / day\n"+GameData.gateIncomeCountdownLabel();
            if(collectButton){collectButton.alpha=GameData.canCollectGateIncome()?1:.65;collectButton.mouseEnabled=GameData.canCollectGateIncome();}
        }
        private function collect():void {var value:int=GameData.collectGateIncome();render();toast.text=value>0?"+"+value+" COINS · TICKET SALES":"Próxima recaudación: "+GameData.gateIncomeCountdownLabel();checkMission();}
        private function checkMission():void {
            if(mission||GameData.missionClaimed("stadium_growth")||!GameData.missionComplete("stadium_growth"))return;
            mission=new MissionCompleteOverlay("stadium_growth",function():void{mission.dispose();removeChild(mission);mission=null;render();});mission.x=480;mission.y=360;mission.scaleX=mission.scaleY=1.5;addChild(mission);
        }
        public function dispose():void {
            if(dead)return;dead=true;timer.stop();timer.removeEventListener(TimerEvent.TIMER,tick);
            if(stage){stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragDecor);stage.removeEventListener(Event.MOUSE_LEAVE,stopDragDecor);}
            if(dragging){dragging.stopDrag();dragging=null;}if(mission){mission.dispose();mission=null;}clear();
        }
    }
}
