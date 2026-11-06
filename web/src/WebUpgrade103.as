package {

 import flash.display.*;import flash.external.ExternalInterface;import flash.geom.*;

 import com.bh.model.*;import com.bh.game.*;import com.bh.core.Game;import com.bh.ui.GameResultPanel;import com.bh.visual.*;import flash.events.Event;

 /** Test-only scenarios. Never included in the production package. */

 public class WebUpgrade103 extends WebUpgrade101 {

  [Embed(source="../../assets/sprites/v100/pitcher-body-atlas.png")] private static const PitchAtlas:Class;

  [Embed(source="../../assets/sprites/v097/fielding-body-atlas.png")] private static const FieldAtlas:Class;

  private var result103:GameResultPanel,gallery103:Sprite,actor103:PitcherBodySprite,field103:FieldingSprite;
  private var wear103:Sprite,wearActors103:Array=[];

  public function WebUpgrade103(){super();ExternalInterface.addCallback("bh103",call103);}

  private function check103(v:Boolean,s:String):void {if(!v)throw new Error(s);}

  private function call103(action:String="model",kind:String=""):String {try{return run103(action,kind);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}

  private function find103(c:DisplayObjectContainer):Game {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d as Game;if(d is DisplayObjectContainer){var g:Game=find103(d as DisplayObjectContainer);if(g)return g;}}return null;}

  private function rows103():Array {var rows:Array=[];for(var i:int=0;i<9;i++)rows.push({slot:i,name:i==2?String(GameData.mainPlayer().name):"Player "+i,isHero:i==2,accent:0x287ab2,hits:i==2?2:i==8?1:2,homeRuns:i==2?1:0,rbi:i==2?3:i==6?3:0,atBats:4});return rows;}

  private function run103(action:String,kind:String):String {
   if(action=="animation"){
    var clock103:int=0,clockFn103:Function=function():int{return clock103;},swingFrames103:Array=[];
    for each(var aim103:int in [-116,-80,-48]){clock103=0;var swing103:ClassicBatter=new ClassicBatter(0,0,0x287ab2,8,"QA swing",clockFn103,false);swing103.swing(aim103);
     for each(var age103:int in [0,20,35,80,130,180,250,500,800,1100,1340]){clock103=age103;swing103.dispatchEvent(new Event(Event.ENTER_FRAME));var body103:DisplayObject=DisplayObjectContainer(swing103.getChildByName("hero-upper")).getChildByName("batter-sprite");check103(!isNaN(body103.rotation)&&Math.abs(body103.rotation)<=18,"finite aim at extremes");if(aim103==-80)swingFrames103.push({at:age103,frame:swing103.frameIndex});}swing103.dispose();}
    check103(swingFrames103[6].frame!=swingFrames103[7].frame&&swingFrames103[7].frame!=swingFrames103[8].frame,"follow-through moves across 250/500/800ms");return JSON.stringify({status:"PASS",aims:[-116,-80,-48],frames:swingFrames103});
   }
   if(action=="wear"){
    for each(var oldActor:HeroSprite in wearActors103)oldActor.dispose();wearActors103=[];if(wear103)removeChild(wear103);
    wear103=new Sprite();wear103.graphics.beginFill(0xd5eef2);wear103.graphics.drawRect(0,0,960,720);wear103.graphics.endFill();var gear103:Object={};
    for each(var gearItem:Object in GameData.shopCatalog())if(CostumeArtwork.theme(gearItem)==int(kind))gear103[gearItem.slot]=gearItem;
    var hero103:Object=GameData.mainPlayer();for(var pose103:int=0;pose103<4;pose103++){var worn:HeroSprite=new HeroSprite(String(hero103.name),0x287ab2,hero103.appearance,pose103==0?"home":"batter",.8,gear103,true);worn.setFrame(int([0,0,6,20][pose103]));worn.x=145+pose103*220;worn.y=570;wear103.addChild(worn);wearActors103.push(worn);}addChild(wear103);return JSON.stringify({status:"PASS",theme:kind,poses:["home","stance","contact","follow-through"],gear:gear103});
   }
   if(action=="close"){for each(oldActor in wearActors103)oldActor.dispose();wearActors103=[];if(wear103){removeChild(wear103);wear103=null;}}

   if(action=="pitch")return find103(this)["qaCadence103"](kind);

   if(action=="runner-pixels"){var runnerTest103:RunnerSprite=new RunnerSprite(GameData.mainPlayer());var runnerReport103:Object=runnerTest103["qaPalette103"]();runnerTest103.dispose();return JSON.stringify(runnerReport103);}
   if(action=="pixels"){var paletteActor:HeroSprite=new HeroSprite("QA palette",0x287ab2,null,"batter",1,{});var report:Object=paletteActor["qaPalette103"]();paletteActor.dispose();return JSON.stringify(report);}

   if(action=="cadence"){

    var table:Array=[],types:Array=["FASTBALL","CURVEBALL","CHANGEUP","SLIDER","SINKER","CUTTER"],tests:int=0,battingModel:BattingSystem=new BattingSystem();

    for each(var type:String in types){var durations:Array=[];for(var l:int=0;l<5;l++){var flight:Number=PitchCadence.duration(type,65,.5,l);durations.push(flight);check103(flight>0&&flight<1.3,"bounded pitch");if(l)check103(flight<durations[l-1],"progressive league speed");tests++;}table.push({type:type,seconds:durations});}

    check103(PitchCadence.duration("FASTBALL",65,.5,0)>.78,"Rookie fastball reaction time");

    check103(battingModel.evaluateTiming(BattingSystem.IDEAL_CONTACT+.06/.7875,64,65,0,.7875)=="GOOD","Rookie good window allows 60 ms");

    check103(battingModel.evaluateTiming(BattingSystem.IDEAL_CONTACT+.06/.35,64,65,4,.35)!="GOOD","Majors retains tighter timing");

    return JSON.stringify({status:"PASS",table:table,cases:tests,rookieGood60ms:true});

   }

   if(action=="model"){

    var rows:Array=rows103(),raw:Object={version:4,points:242710,bestStreak:3,playCoins:270,playXP:39,heroAttempts:5,luckyHits:1,events:[]},hero:String=String(GameData.mainPlayer().name);

    var s:Object=MatchScoring.settle(raw,true,false,rows,hero,17,1,9,9);check103(s.rank=="S"&&s.mvp&&s.perfect&&s.rewardXp==139&&s.rewardCoins==1170,"full objective payout matches reference 100 XP / 1170 C incl 270 plays");

    var c:int=0,x:int=0;for each(var part:Object in s.breakdown){c+=part.coins;x+=part.xp;}check103(c==900&&x==100,"fixed objective rewards sum");

    rows[2].rbi=2;s=MatchScoring.settle(raw,true,false,rows,hero,17,1,9,9);check103(!s.mvp&&!s.perfect&&s.rewardXp==94,"team RBI cannot award hero MVP");

    rows[2].rbi=3;s=MatchScoring.settle(raw,false,false,rows,hero,17,1,9,9);check103(s.mvp&&!s.perfect&&s.rewardXp==99,"MVP can qualify on loss; BONUS requires win");

    s=MatchScoring.settle(raw,false,true,rows,hero,17,1,9,9,500);check103(s.rewardCoins==0&&s.rewardXp==0&&!s.mvp&&!s.perfect,"postseason replay tie awards nothing");

    s=MatchScoring.settle(raw,true,false,[],hero,17,1,9,9);check103(!s.mvp&&!s.perfect,"legacy missing hero totals no invented MVP");

    rows=rows103();for(var i:int=0;i<9;i++)rows[i].hits=1;rows[2].rbi=2;s=MatchScoring.settle(raw,false,false,rows,hero,9,0,2,2,500);check103(s.rank=="C"&&s.rewardXp==59&&s.rewardCoins==870,"loss GAME plus play and special coins only");

    var ledger:MatchScoring=new MatchScoring();ledger.record("SINGLE",0,true);check103(ledger.playXP==2&&ledger.playCoins==3,"provisional play XP");

    var legacyRaw:Object={version:3,points:1,playCoins:1,playXP:80};s=MatchScoring.settle(legacyRaw,false,false,[],hero,0,0,0,0);check103(s.rewardXp==20&&s.playXP==0,"old ledger cannot retroactively pay XP");

    ledger.record("HOME RUN",1,true);ledger.record("WALK",0,false);ledger.record("OUT",0,false);check103(ledger.playXP==8,"play XP total excludes outs");

    return JSON.stringify({status:"PASS",perfectCoins:1170,perfectXp:139,rankEvidence:["17 H / 9 R = S","9 H / 2 R = C"],missingHeroNoMvp:true,tiesUnpaid:true});

   }

   if(action=="result"){

    GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.seasonComplete=false;GameData.postSeasonMode=false;GameData.specialMatch=null;GameData.leagueIndex=0;GameData.seasonGame=kind=="loss"?12:1;GameData.seasonNumber++;GameData.energy=GameData.maxEnergy;GameData.coins=1000;GameData.levelProgress=0;GameData.save();

    for each(var player:Object in GameData.roster)player.condition={energy:6,at:"0"};check103(GameData.startSeasonGame(),"paid fixture starts");var key:String=String(GameData.specialMatch.key);rows=rows103();

    if(kind=="loss"){for(i=0;i<9;i++)rows[i].hits=1;rows[2].rbi=2;}

    raw={version:4,fixtureKey:key,points:kind=="loss"?105217:242710,playCoins:kind=="loss"?19:270,playXP:39,bestStreak:3,heroAttempts:5,luckyHits:1,events:[]};

    s=GameData.completeSeasonGame(kind=="loss"?2:9,kind=="loss"?4:2,kind=="loss"?9:17,1,36,kind=="loss"?2:9,[0,0,0,0,1,3,2,3,0],[0,0,1,1,0,0,0,0,0],rows,raw);

    var paidCoins:int=GameData.coins,paidXp:int=GameData.xp;GameData.completeSeasonGame(s.homeScore,s.awayScore,s.hits,s.homeRuns,s.atBats,s.rbi,s.homeLine,s.awayLine,s.boxScore,raw);check103(GameData.coins==paidCoins&&GameData.xp==paidXp,"fixture reward commits once");

    if(result103){result103.dispose();removeChild(result103);}result103=new GameResultPanel(960,720,s,function():void{});addChild(result103);return JSON.stringify({summary:s,coins:paidCoins,xp:paidXp,idempotent:true});

   }

   if(action=="close"){if(result103){result103.dispose();removeChild(result103);result103=null;}if(gallery103){actor103.dispose();field103.dispose();removeChild(gallery103);gallery103=null;}}

   if(action=="legacy"){

    s={leagueIndex:0,league:"ROOKIE",season:1,game:1,teamCity:GameData.teamCity,heroName:GameData.mainPlayer().name,opponent:GameData.opponentForGame(1),win:true,homeScore:5,awayScore:2,homeLine:[5],awayLine:[2],boxScore:[],hits:2,homeRuns:1,rbi:2,rewardCoins:3100,rewardXp:200,wins:1,losses:0,rank:1,scoring:{version:2,total:30000,rank:"B",breakdown:[{id:"GAME",points:30000,coins:3100,xp:200,active:true}]}};

    var before:int=GameData.coins;if(result103){result103.dispose();removeChild(result103);}result103=new GameResultPanel(960,720,s,function():void{});addChild(result103);check103(GameData.coins==before,"old result presentation cannot grant rewards");return JSON.stringify(s);

   }

   if(action=="gallery"){

    if(!gallery103){gallery103=new Sprite();gallery103.name="uniform-gallery";gallery103.graphics.beginFill(0xd4edf1);gallery103.graphics.drawRect(0,0,960,720);gallery103.graphics.endFill();actor103=new PitcherBodySprite(0x166faf);actor103.warmAll();actor103.scaleX=actor103.scaleY=3;actor103.x=280;actor103.y=530;gallery103.addChild(actor103);field103=new FieldingSprite(0x166faf);field103.warmAll();field103.scaleX=field103.scaleY=3;field103.x=680;field103.y=530;gallery103.addChild(field103);addChild(gallery103);}actor103.setFrame(int(kind)%24);field103.setFrame(int(kind)%16);

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

