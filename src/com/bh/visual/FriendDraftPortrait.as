package com.bh.visual {
 import flash.display.Sprite;import flash.geom.Rectangle;
 /** The accepted friend's published appearance, fitted without clipping the hairstyle. */
 public class FriendDraftPortrait extends Sprite {
  private var head:HeroHead;
  public function FriendDraftPortrait(member:Object,w:Number,h:Number) {
   mouseEnabled=mouseChildren=false;name="draft-portrait-"+member.id;
   var p:Object=member.profile||{},appearance:Object=p.appearance||{};
   head=new HeroHead(appearance,HomeSprite.paletteFor(String(member.name),uint(p.accent||0x247ab2),appearance,{}));
   addChild(head);var bounds:Rectangle=head.getBounds(head),scale:Number=Math.min(w/Math.max(1,bounds.width),h/Math.max(1,bounds.height));
   head.scaleX=head.scaleY=scale;head.x=(w-bounds.width*scale)/2-bounds.x*scale;head.y=(h-bounds.height*scale)/2-bounds.y*scale;head.cacheAsBitmap=true;
  }
  public function dispose():void {if(head){head.dispose();if(head.parent)removeChild(head);head=null;}}
 }
}
