package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebUpgrade108 extends WebUpgrade107 {
        public function WebUpgrade108(){super();ExternalInterface.addCallback("bh108",run108);}
        private function run108(action:String="state"):String {
            if(action=="model"){
                var beforeCoins:int=GameData.coins,beforeEnergy:int=GameData.energy;
                GameData.socialState.visits={coins:0,energy:0};
                var data:Object={userId:"qa",members:[],links:[],totals:{energy:0,key:0,letter:0},visits:{coins:20,energy:1},giftsSent:0,giftsReceived:0};
                GameData.applySocialSnapshot(data);GameData.applySocialSnapshot(data);
                if(GameData.coins!=beforeCoins+20||GameData.energy!=beforeEnergy+1)return JSON.stringify({error:"duplicate visit reward"});
                data.visits={coins:0,energy:0};GameData.applySocialSnapshot(data);
                if(GameData.socialState.visits.coins!=20||GameData.socialState.visits.energy!=1)return JSON.stringify({error:"stale response reduced totals"});
                GameData.coins=beforeCoins;GameData.energy=beforeEnergy;GameData.socialState.visits={coins:0,energy:0};GameData.save();return JSON.stringify({status:"PASS",duplicateRewardRejected:true,staleTotalsCannotDecrease:true});
            }
            return JSON.stringify({coins:GameData.coins,energy:GameData.energy,appearance:GameData.heroAppearance(),equipment:GameData.equipped,stadium:GameData.stadiumActive,visits:GameData.socialState.visits});
        }
    }
}
