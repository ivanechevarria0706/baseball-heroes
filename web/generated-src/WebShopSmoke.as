package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebShopSmoke extends WebEquipmentSmoke {
        public function WebShopSmoke(){super();ExternalInterface.addCallback("bhShop",shopState);}
        private function shopState(action:String=""):String {
            if(action=="fund"){GameData.leagueIndex=4;GameData.coins=500000;GameData.cash=100;GameData.save();}
            if(action=="poor"){GameData.coins=0;GameData.cash=0;GameData.save();}
            if(action=="rookie"){GameData.leagueIndex=0;GameData.save();}
            return JSON.stringify({catalog:GameData.shopCatalog(),inventory:GameData.inventory,equipped:GameData.equipped,coins:GameData.coins,cash:GameData.cash,
                stadium:GameData.stadiumOwned,energy:GameData.energy,level:GameData.level,league:GameData.leagueIndex,xp:GameData.xp,order:GameData.battingOrder});
        }
    }
}
