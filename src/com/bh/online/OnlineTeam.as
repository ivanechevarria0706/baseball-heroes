package com.bh.online {
    import com.bh.model.GameData;
    public class OnlineTeam {
        /** Export only a bounded exhibition lineup, never the save or currency. */
        public static function snapshot():Object {
            var lineup:Array=GameData.battingOrderPlayers(),hero:Object=GameData.mainPlayer(),players:Array=[],heroIndex:int=-1;
            if(lineup.length!=9)throw new Error("Prepare a lineup of nine players.");
            for(var i:int=0;i<lineup.length;i++) {
                var p:Object=lineup[i];if(p===hero)heroIndex=i;
                var index:int=GameData.roster.indexOf(p);
                players.push({id:GameData.stablePlayerId(p),name:String(p.name).substr(0,32),power:limit(GameData.matchPower(p)),contact:limit(GameData.matchContact(p)),speed:limit(GameData.matchSpeed(p))});
            }
            if(heroIndex<0)throw new Error("Include your hero in the lineup before publishing.");
            GameData.save();
            return {name:GameData.teamName.substr(0,28),accent:GameData.teamAccent,heroIndex:heroIndex,players:players,heroAverage:Math.min(1000,Math.round(1000*int(hero.careerHits)/Math.max(1,int(hero.careerAtBats))))};
        }
        private static function limit(n:int):int {return Math.max(1,Math.min(200,n));}
    }
}
