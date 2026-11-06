package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;import com.bh.model.CareerAchievements;import com.bh.model.MatchBoxScore;
    public class WebHallOfFame extends WebSmoke {
        public function WebHallOfFame(){super();ExternalInterface.addCallback("bhHall",hall);}
        private function hall(action:String="state",value:int=0):String {
            if(action=="near"){
                GameData.hallOfFame=CareerAchievements.create();var stats:Object=GameData.hallOfFame.stats;
                stats.hits=199;stats.homeRuns=99;stats.rbi=149;stats.grandSlams=9;stats.triples=49;stats.mvp=49;stats.trades=14;stats.cardsBought=39;
                GameData.coins=500000;GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.save();
            }
            if(action=="fixture"){
                GameData.starterTutorial={version:1,enabled:false,stage:9,skipped:true,claimed:false,hints:{}};
                var hero:Object=GameData.mainPlayer();var box:MatchBoxScore=new MatchBoxScore([hero,GameData.roster[1]]);
                box.record(0,hero,"SINGLE",0);box.record(0,hero,"SINGLE",0);box.record(0,hero,"SINGLE",0);box.record(0,hero,"TRIPLE",1);box.record(0,hero,"HOME RUN",4);
                box.record(1,GameData.roster[1],"TRIPLE",0);box.record(1,GameData.roster[1],"SINGLE",0);
                GameData.completeSeasonGame(6,5,7,1,9,5,[6,0,0,0,0,0,0,0,0],[5,0,0,0,0,0,0,0,0],box.snapshot());
            }
            if(action=="repeat")CareerAchievements.match(GameData.hallOfFame,GameData.leagueIndex+":"+GameData.seasonNumber+":"+(GameData.seasonGame-1),String(GameData.mainPlayer().name),6,5,GameData.lastGameSummary.boxScore);
            if(action=="invalid")return JSON.stringify(GameData.claimHallTrophy("missing",0));
            if(action=="incomplete")return JSON.stringify(GameData.claimHallTrophy("hits",3));
            if(action=="claim-again")return JSON.stringify(GameData.claimHallTrophy("triples",0));
            if(action=="buy")GameData.drawSpecialClassPack("C");
            if(action=="scout")GameData.scout("BRONZE");
            if(action=="no-money"){GameData.coins=0;GameData.cash=0;GameData.save();}
            if(action=="trade"){
                GameData.specialMatch=null;GameData.coins=500000;var ids:Array=[];
                for(var i:int=0;i<3;i++)ids.push(GameData.drawSpecialClassPack("C").card.id);
                GameData.tradeSpecialCards(ids,"CASH"); // Insufficient cash cannot count.
                var before:int=GameData.hallOfFame.stats.trades;
                GameData.tradeSpecialCards(ids,"COINS");if(GameData.hallOfFame.stats.trades!=before+1)throw new Error("Trade must count once");
            }
            return JSON.stringify({hall:GameData.hallOfFame,available:GameData.hallAvailable(),coins:GameData.coins,level:GameData.level,league:GameData.leagueIndex,season:GameData.seasonNumber,game:GameData.seasonGame,missions:GameData.missionCatalog(),claims:GameData.missionClaims,box:GameData.lastGameSummary?GameData.lastGameSummary.boxScore:[]});
        }
    }
}
