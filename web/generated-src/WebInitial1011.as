package {
 import flash.display.*;import flash.events.*;import flash.text.*;import flash.geom.Rectangle;import flash.external.ExternalInterface;
 import com.bh.model.*;import com.bh.ui.*;import com.bh.audio.AudioManager;
 public class WebInitial1011 extends Sprite {
  private var view:Sprite,kind:String="",counts:Object={play:0,creator:0};
  public function WebInitial1011(){stage.scaleMode="noScale";stage.align="TL";stage.frameRate=30;AudioManager.setSfxVolume(0);GameData.init();ExternalInterface.addCallback("bhInitial1011",run);ExternalInterface.addCallback("bhInitialBounds1011",bounds);ExternalInterface.call("BHWeb.ready");}
  private function close():void {if(view){if("dispose" in view)Object(view).dispose();if(view.parent)view.parent.removeChild(view);view=null;}}
  private function home():void{show("home");}private function noop():void{}
  private function show(type:String):void {close();kind=type;
   if(type=="creator")view=new CharacterMakerScreen(960,720,function():void{counts.creator++;show("lineup");});
   if(type=="lineup")view=new LineupScreen(960,720,home,function():void{counts.play++;if(GameData.startSeasonGame())GameData.tutorialEvent("start",GameData.specialMatch.key);},function():void{show("cards");},function():void{show("trade");});
   if(type=="home")view=new LobbyScreen(960,720,noop,noop,function():void{show("draft");},noop,noop,noop,noop,noop,noop,function():void{show("name");},noop,noop,noop,noop,noop,noop,noop);
   if(type=="name")view=new TeamNameScreen(960,720,home);
   if(type=="draft")view=new FriendDraftScreen(960,720,home);
   if(type=="trade")view=new SpecialCardsScreen(960,720,home,"TRADE");
   if(type=="cards")view=new SpecialCardsScreen(960,720,home);
   if(type=="stats")view=new HeroStatPanel(home);
   if(view)addChild(view);
  }
  private function walk(c:DisplayObjectContainer,out:Array):void{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible||d.alpha<=0)continue;if(d is TextField){var t:TextField=TextField(d);out.push({id:d.name,text:t.text,w:t.width,h:t.height,tw:t.textWidth,th:t.textHeight});}if(d is DisplayObjectContainer)walk(DisplayObjectContainer(d),out);}}
  private function find(c:DisplayObjectContainer,id:String):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible)continue;if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(DisplayObjectContainer(d),id);if(f)return f;}}return null;}
  private function bounds(id:String):String {var d:DisplayObject=view?find(view,id):null;if(!d)return "null";var rect:Rectangle=d.getBounds(stage);return JSON.stringify({x:rect.x,y:rect.y,w:rect.width,h:rect.height});}
  private function run(action:String="state",value:String=""):String {try{
   if(action=="fresh"){close();GameData.resetSave();GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.save();}
   if(action=="show")show(value);
   if(action=="reload"){close();GameData.save();GameData.load();show(kind);}
   if(action=="complete"){
    var rows:Array=[];for(var i:int=0;i<9;i++){var p:Object=GameData.battingOrderPlayers()[i];rows.push({name:p.name,isHero:p===GameData.mainPlayer(),hits:i==2?5:i==0?4:1,homeRuns:0,rbi:i==2?1:0,atBats:6});}
    GameData.completeSeasonGame(1,0,16,0,6,1,[0,0,0,0,0,0,0,0,0,0,1],[0,0,0,0,0,0,0,0,0,0,0],rows,{version:4,fixtureKey:GameData.specialMatch.key,playXP:34,playCoins:109,points:18000,bestStreak:1,heroAttempts:6,events:[]});show("home");
   }
   if(action=="no-points"){GameData.starterTutorial=StarterTutorial.create(true);GameData.starterTutorial.stage=StarterTutorial.POINT;GameData.mainPlayer().skillPoints=0;show("home");}
   if(action=="friends"){FriendRoster.update({members:[{id:"one",name:"Alice",connected:true,profile:{}},{id:"two",name:"Bob",connected:true,profile:{}}]});}
   if(action=="model")return JSON.stringify(InitialChecks1011.run());
   var text:Array=[];if(view)walk(view,text);var rowsInfo:Array=[];if(view is LineupScreen){for(var n:int=0;n<30;n++){var d:DisplayObject=find(view,"bench_"+n);if(d){var a:Array=[];walk(DisplayObjectContainer(d),a);rowsInfo.push({id:d.name,text:a});}}}
   return JSON.stringify({kind:kind,stage:GameData.starterTutorial.stage,tutorial:GameData.starterTutorial,level:GameData.level,xp:GameData.xp,coins:GameData.coins,energy:GameData.energy,hero:GameData.mainPlayer(),order:GameData.battingOrder,cards:GameData.specialOwned,equipped:GameData.specialEquipped,appearance:GameData.heroAppearance(),friendDraft:GameData.friendDraft,text:text,bench:rowsInfo,counts:counts,summary:GameData.lastGameSummary});
  }catch(e:Error){return JSON.stringify({error:e.message,stack:e.getStackTrace()});}return "{}";}
 }
}
