package {
    import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;
    import com.bh.ui.*;import com.bh.model.*;
    /** Synthetic mission states only; never shipped. */
    public class WebMissions1007 extends WebSmoke {
        private var view:MissionsScreen,overlay:MissionCompleteOverlay,counts:Object={home:0,shop:0,close:0};
        public function WebMissions1007(){super();ExternalInterface.addCallback("bhMissions1007",run);}
        private function clear():void {if(view){view.dispose();if(view.parent)view.parent.removeChild(view);view=null;}if(overlay){overlay.dispose();if(overlay.parent)overlay.parent.removeChild(overlay);overlay=null;}}
        private function run(action:String="state",value:String=""):String {
            try {
                if(action=="prepare"){
                    clear();GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.missionClaims={};GameData.starterTutorial=StarterTutorial.create(true);GameData.starterTutorial.stage=StarterTutorial.CLAIM;
                    var p:Object=GameData.mainPlayer();p.level=9;p.power=int(p.basePower)+1;
                    GameData.hallOfFame.stats.pitchBreaking=3;GameData.hallOfFame.stats.pitchFourSeam=3;GameData.hallOfFame.stats.pitchTwoSeam=3;GameData.hallOfFame.stats.closeWins=2;GameData.hallOfFame.stats.multiHitGames=3;
                    GameData.gateIncomeCollected=1;while(GameData.stadiumOwned.length<9)GameData.stadiumOwned.push("qa-decoration");while(GameData.roster.length<13)GameData.roster.push({id:"qa-player",name:"QA Draft"});GameData.seasonWins=3;GameData.seasonLosses=0;counts={home:0,shop:0,close:0};
                    if(value=="incomplete"){GameData.starterTutorial.stage=StarterTutorial.SHOP;p.level=1;p.power=p.basePower;GameData.hallOfFame.stats.pitchBreaking=1;GameData.hallOfFame.stats.pitchFourSeam=0;GameData.hallOfFame.stats.pitchTwoSeam=0;GameData.hallOfFame.stats.closeWins=0;GameData.hallOfFame.stats.multiHitGames=0;GameData.gateIncomeCollected=0;GameData.stadiumOwned=GameData.stadiumOwned.slice(0,8);GameData.roster=GameData.roster.slice(0,12);GameData.seasonWins=0;}
                }
                if(action=="show"){clear();view=new MissionsScreen(960,720,function():void{counts.home++;},function():void{counts.shop++;});addChild(view);}
                if(action=="overlay"){clear();overlay=new MissionCompleteOverlay(value,function():void{counts.close++;});overlay.x=480;overlay.y=360;overlay.scaleX=overlay.scaleY=1.5;addChild(overlay);}
                if(action=="invalidate"){GameData.hallOfFame.stats.pitchBreaking=0;GameData.hallOfFame.stats.closeWins=0;}
                if(action=="close")clear();
                return JSON.stringify({catalog:GameData.missionCatalog(),coins:GameData.coins,energy:GameData.energy,claims:GameData.missionClaims,skillPoints:GameData.mainPlayer().skillPoints,tutorial:GameData.starterTutorial,counts:counts,season:GameData.seasonNumber,game:GameData.seasonGame,head:GameData.mainPlayer().appearance});
            }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";
        }
    }
}
