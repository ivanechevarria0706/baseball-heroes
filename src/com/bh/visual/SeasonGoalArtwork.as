package com.bh.visual {
 import flash.display.*;import flash.geom.*;
 /** Reconstructed pointing pose; immutable CPU-copied strips, shared across screen entries. */
 public class SeasonGoalArtwork extends Sprite {
  [Embed(source="../../../../assets/reference/v1023/goal-coach.png")] private static const Sheet:Class;
  private static var parts:Array=[],sourceW:int,sourceH:int;
  public function SeasonGoalArtwork(w:Number=215,h:Number=224) {
   mouseEnabled=mouseChildren=false;
   if(!parts.length){var source:BitmapData=Bitmap(new Sheet()).bitmapData;sourceW=source.width;sourceH=source.height;
    for(var y:int=0;y<sourceH;y+=1024)for(var x:int=0;x<sourceW;x+=1024){var r:Rectangle=new Rectangle(x,y,Math.min(1024,sourceW-x),Math.min(1024,sourceH-y)),p:BitmapData=new BitmapData(r.width,r.height,true,0);p.copyPixels(source,r,new Point());parts.push({pixels:p,x:x,y:y});}source.dispose();
   }
   var s:Number=Math.min(w/sourceW,h/sourceH);
   for each(var a:Object in parts){var b:Bitmap=new Bitmap(a.pixels,"auto",true);b.scaleX=b.scaleY=s;b.x=(w-sourceW*s)/2+a.x*s;b.y=(h-sourceH*s)/2+a.y*s;addChild(b);}
  }
 }
}
