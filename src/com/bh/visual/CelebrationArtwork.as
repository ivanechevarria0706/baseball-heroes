package com.bh.visual {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    /** Complete original illustrations, decoded once and reused between plays. */
    public class CelebrationArtwork extends Sprite {
        [Embed(source="../../../../assets/reference/celebrations/celebration_01.png")] private static const GrandSlam:Class;
        [Embed(source="../../../../assets/reference/celebrations/celebration_02.png")] private static const DoubleHit:Class;
        [Embed(source="../../../../assets/reference/celebrations/celebration_03.png")] private static const TripleHit:Class;
        [Embed(source="../../../../assets/reference/celebrations/celebration_04.png")] private static const HomeRun:Class;
        private static const CLASSES:Array=[GrandSlam,DoubleHit,TripleHit,HomeRun];
        private static var sources:Array=[];
        private var bitmap:Bitmap;
        public static function warm():void {
            for(var i:int=0;i<CLASSES.length;i++)if(!sources[i]){var type:Class=CLASSES[i];sources[i]=Bitmap(new type()).bitmapData;}
        }
        public function CelebrationArtwork(index:int,w:Number,h:Number) {
            super();warm();mouseEnabled=mouseChildren=false;
            index=Math.max(1,Math.min(4,index));name="celebration-art-"+index;
            var pixels:BitmapData=sources[index-1],scale:Number=Math.min(w/pixels.width,h/pixels.height);
            bitmap=new Bitmap(pixels,"auto",true);bitmap.scaleX=bitmap.scaleY=scale;
            bitmap.x=(w-pixels.width*scale)*.5;bitmap.y=(h-pixels.height*scale)*.5;addChild(bitmap);
        }
        public function dispose():void {if(bitmap){bitmap.bitmapData=null;if(bitmap.parent)bitmap.parent.removeChild(bitmap);bitmap=null;}}
    }
}
