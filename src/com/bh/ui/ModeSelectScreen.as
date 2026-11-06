package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.TextField;import flash.ui.Keyboard;
    import com.bh.model.GameData;
    import com.bh.visual.AssetImage;import com.bh.visual.VisualAssetRegistry;import com.bh.visual.TravelMapArtwork;import com.bh.visual.LeagueBadgeView;
    /** Classic competition menu. Choosing a card only previews existing rules. */
    public class ModeSelectScreen extends Sprite {
        private var onBack:Function,onRegular:Function,onDerby:Function,onFirstGame:Function,onRival:Function,onPostSeason:Function;
        private var selectedId:String="opening",entries:Array=[],cards:Array=[],assets:Array=[],controls:Array=[];
        private var actionButton:Sprite,detailArt:Sprite=new Sprite(),detailTitle:TextField,detailStatus:TextField,detailHint:TextField,detailFacts:TextField;
        private var resourceBar:MatchResourceBar,boundStage:Stage,held:Object={},leaving:Boolean=false,dead:Boolean=false;
        public function ModeSelectScreen(w:Number,h:Number,backCallback:Function,regularCallback:Function,derbyCallback:Function,firstGameCallback:Function=null,rivalCallback:Function=null,postSeasonCallback:Function=null) {
            name="competition-modes";onBack=backCallback;onRegular=regularCallback;onDerby=derbyCallback;onFirstGame=firstGameCallback;onRival=rivalCallback;onPostSeason=postSeasonCallback;GameData.init();
            TravelMapArtwork.drawBackdrop(graphics,w,h);
            ClassicInventorySkin.panel(graphics,329,465,611,184);
            header();entries=CompetitionModes.catalog();
            for(var i:int=0;i<entries.length;i++)card(entries[i],i);
            detailArt.x=817;detailArt.y=476;addChild(detailArt);
            detailTitle=text("",345,476,452,31,20);detailTitle.name="mode-detail-title";
            detailStatus=text("",345,504,452,22,12,0xffe69b);detailStatus.name="mode-detail-status";
            detailHint=text("",346,531,577,56,13,0xe2f3ff);detailHint.name="mode-detail-hint";detailHint.multiline=detailHint.wordWrap=true;
            ClassicChrome.well(graphics,341,591,399,46,false,false);
            detailFacts=text("",350,596,382,38,11,0xffefb3);detailFacts.name="mode-detail-facts";detailFacts.multiline=detailFacts.wordWrap=true;
            actionButton=button("OPEN SEASON","mode-open",754,593,173,43,activate,0x7caf30);
            text("Selecciona una ficha para ver requisitos. También puedes usar las flechas y ENTER.",26,686,675,26,11,0xe0f5ff);
            if(onFirstGame!=null)button("REPLAY FIRST GAME","mode-tutorial",719,681,217,31,replay,0xb08229);
            select(GameData.postSeasonInProgress()||GameData.pendingPostSeasonPayment()?"postseason":!GameData.seasonComplete&&GameData.seasonEventType(GameData.seasonGame)=="SPECIAL"?"special":"opening");
            addEventListener(Event.ADDED_TO_STAGE,added);addEventListener(Event.REMOVED_FROM_STAGE,removed);
        }
        private function text(value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,parent:Sprite=null):TextField {return ClassicInventorySkin.text(parent||this,value,x,y,w,h,size,color,"center",size>=18);}
        private function number(n:int):String {return String(n).replace(/\B(?=(\d{3})+(?!\d))/g,",");}
        private function header():void {
            resourceBar=new MatchResourceBar(960,true);addChild(resourceBar);
            ClassicChrome.title(text("GAME MODES",121,65,268,42,26),32);text(GameData.teamName+"  ·  "+GameData.leagueName()+" LEAGUE",391,76,421,25,13,0xcfeeff);
            button("HOME","mode-home",838,72,106,31,back,0x416f8b);
        }
        private function button(value:String,id:String,x:Number,y:Number,w:Number,h:Number,handler:Function,color:uint):Sprite {
            var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,handler);addChild(b);controls.push({view:b,handler:handler});return b;
        }
        private function card(entry:Object,index:int):void {
            var b:Sprite=new Sprite(),last:Boolean=index==6;b.name="mode_"+entry.id;b.x=20+(index%3)*310;b.y=117+int(index/3)*171;if(last){b.x=20;b.y=465;}b.mouseChildren=false;b.buttonMode=b.useHandCursor=true;addChild(b);
            var art:AssetImage=new AssetImage(VisualAssetRegistry.modeIconPath(entry.id),258,last?100:89,AssetImage.CONTAIN);art.x=21;art.y=9;b.addChild(art);assets.push(art);
            var title:TextField=text(entry.title,6,last?114:102,288,24,15,0x24485f,b);
            var status:TextField=text(entry.status,6,last?144:130,288,23,12,entry.enabled?0x347721:0x70572f,b);status.name="mode-status-"+entry.id;
            b.addEventListener(MouseEvent.CLICK,choose);cards.push({view:b,id:entry.id,width:300,height:last?184:157,status:status,title:title});
        }
        private function callback(id:String):Function {return id=="opening"||id=="special"?onRegular:id=="home_run_derby"?onDerby:id=="postseason"?onPostSeason:id=="rival"?onRival:null;}
        private function choose(e:MouseEvent):void {if(dead||leaving)return;for each(var c:Object in cards)if(c.view==e.currentTarget){select(c.id);return;}}
        private function select(id:String):void {
            if(dead)return;selectedId=id;entries=CompetitionModes.catalog();
            for each(var c:Object in cards){var entry:Object=CompetitionModes.byId(c.id),chosen:Boolean=c.id==id,g:Graphics=Sprite(c.view).graphics;
                g.clear();ClassicChrome.well(g,0,0,c.width,c.height,chosen);
                g.lineStyle(1,0xf1ffff);g.drawRoundRect(3,3,c.width-6,c.height-6,6);g.lineStyle();TextField(c.status).text=entry.status;TextField(c.status).textColor=entry.enabled?0x347721:0x70572f;
            }
            var selected:Object=CompetitionModes.byId(id);if(!selected)return;
            while(detailArt.numChildren){var previous:AssetImage=detailArt.getChildAt(0) as AssetImage;if(previous)previous.dispose();detailArt.removeChildAt(0);}
            var image:AssetImage=new AssetImage(VisualAssetRegistry.modeIconPath(id),106,44,AssetImage.CONTAIN);detailArt.addChild(image);
            detailTitle.text=selected.title;detailStatus.text=selected.status;detailHint.text=selected.hint;detailFacts.text=selected.detail;LineupTypography.fit(detailHint,13,0xe2f3ff,"center",false,11);LineupTypography.fit(detailFacts,11,0xffefb3,"center",false,10);
            var label:TextField=actionButton.getChildAt(0) as TextField;if(label)label.text=selected.action;
            actionButton.mouseEnabled=actionButton.buttonMode=selected.enabled&&callback(id)!=null;actionButton.alpha=actionButton.mouseEnabled?1:.48;
        }
        private function activate(e:MouseEvent=null):void {
            if(dead||leaving)return;var selected:Object=CompetitionModes.byId(selectedId),fn:Function=callback(selectedId);
            // Recheck live availability, even if a key event reaches a disabled control.
            if(!selected||!selected.enabled||fn==null){select(selectedId);return;}
            leaving=true;fn();
        }
        private function back(e:MouseEvent):void {if(dead||leaving||onBack==null)return;leaving=true;onBack();}
        private function replay(e:MouseEvent):void {if(dead||leaving||onFirstGame==null)return;leaving=true;onFirstGame();}
        private function added(e:Event):void {boundStage=stage;if(boundStage){boundStage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);boundStage.addEventListener(KeyboardEvent.KEY_UP,keyUp);boundStage.addEventListener(Event.DEACTIVATE,deactivate);}}
        private function removed(e:Event):void {unbind();}
        private function keyDown(e:KeyboardEvent):void {
            if(dead||leaving)return;if([Keyboard.LEFT,Keyboard.RIGHT,Keyboard.UP,Keyboard.DOWN,Keyboard.ENTER].indexOf(e.keyCode)<0)return;
            e.preventDefault();if(held[e.keyCode])return;held[e.keyCode]=true;if(e.keyCode==Keyboard.ENTER){activate();return;}
            var at:int=0;for(var i:int=0;i<entries.length;i++)if(entries[i].id==selectedId){at=i;break;}
            var target:int=at;if(e.keyCode==Keyboard.LEFT||e.keyCode==Keyboard.RIGHT)target=(at+(e.keyCode==Keyboard.LEFT?-1:1)+entries.length)%entries.length;else if(e.keyCode==Keyboard.UP){target=at-3;if(target<0){target=at+6;while(target>=entries.length)target-=3;}}else {target=at+3;if(target>=entries.length)target=at%3;}select(entries[target].id);
        }
        private function keyUp(e:KeyboardEvent):void {delete held[e.keyCode];}
        private function deactivate(e:Event):void {held={};}
        private function unbind():void {if(boundStage){boundStage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown);boundStage.removeEventListener(KeyboardEvent.KEY_UP,keyUp);boundStage.removeEventListener(Event.DEACTIVATE,deactivate);boundStage=null;}held={};}
        public function dispose():void {if(dead)return;dead=true;unbind();removeEventListener(Event.ADDED_TO_STAGE,added);removeEventListener(Event.REMOVED_FROM_STAGE,removed);for each(var c:Object in cards)c.view.removeEventListener(MouseEvent.CLICK,choose);for each(var b:Object in controls){b.view.removeEventListener(MouseEvent.CLICK,b.handler);if(b.view is ClassicActionButton)ClassicActionButton(b.view).dispose();}for each(var a:AssetImage in assets)a.dispose();for(var i:int=0;i<detailArt.numChildren;i++)if(detailArt.getChildAt(i) is AssetImage)AssetImage(detailArt.getChildAt(i)).dispose();resourceBar.dispose();cards=[];controls=[];assets=[];}
    }
}
