package {
    import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.geom.*;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.visual.*;
    /** Local-only stadium layout and interaction inspection. */
    public class WebBuild1003 extends WebVisual1002 {
        private var view:Sprite,disposable:Object;
        public function WebBuild1003(){super();ExternalInterface.addCallback("bhBuild1003",run);}
        private function close():void {if(disposable){disposable.dispose();disposable=null;}if(view){removeChild(view);view=null;}}
        private function placed(c:DisplayObjectContainer,out:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name.indexOf("stadium-decoration-")==0){var p:Point=d.localToGlobal(new Point()),q:Point=d.localToGlobal(new Point(1,1));out.push({name:d.name,x:p.x,y:p.y,sx:q.x-p.x,sy:q.y-p.y});}if(d is DisplayObjectContainer)placed(d as DisplayObjectContainer,out);}}
        private function layers(c:DisplayObjectContainer,out:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name=="match-stadium"){var art:DisplayObjectContainer=DisplayObjectContainer(d).getChildAt(0) as DisplayObjectContainer;for(var j:int=0;j<art.numChildren;j++)out.push({name:art.getChildAt(j).name,visible:art.getChildAt(j).visible});}else if(d is DisplayObjectContainer)layers(d as DisplayObjectContainer,out);}}
        private function run(action:String="state",value:String=""):String {
            try{
                if(action=="close"){close();return "{}";}
                if(action=="catalog")return JSON.stringify(GameData.shopItemsByCategory("STADIUM"));
                if(action=="prepare"){
                    GameData.coins=500000;GameData.cash=500;GameData.level=5;GameData.leagueIndex=1;GameData.onboardingStep=99;GameData.seasonGoalSet=true;
                    GameData.starterTutorial=StarterTutorial.create();GameData.specialMatch=null;GameData.missionClaims.stadium_growth=true;GameData.save();
                }
                if(action=="model"){
                    var samples:Array=[];
                    for each(var size:Array in [[960,720],[960,590],[960,540],[480,360]])for each(var stored:Array in [[30,130],[278,225],[526,292],[104,163],[422,276]]){
                        var entry:Object={x:stored[0],y:stored[1],scale:1.1},p:Point=StadiumPlacement.position(entry,size[0],size[1]),q:Point=StadiumPlacement.stored(p,size[0],size[1]);
                        if(Math.abs(q.x-entry.x)>.0001||Math.abs(q.y-entry.y)>.0001)throw new Error("Placement roundtrip");samples.push({size:size,stored:stored,screen:[p.x,p.y]});
                    }
                    var initial:String=JSON.stringify(GameData.stadiumActive),preview:Object=StadiumPlacement.profile(GameData.shopItemById("stadium_scoreboard_gold"));
                    if(JSON.stringify(GameData.stadiumActive)!=initial||preview.equipped.scoreboard!="stadium_scoreboard_gold")throw new Error("Preview mutated active stadium");
                    return JSON.stringify({status:"PASS",placementSamples:samples,dragBounds:StadiumPlacement.dragBounds()});
                }
                if(action=="show"){close();view=new BuildScreen(960,720,close,close);addChild(view);disposable=view;}
                if(action=="stadium"||action=="home"||action=="visit"||action=="field-baseline"||action=="field-painted"){
                    close();view=new Sprite();addChild(view);var h:Number=action=="stadium"?590:540;
                    var profile:Object=action=="visit"?StadiumPlacement.profile():null;
                    if(action.indexOf("field-")==0){h=720;profile=StadiumPlacement.profile();if(action=="field-baseline")profile.equipped.field="stadium_field_classic";}
                    var backdrop:MatchStadium=new MatchStadium(960,h,profile);view.addChild(backdrop);disposable=backdrop;
                }
                var rendered:Array=[],order:Array=[];if(view){placed(view,rendered);layers(view,order);}
                return JSON.stringify({coins:GameData.coins,cash:GameData.cash,active:GameData.stadiumActive,owned:GameData.stadiumOwned,decorations:GameData.stadiumDecorations,appearance:GameData.mainPlayer().appearance,energy:GameData.energy,xp:GameData.xp,gateAmount:GameData.gateIncomeAmount(),gateAt:GameData.gateIncomeLastAt,rendered:rendered,layers:order});
            }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";
        }
    }
}
