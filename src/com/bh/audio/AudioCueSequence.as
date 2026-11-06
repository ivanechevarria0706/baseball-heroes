package com.bh.audio {
 import flash.events.Event;import flash.events.TimerEvent;import flash.media.SoundChannel;import flash.utils.Timer;import flash.utils.getTimer;
 /** Scene-owned cues share its clock, including pause/resume playback offsets. */
 public class AudioCueSequence {
  private var timer:Timer=new Timer(10),jobs:Array=[],channels:Array=[],suspended:Array=[],dead:Boolean=false,paused:Boolean=false,pausedAt:int=0,clock:Function;
  public function AudioCueSequence(timeSource:Function=null){clock=timeSource==null?getTimer:timeSource;timer.addEventListener(TimerEvent.TIMER,tick);}
  public function enqueue(event:String,delay:int=0,gain:Number=1):void {
   if(dead)return;if(jobs.length>=32)jobs.shift();jobs.push({event:event,at:int(clock())+Math.max(0,delay),gain:gain});advance();if(jobs.length&&!paused)timer.start();
  }
  private function tick(e:TimerEvent):void {advance();}
  private function start(event:String,gain:Number,offset:Number=0):void {
   var c:SoundChannel=event.indexOf('.mp3')>=0?AudioManager.playSfx(event,gain,offset):GameplayAudio.play(event,gain,offset);
   if(!c)return;while(channels.length>=16){var old:Object=channels.shift();old.channel.removeEventListener(Event.SOUND_COMPLETE,complete);AudioManager.stopSfx(old.channel);}
   channels.push({channel:c,event:event,gain:gain});c.addEventListener(Event.SOUND_COMPLETE,complete);
  }
  public function advance():void {
   if(dead||paused)return;var now:int=int(clock());for(var i:int=0;i<jobs.length;){var j:Object=jobs[i];if(j.at>now){i++;continue;}jobs.splice(i,1);start(String(j.event),Number(j.gain));}if(!jobs.length)timer.stop();
  }
  private function complete(e:Event):void {var c:SoundChannel=e.currentTarget as SoundChannel;c.removeEventListener(Event.SOUND_COMPLETE,complete);for(var i:int=channels.length-1;i>=0;i--)if(channels[i].channel===c)channels.splice(i,1);}
  public function pause():void {if(dead||paused)return;paused=true;pausedAt=int(clock());timer.stop();for each(var row:Object in channels){suspended.push({event:row.event,gain:row.gain,offset:row.channel.position});row.channel.removeEventListener(Event.SOUND_COMPLETE,complete);AudioManager.stopSfx(row.channel);}channels=[];}
  public function resume():void {if(dead||!paused)return;var shift:int=Math.max(0,int(clock())-pausedAt);for each(var job:Object in jobs)job.at+=shift;paused=false;var waiting:Array=suspended;suspended=[];for each(var row:Object in waiting)start(String(row.event),Number(row.gain),Number(row.offset));advance();if(jobs.length)timer.start();}
  public function cancelPending():void {jobs=[];timer.stop();}
  public function get pendingCount():int {return jobs.length;}
  public function stopAll():void {cancelPending();for each(var row:Object in channels){row.channel.removeEventListener(Event.SOUND_COMPLETE,complete);AudioManager.stopSfx(row.channel);}channels=[];suspended=[];paused=false;}
  public function dispose():void {if(dead)return;dead=true;stopAll();timer.removeEventListener(TimerEvent.TIMER,tick);}
 }
}
