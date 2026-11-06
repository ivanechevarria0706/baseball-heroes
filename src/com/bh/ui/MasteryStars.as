package com.bh.ui {
    import flash.display.Sprite;
    public class MasteryStars extends Sprite {
        public function MasteryStars(stars:int,width:Number=360):void {
            mouseEnabled=false;mouseChildren=false;
            for(var i:int=0;i<12;i++) {
                var cx:Number=width*(i+.5)/12,cy:Number=10,r:Number=Math.min(10,width/30);
                graphics.lineStyle(1.4,i<stars?0x14678a:0x8e999e);
                graphics.beginFill(i<stars?0x5bd6f6:0xb1bcc1);
                for(var j:int=0;j<10;j++) {
                    var angle:Number=-Math.PI/2+j*Math.PI/5,rr:Number=j%2?r*.46:r;
                    var x:Number=cx+Math.cos(angle)*rr,y:Number=cy+Math.sin(angle)*rr;
                    if(j==0)graphics.moveTo(x,y);else graphics.lineTo(x,y);
                }
                graphics.lineTo(cx,cy-r);graphics.endFill();
            }
            graphics.lineStyle();
        }
    }
}
