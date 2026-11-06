package com.bh.model {
 /** Expanded remake branches. Only the old four IDs predate this catalog;
  * names, gates, dependencies and new effects are reconstruction, not server data. */
 public class SkillCatalog {
  public static function items():Array {return [
   entry("BATTING_EYE","Batting Eye","BATTING EYE","CONTACT",0x43b7df,1,"",0,"Widens the good contact window.","CONTACT +7 / +11 / +15"),
   entry("POWER_HITTER","Power Hitter","POWER HIT","POWER",0xf07945,1,"",0,"Increases power and the chance to score on solid contact.","POWER +7 / +10 / +13"),
   entry("CLUTCH","Clutch","CLUTCH","TEAM",0xd66ca5,1,"",0,"Boosts contact and power from the third inning when you are not ahead.","CONTACT +8 / +12 / +16"),
   entry("SPEEDSTER","Speedster","SPEEDSTER","TEAM",0x8bc744,1,"",0,"Reduces the opposing team's scoring pressure.","DEFENSE +3.5% / +7% / +10.5%"),
   entry("PATIENT_HITTER","Patient Hitter","PATIENT","CONTACT",0x43b7df,5,"BATTING_EYE",1,"Turns more near misses into fouls; does not widen PERFECT.","FOUL WINDOW +12% / +24% / +36%"),
   entry("LINE_DRIVE","Line Drive","LINE DRIVE","POWER",0xf07945,6,"POWER_HITTER",1,"Favors doubles after a successful hit.","DOUBLE CHANCE +3% / +6% / +9%"),
   entry("TEAM_SPIRIT","Team Spirit","TEAM SPIRIT","TEAM",0x8bc744,8,"CLUTCH",1,"Hero hits charge more team combo.","COMBO +1 / +2 / +3 per hit"),
   entry("LUCKY_SWING","Lucky Swing","LUCKY SWING","LUCK",0xe6bd3b,5,"BATTING_EYE",1,"Enables Lucky Hit after a successful hit. Does not turn an out into a hit.","LUCKY EFFECT 8% / 16% / 24%"),
   entry("CONTACT_MASTER","Contact Master","CONTACT MASTER","CONTACT",0x43b7df,12,"BATTING_EYE",2,"Contact specialization with a larger bonus per rank.","CONTACT +9 / +13 / +17"),
   entry("SLUGGER","Slugger","SLUGGER","POWER",0xf07945,12,"POWER_HITTER",2,"Power specialization for longer hits.","POWER +12 / +17 / +22"),
   entry("BASE_RUNNER","Base Runner","BASE RUNNER","TEAM",0x8bc744,10,"SPEEDSTER",1,"Favors triples after a successful hit.","TRIPLE CHANCE +2% / +4% / +6%"),
   entry("DEFENSE_CAPTAIN","Defense Captain","DEFENSE CAPTAIN","TEAM",0x8bc744,12,"SPEEDSTER",2,"Defense specialization to reduce the opponent's scoring.","DEFENSE +4.5% / +9% / +13.5%")
  ];}
  private static function entry(id:String,title:String,short:String,branch:String,accent:uint,level:int,requires:String,rank:int,description:String,effect:String):Object {
   return {id:id,name:title,shortName:short,branch:branch,accent:accent,unlockLevel:level,requires:requires,requiresRank:rank,maxLevel:3,description:description,effect:effect};
  }
  public static function cost(rank:int):int {return rank<=0?1:rank;}
  public static function locked(item:Object,hero:Object,level:int):String {
   if(level<int(item.unlockLevel))return "Requires level "+item.unlockLevel;
   if(item.requires&&(!hero.skillLevels||int(hero.skillLevels[item.requires])<int(item.requiresRank)))return String(item.requires).replace(/_/g," ")+" Lv."+item.requiresRank;
   return "";
  }
 }
}
