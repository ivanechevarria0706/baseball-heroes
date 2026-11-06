package com.bh.visual {
 import flash.display.*;import flash.geom.*;
 /** Reconstructed header and baseball skill badge. Immutable CPU-copied strips are shared. */
 public class LevelUpArtwork extends Sprite {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1026/level-up-header.png")] private static const Header:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1026/skill-badge.png")] private static const Skill:Class;
  private static var cache:Object={};
  public function LevelUpArtwork(key:String,w:Number,h:Number) {
   mouseEnabled=mouseChildren=false;name="level-up-art-"+key;
   if(!cache[key]) {
    var source:BitmapData=Bitmap(key=="header"?new Header():new Skill()).bitmapData;
    // The generated badge has faint alpha far outside its painted circle.
    // Use its measured pixel window so that padding cannot shrink the icon.
    var region:Rectangle=key=="header"?new Rectangle(0,0,source.width,source.height):new Rectangle(209,208,833,837),parts:Array=[];
    for(var y:int=0;y<region.height;y+=1024)for(var x:int=0;x<region.width;x+=1024) {
     var rect:Rectangle=new Rectangle(region.x+x,region.y+y,Math.min(1024,region.width-x),Math.min(1024,region.height-y));
     var pixels:BitmapData=new BitmapData(rect.width,rect.height,true,0);pixels.copyPixels(source,rect,new Point());parts.push({pixels:pixels,x:x,y:y});
    }
    cache[key]={parts:parts,w:region.width,h:region.height};source.dispose();
   }
   var image:Object=cache[key],scale:Number=Math.min(w/image.w,h/image.h);
   for each(var part:Object in image.parts) {
    var b:Bitmap=new Bitmap(part.pixels,"auto",true);b.scaleX=b.scaleY=scale;b.x=(w-image.w*scale)/2+part.x*scale;b.y=(h-image.h*scale)/2+part.y*scale;addChild(b);
   }
  }
 }
}
