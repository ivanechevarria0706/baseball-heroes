package com.bh.model {
 public class HeroStyleCatalog {
  public static const ORIGINAL_COUNT:int=8,COUNT:int=16;
  private static const ORIGINAL:Array=["Wavy","Crop","Spiky","Fringe","Curls","Swept Back","Parted","Braids"];
  private static const MALE:Array=["Bald","Buzz Fade","Dreadlocks","Top Knot","Afro","Side Fade","Long Waves","Full Beard"];
  private static const FEMALE:Array=["High Pony","Twin Braids","Space Buns","Pixie","Angular Bob","Long Curls","Braided Bun","Undercut"];
  public static function style(a:Object):int {return Math.max(0,Math.min(COUNT-1,a?int(a.avatarStyle):0));}
  public static function nameFor(n:int,gender:String="M"):String {n=Math.max(0,Math.min(COUNT-1,n));return n<ORIGINAL_COUNT?ORIGINAL[n]:(gender=="F"?FEMALE:MALE)[n-ORIGINAL_COUNT];}
 }
}
