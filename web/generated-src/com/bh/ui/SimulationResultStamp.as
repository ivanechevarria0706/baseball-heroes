package com.bh.ui {
 import flash.display.*;import com.bh.visual.PitchCalloutArtwork;
 /** Retained comic labels sit directly on the batting row, without an extra panel. */
 public class SimulationResultStamp extends Sprite {
  private static var cache:Object={};private var ink:Sprite,streaks:Shape=new Shape();
  public function SimulationResultStamp(result:String){
   name="simulation-result";mouseEnabled=mouseChildren=false;var bases:int=result.indexOf("TRIPLE")>=0?3:result.indexOf("DOUBLE")>=0?2:result.indexOf("SINGLE")>=0?1:0;
   var value:String=result.indexOf("HOME RUN")>=0?"HOME RUN!":bases>0?bases+" BASE HIT!":result.indexOf("STRIKE OUT")>=0?"STRIKE OUT!":result.indexOf("GROUND OUT")>=0?"GROUND OUT!":result.indexOf("FLY OUT")>=0?"FLY OUT!":result.indexOf("OUT")>=0?"OUT!":result.indexOf("WALK")>=0?"BASE ON BALLS":result;
   ink=cache[value] as Sprite;if(!ink||ink.stage){ink=new Sprite();var color:uint=value.indexOf("OUT")>=0?0xfa4d66:value=="BASE ON BALLS"?0x68dbea:value.indexOf("HOME RUN")>=0?0xffc142:0xb1ed35;
    if(bases>0){var number:PitchCalloutArtwork=new PitchCalloutArtwork(String(bases),color);number.scaleX=number.scaleY=.74;number.x=-50;ink.addChild(number);var words:PitchCalloutArtwork=new PitchCalloutArtwork("BASE HIT!",color);words.scaleX=words.scaleY=.46;words.x=10;ink.addChild(words);}
    else {var label:PitchCalloutArtwork=new PitchCalloutArtwork(value,color);label.scaleX=label.scaleY=value.length>10?.49:.61;ink.addChild(label);}ink.cacheAsBitmap=true;cache[value]=ink;
   }
   var g:Graphics=streaks.graphics;g.lineStyle(3,0x102f32,.55);g.moveTo(-122,10);g.lineTo(-77,10);g.moveTo(-116,17);g.lineTo(-85,17);g.lineStyle(1,0xffffff,.58);g.moveTo(-126,7);g.lineTo(-84,7);g.lineStyle();addChild(streaks);addChild(ink);rotation=-7;
  }
  public function advance(progress:Number):void {var p:Number=Math.max(0,Math.min(1,progress));streaks.alpha=Math.max(0,1-p*4);streaks.scaleX=1+p*.3;}
 }
}
