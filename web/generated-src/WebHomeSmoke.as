package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebHomeSmoke extends WebSmoke {
        public function WebHomeSmoke() {
            super();
            ExternalInterface.addCallback("bhHome",function(action:String="",value:String=""):String {
                if(action=="stadium"){GameData.stadiumActive.background=value;GameData.save();}
                return JSON.stringify({level:GameData.level,league:GameData.leagueIndex,xp:GameData.xp,coins:GameData.coins,
                    energy:GameData.energy,order:GameData.battingOrder,players:GameData.battingOrderPlayers(),hero:GameData.mainPlayer(),
                    gateAt:String(GameData.gateIncomeLastAt),gateCount:GameData.gateIncomeCollected,canCollect:GameData.canCollectGateIncome(),
                    gateAmount:GameData.gateIncomeAmount(),stadium:GameData.stadiumActive.background});
            });
        }
    }
}
