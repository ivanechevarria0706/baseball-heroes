package com.bh.audio {
 import flash.media.Sound;
 /** Curated source recordings: exact provenance and trims in assets/audio/v1045/manifest.json. */
 public class OriginalAudioBank {
  [Embed(source="../../../../assets/audio/v1045/calendar_open.mp3")] private static const Clip0:Class;
  [Embed(source="../../../../assets/audio/v1045/plane.mp3")] private static const Clip1:Class;
  [Embed(source="../../../../assets/audio/v1045/ball.mp3")] private static const Clip2:Class;
  [Embed(source="../../../../assets/audio/v1045/out_hit.mp3")] private static const Clip3:Class;
  [Embed(source="../../../../assets/audio/v1045/out_result.mp3")] private static const Clip4:Class;
  [Embed(source="../../../../assets/audio/v1045/hero_hit.mp3")] private static const Clip5:Class;
  [Embed(source="../../../../assets/audio/v1045/hit_flight.mp3")] private static const Clip6:Class;
  [Embed(source="../../../../assets/audio/v1045/double.mp3")] private static const Clip7:Class;
  [Embed(source="../../../../assets/audio/v1045/home_run.mp3")] private static const Clip8:Class;
  [Embed(source="../../../../assets/audio/v1045/ui_click.mp3")] private static const Clip9:Class;
  [Embed(source="../../../../assets/audio/v1045/match_confirm.mp3")] private static const Clip10:Class;
  [Embed(source="../../../../assets/audio/v1045/stadium_lineup.mp3")] private static const Clip11:Class;
  [Embed(source="../../../../assets/audio/v1045/victory.mp3")] private static const Clip12:Class;
  [Embed(source="../../../../assets/audio/v1045/hero_home_run.mp3")] private static const Clip13:Class;
  [Embed(source="../../../../assets/audio/v1045/grand_slam_story.mp3")] private static const Clip14:Class;
  [Embed(source="../../../../assets/audio/v1045/grand_slam.mp3")] private static const Clip15:Class;
  [Embed(source="../../../../assets/audio/v1045/bases_loaded.mp3")] private static const Clip16:Class;
  [Embed(source="../../../../assets/audio/v1045/sim_hero_in.mp3")] private static const Clip17:Class;
  [Embed(source="../../../../assets/audio/v1045/match_intro.mp3")] private static const Clip18:Class;
  [Embed(source="../../../../assets/audio/v1045/pitch.mp3")] private static const Clip19:Class;
  [Embed(source="../../../../assets/audio/v1045/match_teams.mp3")] private static const Clip20:Class;
  [Embed(source="../../../../assets/audio/v1045/ball_bounce.mp3")] private static const Clip21:Class;
  [Embed(source="../../../../assets/audio/v1045/sim_transition.mp3")] private static const Clip22:Class;
  [Embed(source="../../../../assets/audio/v1045/lineup_select.mp3")] private static const Clip23:Class;
  [Embed(source="../../../../assets/audio/v1045/strike.mp3")] private static const Clip24:Class;
  [Embed(source="../../../../assets/audio/v1045/swing.mp3")] private static const Clip25:Class;
  [Embed(source="../../../../assets/audio/v1045/catch.mp3")] private static const Clip26:Class;
  [Embed(source="../../../../assets/audio/v1045/walk.mp3")] private static const Clip27:Class;
  private static var bank:Object;
  public static function sound(key:String):Sound {
   key=key.replace(".mp3","");if(key=="result_double")key="double";
   if(!bank){bank={};bank["calendar_open"]=new Clip0();bank["plane"]=new Clip1();bank["ball"]=new Clip2();bank["out_hit"]=new Clip3();bank["out_result"]=new Clip4();bank["hero_hit"]=new Clip5();bank["hit_flight"]=new Clip6();bank["double"]=new Clip7();bank["home_run"]=new Clip8();bank["ui_click"]=new Clip9();bank["match_confirm"]=new Clip10();bank["stadium_lineup"]=new Clip11();bank["victory"]=new Clip12();bank["hero_home_run"]=new Clip13();bank["grand_slam_story"]=new Clip14();bank["grand_slam"]=new Clip15();bank["bases_loaded"]=new Clip16();bank["sim_hero_in"]=new Clip17();bank["match_intro"]=new Clip18();bank["pitch"]=new Clip19();bank["match_teams"]=new Clip20();bank["ball_bounce"]=new Clip21();bank["sim_transition"]=new Clip22();bank["lineup_select"]=new Clip23();bank["strike"]=new Clip24();bank["swing"]=new Clip25();bank["catch"]=new Clip26();bank["walk"]=new Clip27();}
   return bank[key] as Sound;
  }
 }
}
