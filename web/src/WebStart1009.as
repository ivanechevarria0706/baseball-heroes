package {
    import flash.display.*;import flash.external.ExternalInterface;import flash.text.TextField;import flash.events.MouseEvent;
    import com.bh.ui.*;import com.bh.model.*;
    /** Isolated data for beginning/development regression checks; never shipped. */
    public class WebStart1009 extends WebSmoke {
        private var view:Sprite,counts:Object={done:0,back:0};
        public function WebStart1009(){super();ExternalInterface.addCallback("bhStart1009",run);ExternalInterface.addCallback("bhStartClick1009",clickView);}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var result:DisplayObject=find(DisplayObjectContainer(d),id);if(result)return result;}}return null;}
        private function clickView(id:String):Boolean {var d:DisplayObject=view?find(view,id):null;if(!d)return false;d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));return true;}
        private function close():void {if(view){Object(view).dispose();if(view.parent)removeChild(view);view=null;}}
        private function done():void {counts.done++;}
        private function back():void {counts.back++;}
        private function fields(c:DisplayObjectContainer,result:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible||d.alpha<=0)continue;if(d is TextField){var t:TextField=TextField(d);result.push({name:t.name,text:t.text,w:t.width,h:t.height,tw:t.textWidth,th:t.textHeight});}if(d is DisplayObjectContainer)fields(DisplayObjectContainer(d),result);}}
        private function run(action:String="state",value:String=""):String {
            try {
                if(action=="prepare"){
                    close();GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.energyAt=String(new Date().time+300000);GameData.coins=50000;GameData.heroAppearance();
                    GameData.roster=GameData.roster.slice(0,12);var template:Object=GameData.roster[1];for(var i:int=12;i<int(value);i++){var p:Object=JSON.parse(JSON.stringify(template));p.name="QA Player "+(i+1);p.power=50;p.xp=75;p.level=1;p.skillPoints=0;GameData.roster.push(p);}
                    for each(var player:Object in GameData.roster)PlayerCondition.ensure(player);counts={done:0,back:0};GameData.save();
                }
                if(action=="show"){close();if(value=="teams")view=new TeamSelectionScreen(960,720,done,back);if(value=="name")view=new TeamNameScreen(960,720,done);if(value=="development")view=new TradeEnhanceScreen(960,720,back);if(view)addChild(view);}
                if(action=="name"&&view){TextField(view.getChildByName("team-name-input")).text=value;}
                if(action=="number"&&view){TextField(view.getChildByName("team-number-input")).text=value;}
                if(action=="coins")GameData.coins=int(value);
                if(action=="max"){for each(var member:Object in GameData.roster)member.power=99;}
                if(action=="nine"){GameData.roster=GameData.roster.slice(0,9);GameData.save();}
                if(action=="dispose"&&view)Object(view).dispose();
                if(action=="close")close();
                var textRows:Array=[];if(view)fields(view,textRows);
                return JSON.stringify({text:textRows,counts:counts,coins:GameData.coins,team:GameData.teamName,city:GameData.teamCity,accent:GameData.teamAccent,number:GameData.uniformNumber,level:GameData.level,energy:GameData.energy,season:GameData.seasonNumber,game:GameData.seasonGame,roster:GameData.roster,equipped:GameData.equipped,order:GameData.battingOrder});
            }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";
        }
    }
}
