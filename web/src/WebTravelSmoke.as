package {
    import flash.external.ExternalInterface;
    import com.bh.ui.TravelMapScreen;
    import com.bh.ui.ArrivalMapScreen;
    import com.bh.model.GameData;
    import com.bh.visual.TravelMapArtwork;
    import flash.display.Sprite;
    import flash.geom.Point;
    public class WebTravelSmoke extends WebAssetSmoke {
        private var travel:Sprite;
        private var now:int=0;
        private var done:int=0;
        private var home:int=0;
        public function WebTravelSmoke(){
            super();
            ExternalInterface.addCallback("bhTravelFPS",function(rate:int):void{stage.frameRate=rate;});
            ExternalInterface.addCallback("bhTravel",function(action:String="",value:String=""):String {
                if(action=="show"||action=="arrival"||action=="clear")clearTravel();
                if(action=="city"){GameData.teamCity=value;GameData.save();}
                if(action=="show"||action=="arrival"){
                    done=home=now=0;var clock:Function=function():int{return now;};
                    travel=action=="show"?new TravelMapScreen(960,720,function():void{done++;},function():void{home++;},clock):new ArrivalMapScreen(960,720,function():void{done++;},clock);addChild(travel);
                }
                if(action=="time")now=int(value);
                if(action=="dispose")clearTravel();
                var opponent:Object=GameData.currentOpponent(),origin:Point=TravelMapArtwork.cityPoint(GameData.teamCity),destination:Point=TravelMapArtwork.cityPoint(String(opponent.city));
                return JSON.stringify({done:done,home:home,now:now,origin:[origin.x,origin.y],destination:[destination.x,destination.y],city:GameData.teamCity,opponent:opponent.city});
            });
        }
        private function clearTravel():void{if(travel){Object(travel).dispose();if(travel.parent)travel.parent.removeChild(travel);travel=null;}}
    }
}
