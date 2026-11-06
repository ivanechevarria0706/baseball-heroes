package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.UncaughtErrorEvent;
    import flash.media.SoundChannel;
    import flash.desktop.NativeApplication;
    import flash.filesystem.*;
    import flash.utils.setTimeout;
    import com.bh.audio.AudioManager;
    import com.bh.audio.SimulationAudio;
    public class AudioSmoke extends Sprite {
        private var completed:int=0;
        private var started:int=0;
        public function AudioSmoke() {
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{
                e.preventDefault();finish('FAIL: '+e.error,1);
            });
            // Decode and exercise the actual mixer without making the QA window audible.
            AudioManager.setSfxVolume(0);
            SimulationAudio.preload();
            setTimeout(begin,300);
            setTimeout(function():void{if(completed!=6)finish('FAIL: sound completion timeout '+completed,1);},12000);
        }
        private function begin():void {
            if(!SimulationAudio.ready){setTimeout(begin,50);return;}
            var c:SoundChannel=SimulationAudio.playOut();
            started++;
            if(!c)throw new Error('Preloaded effect did not create a SoundChannel');
            if(c.soundTransform.volume!=0)throw new Error('SFX volume ignored');
            c.addEventListener(Event.SOUND_COMPLETE,done);
        }
        private function done(e:Event):void {
            SoundChannel(e.currentTarget).removeEventListener(Event.SOUND_COMPLETE,done);
            completed++;
            if(completed==6){
                if(AudioManager.playPreparedSfx(null)!=null)throw new Error('Null sound did not fail silently');
                finish('PASS: six reused playbacks of the user-selected simulation OUT create channels, honor mute and emit SOUND_COMPLETE; null sound is safe.\n',0);
            } else setTimeout(begin,50);
        }
        private function finish(value:String,code:int):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-audio.txt');f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();
            NativeApplication.nativeApplication.exit(code);
        }
    }
}
