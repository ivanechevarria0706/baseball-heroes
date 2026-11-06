package com.bh.game {
 import flash.display.*;import flash.events.Event;import flash.utils.getTimer;
 import com.bh.visual.PitchCalloutArtwork;
 /** A scene-clock label can wait for contact or the umpire cue, and cannot revive after hide. */
 public class GameplayCallout extends Sprite {
  private var clock:Function,shownAt:int=0,duration:int=0,restingTilt:Number=0,paintedAt:int=-1,originX:Number=0;
  private var artwork:PitchCalloutArtwork,trail:Sprite=new Sprite(),carrier:Sprite=new Sprite(),labelValue:String="",pending:Boolean=false,dead:Boolean=false;
  public function GameplayCallout(timeSource:Function=null) {clock=timeSource!=null?timeSource:getTimer;mouseEnabled=mouseChildren=false;visible=false;addChild(carrier);carrier.addChild(trail);addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);}
  public function show(text:String,color:uint=0xffd944,frames:int=42,tilt:Number=0,delayMs:int=0,detail:String=""):void {
   if(dead)return;hide();labelValue=text;shownAt=int(clock())+Math.max(0,delayMs);duration=Math.max(18,frames)*1000/30;restingTilt=tilt;pending=true;
   if(artwork&&artwork.parent)carrier.removeChild(artwork);artwork=new PitchCalloutArtwork(text,color,detail);carrier.addChild(artwork);
   var g:Graphics=trail.graphics;g.clear();g.beginFill(color,.40);g.drawRect(-230,-24,155,7);g.drawRect(-195,-10,115,3);g.beginFill(0xffffff,.5);g.drawRect(-180,5,96,2);g.endFill();
   addEventListener(Event.ENTER_FRAME,onFrame);advance();
  }
  private function onFrame(e:Event):void {advance();}
  public function advance():void {
   if(dead||!pending)return;var age:int=int(clock())-shownAt;paintedAt=age;visible=age>=0;if(age<0)return;
   if(age>=duration){hide();return;}
   var enter:Number=Math.max(0,Math.min(1,age/150)),ease:Number=1-Math.pow(1-enter,3);
   carrier.x=(1-ease)*86;carrier.scaleX=1+.20*(1-ease);carrier.scaleY=1+.12*(1-ease);carrier.rotation=restingTilt-2.2*(1-ease);
   trail.alpha=1-Math.min(1,age/230);trail.scaleX=1+.3*enter;alpha=Math.min(1,(duration-age)/180);
  }
  public function hide():void {removeEventListener(Event.ENTER_FRAME,onFrame);pending=false;visible=false;alpha=1;carrier.x=0;carrier.scaleX=carrier.scaleY=1;carrier.rotation=0;}
  private function onRemoved(e:Event):void {if(e.target===this)hide();}
  public function dispose():void {if(dead)return;hide();dead=true;removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);if(artwork&&artwork.parent)carrier.removeChild(artwork);artwork=null;trail.graphics.clear();}
 }
}
