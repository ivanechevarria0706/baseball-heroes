package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebLineupSmoke extends WebSmoke {
        public function WebLineupSmoke() {
            super();
            ExternalInterface.addCallback("bhLineup",function(action:String=""):String {
                if(action=="bench") {
                    for(var i:int=0;i<12;i++) {
                        var p:Object=JSON.parse(JSON.stringify(GameData.roster[1]));
                        p.name="QA suplente "+i;p.grade=i==11?"RARE":"NORMAL";GameData.roster.push(p);
                    }
                    GameData.save();
                }
                return JSON.stringify({order:GameData.battingOrder,players:GameData.battingOrderPlayers(),
                    bench:GameData.substitutePlayers(),coins:GameData.coins,energy:GameData.energy,
                    level:GameData.level,league:GameData.leagueIndex,xp:GameData.xp});
            });
        }
    }
}
