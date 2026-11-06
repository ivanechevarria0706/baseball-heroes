package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.text.TextField;import flash.geom.Rectangle;
 import com.bh.model.GameData;import com.bh.ui.LevelUpOverlay;import com.bh.ui.GameResultPanel;import com.bh.visual.MatchStadium;
 /** Local-only diagnostic. It is not in the production WebMain or deployment allowlist. */
 [SWF(width="960",height="720",frameRate="30",backgroundColor="#143148")]
 public class WebRewards1026 extends Sprite {
  private var panel:Sprite,callbacks:int=0;
  public function WebRewards1026() {
   GameData.init();GameData.save();addChild(new MatchStadium(960,720));
   loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{ExternalInterface.call("BHWeb.gameError",String(e.error));});
   ExternalInterface.addCallback("bhRewards",command);ExternalInterface.addCallback("bhRewardTree",tree);ExternalInterface.call("BHWeb.ready");
  }
  private function state():Object {return {callbacks:callbacks,coins:GameData.coins,cash:GameData.cash,energy:GameData.energy,level:GameData.level,skillPoints:GameData.mainPlayer().skillPoints,animating:panel?panel.hasEventListener(Event.ENTER_FRAME):false};}
  private function drop():void {if(panel){Object(panel).dispose();if(panel.parent)removeChild(panel);panel=null;}}
  private function close():void {callbacks++;drop();}
  private function item(name:String):Object {for each(var entry:Object in GameData.shopCatalog())if(entry.name==name)return entry;return {name:name,slot:"bat"};}
  private function command(mode:String="state"):String {
   if(mode=="state")return JSON.stringify(state());drop();
   var data:Object={fromLevel:1,toLevel:2,skillPoints:1,coins:2000,maxEnergy:1,unlocked:[]};
   if(mode=="level2"||mode=="result") {for(var i:int=0;i<30;i++)data.unlocked.push(item(["Lightning 1","Bomber 1","Bat 1"][i%3]));}
   if(mode=="level12") {data.fromLevel=11;data.toLevel=12;data.coins=3000;data.maxEnergy=0;for(i=0;i<8;i++)data.unlocked.push(item(["Panda","Pink Love","Camo"][i%3]));}
   if(mode=="one") {data.coins=0;data.maxEnergy=0;data.unlocked=[item("Blue Lightning")];}
   if(mode=="two") {data.skillPoints=0;data.unlocked=[item("Panda"),item("Pink Love")];}
   if(mode=="legacy") {data.toLevel=100;data.fromLevel=97;data.skillPoints=3;data.coins=6000;data.maxEnergy=3;data.unlocked=["Blue Lightning Accessory","Very Long Legacy Baseball Gloves","Classic Bat"];}
   if(mode=="empty") {data.skillPoints=data.coins=data.maxEnergy=0;}
   if(mode=="dispose")return JSON.stringify(state());
   if(mode=="result") {
    var opponent:Object=GameData.opponentForGame(1),rows:Array=[];
    for each(var p:Object in GameData.battingOrderPlayers())rows.push({name:p.name,hits:1,homeRuns:0,rbi:0});
    panel=new GameResultPanel(960,720,{game:1,season:1,leagueIndex:0,league:"ROOKIE",teamCity:GameData.teamCity,teamAccent:GameData.teamAccent,opponent:opponent,win:true,homeScore:6,awayScore:3,homeLine:[0,1,0,0,0,0,0,0,5],awayLine:[0,0,0,0,1,0,0,2,0],awayHits:7,hits:9,homeRuns:0,rbi:6,boxScore:rows,rewardCoins:370,rewardXp:45,wins:1,losses:0,rank:1,seasonComplete:false,levelUp:data},close,close);
   }else panel=new LevelUpOverlay(960,720,data,close);
   addChild(panel);return JSON.stringify(state());
  }
  private function tree():String {var rows:Array=[];walk(this,rows);return JSON.stringify(rows);}
  private function walk(parent:DisplayObjectContainer,rows:Array):void {
   for(var i:int=0;i<parent.numChildren;i++){var p:DisplayObject=parent.getChildAt(i);if(!p.visible)continue;var r:Rectangle=p.getBounds(stage),t:TextField=p as TextField;
    rows.push({name:p.name,text:t?t.text:"",x:r.x,y:r.y,w:r.width,h:r.height,tw:t?t.textWidth:0,th:t?t.textHeight:0,animating:p.hasEventListener(Event.ENTER_FRAME)});
    if(p is DisplayObjectContainer)walk(p as DisplayObjectContainer,rows);
   }
  }
 }
}
