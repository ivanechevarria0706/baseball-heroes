package com.bh.game {
    import flash.display.Graphics;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    /** Shared leather, curved seams and stitches at pitch and cinematic scales. */
    public class BaseballArt {
        public static function draw(g:Graphics,r:Number):void {
            g.clear();var m:Matrix=new Matrix();m.createGradientBox(r*2.6,r*2.6,0,-r*1.65,-r*1.65);
            g.lineStyle(Math.max(.6,r*.04),0x6c7a84,.9);
            g.beginGradientFill(GradientType.RADIAL,[0xffffff,0xf4f1e7,0xaab9c2],[1,1,1],[0,180,255],m);
            g.drawCircle(0,0,r);g.endFill();
            for(var side:int=-1;side<=1;side+=2){
                g.lineStyle(Math.max(.7,r*.065),0xb64450,.95);
                g.moveTo(side*r*.56,-r*.79);g.curveTo(-side*r*.12,0,side*r*.56,r*.79);
                for(var i:int=0;i<6;i++){
                    var t:Number=(i+.5)/6;
                    var sy:Number=(-.79+1.58*t)*r;
                    var sx:Number=side*r*(.56*(1-t)*(1-t)-.24*(1-t)*t+.56*t*t);
                    g.lineStyle(Math.max(.5,r*.035),0xab3947,.9);
                    g.moveTo(sx-r*.075,sy-r*.035);g.lineTo(sx+r*.075,sy+r*.035);
                }
            }
            g.lineStyle();g.beginFill(0xffffff,.4);g.drawEllipse(-r*.52,-r*.65,r*.55,r*.27);g.endFill();
        }
    }
}
