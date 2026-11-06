package com.bh.ui {
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.utils.getTimer;
    import com.bh.visual.ObservedArtwork;
    import com.bh.visual.GearArtwork;
    import com.bh.visual.GearPieceArtwork;
    import com.bh.visual.LevelUpArtwork;
    /** The saved level award is already credited; this modal only presents it. */
    public class LevelUpOverlay extends Sprite {
        private var onClose:Function,continueButton:UIButton,views:Array=[],closed:Boolean=false;
        private var header:Sprite=new Sprite(),rewardStrip:Sprite=new Sprite(),startedAt:int;
        public function LevelUpOverlay(w:Number,h:Number,data:Object,closeCallback:Function) {
            name="level-up-overlay";onClose=closeCallback;
            graphics.beginFill(0x081c2b,.58);graphics.drawRect(0,0,w,h);graphics.endFill();
            var board:Sprite=new Sprite();addChild(board);board.name="level-up-paper";
            var scale:Number=Math.min(w/960,h/720);board.scaleX=board.scaleY=scale;board.x=(w-960*scale)/2;board.y=(h-720*scale)/2;
            ResultPaperSkin.paper(board.graphics,194,119,572,512);
            header.name="level-up-banner";header.x=500;header.y=145;header.mouseEnabled=header.mouseChildren=false;board.addChild(header);
            var art:LevelUpArtwork=new LevelUpArtwork("header",600,200);art.x=-300;art.y=-100;header.addChild(art);
            ResultPaperSkin.outlined(header,"level-up-number",String(data.toLevel),-257,-49,114,100,76,0xffffff,0x102b50,3);
            var unlocked:Array=data.unlocked as Array;
            // Keep the full observed unlock count; only the first three are previews.
            ResultPaperSkin.text(board,"level-up-unlock-count",unlocked&&unlocked.length?unlocked.length+" NEW GEARS UNLOCKED":"CAREER PROGRESS",230,223,500,27,21,0x4c5355,"left",true);
            ClassicChrome.fill(board.graphics,227,259,506,123,[0xffffff,0xffffff,0xf3f5f1],[0,195,255],6);
            var count:int=unlocked?Math.min(3,unlocked.length):0;
            for(var i:int=0;i<count;i++)drawUnlock(board,227+506/count*(i+.5),305,unlocked[i],i,506/count-18);
            if(count==0) {
                ResultPaperSkin.text(board,"level-up-progress","LEVEL "+data.fromLevel+"  >  "+data.toLevel,251,274,458,39,28,0x267eaa,"center",true);
                var tip:TextField=ResultPaperSkin.text(board,"level-up-progress-tip","Al subir de nivel mejoras a tu héroe. Sigue jugando para desbloquear más equipo.",252,318,456,48,15,0x53616a);tip.wordWrap=true;LineupTypography.fit(tip,15,0x53616a,'center',false,12);
            }
            ResultPaperSkin.text(board,"level-up-rewards-heading","REWARDS",230,390,500,22,15,0x62727c,"left");
            rewardStrip.name="level-up-rewards";board.addChild(rewardStrip);ClassicChrome.bar(rewardStrip.graphics,227,416,506,100);
            var rewards:Array=[];
            if(int(data.skillPoints)>0)rewards.push({id:"SKILL POINT",n:int(data.skillPoints)});
            if(int(data.coins)>0)rewards.push({id:"COINS",n:int(data.coins)});
            if(int(data.maxEnergy)>0)rewards.push({id:"MAX ENERGY",n:int(data.maxEnergy)});
            for(i=0;i<rewards.length;i++){
                var item:Object=rewards[i],cw:Number=506/rewards.length,cx:Number=227+cw*(i+.5);
                ResultPaperSkin.icon(rewardStrip,item.id,cx,446,47);
                ResultPaperSkin.outlined(rewardStrip,"level-up-reward-"+i,number(item.n)+" "+item.id,cx-cw/2+6,477,cw-12,28,18,0xffe888,0x1d4b70,1);
            }
            if(rewards.length==0)ResultPaperSkin.text(rewardStrip,"level-up-no-rewards","NO NEW REWARDS",245,451,470,28,19,0xe4f5ff);
            ResultPaperSkin.text(board,"level-up-saved","Premios añadidos a tu cuenta. Sigue mejorando a tu héroe.",224,531,512,32,15,0x515b61);
            continueButton=new UIButton("CONTINUE",270,42,0x6eb52c,0x8ac744,0xe8ffb3);continueButton.name="LEVEL_CONTINUE";continueButton.x=345;continueButton.y=576;continueButton.addEventListener(MouseEvent.CLICK,onContinue);board.addChild(continueButton);
            startedAt=getTimer();header.scaleX=header.scaleY=.86;header.alpha=0;rewardStrip.alpha=0;
            addEventListener(Event.ENTER_FRAME,reveal);addEventListener(Event.REMOVED_FROM_STAGE,stopReveal);
        }
        private function reveal(e:Event):void {
            var elapsed:int=getTimer()-startedAt,t:Number=Math.min(1,elapsed/340),ease:Number=1-Math.pow(1-t,3);
            header.scaleX=header.scaleY=.86+.14*ease;header.alpha=Math.min(1,t*2.5);rewardStrip.alpha=Math.max(0,Math.min(1,(elapsed-80)/260));
            if(elapsed>=340)stopReveal();
        }
        private function stopReveal(e:Event=null):void {removeEventListener(Event.ENTER_FRAME,reveal);removeEventListener(Event.REMOVED_FROM_STAGE,stopReveal);header.scaleX=header.scaleY=header.alpha=rewardStrip.alpha=1;}
        private function number(n:int):String{return String(n).replace(/\B(?=(\d{3})+(?!\d))/g,",");}
        private function drawUnlock(board:Sprite,x:Number,y:Number,item:*,index:int,labelWidth:Number):void {
            var value:Object=item is String?{name:String(item)}:item,key:String=ObservedArtwork.gearKey(value),art:Sprite;
            if(key!="") {art=new ObservedArtwork(key,110,80);art.x=x-55;art.y=y-42;views.push(art);}
            else if(value.classicFamily){art=new BasicGearIcon(value);art.x=x;art.y=y-8;}
            else if(GearPieceArtwork.supports(String(value.name))) {art=new GearPieceArtwork(String(value.name),String(value.slot),75);art.x=x;art.y=y-8;}
            else if(value.slot=="bat"){art=new GearArtwork(String(value.name),80);art.rotation=42;art.x=x;art.y=y-8;}
            else {art=new BasicGearIcon(value);art.x=x;art.y=y-8;}
            art.name="level-up-gear-"+index;board.addChild(art);
            var label:TextField=ResultPaperSkin.text(board,"level-up-gear-name-"+index,String(value.name),x-labelWidth/2,y+34,labelWidth,40,15,0x3b464e);
            label.multiline=label.wordWrap=true;LineupTypography.fit(label,15,0x3b464e,'center',false,11);
        }
        private function onContinue(e:MouseEvent):void {e.stopPropagation();if(closed)return;closed=true;stopReveal();if(onClose!=null)onClose();}
        public function dispose():void {closed=true;stopReveal();onClose=null;if(continueButton){continueButton.removeEventListener(MouseEvent.CLICK,onContinue);continueButton.dispose();}for each(var v:Object in views)v.dispose();views=[];}
    }
}
