package com.bh.visual {
 import flash.display.BitmapData;
 /** One bulk read/write per cached pose; preserve the original selection and shading. */
 public class UniformTint {
  private static var redColor:uint,blueColor:uint,redTones:Vector.<uint>,blueTones:Vector.<uint>;
  private static function tones(color:uint,red:Boolean):Vector.<uint> {
   if(red&&redTones&&redColor==color)return redTones;
   if(!red&&blueTones&&blueColor==color)return blueTones;
   var values:Vector.<uint>=new Vector.<uint>(766,true),tr:int=(color>>16)&255,tg:int=(color>>8)&255,tb:int=color&255;
   // Shading only depends on the channel sum. Two bounded lookup tables
   // replace repeated division and six clamp calls for every selected pixel.
   for(var sum:int=0;sum<766;sum++){var d:Number=sum/3-(red?85:65);var nr:int=Math.max(0,Math.min(255,tr+d)),ng:int=Math.max(0,Math.min(255,tg+d)),nb:int=Math.max(0,Math.min(255,tb+d));values[sum]=(nr<<16)|(ng<<8)|nb;}
   if(red){redColor=color;redTones=values;}else{blueColor=color;blueTones=values;}return values;
  }
  public static function apply(b:BitmapData,color:uint,redUniform:Boolean):void {
   var pixels:Vector.<uint>=b.getVector(b.rect),length:int=pixels.length;
   var shades:Vector.<uint>=tones(color,redUniform);
   for(var i:int=0;i<length;i++){
    var q:uint=pixels[i],a:int=q>>>24,r:int=(q>>16)&255,g:int=(q>>8)&255,blue:int=q&255;
    if(redUniform&&a<40){pixels[i]=0;continue;}
    var selected:Boolean=redUniform?r>g*2.2&&r>blue*2.2&&r>60:a>16&&blue>r*1.3&&blue>g*1.12&&blue>35;
    if(selected)pixels[i]=(q&0xff000000)|shades[r+g+blue];
   }
   b.setVector(b.rect,pixels);
  }
 }
}
