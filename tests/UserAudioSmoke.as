package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.media.SoundChannel;
    import flash.desktop.NativeApplication;
    import flash.filesystem.*;
    import flash.utils.setTimeout;
    import com.bh.audio.*;
    public class UserAudioSmoke extends Sprite {
        private var completed:int=0;
        private var keys:Array=['hero_hit','sim_hit','sim_out','strike'];
        private var durations:Array=[1860,711,358,847];
        public function UserAudioSmoke(){
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            AudioManager.setSfxVolume(0);GameplayAudio.preload();GameplayAudio.preload();
            for(var i:int=0;i<4;i++)check(Math.abs(GameplayAudio.duration(keys[i])-durations[i])<80,'Unexpected decoded duration '+keys[i]);
            for each(var result:String in ['SINGLE','DOUBLE','TRIPLE','HOME RUN'])check(GameplayAudio.simulationEvent(result)=='sim_hit','Missing hit mapping '+result);
            for each(result in ['OUT','FLY OUT','STRIKEOUT'])check(GameplayAudio.simulationEvent(result)=='sim_out','Missing out mapping '+result);
            check(GameplayAudio.simulationEvent('WALK')=='','Walk plays contact audio');
            check(GameplayAudio.play('missing')==null&&GameplayAudio.duration('missing')==0,'Unknown cue is not safe');
            check(SimulationAudio.ready,'Compatibility OUT not ready');
            begin();setTimeout(function():void{finish('FAIL: sound completion timeout '+completed,1);},15000);
        }
        private function check(value:Boolean,message:String):void {if(!value)throw new Error(message);}
        private function begin():void {
            var channel:SoundChannel=GameplayAudio.play(keys[completed%4],.5);
            check(channel!=null,'No channel for '+keys[completed%4]);check(channel.soundTransform.volume==0,'Initial mute ignored');
            // Read back changes synchronously, returning to mute before yielding to playback.
            AudioManager.setSfxVolume(.8);check(Math.abs(channel.soundTransform.volume-.4)<.001,'Active gain lost');
            AudioManager.setSfxVolume(0);check(channel.soundTransform.volume==0,'Active sound did not mute');
            channel.addEventListener(Event.SOUND_COMPLETE,done);
        }
        private function done(e:Event):void {
            SoundChannel(e.currentTarget).removeEventListener(Event.SOUND_COMPLETE,done);completed++;
            if(completed==8)finish('PASS: all four user clips decode at expected lengths and play twice to SOUND_COMPLETE; reused embedded sounds honor volume and live mute with per-channel gain; hit/out mappings cover results and exclude WALK; unknown cues are silent.\n',0);
            else setTimeout(begin,20);
        }
        private function finish(value:String,code:int):void {var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-user-audio.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
