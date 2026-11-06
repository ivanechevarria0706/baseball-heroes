package com.bh.ui {
    import flash.display.*;
    import com.bh.visual.InventoryArtwork;
    import com.bh.visual.LeagueBadgeView;
    /** Existing energy/key art, plus a native letter carrying the AA emblem. */
    public class SocialGiftArtwork extends Sprite {
        private var emblem:LeagueBadgeView;
        public function SocialGiftArtwork(kind:String,w:Number,h:Number) {
            mouseEnabled=mouseChildren=false;name="social-gift-art-"+kind;
            if(kind=="energy") {var can:EnergyShopArtwork=new EnergyShopArtwork();can.scaleX=can.scaleY=Math.min(w/70,h/145);can.x=w/2;can.y=h/2;addChild(can);return;}
            if(kind=="key") {var key:InventoryArtwork=new InventoryArtwork("key",w,h);addChild(key);return;}
            var paper:Sprite=new Sprite(),g:Graphics=paper.graphics;paper.scaleX=paper.scaleY=Math.min(w/160,h/140);paper.x=(w-160*paper.scaleX)/2;paper.y=(h-140*paper.scaleY)/2;addChild(paper);
            g.lineStyle(3,0x553b2d);ClassicInventorySkin.gradient(g,20,5,121,127,0xfff8df,0xe8c288,7);
            g.lineStyle(1,0xffffff);g.moveTo(25,10);g.lineTo(134,10);g.lineStyle(3,0x6b5140);g.beginFill(0xffebbc);g.moveTo(116,5);g.lineTo(141,30);g.lineTo(116,30);g.lineTo(116,5);g.endFill();
            g.lineStyle(2,0x9b8b6f);g.moveTo(40,94);g.lineTo(121,94);g.moveTo(40,106);g.lineTo(113,106);g.moveTo(40,118);g.lineTo(97,118);g.lineStyle();
            emblem=new LeagueBadgeView(2,"AA",69);emblem.x=42;emblem.y=16;paper.addChild(emblem);
        }
        public function dispose():void {if(emblem){emblem.dispose();emblem=null;}}
    }
}
