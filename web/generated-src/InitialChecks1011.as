package {
 import com.bh.model.*;
 /** Only linked into private diagnostic SWFs, never WebMain. */
 public class InitialChecks1011 {
  private static var checks:Array;
  private static function check(ok:Boolean,label:String):void{if(!ok)throw new Error(label);checks.push(label);}
  public static function run():Object {
   checks=[];GameData.resetSave();var hero:Object=GameData.mainPlayer(),name:String=hero.name;
   check(GameData.level==1&&GameData.xp==0&&GameData.leagueIndex==0&&GameData.coins==6000&&GameData.energy==20,"fresh level-one Rookie resources");
   check(GameData.battingOrder[8]==name&&hero.skillPoints==0,"fresh hero bats ninth and earns first point by levelling");
   check(GameData.roster.every(function(p:Object,i:int,a:Array):Boolean{return i==0||p.avg==".200"&&p.careerHits==0&&p.careerAtBats==0;}),"base .200 does not fabricate career hits");
   check(GameData.ownsSpecialCatalog("card_kyle_initial")&&!GameData.specialEquipped[0]&&GameData.equipped.goggles==null,"Kyle starts on bench; no goggles");
   check(GameData.levelXpTarget()==50,"new first-level calibration");
   check(SpecialCardCatalog.gradeAllowed("C","HERO")&&SpecialCardCatalog.gradeAllowed("B","HERO"),"class and grade independent");
   GameData.onboardingStep=99;GameData.seasonGoalSet=true;
   var draw:Object=GameData.drawSpecialClassPack("C");
   check(draw.status=="OK"&&draw.card.catalogId=="card_walker_p"&&draw.card.grade=="HERO"&&GameData.coins==0,"paid tutorial C HERO Walker");
   var cardId:String=String(draw.card.id);GameData.tutorialEvent("open");GameData.tutorialEvent("card");GameData.save();GameData.load();
   check(GameData.starterTutorial.stage==StarterTutorial.SUBSTITUTE&&GameData.ownsSpecialCard(cardId),"paid card and pending drag lesson survive reload");
   check(GameData.substituteBattingOrder(1,GameData.playerByName("Aaron"))=="OK"&&GameData.starterTutorial.stage==StarterTutorial.REORDER,"normal substitution advances lesson");
   GameData.moveBattingOrder(8,0);check(GameData.starterTutorial.stage==StarterTutorial.AUTOSORT,"hero reordering advances separately");
   GameData.save();GameData.load();GameData.autoOptimizeBattingOrder();
   check(GameData.starterTutorial.stage==StarterTutorial.PLAY&&GameData.specialEquipped[0]==cardId&&GameData.battingOrder[2]==name,"auto sort activates Walker and places hero third");
   check(GameData.startSeasonGame(),"fixture reserves");GameData.tutorialEvent("start",GameData.specialMatch.key);
   var energy:int=GameData.energy;check(GameData.startSeasonGame()&&GameData.energy==energy&&GameData.specialCardEnergy(cardId)==1,"fixture reentry charges once");
   var rows:Array=[];for(var i:int=0;i<9;i++){var p:Object=GameData.battingOrderPlayers()[i];rows.push({name:p.name,isHero:p===GameData.mainPlayer(),hits:i==2?5:i==0?4:1,homeRuns:0,rbi:i==2?1:0,atBats:6});}
   var raw:Object={version:4,points:18000,playXP:34,playCoins:109,bestStreak:1,fixtureKey:GameData.specialMatch.key,heroAttempts:6,events:[]};
   var summary:Object=GameData.completeSeasonGame(1,0,16,0,6,1,[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,0,0],rows,raw);
   check(summary.scoring.rank=="D"&&summary.scoring.mvp&&summary.scoring.heroMvp,"observed one-run game gives D and hero MVP");
   check(GameData.xp==79&&GameData.level==2&&GameData.mainPlayer().skillPoints==1,"79 total XP reaches level two and one point");
   var coins:int=GameData.coins,xp:int=GameData.xp;GameData.completeSeasonGame(1,0,16,0,6,1,null,null,rows,raw);
   check(GameData.coins==coins&&GameData.xp==xp,"repeated settlement cannot award twice");
   hero=GameData.mainPlayer();var before:int=hero.contact;check(GameData.allocateHeroStat("contact")&&hero.contact==before+1&&hero.skillInvestment.contact==2&&hero.skillPoints==0,"display investment and engine stat increment together");
   check(GameData.starterTutorial.stage==StarterTutorial.DRAFT,"point leads to draft");
   coins=GameData.coins;check(GameData.claimStarterReward()==40000&&GameData.claimStarterReward()==0&&GameData.coins==coins+40000,"reward credited once before draft closes");
   GameData.save();GameData.load();check(GameData.starterTutorial.stage==StarterTutorial.DRAFT&&GameData.tutorialActive(),"credited draft survives reload without replay");
   GameData.tutorialEvent("draft");GameData.save();GameData.load();check(GameData.starterTutorial.stage==StarterTutorial.REWARD,"mission presentation persists independently of credit");
   GameData.tutorialEvent("reward");GameData.setTeamIdentity("My Chicago",GameData.teamCity,GameData.teamAccent,63);
   check(GameData.starterTutorial.stage==StarterTutorial.TICKETS,"confirmed name advances guide");
   GameData.collectGateIncome();check(!GameData.tutorialActive()&&GameData.collectGateIncome()==0,"tickets finish lesson and cannot double collect");
   var legacy:Object=StarterTutorial.normalize({version:1,enabled:true,stage:3,cardId:"old",claimed:false});
   check(legacy.lesson==1&&!StarterTutorial.event(legacy,"substitute","other")&&StarterTutorial.event(legacy,"substitute","old")&&legacy.stage==4,"legacy unfinished lesson retains its actions");
   check(!StarterTutorial.active(StarterTutorial.normalize({version:1,enabled:true,stage:8,claimed:true})),"legacy paid reward never reopens");
   GameData.careerStartVersion=3;GameData.level=1;GameData.levelProgress=73;GameData.mainPlayer().skillPoints=7;GameData.friendDraft=["friend-a","friend-b"];
   var oldRoster:String=JSON.stringify(GameData.roster),oldOrder:String=JSON.stringify(GameData.battingOrder);GameData.save();GameData.load();
   check(GameData.levelXpTarget()==180&&GameData.levelProgress==73&&GameData.mainPlayer().skillPoints==7&&JSON.stringify(GameData.roster)==oldRoster&&JSON.stringify(GameData.battingOrder)==oldOrder,"legacy progress, roster, points and order preserved");
   check(GameData.friendDraft.join(",")=="friend-a,friend-b","draft selection persists");
   var mm:MatchMomentum=new MatchMomentum();mm.boost(10);mm.beginPlate(3,0,0,false);mm.gain("STRIKE");check(mm.maxReady,"individual strike retains MAX");mm.strikeout();check(mm.charge==0&&!mm.maxReady,"strikeout clears MAX");
   for each(var c:Array in [[17,9,"S"],[17,6,"A"],[15,3,"B"],[9,2,"C"],[16,1,"D"]])check(MatchScoring.grade(c[0],c[1])==c[2],"observed rank "+c.join("/"));
   return {status:"PASS",checks:checks,total:checks.length};
  }
 }
}
