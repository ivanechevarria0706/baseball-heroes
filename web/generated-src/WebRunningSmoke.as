package {
    import flash.external.ExternalInterface;
    import com.bh.model.GameData;
    public class WebRunningSmoke extends WebSmoke {
        public function WebRunningSmoke(){super();ExternalInterface.addCallback("bhRunning",run);}
        private function run(action:String="inspect",value:String=""):String {
            var result:Object=null;
            if(action=="reset")GameData.startNewCareer();
            if(action=="expire"){GameData.runningTraining.availableAt=String(new Date().time-1);GameData.save();}
            if(action=="mastery"){GameData.runningTraining.mastery=Number(value);GameData.save();}
            if(action=="coins"){GameData.coins=int(value);GameData.save();}
            if(action=="start")result=GameData.startRunningTraining(value);
            if(action=="load")GameData.load();
            return JSON.stringify({result:result,running:GameData.runningTraining,remaining:GameData.runningRemaining(),
                step:GameData.runningStep(),coins:GameData.coins,xp:GameData.xp,level:GameData.level,
                league:GameData.leagueIndex,hero:GameData.mainPlayer(),activities:GameData.runningActivities()});
        }
    }
}
