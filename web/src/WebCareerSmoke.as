package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebCareerSmoke extends WebSmoke {
        public function WebCareerSmoke() {
            super();ExternalInterface.addCallback("bhCareer",career);
        }
        private function career(action:String):String {
            if(action=="win")GameData.completeSeasonGame(3,0,3,1,4,3,[1,0,0,0,0,0,0,0,2],[0,0,0,0,0,0,0,0,0]);
            if(action=="advanced-item"){
                GameData.inventory.push(GameData.equipment("Purchased QA Bat","bat","RARE",0x4f86bf,6,0,0,0));GameData.save();
            }
            if(action=="load")GameData.load();
            return JSON.stringify({level:GameData.level,xp:GameData.xp,progress:GameData.levelProgress,
                league:GameData.leagueName(),leagueIndex:GameData.leagueIndex,seasonGame:GameData.seasonGame,
                energy:GameData.energy,maxEnergy:GameData.maxEnergy,coins:GameData.coins,cash:GameData.cash,
                rules:GameData.careerStartVersion,roster:GameData.roster,inventory:GameData.inventory,
                specialOwned:GameData.specialOwned,levelUp:GameData.lastLevelUpSummary,
                team:GameData.teamName,onboarding:GameData.onboardingStep});
        }
    }
}
