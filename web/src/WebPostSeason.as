package {
    import flash.display.*;import flash.external.ExternalInterface;
    import com.bh.model.GameData;import com.bh.model.PostSeason;import com.bh.core.Game;
    public class WebPostSeason extends WebSmoke {
        public function WebPostSeason(){super();ExternalInterface.addCallback("bhPost",post);}
        private function match(c:DisplayObjectContainer):Object {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d;if(d is DisplayObjectContainer){var found:Object=match(d as DisplayObjectContainer);if(found)return found;}}return null;}
        private function post(action:String="state",value:int=0):String {
            if(action=="seed"||action=="seed-ineligible"){
                GameData.starterTutorial={version:1,enabled:false,stage:9,skipped:true,claimed:false,hints:{}};
                GameData.postSeason=null;GameData.postSeasonMode=false;GameData.specialMatch=null;
                for each(var starter:Object in GameData.roster)starter.condition={energy:6,at:"0"};
                GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
                GameData.leagueIndex=0;GameData.seasonNumber=6;GameData.seasonGame=30;GameData.seasonComplete=false;
                GameData.seasonWins=action=="seed-ineligible"?9:value==4?14:23;GameData.seasonLosses=29-GameData.seasonWins;
                GameData.seasonResults=[];GameData.energy=25;GameData.completeSeasonGame(7,1,3,1,4,7);
            }
            if(action=="legacy"){GameData.postSeason=null;GameData.save();}
            if(action=="no-energy"){GameData.energy=0;GameData.save();}
            if(action=="refill"){GameData.energy=25;for each(var p:Object in GameData.roster)p.condition={energy:6,at:"0"};GameData.save();}
            if(action=="model-start"){GameData.postSeasonMode=true;return JSON.stringify({started:GameData.startPostSeasonGame()});}
            if(action=="regular-start"){GameData.postSeasonMode=false;return JSON.stringify({started:GameData.startSeasonGame()});}
            if(action=="prepare")return JSON.stringify({advanced:GameData.prepareNextSeason()});
            if(action=="model-win"||action=="model-loss"||action=="model-tie"){
                GameData.postSeasonMode=true;GameData.completePostSeasonGame(action=="model-loss"?1:7,action=="model-win"?1:7,3,1,4,2,[7,0,0,0,0,0,0,0,0],[1,0,0,0,0,0,0,0,0],[]);
            }
            if(action=="engine-win"||action=="engine-loss"||action=="engine-tie"){
                var game:Object=match(this);if(!game)throw new Error("No actual Game actor");game["qaFinish"](action=="engine-loss"?1:7,action=="engine-win"?1:7);
            }
            return JSON.stringify({career:GameData.hallOfFame,post:GameData.postSeason,history:GameData.postSeasonHistory,paid:GameData.specialMatch,mode:GameData.postSeasonMode,energy:GameData.energy,coins:GameData.coins,xp:GameData.xp,level:GameData.level,league:GameData.leagueIndex,season:GameData.seasonNumber,game:GameData.seasonGame,wins:GameData.seasonWins,losses:GameData.seasonLosses,lastGame:GameData.lastGameSummary,lastSeason:GameData.lastSeasonSummary,cards:GameData.specialOwned,appearance:GameData.heroAppearance(),key:PostSeason.key(GameData.postSeason),opponent:GameData.currentOpponent()});
        }
    }
}
