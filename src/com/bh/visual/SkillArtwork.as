package com.bh.visual {
 import flash.display.*;import flash.geom.*;
 /** Reconstructed skill emblems: immutable native pixel windows, cached once. */
 public class SkillArtwork extends Sprite {
  [Embed(source="../../../../assets/reference/v1033/skills.png")] private static const Sheet:Class;
  private static const FRAMES:Object={"BATTING_EYE":[39,107,300,245],"POWER_HITTER":[374,63,325,301],"CLUTCH":[744,85,324,270],"SPEEDSTER":[1086,65,334,292],"PATIENT_HITTER":[41,424,302,260],"LINE_DRIVE":[362,456,362,185],"TEAM_SPIRIT":[735,387,342,299],"LUCKY_SWING":[1109,406,313,278],"CONTACT_MASTER":[33,710,329,312],"SLUGGER":[362,707,362,313],"BASE_RUNNER":[739,752,345,255],"DEFENSE_CAPTAIN":[1122,705,275,318]};
  private static var cache:Object,prepared:Boolean=false;
  private static function prepare():void {
   if(prepared)return;cache={};var source:BitmapData=Bitmap(new Sheet()).bitmapData;
   for(var key:String in FRAMES){var f:Array=FRAMES[key],pixels:BitmapData=new BitmapData(f[2],f[3],true,0);pixels.copyPixels(source,new Rectangle(f[0],f[1],f[2],f[3]),new Point());cache[key]={normal:pixels,locked:grayPreview(pixels)};}
   source.dispose();prepared=true;
  }
  // Cached neutral display state, using native channel copies rather than GPU filters.
  private static function grayPreview(source:BitmapData):BitmapData {
   var gray:BitmapData=source.clone();gray.copyChannel(source,source.rect,new Point(),BitmapDataChannel.GREEN,BitmapDataChannel.RED);gray.copyChannel(source,source.rect,new Point(),BitmapDataChannel.GREEN,BitmapDataChannel.BLUE);return gray;
  }
  public static function supports(key:String):Boolean{return FRAMES.hasOwnProperty(key);}
  public function SkillArtwork(key:String,w:Number=64,h:Number=64,locked:Boolean=false){name="skill-art-"+key;mouseEnabled=mouseChildren=false;if(!supports(key))return;prepare();var pixels:BitmapData=locked?cache[key].locked:cache[key].normal,image:Bitmap=new Bitmap(pixels,"auto",true),s:Number=Math.min(w/pixels.width,h/pixels.height);image.scaleX=image.scaleY=s;image.x=(w-pixels.width*s)/2;image.y=(h-pixels.height*s)/2;addChild(image);}
  public function dispose():void {for(var i:int=0;i<numChildren;i++)Bitmap(getChildAt(i)).bitmapData=null;}
 }
}
