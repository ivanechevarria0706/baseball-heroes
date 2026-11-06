package {
    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.utils.getTimer;
    import com.bh.model.*;
    import com.bh.visual.*;
    import com.bh.ui.TrainingExerciseScene;
    public class WebTraining112 extends WebTraining111 {
        private var sheet:Sprite,actors:Array=[],intervals:Array=[],lastAt:int=0;
        public function WebTraining112(){super();ExternalInterface.addCallback("bh112",run112);addEventListener(Event.ENTER_FRAME,measure);}
        private function measure(e:Event):void {var now:int=getTimer();if(findScene(this)&&lastAt>0)intervals.push(now-lastAt);lastAt=now;}
        private function findScene(root:DisplayObjectContainer):TrainingExerciseScene {
            for(var i:int=0;i<root.numChildren;i++){var d:DisplayObject=root.getChildAt(i);if(d is TrainingExerciseScene)return d as TrainingExerciseScene;if(d is DisplayObjectContainer){var found:TrainingExerciseScene=findScene(d as DisplayObjectContainer);if(found)return found;}}
            return null;
        }
        private function clearSheet():void {for each(var actor:TrainingActor in actors)actor.dispose();actors=[];if(sheet){removeChild(sheet);sheet=null;}}
        private function run112(action:String="state",value:String=""):String {
            try {
                if(action=="appearance") {var a:Object=GameData.mainPlayer().appearance;a.shape=7;a.hair=6;a.hairColor=4;a.skinColor=2;a.eyes=3;GameData.save();}
                if(action=="sheet") {
                    clearSheet();sheet=new Sprite();sheet.graphics.beginFill(0xd9e6e9);sheet.graphics.drawRect(0,0,960,720);sheet.graphics.endFill();addChild(sheet);
                    for(var row:int=0;row<6;row++)for(var col:int=0;col<4;col++) {
                        var entry:Object=TrainingCatalog.activities(value)[row],actor:TrainingActor=new TrainingActor(GameData.mainPlayer(),value,row,entry.id);
                        actor.animate(col*240);actor.scaleX=actor.scaleY=.38;actor.x=120+col*240;actor.y=116+row*117;sheet.addChild(actor);actors.push(actor);
                    }
                }
                if(action=="close-sheet")clearSheet();
                if(action=="geometry") {
                    var errors:Array=[],count:int=0;
                    for each(var def:Object in TrainingCatalog.disciplines())for(var i:int=0;i<6;i++) {
                        var item:Object=TrainingCatalog.activities(def.id)[i],view:TrainingActor=new TrainingActor(GameData.mainPlayer(),def.id,i,item.id);
                        for(var j:int=0;j<4;j++){view.animate(j*240);var state:Object=view.describe();count++;if(state.headStyle!="0.8.6"||!isFinite(state.headX)||!isFinite(state.headY)||state.headY>0||state.headY< -300)errors.push({discipline:def.id,row:i,pose:j,state:state});}
                        view.dispose();
                    }
                    return JSON.stringify({status:errors.length?"FAIL":"PASS",renderedStates:count,newBodyFrames:48,errors:errors});
                }
                var scene:TrainingExerciseScene=findScene(this);
                return JSON.stringify({scene:scene?scene.describe():null,coins:GameData.coins,xp:GameData.xp,level:GameData.level,energy:GameData.energy,running:GameData.runningTraining,appearance:GameData.mainPlayer().appearance,frameIntervals:intervals});
            }catch(error:Error){return JSON.stringify({error:error.message});}
            return "{}";
        }
    }
}
