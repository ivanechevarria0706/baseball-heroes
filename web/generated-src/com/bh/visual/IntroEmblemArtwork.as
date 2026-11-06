package com.bh.visual {
 import flash.display.*;import flash.geom.*;
 /** One reconstructed transparent emblem; shared strips avoid over-wide textures. */
 public class IntroEmblemArtwork extends Sprite {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1025/intro-emblem.png")] private static const Sheet:Class;
  private static var parts:Array=[],sourceW:int,sourceH:int;
  public function IntroEmblemArtwork(w:Number=474,h:Number=330) {
   mouseEnabled=mouseChildren=false;
   if(!parts.length){var source:BitmapData=Bitmap(new Sheet()).bitmapData;sourceW=source.width;sourceH=source.height;for(var y:int=0;y<sourceH;y+=1024)for(var x:int=0;x<sourceW;x+=1024){var r:Rectangle=new Rectangle(x,y,Math.min(1024,sourceW-x),Math.min(1024,sourceH-y)),pixels:BitmapData=new BitmapData(r.width,r.height,true,0);pixels.copyPixels(source,r,new Point());parts.push({pixels:pixels,x:x,y:y});}source.dispose();}
   var s:Number=Math.min(w/sourceW,h/sourceH);for each(var part:Object in parts){var b:Bitmap=new Bitmap(part.pixels,"auto",true);b.scaleX=b.scaleY=s;b.x=(w-sourceW*s)/2+part.x*s;b.y=(h-sourceH*s)/2+part.y*s;addChild(b);}
  }
 }
}
