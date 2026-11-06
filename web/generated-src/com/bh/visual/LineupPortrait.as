package com.bh.visual {
 import flash.display.Sprite;import com.bh.model.*;
 public class LineupPortrait extends Sprite {
  private var mlb:MLBPlayerArtwork,head:HeroHead;
  public function LineupPortrait(frame:int,w:Number=32,h:Number=28,card:Object=null){
   mouseEnabled=mouseChildren=false;name="illustrated-lineup-head";
   var data:Object=card;if(data&&!data.friendId&&MLBPlayerArtwork.indexFor(data)<0&&data.name)data=MLB2026Catalog.named(String(data.name));
   if(data&&!data.friendId&&MLBPlayerArtwork.indexFor(data)>=0){mlb=new MLBPlayerArtwork(data,w,h,true);addChild(mlb);}
   else {var a:Object=card&&card.appearance?card.appearance:GameData.heroAppearance();head=new HeroHead(a,HomeSprite.paletteFor("Hero",0x287ab2,a,{}));head.scaleX=head.scaleY=Math.min(w/150,h/165);head.x=w/2;head.y=h;addChild(head);}
  }
  public function dispose():void {if(mlb)mlb.dispose();if(head)head.dispose();}
 }
}
