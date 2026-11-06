package com.bh.visual {
 import flash.display.Sprite;
 /** Three retained tapered layers follow projected ball velocity; no per-frame graphics rebuild. */
 public class BallFlightTrail extends Sprite {
  public function BallFlightTrail(){name="ball-flight-trail";mouseEnabled=mouseChildren=false;var g:*=graphics;
   g.beginFill(0x53d9df,.17);g.moveTo(8,0);g.curveTo(-55,-24,-142,0);g.curveTo(-55,24,8,0);g.endFill();
   g.beginFill(0xb8ffff,.46);g.moveTo(3,0);g.curveTo(-42,-12,-112,0);g.curveTo(-42,12,3,0);g.endFill();
   g.beginFill(0xffffff,.83);g.moveTo(0,0);g.curveTo(-35,-4,-87,0);g.curveTo(-35,4,0,0);g.endFill();visible=false;}
  public function follow(px:Number,py:Number,dx:Number,dy:Number,progress:Number):void {var p:Number=Math.max(0,Math.min(1,progress));visible=p>.01&&p<1;x=px;y=py;rotation=Math.atan2(dy,dx)*180/Math.PI;scaleX=1.05-p*.60;scaleY=.95-p*.65;alpha=.9-p*.25;}
  public function hide():void {visible=false;}
  public function dispose():void {hide();graphics.clear();}
 }
}
