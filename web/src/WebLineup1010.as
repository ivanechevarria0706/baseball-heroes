package {
 import flash.display.*;import flash.external.ExternalInterface;import flash.events.MouseEvent;import flash.text.TextField;
 import com.bh.ui.*;import com.bh.model.*;
 public class WebLineup1010 extends WebSmoke {
  private var view:LineupScreen,counts:Object={home:0,play:0};
  public function WebLineup1010(){super();ExternalInterface.addCallback("bhLineup1010",run);ExternalInterface.addCallback("bhLineupClick1010",clickView);}
  private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(DisplayObjectContainer(d),id);if(f)return f;}}return null;}
  private function clickView(id:String):Boolean {var d:DisplayObject=view?find(view,id):null;if(!d)return false;d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));return true;}
  private function close():void {if(view){view.dispose();if(view.parent)view.parent.removeChild(view);view=null;}}
  private function show():void {close();view=new LineupScreen(960,720,function():void{counts.home++;},function():void{counts.play++;});addChild(view);}
  private function fields(c:DisplayObjectContainer,result:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible||d.alpha<=0)continue;if(d is TextField){var t:TextField=TextField(d);result.push({name:t.name,text:t.text,w:t.width,h:t.height,tw:t.textWidth,th:t.textHeight});}if(d is DisplayObjectContainer)fields(DisplayObjectContainer(d),result);}}
  private function check(ok:Boolean,label:String):void {if(!ok)throw new Error(label);}
  private function run(action:String="state",value:String=""):String {try{
   if(action=="prepare"){
    close();GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.energy=25;GameData.energyAt="0";GameData.cash=20;GameData.specialMatch=null;GameData.postSeasonMode=false;GameData.seasonGame=1;GameData.seasonComplete=false;GameData.heroAppearance();
    for(var i:int=0;i<GameData.roster.length;i++){var p:Object=GameData.roster[i];p.condition={version:1,form:i%5-2,lastFixture:"",energy:0,at:"0"};p.level=16+i;p.xp=i*9%100;GameData.activeSkillName(p);}
    GameData.specialOwned={};GameData.specialEquipped=["qa_full","qa_half","qa_empty",null,null];GameData.specialSlotsUnlocked=3;
    for each(var id:String in ["qa_full","qa_half","qa_empty","qa_bench"]){var s:Object=SpecialCardInventory.fresh(id,id=="qa_half"?"card_benny_c":id=="qa_empty"?"card_ken_golden":"card_kai_captain");s.charges=id=="qa_empty"?0:id=="qa_half"?1:2;s.rechargeAt=s.charges<2?String(new Date().time+10800000):"0";GameData.specialOwned[id]=s;}
    var order:Array=GameData.battingOrderPlayers(),hero:Object=GameData.mainPlayer();order.splice(order.indexOf(hero),1);order.splice(2,0,hero);GameData.setBattingOrder(order);GameData.save();counts={home:0,play:0};
   }
   if(action=="show")show();
   if(action=="cash"){GameData.cash=int(value);GameData.save();}
   if(action=="clock"){GameData.specialOwned.qa_empty.charges=0;GameData.specialOwned.qa_empty.rechargeAt=String(new Date().time+int(value));GameData.save();}
   if(action=="paid")check(GameData.startSeasonGame(),"start fixture");
   if(action=="finish"){var key:String=GameData.specialMatch.key;GameData.completeSeasonGame(3,1,1,0,3,1,null,null,[],{fixtureKey:key});}
   if(action=="reload"){close();GameData.save();GameData.load();show();}
   if(action=="dispose"&&view)view.dispose();
   if(action=="close")close();
   if(action=="model"){
    var test:Object={name:"Condition Test",condition:{energy:0,at:"0",custom:"keep"}};PlayerCondition.ensure(test);check(test.condition.form==-2&&test.condition.custom=="keep","legacy condition preserved");check(GameData.playerReady(test),"poor form still plays");
    var initial:int=PlayerCondition.modifier(test);check(PlayerCondition.advance(test,"fixture-1"),"condition advances once");var form:int=PlayerCondition.modifier(test);check(!PlayerCondition.advance(test,"fixture-1")&&PlayerCondition.modifier(test)==form,"condition cannot reroll");
    var up:Boolean=false,down:Boolean=false;test.condition.form=0;for(i=0;i<60;i++){var old:int=PlayerCondition.modifier(test);PlayerCondition.advance(test,"fixture-"+(i+2));form=PlayerCondition.modifier(test);up=up||form>old;down=down||form<old;check(form>=-2&&form<=2,"bounded condition");}check(up&&down,"condition can improve and worsen");
    check(ConditionArrow.color(2)==0xe65360&&ConditionArrow.color(-2)==0x838e91,"reference arrow palette");
   }
   var textRows:Array=[];if(view)fields(view,textRows);var display:Array=[];order=GameData.battingOrderPlayers();for(i=0;i<order.length;i++){var card:Object=GameData.lineupCardAt(i);display.push({index:i,base:order[i].name,card:card?card.id:null,condition:card?2:GameData.matchCondition(order[i])});}
   return JSON.stringify({text:textRows,counts:counts,cash:GameData.cash,coins:GameData.coins,energy:GameData.energy,game:GameData.seasonGame,roster:GameData.roster,order:GameData.battingOrder,cards:GameData.specialOwned,slots:GameData.specialEquipped,paid:GameData.specialMatch,display:display,equipped:GameData.equipped});
  }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";}
 }
}
