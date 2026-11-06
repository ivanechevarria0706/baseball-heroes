package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;import com.bh.model.MysteryInventory;
    public class WebMystery extends WebSmoke {
        public function WebMystery(){super();ExternalInterface.addCallback("bhMystery",safeTest);}
        private function safeTest(action:String="state"):String {try{return test(action);}catch(e:Error){return JSON.stringify({status:"FAIL",message:e.message});}return "";}
        private function check(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
        private function test(action:String="state"):String {
            if(action=="seed"){
                GameData.mysteryInventory=MysteryInventory.create();GameData.mysteryInventory.boxes.rookie=3;GameData.mysteryInventory.boxes.single_a=2;GameData.mysteryInventory.keys=2;GameData.mysteryInventory.packs.C=1;
                GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.save();
            }
            if(action=="model"){
                var s:Object=MysteryInventory.create(),r:Object,old:Object,n:int,before:int;
                check(MysteryInventory.open(s,"wrong").status=="INVALID","invalid kind");check(MysteryInventory.open(s,"rookie").status=="EMPTY","empty box");
                MysteryInventory.addBox(s,"rookie");check(MysteryInventory.open(s,"rookie").status=="KEYS","no keys");check(s.boxes.rookie==1&&s.keys==0,"failed open inert");
                MysteryInventory.addKeys(s,100);check(s.keys==40,"key cap");s.boxes.rookie=50;check(!MysteryInventory.addBox(s,"rookie"),"box cap");
                r=MysteryInventory.recordGame(s,"fixture",true,28,0);check(r.keys==0&&r.boxes==0,"full inventory");
                old=JSON.parse(JSON.stringify(s));r=MysteryInventory.recordGame(s,"fixture",true,28,0);check(s.matches.length==old.matches.length&&s.keys==old.keys&&s.boxes.rookie==old.boxes.rookie&&s.boxes.single_a==old.boxes.single_a&&r.keys==0&&r.boxes==0&&r.coins==0,"duplicate fixture inert");
                s=MysteryInventory.create();r=MysteryInventory.recordGame(s,"loss",false,28,0);check(s.keys==0&&s.boxes.rookie==0,"loss not awarded");
                r=MysteryInventory.recordGame(s,"special",true,28,1);check(s.keys==1&&s.boxes.single_a==1,"special award");r=MysteryInventory.recordGame(s,"rival",true,30,1);check(r.coins==2000,"rival bonus");
                s=MysteryInventory.create();s.boxes.single_a=1;s.keys=3;check(MysteryInventory.open(s,"single_a",0).status=="OK"&&s.keys==0&&s.boxes.single_a==0&&s.pending.amount==2000,"green costs exactly three keys");
                var stable:Object=GameData.mysteryInventory;var coins:int=GameData.coins,cash:int=GameData.cash,energy:int=GameData.energy;
                for each(var roll:Number in [0,.5,.75,.9,.98]){
                    GameData.mysteryInventory=MysteryInventory.create();GameData.mysteryInventory.boxes.rookie=1;GameData.mysteryInventory.keys=2;
                    r=MysteryInventory.open(GameData.mysteryInventory,"rookie",roll);check(r.status=="OK","open prize");
                    var pending:Object=JSON.parse(JSON.stringify(r.reward));check(GameData.mysteryInventory.keys==0&&GameData.mysteryInventory.boxes.rookie==0,"consume exactly");
                    check(MysteryInventory.open(GameData.mysteryInventory,"single_a").status=="PENDING","pending blocks second open");
                    GameData.mysteryInventory=MysteryInventory.normalize(GameData.mysteryInventory);check(GameData.mysteryInventory.pending&&GameData.mysteryInventory.pending.id==pending.id&&GameData.mysteryInventory.pending.type==pending.type&&GameData.mysteryInventory.pending.amount==pending.amount,"normalize retains prize");
                    check(GameData.mysteryCollect("stale").status=="STALE","stale claim inert");
                    var priorCoins:int=GameData.coins,priorCash:int=GameData.cash;GameData.energy=0;
                    check(GameData.mysteryCollect(pending.id).status=="OK","claim exact id");
                    if(pending.type=="COINS")check(GameData.coins==priorCoins+1000,"coin prize amount");
                    if(pending.type=="CASH")check(GameData.cash==priorCash+1,"cash prize amount");
                    if(pending.type=="KEY")check(GameData.mysteryInventory.keys==2,"key prize amount");
                    if(pending.type=="PACK")check(GameData.mysteryInventory.packs.C==1,"sealed pack prize");
                    if(pending.type=="ENERGY")check(GameData.energy==3,"energy prize amount");
                    before=GameData.coins;check(GameData.mysteryCollect(pending.id).status=="STALE"&&GameData.coins==before,"repeat collection inert");
                }
                GameData.mysteryInventory=stable;GameData.coins=coins;GameData.cash=cash;GameData.energy=energy;
                var claims:Object=JSON.parse(JSON.stringify(GameData.roadmapClaims)),league:int=GameData.leagueIndex;GameData.leagueIndex=1;delete GameData.roadmapClaims["0"];
                before=int(GameData.mysteryInventory.boxes.rookie);check(GameData.roadmapClaimStage(0).status=="OK","roadmap stores box");check(GameData.mysteryInventory.boxes.rookie==before+1&&GameData.coins==coins,"no immediate roadmap payout");check(GameData.roadmapClaimStage(0).status=="CLAIMED","roadmap once");
                GameData.roadmapClaims=claims;GameData.leagueIndex=league;GameData.save();return JSON.stringify({status:"PASS"});
            }
            if(action=="regular")GameData.completeSeasonGame(5,2,3,1,4,4);
            if(action=="special"){GameData.seasonGame=28;GameData.completeSeasonGame(5,2,3,1,4,4);}
            if(action=="rival"){GameData.seasonGame=30;GameData.completeSeasonGame(5,2,3,1,4,4);}
            var owned:int=0;for(var id:String in GameData.specialOwned)owned++;
            return JSON.stringify({inventory:GameData.mysteryInventory,coins:GameData.coins,cash:GameData.cash,energy:GameData.energy,level:GameData.level,league:GameData.leagueIndex,owned:owned,hall:GameData.hallOfFame,claims:GameData.roadmapClaims,summary:GameData.lastGameSummary});
        }
    }
}
