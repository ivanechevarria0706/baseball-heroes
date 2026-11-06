package com.bh.audio {
    import flash.media.Sound;
    import flash.media.SoundChannel;
    /** Curated original recordings; approved earlier cuts and declared recreations remain as fallbacks. */
    public class GameplayAudio {
        public static const HERO_HIT:String='hero_hit',OUT_HIT:String='out_hit';
        public static const HERO_HOME_RUN:String='hero_home_run',VICTORY:String='victory',DEFEAT:String='defeat';
        [Embed(source='../../../../assets/audio/hero_home_run.mp3')] private static const HomeRun:Class;
        [Embed(source='../../../../assets/audio/result_victory.mp3')] private static const Victory:Class;
        [Embed(source='../../../../assets/audio/result_defeat.mp3')] private static const Defeat:Class;
        public static const SIM_HIT:String='sim_hit';
        public static const SIM_OUT:String='sim_out';
        public static const STRIKE:String='strike';
        [Embed(source='../../../../assets/audio/user_hero_hit.mp3')] private static const HeroHit:Class;
        [Embed(source='../../../../assets/audio/user_sim_hit.mp3')] private static const SimHit:Class;
        [Embed(source='../../../../assets/audio/user_sim_out.mp3')] private static const SimOut:Class;
        [Embed(source='../../../../assets/audio/user_strike.mp3')] private static const Strike:Class;
        public static const PITCH:String="pitch",SWING:String="swing",RESULT_SINGLE:String="result_single",RESULT_DOUBLE:String="result_double",RESULT_TRIPLE:String="result_triple";
        public static const CATCH:String="catch",BALL:String="ball",WALK:String="walk";
        // Unverified gameplay recordings stay excluded.
        private static var sounds:Object;
        public static function preload():void {
            if(sounds)return;
            sounds={};sounds[HERO_HIT]=new HeroHit();sounds[SIM_HIT]=new SimHit();
            sounds[SIM_OUT]=new SimOut();sounds[STRIKE]=new Strike();
            sounds[HERO_HOME_RUN]=new HomeRun();sounds[VICTORY]=new Victory();sounds[DEFEAT]=new Defeat();
            for each(var cue:String in [PITCH,SWING,CATCH,BALL,WALK,RESULT_SINGLE,RESULT_DOUBLE,RESULT_TRIPLE])sounds[cue]=RebuiltAudioBank.sound(cue);
            for each(cue in [HERO_HIT,HERO_HOME_RUN,OUT_HIT,STRIKE,VICTORY,PITCH,SWING,CATCH,BALL,WALK,RESULT_DOUBLE]){
                var original:Sound=OriginalAudioBank.sound(cue);if(original)sounds[cue]=original;
            }

        }
        public static function duration(event:String):Number {
            preload();var sound:Sound=sounds[event] as Sound;return sound?sound.length:0;
        }
        public static function play(event:String,gain:Number=1,offsetMs:Number=0):SoundChannel {
            preload();return AudioManager.playPreparedSfx(sounds[event] as Sound,gain,offsetMs);
        }
        public static function simulationEvent(result:String):String {
            if(result.indexOf('OUT')>=0)return SIM_OUT;
            if(result.indexOf('WALK')>=0||result.indexOf('BASE ON BALLS')>=0)return WALK;
            if(result.indexOf('HOME RUN')>=0||result.indexOf('SINGLE')>=0||result.indexOf('DOUBLE')>=0||result.indexOf('TRIPLE')>=0)return SIM_HIT;
            return '';
        }
    }
}
