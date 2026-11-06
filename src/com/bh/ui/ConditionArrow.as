package com.bh.ui {
    import flash.display.*;import flash.events.MouseEvent;
    /** Shared reference palette: red up, yellow diagonal, green level, blue down, gray down. */
    public class ConditionArrow extends Sprite {
        private var action:Function,dead:Boolean=false;
        public function ConditionArrow(value:int,callback:Function=null){action=callback;mouseChildren=false;buttonMode=callback!=null;paint(graphics,11.5,13,value,23,26);addEventListener(MouseEvent.MOUSE_DOWN,stop);addEventListener(MouseEvent.CLICK,click);}
        private function stop(e:MouseEvent):void {e.stopPropagation();}
        private function click(e:MouseEvent):void {e.stopPropagation();if(!dead&&action!=null)action();}
        public static function color(value:int):uint {return [0x838e91,0x45bce2,0x87ce36,0xf3cf3b,0xe65360][Math.max(0,Math.min(4,value+2))];}
        public static function paint(g:Graphics,cx:Number,cy:Number,value:int,w:Number=23,h:Number=26):void {
            value=Math.max(-2,Math.min(2,value));g.lineStyle(1,0x879391);ClassicChrome.fill(g,cx-w/2,cy-h/2,w,h,[0x63706d,0x283a36,0x182b29],[0,100,255],4);g.lineStyle();
            var a:Number=-value*Math.PI/4,scale:Number=Math.min(w,h)/23,points:Array=[[-6,-3],[0,-3],[0,-6],[7,0],[0,6],[0,3],[-6,3]];
            g.lineStyle(.8,ClassicChrome.blend(color(value),0x122a2b,.4));g.beginFill(color(value));
            for(var i:int=0;i<points.length;i++){var x:Number=cx+(points[i][0]*Math.cos(a)-points[i][1]*Math.sin(a))*scale,y:Number=cy+(points[i][0]*Math.sin(a)+points[i][1]*Math.cos(a))*scale;if(i==0)g.moveTo(x,y);else g.lineTo(x,y);}g.lineTo(cx+(points[0][0]*Math.cos(a)-points[0][1]*Math.sin(a))*scale,cy+(points[0][0]*Math.sin(a)+points[0][1]*Math.cos(a))*scale);g.endFill();g.lineStyle();
        }
        public function dispose():void {if(dead)return;dead=true;action=null;removeEventListener(MouseEvent.MOUSE_DOWN,stop);removeEventListener(MouseEvent.CLICK,click);}
    }
}
