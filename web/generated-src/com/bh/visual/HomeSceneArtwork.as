package com.bh.visual {
 import flash.display.*;import flash.geom.*;
 /** Reconstructed HOME props. Immutable native pixel windows, prepared once. */
 public class HomeSceneArtwork extends Sprite {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1030/equipment.png")] private static const Equipment:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1030/duffel.png")] private static const Duffel:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1030/mission.png")] private static const Mission:Class;
  private static const FRAMES:Object={"bat": [0, 465, 123, 844, 135], "cleat": [0, 153, 306, 356, 224], "bat2": [0, 1030, 391, 651, 120], "ball": [0, 184, 605, 206, 206], "glove": [0, 695, 617, 307, 178], "mitt": [0, 1254, 550, 391, 276], "duffel": [1, 41, 26, 1499, 983], "mission": [2, 51, 62, 1070, 1228]};
  private static var cache:Object={},ready:Object={};
  private static function prepare(sheet:int):void {
   if(ready[sheet])return;var source:BitmapData=Bitmap(sheet==0?new Equipment():sheet==1?new Duffel():new Mission()).bitmapData;
   for(var key:String in FRAMES){var f:Array=FRAMES[key];if(f[0]!=sheet)continue;var parts:Array=[];
    for(var y:int=0;y<f[4];y+=1024)for(var x:int=0;x<f[3];x+=1024){var pixels:BitmapData=new BitmapData(Math.min(1024,f[3]-x),Math.min(1024,f[4]-y),true,0);pixels.copyPixels(source,new Rectangle(f[1]+x,f[2]+y,pixels.width,pixels.height),new Point());parts.push({pixels:pixels,x:x,y:y});}cache[key]=parts;
   }source.dispose();ready[sheet]=true;
  }
  public function HomeSceneArtwork(key:String,w:Number,h:Number){name="home-scene-"+key;mouseEnabled=mouseChildren=false;var f:Array=FRAMES[key];if(!f)return;prepare(int(f[0]));var scale:Number=Math.min(w/f[3],h/f[4]);
   for each(var part:Object in cache[key]){var bitmap:Bitmap=new Bitmap(part.pixels,"auto",true);bitmap.scaleX=bitmap.scaleY=scale;bitmap.x=(w-f[3]*scale)/2+part.x*scale;bitmap.y=(h-f[4]*scale)/2+part.y*scale;addChild(bitmap);}
  }
  public function dispose():void {for(var i:int=0;i<numChildren;i++)Bitmap(getChildAt(i)).bitmapData=null;}
 }
}
