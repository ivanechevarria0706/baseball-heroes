package {
 import flash.display.*;import flash.external.ExternalInterface;import flash.geom.*;
 import com.bh.model.*;import com.bh.visual.*;import com.bh.game.*;import com.bh.ui.*;
 /** Local diagnostic only. Never included in the deployment allowlist. */
 public class WebImprovements extends WebParity {
  private var overlay:Sprite,actors:Array=[];
  public function WebImprovements(){super();ExternalInterface.addCallback("bhImprovements",call);}
  private function check(ok:Boolean,msg:String):void {if(!ok)throw new Error(msg);}
  private function clear():void {for each(var a:* in actors)a.dispose();actors=[];if(overlay){removeChild(overlay);overlay=null;}}
  private function label(s:String,x:Number,y:Number,w:Number=210):void {ClassicInventorySkin.text(overlay,s,x,y,w,30,14,0xffffff,"center");}
  private function call(action:String="state",value:String=""):String {try{return run(action,value);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}
  private function run(action:String,value:String):String {
   if(action=="model"){
    var s:Object=RoadmapJourney.normalize(null,1,null,[]);check(RoadmapJourney.completed(s,0)&&!RoadmapJourney.completed(s,1),"legacy completion");
    check(!RoadmapJourney.optionalReady(s,1)&&s.letters['1']===undefined,"no invented letters");
    RoadmapJourney.record(s,"A:1:29",1,true,false);check(!RoadmapJourney.completed(s,1),"only final fixture completes season");
    RoadmapJourney.record(s,"A:1:30",1,false,true);RoadmapJourney.record(s,"A:1:30",1,false,true);check(RoadmapJourney.completed(s,1)&&s.fixtures.length==2,"fixture idempotency");
    s.letters['1']=7;s.champions['1']=true;check(RoadmapJourney.claimOptional(s,1).coins==4000&&RoadmapJourney.claimOptional(s,1).status=="CLAIMED","one optional reward");
    var normalized:Object=RoadmapJourney.normalize(s,1,null,[]);check(normalized.claims['1']&&normalized.letters['1']==7,"journey roundtrip");
    var saved:Object=GameData.socialState,journey:Object=GameData.roadmapJourney,oldEnergy:int=GameData.energy,oldHall:Object=JSON.parse(JSON.stringify(GameData.hallOfFame));
    GameData.socialState={links:[],pendingKeys:0,totals:{energy:0,key:0}};GameData.roadmapJourney=RoadmapJourney.create();
    var social:Object={userId:"qa",links:[],members:[],totals:{energy:0,key:0,letter:7},giftsSent:0,giftsReceived:7};
    GameData.applySocialSnapshot(social);GameData.applySocialSnapshot(social);check(GameData.roadmapJourney.letters['1']==7,"letter ledger replay");
    GameData.socialState=saved;GameData.roadmapJourney=journey;GameData.energy=oldEnergy;GameData.hallOfFame=oldHall;GameData.save();
    var batting:BattingSystem=new BattingSystem(),results:Array=[];
    for each(var delta:Number in [0,.01,.03,.055,.1]){var first:String="";for each(var sec:Number in [.34,.42,.59,.625]){var t:Number=BattingSystem.IDEAL_CONTACT-delta/sec,judgment:String=batting.evaluateTiming(t,75,70,0,sec);if(first!="")check(first==judgment,"millisecond windows independent of pitch speed");first=judgment;}results.push({errorMs:delta*1000,result:first});}
    check(batting.evaluateTiming(-.01,75,70,0,.42)=="MISS","pre-release swing");
    var hero:Object=GameData.mainPlayer(),runner:RunnerSprite=new RunnerSprite(hero);runner.runAt(1);var origin:Number=runner.getChildAt(0).y;for(var tick:int=0;tick<120;tick++)runner.runAt(1);check(Math.abs(runner.getChildAt(0).y-origin)<.001,"runner bob never accumulates");runner.dispose();
    var now:int=1000,clock:Function=function():int{return now;},pitcher:Pitcher=new Pitcher(440,320,0x247ab2,"QA",clock);overlay=new Sprite();addChild(overlay);overlay.addChild(pitcher);pitcher.throwPitch(.96);var release:Point=pitcher.releasePosition(),repeat:Point=pitcher.releasePosition();check(pitcher.frameIndex==15&&Point.distance(release,repeat)<.001,"release is synchronized and stable");pitcher.dispose();clear();
    check(SpriteFrameLayout.PITCHER.length==24,"24 pitcher poses");check(EquipmentCatalog.items().length==87&&StadiumCatalog.items().length==26,"catalog extensions");
    return JSON.stringify({status:"PASS",timing:results,pitcherPoses:24,runnerNoDrift:true,letterIdempotency:true,optionalRewardOnce:true});
   }
   if(action=="roadmap-seed"){GameData.leagueIndex=1;GameData.seasonGame=30;GameData.seasonWins=12;GameData.roadmapGames=30;GameData.roadmapWins=12;GameData.roadmapJourney=RoadmapJourney.create();GameData.roadmapJourney.letters['1']=7;GameData.roadmapJourney.champions['1']=true;GameData.save();}
   if(action=="season-complete"){RoadmapJourney.record(GameData.roadmapJourney,"qa095:1:30",1,true,true);GameData.save();}
   if(action=="stadium-equip"){
    GameData.leagueIndex=0;GameData.coins=10000;var civic:Object=GameData.shopItemById("stadium_background_civic095"),mountain:Object=GameData.shopItemById("stadium_background_mountain095");
    check(GameData.purchaseShopItem(civic)=="LOCKED"&&GameData.coins==10000,"stadium league gate");
    var wanted:Object=value=="civic"?civic:mountain;GameData.leagueIndex=value=="civic"?1:0;
    var price:int=wanted.coinPrice;check(GameData.purchaseShopItem(wanted)=="OK"&&GameData.coins==10000-price,"stadium purchase");check(GameData.activateStadiumItem(wanted),"stadium equip");GameData.save();
   }
   if(action=="preview"){
    clear();if(value=="close")return "{}";overlay=new Sprite();overlay.graphics.beginFill(0x18334b);overlay.graphics.drawRect(0,0,960,720);overlay.graphics.endFill();addChild(overlay);
    hero=GameData.mainPlayer();
    if(value=="costumes")for(var i:int=0;i<12;i++){
     var gear:Object={};for each(var item:Object in EquipmentCatalog.items())if(item.name.indexOf("COLLECTOR "+GearPieceArtwork.THEMES[i]+" ")==0)gear[item.slot]=item;
     var actor:HeroSprite=new HeroSprite(hero.name,hero.accent,hero.appearance,"home",.68,gear);actor.x=111+(i%4)*242;actor.y=211+int(i/4)*237;overlay.addChild(actor);actors.push(actor);label(GearPieceArtwork.THEMES[i],i%4*242,214+int(i/4)*237,224);
    }
    if(value=="pitcher")for(i=0;i<24;i++){var pose:IllustratedSprite=new IllustratedSprite("pitcher",.56,{uniform:0x79539d});pose.setFrame(i);pose.x=78+(i%6)*160;pose.y=155+int(i/6)*179;overlay.addChild(pose);actors.push(pose);label(String(i),i%6*160,158+int(i/6)*179,150);}
    if(value=="pieces")for(i=0;i<12;i++){var col:int=i%2,row:int=int(i/2);label(GearPieceArtwork.THEMES[i],col*480,row*116+6,180);var j:int=0;for each(var slot:String in ["helmet","goggles","belt","glove","shoes"]){var piece:GearPieceArtwork=new GearPieceArtwork("COLLECTOR "+GearPieceArtwork.THEMES[i]+" "+slot.toUpperCase(),slot,48);piece.x=col*480+215+j*52;piece.y=row*116+50;overlay.addChild(piece);j++;}}
    if(value.indexOf("stadium-")==0){var old:Object=GameData.stadiumActive;GameData.stadiumActive={background:value=="stadium-mountain"?"stadium_background_mountain095":"stadium_background_civic095"};var stadium:MatchStadium=new MatchStadium(960,720);overlay.addChild(stadium);actors.push(stadium);GameData.stadiumActive=old;}
    if(value=="equipped"){gear={};for each(item in EquipmentCatalog.items())if(item.name.indexOf("COLLECTOR ARCTIC ")==0)gear[item.slot]=item;GameData.equipped=gear;GameData.save();clear();}
   }
   return JSON.stringify({journey:GameData.roadmapJourney,coins:GameData.coins,league:GameData.leagueIndex,equipped:GameData.equipped});
  }
 }
}
