package com.bh.ui {
    import flash.display.*;import flash.events.MouseEvent;import flash.text.TextField;
    /** Shop-only blue tabs and red close control; other screens keep their skin. */
    public class EquipmentChromeButton extends Sprite {
        private var skin:Sprite=new Sprite(),caption:TextField;
        private var w:Number,h:Number,kind:String,selected:Boolean=false,hover:Boolean=false,captionY:Number;
        public function EquipmentChromeButton(value:String,width:Number,height:Number,style:String='tab') {
            w=width;h=height;kind=style;mouseChildren=false;buttonMode=useHandCursor=true;
            addChild(skin);caption=ClassicInventorySkin.text(this,value,3,0,w-6,h,kind=='close'?24:kind=='point'?16:h>=33?18:12,kind=='point'?0x395465:0xffffff,'center',kind!='point');
            caption.y=Math.max(0,(h-caption.textHeight)/2-2);captionY=caption.y;paint();
            addEventListener(MouseEvent.ROLL_OVER,onOver);addEventListener(MouseEvent.ROLL_OUT,onOut);addEventListener(MouseEvent.MOUSE_DOWN,onDown);addEventListener(MouseEvent.MOUSE_UP,onUp);
        }
        public function setSelected(value:Boolean):void {if(value==selected)return;selected=value;paint();}
        public function get isSelected():Boolean {return selected;}
        private function paint():void {
            var g:Graphics=skin.graphics;g.clear();
            if(kind=='close') {
                g.lineStyle(2,0xf3eeee);ClassicInventorySkin.gradient(g,1,0,w-2,h,hover?0xf07469:0xd95750,0x942e35,h);g.lineStyle(1,0x472d36);g.drawEllipse(0,0,w,h);g.lineStyle();return;
            }
            if(kind=='point') {g.lineStyle(1,0x667e88);ClassicInventorySkin.gradient(g,0,0,w,h,hover?0xffffff:0xeef3f2,0xaabbbc,h);g.lineStyle();return;}
            ClassicChrome.bar(g,0,0,w,h,selected||hover);

        }
        private function onOver(e:MouseEvent):void {hover=true;skin.y=0;caption.y=captionY;paint();}
        private function onOut(e:MouseEvent):void {hover=false;skin.y=0;caption.y=captionY;paint();}
        private function onDown(e:MouseEvent):void {skin.y=1;caption.y=captionY+1;}
        private function onUp(e:MouseEvent):void {skin.y=0;caption.y=captionY;}
        public function dispose():void {removeEventListener(MouseEvent.ROLL_OVER,onOver);removeEventListener(MouseEvent.ROLL_OUT,onOut);removeEventListener(MouseEvent.MOUSE_DOWN,onDown);removeEventListener(MouseEvent.MOUSE_UP,onUp);}
    }
}
