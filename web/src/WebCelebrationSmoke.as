package {
    import flash.external.ExternalInterface;
    import flash.utils.getTimer;
    import com.bh.game.HitCinematic;
    import com.bh.visual.CelebrationArtwork;
    import com.bh.model.GameData;
    public class WebCelebrationSmoke extends WebSeasonTransition {
        private var cinematic:HitCinematic;
        private var now:int=0;
        private var createdMs:int=0;
        private var preparedMs:int=0;
        public function WebCelebrationSmoke() {
            super();
            var prepareAt:int=getTimer();CelebrationArtwork.warm();preparedMs=getTimer()-prepareAt;
            ExternalInterface.addCallback("bhCinematic",function(action:String,value:String="DOUBLE",rbi:int=1):String {
                if(action=="clear"||action=="show"||action=="run") {
                    if(cinematic){cinematic.dispose();if(cinematic.parent)cinematic.parent.removeChild(cinematic);cinematic=null;}
                }
                if(action=="show"||action=="run") {
                    now=0;var started:int=getTimer();
                    cinematic=new HitCinematic(960,720,function():int{return now;},uint(GameData.currentOpponent().accent));createdMs=getTimer()-started;
                    cinematic.name="qa-hit-cinematic";addChild(cinematic);
                    cinematic.play(value,rbi,value=="HOME RUN"?410:0);
                    if(action=="show") {cinematic.forceResultVisible();now=500;}
                }
                if(action=="time")now=int(value);
                return JSON.stringify({playing:cinematic?cinematic.isPlaying():false,ready:cinematic?cinematic.canContinue():true,createdMs:createdMs,preparedMs:preparedMs});
            });
        }
    }
}
