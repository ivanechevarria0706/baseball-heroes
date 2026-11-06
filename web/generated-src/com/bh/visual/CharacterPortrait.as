package com.bh.visual {
 import flash.display.Sprite;import flash.geom.Rectangle;import com.bh.model.*;
 public class CharacterPortrait extends Sprite {
  private var head:HeroHead,mlb:MLBPlayerArtwork;
  public function CharacterPortrait(data:Object,w:Number=86,h:Number=78,helmet:Boolean=true){
   mouseEnabled=mouseChildren=false;var isHero:Boolean=data&&(data.friendId||data.isHero===true||String(data.name)==String(GameData.mainPlayer().name));
   var identity:Object=data;if(!isHero&&MLBPlayerArtwork.indexFor(identity)<0&&data&&data.name)identity=MLB2026Catalog.named(String(data.name));
   if(!isHero&&MLBPlayerArtwork.indexFor(identity)>=0){mlb=new MLBPlayerArtwork(identity,w,h,true);addChild(mlb);return;}
   var accent:uint=data&&data.accent!==undefined?uint(data.accent):0x287ab2,a:Object=data&&data.appearance?data.appearance:GameData.heroAppearance();
   graphics.beginFill(VisualProfile.lighter(accent,.72));graphics.drawRoundRect(0,0,w,h,8);graphics.endFill();
   var crop:Sprite=new Sprite();crop.scrollRect=new Rectangle(0,0,w,h);addChild(crop);
   head=new HeroHead(a,HomeSprite.paletteFor("Hero",accent,a,{}));head.scaleX=head.scaleY=Math.min(w/150,h/165);head.x=w/2;head.y=h;crop.addChild(head);
  }
  public function dispose():void {if(head)head.dispose();if(mlb)mlb.dispose();}
 }
}
