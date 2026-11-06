package {
    import flash.display.*;import flash.external.ExternalInterface;
    import com.bh.ui.*;import com.bh.model.*;
    /** Visual regression fixture. Never included in the deployment package. */
    public class WebVisual1008 extends WebSmoke {
        private var view:Sprite,counts:Object={back:0,done:0,shop:0,play:0},kind:String="";
        public function WebVisual1008(){super();ExternalInterface.addCallback("bhVisual1008",run);}
        private function close():void {if(view){Object(view).dispose();if(view.parent)removeChild(view);view=null;}}
        private function back():void {counts.back++;}
        private function done():void {counts.done++;}
        private function shop():void {counts.shop++;}
        private function play():void {counts.play++;}
        private function noop(...rest):void {}
        private function run(action:String="state",value:String=""):String {
            try {
                if(action=="prepare"){GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.starterTutorial=StarterTutorial.create();GameData.coins=123456789;GameData.cash=123456;GameData.energyAt=String(new Date().time+300000);var oldName:String=String(GameData.mainPlayer().name);GameData.mainPlayer().name="Alejandro Maximiliano";for(var i:int=0;i<GameData.battingOrder.length;i++)if(GameData.battingOrder[i]==oldName)GameData.battingOrder[i]="Alejandro Maximiliano";for each(var player:Object in GameData.roster)PlayerCondition.energy(player);counts={back:0,done:0,shop:0,play:0};GameData.save();}
                if(action=="show"){
                    close();kind=value;
                    if(value=="creator")view=new CharacterMakerScreen(960,720,done,back);
                    if(value=="shop"||value=="inventory")view=new EquipmentScreen(960,720,back,shop,value=="shop",back,noop,noop);
                    if(value=="lineup")view=new LineupScreen(960,720,back,play,shop,noop);
                    if(value=="modes")view=new ModeSelectScreen(960,720,back,play,play,noop,noop,noop);
                    if(value=="missions")view=new MissionsScreen(960,720,back,shop);
                    if(value=="home")view=new LobbyScreen(960,720,play,noop,noop,shop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop);
                    if(view)addChild(view);
                }
                if(action=="close")close();
                return JSON.stringify({screen:kind,counts:counts,coins:GameData.coins,cash:GameData.cash,energy:GameData.energy,level:GameData.level,xp:GameData.xp,league:GameData.leagueIndex,season:GameData.seasonNumber,game:GameData.seasonGame,roster:GameData.roster,equipped:GameData.equipped,order:GameData.battingOrder,appearance:GameData.heroAppearance(),claims:GameData.missionClaims});
            }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";
        }
    }
}
