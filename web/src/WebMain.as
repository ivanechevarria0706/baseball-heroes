package {
    import flash.display.Sprite;
    import flash.events.UncaughtErrorEvent;
    import flash.external.ExternalInterface;
    import com.bh.Main;
    import com.bh.model.GameData;
    import com.bh.online.FriendInvite;
    import com.bh.visual.CelebrationArtwork;
    import com.bh.visual.HeroArtwork;
    import com.bh.visual.HeroSprite;
    [SWF(width="960",height="720",frameRate="30",backgroundColor="#143148")]
    public class WebMain extends Sprite {
        public function WebMain() {
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{
                ExternalInterface.call("BHWeb.gameError",String(e.error));
            });
            // The original used the account identity for its hero. Only a
            // genuinely new cloud career receives the web nickname; an existing
            // save, including one at onboarding step zero, is never renamed.
            var initial:String=String(ExternalInterface.call("BHWeb.initialSave"));
            GameData.init();
            if(initial=="null") {
                var session:Object=JSON.parse(String(ExternalInterface.call("BHWeb.session")));
                var nickname:String=String(session.user.name).replace(/^\s+|\s+$/g, "").substr(0,24);
                if(nickname.length){
                    var player:Object=GameData.mainPlayer(),oldName:String=String(player.name);
                    for(var j:int=1;j<GameData.roster.length;j++)if(String(GameData.roster[j].name)==nickname){nickname=nickname.substr(0,19)+" Hero";break;}
                    player.name=nickname;
                    for(var i:int=0;i<GameData.battingOrder.length;i++)if(String(GameData.battingOrder[i])==oldName)GameData.battingOrder[i]=nickname;
                    GameData.teamName=(nickname+" HEROES").substr(0,18);
                    GameData.save();
                }
            }
            // Keep the first bitmap decode inside the loading screen, before play.
            CelebrationArtwork.warm();
            FriendInvite.capture();
            addChild(new Main());
            // Palette processing is expensive on the first use in Ruffle.
            // Prepare the current hero while the loading overlay is visible.
            // PitcherBodySprite and FieldingSprite prepare their shared caches
            // at match creation; the old IllustratedSprite pitcher is unused.
            var hero:Object=GameData.mainPlayer();
            var heroArt:HeroSprite=new HeroSprite(String(hero.name),uint(hero.accent),null,"batter");
            heroArt.warmAll();heroArt.dispose();
            ExternalInterface.addCallback("bhFlush",function():void { GameData.save(); });
            ExternalInterface.addCallback("bhNewCareer",function():Boolean { GameData.startNewCareer(); return true; });
            ExternalInterface.call("BHWeb.ready");
        }
    }
}
