package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebSeasonSmoke extends WebHomeSmoke {
        public function WebSeasonSmoke() {
            super();ExternalInterface.addCallback("bhSeason",function(action:String=""):String {
                if(action=="history") {
                    GameData.seasonGame=3;GameData.seasonWins=1;GameData.seasonLosses=1;GameData.seasonNumber=6;
                    GameData.seasonResults=[
                        {game:1,win:true,homeScore:5,awayScore:4,scoreKnown:true,opponentCity:"NEW YORK",opponentTeam:"HISTORICAL",opponentAccent:0x456789},
                        {game:2,win:false,homeScore:0,awayScore:0,scoreKnown:false,opponentCity:"COLORADO",opponentTeam:"LEGACY",opponentAccent:0x456789}
                    ];GameData.save();
                }
                if(action=="last") {GameData.seasonGame=30;GameData.seasonComplete=false;GameData.save();}
                if(action=="complete") {GameData.seasonGame=30;GameData.seasonComplete=true;GameData.seasonWins=16;GameData.seasonLosses=14;GameData.seasonResults.push({game:30,win:true,homeScore:7,awayScore:4,scoreKnown:true});GameData.save();}
                return JSON.stringify({game:GameData.seasonGame,number:GameData.seasonNumber,complete:GameData.seasonComplete,results:GameData.seasonResults,
                    level:GameData.level,league:GameData.leagueIndex,xp:GameData.xp,coins:GameData.coins,energy:GameData.energy,order:GameData.battingOrder,opponent:GameData.currentOpponent()});
            });
        }
    }
}
