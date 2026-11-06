package com.bh.audio {
    import flash.media.SoundChannel;

    /** Compatibility entry point; the user's new OUT replaces the F.A.F. cut. */
    public class SimulationAudio {
        public static function preload():void {GameplayAudio.preload();}
        public static function get ready():Boolean {return GameplayAudio.duration(GameplayAudio.SIM_OUT)>0;}
        public static function playOut():SoundChannel {return GameplayAudio.play(GameplayAudio.SIM_OUT);}
    }
}
