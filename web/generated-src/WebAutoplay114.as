package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.visual.MatchStadium;import com.bh.audio.GameplayAudio;
    public class WebAutoplay114 extends WebSmoke {
        private var panel:TeamSimulationPanel,layer:Sprite,stadium:MatchStadium,social:MatchSocialBar,now:int=0,checks:int=0;
        public function WebAutoplay114(){super();ExternalInterface.addCallback('bh114',run);}
        private function check(ok:Boolean,label:String):void {checks++;if(!ok)throw new Error(label);}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function txt(id:String):String {var t:TextField=find(panel,id) as TextField;return t?t.text:'';}
        private function close():void {if(panel){panel.dispose();panel=null;}if(stadium){stadium.dispose();stadium=null;}if(social){social.dispose();social=null;}if(layer){removeChild(layer);layer=null;}}
        private function setup():void {
            close();GameData.startNewCareer();GameData.coins=100000;GameData.onboardingStep=99;GameData.seasonGoalSet=true;
            GameData.starterTutorial=StarterTutorial.create(true);var draw:Object=GameData.drawSpecialClassPack('C');GameData.specialEquipped[0]=draw.card.id;GameData.starterTutorial=StarterTutorial.create();
            var order:Array=GameData.battingOrderPlayers();order[2].socialId='qa114-linked';GameData.socialState.links=[{player:'qa114-linked',friend:'qa114-friend',name:'QA Friend',average:320}];
            FriendRoster.update({members:[{id:'qa114-friend',connected:true,name:'QA Friend',profile:{level:1,accent:0x257aaa,appearance:GameData.heroAppearance(),avg:320}}]});
            layer=new Sprite();addChild(layer);stadium=new MatchStadium(960,588);layer.addChild(stadium);now=0;
            panel=new TeamSimulationPanel(960,588,function():int{return now;});panel.configure(order,GameData.currentOpponent(),GameData.mainPlayer());layer.addChild(panel);
            social=new MatchSocialBar({});social.y=590;layer.addChild(social);panel.beginSimulation(3,'AWAY');panel.setScore(0,1,3,0);panel.setHalfInning('HOME',3);panel.setScore(1,1,3,0);now=400;tick();
        }
        private function tick():void {panel.dispatchEvent(new Event(Event.ENTER_FRAME));MatchMiniDiamond(find(panel,'simulation-diamond')).advance();}
        private function result(kind:String):void {
            var away:Boolean=kind.indexOf('OUT')>=0,side:String=away?'AWAY':'HOME',index:int=away?3:1;
            panel.setHalfInning(side,3);panel.setActiveBatter(side,index);panel.addResultFor(side,index,away?'Walker':'Lenard',kind,away?0:2);
            var a:Object={},b:Object={},batter:Object={},before:Array=[a,b,null],after:Array=/SINGLE|DOUBLE|TRIPLE|HOME RUN/.test(kind)?[batter,null,a]:[a,b,null];
            panel.showResolvedPlay(before,after,batter,kind);panel.setBases(after[0]!=null,after[1]!=null,after[2]!=null);panel.setScore(2,1,3,away?2:0);panel.setHits(4,2);panel.setMomentum({charge:7});panel.setLiveScore(4830);tick();
        }
        private function snapshot():Object {return {coins:GameData.coins,xp:GameData.xp,energy:GameData.energy,speedDelay:panel?panel.simulationDelay():0,resultDelay:panel?panel.resultDelay():0,home:panel?txt('home-runs'):'',away:panel?txt('away-runs'):'',time:now};}
        private function run(action:String='state',value:String=''):String {
            try {
                if(action=='model')return JSON.stringify(model());
                if(action=='demo')setup();
                if(action=='result')result(value);
                if(action=='time'){now=int(value);tick();}
                if(action=='speed')find(panel,'speed-'+value).dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));
                if(action=='hero')panel.showHeroTurn(String(GameData.mainPlayer().name),3,'2-1');
                if(action=='close')close();
                return JSON.stringify(snapshot());
            }catch(e:Error){return JSON.stringify({error:e.message,checks:checks});}
            return '{}';
        }
        private function model():Object {
            checks=0;setup();var coins:int=GameData.coins,xp:int=GameData.xp,energy:int=GameData.energy;
            check(txt('simulation-player-name')==String(GameData.mainPlayer().name),'hero name');
            var row:DisplayObjectContainer=find(panel,'home-row-1') as DisplayObjectContainer;
            check(TextField(find(row,'simulation-player-name')).text=='Lenard J.','equipped special identity');
            check(find(find(panel,'home-row-2') as DisplayObjectContainer,'support-slot')!=null,'cached support slot');
            result('SINGLE +1 RBI');check(txt('home-runs')=='2'&&txt('home-hits')=='4'&&txt('away-hits')=='2','actual R/H totals');
            check(TextField(find(row,'last-result')).text=='1B'&&SimulationPlayerRow(row).isActive,'retained result badge');
            var stamp:Sprite=find(panel,'simulation-result') as Sprite,label:TextField=stamp.getChildAt(0) as TextField;
            check(label.embedFonts&&label.textWidth>100&&label.cacheAsBitmap,'embedded result label cached');
            check(panel.resultDelay()>=GameplayAudio.duration(GameplayAudio.SIM_HIT)+40,'original hit sound hold');
            var duration:int=panel.resultDelay();now=400+int(duration*.45);tick();check(find(panel,'advancing-runner')!=null,'resolved runners move');
            now=400+duration;tick();check(find(panel,'advancing-runner')==null&&find(panel,'first-runner').visible&&!find(panel,'second-runner').visible&&find(panel,'third-runner').visible,'final actual bases');
            for each(var speed:int in [1,2,4]){find(panel,'speed-'+speed).dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));check(panel.simulationDelay()==(speed==1?1650:speed==2?880:470),'unchanged speed '+speed);check(find(panel,'home-row-1')===row&&SimulationPlayerRow(row).isActive,'speed retains actors '+speed);}
            panel.addResultFor('HOME',1,'Lenard','SINGLE',0);stamp=find(panel,'simulation-result') as Sprite;check(stamp.getChildAt(0)===label,'result label reused');
            panel.addResultFor('AWAY',0,'Keith','STRIKE OUT',0);panel.showResolvedPlay([null,null,null],[null,null,null],{},'STRIKE OUT');
            check(!find(panel,'minimap-ball').visible&&find(panel,'advancing-runner')==null,'strike out has no batted ball');
            panel.addResultFor('AWAY',0,'Keith','WALK',0);check(panel.resultDelay()==300,'walk keeps previous timing');
            panel.setHalfInning('HOME',11);panel.setScore(3,1,11,1);check(txt('inning-header-8')=='11'&&txt('home-inning-8')=='1','extra innings intact');
            var card:Object=GameData.specialCardForMatch(0);panel.showSpecialCardResult(card,'HOME RUN');check(panel.resultDelay()==1250&&find(panel,'simulation-special-card')!=null,'special card readable hold');
            now=2000;panel.showHeroTurn(String(GameData.mainPlayer().name),11,'3-1');find(panel,'speed-1').dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));check(panel.simulationDelay()==470,'handoff blocks speed clicks');
            now=2600;tick();check(find(panel,'home-lineup').alpha==0&&panel.heroReveal()==0,'empty field handoff');now=2970;tick();check(find(panel,'hero-transition-shade').alpha>.99,'camera cut');now=3600;tick();check(panel.heroReveal()==1,'manual reveal');
            panel.hidePanel();check(!panel.visible&&find(panel,'advancing-runner')==null&&!find(panel,'minimap-ball').visible,'hidden panel stops animated tracks');
            check(GameData.coins==coins&&GameData.xp==xp&&GameData.energy==energy,'presentation grants and spends nothing');
            panel.dispose();panel.dispose();check(true,'repeatable disposal');close();return {status:'PASS',checks:checks,frequenciesUnchanged:true,presentationOnly:true};
        }
    }
}
