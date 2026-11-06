package {
    import flash.external.ExternalInterface;
    import com.bh.model.*;
    import com.bh.ui.RunningTrainingRoom;
    public class WebTraining111 extends WebSmoke {
        private var room:RunningTrainingRoom;
        private var checks:int=0;
        public function WebTraining111(){super();ExternalInterface.addCallback("bh111",run);}
        private function check(ok:Boolean,label:String):void {checks++;if(!ok)throw new Error(label);}
        private function closeRoom():void {if(room){room.dispose();removeChild(room);room=null;}}
        private function snapshot():Object {return {coins:GameData.coins,xp:GameData.xp,level:GameData.level,energy:GameData.energy,
            running:GameData.runningTraining,stretching:GameData.trainingState("stretching"),lifting:GameData.trainingState("lifting"),points:GameData.mainPlayer().skillPoints};}
        private function run(action:String="state",value:String=""):String {
            try {
                if(action=="model")return JSON.stringify(model());
                if(action=="seed") {
                    closeRoom();GameData.startNewCareer();GameData.coins=100000;GameData.xp=0;
                    GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.save();
                }
                if(action=="room"){closeRoom();room=new RunningTrainingRoom(960,720,GameData.mainPlayer(),closeRoom);addChild(room);}
                if(action=="close")closeRoom();
                if(action=="expire"){GameData.trainingState(value).availableAt=String(new Date().time-1);GameData.save();}
                if(action=="load")GameData.load();
                return JSON.stringify(snapshot());
            }catch(error:Error){return JSON.stringify({error:error.message,checks:checks});}
            return "{}";
        }
        private function model():Object {
            closeRoom();checks=0;
            var def:Object,a:Object,r:Object,st:Object,before:int,pts:int,at:Number,id:String;
            var hours:Array=[1,4,8,12,24,48],m:Array=[60,150,225,300,480,600],x:Array=[16,40,60,80,128,160];
            for each(def in TrainingCatalog.disciplines()) {
                var list:Array=TrainingCatalog.activities(def.id);check(list.length==6,"six sessions "+def.id);
                for(var i:int=0;i<list.length;i++) {
                    a=list[i];GameData.startNewCareer();GameData.coins=100000;GameData.xp=0;pts=int(GameData.mainPlayer().skillPoints);
                    var other:int=def.id=="running"?120:[120,350,600,800,1500,1800][i];
                    check(a.hours==hours[i]&&a.mastery==m[i]&&a.xp==x[i],"observed session rewards");
                    check(a.cost==(def.id=="running"?[90,250,400,550,1000,1250][i]:[120,350,600,800,1500,1800][i]),"observed cost");
                    at=new Date().time;r=GameData.startDisciplineTraining(def.id,a.id);st=GameData.trainingState(def.id);
                    check(r.ok&&GameData.coins==100000-int(a.cost),"one exact charge");
                    check(GameData.xp==int(a.xp)&&st.mastery==a.mastery,"one immediate reward");
                    check(Math.abs(Number(st.availableAt)-at-Number(a.hours)*3600000)<1000&&st.availableAt is String,"UTC duration as text");
                    before=GameData.coins;r=GameData.startDisciplineTraining(def.id,a.id);
                    check(!r.ok&&GameData.coins==before&&GameData.xp==a.xp&&st.mastery==a.mastery,"duplicate during break does not pay");
                    GameData.save();GameData.load();st=GameData.trainingState(def.id);
                    check(st.mastery==a.mastery&&st.activity==a.id&&GameData.coins==before,"reload retains paid session");
                }
            }
            GameData.startNewCareer();GameData.coins=10000;GameData.xp=0;
            for each(def in TrainingCatalog.disciplines())check(GameData.startDisciplineTraining(def.id,TrainingCatalog.activities(def.id)[0].id).ok,"simultaneous coaches");
            check(GameData.coins==9670&&GameData.xp==48,"three independent payments");
            check(GameData.runningRemaining()>0&&GameData.trainingRemaining("stretching")>0&&GameData.trainingRemaining("lifting")>0,"three saved breaks");
            var stretchAt:String=GameData.trainingState("stretching").availableAt,liftAt:String=GameData.trainingState("lifting").availableAt;
            GameData.runningTraining.availableAt=String(new Date().time-1);before=GameData.coins;
            check(GameData.startRunningTraining("yards30").ok&&GameData.coins==before-90,"legacy running API");
            check(GameData.trainingState("stretching").availableAt==stretchAt&&GameData.trainingState("lifting").availableAt==liftAt,"expire one does not expire others");
            GameData.save();GameData.load();check(GameData.trainingState("stretching").availableAt==stretchAt&&GameData.trainingState("lifting").availableAt==liftAt,"save preserves all clocks");
            GameData.startNewCareer();GameData.coins=0;before=GameData.xp;
            check(!GameData.startDisciplineTraining("lifting","pushUp").ok&&GameData.coins==0&&GameData.xp==before&&GameData.trainingRemaining("lifting")==0,"insufficient funds no reward or break");
            check(!GameData.startDisciplineTraining("missing","pushUp").ok&&!GameData.startDisciplineTraining("stretching","missing").ok,"invalid discipline and session");
            GameData.startNewCareer();GameData.coins=10000;
            GameData.runningTraining={mastery:4025,availableAt:String(new Date().time+3600000),activity:"mile",lastReward:{ok:true,legacy:"retain"}};
            GameData.save();GameData.load();GameData.trainingState("stretching");
            check(GameData.runningTraining.mastery==4025&&GameData.runningTraining.activity=="mile"&&GameData.runningTraining.lastReward.legacy=="retain"&&GameData.runningRemaining()>0,"legacy running progress and reward preserved");
            check(GameData.trainingState("stretching").mastery==0&&GameData.trainingState("lifting").mastery==0,"new disciplines begin at zero");
            for each(def in TrainingCatalog.disciplines()) {
                GameData.coins=10000;GameData.xp=0;st=GameData.trainingState(def.id);st.mastery=1340;st.availableAt="0";pts=int(GameData.mainPlayer().skillPoints);
                r=GameData.startDisciplineTraining(def.id,TrainingCatalog.activities(def.id)[0].id);
                check(r.ok&&r.skillPoints==2&&GameData.mainPlayer().skillPoints==pts+2,"existing step award "+def.id);
                GameData.save();GameData.load();check(GameData.mainPlayer().skillPoints==pts+2&&GameData.trainingState(def.id).mastery==1400,"step award once on reload");
            }
            st=TrainingCatalog.normalize({mastery:-500,availableAt:"bad",activity:3});check(st.mastery==0&&st.availableAt=="0"&&st.activity=="","malformed state");
            GameData.runningTraining.disciplines=[];check(GameData.trainingState("lifting").mastery==0,"malformed nested state");
            GameData.startNewCareer();GameData.save();
            return {status:"PASS",checks:checks,activities:18,legacyRunningPreserved:true,independentClocks:true};
        }
    }
}
