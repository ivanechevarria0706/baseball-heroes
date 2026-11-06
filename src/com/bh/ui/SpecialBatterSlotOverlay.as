package com.bh.ui {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import com.bh.model.GameData;

    public class SpecialBatterSlotOverlay extends Sprite {
        private var onClose:Function,onShop:Function,onUpdate:Function;
        private var buttons:Array=[];
        private var types:Boolean=false;
        private var message:String="";
        public function SpecialBatterSlotOverlay(closeCallback:Function,shopCallback:Function,updatedCallback:Function=null) {
            onClose=closeCallback;onShop=shopCallback;onUpdate=updatedCallback;draw();
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff):void {
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("Arial",size,color,true);
            t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.multiline=true;t.wordWrap=true;t.selectable=false;t.mouseEnabled=false;addChild(t);
        }
        private function button(value:String,name:String,x:Number,y:Number,w:Number,h:Number,callback:Function,color:uint=0x3a78a1):void {
            var b:UIButton=new UIButton(value,w,h,color,0x5591ae,0xa5d4ee);b.name=name;b.x=x;b.y=y;
            b.addEventListener(MouseEvent.CLICK,callback);addChild(b);buttons.push({view:b,callback:callback});
        }
        private function clear():void {
            for each(var entry:Object in buttons){entry.view.removeEventListener(MouseEvent.CLICK,entry.callback);entry.view.dispose();}
            buttons=[];while(numChildren)removeChildAt(0);graphics.clear();
        }
        private function draw():void {
            clear();
            graphics.beginFill(0x043754,.98);graphics.lineStyle(3,0x9ad6ef);graphics.drawRoundRect(-185,-44,370,395,12,12);graphics.endFill();graphics.lineStyle();
            graphics.beginFill(0x127cb5);graphics.drawRoundRect(-179,-38,358,41,9,9);graphics.endFill();
            label("SPECIAL BATTER SLOT",-168,-31,300,28,21);
            button("X","slots_close",146,-33,28,27,closeClick,0xb9443b);
            button("SLOTS","slots_tab",-163,13,102,26,slotsClick);
            button("TYPES","types_tab",-51,13,102,26,typesClick);
            if(!types) {
                for(var i:int=1;i<=5;i++) {
                    var yy:Number=48+(i-1)*45;
                    graphics.beginFill(0x09679c);graphics.drawRoundRect(-163,yy,326,39,5,5);graphics.endFill();
                    label(String(i),-150,yy+7,28,22,18,0xb9e4f0);
                    if(i<=GameData.specialSlotsUnlocked)label("UNLOCKED",-105,yy+10,240,20,13,0xffdd69);
                    else {
                        var cost:Object=GameData.specialSlotCost(i);
                        var price:String=cost.coins>0?"C "+String(cost.coins).replace(/\B(?=(\d{3})+(?!\d))/g,","):"$ "+cost.cash;
                        if(i==GameData.specialSlotsUnlocked+1)button(price,"slot_unlock_"+i,-91,yy+5,178,29,buyClick,cost.coins>0?0xbd8d23:0x66a42f);
                        else label("LOCKED   "+price,-104,yy+11,240,21,12,0x88b7cb);
                    }
                }
            } else {
                label("CLASSES: S > A > B > C",-150,48,310,24,13,0xffdf74);
                var grades:Array=["HERO","ELITE","RARE","A"];
                for(var j:int=0;j<grades.length;j++) {
                    var grade:String=grades[j];var y:Number=78+j*48;
                    graphics.beginFill(0x09679c);graphics.drawRoundRect(-163,y,326,43,5,5);graphics.endFill();
                    label(grade,-150,y+6,88,22,13,0xffdf74);
                    label("Probabilidad de habilidad "+Math.round(GameData.specialAbilityChance({grade:grade})*100)+"%",-58,y+7,214,33,12);
                }
            }
            label(message!=""?message:"C "+GameData.coins+"     $ "+GameData.cash,-162,281,330,30,11,0xd5e7ec);
            button("BATTER SHOP","slots_shop",-81,314,162,28,shopClick);
        }
        private function buyClick(e:MouseEvent):void {
            var result:String=GameData.unlockNextSpecialSlot();
            message=result=="OK"?"Slot unlocked!":result=="COINS"?"Not enough Coins.":result=="CASH"?"Not enough Cash.":"All slots unlocked.";
            if(result=="OK"&&onUpdate!=null)onUpdate();draw();
        }
        private function slotsClick(e:MouseEvent):void {types=false;message="";draw();}
        private function typesClick(e:MouseEvent):void {types=true;message="";draw();}
        private function closeClick(e:MouseEvent):void {if(onClose!=null)onClose();}
        private function shopClick(e:MouseEvent):void {if(onShop!=null)onShop();}
        public function dispose():void {clear();}
    }
}
