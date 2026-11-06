package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebEquipmentSmoke extends WebSmoke {
        public function WebEquipmentSmoke() {
            super();ExternalInterface.addCallback("bhEquipment",equipmentState);
        }
        private function equipmentState(action:String=""):String {
            if(action=="seed") {
                var slots:Array=["bat","glove","belt","helmet","shoes","goggles"];
                for each(var slot:String in slots)for(var i:int=0;i<20;i++) {
                    var item:Object=GameData.equipment("QA "+slot+" "+i,slot,"ELITE",0x7736a1+i*129,slot=="bat"?i:0,slot=="helmet"?i:0,slot=="shoes"?i:0,slot=="glove"?i:0);
                    GameData.inventory.push(item);
                }
                GameData.mainPlayer().power=98;GameData.save();
            }
            return JSON.stringify({inventory:GameData.inventory,equipped:GameData.equipped,hero:GameData.mainPlayer(),coins:GameData.coins,cash:GameData.cash,
                level:GameData.level,league:GameData.leagueIndex,xp:GameData.xp,order:GameData.battingOrder,energy:GameData.energy});
        }
    }
}
