package {
 import flash.display.*;import flash.external.ExternalInterface;import com.bh.model.*;import com.bh.ui.*;import com.bh.core.Game;
 /** Development-only diagnostics; excluded from the deployment allowlist. */
 public class WebUpgrade096 extends WebParity {
  private var result:GameResultPanel;
  public function WebUpgrade096(){super();ExternalInterface.addCallback("bhUpgrade",call);}
  private function check(v:Boolean,s:String):void {if(!v)throw new Error(s);}
  private function find(c:DisplayObjectContainer):Game {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d as Game;if(d is DisplayObjectContainer){var g:Game=find(d as DisplayObjectContainer);if(g)return g;}}return null;}
  private function call(action:String="state",value:String=""):String {try{return run(action,value);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}
  private function run(action:String,value:String):String {
   if(action=="model"){
    var energy:Object=AccountEnergy.settle(7,12,"301000",1000);check(energy.energy==7&&energy.at=="301000","not early");
    energy=AccountEnergy.settle(7,12,"301000",901000);check(energy.energy==10&&energy.at=="1201000","elapsed recharge");
    energy=AccountEnergy.settle(7,12,"301000",99999999);check(energy.energy==12&&energy.at=="0","energy cap");
    check(AccountEnergy.settle(15,12,"0",1000).energy==15,"purchased and gifted overflow survives");
    check(AccountEnergy.settle(0,12,"0",1000).at=="301000","old save starts recovery clock");
    var m:MatchMomentum=new MatchMomentum();check(m.gain("OUT")==0&&m.gain("SINGLE")==1&&m.gain("HOME RUN")==2,"event gains");for(var i:int=0;i<9;i++)m.gain("HOME RUN");check(m.charge==10,"max charge");
    m.beginPlate(5,0,4,true);check(m.charge==0&&m.spent==10&&m.tier==3&&m.comeback&&m.contactBonus==8,"boost consumed for one plate");m.beginPlate(4,0,4,true);check(!m.comeback&&m.tier==0,"next plate clears boost");m.beginPlate(5,4,4,true);check(!m.comeback,"no chance at tie");m.beginPlate(5,0,4,false);check(!m.comeback,"runners required");
    var ledger:MatchScoring=new MatchScoring(),ev:Object=ledger.record("SINGLE",0,true);check(ev.coins==3,"first hit award");ev=ledger.record("DOUBLE",0,true);check(ev.multiplier==3&&ev.coins==9,"two hits x3");ledger.record("OUT",0,false);check(ledger.hitStreak==2,"sim preserves hero streak");ev=ledger.record("HOME RUN",0,true);check(ev.multiplier==5&&ev.coins==40,"bounded streak x5");ledger.record("OUT",0,true);check(ledger.hitStreak==0,"out resets");
    var box:Object=MysteryInventory.create();check(MysteryInventory.recordGame(box,"loss12",false,12,0).coins==500,"special loss reward");check(MysteryInventory.recordGame(box,"loss12",false,12,0).coins==0,"special reward replay");check(MysteryInventory.recordGame(box,"win12",true,12,0).boxes==1,"special win box");check(MysteryInventory.recordGame(box,"ordinary",false,11,0).coins==0,"ordinary no bonus");
    var h:Object=ScoreHistory.normalize(null);ScoreHistory.record(h,{fixtureKey:"one",scoring:{total:1234},leagueIndex:0});ScoreHistory.record(h,{fixtureKey:"one",scoring:{total:9999},leagueIndex:0});check(h.best==1234&&h.matches.length==1,"history idempotency");
    check(EquipmentCatalog.items().length==93,"catalog six additions");var basic:int=0;for each(var item:Object in EquipmentCatalog.items())if(item.unlockLevel==4)basic++;check(basic==6,"six first unlocks");
    return JSON.stringify({status:"PASS",energy:energy,combo:m.snapshot(),ledger:ledger.snapshot(),mystery:box,history:h});
   }
   if(action=="special-result"){
    GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.seasonComplete=false;GameData.leagueIndex=0;GameData.seasonGame=12;if(value=="win")GameData.seasonNumber++;GameData.postSeasonMode=false;GameData.specialMatch=null;GameData.level=3;GameData.maxEnergy=12;GameData.energy=5;GameData.energyAt="0";GameData.levelProgress=GameData.levelXpTarget()-1;GameData.coins=1000;
    for each(var p:Object in GameData.roster)p.condition={energy:6,at:"0"};GameData.save();check(GameData.startSeasonGame()&&GameData.energy==0,"five energy per fixture");var paid:Object=GameData.specialMatch;check(GameData.startSeasonGame()&&GameData.energy==0&&GameData.specialMatch===paid,"reentry free");
    var raw:Object={points:1000,playCoins:3,playXP:2,bestStreak:1,events:[],fixtureKey:paid.key};var s:Object=GameData.completeSeasonGame(value=="win"?5:2,4,1,0,4,0,[2,0,0,0,0,0,0,0,0],[4,0,0,0,0,0,0,0,0],[],raw);
    check(GameData.level==4&&GameData.energy==13&&s.levelUp.unlocked.length==6,"level four refill and unlock");check(s.mysteryAward.special,"special award flag");check(value=="win"?s.mysteryAward.boxes==1:s.mysteryAward.coins==500,"committed special award");
    var coins:int=GameData.coins;GameData.completeSeasonGame(s.homeScore,s.awayScore,s.hits,s.homeRuns,s.atBats,s.rbi,s.homeLine,s.awayLine,s.boxScore,raw);check(GameData.coins==coins,"final settlement replay");
    if(result){result.dispose();removeChild(result);}result=new GameResultPanel(960,720,s,function():void{});addChild(result);return JSON.stringify(s);
   }
   if(action=="ranking-result"){
    GameData.lastGameSummary.fixtureKey+="-ranking";GameData.lastGameSummary.scoring.total=520710;GameData.lastGameSummary.levelUp=null;GameData.lastGameSummary.mysteryAward=null;GameData.save();
    if(result){result.dispose();removeChild(result);}result=new GameResultPanel(960,720,GameData.lastGameSummary,function():void{});addChild(result);
   }
   if(action=="close-result"&&result){result.dispose();removeChild(result);result=null;}
   if(action=="engine"){var g:Game=find(this);return g?g["qaUpgrade"](value):"{}";}
   return JSON.stringify({energy:GameData.energy,energyAt:GameData.energyAt,maxEnergy:GameData.maxEnergy,history:GameData.scoreHistory,rewardTotal:GameData.scoreRewardTotal,summary:GameData.lastGameSummary,coins:GameData.coins,level:GameData.level});
  }
 }
}
