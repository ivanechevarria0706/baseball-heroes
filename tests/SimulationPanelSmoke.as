package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.text.TextField;
    import flash.utils.setTimeout;
    import com.bh.model.GameData;
    import com.bh.ui.*;
    import com.bh.audio.GameplayAudio;
    import com.bh.audio.AudioManager;
    public class SimulationPanelSmoke extends Sprite {
        private var time:int=0;
        private var panel:TeamSimulationPanel;
        public function SimulationPanelSmoke(){
            stage.scaleMode='noScale';stage.align='TL';
            AudioManager.setSfxVolume(0);
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            GameData.init();panel=new TeamSimulationPanel(960,540,function():int{return time;});panel.configure(GameData.battingOrderPlayers(),GameData.currentOpponent(),GameData.mainPlayer());addChild(panel);setTimeout(run,700);
        }
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function txt(id:String):String{return TextField(find(panel,id)).text;}
        private function assert(value:Boolean,message:String):void {if(!value)throw new Error(message);}
        private function tick():void {panel.dispatchEvent(new Event(Event.ENTER_FRAME));}
        private function click(speed:int):void {find(panel,'speed-'+speed).dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function shot(name:String):void {
            var b:BitmapData=new BitmapData(960,540,false,0x478c5a);b.draw(panel);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();
        }
        private function run():void {
            panel.beginSimulation(1,'HOME');time=400;tick();panel.setActiveBatter('HOME',2);panel.setBases(true,false,true);panel.addResultFor('HOME',2,'Player','SINGLE',1);panel.setScore(2,0,1,0);
            var row:SimulationPlayerRow=find(panel,'home-row-2') as SimulationPlayerRow;
            assert(panel.resultDelay()>=GameplayAudio.duration(GameplayAudio.SIM_HIT)+40,'Hit audio cut short at x4');
            var stamp:Sprite=find(panel,'simulation-result') as Sprite;
            assert(stamp&&stamp.numChildren==1&&stamp.getChildAt(0) is TextField,'Result stamp missing readable label');
            var resultLabel:TextField=stamp.getChildAt(0) as TextField;assert(resultLabel.embedFonts&&resultLabel.text=='1 BASE HIT!'&&resultLabel.textWidth>0,'Result lettering has no embedded glyphs');
            click(2);assert(panel.simulationDelay()==880,'x2 not applied');assert(find(panel,'home-row-2')===row&&row.isActive,'Speed rebuilt or deselected active row');
            assert(TextField(find(row,'last-result')).text=='1B'&&find(panel,'first-runner').visible&&find(panel,'third-runner').visible,'Speed erased result or bases');
            assert(txt('home-runs')=='2'&&txt('home-inning-0')=='2','Score not retained');click(1);assert(panel.simulationDelay()==1650,'x1 not applied');click(4);assert(panel.simulationDelay()==470,'x4 not applied');
            time=500;tick();shot('v052-simulation-home.png');
            panel.setHalfInning('AWAY',2);panel.setScore(2,3,2,3);panel.setScore(2,3,2,3);
            assert(txt('away-inning-1')=='3'&&txt('home-inning-0')=='2','Inning score duplicated or lost');assert(txt('home-inning-1')=='–','Unplayed half shown as completed');
            panel.setHalfInning('HOME',11);panel.setScore(3,3,11,1);assert(txt('inning-header-8')=='11'&&txt('home-inning-8')=='1','Extra inning not displayed');
            var card:Object=GameData.specialCardCatalog()[0];panel.showSpecialCardResult(card,'HOME RUN');assert(find(panel,'simulation-special-card') is SpecialBatterCardView,'Special result did not use real card view');assert(panel.resultDelay()==1250,'Special card has no readable hold');shot('v052-special-card.png');
            time=2000;panel.showHeroTurn(String(GameData.mainPlayer().name),2,'3-3');click(1);assert(panel.simulationDelay()==470,'Speed input affected hero handoff');
            time=2600;tick();assert(find(panel,'home-lineup').alpha==0&&panel.heroReveal()==0,'Empty field interval missing');shot('v052-hero-empty.png');
            time=2970;tick();assert(find(panel,'hero-transition-shade').alpha>.99&&panel.heroReveal()==0,'Camera cut missing');
            time=3250;tick();assert(panel.heroReveal()>.4&&panel.heroReveal()<.6,'Hero reveal not timed');
            time=3600;tick();assert(panel.heroReveal()==1,'Hero handoff not complete');panel.hidePanel();assert(!panel.visible,'Panel did not hide');
            time=4000;panel.beginSimulation(2,'AWAY');time=4400;tick();assert(find(panel,'away-lineup').alpha==1&&find(panel,'first-runner').visible,'Return to simulation lost layout or bases');shot('v052-simulation-return.png');
            panel.recordBatterResult('HOME',0,'WALK');assert(TextField(find(find(panel,'home-row-0') as DisplayObjectContainer,'last-result')).text=='BB','Manual result not retained in lineup');
            panel.addResultFor('AWAY',0,'Player','OUT');assert(panel.resultDelay()>=GameplayAudio.duration(GameplayAudio.SIM_OUT)+40,'OUT audio cut short');
            panel.addResultFor('AWAY',1,'Player','WALK');assert(panel.resultDelay()==300,'WALK inherited the prior audio hold');
            panel.dispose();panel.dispose();finish('PASS: speed x1/x2/x4 preserves row objects, active batter, bases and results; result text renders under rotation; inning totals do not duplicate and extras display; special result uses actual card; empty field/cut/reveal/return are time-based; manual result persists; disposal repeat-safe.\n',0);
        }
        private function finish(value:String,code:int):void {var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-simulation-panel.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
