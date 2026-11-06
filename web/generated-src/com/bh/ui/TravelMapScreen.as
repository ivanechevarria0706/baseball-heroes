package com.bh.ui {
    import flash.display.Sprite;import flash.events.Event;import flash.utils.getTimer;import flash.geom.Point;
    import com.bh.audio.AudioCueSequence;
    import com.bh.model.GameData;import com.bh.visual.TravelMapArtwork;import com.bh.visual.VisualAssetRegistry;
    /** Existing 2.8s movement / 4.3s automatic handoff, with shared journey chrome. */
    public class TravelMapScreen extends Sprite {
        private var cues:AudioCueSequence;private var entrance:MenuEntrance,flightCue:Boolean=false;
        private var forward:Function,back:Function,clock:Function,startedAt:int,completed:Boolean=false;
        private var route:JourneyRouteView,chrome:JourneyChrome,waitingForFrame:Boolean;
        public function TravelMapScreen(w:Number,h:Number,continueCallback:Function,homeCallback:Function,timeSource:Function=null) {
            name="season-travel";forward=continueCallback;back=homeCallback;clock=timeSource!=null?timeSource:getTimer;waitingForFrame=timeSource==null;startedAt=int(clock());cues=new AudioCueSequence(clock);GameData.init();
            TravelMapArtwork.drawBackdrop(graphics,w,h);addChild(new TravelMapArtwork(w,h));
            var opponent:Object=GameData.currentOpponent(),origin:Point=TravelMapArtwork.cityPoint(GameData.teamCity,w,h),destination:Point=TravelMapArtwork.cityPoint(String(opponent.city),w,h),local:Boolean=Point.distance(origin,destination)<8;
            route=new JourneyRouteView(origin,destination,GameData.teamCity,String(opponent.city),GameData.teamAccent,uint(opponent.accent),VisualAssetRegistry.transportPath(GameData.leagueIndex),GameData.leagueIndex,"travel-vehicle",w);addChild(route);
            var n:int=GameData.seasonNumber,mod:int=n%100,suffix:String=mod>=11&&mod<=13?"TH":n%10==1?"ST":n%10==2?"ND":n%10==3?"RD":"TH";
            var labels:Array=["ROOKIE BUS","SINGLE-A BUS","DOUBLE-A COACH","TRIPLE-A FLIGHT","MAJOR AIRLINER"];
            chrome=new JourneyChrome(w,h,{title:GameData.postSeasonMode?GameData.competitionTitle():n+suffix+" REGULAR SEASON",transport:labels[Math.max(0,Math.min(4,GameData.leagueIndex))]+"  ·  "+(local?"HOME GAME":GameData.teamCity+" > "+opponent.city),
                fromCity:GameData.teamCity,toCity:opponent.city,fromAccent:GameData.teamAccent,toAccent:opponent.accent,local:local,arrival:false,
                detail:(GameData.postSeasonMode?GameData.competitionDetail():"GAME "+GameData.seasonGame+" / 30")+"  ·  "+opponent.teamName+"  ·  OVR "+opponent.rating+"  ·  "+opponent.pitcherName},completeTravel,goHome);addChild(chrome);
            flightCue=GameData.leagueIndex>=3&&!local;
            entrance=new MenuEntrance(this,timeSource);entrance.track(chrome,0,300,0,8);entrance.track(route,0,240);entrance.play();if(!waitingForFrame&&flightCue)cues.enqueue("plane.mp3",0,.65);
            addEventListener(Event.ENTER_FRAME,onFrame);
        }
        private function onFrame(e:Event):void {if(completed)return;if(waitingForFrame){startedAt=int(clock());waitingForFrame=false;if(flightCue)cues.enqueue("plane.mp3",0,.65);}cues.advance();var elapsed:Number=Math.max(0,int(clock())-startedAt),p:Number=Math.min(1,elapsed/2800);route.setProgress(p);chrome.setProgress(p);if(elapsed>=4300)completeTravel();}
        private function completeTravel():void {if(completed)return;completed=true;removeEventListener(Event.ENTER_FRAME,onFrame);var fn:Function=forward;forward=back=null;if(fn!=null)fn();}
        private function goHome():void {if(completed)return;completed=true;removeEventListener(Event.ENTER_FRAME,onFrame);var fn:Function=back;forward=back=null;if(fn!=null)fn();}
        public function dispose():void {if(entrance)entrance.dispose();cues.dispose();if(route){route.dispose();route=null;}if(chrome){chrome.dispose();chrome=null;}completed=true;forward=back=null;removeEventListener(Event.ENTER_FRAME,onFrame);}
    }
}
