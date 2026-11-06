package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    /** Existing pixels recovered from the supplied 11:40 inventory sequence. */
    public class InventoryArtwork extends Sprite {
        [Embed(source="../../../../assets/reference/v1019/inventory-atlas.png")] private static const Sheet:Class;
        private static var atlas:BitmapData,cache:Object={};
        private static const FRAMES:Object={"case":[4,4,46,29],"batter":[260,4,58,34],"mystery":[516,4,58,39],"key":[772,4,77,63],"rookie":[4,132,173,120],"single_a":[260,132,95,67],"double_a":[516,132,190,120],"triple_a":[772,132,189,120],"majors":[4,260,190,120]};
        public static function supports(key:String):Boolean{return FRAMES.hasOwnProperty(key);}
        public function InventoryArtwork(key:String,w:Number=36,h:Number=33){
            name="inventory-art-"+key;mouseEnabled=mouseChildren=false;if(!supports(key))return;
            if(!atlas)atlas=Bitmap(new Sheet()).bitmapData;
            if(!cache[key]){var f:Array=FRAMES[key],p:BitmapData=new BitmapData(f[2],f[3],true,0);p.copyPixels(atlas,new Rectangle(f[0],f[1],f[2],f[3]),new Point());cache[key]=p;}
            var im:Bitmap=new Bitmap(cache[key],"auto",true);im.scaleX=im.scaleY=Math.min(w/im.width,h/im.height);im.x=(w-im.width)/2;im.y=(h-im.height)/2;addChild(im);
        }
    }
}
