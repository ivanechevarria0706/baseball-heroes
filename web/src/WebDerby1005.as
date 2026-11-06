package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.ui.Keyboard;
 import com.bh.ui.*;import com.bh.model.*;
 /** Private deterministic Derby fixture. Never published. */
 public class WebDerby1005 extends WebSmoke {
  private var derby:HomeRunDerbyScreen,now:int=0,random:Number=.5,returns:int=0;
  public function WebDerby1005(){super();ExternalInterface.addCallback("bhDerby1005",run);}
  private function run(action:String="state",value:Number=0):String {
   try {
    if(action=="prepare") {GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.coins=10000;GameData.energy=20;GameData.energyAt=String(new Date().time+300000);GameData.mainPlayer().accent=0xc3323b;GameData.stadiumActive.field="stadium_field_pro";GameData.stadiumActive.scoreboard="stadium_scoreboard_gold";GameData.stadiumOwned.push("stadium_field_pro","stadium_scoreboard_gold");GameData.save();}
    if(action=="show"){if(derby){derby.dispose();if(derby.parent)removeChild(derby);}now=0;returns=0;derby=new HomeRunDerbyScreen(960,720,function():void{returns++;derby.dispose();if(derby.parent)removeChild(derby);},function():int{return now;},function():Number{return random;});addChild(derby);}
    if(action=="random")random=value;
    if(action=="advance") {now+=int(value);derby.qaDerby1005("tick");}
    if(action=="key-down"||action=="key-up")stage.dispatchEvent(new KeyboardEvent(action=="key-down"?KeyboardEvent.KEY_DOWN:KeyboardEvent.KEY_UP,true,false,0,int(value)));
    if(action=="deactivate")stage.dispatchEvent(new Event(Event.DEACTIVATE));
    if(action=="dispose"){derby.dispose();if(derby.parent)removeChild(derby);}
    var result:Object=derby?derby.qaDerby1005(action):{};result.returns=returns;return JSON.stringify(result);
   }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";
  }
 }
}
