package com.bh.ui {
    import flash.display.Sprite;
    import com.bh.audio.AudioManager;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    /** Oval actions and square tabs traced from the supplied LINE UP gameplay. */
    public class LineupButton extends Sprite {
        private var skin:Sprite=new Sprite();
        private var caption:TextField;
        private var title:String;
        private var widthPx:Number;
        private var heightPx:Number;
        private var color:uint;
        private var pill:Boolean;
        public function LineupButton(value:String,w:Number,h:Number,c:uint,oval:Boolean=false) {
            title=value;widthPx=w;heightPx=h;color=c;pill=oval;
            mouseChildren=false;buttonMode=true;useHandCursor=true;addChild(skin);
            caption=ClassicInventorySkin.text(this,title,8,Math.max(0,(h-26)/2),w-16,28,h>=37?18:12,c==0xcacaca?0x4b4b4b:c==0xe3ac36?0x725216:0x214929,"center");
            LineupTypography.apply(caption,h>=37?18:12,c==0xcacaca?0x4b4b4b:c==0xe3ac36?0x725216:0x214929,"center",h>=37);
            LineupTypography.fit(caption,h>=37?18:12,c==0xcacaca?0x4b4b4b:c==0xe3ac36?0x725216:0x214929,"center",h>=37);caption.y=Math.max(0,(h-caption.textHeight)/2-2);cacheAsBitmap=true;
            draw(false);
            addEventListener(MouseEvent.ROLL_OVER,over);addEventListener(MouseEvent.ROLL_OUT,out);
            addEventListener(MouseEvent.MOUSE_DOWN,down);addEventListener(MouseEvent.MOUSE_UP,over);
        }
        private function draw(hover:Boolean):void {
            skin.graphics.clear();ClassicChrome.button(skin.graphics,widthPx,heightPx,color,hover,false,pill);skin.y=0;
        }
        private function over(e:MouseEvent):void {draw(true);skin.y=0;caption.y=Math.max(0,(heightPx-caption.textHeight)/2-2);}
        private function out(e:MouseEvent):void {draw(false);skin.y=0;caption.y=Math.max(0,(heightPx-caption.textHeight)/2-2);}
        private function down(e:MouseEvent):void {AudioManager.playUiClick();draw(true);skin.y=1;caption.y=Math.max(0,(heightPx-caption.textHeight)/2-2)+1;}
        public function setLabel(value:String):void {title=value;caption.text=value;LineupTypography.fit(caption,heightPx>=37?18:12,color==0xcacaca?0x4b4b4b:0x214929,"center",heightPx>=37);}
        public function dispose():void {
            removeEventListener(MouseEvent.ROLL_OVER,over);removeEventListener(MouseEvent.ROLL_OUT,out);
            removeEventListener(MouseEvent.MOUSE_DOWN,down);removeEventListener(MouseEvent.MOUSE_UP,over);
        }
    }
}
