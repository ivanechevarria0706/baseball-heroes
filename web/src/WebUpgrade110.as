package {
    import flash.display.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.ui.*;
    public class WebUpgrade110 extends WebUpgrade109 {
        private var view110:BatterShopOverlay,checks110:int=0;
        public function WebUpgrade110(){super();ExternalInterface.addCallback("bh110",run110);}
        private function assert110(ok:Boolean,label:String):void {checks110++;if(!ok)throw new Error(label);}
        private function close110():void {if(view110){view110.dispose();removeChild(view110);view110=null;}}
        private function run110(action:String="model",value:String="4"):String {
            try {
                if(action=="state")return JSON.stringify({coins:GameData.coins,cash:GameData.cash,league:GameData.leagueIndex,last:GameData.lastSpecialDraw,owned:GameData.ownedSpecialCards()});
                if(action=="close"){close110();return JSON.stringify({ok:true});}
                if(action=="shop"){
                    close110();GameData.starterTutorial=StarterTutorial.create();GameData.leagueIndex=int(value);GameData.specialMatch=null;GameData.coins=500000;GameData.cash=500;GameData.save();
                    view110=new BatterShopOverlay(close110);view110.y=90;addChild(view110);return JSON.stringify({ok:true});
                }
                checks110=0;GameData.starterTutorial=StarterTutorial.create();GameData.specialMatch=null;GameData.specialEquipped=[null,null,null,null,null];GameData.specialOwned={};GameData.coins=1000000;GameData.cash=10000;GameData.leagueIndex=4;
                var defs:Array=SpecialCardCatalog.classPacks();assert110(defs.length==7,"seven observed variants");
                for each(var p:Object in defs){
                    var weights:Array=SpecialCardCatalog.packWeights(p.packClass),sum:Number=0;
                    for each(var row:Object in weights){assert110(SpecialCardCatalog.gradeAllowed(p.cardClass,row.grade),"legal weighted grade");sum+=row.chance;}
                    assert110(Math.abs(sum-1)<.000001,"normalized weights");
                    for(var i:int=0;i<1000;i++){var grade:String=SpecialCardCatalog.packGrade(p.packClass,i/1000);assert110(p.grades.indexOf(grade)>=0&&SpecialCardCatalog.gradeAllowed(p.cardClass,grade),"variant grade range "+p.packClass);}
                    for(i=0;i<5;i++){
                        var cost:Object=GameData.specialClassPackCost(p.packClass),coin:int=GameData.coins,cash:int=GameData.cash,count:int=GameData.ownedSpecialCards().length;
                        var result:Object=GameData.drawSpecialClassPack(p.packClass);
                        assert110(result.status=="OK"&&result.card.cardClass==p.cardClass&&p.grades.indexOf(result.card.grade)>=0,"actual draw "+p.packClass);
                        assert110(GameData.coins==coin-cost.coins&&GameData.cash==cash-cost.cash&&GameData.ownedSpecialCards().length==count+1,"one charge and one instance");
                    }
                }
                assert110(GameData.specialClassPackCost("C").coins==5000,"observed career C price");
                assert110(GameData.specialClassPackCost("B+").coins==15000&&GameData.specialClassPackCost("B++").cash==45,"B variants no longer alias");
                assert110(GameData.specialClassPackCost("A+").coins==45000&&GameData.specialClassPackCost("A++").cash==80,"A variants no longer alias");
                assert110(SpecialCardCatalog.packGrade("A++",0)=="ELITE"&&SpecialCardCatalog.packGrade("A++",.8)=="HERO","A++ 80/20 boundary");
                coin=GameData.coins;cash=GameData.cash;count=GameData.ownedSpecialCards().length;GameData.leagueIndex=0;
                assert110(GameData.drawSpecialClassPack("B").status=="LOCKED"&&GameData.drawSpecialClassPack("A++").status=="LOCKED","league locks");
                assert110(GameData.drawSpecialClassPack("unknown").status=="INVALID_PACK","invalid pack");
                assert110(GameData.coins==coin&&GameData.cash==cash&&GameData.ownedSpecialCards().length==count,"locked/invalid no mutation");
                GameData.coins=0;GameData.cash=0;assert110(GameData.drawSpecialClassPack("C").status=="COINS"&&GameData.drawSpecialClassPack("B++").status=="CASH","insufficient funds");
                GameData.starterTutorial=StarterTutorial.create(true);GameData.coins=6000;GameData.specialOwned={};assert110(GameData.specialClassPackCost("C").coins==6000,"starter contract");result=GameData.drawSpecialClassPack("C");assert110(result.card.catalogId=="card_lenard_j"&&GameData.coins==0&&GameData.starterTutorial.stage==1,"starter Lenard/charge/stage");
                GameData.starterTutorial=StarterTutorial.create();GameData.coins=1000000;GameData.cash=10000;GameData.leagueIndex=4;
                for each(var cls:String in ["C","B","A","S"])for(i=0;i<1000;i++)assert110(SpecialCardCatalog.gradeAllowed(cls,SpecialCardCatalog.classPackGrade(i/1000,cls)),"class reward legal");
                for(i=0;i<40;i++){result=GameData.drawSpecialCardPack(i%2==0);assert110(result.status=="OK"&&SpecialCardCatalog.gradeAllowed(result.card.cardClass,result.card.grade),"mixed reward legal");}
                for each(cls in ["C","B"]){
                    GameData.mysteryInventory=MysteryInventory.create();GameData.mysteryInventory.packs[cls]=1;result=GameData.mysteryOpenPack(cls);var c:Object=GameData.specialCardById(result.reward.cardId);assert110(result.status=="OK"&&SpecialCardCatalog.gradeAllowed(c.cardClass,c.grade),"mystery pack legal");
                }
                var legacy:String=GameData.qa107Grant("card_kai_captain").instanceId;GameData.specialCardState(legacy).atBats=17;GameData.specialCardState(legacy).hits=8;GameData.specialCardState(legacy).enhancement=2;GameData.specialCardState(legacy).level=3;GameData.specialEquipped[0]=legacy;
                var snapshot:Object=JSON.parse(JSON.stringify(GameData.specialCardState(legacy)));GameData.save();GameData.load();
                for(var key:String in snapshot)assert110(GameData.specialCardState(legacy)[key]===snapshot[key],"legacy state field "+key);
                assert110(GameData.isSpecialCardEquipped(legacy)&&GameData.specialCardById(legacy).grade=="HERO","legacy HERO slot and grade preserved");
                GameData.mysteryInventory=MysteryInventory.create();GameData.save();return JSON.stringify({status:"PASS",checks:checks110,variants:defs,legacyHeroPreserved:true});
            }catch(e:Error){return JSON.stringify({error:e.message,checks:checks110});}
            return "{}";
        }
    }
}
