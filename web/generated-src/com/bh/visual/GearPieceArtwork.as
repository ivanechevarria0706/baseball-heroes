package com.bh.visual {
 import flash.display.*;import flash.geom.*;
 /** Individual accessories from the original 11_11 sheet, with separate alpha bounds. */
 public class GearPieceArtwork extends Sprite {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/equipment092/sheet.png")] private static const Sheet:Class;
  private static var source:BitmapData,cache:Object={};
  public static const THEMES:Array=["BOSS","TIGER","ALL STAR","ARCTIC","PUMPKIN","SKELETON","ZOMBIE","MUMMY","RUDOLPH","STEAM","ROBOT","MECHA"];
  private static const HEADS:Array=[[40,284,125,82],[262,285,117,81],[477,285,120,83],[695,284,115,85],[41,591,127,127],[262,628,117,91],[477,628,122,91],[695,626,119,91],[29,949,146,110],[262,965,118,94],[477,963,120,97],[695,962,117,96]];
  private static const EYES:Array=[[57,367,91,34],[276,364,91,37],[491,365,91,36],[711,365,91,38],[56,705,93,37],[275,712,91,40],[491,708,93,42],[708,710,93,39],[57,1040,93,43],[276,1040,91,44],[492,1040,92,44],[709,1040,92,43]];
  private static const SHOES:Array=[[43,509,110,36],[263,508,112,42],[480,509,109,38],[695,510,110,39],[42,851,111,37],[260,850,115,38],[479,851,112,37],[698,849,110,39],[39,1190,115,39],[260,1184,116,42],[479,1183,112,44],[697,1181,111,46]];
  private static const BELTS:Array=[[74,458,35,24],[293,456,37,31],[496,458,59,23],[719,458,36,27],[75,795,40,25],[294,795,38,27],[500,795,39,26],[719,798,41,25],[77,1133,37,28],[292,1130,38,29],[500,1129,39,31],[714,1120,46,32]];
  private static const GLOVES:Array=[[121,475,23,35],[340,475,26,35],[556,475,27,36],[776,475,27,39],[124,813,29,40],[340,812,29,42],[558,812,27,43],[775,812,29,43],[123,1148,32,42],[340,1148,31,42],[556,1145,29,41],[778,1143,31,44]];
  public static function supports(name:String):Boolean {return name.indexOf("COLLECTOR ")==0;}
  public function GearPieceArtwork(name:String,slot:String,size:Number=72){mouseEnabled=mouseChildren=false;if(!source)source=Bitmap(new Sheet()).bitmapData;var index:int=0;for(var i:int=0;i<THEMES.length;i++)if(name.indexOf("COLLECTOR "+THEMES[i]+" ")==0){index=i;break;}
   var key:String=slot+":"+index,r:Array=slot=="helmet"?HEADS[index]:slot=="goggles"?EYES[index]:slot=="belt"?BELTS[index]:slot=="glove"?GLOVES[index]:SHOES[index];
   if(!cache[key]){var b:BitmapData=new BitmapData(r[2],r[3],true,0);b.copyPixels(source,new Rectangle(r[0],r[1],r[2],r[3]),new Point());cache[key]=b;}
   var image:Bitmap=new Bitmap(cache[key],"auto",true);image.scaleX=image.scaleY=Math.min(size/r[2],size/r[3]);image.x=-image.width*.5;image.y=-image.height*.5;addChild(image);
  }
 }
}
