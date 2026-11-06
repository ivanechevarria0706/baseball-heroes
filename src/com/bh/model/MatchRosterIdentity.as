package com.bh.model {
 import com.bh.visual.VisualProfile;
 /** Read-only match actors share the same ordered roster as the scorecard. */
 public class MatchRosterIdentity {
  public static function opponent(rival:Object):Array {
   var pool:Array=MLBNormalPlayers.ids(),players:Array=[],used:Object={};
   // Seed by club (city|team), not by rival.name: opponent objects
   // carry teamName/city, so the old expression always fell back
   // to "Rival" and every club fielded the same nine players.
   var label:String=rival?String((rival.city?rival.city+"|":"")+(rival.teamName||rival.name||"Rival")):"Rival";
   var seed:int=VisualProfile.seed(label),positions:Array=['1B','2B','3B','SS','LF','CF','RF','C','P'];
   // Never field a player who is on the user's roster: the pool is
   // the same 48 normal players the user's own team is built from.
   var owned:Object={};
   for each(var rp:Object in GameData.roster)if(rp&&int(rp.mlbId)>0)owned[int(rp.mlbId)]=true;
   for(var i:int=0;i<9;i++){
    var chosen:Object=null;
    for(var j:int=0;j<pool.length;j++){var id:int=pool[(j+seed%pool.length)%pool.length],c:Object=MLB2026Catalog.entry("card_mlb2026_"+id);if(!used[id]&&!owned[id]&&c&&c.realPosition==positions[i]){chosen=MLBNormalPlayers.make(id);used[id]=true;break;}}
    if(!chosen)for each(id in pool)if(!used[id]&&!owned[id]){chosen=MLBNormalPlayers.make(id);used[id]=true;break;}
    if(!chosen)for each(id in pool)if(!used[id]){chosen=MLBNormalPlayers.make(id);used[id]=true;break;}
    if(!chosen)continue;
    chosen.rating=rival&&rival.rating!==undefined?int(rival.rating)+(i%3)-1:50;players.push(chosen);
   }return players;
  }
  public static function atPosition(players:Array,position:String,fallback:int=0):Object {
   if(players&&players.length){for each(var player:Object in players)if(String(player.pos)==position)return player;return players[(fallback%players.length+players.length)%players.length];}
   for each(var id:int in MLBNormalPlayers.ids()){var p:Object=MLBNormalPlayers.make(id);if(String(p.pos)==position)return p;}
   return MLBNormalPlayers.make(int(MLBNormalPlayers.ids()[0]));
  }
  public static function resolve(player:Object,position:String="P"):Object {
   if(player&&(player.appearance||int(player.mlbId)>0))return player;
   var found:Object=player&&player.name?MLB2026Catalog.named(String(player.name)):null;
   return found?found:atPosition(null,position);
  }
  public static function key(player:Object):String {if(player.specialCardId)return "special:"+player.specialCardId;return int(player.mlbId)>0?"mlb:"+player.mlbId:String(player.name)+":"+JSON.stringify(player.appearance||{});}
 }
}
