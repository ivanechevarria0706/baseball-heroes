package {
    import flash.display.*;
    import flash.external.ExternalInterface;
    import com.bh.model.*;
    import com.bh.ui.GameResultPanel;
    public class WebBats extends WebParity {
        private var result:GameResultPanel;
        public function WebBats(){super();ExternalInterface.addCallback("bhBats",call);}
        private function check(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
        private function fixture():void {
            GameData.specialMatch=null;GameData.postSeason=null;GameData.postSeasonMode=false;
            GameData.seasonComplete=false;GameData.seasonGame=1;GameData.seasonNumber=1;GameData.seasonWins=0;GameData.seasonLosses=0;
            GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.energy=25;GameData.cash=60;
            for each(var p:Object in GameData.roster)p.condition={energy:6,at:"0"};
        }
        private function call(action:String="state",value:int=0):String {try{return run(action,value);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}
        private function run(action:String,value:int):String {
            var item:Object=ConsumableBats.byId("bat094_contact400"),key:String,paid:Object,energy:int,cash:int;
            if(action=="model"){
                fixture();GameData.consumableBats=ConsumableBats.create();var permanent:Object=GameData.equipped.bat;
                GameData.cash=11;cash=GameData.cash;check(GameData.purchaseShopItem(item)=="CASH"&&GameData.cash==cash&&GameData.batStock(item)==0,"cannot buy with insufficient cash");
                GameData.cash=60;check(GameData.purchaseShopItem(item)=="OK"&&GameData.cash==48&&GameData.batStock(item)==5,"pack grants five for twelve");
                check(GameData.purchaseShopItem(item)=="OK"&&GameData.cash==36&&GameData.batStock(item)==10,"packs stack");
                check(GameData.inventory.filter(function(p:Object,...rest):Boolean{return p.consumableId==item.consumableId;}).length==1,"one inventory stack");
                check(GameData.equipItem(item)&&GameData.consumableBats.returnName==permanent.name,"return to previously equipped permanent");
                check(GameData.equipmentBonus("contact")>=400&&GameData.matchContact(GameData.mainPlayer())<=99,"raw +400, normalized match stat");
                GameData.energy=0;check(!GameData.startSeasonGame()&&GameData.batStock(item)==10,"rejected start consumes nothing");
                GameData.energy=25;check(GameData.startSeasonGame()&&GameData.batStock(item)==9,"one unit on paid fixture");paid=GameData.specialMatch;energy=GameData.energy;
                check(GameData.startSeasonGame()&&GameData.batStock(item)==9&&GameData.energy==energy,"reentry does not consume again");
                check(!GameData.equipItem(permanent),"cannot change reserved bat");
                GameData.load();check(GameData.batStock(item)==9&&GameData.specialMatch.key==paid.key&&GameData.specialMatch.batSnapshot.contact==400,"reservation survives saved reload");
                key=String(GameData.specialMatch.key);GameData.completeSeasonGame(7,1,3,1,4,7,null,null,null,{fixtureKey:key});
                check(GameData.batStock(item)==9&&!GameData.consumableBats.expired&&GameData.equipped.bat.consumableId==item.consumableId,"nonfinal bat stays equipped");
                GameData.completeSeasonGame(7,1,3,1,4,7,null,null,null,{fixtureKey:key});check(GameData.batStock(item)==9,"completion replay does not consume");
                for each(var p:Object in GameData.roster)p.condition={energy:6,at:"0"};
                GameData.consumableBats.stock[item.consumableId]=1;GameData.save();check(GameData.startSeasonGame()&&GameData.batStock(item)==0,"last unit reserved");
                GameData.load();check(GameData.equipmentBonus("contact")>=400&&GameData.equipped.bat.consumableId==item.consumableId,"last unit retains bonus after reload");
                key=String(GameData.specialMatch.key);GameData.completeSeasonGame(4,3,3,1,4,4,null,null,null,{fixtureKey:key});
                check(GameData.equipped.bat.name==permanent.name&&GameData.consumableBats.expired.id==item.id,"exhaustion restores permanent and persists notice");
                GameData.load();check(GameData.consumableBats.expired.fixture==key&&GameData.batStock(item)==0,"notice persists until acknowledgment");
                check(!GameData.equipItem(item),"empty bat cannot equip");GameData.acknowledgeBatExpired();GameData.load();check(!GameData.consumableBats.expired,"acknowledgment persists");
                GameData.consumableBats.stock[item.id]=ConsumableBats.CAP-4;cash=GameData.cash;
                check(GameData.purchaseShopItem(item)=="FULL"&&GameData.cash==cash,"stock cap cannot debit");
                GameData.consumableBats=ConsumableBats.create();GameData.save();
                return JSON.stringify({status:"PASS",checks:15});
            }
            if(action=="seed"){fixture();GameData.consumableBats=ConsumableBats.create();GameData.save();}
            if(action=="last") {GameData.levelProgress=GameData.levelXpTarget()-10;GameData.consumableBats.stock[item.id]=1;GameData.equipItem(item);GameData.save();}
            if(action=="reserve"){check(GameData.startSeasonGame(),"start");}
            if(action=="finish"){
                key=String(GameData.specialMatch.key);GameData.completeSeasonGame(4,3,2,0,4,2,[0,0,0,0,0,0,0,0,4],[0,0,0,0,0,0,0,0,3],[],{fixtureKey:key});
            }
            if(action=="result"){
                if(result){result.dispose();removeChild(result);}GameData.lastGameSummary.levelUp=null;
                result=new GameResultPanel(960,720,GameData.lastGameSummary,function():void{result.dispose();removeChild(result);result=null;});addChild(result);
            }
            if(action=="post"){
                fixture();GameData.consumableBats.stock[item.id]=1;GameData.equipItem(item);GameData.seasonNumber=5;GameData.seasonGame=30;GameData.seasonWins=23;GameData.seasonLosses=6;GameData.completeSeasonGame(7,1,3,1,4,7);
                GameData.postSeasonMode=true;check(GameData.startPostSeasonGame()&&GameData.batStock(item)==0,"post reserve");paid=GameData.specialMatch;
                check(GameData.startPostSeasonGame()&&GameData.specialMatch.key==paid.key&&GameData.batStock(item)==0,"post reentry");
                GameData.load();check(GameData.matchBat().contact==400,"post last bat after reload");GameData.postSeasonMode=true;
                GameData.completePostSeasonGame(2,2,2,0,4,1);check(GameData.consumableBats.expired&&GameData.equipped.bat.name==GameData.consumableBats.returnName,"tie consumes paid post unit and restores permanent");
                GameData.acknowledgeBatExpired();GameData.save();return JSON.stringify({status:"PASS",post:GameData.postSeason});
            }
            return JSON.stringify({stock:GameData.consumableBats,equipped:GameData.equipped,bonus:GameData.equipmentBonus("contact"),cash:GameData.cash,energy:GameData.energy,paid:GameData.specialMatch,summary:GameData.lastGameSummary});
        }
    }
}
