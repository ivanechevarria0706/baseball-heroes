package com.bh.visual {
 import flash.display.Sprite;import flash.text.*;import com.bh.ui.LineupTypography;
 /** Explicit ink copies keep the thick outline visible in browser rotations. */
 public class ComicResultWords extends Sprite {
  public function ComicResultWords(label:String){mouseEnabled=mouseChildren=false;
   for(var i:int=0;i<9;i++){
    var t:TextField=new TextField();t.text=label;t.multiline=true;t.width=730;t.height=250;t.selectable=t.mouseEnabled=false;
    LineupTypography.apply(t,84,i==8?0xc3f12a:0x071208,TextFormatAlign.CENTER,true);
    var f:TextFormat=t.defaultTextFormat;f.leading=-8;t.defaultTextFormat=f;t.setTextFormat(f);
    if(i<8){t.x=Math.cos(i*Math.PI/4)*6;t.y=Math.sin(i*Math.PI/4)*6;}addChild(t);
   }
  }
 }
}
