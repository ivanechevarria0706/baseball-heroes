package com.bh.game {
 /** Local difficulty calibration. Advanced reference samples are too short
  * for a new player's Rookie learning curve; no recovered server speed table. */
 public class PitchCadence {
  public static const RELEASE_DELAY:Number=.96;
  private static const BASE:Object={FASTBALL:.35,CURVEBALL:.49,CHANGEUP:.54,SLIDER:.44,SINKER:.39,CUTTER:.36};
  private static const LEAGUE_SCALE:Array=[2.35,1.85,1.5,1.2,1];
  public static function duration(type:String,rating:int,random:Number=.5,leagueIndex:int=4):Number {
   var league:int=Math.max(0,Math.min(4,leagueIndex));
   var base:Number=BASE[type]===undefined?.39:Number(BASE[type]);
   random=isNaN(random)?.5:Math.max(0,Math.min(1,random));
   var advanced:Number=Math.max(.30,base-Math.max(0,Math.min(99,rating)-65)*.0015+(random-.5)*.016);
   var seconds:Number=advanced*Number(LEAGUE_SCALE[league]);
   // Rookie remains slower than Single-A, with a readable change of pace.
   // This is playtesting calibration, not a recovered historical speed table.
   return league==0?Math.max(.82,Math.min(1.26,seconds)):seconds;
  }
 }
}
