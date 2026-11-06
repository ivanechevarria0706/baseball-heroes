package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.text.TextField;
    import flash.geom.Matrix;
    import flash.utils.setTimeout;
    import com.bh.ui.Hud;
    import com.bh.model.GameData;
    import com.bh.model.Player;
    import com.bh.game.BattingCursor;
    public class HudSmoke extends Sprite {
        private var hud:Hud;
        private var p:Player;
        public function HudSmoke(){
            stage.scaleMode='noScale';stage.align='TL';
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});
            GameData.init();var data:Object=GameData.mainPlayer();p=new Player(String(data.name),8,74,85,70);
            hud=new Hud(960,540,p);addChild(hud);setTimeout(run,600);
        }
        private function field(id:String):TextField {return hud.getChildByName(id) as TextField;}
        private function assert(value:Boolean,message:String):void {if(!value)throw new Error(message);}
        private function color(d:DisplayObject):uint {var b:BitmapData=new BitmapData(20,20,true,0);b.draw(d,new Matrix(1,0,0,1,10,10));var c:uint=b.getPixel(10,10);b.dispose();return c;}
        private function shot(name:String):void {
            var b:BitmapData=new BitmapData(960,540,false,0x6cc7df);b.draw(hud);
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();
        }
        private function run():void {
            var ids:Array=['first','second','third'];
            for(var mask:int=0;mask<8;mask++){
                hud.setBases(Boolean(mask&1),Boolean(mask&2),Boolean(mask&4));
                for(var i:int=0;i<3;i++){
                    var occupied:Boolean=Boolean(mask&(1<<i));
                    assert(hud.getChildByName('runner-'+ids[i]).visible==occupied,'Minimap runner mismatch '+mask+'/'+ids[i]);
                    assert(color(hud.getChildByName('base-'+ids[i]))==(occupied?0xffc352:0x315b65),'Scoreboard base mismatch '+mask+'/'+ids[i]);
                }
            }
            hud.setGameState(128,99,21,3,2,2,0);
            assert(field('inning').text=='21ST','Extra-inning ordinal');
            for each(var n:int in [11,12,13]){hud.setGameState(128,99,n,3,2,2,0);assert(field('inning').text==n+'TH','Teen ordinal');}
            hud.setGameState(128,99,21,1,1,1,0);
            assert(color(hud.getChildByName('balls-0'))!=color(hud.getChildByName('balls-1')),'Ball count not rendered');
            assert(color(hud.getChildByName('strikes-0'))!=color(hud.getChildByName('strikes-1')),'Strike count not rendered');
            assert(color(hud.getChildByName('outs-0'))!=color(hud.getChildByName('outs-1')),'Out count not rendered');
            GameData.coins=123456789;GameData.cash=1234567;GameData.xp=987654321;
            GameData.seasonHits=12;GameData.seasonRbi=7;GameData.seasonHomeRuns=3;GameData.seasonGoalHomeRuns=15;GameData.seasonGoalRbi=55;
            hud.refresh(p);
            assert(field('coins').text=='123,456,789','Currency did not refresh');
            assert(field('season-hr').text=='3/15'&&field('season-rbi').text=='7/55','Season goal did not refresh');
            assert(field('leader-score').text=='SCORE  3,250','Leaderboard score did not refresh');
            GameData.seasonHits=13;GameData.seasonRbi=8;
            hud.setBatterCareer({avg:'.538',hr:132,rbi:205},7);
            assert(field('leader-score').text=='SCORE  3,625'&&field('season-rbi').text=='8/55','Career update left stale season values');
            hud.setMatchProgress(2,1,3);
            assert(field('leader-score').text=='SCORE  4,625'&&field('season-hr').text=='4/15'&&field('season-rbi').text=='11/55','Live match not included in season display');
            assert(GameData.seasonHits==13&&GameData.seasonRbi==8&&GameData.seasonHomeRuns==3,'HUD changed persisted season counters');
            GameData.seasonHits+=2;GameData.seasonRbi+=3;GameData.seasonHomeRuns++;
            hud.setMatchProgress(2,1,3,true);
            assert(field('leader-score').text=='SCORE  4,625'&&field('season-hr').text=='4/15'&&field('season-rbi').text=='11/55','Finished match counted twice');
            var old:DisplayObject=hud.getChildByName('batter-portrait');
            var next:Object=GameData.roster[1];hud.refresh(new Player(String(next.name),9,81,79,65));
            assert(hud.getChildByName('batter-portrait')!==old,'Portrait did not follow active batter');
            p.name='ALEJANDRO FERNANDO MARTINEZ';hud.refresh(p);
            hud.setOpponentName('LOS ANGELES BASEBALL HEROES');hud.setBatterContext(9,'CHRISTOPHER ALEXANDER');hud.setActiveSkill('BATTING EYE LV1 • COMBO 80');hud.setBases(true,false,true);
            for each(var id:String in ['coins','cash','xp','leader-score','batter-name','away-name','next-batter','home-score','away-score','skill-values']){
                var t:TextField=field(id);assert(t.textWidth<=t.width-2&&t.textHeight<=t.height,'Clipped text: '+id+' '+t.textWidth+'/'+t.width+' '+t.textHeight+'/'+t.height);
            }
            for(i=0;i<10;i++)hud.addHeroHitHistory('SINGLE',0);
            assert(field('hit-history').numLines==7,'Hit history not capped');hud.clearHeroHitHistory();assert(field('hit-history').text=='','History not cleared');
            shot('v051-hud-stress.png');cursorCheck();hud.dispose();hud.dispose();
            finish('PASS: all eight base states agree in scoreboard/minimap; B/S/O count rendering; season goals and score include the live match without changing saved counters or double-counting at completion; portrait follows batter; large values and long names fit; extra innings and bounded history; reticle lifecycle and progress-only pulse.\n',0);
        }
        private function cursorCheck():void {
            var c:BattingCursor=new BattingCursor(0,0,24);c.configureForPitch(85,70,0,'FASTBALL');c.setActive(true);c.setTimingProgress(.2);assert(!c.visible,'Target exposed too early');
            c.setTimingProgress(.75);assert(c.visible,'Target never appeared');var alpha:Number=c.alpha;
            for(var i:int=0;i<60;i++)c.dispatchEvent(new Event(Event.ENTER_FRAME));assert(c.alpha==alpha,'Reticle pulse still depends on frame count');
            c.setActive(false);assert(!c.visible,'Inactive reticle visible');c.dispose();c.dispose();
        }
        private function finish(value:String,code:int):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-hud.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);
        }
    }
}
