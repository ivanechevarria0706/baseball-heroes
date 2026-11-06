package com.bh.model {
 import flash.utils.ByteArray;
 /** Permanent class-C teammates. Their game statistics start at zero, not MLB totals. */
 public class MLBNormalPlayers {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1038/normal-players.json",mimeType="application/octet-stream")] private static const Data:Class;
  private static var data:Object,offered:Object={};
  public static function resetOffers():void {offered={};}
  private static function config():Object {if(!data){var bytes:ByteArray=new Data() as ByteArray;data=JSON.parse(bytes.readUTFBytes(bytes.length));}return data;}
  public static function contains(id:int):Boolean {return config().players.indexOf(id)>=0;}
  public static function pitcherNames():Array {var names:Array=[];for each(var id:int in config().players){var c:Object=MLB2026Catalog.entry("card_mlb2026_"+id);if(c&&c.role=="PITCHER")names.push(c.name);}return names;}
  public static function ids():Array {return config().players.concat();}
  public static function make(id:int,tier:String="BRONZE"):Object {
   var c:Object=MLB2026Catalog.entry("card_mlb2026_"+id);if(!c||!contains(id))return null;
   var boost:int=tier=="PREMIUM"?8:tier=="GOLD"?4:0;
   var pow:int=Math.min(65,Math.max(42,int(c.role=="PITCHER"?c.pitchStuff:c.power)*.72+10))+boost;
   var con:int=Math.min(65,Math.max(42,int(c.role=="PITCHER"?c.pitchControl:c.contact)*.72+10))+boost;
   var speed:int=Math.min(65,Math.max(42,int(c.role=="PITCHER"?c.pitchStamina:c.speed)*.72+10))+boost;
   var p:Object=GameData.player(c.name,c.realPosition,1,pow,con,speed,".200",0,0,Math.round((pow+con+speed)/3),"NORMAL",uint(c.accent));
   p.id="normal_mlb2026_"+id;p.mlbId=id;p.normalPlayer=true;p.sourceClass="C";p.realTeam=c.realTeam;p.teamCode=c.teamCode;
   p.baseAverage=".200";p.skillPoints=0;return p;
  }
  public static function starters():Array {resetOffers();var rows:Array=[];for each(var id:int in config().starters)rows.push(make(id));return rows;}
  public static function candidate(tier:String):Object {
   var available:Array=[];for each(var id:int in config().players){var owned:Boolean=false;for each(var p:Object in GameData.roster)if(int(p.mlbId)==id){owned=true;break;}if(!owned&&!offered[id])available.push(id);}
   if(!available.length)return null;id=available[int(Math.random()*available.length)];offered[id]=true;return make(id,tier);
  }
  public static function owned(id:int):Boolean {for each(var p:Object in GameData.roster)if(int(p.mlbId)==id)return true;return false;}
 }
}
