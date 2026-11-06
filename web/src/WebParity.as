package {
    import flash.display.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.core.Game;import com.bh.audio.GameplayAudio;import com.bh.game.HitCinematic;import com.bh.ui.MatchVictory;
    public class WebParity extends WebSmoke {
        private var preview:HitCinematic;
        private var victory:MatchVictory;
        public function WebParity(){super();ExternalInterface.addCallback("bhParity",call);}
        private function game(c:DisplayObjectContainer):Object {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d;if(d is DisplayObjectContainer){var found:Object=game(d as DisplayObjectContainer);if(found)return found;}}return null;}
        private function check(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
        private function call(action:String="state",value:String=""):String {try{return run(action,value);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}
        private function run(action:String,value:String):String {
            if(action=="model"){
                var ledger:MatchScoring=new MatchScoring();var event:Object;
                event=ledger.record("SINGLE",0,true);check(event.points==1000,"single points");ledger.record("DOUBLE",2,true);event=ledger.record("HOME RUN",4,true);check(event.multiplier==2&&event.points==36000,"streak multiplier");ledger.record("STRIKE OUT",0,false);check(ledger.hitStreak==3,"sim out preserves hero streak");ledger.record("WALK",0,true);check(ledger.hitStreak==0,"walk ends hit streak");
                var rows:Array=[{name:"Hero",hits:3,homeRuns:1,rbi:6}],score:Object=MatchScoring.settle(ledger.snapshot(),true,false,rows,"Hero",3,1,6,9),total:int=0;
                for each(var part:Object in score.breakdown)total+=part.coins;check(total==3160&&score.mvp&&score.breakdown.length==5,"rewards reconcile");
                var p:Object={condition:{energy:1,at:"0"}};check(PlayerCondition.consume(p,1000)&&PlayerCondition.energy(p,1001)==0,"last unit reserved");check(!PlayerCondition.consume(p,1001),"zero energy blocked");check(PlayerCondition.energy(p,1801000)==1,"one recharge");check(PlayerCondition.energy(p,20000000)==6,"full recovery cap");
                var hero:Object=GameData.mainPlayer(),old:Object=GameData.equipped.bat;GameData.equipped.bat={slot:"bat",name:"QA400",power:400,contact:0,speed:0,luck:0};check(GameData.effectivePower(hero)>400&&GameData.matchPower(hero)<=99,"raw and game stat scales");GameData.equipped.bat=old;
                check(EquipmentCatalog.items().length==87,"expanded catalog");
                var oldLevel:int=GameData.level;
                for each(var item:Object in EquipmentCatalog.items()){
                    check([5,15,25,30,50,70].indexOf(item.unlockLevel)>=0,"level gates");
                    GameData.level=item.unlockLevel-1;check(!GameData.shopItemUnlocked(item),"blocked below required level");
                    GameData.level=item.unlockLevel;check(GameData.shopItemUnlocked(item),"unlocked at required level");
                }
                GameData.level=oldLevel;
                check(GameplayAudio.duration(GameplayAudio.PITCH)==0&&GameplayAudio.duration(GameplayAudio.RESULT_SINGLE)==0&&GameplayAudio.duration(GameplayAudio.RESULT_DOUBLE)==0&&GameplayAudio.duration(GameplayAudio.HERO_HIT)>0,"embedded sound decode");
                var box:MatchBoxScore=new MatchBoxScore([GameData.mainPlayer()]);
                box.record(0,GameData.mainPlayer(),"SINGLE",0,"FASTBALL");box.record(0,GameData.mainPlayer(),"DOUBLE",1,"SINKER");box.record(0,GameData.mainPlayer(),"TRIPLE",2,"CURVEBALL");box.record(0,GameData.mainPlayer(),"HOME RUN",4,"SLIDER");box.record(0,GameData.mainPlayer(),"WALK",0,"CHANGEUP");
                var career:Object=CareerAchievements.create();check(CareerAchievements.catalog().length==16,"16 observed achievements");
                check(CareerAchievements.match(career,"fixture093","",7,6,box.snapshot(),true),"fixture commits");check(!CareerAchievements.match(career,"fixture093","",7,6,box.snapshot(),true),"fixture replay rejected");
                check(career.stats.singles==1&&career.stats.doubles==1&&career.stats.walks==1&&career.stats.extraWins==1,"expanded career stats");check(career.stats.pitchBreaking==2&&career.stats.pitchFourSeam==1&&career.stats.pitchTwoSeam==1,"pitch families count only hits");
                var normalized:Object=CareerAchievements.normalize({stats:{hits:400},claims:{"hits:0":true}});check(normalized.stats.hits==400&&normalized.claims["hits:0"]&&normalized.stats.giftsSent==0,"legacy medals preserved");
                check(StadiumCatalog.items().length==26,"stadium expansion");
                var claims:Object=JSON.parse(JSON.stringify(GameData.missionClaims||{})),missionCoins:int=GameData.coins,pitchStats:Array=[GameData.hallOfFame.stats.pitchBreaking,GameData.hallOfFame.stats.pitchFourSeam,GameData.hallOfFame.stats.pitchTwoSeam];
                GameData.hallOfFame.stats.pitchBreaking=GameData.hallOfFame.stats.pitchFourSeam=GameData.hallOfFame.stats.pitchTwoSeam=3;
                check(GameData.missionComplete("pitch_master")&&GameData.claimMission("pitch_master")=="OK"&&GameData.coins==missionCoins+800,"pitch mission grants 800 once");
                check(GameData.claimMission("pitch_master")=="CLAIMED"&&GameData.coins==missionCoins+800,"mission replay blocked");
                GameData.missionClaims=claims;GameData.coins=missionCoins;GameData.hallOfFame.stats.pitchBreaking=pitchStats[0];GameData.hallOfFame.stats.pitchFourSeam=pitchStats[1];GameData.hallOfFame.stats.pitchTwoSeam=pitchStats[2];

                var savedSocial:Object=GameData.socialState,savedKeys:int=GameData.mysteryInventory.keys,savedEnergy:int=GameData.energy,savedHall:Object=JSON.parse(JSON.stringify(GameData.hallOfFame));
                GameData.socialState={links:[],pendingKeys:0,totals:{energy:0,key:0}};GameData.mysteryInventory.keys=39;
                var social:Object={userId:"qa",links:[],members:[],totals:{energy:2,key:3},giftsSent:0,giftsReceived:5};
                GameData.applySocialSnapshot(social);check(GameData.mysteryInventory.keys==40&&GameData.socialState.pendingKeys==2&&GameData.energy==savedEnergy+2,"overflow gift credit retained");
                GameData.applySocialSnapshot(social);check(GameData.socialState.pendingKeys==2&&GameData.energy==savedEnergy+2,"social grants idempotent");
                GameData.mysteryInventory.keys=37;GameData.save();check(GameData.mysteryInventory.keys==39&&GameData.socialState.pendingKeys==0,"credit refills after spending");
                GameData.socialState=savedSocial;GameData.mysteryInventory.keys=savedKeys;GameData.energy=savedEnergy;GameData.hallOfFame=savedHall;GameData.save();

                return JSON.stringify({status:"PASS",score:score,career:career});
            }
            if(action=="seed"){
                GameData.starterTutorial={version:1,enabled:false,stage:9,skipped:true,claimed:false,hints:{}};
                GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.seasonComplete=false;GameData.seasonGame=1;GameData.postSeasonMode=false;GameData.postSeason=null;GameData.specialMatch=null;
                GameData.energy=25;GameData.coins=300000;GameData.level=70;GameData.save();
            }
            if(action=="stadium-fixture"){GameData.gateIncomeLastAt=0;GameData.save();}
            if(action=="low-level"){GameData.level=1;GameData.save();}
            if(action=="exhaust"){
                GameData.specialMatch=null;var order:Array=GameData.battingOrderPlayers();for(var i:int=0;i<order.length;i++)if(order[i]!==GameData.mainPlayer()){order[i].condition={energy:i==8?0:6,at:String(new Date().time+1800000)};}GameData.save();
            }
            if(action=="restore"){
                for each(p in GameData.roster)p.condition={energy:6,at:"0"};GameData.specialMatch=null;GameData.energy=25;GameData.level=70;GameData.save();
            }
            if(action=="scenario"){var g:Object=game(this);check(g!=null,"game actor required");return g["qaParity"](value);}
            if(action=="repeat-completion"){
                var last:Object=GameData.lastGameSummary;
                GameData.completeSeasonGame(last.homeScore,last.awayScore,last.hits,last.homeRuns,last.atBats,last.rbi,last.homeLine,last.awayLine,last.boxScore,{fixtureKey:last.fixtureKey});
            }
            if(action=="engine"){g=game(this);return g?g["qaParity"]("state"):"{}";}
            if(action=="preview"){
                if(preview){preview.dispose();removeChild(preview);preview=null;}
                if(value!="close"){preview=new HitCinematic(960,720);addChild(preview);var isHit:Boolean=value=="HOME RUN"||value=="SINGLE"||value=="DOUBLE"||value=="TRIPLE";preview.setPoints(value=="HOME RUN"?18000:value=="DOUBLE"?2500:value=="TRIPLE"?5000:value=="SINGLE"?1000:0,1,isHit?1:0,0);preview.play(value,value=="HOME RUN"?4:0,value=="HOME RUN"?567:0);}
            }
            if(action=="preview-skip"&&preview)preview.forceResultVisible();
            if(action=="victory"){
                if(victory){victory.dispose();removeChild(victory);victory=null;}
                if(value!="close"){victory=new MatchVictory(960,720,value,function():void{if(victory){victory.dispose();removeChild(victory);victory=null;}});addChild(victory);}
            }
            return JSON.stringify({level:GameData.level,league:GameData.leagueIndex,coins:GameData.coins,xp:GameData.xp,energy:GameData.energy,paid:GameData.specialMatch,hero:GameData.mainPlayer(),roster:GameData.roster,order:GameData.battingOrder,inventory:GameData.inventory,equipped:GameData.equipped,social:GameData.socialState,hall:GameData.hallOfFame,stadium:GameData.stadiumActive,decorations:GameData.stadiumDecorations,keys:GameData.mysteryInventory.keys,summary:GameData.lastGameSummary,post:GameData.postSeason,unstartable:GameData.unstartablePlayers().length});
        }
    }
}
