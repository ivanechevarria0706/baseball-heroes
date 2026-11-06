package com.bh.model {
 import flash.utils.ByteArray;
 /** Dated MLB directory. Game balance is local; class and grade are separate axes. */
 public class MLB2026Catalog {
  [Embed(source="../../../../assets/reference/v1037/directory.json",mimeType="application/octet-stream")] private static const Data:Class;
  private static var entries:Array,batters:Array,index:Object,names:Object;
  private static function prepare():void {
   if(entries)return;var bytes:ByteArray=new Data() as ByteArray;entries=JSON.parse(bytes.readUTFBytes(bytes.length)).players;index={};batters=[];
   names={};for each(var c:Object in entries){c.normalPlayer=MLBNormalPlayers.contains(int(c.mlbId));index[c.id]=c;names[c.name]=c;if(c.role=="BATTER"&&c.artReady&&!c.normalPlayer)batters.push(c);}
  }
  private static function copy(c:Object):Object {if(!c)return null;var result:Object={};for(var key:String in c)result[key]=c[key];return result;}
  public static function directory():Array {prepare();return entries.concat();}
  public static function cards():Array {prepare();var result:Array=[];for each(var c:Object in batters)for each(var grade:String in ["A","RARE","ELITE","HERO"])result.push(edition(c,grade));return result;}
  public static function supports(id:String):Boolean {return id!=null&&id.indexOf("card_mlb2026_")==0;}
  public static function entry(id:String):Object {prepare();return copy(index[id]);}
  public static function named(name:String):Object {prepare();return copy(names[name]);}
  public static function byId(id:String):Object {prepare();var parts:Array=id.split("_"),grade:String=parts.length>3?String(parts[3]).toUpperCase():"A",base:String=parts.slice(0,3).join("_"),c:Object=index[base];return c&&c.role=="BATTER"&&c.artReady&&!c.normalPlayer&&["A","RARE","ELITE","HERO"].indexOf(grade)>=0?edition(c,grade):null;}
  private static function edition(c:Object,grade:String):Object {var result:Object=copy(c);result.grade=grade;if(grade!="A")result.id=c.id+"_"+grade.toLowerCase();return result;}
  public static function price(c:Object):int {return c.normalPlayer?1500:c.cardClass=="S"?60000:c.cardClass=="A"?30000:c.cardClass=="B"?10000:5000;}
  public static function league(c:Object):int {return c.cardClass=="S"?4:c.cardClass=="A"?3:c.cardClass=="B"?2:0;}
 }
}
