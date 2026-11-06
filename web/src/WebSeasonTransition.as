package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    import com.bh.model.SpecialCardInventory;
    public class WebSeasonTransition extends WebSeasonSmoke {
        public function WebSeasonTransition() {
            super();ExternalInterface.addCallback("bhTransition",function(action:String=""):String {
                if(action=="finish") {
                    GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
                    GameData.seasonNumber=6;GameData.seasonGame=30;GameData.seasonComplete=false;
                    GameData.seasonWins=17;GameData.seasonLosses=12;GameData.seasonHits=70;GameData.seasonHomeRuns=20;GameData.seasonRbi=45;
                    GameData.leagueIndex=1;GameData.level=11;GameData.xp=3000;GameData.levelProgress=0;
                    GameData.energy=GameData.maxEnergy;GameData.coins=15000;GameData.cash=12;
                    GameData.specialMatch=null;GameData.specialEquipped[0]="card_rookie_ace";
                    GameData.specialOwned.card_rookie_ace.charges=2;GameData.specialOwned.card_rookie_ace.rechargeAt=0;
                    GameData.seasonResults=[];
                    for(var i:int=1;i<30;i++){
                        var o:Object=GameData.opponentForGame(i);
                        GameData.seasonResults.push({game:i,win:i<=17,homeScore:i<=17?5:2,awayScore:i<=17?2:5,scoreKnown:true,
                            opponentCity:o.city,opponentTeam:o.teamName,opponentAccent:o.accent});
                    }
                    GameData.startSeasonGame();
                    GameData.completeSeasonGame(7,4,6,1,20,7,[0,0,0,0,0,0,0,0,7],[0,0,0,0,0,0,0,0,4]);
                }
                if(action=="prepare")return JSON.stringify({advanced:GameData.prepareNextSeason()});
                if(action=="empty"){GameData.energy=0;GameData.save();}
                if(action=="refill"){GameData.energy=GameData.maxEnergy;GameData.save();}
                if(action=="model-start")return JSON.stringify({started:GameData.startSeasonGame()});
                return JSON.stringify({number:GameData.seasonNumber,game:GameData.seasonGame,complete:GameData.seasonComplete,
                    wins:GameData.seasonWins,losses:GameData.seasonLosses,hits:GameData.seasonHits,hr:GameData.seasonHomeRuns,rbi:GameData.seasonRbi,
                    goalSet:GameData.seasonGoalSet,goals:[GameData.seasonGoalHomeRuns,GameData.seasonGoalRbi],
                    energy:GameData.energy,coins:GameData.coins,cash:GameData.cash,xp:GameData.xp,level:GameData.level,league:GameData.leagueIndex,
                    order:GameData.battingOrder,players:GameData.battingOrderPlayers(),inventory:GameData.inventory,equipped:GameData.equipped,
                    cards:GameData.specialOwned,slots:GameData.specialSlotsUnlocked,cardOrder:GameData.specialEquipped,paid:GameData.specialMatch,
                    results:GameData.seasonResults,lastSeason:GameData.lastSeasonSummary,lastGame:GameData.lastGameSummary,
                    opponent:GameData.currentOpponent(),roadmap:[GameData.roadmapGames,GameData.roadmapWins,GameData.roadmapHomeRuns,GameData.roadmapRbi]});
            });
            ExternalInterface.addCallback("bhRecovery",function():String {
                var now:Number=new Date().time,s:Object=SpecialCardInventory.fresh("qa","card_rookie_ace");
                s.charges=0;s.rechargeAt=String(now+SpecialCardInventory.RECOVERY_MS);
                var results:Array=[];
                for each(var offset:Number in [0,SpecialCardInventory.RECOVERY_MS-1,SpecialCardInventory.RECOVERY_MS,2*SpecialCardInventory.RECOVERY_MS]) {
                    SpecialCardInventory.recover(s,now+offset);results.push({charges:s.charges,rechargeAt:s.rechargeAt});
                }
                return JSON.stringify({now:String(now),interval:SpecialCardInventory.RECOVERY_MS,steps:results});
            });
        }
    }
}
