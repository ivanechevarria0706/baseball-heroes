package com.bh.game {
 import flash.utils.ByteArray;
 /** Presentation only. Input timing and hit probability remain owned by Game. */
 public class SwingMotion {
  public static const CONTACT_MS:int=100,END_MS:int=840;
  [Embed(source="../../../../assets/sprites/v1042/swing.json",mimeType="application/octet-stream")] private static const Data:Class;
  private static var layout:Object;
  public static function pose(index:int):Object {if(!layout){var b:ByteArray=new Data() as ByteArray;layout=JSON.parse(b.readUTFBytes(b.length));}return layout.poses[index];}
  public static function frame(age:int,hold:int=0):int {
   if(age<34)return 4;if(age<67)return 5;if(age<CONTACT_MS)return 17;
   if(age<CONTACT_MS+hold+45)return 6;age-=hold;
   return age<185?18:age<300?19:age<450?20:age<620?21:age<END_MS?22:0;
  }
  public static function planted(frame:int):Boolean {return frame==4||frame==5||frame==6||frame==16||frame==17||frame==18||frame==19||frame==20;}
 }
}
