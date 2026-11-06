package com.bh.audio {
 import flash.media.Sound;
 /** Original procedural effects. No quarantined gameplay recordings are loaded. */
 public class RebuiltAudioBank {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/pitch.mp3")] private static const Clip0:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/swing.mp3")] private static const Clip1:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/catch.mp3")] private static const Clip2:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/ball.mp3")] private static const Clip3:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/walk.mp3")] private static const Clip4:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/single.mp3")] private static const Clip5:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/double.mp3")] private static const Clip6:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/triple.mp3")] private static const Clip7:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/home_run.mp3")] private static const Clip8:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/grand_slam.mp3")] private static const Clip9:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/bases_loaded.mp3")] private static const Clip10:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/power_hit.mp3")] private static const Clip11:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/lucky_hit.mp3")] private static const Clip12:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/sim_combo.mp3")] private static const Clip13:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/sim_special.mp3")] private static const Clip14:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/sim_hero_in.mp3")] private static const Clip15:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/sim_transition.mp3")] private static const Clip16:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/audio/v1042/world_champion.mp3")] private static const Clip17:Class;
  private static var bank:Object;
  public static function sound(key:String):Sound {var original:Sound=OriginalAudioBank.sound(key);if(original)return original;if(!bank){bank={};bank["pitch"]=new Clip0();bank["swing"]=new Clip1();bank["catch"]=new Clip2();bank["ball"]=new Clip3();bank["walk"]=new Clip4();bank["single"]=new Clip5();bank["double"]=new Clip6();bank["triple"]=new Clip7();bank["home_run"]=new Clip8();bank["grand_slam"]=new Clip9();bank["bases_loaded"]=new Clip10();bank["power_hit"]=new Clip11();bank["lucky_hit"]=new Clip12();bank["sim_combo"]=new Clip13();bank["sim_special"]=new Clip14();bank["sim_hero_in"]=new Clip15();bank["sim_transition"]=new Clip16();bank["world_champion"]=new Clip17();}key=key.replace(".mp3","");if(key=="result_single")key="single";if(key=="result_double")key="double";if(key=="result_triple")key="triple";return bank[key] as Sound;}
 }
}
