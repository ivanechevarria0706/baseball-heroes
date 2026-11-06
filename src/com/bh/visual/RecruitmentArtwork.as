package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.ByteArray;
 /** Original recruitment sprites. Native alpha is preserved; immutable crops are shared. */
 public class RecruitmentArtwork extends Sprite {
  [Embed(source="../../../../assets/sprites/v1040/scout.png")] private static const Scout:Class;
  [Embed(source="../../../../assets/sprites/v1040/kit-clean.png")] private static const Kit:Class;
  [Embed(source="../../../../assets/sprites/v1040/frames.json",mimeType="application/octet-stream")] private static const Data:Class;
  private static var frames:Object,sheets:Object={},cache:Object={};private var image:Bitmap;
  public function RecruitmentArtwork(key:String,w:Number=70,h:Number=60){
   name="recruitment-"+key;mouseEnabled=mouseChildren=false;var pixels:BitmapData=crop(key);if(!pixels)return;
   image=new Bitmap(pixels,"auto",true);image.scaleX=image.scaleY=Math.min(w/image.width,h/image.height);image.x=(w-image.width)/2;image.y=(h-image.height)/2;addChild(image);
  }
  private static function crop(key:String):BitmapData {
   if(!frames){var bytes:ByteArray=new Data() as ByteArray;frames=JSON.parse(bytes.readUTFBytes(bytes.length));}var f:Object=frames[key];if(!f)return null;
   if(!cache[key]){if(!sheets[f.sheet])sheets[f.sheet]=Bitmap(f.sheet=="scout.png"?new Scout():new Kit()).bitmapData;var rect:Array=f.rect,b:BitmapData=new BitmapData(rect[2],rect[3],true,0);b.copyPixels(sheets[f.sheet],new Rectangle(rect[0],rect[1],rect[2],rect[3]),new Point());cache[key]=b;}return cache[key];
  }
  public static function coachBitmap():Bitmap {
   var bitmap:Bitmap=new Bitmap(crop("coach-read").clone(),"auto",true);bitmap.name="recruitment-coach-bitmap";return bitmap;
  }
  public function dispose():void{if(image)image.bitmapData=null;}
 }
}
