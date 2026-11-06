package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.desktop.NativeApplication;
    import flash.filesystem.*;
    import flash.net.SharedObject;
    import com.bh.model.GameData;
    public class CardPersistence059Smoke extends Sprite {
        private var legacy:Array=["card_rookie_ace","card_lenard_j","card_mio_flash","card_rex_slugger","card_hana_clutch","card_leo_lucky","card_ken_golden","card_sora_comet","card_tomo_wall"];
        public function CardPersistence059Smoke() {
            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,run);
        }
        private function run(e:InvokeEvent):void {
            try {
                GameData.init();
                if(e.arguments[0]=="seed") {
                    GameData.coins=34567;GameData.cash=42;GameData.energy=12;
                    GameData.seasonGame=17;GameData.seasonWins=10;GameData.seasonLosses=6;
                    GameData.teamName="PERSISTENCE QA";GameData.uniformNumber=77;
                    GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
                    GameData.specialOwned={};GameData.specialSlotsUnlocked=5;
                    for(var i:int=0;i<legacy.length;i++)GameData.specialOwned[legacy[i]]={level:1+i%3,copies:2+i,atBats:50+i,hits:20+i,rbi:11+i};
                    GameData.specialOwned.card_aria_nova={level:2,copies:4,atBats:3,hits:2,rbi:1};
                    GameData.specialEquipped=legacy.slice(0,5);GameData.save();
                    var so:SharedObject=SharedObject.getLocal("baseballHeroesRemakeSave");
                    if(so.data.version!=20)throw new Error("Schema changed");so.flush();
                    write("smoke-card-save-seed.txt","PASS: isolated v20 fixture seeded with all nine legacy IDs, card progress and a new card; wallet, season, lineup and hero settings saved.");
                } else {
                    if(GameData.coins!=34567||GameData.cash!=42||GameData.energy!=12)throw new Error("Wallet/energy changed");
                    if(GameData.seasonGame!=17||GameData.seasonWins!=10||GameData.seasonLosses!=6)throw new Error("Season changed");
                    if(GameData.teamName!="PERSISTENCE QA"||GameData.uniformNumber!=77||GameData.onboardingStep!=99)throw new Error("Hero/onboarding changed");
                    for(i=0;i<legacy.length;i++) {
                        var state:Object=GameData.specialCardState(legacy[i]);
                        if(!state||state.level!=1+i%3||state.copies!=2+i||state.atBats!=50+i||state.hits!=20+i||state.rbi!=11+i)throw new Error("Legacy state changed: "+legacy[i]);
                        if(i<5&&GameData.specialEquipped[i]!=legacy[i])throw new Error("Equipped order changed");
                    }
                    if(GameData.specialCardState("card_aria_nova").copies!=4)throw new Error("New card lost");
                    write("smoke-card-save-reload.txt","PASS: a second AIR process loaded the v20 fixture; all nine legacy IDs retained levels/copies/AB/H/RBI and equipped order; new card, wallet, energy, season, team name, uniform number and onboarding preserved.");
                }
                NativeApplication.nativeApplication.exit();
            } catch(error:Error){write("smoke-card-save-reload.txt","FAIL: "+error.message);NativeApplication.nativeApplication.exit(1);}
        }
        private function write(name:String,value:String):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/"+name);f.parent.createDirectory();
            var stream:FileStream=new FileStream();stream.open(f,FileMode.WRITE);stream.writeUTFBytes(value);stream.close();
        }
    }
}
