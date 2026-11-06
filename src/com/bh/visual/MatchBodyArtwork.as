package com.bh.visual {
 import flash.display.*;import flash.geom.*;
 /** Body proportions are fixed by the standing pose; neck/hand anchors follow the drawing. */
 public class MatchBodyArtwork extends Sprite {
  private var kind:String,bank:Object,bitmap:Bitmap=new Bitmap(null,"auto",true),index:int=-1,dead:Boolean=false,unit:Number;
  public function MatchBodyArtwork(kind:String,palette:Object,height:Number=140){this.kind=kind;mouseEnabled=mouseChildren=false;bank=MatchPoseStore.acquire(kind,palette);var ready:Object=MatchPoseStore.frames(kind)[0];unit=height/Math.max(1,ready.ground[1]-ready.neck[1]);name="motion39-"+kind;addChild(bitmap);setFrame(0);}
  public function get frameIndex():int {return index;}
  public function get frameCount():int {return MatchPoseStore.frames(kind).length;}
  public function get facing():int {return int(MatchPoseStore.frames(kind)[index].facing);}
  public function setFrame(n:int):void {if(dead)return;n=Math.max(0,Math.min(frameCount-1,n));if(n==index)return;index=n;var f:Object=MatchPoseStore.frames(kind)[n],r:Array=f.rect,u:Number=unit*(f.nativeScale?Number(f.nativeScale):1);bitmap.bitmapData=MatchPoseStore.pixels(bank,n);bitmap.scaleX=bitmap.scaleY=u;bitmap.x=(r[0]-f.ground[0])*u;bitmap.y=(r[1]-f.ground[1])*u;}
  public function anchor(key:String="neck",frame:int=-1):Point {var f:Object=MatchPoseStore.frames(kind)[frame<0?index:frame],p:Array=f[key]||f.neck,u:Number=unit*(f.nativeScale?Number(f.nativeScale):1);return new Point((p[0]-f.ground[0])*u,(p[1]-f.ground[1])*u);}
  public function warmDeferred():void {MatchPoseStore.warmDeferred(bank);}
  public function warmAll():void {var saved:int=index;for(var n:int=0;n<frameCount;n++)setFrame(n);setFrame(saved);}
  public function dispose():void {if(dead)return;dead=true;bitmap.bitmapData=null;MatchPoseStore.release(bank);}
 }
}
