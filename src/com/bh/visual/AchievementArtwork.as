package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    /** Reconstructed achievement cups and mission banner; prepared once with CPU pixel copies. */
    public class AchievementArtwork extends Sprite {
        [Embed(source="../../../../assets/reference/v1022/achievement-atlas.png")] private static const Cups:Class;
        [Embed(source="../../../../assets/reference/v1022/mission-complete.png")] private static const Banner:Class;
        private static var cache:Object={},ready:Object={};
        private static const FRAMES:Object={"bronze":[0,31,94,482,362],"silver":[0,535,94,466,362],"gold":[0,1023,94,481,362],"diamond":[0,29,563,486,367],"locked":[0,535,560,466,367],"skill":[0,1081,540,381,370],"mission":[1,91,75,2083,597]};
        public static function supports(key:String):Boolean{return FRAMES.hasOwnProperty(key);}
        private static function prepare(sheet:int):void {
            if(ready[sheet])return;
            var source:BitmapData=Bitmap(sheet==0?new Cups():new Banner()).bitmapData;
            for(var key:String in FRAMES){var f:Array=FRAMES[key];if(f[0]!=sheet)continue;
                var parts:Array=[];
                // The banner may exceed conservative browser texture limits.
                for(var left:int=0;left<f[3];left+=1024){
                    var width:int=Math.min(1024,f[3]-left),pixels:BitmapData=new BitmapData(width,f[4],true,0);
                    pixels.copyPixels(source,new Rectangle(f[1]+left,f[2],width,f[4]),new Point());parts.push({pixels:pixels,x:left});
                }
                cache[key]=parts;
            }
            source.dispose();ready[sheet]=true;
        }
        public function AchievementArtwork(key:String,w:Number,h:Number){
            name="achievement-art-"+key;mouseEnabled=mouseChildren=false;if(!supports(key))return;
            var frame:Array=FRAMES[key];prepare(int(frame[0]));var scale:Number=Math.min(w/frame[3],h/frame[4]);
            for each(var part:Object in cache[key]){var picture:Bitmap=new Bitmap(part.pixels,"auto",true);
                picture.scaleX=picture.scaleY=scale;picture.x=(w-frame[3]*scale)/2+part.x*scale;picture.y=(h-frame[4]*scale)/2;addChild(picture);}
        }
    }
}
