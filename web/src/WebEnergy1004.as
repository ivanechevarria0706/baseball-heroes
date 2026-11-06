package {
    import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.game.HomeHero;import com.bh.visual.HeroSprite;
    /** Private edge-case QA; never part of the published package. */
    public class WebEnergy1004 extends WebNotes1001 {
        private var energyView:EnergyShopScreen;
        public function WebEnergy1004(){super();ExternalInterface.addCallback("bhEnergy1004",runEnergy);}
        private function closeEnergy():void {if(energyView){energyView.dispose();removeChild(energyView);energyView=null;}}
        private function state():Object {return {coins:GameData.coins,cash:GameData.cash,energy:GameData.energy,cap:GameData.maxEnergy,at:GameData.energyAt,appearance:GameData.mainPlayer().appearance,equipped:GameData.equipped};}
        private function runEnergy(action:String="state",value:String=""):String {
            try {
                if(action=="close"){closeEnergy();return "{}";}
                if(action=="prepare") {GameData.starterTutorial=StarterTutorial.create();GameData.onboardingStep=99;GameData.coins=14000;GameData.cash=10;GameData.energy=24;GameData.maxEnergy=25;GameData.energyAt=String(new Date().time+300000);GameData.mainPlayer().accent=0xc3323b;GameData.save();}
                if(action=="show"){closeEnergy();energyView=new EnergyShopScreen(960,720,closeEnergy,closeEnergy,function(category:String):void{closeEnergy();});addChild(energyView);}
                if(action=="uniform") {
                    var actual:HomeHero=energyView.getChildByName("home-hero") as HomeHero,player:Object=GameData.mainPlayer();
                    var reference:HomeHero=new HomeHero(0,0,uint(player.accent),GameData.uniformNumber,String(player.name),null,null,player.appearance);
                    var actualArt:HeroSprite=actual.getChildAt(0) as HeroSprite,referenceArt:HeroSprite=reference.getChildAt(0) as HeroSprite;referenceArt.setFrame(actual.frameIndex);
                    var a:BitmapData=Bitmap(actualArt.getChildAt(0)).bitmapData,b:BitmapData=Bitmap(referenceArt.getChildAt(0)).bitmapData;
                    var av:Vector.<uint>=a.getVector(a.rect),bv:Vector.<uint>=b.getVector(b.rect);var equal:Boolean=av.length==bv.length;
                    for(var i:int=0;equal&&i<av.length;i++)equal=av[i]==bv[i];reference.dispose();
                    if(!equal)throw new Error("Energy hero differs from the canonical saved uniform");
                    return JSON.stringify({status:"PASS",savedAccent:player.accent,matchedBodyPixels:av.length});
                }
                if(action=="near-full"){GameData.energy=24;GameData.energyAt=String(new Date().time+450);GameData.save();}
                if(action=="model") {
                    var drink:Object=GameData.shopItemById("energy_drink"),crate:Object=GameData.shopItemById("energy_crate"),checks:Array=[];
                    GameData.coins=7000;GameData.cash=5;GameData.maxEnergy=25;GameData.energy=25;
                    if(GameData.purchaseShopItem(drink)!="FULL"||GameData.coins!=7000)throw new Error("Full refill charged");checks.push("full-no-charge");
                    GameData.energy=26;if(GameData.purchaseShopItem(crate)!="FULL"||GameData.cash!=5)throw new Error("Over-cap refill charged");checks.push("over-cap-no-charge");
                    GameData.energy=24;GameData.energyAt=String(new Date().time-1);
                    if(GameData.purchaseShopItem(drink)!="FULL"||GameData.coins!=7000||GameData.energy!=25)throw new Error("Recovered full charged");checks.push("natural-recovery-rechecked");
                    GameData.energy=24;GameData.energyAt=String(new Date().time+300000);GameData.coins=6999;
                    if(GameData.purchaseShopItem(drink)!="COINS"||GameData.energy!=24||GameData.coins!=6999)throw new Error("Insufficient coins changed save");checks.push("insufficient-coins-inert");
                    GameData.cash=4;if(GameData.purchaseShopItem(crate)!="CASH"||GameData.energy!=24||GameData.cash!=4)throw new Error("Insufficient cash changed save");checks.push("insufficient-cash-inert");
                    GameData.cash=5;if(GameData.purchaseShopItem(crate)!="OK"||GameData.energy!=44||GameData.cash!=0)throw new Error("Paid energy clipped");GameData.save();GameData.load();
                    if(GameData.energy!=44||GameData.cash!=0)throw new Error("Paid energy lost on reload");checks.push("whole-paid-amount-survives-reload");
                    var invalid:Object={category:"ENERGY",energy:0,coinPrice:1,cashPrice:0,unlockLeague:0};GameData.energy=20;GameData.coins=7000;
                    if(GameData.purchaseShopItem(invalid)!="INVALID"||GameData.coins!=7000)throw new Error("Empty refill charged");checks.push("empty-refill-rejected");
                    return JSON.stringify({status:"PASS",checks:checks});
                }
                return JSON.stringify(state());
            }catch(e:Error){return JSON.stringify({error:e.message});}
            return "{}";
        }
    }
}
