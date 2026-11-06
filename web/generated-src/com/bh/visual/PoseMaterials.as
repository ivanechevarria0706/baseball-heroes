package com.bh.visual {
 /** Materials are expressed along the illustrated bat, never in screen pixels.
  * The same grip/barrel anchors follow all twelve body poses. */
 public class PoseMaterials {
  private static const BATS:Array=[[141,142,300,74],[483,144,645,71],[847,143,1003,68],[1191,142,1328,75],[162,478,100,398],[520,470,446,394],[865,472,794,395],[1276,530,1398,544],[280,842,407,842],[550,786,488,730],[901,808,828,764],[1231,798,1178,739]];
  private static const HANDS:Array=[[115,155,217,213],[461,156,583,215],[821,155,1008,102],[1167,154,1349,130],[155,475,175,514],[520,478,535,505],[862,478,870,509],[1240,530,1255,531],[238,843,258,843],[563,788,577,812],[905,809,918,833],[1230,805,1241,815]];
  public static function bat(theme:int,x:Number,y:Number,frame:int,color:uint):uint {
   if(frame<0)return CostumeArtwork.batPaint(theme,int(x),int(y),color);
   var a:Array=BATS[frame],dx:Number=a[2]-a[0],dy:Number=a[3]-a[1],length:Number=Math.sqrt(dx*dx+dy*dy);
   var along:Number=((x-a[0])*dx+(y-a[1])*dy)/length,across:Number=(-(x-a[0])*dy+(y-a[1])*dx)/length;
   return CostumeArtwork.batPaint(theme,int(along),int(across),color);
  }
  public static function classicBat(name:String,x:Number,y:Number,frame:int,color:uint):uint {
   if(frame<0)return color;var a:Array=BATS[frame],dx:Number=a[2]-a[0],dy:Number=a[3]-a[1],length:Number=Math.sqrt(dx*dx+dy*dy);
   return ClassicWearables.batPaint(name,((x-a[0])*dx+(y-a[1])*dy)/length,(-(x-a[0])*dy+(y-a[1])*dx)/length,length,color);
  }
  public static function batAnchors(frame:int):Array {return BATS[frame].concat();}
  public static function glove(x:Number,y:Number,frame:int):Boolean {
   if(frame<0)return false;var a:Array=HANDS[frame];
   for(var i:int=0;i<4;i+=2){var dx:Number=x-a[i],dy:Number=y-a[i+1];if(dx*dx+dy*dy<625)return true;}return false;
  }
 }
}
