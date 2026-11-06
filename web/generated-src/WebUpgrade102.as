package {
 import flash.display.*;import flash.external.ExternalInterface;import flash.geom.*;
 import com.bh.model.*;import com.bh.ui.GameResultPanel;import com.bh.visual.*;
 /** Test-only scenarios. Never included in the production package. */
 public class WebUpgrade102 extends WebUpgrade101 {
  [Embed(source="../../assets/sprites/v100/pitcher-body-atlas.png")] private static const PitchAtlas:Class;
  [Embed(source="../../assets/sprites/v097/fielding-body-atlas.png")] private static const FieldAtlas:Class;
  private var result102:GameResultPanel,gallery102:Sprite,actor102:PitcherBodySprite,field102:FieldingSprite;
  public function WebUpgrade102(){super();ExternalInterface.addCallback("bh102",call102);}
  private function check102(v:Boolean,s:String):void {if(!v)throw new Error(s);}
  private function call102(action:String="model",kind:String=""):String {try{return run102(action,kind);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}
  private function rows102():Array {var rows:Array=[];for(var i:int=0;i<9;i++)rows.push({slot:i,name:i==2?String(GameData.mainPlayer().name):"Player "+i,isHero:i==2,accent:0x287ab2,hits:i==2?2:i==8?1:2,homeRuns:i==2?1:0,rbi:i==2?3:i==6?3:0,atBats:4});return rows;}
  private function run102(action:String,kind:String):String {
   if(action=="model"){
    var rows:Array=rows102(),raw:Object={points:242710,bestStreak:3,playCoins:270,playXP:80,heroAttempts:5,luckyHits:1,events:[]},hero:String=String(GameData.mainPlayer().name);
    var s:Object=MatchScoring.settle(raw,true,false,rows,hero,17,1,9,9);check102(s.rank=="S"&&s.mvp&&s.perfect&&s.rewardXp==100&&s.rewardCoins==1170,"full objective payout matches reference 100 XP / 1170 C incl 270 plays");
    var c:int=0,x:int=0;for each(var part:Object in s.breakdown){c+=part.coins;x+=part.xp;}check102(c==900&&x==100,"fixed objective rewards sum");
    rows[2].rbi=2;s=MatchScoring.settle(raw,true,false,rows,hero,17,1,9,9);check102(!s.mvp&&!s.perfect&&s.rewardXp==55,"team RBI cannot award hero MVP");
    rows[2].rbi=3;s=MatchScoring.settle(raw,false,false,rows,hero,17,1,9,9);check102(s.mvp&&!s.perfect&&s.rewardXp==60,"MVP can qualify on loss; BONUS requires win");
    s=MatchScoring.settle(raw,false,true,rows,hero,17,1,9,9,500);check102(s.rewardCoins==0&&s.rewardXp==0&&!s.mvp&&!s.perfect,"postseason replay tie awards nothing");
    s=MatchScoring.settle(raw,true,false,[],hero,17,1,9,9);check102(!s.mvp&&!s.perfect,"legacy missing hero totals no invented MVP");
    rows=rows102();for(var i:int=0;i<9;i++)rows[i].hits=1;rows[2].rbi=2;s=MatchScoring.settle(raw,false,false,rows,hero,9,0,2,2,500);check102(s.rank=="C"&&s.rewardXp==20&&s.rewardCoins==870,"loss GAME plus play and special coins only");
    var ledger:MatchScoring=new MatchScoring();ledger.record("SINGLE",0,true);check102(ledger.playXP==0&&ledger.playCoins==3,"XP awarded at settlement only");
    return JSON.stringify({status:"PASS",perfectCoins:1170,perfectXp:100,rankEvidence:["17 H / 9 R = S","9 H / 2 R = C"],missingHeroNoMvp:true,tiesUnpaid:true});
   }
   if(action=="result"){
    GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.seasonComplete=false;GameData.postSeasonMode=false;GameData.specialMatch=null;GameData.leagueIndex=0;GameData.seasonGame=kind=="loss"?12:1;GameData.seasonNumber++;GameData.energy=GameData.maxEnergy;GameData.coins=1000;GameData.levelProgress=0;GameData.save();
    for each(var player:Object in GameData.roster)player.condition={energy:6,at:"0"};check102(GameData.startSeasonGame(),"paid fixture starts");var key:String=String(GameData.specialMatch.key);rows=rows102();
    if(kind=="loss"){for(i=0;i<9;i++)rows[i].hits=1;rows[2].rbi=2;}
    raw={fixtureKey:key,points:kind=="loss"?105217:242710,playCoins:kind=="loss"?19:270,playXP:80,bestStreak:3,heroAttempts:5,luckyHits:1,events:[]};
    s=GameData.completeSeasonGame(kind=="loss"?2:9,kind=="loss"?4:2,kind=="loss"?9:17,1,36,kind=="loss"?2:9,[0,0,0,0,1,3,2,3,0],[0,0,1,1,0,0,0,0,0],rows,raw);
    var paidCoins:int=GameData.coins,paidXp:int=GameData.xp;GameData.completeSeasonGame(s.homeScore,s.awayScore,s.hits,s.homeRuns,s.atBats,s.rbi,s.homeLine,s.awayLine,s.boxScore,raw);check102(GameData.coins==paidCoins&&GameData.xp==paidXp,"fixture reward commits once");
    if(result102){result102.dispose();removeChild(result102);}result102=new GameResultPanel(960,720,s,function():void{});addChild(result102);return JSON.stringify({summary:s,coins:paidCoins,xp:paidXp,idempotent:true});
   }
   if(action=="close"){if(result102){result102.dispose();removeChild(result102);result102=null;}if(gallery102){actor102.dispose();field102.dispose();removeChild(gallery102);gallery102=null;}}
   if(action=="legacy"){
    s={leagueIndex:0,league:"ROOKIE",season:1,game:1,teamCity:GameData.teamCity,heroName:GameData.mainPlayer().name,opponent:GameData.opponentForGame(1),win:true,homeScore:5,awayScore:2,homeLine:[5],awayLine:[2],boxScore:[],hits:2,homeRuns:1,rbi:2,rewardCoins:3100,rewardXp:200,wins:1,losses:0,rank:1,scoring:{version:2,total:30000,rank:"B",breakdown:[{id:"GAME",points:30000,coins:3100,xp:200,active:true}]}};
    var before:int=GameData.coins;if(result102){result102.dispose();removeChild(result102);}result102=new GameResultPanel(960,720,s,function():void{});addChild(result102);check102(GameData.coins==before,"old result presentation cannot grant rewards");return JSON.stringify(s);
   }
   if(action=="gallery"){
    if(!gallery102){gallery102=new Sprite();gallery102.name="uniform-gallery";gallery102.graphics.beginFill(0xd4edf1);gallery102.graphics.drawRect(0,0,960,720);gallery102.graphics.endFill();actor102=new PitcherBodySprite(0x166faf);actor102.warmAll();actor102.scaleX=actor102.scaleY=3;actor102.x=280;actor102.y=530;gallery102.addChild(actor102);field102=new FieldingSprite(0x166faf);field102.warmAll();field102.scaleX=field102.scaleY=3;field102.x=680;field102.y=530;gallery102.addChild(field102);addChild(gallery102);}actor102.setFrame(int(kind)%24);field102.setFrame(int(kind)%16);
   }
   if(action=="tint"){
    var mismatches:int=0,checked:int=0,maxDiff:int=0,samples:Array=[];
    for each(var red:Boolean in [true,false]){
     var source:BitmapData=Bitmap(red?new PitchAtlas():new FieldAtlas()).bitmapData;
     var boxes:Array=red?[[59,56,187,211],[783,563,210,196]]:[[26,58,230,190],[1106,915,182,231]];
     for each(var box:Array in boxes){var original:BitmapData=new BitmapData(box[2],box[3],true,0);original.copyPixels(source,new Rectangle(box[0],box[1],box[2],box[3]),new Point());var fast:BitmapData=original.clone();UniformTint.apply(fast,0x166faf,red);
      for(var yy:int=0;yy<original.height;yy++)for(var xx:int=0;xx<original.width;xx++){
       var q:uint=original.getPixel32(xx,yy),a:int=q>>>24,r:int=(q>>16)&255,g:int=(q>>8)&255,b:int=q&255,expected:uint=q;
       if(red&&a<40)expected=0;else if(red?r>g*2.2&&r>b*2.2&&r>60:a>16&&b>r*1.3&&b>g*1.12&&b>35){var d:Number=(r+g+b)/3-(red?85:65);expected=(q&0xff000000)|(int(Math.max(0,Math.min(255,22+d)))<<16)|(int(Math.max(0,Math.min(255,111+d)))<<8)|int(Math.max(0,Math.min(255,175+d)));}
       var actual:uint=fast.getPixel32(xx,yy),diff:int=Math.max(Math.abs(int(actual>>>24)-int(expected>>>24)),Math.abs(int((actual>>16)&255)-int((expected>>16)&255)),Math.abs(int((actual>>8)&255)-int((expected>>8)&255)),Math.abs(int(actual&255)-int(expected&255)));
       checked++;if(diff>4){mismatches++;if(samples.length<8)samples.push({red:red,x:xx,y:yy,original:q.toString(16),expected:expected.toString(16),actual:actual.toString(16)});}maxDiff=Math.max(maxDiff,diff);
      }original.dispose();fast.dispose();
     }source.dispose();
    }
    return JSON.stringify({status:mismatches<checked*.003?"PASS":"FAIL",checked:checked,mismatches:mismatches,maxDiff:maxDiff,samples:samples});
   }
   return JSON.stringify({coins:GameData.coins,xp:GameData.xp,summary:GameData.lastGameSummary});
  }
 }
}
