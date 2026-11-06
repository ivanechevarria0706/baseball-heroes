package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.text.TextField;
 import com.bh.model.*;import com.bh.ui.*;
 /** Private availability/preview fixture; never included in production. */
 public class WebModes1006 extends WebSmoke {
  private var view:ModeSelectScreen,counts:Object={home:0,regular:0,derby:0,tutorial:0,rival:0,post:0};
  public function WebModes1006(){super();ExternalInterface.addCallback("bhModes1006",run);}
  private function close():void {if(view){view.dispose();if(view.parent)removeChild(view);}}
  private function snapshot():Object {return {level:GameData.level,xp:GameData.xp,league:GameData.leagueIndex,coins:GameData.coins,cash:GameData.cash,energy:GameData.energy,season:GameData.seasonNumber,game:GameData.seasonGame,complete:GameData.seasonComplete,post:GameData.postSeason,summary:GameData.lastSeasonSummary,reservation:GameData.specialMatch,roster:GameData.roster,equipped:GameData.equipped};}
  private function prepare(kind:String):void {
   GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.seasonNumber=1;GameData.seasonGame=1;GameData.seasonComplete=false;GameData.postSeason=null;GameData.lastSeasonSummary=null;GameData.specialMatch=null;GameData.postSeasonMode=false;GameData.energy=20;GameData.maxEnergy=25;GameData.energyAt=String(new Date().time+300000);
   if(kind=="qualified"||kind=="unqualified"||kind=="active"||kind=="paidpost"||kind=="oldpost") {GameData.seasonGame=30;GameData.seasonComplete=true;GameData.lastSeasonSummary={season:1,leagueIndex:0,rank:kind=="unqualified"?8:1,playoffs:kind!="unqualified"};}
   if(kind=="active"||kind=="paidpost"||kind=="oldpost") {GameData.ensurePostSeason();PostSeason.record(GameData.postSeason,3,1);}
   if(kind=="paidpost"){GameData.specialMatch={key:PostSeason.key(GameData.postSeason),cards:[]};GameData.energy=0;}
   if(kind=="paidregular"||kind=="paidspecial"){GameData.seasonGame=kind=="paidspecial"?12:11;GameData.specialMatch={key:"0:1:"+GameData.seasonGame,cards:[]};GameData.energy=0;}
   if(kind=="oldpost"){GameData.seasonNumber=2;GameData.seasonGame=1;GameData.seasonComplete=false;}
   counts={home:0,regular:0,derby:0,tutorial:0,rival:0,post:0};GameData.save();
  }
  private function run(action:String="state",value:String=""):String {
   try {
    if(action=="prepare")prepare(value);
    if(action=="game"){GameData.seasonGame=int(value);GameData.save();}
    if(action=="show"){close();var empty:Boolean=value=="null";view=new ModeSelectScreen(960,720,empty?null:function():void{counts.home++;},empty?null:function():void{counts.regular++;},empty?null:function():void{counts.derby++;},empty?null:function():void{counts.tutorial++;},empty?null:function():void{counts.rival++;},empty?null:function():void{counts.post++;});addChild(view);}
    if(action=="close")close();
    if(action=="key-down"||action=="key-up")stage.dispatchEvent(new KeyboardEvent(action=="key-down"?KeyboardEvent.KEY_DOWN:KeyboardEvent.KEY_UP,true,false,0,int(value)));
    var title:TextField=view?view.getChildByName("mode-detail-title") as TextField:null;
    return JSON.stringify({catalog:CompetitionModes.catalog(),next:CompetitionModes.nextSpecial(),account:snapshot(),selected:title?title.text:"",counts:counts});
   }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";
  }
 }
}
