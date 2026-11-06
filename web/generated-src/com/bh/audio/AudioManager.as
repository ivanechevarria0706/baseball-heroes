package com.bh.audio {
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.events.IOErrorEvent;
    import com.bh.platform.File;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;

    public class AudioManager {
        private static var sound:Sound;
        private static var channel:SoundChannel;
        private static var currentTrack:String = "";
        private static var volume:Number = 0.55;

        private static var sfxSounds:Array = [];
        private static var sfxChannels:Array = [];
        private static var sfxGains:Array = [];
        private static var sfxVolume:Number = 0.88;

        public static function playMusic(
            track:String
        ):void {
            if (!track) return;

            if (
                currentTrack == track &&
                channel != null
            ) {
                return;
            }

            stopMusic();

            var fileName:String =
                fileForTrack(track);

            if (fileName == "") {
                return;
            }

            var file:File =
                File.applicationDirectory.resolvePath(
                    "assets/audio/" +
                    fileName
                );

            if (!file.exists) {
                // Silent fallback: the project intentionally ships
                // without copyrighted Baseball Heroes music files.
                currentTrack = "";
                return;
            }

            currentTrack = track;
            sound = new Sound();

            sound.addEventListener(
                IOErrorEvent.IO_ERROR,
                onIoError
            );

            sound.load(
                new URLRequest(
                    file.url
                )
            );

            channel =
                sound.play(
                    0,
                    int.MAX_VALUE
                );

            if (channel) {
                applyVolume();
            }
        }

        public static function stopMusic():void {
            if (channel) {
                channel.stop();
                channel = null;
            }

            if (sound) {
                try {
                    sound.close();
                }
                catch (e:Error) {
                }

                sound.removeEventListener(
                    IOErrorEvent.IO_ERROR,
                    onIoError
                );

                sound = null;
            }

            currentTrack = "";
        }

        public static function setVolume(
            value:Number
        ):void {
            volume =
                Math.max(
                    0,
                    Math.min(
                        1,
                        value
                    )
                );

            if (channel) {
                applyVolume();
            }
        }

        private static function applyVolume():void {
            if (!channel) return;

            var transform:SoundTransform =
                channel.soundTransform;

            transform.volume = volume;
            channel.soundTransform = transform;
        }

        private static var lastUiClick:int=-1000;
        public static function playUiClick():void {
            var now:int=getTimer();if(now-lastUiClick<65)return;lastUiClick=now;playSfx("ui_click.mp3",.48);
        }
        public static function playSfx(fileName:String,gain:Number=1.0,offsetMs:Number=0):SoundChannel {
            // Only curated recordings, approved user cuts and declared recreations. Narrator files remain blocked.
            var prepared:Sound=RebuiltAudioBank.sound(fileName);
            if(prepared){var layer:Number=["home_run.mp3","grand_slam.mp3","power_hit.mp3","lucky_hit.mp3"].indexOf(fileName)>=0?.45:1;return playPreparedSfx(prepared,gain*layer,offsetMs);}
            if(["user_hero_hit.mp3","user_sim_hit.mp3","user_sim_out.mp3","user_strike.mp3"].indexOf(fileName)<0)return null;
            var file:File=File.applicationDirectory.resolvePath("assets/audio/"+fileName);
            if(!file.exists)return null;
            var effect:Sound=new Sound();effect.addEventListener(IOErrorEvent.IO_ERROR,onSfxIoError);effect.load(new URLRequest(file.url));
            return playPreparedSfx(effect,gain,offsetMs);
        }

        public static function playPreparedSfx(effect:Sound,gain:Number=1.0,offsetMs:Number=0):SoundChannel {
            if(!effect) return null;
            while(sfxChannels.length>=16)stopSfx(sfxChannels[0] as SoundChannel);
            var effectChannel:SoundChannel =
                effect.play(Math.max(0,offsetMs));

            if (!effectChannel) {
                return null;
            }

            var transform:SoundTransform =
                effectChannel.soundTransform;

            transform.volume =
                Math.max(
                    0,
                    Math.min(
                        1,
                        sfxVolume *
                        gain
                    )
                );

            effectChannel.soundTransform =
                transform;

            effectChannel.addEventListener(
                Event.SOUND_COMPLETE,
                onSfxComplete
            );

            sfxSounds.push(effect);
            sfxGains.push(gain);
            sfxChannels.push(
                effectChannel
            );
            return effectChannel;
        }

        public static function setSfxVolume(
            value:Number
        ):void {
            sfxVolume =
                Math.max(
                    0,
                    Math.min(
                        1,
                        value
                    )
                );
            for(var i:int=0;i<sfxChannels.length;i++) {
                var active:SoundChannel=sfxChannels[i] as SoundChannel;
                active.soundTransform=new SoundTransform(Math.max(0,Math.min(1,sfxVolume*Number(sfxGains[i]))));
            }
        }

        private static function onSfxComplete(
            e:Event
        ):void {
            var completed:SoundChannel =
                e.currentTarget
                as SoundChannel;

            if (!completed) {
                return;
            }

            releaseSfx(completed);
        }
        public static function stopSfx(active:SoundChannel):void {
            if(!active)return;active.stop();releaseSfx(active);
        }
        private static function releaseSfx(completed:SoundChannel):void {
            completed.removeEventListener(
                Event.SOUND_COMPLETE,
                onSfxComplete
            );

            var index:int =
                sfxChannels.indexOf(
                    completed
                );

            if (index >= 0) {
                var effect:Sound =
                    sfxSounds[index]
                    as Sound;

                if (effect) {
                    effect.removeEventListener(
                        IOErrorEvent.IO_ERROR,
                        onSfxIoError
                    );
                }

                sfxChannels.splice(
                    index,
                    1
                );

                sfxSounds.splice(
                    index,
                    1
                );
                sfxGains.splice(index,1);
            }
        }

        private static function onSfxIoError(
            e:IOErrorEvent
        ):void {
            // Missing/invalid optional SFX must never interrupt gameplay.
        }

        private static function fileForTrack(
            track:String
        ):String {
            if (track == "baseball_heroes") {
                return "baseball_heroes.mp3";
            }

            if (track == "locker_room") {
                return "locker_room.mp3";
            }

            if (track == "shop") {
                return "shop.mp3";
            }

            return "";
        }

        private static function onIoError(
            e:IOErrorEvent
        ):void {
            stopMusic();
        }
    }
}
