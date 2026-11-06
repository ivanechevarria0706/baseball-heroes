package com.bh.visual {
 import flash.display.*;
 /** A genuine rear helmet silhouette replaces the old flattened front face. */
 public class RearHeroArtwork extends Sprite {
  private var bank:Object,bitmap:Bitmap=new Bitmap(null,"auto",true),index:int=-1,dead:Boolean=false;
  public function RearHeroArtwork(palette:Object){mouseEnabled=mouseChildren=false;bank=MatchPoseStore.acquire("rear",palette);name="hero-rear-illustration";addChild(bitmap);setFacing(135);}
  public function setFacing(degrees:Number):void {if(dead)return;var n:int=degrees>=160?1:0;if(n==index)return;index=n;var f:Object=MatchPoseStore.frames("rear")[n],r:Array=f.rect;bitmap.bitmapData=MatchPoseStore.pixels(bank,n);var s:Number=156/r[3];bitmap.scaleX=bitmap.scaleY=s;bitmap.x=-r[2]*s/2;bitmap.y=-154;}
  public function dispose():void {if(dead)return;dead=true;bitmap.bitmapData=null;MatchPoseStore.release(bank);}
 }
}
