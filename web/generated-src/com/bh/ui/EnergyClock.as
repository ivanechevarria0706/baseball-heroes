package com.bh.ui {
 import flash.display.Sprite;import flash.events.Event;import flash.events.TimerEvent;import flash.utils.Timer;import flash.text.*;import com.bh.model.GameData;
 /** A one-second clock, suspended whenever its screen leaves the stage. */
 public class EnergyClock extends Sprite {
  private var timer:Timer=new Timer(1000),target:TextField,label:TextField=new TextField(),changed:Function;
  public function EnergyClock(field:TextField=null,width:Number=170,onRefresh:Function=null){target=field;changed=onRefresh;mouseEnabled=mouseChildren=false;name="energy-clock";label.defaultTextFormat=new TextFormat("Arial",8,0xffffff,true,null,null,null,null,"center");label.width=width;label.height=16;label.selectable=false;addChild(label);timer.addEventListener(TimerEvent.TIMER,tick);addEventListener(Event.ADDED_TO_STAGE,added);addEventListener(Event.REMOVED_FROM_STAGE,removed);}
  private function added(e:Event):void {tick();timer.start();}
  private function removed(e:Event):void {timer.stop();}
  private function tick(e:Event=null):void {GameData.refreshEnergy();if(target)target.text=GameData.energy+" / "+GameData.maxEnergy;label.text=GameData.energyCountdown();if(changed!=null)changed();}
  public function dispose():void {changed=null;timer.stop();timer.removeEventListener(TimerEvent.TIMER,tick);removeEventListener(Event.ADDED_TO_STAGE,added);removeEventListener(Event.REMOVED_FROM_STAGE,removed);}
 }
}
