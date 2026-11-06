package {
 import flash.display.*;import com.bh.game.PitchCadence;import com.bh.game.BattingSystem;import flash.text.TextField;import flash.external.ExternalInterface;import com.bh.visual.*;import com.bh.model.*;import com.bh.ui.*;import com.bh.core.Game;
 /** Development-only diagnostics; excluded from the deployment allowlist. */
 public class WebUpgrade097 extends WebParity {
  private var result:GameResultPanel;private var gallery:Sprite,skillScreen:SkillScreen,actors:Array=[];
  public function WebUpgrade097(){super();ExternalInterface.addCallback("bhUpgrade",call);}
  private function check(v:Boolean,s:String):void {if(!v)throw new Error(s);}
  private function find(c:DisplayObjectContainer):Game {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d as Game;if(d is DisplayObjectContainer){var g:Game=find(d as DisplayObjectContainer);if(g)return g;}}return null;}
  private function call(action:String="state",value:String=""):String {try{return run(action,value);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}
  private function run(action:String,value:String):String {
   if(action=="skills-model"){
    var hero:Object=GameData.mainPlayer(),oldLevel:int=GameData.level,oldPoints:int=int(hero.skillPoints),oldActive:String=String(hero.activeSkill),oldSkills:Object=JSON.parse(JSON.stringify(hero.skillLevels));
    try {
     GameData.level=1;hero.skillPoints=100;hero.skillLevels={BATTING_EYE:1,POWER_HITTER:0,CLUTCH:0,SPEEDSTER:0};
     check(GameData.upgradeSkill(hero,"CONTACT_MASTER")=="LOCKED"&&hero.skillPoints==100,"level gate preserves points");
     GameData.level=12;check(GameData.upgradeSkill(hero,"CONTACT_MASTER")=="LOCKED","rank prerequisite enforced");
     for each(var id:String in ["BATTING_EYE","POWER_HITTER","CLUTCH","SPEEDSTER"]){hero.skillLevels[id]=2;}
     for each(var skill:Object in SkillCatalog.items()){if(int(hero.skillLevels[skill.id])<1){var before:int=hero.skillPoints;check(GameData.upgradeSkill(hero,skill.id)=="OK"&&hero.skillPoints==before-1,"learn "+skill.id);check(GameData.upgradeSkill(hero,skill.id)=="OK"&&GameData.upgradeSkill(hero,skill.id)=="OK","rank "+skill.id);check(GameData.upgradeSkill(hero,skill.id)=="MAX","bounded rank "+skill.id);}}
     GameData.setActiveSkill(hero,"SLUGGER");check(GameData.skillPowerBonus(hero,1,0,0)==22,"slugger affects power");
     GameData.setActiveSkill(hero,"CONTACT_MASTER");check(GameData.skillContactBonus(hero,1,0,0)==17,"contact master effect");
     GameData.setActiveSkill(hero,"PATIENT_HITTER");check(Math.abs(GameData.skillFoulTolerance(hero)-.36)<.0001,"patient foul effect");
     GameData.setActiveSkill(hero,"BASE_RUNNER");check(Math.abs(GameData.skillTripleBonus(hero)-.06)<.0001,"base runner effect");
     GameData.setActiveSkill(hero,"LINE_DRIVE");check(Math.abs(GameData.skillDoubleBonus(hero)-.09)<.0001,"line drive effect");
     GameData.setActiveSkill(hero,"TEAM_SPIRIT");check(GameData.skillComboBonus(hero)==3,"team combo effect");
     GameData.setActiveSkill(hero,"LUCKY_SWING");check(Math.abs(GameData.skillLuckyChance(hero)-.24)<.0001,"lucky effect");
     GameData.setActiveSkill(hero,"DEFENSE_CAPTAIN");check(Math.abs(GameData.skillDefenseBonus(hero)-.135)<.0001,"captain effect");
     var career:Object=CareerAchievements.normalize({version:1,stats:{singles:149},claims:{"singles:0":true}});check(career.stats.heroAttempts==0&&career.stats.luckyHits==0&&career.claims["singles:0"],"legacy career preserved");
     CareerAchievements.add(career,"heroAttempts",500);CareerAchievements.add(career,"luckyHits",25);check(CareerAchievements.claim(career,"heroAttempts",0).status=="OK"&&CareerAchievements.claim(career,"heroAttempts",0).status=="CLAIMED","hardworking reward once");check(CareerAchievements.claim(career,"luckyHits",0).status=="OK","lucky award");
     var skillLedger:MatchScoring=new MatchScoring();skillLedger.record("SINGLE",0,true);skillLedger.record("OUT",0,false);skillLedger.record("WALK",0,true);skillLedger.luckyHits=1;var committed:Object=MatchScoring.settle(skillLedger.snapshot(),false,false,[],"Hero",1,0,0,0);check(committed.heroAttempts==2&&committed.luckyHits==1,"new counters settle from actual ledger");
     var item097:Object=GameData.shopItemById("gear097_0_bat"),oldCoins097:int=GameData.coins,oldInventory097:Array=GameData.inventory.concat(),oldEquipment097:Object=JSON.parse(JSON.stringify(GameData.equipped));
     try{
      GameData.level=1;GameData.coins=4500;check(GameData.purchaseShopItem(item097)=="LOCKED"&&GameData.coins==4500,"collector level gate");
      GameData.level=5;GameData.coins=4499;check(GameData.purchaseShopItem(item097)=="COINS"&&GameData.coins==4499,"collector funds gate");
      GameData.coins=4500;check(GameData.purchaseShopItem(item097)=="OK"&&GameData.coins==0,"collector purchase");
      var bought097:Object;for each(var owned097:Object in GameData.inventory)if(owned097.name==item097.name)bought097=owned097;
      check(bought097!=null&&GameData.equipItem(bought097)&&GameData.equipped.bat.name==item097.name,"collector equips");
      check(GameData.purchaseShopItem(item097)=="OWNED"&&GameData.coins==0,"collector permanent ownership");
     }finally{GameData.coins=oldCoins097;GameData.inventory=oldInventory097;GameData.equipped=oldEquipment097;}
     var timing:BattingSystem=new BattingSystem();
     for each(var error:Number in [0,.010,.030,.055,.100]){var expected:String=timing.evaluateTiming(.925+error/.35,60,65,0,.35);check(expected==timing.evaluateTiming(.925+error/.60,60,65,0,.60),"absolute timing windows");}
     check(PitchCadence.duration("FASTBALL",65)<PitchCadence.duration("CHANGEUP",65)&&PitchCadence.duration("FASTBALL",99,0)>=.30,"calibrated duration bounds");
     return JSON.stringify({status:"PASS",skills:SkillCatalog.items().length,achievements:CareerAchievements.catalog().length,catalog:EquipmentCatalog.items().length,legacy:career});
    }finally{GameData.level=oldLevel;hero.skillPoints=oldPoints;hero.activeSkill=oldActive;hero.skillLevels=oldSkills;GameData.save();}
   }
   if(action=="skills"){
    if(skillScreen){skillScreen.dispose();removeChild(skillScreen);skillScreen=null;}
    GameData.level=value=="locked"?1:12;GameData.mainPlayer().skillPoints=20;GameData.mainPlayer().skillLevels={BATTING_EYE:2,POWER_HITTER:2,CLUTCH:2,SPEEDSTER:2};
    skillScreen=new SkillScreen(960,720,GameData.mainPlayer(),function():void{});addChild(skillScreen);return JSON.stringify({status:"OK"});
   }
   if(action=="close-skills"&&skillScreen){skillScreen.dispose();removeChild(skillScreen);skillScreen=null;}
   if(action=="gallery"){
    if(gallery){for each(var actor:* in actors)actor.dispose();actors=[];removeChild(gallery);gallery=null;}
    if(value=="close")return "{}";
    gallery=new Sprite();gallery.name="gallery097-"+value;gallery.graphics.beginFill(0xd3ebf5);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();addChild(gallery);
    var total:int=value=="fielding"?16:value=="home"?4:12;
    for(var f:int=0;f<total;f++){
     var figure:*=value=="fielding"?new FieldingSprite(0x246ba4):value=="runner"?new RunnerSprite(GameData.mainPlayer()):new HeroSprite(String(GameData.mainPlayer().name),GameData.teamAccent,null,value=="home"?"home":"batter",.8);
     figure.setFrame(f);figure.scaleX=figure.scaleY=value=="fielding"?.9:.75;figure.x=110+(f%4)*235;figure.y=145+int(f/4)*178;gallery.addChild(figure);actors.push(figure);
     var label:TextField=new TextField();label.text=String(f);label.x=figure.x;label.y=figure.y+7;gallery.addChild(label);
    }
    return JSON.stringify({status:"OK",poses:total});
   }
   if(action=="model"){
    var energy:Object=AccountEnergy.settle(7,12,"301000",1000);check(energy.energy==7&&energy.at=="301000","not early");
    energy=AccountEnergy.settle(7,12,"301000",901000);check(energy.energy==10&&energy.at=="1201000","elapsed recharge");
    energy=AccountEnergy.settle(7,12,"301000",99999999);check(energy.energy==12&&energy.at=="0","energy cap");
    check(AccountEnergy.settle(15,12,"0",1000).energy==15,"purchased and gifted overflow survives");
    check(AccountEnergy.settle(0,12,"0",1000).at=="301000","old save starts recovery clock");
    var m:MatchMomentum=new MatchMomentum();check(m.gain("OUT")==0&&m.gain("SINGLE")==1&&m.gain("HOME RUN")==2,"event gains");for(var i:int=0;i<9;i++)m.gain("HOME RUN");check(m.charge==10,"max charge");
    m.beginPlate(5,0,4,true);check(m.charge==10&&m.spent==0&&m.tier==3&&m.comeback&&m.contactBonus==8,"MAX survives plate start");check(m.consumeMax()&&m.charge==0&&m.spent==10,"fair contact consumes MAX");m.beginPlate(4,0,4,true);check(!m.comeback&&m.tier==0,"spent boost clears");m.beginPlate(5,4,4,true);check(!m.comeback,"no chance at tie");m.beginPlate(5,0,4,false);check(!m.comeback,"runners required");
    var ledger:MatchScoring=new MatchScoring(),ev:Object=ledger.record("SINGLE",0,true);check(ev.coins==3,"first hit award");ev=ledger.record("DOUBLE",0,true);check(ev.multiplier==3&&ev.coins==9,"two hits x3");ledger.record("OUT",0,false);check(ledger.hitStreak==2,"sim preserves hero streak");ev=ledger.record("HOME RUN",0,true);check(ev.multiplier==5&&ev.coins==40,"bounded streak x5");ledger.record("OUT",0,true);check(ledger.hitStreak==0,"out resets");
    var box:Object=MysteryInventory.create();check(MysteryInventory.recordGame(box,"loss12",false,12,0).coins==500,"special loss reward");check(MysteryInventory.recordGame(box,"loss12",false,12,0).coins==0,"special reward replay");check(MysteryInventory.recordGame(box,"win12",true,12,0).boxes==1,"special win box");check(MysteryInventory.recordGame(box,"ordinary",false,11,0).coins==0,"ordinary no bonus");
    var h:Object=ScoreHistory.normalize(null);ScoreHistory.record(h,{fixtureKey:"one",scoring:{total:1234},leagueIndex:0});ScoreHistory.record(h,{fixtureKey:"one",scoring:{total:9999},leagueIndex:0});check(h.best==1234&&h.matches.length==1,"history idempotency");
    check(EquipmentCatalog.items().length==153,"additive equipment catalog");var basic:int=0;for each(var item:Object in EquipmentCatalog.items())if(item.unlockLevel==4)basic++;check(basic==6,"six first unlocks");
    return JSON.stringify({status:"PASS",energy:energy,combo:m.snapshot(),ledger:ledger.snapshot(),mystery:box,history:h});
   }
   if(action=="special-result"){
    GameData.starterTutorial={version:1,enabled:false,stage:9,skipped:true,claimed:false,hints:{}};
    GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.seasonComplete=false;GameData.leagueIndex=0;GameData.seasonGame=12;if(value=="win")GameData.seasonNumber++;GameData.postSeasonMode=false;GameData.specialMatch=null;GameData.level=3;GameData.maxEnergy=12;GameData.energy=5;GameData.energyAt="0";GameData.levelProgress=GameData.levelXpTarget()-1;GameData.coins=1000;
    for each(var p:Object in GameData.roster)p.condition={energy:6,at:"0"};GameData.save();check(GameData.startSeasonGame()&&GameData.energy==0,"five energy per fixture");var paid:Object=GameData.specialMatch;check(GameData.startSeasonGame()&&GameData.energy==0&&GameData.specialMatch===paid,"reentry free");
    var beforeAttempts:int=int(GameData.hallOfFame.stats.heroAttempts),beforeLucky:int=int(GameData.hallOfFame.stats.luckyHits);
    var raw:Object={points:1000,playCoins:3,playXP:2,heroAttempts:4,luckyHits:1,bestStreak:1,events:[],fixtureKey:paid.key};var s:Object=GameData.completeSeasonGame(value=="win"?5:2,4,1,0,4,0,[2,0,0,0,0,0,0,0,0],[4,0,0,0,0,0,0,0,0],[],raw);
    check(GameData.hallOfFame.stats.heroAttempts==beforeAttempts+4&&GameData.hallOfFame.stats.luckyHits==beforeLucky+1,"new career counters committed");
    check(GameData.level==4&&GameData.energy==13&&s.levelUp.unlocked.length==6,"level four refill and unlock");check(s.mysteryAward.special,"special award flag");check(value=="win"?s.mysteryAward.boxes==1:s.mysteryAward.coins==500,"committed special award");
    var coins:int=GameData.coins;GameData.completeSeasonGame(s.homeScore,s.awayScore,s.hits,s.homeRuns,s.atBats,s.rbi,s.homeLine,s.awayLine,s.boxScore,raw);check(GameData.coins==coins,"final settlement replay");
    check(GameData.hallOfFame.stats.heroAttempts==beforeAttempts+4&&GameData.hallOfFame.stats.luckyHits==beforeLucky+1,"career counter replay");
    if(result){result.dispose();removeChild(result);}result=new GameResultPanel(960,720,s,function():void{});addChild(result);return JSON.stringify(s);
   }
   if(action=="ranking-result"){
    GameData.lastGameSummary.fixtureKey+="-ranking";GameData.lastGameSummary.scoring.total=520710;GameData.lastGameSummary.levelUp=null;GameData.lastGameSummary.mysteryAward=null;GameData.save();
    if(result){result.dispose();removeChild(result);}result=new GameResultPanel(960,720,GameData.lastGameSummary,function():void{});addChild(result);
   }
   if(action=="close-result"&&result){result.dispose();removeChild(result);result=null;}
   if(action=="engine"){var g:Game=find(this);return g?g["qaUpgrade"](value):"{}";}
   return JSON.stringify({skills:GameData.mainPlayer().skillLevels,activeSkill:GameData.mainPlayer().activeSkill,skillPoints:GameData.mainPlayer().skillPoints,energy:GameData.energy,energyAt:GameData.energyAt,maxEnergy:GameData.maxEnergy,history:GameData.scoreHistory,rewardTotal:GameData.scoreRewardTotal,summary:GameData.lastGameSummary,coins:GameData.coins,level:GameData.level});
  }
 }
}
