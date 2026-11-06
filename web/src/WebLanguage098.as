package {
 import flash.display.*;import flash.external.ExternalInterface;import com.bh.model.*;import com.bh.ui.*;
 /** English training and milestone QA, excluded from deployment. */
 public class WebLanguage098 extends WebSmoke {
  private var view:*;
  public function WebLanguage098(){super();ExternalInterface.addCallback("bhLanguage",show);}
  private function show(action:String="state"):String {
   if(view){view.dispose();removeChild(view);view=null;}
   if(action=="training"){view=new RunningTrainingRoom(960,720,GameData.mainPlayer(),function():void{});addChild(view);}
   if(action=="hall"){view=new HallOfFameScreen(960,720,function():void{},function():void{});addChild(view);}
   return JSON.stringify({activities:GameData.runningActivities(),achievements:CareerAchievements.catalog()});
  }
 }
}
