package com.bh.ui {
    import flash.display.Sprite;
    import com.bh.audio.AudioManager;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    /** Caption remains child zero for existing callers that update its text. */
    public class ClassicActionButton extends Sprite {
        private var w:Number,h:Number,color:uint,label:TextField,over:Boolean=false,pressed:Boolean=false;
        public function ClassicActionButton(value:String,width:Number,height:Number,c:uint) {
            w=width;h=height;color=c;mouseChildren=false;buttonMode=useHandCursor=true;
            var size:int=h<22?8:h>=43?16:12,lines:Boolean=value.indexOf("\n")>=0;
            var ink:uint=c==0xdddddd||c==0xcacaca?0x314450:c==0xe1a926?0x574316:0xffffff;
            label=ClassicInventorySkin.text(this,value,6,3,w-12,h-5,size,ink,"center",c!=0xdddddd&&c!=0xcacaca);
            // Only an explicit line break should split a caption such as PLAY\nBALL.
            label.multiline=label.wordWrap=lines;
            LineupTypography.fit(label,size,ink,"center");center();paint();
            addEventListener(MouseEvent.ROLL_OVER,onOver);addEventListener(MouseEvent.ROLL_OUT,onOut);addEventListener(MouseEvent.MOUSE_DOWN,onDown);addEventListener(MouseEvent.MOUSE_UP,onUp);
        }
        private function center():void {label.y=Math.max(0,(h-label.textHeight)/2-2)+(pressed?1.5:0);}
        private function paint():void {graphics.clear();ClassicChrome.button(graphics,w,h,color,over,pressed,h<=40);center();}
        private function onOver(e:MouseEvent):void {if(!mouseEnabled)return;over=true;paint();}
        private function onOut(e:MouseEvent):void {over=pressed=false;paint();}
        private function onDown(e:MouseEvent):void {if(!mouseEnabled)return;AudioManager.playUiClick();pressed=true;paint();}
        private function onUp(e:MouseEvent):void {pressed=false;paint();}
        public function dispose():void {removeEventListener(MouseEvent.ROLL_OVER,onOver);removeEventListener(MouseEvent.ROLL_OUT,onOut);removeEventListener(MouseEvent.MOUSE_DOWN,onDown);removeEventListener(MouseEvent.MOUSE_UP,onUp);}
    }
}
