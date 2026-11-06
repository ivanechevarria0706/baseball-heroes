package {
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.PNGEncoderOptions;
    import flash.desktop.NativeApplication;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.display.DisplayObjectContainer;
    import flash.text.TextField;
    import flash.events.UncaughtErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.setTimeout;
    import flash.geom.Point;
    import com.bh.model.GameData;
    import com.bh.ui.LobbyScreen;
    import com.bh.ui.LineupScreen;
    import com.bh.core.Game;
    import com.bh.ui.Hud;
    import com.bh.game.Ball;
    import com.bh.ui.UIButton;

    public class VisualSmoke extends Sprite {
        private var scene:Sprite;
        private var names:Array = ["lobby", "lineup", "match", "match-major"];
        private var index:int = 0;
        private var phase:String = "before";
        private var callbackCount:int=0;
        private var checks:Array=[];
        private var attempts:int=0;
        public function VisualSmoke() {
            stage.scaleMode = "noScale";
            stage.align = "TL";
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, failed);
            setTimeout(function():void {
                phase = "classic";
                GameData.init();
                GameData.onboardingStep = GameData.ONBOARDING_COMPLETE;
                GameData.seasonGoalSet = true;
                next();
            }, 200);
        }
        private function next():void {
            if (scene) {
                Object(scene).dispose();
                removeChild(scene);
            }
            if (index == names.length) {
                if(phase!="before") {
                    GameData.stadiumActive.background="stadium_background_city";
                    scene=new LobbyScreen(960,540,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop);
                    addChild(scene);
                    setTimeout(function():void {saveImage("lobby-major");Object(scene).dispose();finish();},1200);
                } else finish();
                return;
            }
            if (index == 0) scene = new LobbyScreen(960,540,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop,noop);
            else if (index == 1) scene = new LineupScreen(960,540,noop,noop,noop,noop);
            else {
                if(index==3) GameData.stadiumActive.background="stadium_background_major_night";
                scene = new Game(960,540,noop,noop);
                attempts=0;
            }
            addChild(scene);
            setTimeout(capture, 1200);
        }
        private function capture():void {
            saveImage(names[index]);
            if(phase!="before"&&index==0) checkLobby();
            if(phase!="before"&&index==1) checkLineup();
            if(phase!="before"&&index>=2) { waitForBatting();return; }
            index++;
            next();
        }
        private function saveImage(name:String):void {
            if(index==3) name="major-"+name;
            var data:BitmapData = new BitmapData(960,540,false,0x162f42);
            data.draw(scene);
            var file:File = new File(File.applicationDirectory.nativePath).resolvePath("qa/" + phase + "-" + name + ".png");
            file.parent.createDirectory();
            var stream:FileStream = new FileStream();
            stream.open(file, FileMode.WRITE);
            stream.writeBytes(data.encode(data.rect,new PNGEncoderOptions()));
            stream.close();
            data.dispose();
        }
        private function checkLobby():void {
            var keys:Array=["PLAY","TEAM","DRAFT","SHOP","BUILD","MISSIONS","HERO","LEAGUE","GOALS","NAME","MODES","ROADMAP"];
            for each(var key:String in keys) {
                var b:Sprite=scene.getChildByName(key) as Sprite;
                if(!b||!b.visible) throw new Error("Missing navigation: "+key);
                var count:int=callbackCount;b.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                if(callbackCount!=count+1) throw new Error("Callback: "+key);
            }
            checks.push("PASS: all 12 lobby destinations dispatch callbacks.");
            GameData.gateIncomeLastAt=0;
            var initial:int=GameData.coins, reward:int=GameData.gateIncomeAmount();
            var collect:Sprite=scene.getChildByName("COLLECT") as Sprite;
            collect.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(GameData.coins!=initial+reward) throw new Error("Gate income reward");
            var strings:String=readText(scene);
            var formatted:String=String(GameData.coins).replace(/\B(?=(\d{3})+(?!\d))/g,",");
            if(strings.indexOf(formatted)<0) throw new Error("Coin HUD did not refresh");
            collect.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(GameData.coins!=initial+reward) throw new Error("Duplicate gate income");
            checks.push("PASS: gate income refreshes visible balance; repeated collection cannot duplicate coins.");
        }
        private function readText(container:DisplayObjectContainer):String {
            var value:String="";
            for(var i:int=0;i<container.numChildren;i++) {
                var child:Object=container.getChildAt(i);
                if(child is TextField) value+=TextField(child).text+"\n";
                else if(child is DisplayObjectContainer) value+=readText(child as DisplayObjectContainer);
            }
            return value;
        }
        private function findNamed(container:DisplayObjectContainer,name:String):Sprite {
            for(var i:int=0;i<container.numChildren;i++) {
                var child:Object=container.getChildAt(i);
                if(child.name==name) return child as Sprite;
                if(child is DisplayObjectContainer) {
                    var found:Sprite=findNamed(child as DisplayObjectContainer,name);
                    if(found) return found;
                }
            }
            return null;
        }
        private function checkLineup():void {
            var before:Array=GameData.battingOrderPlayers();
            var bench:Array=GameData.substitutePlayers();
            if(before.length!=9 || bench.length==0) throw new Error("QA needs nine hitters and a substitute");
            var original:Object=before[1];
            var replacement:Object=bench[0];
            findNamed(scene,"slot_1").dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            findNamed(scene,"bench_0").dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(GameData.battingOrderPlayers()[1].name!=replacement.name) throw new Error("Lineup click substitution failed");
            GameData.substituteBattingOrder(1,original);
            if(GameData.battingOrderPlayers()[1].name!=original.name) throw new Error("QA lineup restoration failed");
            var targetRow:Sprite=findNamed(scene,"slot_2");
            var drop:Point=targetRow.localToGlobal(new Point(40,15));
            findNamed(scene,"slot_1").dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,false,10,10));
            stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE,true,false,drop.x,drop.y));
            stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,false,drop.x,drop.y));
            if(GameData.battingOrderPlayers()[2].name!=original.name) throw new Error("Lineup drag did not reorder hitters");
            GameData.moveBattingOrder(2,1);
            if(GameData.battingOrderPlayers()[1].name!=original.name) throw new Error("QA drag restoration failed");
            var homeFound:Boolean=false;
            for(var i:int=0;i<scene.numChildren;i++) {
                var button:UIButton=scene.getChildAt(i) as UIButton;
                if(button && readText(button).replace(/\s/g,"")=="HOME") {
                    homeFound=true;
                    var count:int=callbackCount;button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                    if(callbackCount!=count+1) throw new Error("Lineup HOME callback");
                }
            }
            if(!homeFound) throw new Error("Missing lineup HOME");
            checks.push("PASS: lineup click substitution and drag reordering update the intended slots; original QA order restored; HOME works.");
        }
        private function waitForBatting():void {
            var hud:Hud;
            for(var i:int=0;i<scene.numChildren;i++) if(scene.getChildAt(i) is Hud) hud=scene.getChildAt(i) as Hud;
            if(hud&&hud.visible&&readText(hud).indexOf("READY")>=0) {
                saveImage("batting-ready");
                stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));
                setTimeout(function():void {
                    var ball:Ball=findBall(scene);
                    if(!ball || ball.visible) throw new Error("Ball released before windup finished");
                    saveImage("windup");
                },500);
                setTimeout(captureReleasedPitch,1100);
                return;
            }
            if(attempts++>120) throw new Error("Hero READY not reached in 30 seconds");
            setTimeout(waitForBatting,250);
        }
        private function captureReleasedPitch(retries:int=0):void {
            var ball:Ball=findBall(scene);
            if(!ball) throw new Error("Missing game ball");
            // AIR can throttle ENTER_FRAME when its test window loses focus.
            // Wait for a rendered release, with a bound, instead of a single timer sample.
            if(!ball.visible && retries<12) {setTimeout(captureReleasedPitch,100,retries+1);return;}
            if(!ball.visible) throw new Error("Ball was not released after windup");
            saveImage("pitch");
            stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));
            setTimeout(function():void {saveImage("swing-contact");},120);
            setTimeout(function():void {
                saveImage("swing");
                checks.push("PASS: "+names[index]+" reaches READY; ball hidden during windup, visible after release; SPACE swings without uncaught errors.");
                index++;next();
            },500);
        }
        private function findBall(container:DisplayObjectContainer):Ball {
            for(var i:int=0;i<container.numChildren;i++) {
                var child:Object=container.getChildAt(i);
                if(child is Ball) return child as Ball;
                if(child is DisplayObjectContainer) {
                    var found:Ball=findBall(child as DisplayObjectContainer);
                    if(found) return found;
                }
            }
            return null;
        }
        private function write(name:String, value:String):void {
            var file:File = new File(File.applicationDirectory.nativePath).resolvePath("qa/" + name);
            file.parent.createDirectory();
            var stream:FileStream = new FileStream();
            stream.open(file,FileMode.WRITE);
            stream.writeUTFBytes(value);
            stream.close();
        }
        private function finish():void {
            write("smoke-" + phase + ".txt", "PASS: lobby, lineup, match constructed and rendered; isolated QA save ID.\n"+checks.join("\n"));
            NativeApplication.nativeApplication.exit();
        }
        private function failed(e:UncaughtErrorEvent):void {
            e.preventDefault();
            trace("FAIL: "+e.error);
            write("smoke-" + phase + ".txt", "FAIL: " + e.error + "\n" + (e.error is Error ? Error(e.error).getStackTrace() : ""));
            NativeApplication.nativeApplication.exit(1);
        }
        private function noop(...args):void { callbackCount++; }
    }
}
