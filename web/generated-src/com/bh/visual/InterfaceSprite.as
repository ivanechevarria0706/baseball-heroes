package com.bh.visual {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    /** Illustrated interface pixels recovered from the supplied footage/sheets.
     * Shared immutable frames: no loaders, per-frame allocation or update loop. */
    public class InterfaceSprite extends Sprite {
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1018/interface-atlas.png")]
        private static const Sheet:Class;
        private static var atlas:BitmapData;
        private static var frames:Object={energy:[4,4,26,31],coin:[260,4,41,34],cash:[516,4,31,27],scout:[772,4,80,63],build:[4,132,86,60],chest:[260,132,95,69],play:[516,132,164,78],helmet:[772,132,44,40],modes:[4,260,139,120],batter:[260,260,83,50],shop:[516,260,44,40],gear_glove:[772,260,27,41],gear_shoes:[4,388,45,25],gear_belt:[260,388,44,18],gear_goggles:[516,388,47,22],gear_bat:[772,388,53,38],gear_helmet:[4,516,44,40],portrait0:[260,516,133,120],portrait1:[516,516,131,120],portrait2:[772,516,117,120],portrait3:[4,644,136,118],portrait4:[260,644,125,120],portrait5:[516,644,133,120],portrait6:[772,644,117,120],portrait7:[4,772,113,120],portrait8:[260,772,105,120],portrait9:[516,772,108,120],portrait10:[772,772,123,120],portrait11:[4,900,107,120],portrait12:[260,900,103,120],portrait13:[516,900,109,120],portrait14:[772,900,102,120],portrait15:[4,1028,113,120],portrait16:[260,1028,103,120],portrait17:[516,1028,100,120],portrait18:[772,1028,105,120],portrait19:[4,1156,107,120],portrait20:[260,1156,108,120],portrait21:[516,1156,100,120],portrait22:[772,1156,107,120],portrait23:[4,1284,106,120],portrait24:[260,1284,101,120],portrait25:[516,1284,103,120],portrait26:[772,1284,98,120],portrait27:[4,1412,107,120],portrait28:[260,1412,103,120],portrait29:[516,1412,93,120],portrait30:[772,1412,97,120],portrait31:[4,1540,97,120]};
        private static var cache:Object={};
        public static function supports(key:String):Boolean{return frames.hasOwnProperty(key);}
        public function InterfaceSprite(key:String,w:Number=36,h:Number=33,stretch:Boolean=false){
            name="interface-sprite-"+key;mouseEnabled=mouseChildren=false;
            if(!supports(key))return;
            if(!atlas)atlas=Bitmap(new Sheet()).bitmapData;
            if(!cache[key]){
                var f:Array=frames[key],p:BitmapData=new BitmapData(int(f[2]),int(f[3]),true,0);
                p.copyPixels(atlas,new Rectangle(f[0],f[1],f[2],f[3]),new Point());cache[key]=p;
            }
            var image:Bitmap=new Bitmap(cache[key],"auto",true);
            if(stretch){image.width=w;image.height=h;}
            else {image.scaleX=image.scaleY=Math.min(w/image.width,h/image.height);image.x=(w-image.width)/2;image.y=(h-image.height)/2;}
            addChild(image);
        }
    }
}
