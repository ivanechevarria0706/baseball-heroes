package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.geom.Rectangle;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.visual.*;import com.bh.audio.AudioManager;
    public class WebResults1014 extends Sprite {
        private var view:Sprite,field:StadiumBackdrop,bar:MatchResourceBar,counts:Object={home:0,next:0,level:0},kind:String='';
        public function WebResults1014(){stage.scaleMode='noScale';stage.align='TL';stage.frameRate=30;AudioManager.setSfxVolume(0);GameData.init();ExternalInterface.addCallback('bhResults1014',run);ExternalInterface.addCallback('bhResultsBounds1014',bounds);ExternalInterface.call('BHWeb.ready');}
        private function clear():void {if(view){Object(view).dispose();removeChild(view);view=null;}if(field){field.dispose();removeChild(field);field=null;}if(bar){bar.dispose();removeChild(bar);bar=null;}}
        private function show(value:String):void {
            clear();kind=value;counts={home:0,next:0,level:0};GameData.startNewCareer();GameData.starterTutorial=StarterTutorial.create(true);GameData.onboardingStep=99;GameData.seasonGoalSet=true;
            field=new StadiumBackdrop(960,720);addChild(field);bar=new MatchResourceBar();addChild(bar);
            if(value.indexOf('level')==0){
                var n:int=value=='level12'?12:value=='level100'?100:2;
                var items:Array=GameData.shopCatalog().filter(function(p:Object,i:int,a:Array):Boolean{return int(p.unlockLevel)==n;});
                if(value=='level-empty')items=[];
                view=new LevelUpOverlay(960,720,{fromLevel:n-1,toLevel:n,skillPoints:n==100?18:1,coins:n==12?3000:n==100?999999999:2000,maxEnergy:n==2?1:0,unlocked:items},function():void{counts.level++;});addChild(view);return;
            }
            var rows:Array=[],order:Array=GameData.battingOrderPlayers();
            for(var i:int=0;i<9;i++){var p:Object=order[i];rows.push({name:p.name,appearance:p.appearance,isHero:p.isHero,accent:p.accent,hits:i==8?5:i==0?4:1,homeRuns:0,rbi:i==8?1:0,atBats:6});}
            var home:Array=[0,0,0,0,0,0,0,0,0,0,1],away:Array=[0,0,0,0,0,0,0,0,0,0,0];
            GameData.completeSeasonGame(value=='loss'?0:1,value=='loss'?3:0,16,0,6,1,home,away,rows,{version:4,fixtureKey:'',playXP:34,playCoins:109,points:18000,bestStreak:1,heroAttempts:6,events:[]});
            var s:Object=JSON.parse(JSON.stringify(GameData.lastGameSummary));s.levelUp=null;
            if(value=='tie'){s.win=false;s.draw=true;s.homeScore=s.awayScore=2;}
            if(value=='post'){s.competition='POST SEASON';s.roundName='WORLD CHAMPIONSHIP';s.draw=true;s.postStatus='final';s.wins=1;s.losses=1;}
            if(value=='extra'){for(i=0;i<10;i++){s.homeLine.push(i%3);s.awayLine.push(0);}s.homeScore=123;s.awayScore=99;s.teamCity='SAN FRANCISCO';s.boxScore[0].name='A Very Long Legacy Player Name';s.rewardCoins=999999999;s.rewardXp=99999999;}
            if(value=='legacy'){s.boxScore=[];s.scoring=null;s.levelUp=null;}
            GameData.coins=43210;GameData.xp=79;GameData.save();
            view=new GameResultPanel(960,720,s,function():void{counts.home++;},function():void{counts.next++;});addChild(view);
        }
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible)continue;if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(DisplayObjectContainer(d),id);if(f)return f;}}return null;}
        private function bounds(id:String):String {var d:DisplayObject=view?find(view,id):null;if(!d)return 'null';var r:Rectangle=d.getBounds(stage);return JSON.stringify({x:r.x,y:r.y,w:r.width,h:r.height});}
        private function walk(c:DisplayObjectContainer,a:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(!d.visible)continue;if(d is TextField&&d.name.indexOf('-outline-')<0){var t:TextField=TextField(d);a.push({id:t.name,text:t.text,w:t.width,h:t.height,tw:t.textWidth,th:t.textHeight});}if(d is DisplayObjectContainer)walk(DisplayObjectContainer(d),a);}}
        private function run(action:String='state',value:String=''):String {try{
            if(action=='show')show(value);if(action=='dispose')clear();var text:Array=[];if(view)walk(view,text);
            return JSON.stringify({kind:kind,counts:counts,coins:GameData.coins,xp:GameData.xp,seasonGame:GameData.seasonGame,frameListener:view?view.hasEventListener(Event.ENTER_FRAME):false,text:text});
        }catch(e:Error){return JSON.stringify({error:e.message,stack:e.getStackTrace()});}return '{}';}
    }
}
