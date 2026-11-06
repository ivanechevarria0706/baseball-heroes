package com.bh.visual {
 import flash.display.BitmapData;
 /** Classify the twelve neutral poses once, then recolor only their material
  * pixels. Palette tables and pose metadata have bounded lifetime/size. */
 public class RunnerTint {
  private static var poses:Object={},tables:Object={},order:Array=[];
  private static function lut(color:uint,reference:int):Vector.<uint> {
   var key:String=color+":"+reference;if(tables[key])return tables[key];
   var values:Vector.<uint>=new Vector.<uint>(766,true),r:int=(color>>16)&255,g:int=(color>>8)&255,b:int=color&255;
   for(var s:int=0;s<766;s++){var d:Number=s/3-reference/3;values[s]=(int(Math.max(0,Math.min(255,r+d)))<<16)|(int(Math.max(0,Math.min(255,g+d)))<<8)|int(Math.max(0,Math.min(255,b+d)));}
   tables[key]=values;order.push(key);if(order.length>32)delete tables[order.shift()];return values;
  }
  public static function apply(b:BitmapData,frame:int,p:Object,r:Array,neck:Array):void {
   var height:Number=r[1]+r[3]-neck[1],meta:Object=poses[frame];
   if(!meta){var source:Vector.<uint>=b.getVector(b.rect),indices:Vector.<int>=new Vector.<int>(),kinds:Vector.<int>=new Vector.<int>(),sums:Vector.<int>=new Vector.<int>();
    for(var i:int=0;i<source.length;i++){var q:uint=source[i];if((q>>>24)<16)continue;var red:int=(q>>16)&255,green:int=(q>>8)&255,blue:int=q&255,y:int=int(i/b.width),by:Number=(y+r[1]-neck[1])/height,kind:int=0;
     if(blue>red*1.4&&blue>green*1.15)kind=1;else if(red>green*1.09&&green>blue*1.15&&red>95)kind=2;
     if(red<100&&Math.max(red,green,blue)-Math.min(red,green,blue)<18&&by>.78)kind=3;
     else if(red<85&&Math.max(red,green,blue)-Math.min(red,green,blue)<12&&by>.38&&by<.60)kind=4;
     if(kind){indices.push(i);kinds.push(kind);sums.push(red+green+blue);}
    }
    meta={pixels:source,indices:indices,kinds:kinds,sums:sums};poses[frame]=meta;
   }
   var pixels:Vector.<uint>=Vector.<uint>(meta.pixels).concat(),idx:Vector.<int>=meta.indices,materials:Vector.<int>=meta.kinds,tones:Vector.<int>=meta.sums;
   var lookups:Array=[null,lut(uint(p.uniform),331),lut(uint(p.skin),555),lut(uint(p.shoe),153),lut(uint(p.belt),153)],costume:int=int(p.costume),shoesName:String=String(p.shoesName),classicShoes:Boolean=ClassicWearables.hasShoes(shoesName);
   for(var j:int=0;j<idx.length;j++){var at:int=idx[j],material:int=materials[j],palette:Vector.<uint>=lookups[material];
    if(costume>=0&&material==1){y=int(at/b.width);var x:int=at-y*b.width;var c:uint=CostumeArtwork.cloth(costume,(x+r[0]-neck[0])/height,(y+r[1]-neck[1])/height,uint(p.uniform));palette=lut(c,331);}
    if(material==3&&classicShoes){y=int(at/b.width);x=at-y*b.width;palette=lut(ClassicWearables.shoePaint(shoesName,(x+r[0]-neck[0])/height,(y+r[1]-neck[1])/height,uint(p.shoe),true),153);}
    pixels[at]=(pixels[at]&0xff000000)|palette[tones[j]];
   }
   b.setVector(b.rect,pixels);
  }
 }
}
