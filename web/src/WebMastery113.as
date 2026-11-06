package {
    import flash.external.ExternalInterface;
    import com.bh.model.*;
    public class WebMastery113 extends WebTraining112 {
        private var checks:int;
        public function WebMastery113() {super();ExternalInterface.addCallback("bh113",run);}
        private function check(ok:Boolean,label:String):void {checks++;if(!ok)throw new Error(label);}
        private function profile(stars:int,progress:int):Object {
            return {mastery:stars*1350,availableAt:"0",activity:"",lastReward:null,
                progression:{version:1,stars:stars,progress:progress,cycles:0,sourceMastery:stars*1350}};
        }
        private function state():Object {return {coins:GameData.coins,xp:GameData.xp,energy:GameData.energy,points:GameData.mainPlayer().skillPoints,
            running:GameData.trainingState("running"),stretching:GameData.trainingState("stretching"),lifting:GameData.trainingState("lifting")};}
        private function run(action:String="state",value:String=""):String {
            try {
                if(action=="model")return JSON.stringify(model());
                if(action=="set") {
                    var v:Object=JSON.parse(value);GameData.trainingState(v.id);
                    if(v.id=="running")GameData.runningTraining=profile(v.stars,v.progress);
                    else GameData.runningTraining.disciplines[v.id]=profile(v.stars,v.progress);
                    if(v.hasOwnProperty("energy")){GameData.energy=int(v.energy);GameData.energyAt="0";}
                    // Isolate Mastery rewards from the independent level-up refill.
                    GameData.levelProgress=0;
                    GameData.save();
                }
                if(action=="ack") {v=JSON.parse(value);return JSON.stringify({ok:GameData.acknowledgeTrainingReward(v.id,v.receipt)});}
                return JSON.stringify(state());
            }catch(e:Error){return JSON.stringify({error:e.message,checks:checks});}
            return "{}";
        }
        private function model():Object {
            checks=0;var p:Object,r:Object,old:int,pts:int,receipt:String,id:String;
            p=profile(4,1245);r=TrainingMastery.advance(p,600);
            check(r.stars==5&&r.step==6&&r.progress==495&&r.target==1800&&r.skillPoints==2,"observed STEP5 crossing");
            p=profile(9,3090);r=TrainingMastery.advance(p,600);
            check(r.stars==10&&r.progress==90&&r.target==4050&&r.skillPoints==2,"observed STEP10 threshold");
            p=profile(12,615);r=TrainingMastery.advance(p,600);
            check(r.master&&r.progress==90&&r.energy==5&&r.skillPoints==0,"observed MASTER stretching");
            p=profile(12,870);r=TrainingMastery.advance(p,600);
            check(r.master&&r.progress==345&&r.energy==5&&r.skillPoints==0,"observed MASTER running");
            p=profile(12,0);r=TrainingMastery.advance(p,3375);
            check(r.energy==15&&r.progress==0&&r.cycles==3&&r.stars==12,"repeatable cycles and bounded stars");
            p=profile(11,4490);r=TrainingMastery.advance(p,60);
            check(r.master&&r.progress==50&&r.skillPoints==2&&r.energy==0,"enter MASTER retains remainder, no speculative energy");
            p={mastery:9*1350+675};r=TrainingMastery.info(p);
            check(r.stars==9&&r.progress==1800&&r.target==3600,"legacy fractional progress and stars");
            p.mastery=1340;r=TrainingMastery.info(p);check(r.stars==0&&r.progress==1340,"legacy client replaces stale anchor");
            p={mastery:500,progression:{version:1,stars:99,progress:999999,cycles:-2,sourceMastery:500}};r=TrainingMastery.info(p);
            check(r.stars==12&&r.progress==1124&&r.cycles==0,"malformed fields bounded without award");
            for each(id in ["running","stretching","lifting"]) {
                GameData.startNewCareer();GameData.coins=10000;GameData.energy=17;GameData.energyAt="0";
                GameData.trainingState(id);if(id=="running")GameData.runningTraining=profile(12,615);else GameData.runningTraining.disciplines[id]=profile(12,615);
                pts=int(GameData.mainPlayer().skillPoints);r=GameData.startDisciplineTraining(id,TrainingCatalog.activities(id)[5].id);
                check(r.ok&&r.energy==5&&GameData.energy==22,"energy beyond cap "+id);
                check(GameData.trainingInfo(id).progress==90&&GameData.trainingStep(id)==13,"MASTER progress "+id);
                check(GameData.mainPlayer().skillPoints==pts&&GameData.trainingRemaining(id)>47*3600000,"energy keeps independent break "+id);
                check(Number(GameData.energyAt)>new Date().time&&GameData.trainingPendingReward(id)!=null,"receipt and recovery pending below cap "+id);
                receipt=r.receipt;old=GameData.coins;check(!GameData.startDisciplineTraining(id,TrainingCatalog.activities(id)[5].id).ok,"break blocks duplicate "+id);
                GameData.save();GameData.load();check(GameData.energy==22&&GameData.coins==old&&GameData.trainingPendingReward(id).receipt==receipt,"receipt survives reload "+id);
                check(!GameData.acknowledgeTrainingReward(id,"stale"),"wrong receipt ignored "+id);
                check(GameData.acknowledgeTrainingReward(id,receipt)&&!GameData.acknowledgeTrainingReward(id,receipt),"ack idempotent "+id);
                check(GameData.energy==22&&GameData.coins==old&&GameData.trainingPendingReward(id)==null,"ack grants nothing "+id);
                p=GameData.trainingState(id);p.availableAt="0";p.progression.progress=870;GameData.levelProgress=0;
                r=GameData.startDisciplineTraining(id,TrainingCatalog.activities(id)[5].id);
                check(r.ok&&r.energy==5&&GameData.energy==27&&GameData.energyAt=="0"&&GameData.trainingInfo(id).progress==345,"train again while MASTER "+id);
            }
            GameData.startNewCareer();GameData.coins=10000;GameData.runningTraining={mastery:20000,availableAt:"0",activity:"mile",lastReward:{legacy:true}};
            pts=GameData.mainPlayer().skillPoints;old=GameData.energy;
            for(var i:int=0;i<5;i++){GameData.trainingInfo("running");GameData.save();GameData.load();}
            check(GameData.energy==old&&GameData.mainPlayer().skillPoints==pts&&GameData.trainingPendingReward("running")==null,"migration never pays retroactively");
            check(GameData.runningTraining.mastery==20000&&GameData.runningTraining.activity=="mile"&&GameData.runningTraining.lastReward.legacy,"legacy data retained");
            GameData.startNewCareer();GameData.coins=10000;GameData.runningTraining=profile(4,1245);pts=GameData.mainPlayer().skillPoints;
            r=GameData.startRunningTraining("longrun");receipt=r.receipt;
            check(r.skillPoints==2&&GameData.mainPlayer().skillPoints==pts+2&&r.energy==0,"star award paid once");
            GameData.save();GameData.load();check(GameData.mainPlayer().skillPoints==pts+2&&GameData.trainingPendingReward("running").receipt==receipt,"star receipt survives reload");
            GameData.acknowledgeTrainingReward("running",receipt);GameData.save();GameData.load();
            check(GameData.mainPlayer().skillPoints==pts+2&&GameData.trainingPendingReward("running")==null,"ack persists without duplicate points");
            GameData.startNewCareer();GameData.save();return {status:"PASS",checks:checks};
        }
    }
}
