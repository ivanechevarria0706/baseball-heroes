package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.utils.getTimer;
 import com.bh.audio.AudioCueSequence;import com.bh.audio.OriginalAudioBank;
 /** One first-visible-frame clock for retained artwork, entrance beats and owned sound. */
 public class MenuEntrance {
  private var target:Sprite,clock:Function,renderer:Function,manual:Boolean,started:Boolean=false,finished:Boolean=false,dead:Boolean=false,startedAt:int=0,endAt:int=0,paintedAt:int=0;
  private var tracks:Array=[],sounds:Array=[],cues:AudioCueSequence;
  public function MenuEntrance(view:Sprite,timeSource:Function=null,frameRenderer:Function=null){target=view;manual=timeSource!=null;clock=manual?timeSource:getTimer;renderer=frameRenderer;cues=new AudioCueSequence(clock);}
  public function track(view:DisplayObject,delay:int,duration:int,dx:Number=0,dy:Number=0,scale:Number=1,anchorX:Number=0,anchorY:Number=0,fade:Boolean=true,fadeOut:Boolean=false):void {
   if(dead||finished)return;tracks.push({view:view,delay:delay,duration:Math.max(1,duration),dx:dx,dy:dy,scale:scale,ax:anchorX,ay:anchorY,x:view.x,y:view.y,sx:view.scaleX,sy:view.scaleY,alpha:view.alpha,visible:view.visible,fade:fade,out:fadeOut});endAt=Math.max(endAt,delay+duration);paint(-1);
  }
  public function sound(key:String,delay:int=0,gain:Number=.65):void {if(dead||finished)return;sounds.push({key:key,delay:delay,gain:gain});var original:*=OriginalAudioBank.sound(key);endAt=Math.max(endAt,delay+(original?Math.ceil(original.length):0)+40);}
  public function play():void {if(dead||finished)return;target.addEventListener(Event.ENTER_FRAME,tick);target.addEventListener(Event.REMOVED_FROM_STAGE,removed);target.addEventListener(MouseEvent.MOUSE_DOWN,interact,true,1000);paint(-1);if(manual)advance();}
  private function tick(e:Event):void {advance();}
  public function advance():void {if(dead||finished)return;if(!manual&&!target.stage)return;if(!started){started=true;startedAt=int(clock());for each(var cue:Object in sounds)cues.enqueue(String(cue.key),int(cue.delay),Number(cue.gain));}cues.advance();paint(Math.max(0,int(clock())-startedAt));if(paintedAt>=endAt)finish();}
  private function paint(ms:int):void {paintedAt=ms;for each(var t:Object in tracks){var p:Number=Math.max(0,Math.min(1,(ms-int(t.delay))/int(t.duration))),ease:Number=1-Math.pow(1-p,3),scale:Number=Number(t.scale)+(1-Number(t.scale))*ease,v:DisplayObject=t.view;v.scaleX=Number(t.sx)*scale;v.scaleY=Number(t.sy)*scale;v.x=Number(t.x)+Number(t.dx)*(1-ease)+Number(t.ax)*(1-scale);v.y=Number(t.y)+Number(t.dy)*(1-ease)+Number(t.ay)*(1-scale);v.alpha=Number(t.alpha)*(t.out?1-ease:t.fade?ease:1);v.visible=Boolean(t.visible)&&(t.out?p<1:p>0);}if(renderer!=null)renderer(Math.max(0,ms));}
  private function interact(e:MouseEvent):void {finish();}
  public function finish():void {if(dead||finished)return;paint(endAt);finished=true;target.removeEventListener(Event.ENTER_FRAME,tick);target.removeEventListener(MouseEvent.MOUSE_DOWN,interact,true);}
  private function removed(e:Event):void {if(e.target===target)dispose();}
  public function dispose():void {if(dead)return;finish();dead=true;cues.dispose();target.removeEventListener(Event.REMOVED_FROM_STAGE,removed);tracks=[];sounds=[];renderer=null;}
 }
}

