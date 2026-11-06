package com.bh.visual {
 import flash.display.Sprite;
 /** MLB editions share one original illustration per player. */
 public class SpecialCardIllustration extends Sprite {
  private var art:LineupPortrait;
  public function SpecialCardIllustration(data:Object){mouseEnabled=mouseChildren=false;art=new LineupPortrait(-1,124,113,data);addChild(art);}
  public function dispose():void {if(art){art.dispose();art=null;}}
 }
}
