package com.bh.ui {
    import flash.display.Sprite;import flash.events.Event;import flash.utils.getTimer;
    import com.bh.model.GameData;import com.bh.visual.TravelMapArtwork;import com.bh.visual.VisualAssetRegistry;
    /** First club arrival: the saved hero, existing Rookie bus and original handoff timing. */
    public class ArrivalMapScreen extends Sprite {
        private var entrance:MenuEntrance;
        private var done:Function,clock:Function,startedAt:int,completed:Boolean=false;
        private var route:JourneyRouteView,chrome:JourneyChrome,waitingForFrame:Boolean;
        public function ArrivalMapScreen(w:Number,h:Number,doneCallback:Function,timeSource:Function=null) {
            name="arrival-map";done=doneCallback;clock=timeSource!=null?timeSource:getTimer;waitingForFrame=timeSource==null;startedAt=int(clock());GameData.init();
            TravelMapArtwork.drawBackdrop(graphics,w,h);addChild(new TravelMapArtwork(w,h));
            route=new JourneyRouteView(TravelMapArtwork.cityPoint("KANSAS CITY",w,h),TravelMapArtwork.cityPoint(GameData.teamCity,w,h),"KANSAS CITY",GameData.teamCity,GameData.teamAccent,GameData.teamAccent,VisualAssetRegistry.transportPath(0),0,"arrival-vehicle",w,true);addChild(route);
            chrome=new JourneyChrome(w,h,{title:"WELCOME TO BASEBALL HEROES",transport:"ROOKIE TRANSPORT  ·  KANSAS CITY > "+GameData.teamCity,fromCity:"KANSAS CITY",toCity:GameData.teamCity,fromAccent:GameData.teamAccent,toAccent:GameData.teamAccent,arrival:true,hero:GameData.mainPlayer(),detail:"Tu primera parada es el estadio de tu nuevo club."},completeArrival);addChild(chrome);
            entrance=new MenuEntrance(this,timeSource);entrance.track(chrome,0,300,0,8);entrance.track(route,0,240);entrance.play();
            addEventListener(Event.ENTER_FRAME,onFrame);
        }
        private function onFrame(e:Event):void {if(completed)return;if(waitingForFrame){startedAt=int(clock());waitingForFrame=false;}var elapsed:Number=Math.max(0,int(clock())-startedAt),p:Number=Math.min(1,elapsed/2600);route.setProgress(p);chrome.setProgress(p);if(elapsed>=4400)completeArrival();}
        private function completeArrival():void {if(completed)return;completed=true;removeEventListener(Event.ENTER_FRAME,onFrame);var fn:Function=done;done=null;if(fn!=null)fn();}
        public function dispose():void {if(entrance)entrance.dispose();completed=true;done=null;removeEventListener(Event.ENTER_FRAME,onFrame);if(route){route.dispose();route=null;}if(chrome){chrome.dispose();chrome=null;}}
    }
}
