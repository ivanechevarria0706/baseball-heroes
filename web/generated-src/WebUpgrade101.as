package {
    import flash.display.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.core.Game;
    /** Diagnostics only. This SWF is excluded from production staging. */
    public class WebUpgrade101 extends WebUpgrade097 {
        public function WebUpgrade101(){super();ExternalInterface.addCallback("bh101",safe);}
        private function check(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
        private function findGame(c:DisplayObjectContainer):Game {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d as Game;if(d is DisplayObjectContainer){var g:Game=findGame(d as DisplayObjectContainer);if(g)return g;}}return null;}
        private function safe(action:String="state",kind:String="",value:String=""):String {try{return run101(action,kind,value);}catch(e:Error){return JSON.stringify({error:e.message});}return "";}
        private function run101(action:String,kind:String,value:String):String {
            if(action=="model"){
                var costs:Array=[2,3,4,5,7],branches:Array=[0,.5,.61,.67,.75,.9,.98],cases:int=0;
                for(var i:int=0;i<5;i++){
                    var k:String=String(MysteryCatalog.KINDS[i]);check(MysteryInventory.keyCost(k)==costs[i],"documented key cost "+k);
                    for each(var roll:Number in branches){
                        var s:Object=MysteryInventory.create();s.boxes[k]=1;s.keys=costs[i]-1;
                        check(MysteryInventory.open(s,k,roll,0).status=="KEYS"&&s.boxes[k]==1,"insufficient keys inert");s.keys++;
                        var r:Object=MysteryInventory.open(s,k,roll,0);check(r.status=="OK"&&s.keys==0&&s.boxes[k]==0,"one box and exact keys consumed");
                        var n:Object=MysteryInventory.normalize(s);check(n.pending&&n.pending.type==r.reward.type&&n.pending.amount==r.reward.amount&&n.pending.source==k,"pending prize survives normalize");
                        if(r.reward.type=="GEAR")check(n.pending.itemId==r.reward.itemId&&n.pending.duplicateCoins==r.reward.duplicateCoins,"gear identity persists");
                        if(r.reward.type=="CARD")check(n.pending.cardId==r.reward.cardId,"card identity persists");
                        check(MysteryInventory.open(n,k,roll,0).status=="PENDING","second open blocked");cases++;
                    }
                    s=MysteryInventory.create();r=MysteryInventory.recordGame(s,"league-"+i,true,12,i);
                    check(r.kind==k&&s.boxes[k]==1,"SPECIAL awards current league box");
                    check(MysteryInventory.recordGame(s,"league-"+i,true,12,i).boxes==0,"fixture idempotent");
                }
                var legacy:Object={version:1,boxes:{rookie:3,single_a:2},keys:7,packs:{C:4},serial:8,matches:["old"],pending:{id:"mystery-8",source:"single_a",type:"COINS",amount:2000}};
                n=MysteryInventory.normalize(legacy);check(n.version==2&&n.boxes.rookie==3&&n.boxes.single_a==2&&n.boxes.majors==0&&n.keys==7&&n.packs.C==4&&n.pending.amount==2000&&n.matches[0]=="old","v1 inventory and already rolled prize preserved");
                legacy.pending={id:"mystery-8",source:"pack",type:"CARD",amount:1,cardId:"card_rookie_ace"};n=MysteryInventory.normalize(legacy);check(n.pending&&n.pending.source=="pack","legacy card prize preserved");
                s=MysteryInventory.create();s.boxes.majors=50;s.keys=40;check(!MysteryInventory.addBox(s,"majors")&&MysteryInventory.addKeys(s,1)==0,"capacities enforced");check(MysteryInventory.open(s,"unknown").status=="INVALID","unknown box rejected");
                var m:MatchMomentum=new MatchMomentum(),low:int=m.gain("SINGLE",0),high:MatchMomentum=new MatchMomentum();check(high.gain("SINGLE",99)>low,"Luck increases charge");check(m.gain("WALK",99)==0&&m.gain("OUT",99)==0,"only hits charge");
                m.charge=7;m.beginPlate(2,0,0,false);check(m.charge==7&&!m.maxReady,"partial gauge retained");m.charge=10;m.beginPlate(5,0,4,true);check(m.maxReady&&m.charge==10&&m.spent==0&&m.comeback,"MAX armed without consuming");
                check(m.gain("STRIKE",99)==0&&m.gain("FOUL",99)==0&&m.charge==10,"misses and fouls retain MAX");check(m.resultOnContact("OUT")=="HOME RUN"&&m.charge==10,"fair contact converted before settlement");check(m.consumeMax()&&m.charge==0&&m.spent==10&&!m.consumeMax(),"MAX consumed once");
                return JSON.stringify({status:"PASS",prizeCases:cases,legacyPreserved:true,combo:m.snapshot(),costs:costs});
            }
            if(action=="seed"){
                GameData.starterTutorial={version:1,enabled:false,stage:9,skipped:true,claimed:false,hints:{}};
                GameData.mysteryInventory=MysteryInventory.create();for each(var boxKind:String in MysteryCatalog.KINDS)GameData.mysteryInventory.boxes[boxKind]=3;
                for each(var cls:String in MysteryCatalog.CLASSES)GameData.mysteryInventory.packs[cls]=2;
                GameData.mysteryInventory.keys=40;GameData.leagueIndex=0;GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.save();
            }
            if(action=="open"){var opened:Object=MysteryInventory.open(GameData.mysteryInventory,kind,Number(value),.1);GameData.save();return JSON.stringify(opened);}
            if(action=="claim")return JSON.stringify(GameData.mysteryCollect(kind));
            if(action=="keys"){GameData.mysteryInventory.keys=int(kind);GameData.save();}
            if(action=="equip"){
                item=MysteryCatalog.gearById(kind);check(item!=null,"known gear");
                for each(var ownedItem:Object in GameData.inventory)if(ownedItem.name==item.name){check(GameData.equipItem(ownedItem),"prize can be equipped");break;}GameData.save();
            }
            if(action=="own-prize"){
                var item:Object=MysteryCatalog.gearById(String(GameData.mysteryInventory.pending.itemId));check(item!=null,"gear prize required");
                if(!GameData.ownsShopItem(item))GameData.inventory.push({name:item.name,slot:item.slot,grade:item.grade,accent:item.accent,power:item.power,contact:item.contact,speed:item.speed,luck:item.luck});GameData.save();
            }
            if(action=="legacy"){
                GameData.mysteryInventory=MysteryInventory.normalize({version:1,boxes:{rookie:3,single_a:2},keys:7,packs:{C:4},serial:8,matches:["old"],pending:{id:"mystery-8",source:"single_a",type:"COINS",amount:2000}});GameData.save();
            }
            if(action=="roadmap"){
                GameData.leagueIndex=4;GameData.roadmapClaims={};GameData.mysteryInventory=MysteryInventory.create();
                for(i=0;i<4;i++){r=GameData.roadmapClaimStage(i);check(r.status=="OK"&&GameData.mysteryInventory.boxes[MysteryCatalog.forLeague(i)]==1,"roadmap correct league box");check(GameData.roadmapClaimStage(i).status=="CLAIMED","roadmap paid once");}
                GameData.save();
            }
            if(action=="engine"){var game:Game=findGame(this);check(game!=null,"match required");return game["qaCombo101"](kind);}
            var owned:int=0;for(var id:String in GameData.specialOwned)owned++;
            return JSON.stringify({level:GameData.level,league:GameData.leagueIndex,coins:GameData.coins,cash:GameData.cash,energy:GameData.energy,maxEnergy:GameData.maxEnergy,inventory:GameData.mysteryInventory,gear:GameData.inventory,equipped:GameData.equipped,ownedCards:owned,claims:GameData.roadmapClaims});
        }
    }
}
