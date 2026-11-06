package com.bh.visual {
 import flash.display.*;
 /** Reconstructed field illustration, displayed whole with shared immutable pixels. */
 public class TeamFieldArtwork extends Sprite {
  [Embed(source="../../../../assets/reference/v1034/team-field.png")] private static const Sheet:Class;
  private static var pixels:BitmapData;private var image:Bitmap;
  public function TeamFieldArtwork(w:Number,h:Number){name="team-field-art";mouseEnabled=mouseChildren=false;if(!pixels)pixels=Bitmap(new Sheet()).bitmapData;image=new Bitmap(pixels,"auto",true);image.scaleX=image.scaleY=Math.min(w/pixels.width,h/pixels.height);image.x=(w-image.width)/2;image.y=(h-image.height)/2;addChild(image);}
  public function dispose():void {if(image)image.bitmapData=null;}
 }
}
