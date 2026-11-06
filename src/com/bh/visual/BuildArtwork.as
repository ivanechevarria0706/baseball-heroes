package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    /** Reconstructed BUILD sprites. CPU copies avoid offscreen render dependencies in Ruffle. */
    public class BuildArtwork extends Sprite {
        [Embed(source="../../../../assets/reference/v1021/build-categories.png")] private static const Categories:Class;
        [Embed(source="../../../../assets/reference/v1021/stadium-decorations.png")] private static const Props:Class;
        private static var cache:Object={},ready:Object={};
        private static const FRAMES:Object={"category_background":[0,65,84,392,297],"category_field":[0,486,113,342,267],"category_scoreboard":[0,889,121,366,254],"category_stand":[0,49,469,376,288],"category_fence":[0,472,504,378,233],"category_lights":[0,944,452,259,310],"category_decoration":[0,109,803,274,324],"category_banner":[0,477,851,355,228],"category_wall":[0,895,848,372,291],"prop_flag":[1,27,115,422,506],"prop_star":[1,461,181,379,446],"prop_ball":[1,888,225,366,402],"prop_trophy":[1,1286,151,430,476],"prop_fireworks":[1,1732,83,411,536]};
        public static function supports(key:String):Boolean{return FRAMES.hasOwnProperty(key);}
        private static function prepare(sheet:int):void {
            if(ready[sheet])return;
            var source:BitmapData=Bitmap(sheet==0?new Categories():new Props()).bitmapData;
            for(var key:String in FRAMES){
                var f:Array=FRAMES[key];if(f[0]!=sheet)continue;
                var pixels:BitmapData=new BitmapData(f[3],f[4],true,0);
                pixels.copyPixels(source,new Rectangle(f[1],f[2],f[3],f[4]),new Point());
                cache[key]=pixels;
            }
            source.dispose();ready[sheet]=true;
        }
        public function BuildArtwork(key:String,w:Number=64,h:Number=50){
            name="build-art-"+key;mouseEnabled=mouseChildren=false;if(!supports(key))return;
            prepare(int(FRAMES[key][0]));var picture:Bitmap=new Bitmap(cache[key],"auto",true);
            picture.scaleX=picture.scaleY=Math.min(w/picture.width,h/picture.height);
            picture.x=(w-picture.width)/2;picture.y=(h-picture.height)/2;addChild(picture);
        }
    }
}
