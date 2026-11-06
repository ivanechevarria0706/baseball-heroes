package com.bh.ui {
    import flash.display.*;
    import flash.geom.Matrix;
    /** Native resource illustration; reconstructed, not extracted original art. */
    public class EnergyShopArtwork extends Sprite {
        public function EnergyShopArtwork(crate:Boolean=false) {
            mouseEnabled=mouseChildren=false;
            if(crate){
                can(-32,-12,.72,0x1c87ba);can(30,-12,.72,0x267fac);
                var g:Graphics=graphics;g.lineStyle(3,0x203e45);
                ClassicInventorySkin.gradient(g,-61,15,122,49,0x65b3d3,0x1e5c7d,6);
                g.lineStyle(2,0x123e53);g.moveTo(-59,27);g.lineTo(59,27);g.moveTo(-47,32);g.lineTo(-47,57);g.moveTo(47,32);g.lineTo(47,57);
                ClassicInventorySkin.text(this,"ENERGY",-49,32,98,23,16,0xe9f9ff,"center",true);
            }else can(0,0,1,0x61ac29);
            cacheAsBitmap=true;
        }
        private function can(px:Number,py:Number,size:Number,color:uint):void {
            var s:Sprite=new Sprite();s.x=px;s.y=py;s.scaleX=s.scaleY=size;addChild(s);
            var g:Graphics=s.graphics,m:Matrix=new Matrix();m.createGradientBox(63,125,0,-31,-68);
            g.lineStyle(3,0x203e3c);g.beginGradientFill(GradientType.LINEAR,[0x1e4c2c,color,0xb5ef5c,color],[1,1,1,1],[0,80,145,255],m);
            g.drawRoundRect(-31,-67,62,125,12);g.endFill();
            g.lineStyle(2,0x42585a);g.beginFill(0xc9d7d3);g.drawEllipse(-30,-71,60,12);g.endFill();
            g.lineStyle(1.5,0x7c8e8c);g.drawEllipse(-24,-68,48,7);g.beginFill(0x6c7c79);g.drawEllipse(-8,-68,16,5);g.endFill();
            g.lineStyle(2,0x617776);g.beginFill(0xd8e4de);g.drawEllipse(-29,52,58,9);g.endFill();
            g.lineStyle();g.beginFill(0x163e2b,.6);g.moveTo(-30,-35);g.lineTo(31,-50);g.lineTo(31,30);g.lineTo(-30,43);g.lineTo(-30,-35);g.endFill();
            var bolt:Sprite=ClassicInventorySkin.icon(s,"energy",-17,-41,1.18);bolt.rotation=9;
            ClassicInventorySkin.text(s,"HERO",-28,8,56,21,15,0xf4ffbc,"center",true);
            ClassicInventorySkin.text(s,"ENERGY",-28,29,56,18,10,0xe6ffc2,"center",true);
            g.beginFill(0xffffff,.24);g.drawRoundRect(-25,-54,6,91,5);g.endFill();
        }
    }
}
