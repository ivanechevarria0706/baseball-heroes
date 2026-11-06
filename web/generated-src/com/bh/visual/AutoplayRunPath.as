package com.bh.visual {
 import flash.geom.Point;
 /** Logical base distances do not depend on render cadence or playback speed. */
 public class AutoplayRunPath {
  private static const PATH:Array=[[112,201],[185,139],[112,101],[39,139],[112,201]];
  public static function point(distance:Number):Point {var d:Number=Math.max(0,Math.min(4,distance)),i:int=Math.min(3,int(d)),p:Number=d-i;return new Point(PATH[i][0]+(PATH[i+1][0]-PATH[i][0])*p,PATH[i][1]+(PATH[i+1][1]-PATH[i][1])*p);}
  public static function bases():Array {return [point(0),point(1),point(2),point(3)];}
 }
}
