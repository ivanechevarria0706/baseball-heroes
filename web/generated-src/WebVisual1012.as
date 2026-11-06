package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.text.*;import flash.geom.Rectangle;
 import com.bh.ui.*;import com.bh.model.*;import com.bh.visual.*;import com.bh.audio.AudioManager;
 public class WebVisual1012 extends Sprite {
  private var bg:MatchStadium,rowIdentity:DisplayObject;
  private var view:Sprite,panel:TeamSimulationPanel,now:int=1000,kind:String="",before:String;
  public function WebVisual1012(){stage.scaleMode="noScale";stage.align="TL";stage.frameRate=30;AudioManager.setSfxVolume(0);GameData.init();ExternalInterface.addCallback("bhVisual1012",run);ExternalInterface.call("BHWeb.ready");}
  private function close():void {if(view){if("dispose" in view)Object(view).dispose();if(view.parent)view.parent.removeChild(view);}view=null;panel=null;}
  private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var v:DisplayObject=find(d as DisplayObjectContainer,id);if(v)return v;}}return null;}
  private function walk(c:DisplayObjectContainer,out:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible||d.alpha<=0)continue;if(d is TextField){var t:TextField=d as TextField;var p:Rectangle=t.getBounds(stage);out.push({id:d.name,text:t.text,w:t.width,h:t.height,tw:t.textWidth,th:t.textHeight,x:p.x,y:p.y,color:t.textColor});}if(d is DisplayObjectContainer)walk(d as DisplayObjectContainer,out);}}
  private function run(action:String="state",value:String=""):String {try {
   if(action=="prepare"){close();GameData.resetSave();GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.teamCity="CHICAGO";GameData.teamName="CHICAGO HEROES";GameData.level=12;GameData.xp=6168;GameData.levelProgress=55;GameData.energy=14;GameData.coins=6581;GameData.cash=100;GameData.heroAppearance();for each(var regular:Object in GameData.roster)PlayerCondition.ensure(regular);before=JSON.stringify(GameData.roster);if(bg){bg.dispose();removeChild(bg);}bg=new MatchStadium(960,586);addChildAt(bg,0);}
   if(action=="show"){
    close();kind=value;
    if(kind=="batting"){var p:Object=GameData.mainPlayer();view=new Hud(960,586,new Player(p.name,GameData.level,p.power,p.contact,p.speed));Hud(view).setLiveRewards(123,7);Hud(view).refresh(new Player(p.name,GameData.level,p.power,p.contact,p.speed));}
    else if(kind=="card"){view=new SpecialBatterCardView(SpecialCardCatalog.cards()[1],196,292);view.x=380;view.y=140;}
    else {panel=new TeamSimulationPanel(960,586,function():int{return now;});view=panel;panel.configure(GameData.battingOrderPlayers(),{city:"MINNESOTA",teamName:"MINNESOTA GRUMPIES",accent:0xb87538,rating:60},GameData.mainPlayer());panel.beginSimulation(3,kind=="away"?"AWAY":"HOME");now+=500;panel.setActiveBatter(kind=="away"?"AWAY":"HOME",2);panel.setScore(4,2,3,2);panel.setHits(9,6);panel.setLiveRewards(123,7);panel.setMomentum({charge:10});}
    addChild(view);rowIdentity=panel?find(panel,"home-row-0"):null;
   }
   if(action=="advance")now+=int(value);
   if(action=="active"&&panel)panel.setActiveBatter("HOME",int(value));
   if(action=="result"&&panel)panel.addResultFor("HOME",2,"Lucas",value,1);
   if(action=="large"){GameData.coins=999999999;GameData.cash=999999999;if(panel)panel.setLiveRewards(0,0);}
   if(action=="reconfigure"&&panel){panel.configure(GameData.battingOrderPlayers(),{city:"MINNESOTA",teamName:"MINNESOTA GRUMPIES",accent:0xb87538},GameData.mainPlayer());panel.beginSimulation(12,"AWAY");now+=500;panel.setScore(4,2,12,1);}
   if(action=="dispose")close();
   var text:Array=[];if(view)walk(view,text);var bars:int=0;for each(var t:Object in text)if(t.id=="level")bars++;
   return JSON.stringify({kind:kind,text:text,resourceBars:bars,rosterUnchanged:before==JSON.stringify(GameData.roster),beforeRows:before?JSON.parse(before):[],roster:GameData.roster,level:GameData.level,xp:GameData.xp,coins:GameData.coins,cash:GameData.cash,energy:GameData.energy,now:now,mode:panel?panel.isPaused:false,sameRows:panel&&rowIdentity===find(panel,"home-row-0")});
  }catch(e:Error){return JSON.stringify({error:e.message,stack:e.getStackTrace()});}return "{}";}
 }
}
