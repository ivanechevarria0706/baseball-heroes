package com.bh.visual {
 import flash.display.*;import flash.geom.Matrix;import flash.text.*;import flash.filters.GlowFilter;
 import com.bh.ui.LineupTypography;
 /** Retained comic lettering: a substitute face, hard ink, depth and a masked color ramp. */
 public class PitchCalloutArtwork extends Sprite {
  [Embed(source="C:/Windows/Fonts/impact.ttf",fontName="BHCallout",fontWeight="normal",embedAsCFF="false",unicodeRange="U+0020-U+00FF")] private static const Face:Class;
  private static var registered:Boolean=false;
  public function PitchCalloutArtwork(value:String,color:uint,detail:String="") {
   mouseEnabled=mouseChildren=false;if(!registered){Font.registerFont(Face);registered=true;}
   var size:int=value.length>12?43:value.length>8?50:64;
   var probe:TextField=letters(value,size,0xffffff);var width:Number=Math.ceil(probe.textWidth)+16,height:Number=size*1.4;
   var word:Sprite=new Sprite();word.transform.matrix=new Matrix(1,0,-.16,1,0,0);addChild(word);
   for(var depth:int=4;depth>=1;depth--){var shadow:TextField=letters(value,size,0x071a22);shadow.width=width;shadow.x=-width/2+depth*.7;shadow.y=-height/2+depth;word.addChild(shadow);}
   for(var i:int=0;i<12;i++){var ink:TextField=letters(value,size,0x071a22);ink.width=width;ink.x=-width/2+Math.cos(i*Math.PI/6)*3.2;ink.y=-height/2+Math.sin(i*Math.PI/6)*3.2;word.addChild(ink);}
   var faceMask:TextField=letters(value,size,0xffffff);faceMask.width=width;faceMask.x=-width/2;faceMask.y=-height/2;word.addChild(faceMask);
   var fill:Shape=new Shape(),m:Matrix=new Matrix();m.createGradientBox(width,height,Math.PI/2,-width/2,-height/2);
   fill.graphics.beginGradientFill(GradientType.LINEAR,[0xffffff,color,darken(color)],[1,1,1],[10,115,255],m);fill.graphics.drawRect(-width/2,-height/2,width,height);fill.graphics.endFill();word.addChild(fill);fill.mask=faceMask;
   if(detail!=""){var info:TextField=new TextField();info.text=detail;info.width=Math.max(240,width+40);info.height=43;info.x=-info.width/2;info.y=size*.38;info.multiline=true;info.wordWrap=false;info.mouseEnabled=info.selectable=false;LineupTypography.apply(info,11,0xfff7bd,"center");info.filters=[new GlowFilter(0x10252e,1,3,3,5)];addChild(info);}
   cacheAsBitmap=true;
  }
  private function letters(value:String,size:int,color:uint):TextField {var t:TextField=new TextField();t.text=value;t.width=560;t.height=size*1.5;t.selectable=t.mouseEnabled=false;t.embedFonts=true;t.antiAliasType=AntiAliasType.ADVANCED;var f:TextFormat=new TextFormat("BHCallout",size,color,false);f.align="center";t.defaultTextFormat=f;t.setTextFormat(f);return t;}
  private function darken(color:uint):uint {return (int(((color>>16)&255)*.65)<<16)|(int(((color>>8)&255)*.65)<<8)|int((color&255)*.65);}
 }
}
