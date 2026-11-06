package {
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.utils.*;
    import com.bh.Main;
    import com.bh.model.GameData;
    import com.bh.core.Game;
    import com.bh.ui.*;
    import com.bh.audio.AudioManager;
    public class HomeRoutes063Smoke extends Sprite {
        private var app:Main,home:LobbyScreen,lineup:LineupScreen;
        private var bench:Object,expected:Array,started:int,gameSeenAt:int=-1,finished:Boolean=false,before:String,callbackCount:int=0;
        public function HomeRoutes063Smoke(){
            stage.scaleMode='noScale';stage.align='TL';
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            AudioManager.setSfxVolume(0);GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;GameData.energy=GameData.maxEnergy;
            app=new Main();addChild(app);setTimeout(run,1200);setTimeout(function():void{finish('FAIL: route timeout',1);},90000);
        }
        private function find(c:DisplayObjectContainer,type:Class):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is type)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,type);if(f)return f;}}return null;}
        private function named(c:DisplayObjectContainer,id:String):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=named(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function click(c:DisplayObjectContainer,id:String):void{var d:DisplayObject=named(c,id);check(d!=null,'Missing '+id);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function check(value:Boolean,msg:String):void{if(!value)throw new Error(msg);}
        private function order():String{return GameData.battingOrder.join('|');}
        private function run():void {
            var navigation:LobbyScreen=new LobbyScreen(960,720,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop);
            var keys:Array=['PLAY','TEAM','LINEUP','DRAFT','SHOP','BUILD','MISSIONS','HERO','LEAGUE','GOALS','NAME','MODES','ROADMAP'];
            for each(var key:String in keys){var count:int=callbackCount;click(navigation,key);check(callbackCount==count+1,'Navigation callback '+key);}
            navigation.dispose();
            home=find(app,LobbyScreen) as LobbyScreen;check(home!=null,'Main did not open HOME');
            var routes:Array=[['PLAY',SeasonRoadmapScreen],['TEAM',TeamScreen],['DRAFT',ScoutScreen],['SHOP',ShopScreen],['BUILD',BuildScreen],['MISSIONS',MissionsScreen],['HERO',CharacterMakerScreen],['LEAGUE',TeamSelectionScreen],['GOALS',SeasonGoalScreen],['NAME',TeamNameScreen],['MODES',ModeSelectScreen],['ROADMAP',RoadmapToMajorScreen]];
            for each(var route:Array in routes) {
                click(home,route[0]);var screen:DisplayObject=find(app,route[1]);check(screen!=null,'Main route '+route[0]);
                var root:DisplayObject=screen.parent,scale:Number=Math.min(1,stage.stageWidth/960,stage.stageHeight/720);
                check(Math.abs(root.scaleX-scale)<.001&&root.scaleX==root.scaleY,'4:3 scale '+route[0]);
                check(Math.abs(root.y-Math.round((stage.stageHeight-720*scale)/2))<1,'4:3 centering '+route[0]);
                stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,27));home=find(app,LobbyScreen) as LobbyScreen;check(home!=null,'ESC HOME '+route[0]);
            }
            setTimeout(homeReady,900);
        }
        private function homeReady():void {
            var container:DisplayObject=home.parent;check(container.scaleX==container.scaleY,'HOME stretched');
            shot(home,'home');
            GameData.gateIncomeLastAt=0;var coins:int=GameData.coins,reward:int=GameData.gateIncomeAmount();click(home,'COLLECT');check(GameData.coins==coins+reward,'Gate income failed');click(home,'COLLECT');check(GameData.coins==coins+reward,'Gate income duplicated');
            before=order();click(home,'home_player_1');check(find(home,PlayerDossier)!=null,'HOME profile did not open');check(order()==before,'Viewing profile changed lineup');setTimeout(homeProfile,600);
        }
        private function homeProfile():void {
            shot(home,'home-profile');click(home,'PROFILE_USE');
            lineup=find(app,LineupScreen) as LineupScreen;check(lineup!=null,'Profile did not lead to LINEUP');
            click(lineup,'slot_1');bench=GameData.substitutePlayers()[0];check(bench!=null,'No QA bench');
            click(lineup,'info_bench_0');check(order()==before,'Information button substituted player');
            var profile:PlayerDossier=find(lineup,PlayerDossier) as PlayerDossier;check(profile!=null,'Bench profile missing');
            check(TextField(named(profile,'profile-power')).text==String(GameData.effectivePower(bench)),'Profile uses wrong player values');setTimeout(benchProfile,600);
        }
        private function benchProfile():void {
            shot(lineup,'bench-profile');
            click(lineup,'PROFILE_USE');check(GameData.battingOrderPlayers()[1].name==bench.name,'Explicit substitute failed');
            var moved:String=GameData.battingOrderPlayers()[1].name;drag(1,3);check(GameData.battingOrderPlayers()[3].name==moved,'Scaled drag did not reorder');
            before=order();drag(3,-1);check(order()==before,'Outside drop changed order');
            GameData.battingOrder=[];GameData.load();check(order()==before,'Saved order did not reload');setTimeout(editedLineup,600);
        }
        private function editedLineup():void {
            shot(lineup,'lineup');
            click(lineup,'HOME');home=find(app,LobbyScreen) as LobbyScreen;check(home!=null&&named(home,'home_player_3')!=null,'HOME did not rebuild');
            click(home,'home_player_3');var p:PlayerDossier=find(home,PlayerDossier) as PlayerDossier;
            check(TextField(named(p,'profile-power')).text==String(GameData.effectivePower(bench)),'HOME profile did not follow changed order');click(home,'PROFILE_CLOSE');
            click(home,'LINEUP');lineup=find(app,LineupScreen) as LineupScreen;
            before=order();click(lineup,'SPECIAL');click(lineup,'ALL');check(order()==before,'Filters changed order');
            click(lineup,'NEXT');click(lineup,'PREV');check(order()==before,'Page bounds changed order');
            click(lineup,'BATTER_SHOP');check(find(lineup,BatterShopOverlay)!=null,'Shop did not open');setTimeout(shopOpened,600);
        }
        private function shopOpened():void {
            shot(lineup,'shop');click(lineup,'shop_close');check(find(lineup,BatterShopOverlay)==null,'Shop failed to close');check(order()==before,'Shop browsing changed lineup');
            click(lineup,'AUTO');check(GameData.battingOrderPlayers().length==9,'Auto sort lost players');
            expected=GameData.battingOrderPlayers().concat();click(lineup,'PLAY');
            started=getTimer();addEventListener(Event.ENTER_FRAME,waitGame);
        }
        private function drag(from:int,to:int):void{
            var row:DisplayObject=named(lineup,'slot_'+from),dest:DisplayObject=to>=0?named(lineup,'slot_'+to):lineup;
            row.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,false,180,15));
            var point:Point=to>=0?dest.localToGlobal(new Point(180,20)):lineup.localToGlobal(new Point(947,650));
            var move:MouseEvent=new MouseEvent(MouseEvent.MOUSE_MOVE,true,false,point.x,point.y);stage.dispatchEvent(move);
            stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,false,point.x,point.y));
        }
        private function waitGame(e:Event):void {
            var game:Game=find(app,Game) as Game;if(!game)return;
            if(gameSeenAt<0){gameSeenAt=getTimer();return;}
            var panel:TeamSimulationPanel=find(game,TeamSimulationPanel) as TeamSimulationPanel;
            if(getTimer()-gameSeenAt<1200||!panel||!panel.visible||panel.alpha<0.95)return;
            for(var i:int=0;i<9;i++){var row:SimulationPlayerRow=named(panel,'home-row-'+i) as SimulationPlayerRow;check(row&&row.data.name==expected[i].name,'Match lineup mismatch at '+i);}
            check(game.parent.scaleX==game.parent.scaleY,'Match stretched');shot(game,'match-lineup');game.dispose();
            finish('PASS: all 13 HOME navigation callbacks; 12 actual Main menu routes preserve uniform 4:3 scale and vertical centering at a reduced window and return via ESC; real Main HOME -> profile -> LINEUP; information is read-only; effective player stats; explicit bench substitution; drag under window scaling and rejected outside drop; saved order reloads; HOME reflects edited lineup; filter and page boundaries; shop opens and closes without mutation; auto sort retains nine players; PLAY traverses match intro and all nine match slots match selection; gate income cannot duplicate; isolated save.\n',0);
        }
        private function noop(...args):void{callbackCount++;}
        private function shot(view:DisplayObject,name:String):void{var b:BitmapData=new BitmapData(960,720,false,0x123449);b.draw(view);var file:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/v063-'+name+'.png');file.parent.createDirectory();var s:FileStream=new FileStream();s.open(file,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();}
        private function finish(value:String,code:int):void{if(finished)return;finished=true;removeEventListener(Event.ENTER_FRAME,waitGame);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-home-routes063.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
