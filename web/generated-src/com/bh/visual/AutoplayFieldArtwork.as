package com.bh.visual {
 import flash.display.*;
 /** Shared native background; instances own only their display wrapper. */
 public class AutoplayFieldArtwork extends Sprite {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1046/autoplay-field.png")] private static const FieldImage:Class;
  private static var pixels:BitmapData;
  private var art:Bitmap;
  public function AutoplayFieldArtwork(w:Number,h:Number){if(!pixels)pixels=Bitmap(new FieldImage()).bitmapData;art=new Bitmap(pixels,PixelSnapping.AUTO,true);art.width=w;art.height=h;addChild(art);mouseEnabled=mouseChildren=false;}
  public function dispose():void{if(art&&art.parent)removeChild(art);art=null;}
 }
}
