package com.bh.ui {
 import flash.display.Sprite;import com.bh.visual.PitchCalloutArtwork;
 /** A retained run callout; its count is supplied by the existing scoreboard update. */
 public class SimulationRunStamp extends Sprite {
  private var labels:Object={},current:PitchCalloutArtwork,gain:int=0,armed:Boolean=false;
  public function SimulationRunStamp(){name="simulation-runs-gain";mouseEnabled=mouseChildren=false;visible=false;rotation=-7;}
  public function show(value:int):void {clear();if(value<=0)return;gain=value;current=labels[value] as PitchCalloutArtwork;if(!current){current=new PitchCalloutArtwork("+"+value+" RUN",0xffb432);labels[value]=current;addChild(current);}current.visible=true;armed=true;visible=false;alpha=1;scaleX=scaleY=.58;}
  public function advance(progress:Number):void {if(!armed)return;if(progress<0){visible=false;return;}visible=true;var p:Number=Math.max(0,Math.min(1,progress));scaleX=scaleY=.58*(1+.16*Math.max(0,1-p*4));alpha=Math.max(0,1-p);if(p>=1)clear();}
  public function clear():void {if(current)current.visible=false;gain=0;armed=false;visible=false;}
 }
}
