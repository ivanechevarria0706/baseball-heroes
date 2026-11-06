package {
 import flash.display.*;import flash.text.*;import flash.events.*;import flash.external.ExternalInterface;import flash.geom.Rectangle;
 import com.bh.ui.*;import com.bh.model.*;import com.bh.visual.MatchStadium;import com.bh.audio.AudioManager;
 public class WebCards1013 extends Sprite {
  private var view:Sprite,bg:MatchStadium,closed:int=0,updated:int=0;
  public function WebCards1013(){stage.scaleMode="noScale";stage.align="TL";stage.frameRate=30;AudioManager.setSfxVolume(0);GameData.init();ExternalInterface.addCallback("bhCards1013",run);ExternalInterface.addCallback("bhCardsBounds1013",bounds);ExternalInterface.call("BHWeb.ready");}
  private function close():void {if(view){if("dispose" in view)Object(view).dispose();if(view.parent)view.parent.removeChild(view);}view=null;}
  private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var r:DisplayObject=find(d as DisplayObjectContainer,id);if(r)return r;}}return null;}
  private function bounds(id:String):String {var d:DisplayObject=view?find(view,id):null;if(!d)return "null";var r:Rectangle=d.getBounds(stage);return JSON.stringify({x:r.x,y:r.y,w:r.width,h:r.height,enabled:d is InteractiveObject?InteractiveObject(d).mouseEnabled:false,visible:d.visible});}
  private function walk(c:DisplayObjectContainer,out:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible||d.alpha<=0)continue;if(d is TextField){var t:TextField=d as TextField;out.push({id:t.name,text:t.text,w:t.width,h:t.height,tw:t.textWidth,th:t.textHeight,embedded:t.embedFonts});}if(d is DisplayObjectContainer)walk(d as DisplayObjectContainer,out);}}
  private function run(action:String="state",value:String=""):String {try{
   if(action=="prepare"){close();if(bg){bg.dispose();removeChild(bg);}bg=new MatchStadium(960,720);addChildAt(bg,0);GameData.resetSave();GameData.heroAppearance();GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.leagueIndex=4;GameData.coins=500000;GameData.cash=500;GameData.specialOwned={};GameData.specialEquipped=[null,null,null,null,null];for(var n:int=0;n<3;n++)GameData.specialOwned["qa_c"+n]=SpecialCardInventory.fresh("qa_c"+n,"card_walker_p");}
   if(action=="rookie"){close();GameData.leagueIndex=0;GameData.coins=0;GameData.cash=0;}
   if(action=="show"){close();if(value=="shop"){view=new BatterShopOverlay(function():void{closed++;close();},function(card:Object):void{updated++;});view.y=90;view.graphics.clear();view.graphics.beginFill(0,.58);view.graphics.drawRect(0,-90,960,720);view.graphics.endFill();}else if(value=="peel"){view=new CardPeelReveal(new SpecialBatterCardView(GameData.specialCardById("qa_c0"),150,236),"C",150,236);view.x=405;view.y=180;}else view=new SpecialCardsScreen(960,720,function():void{closed++;close();},value=="trade"?"TRADE":"DETAILS");addChild(view);}
   if(action=="peel"&&view is CardPeelReveal)CardPeelReveal(view).progress(Number(value));
   if(action=="reload"){close();GameData.save();GameData.load();}
   if(action=="dispose")close();
   var text:Array=[];if(view)walk(view,text);var cards:Array=GameData.ownedSpecialCards();return JSON.stringify({text:text,coins:GameData.coins,cash:GameData.cash,closed:closed,updated:updated,cards:cards,hero:GameData.mainPlayer(),order:GameData.battingOrder,version:24});
  }catch(e:Error){return JSON.stringify({error:e.message,stack:e.getStackTrace()});}return "{}";}
 }
}
