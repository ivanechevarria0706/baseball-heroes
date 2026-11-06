package {
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.geom.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.utils.*;
    import com.bh.ui.*;
    import com.bh.model.GameData;
    import com.bh.audio.AudioManager;
    import com.bh.visual.TeamLogoView;
    import com.bh.visual.CharacterPortrait;
    public class MenuPresentationSmoke extends Sprite {
        private var names:Array=['team-select','character','arrival','goal','roadmap','season','travel','intro','modes','derby','team-name','missions','team','training','skills','equipment','shop','build','scout','special','trade','pregame'];
        private var index:int=0, view:Sprite, baseline:Boolean=false, heightValue:int=720, ended:Boolean=false;
        private var report:Array=[], callbacks:int=0;
        public function MenuPresentationSmoke() {
            stage.scaleMode='noScale';stage.align='TL';stage.frameRate=30;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void {e.preventDefault();finish('FAIL: '+e.error,1);});
            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,start);
        }
        private function start(e:InvokeEvent):void {
            NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE,start);
            // Earlier captures belong to 0.5.7; this binary only validates 0.5.8.
            baseline=false;heightValue=720;
            AudioManager.setSfxVolume(0);GameData.init();GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
            GameData.energy=GameData.maxEnergy;GameData.coins=1000000;
            next();setTimeout(function():void {finish('FAIL: timeout',1);},90000);
        }
        private function noop(...args):void {callbacks++;}
        private function next():void {
            if(view) {Object(view).dispose();removeChild(view);view=null;}
            if(index>=names.length) {finish('PASS: '+names.length+' screens at 960x'+heightValue+'; visible text, controls, logos and portraits inside viewport; 27 club cells retain local logo bounds; roadmap and season pagination; nine shop items and categories; six equipment categories; character and mission tabs; two active mode callbacks; scouting reveal; special-card shop open/close; four intro phases; captures: '+report.join('; ')+'; isolated application/save.\n',0);return;}
            var w:int=960,h:int=heightValue;
            switch(names[index]) {
                case 'team-select':view=new TeamSelectionScreen(w,h,noop,noop);break;
                case 'character':view=new CharacterMakerScreen(w,h,noop,noop);break;
                case 'arrival':view=new ArrivalMapScreen(w,h,noop);break;
                case 'goal':view=new SeasonGoalScreen(w,h,noop);break;
                case 'roadmap':view=new RoadmapToMajorScreen(w,h,noop);break;
                case 'season':view=new SeasonRoadmapScreen(w,h,noop,noop);break;
                case 'travel':view=new TravelMapScreen(w,h,noop,noop);break;
                case 'intro':view=new MatchIntroScreen(w,h,noop,noop);break;
                case 'modes':view=new ModeSelectScreen(w,h,noop,noop,noop,noop);break;
                case 'derby':view=new HomeRunDerbyScreen(w,h,noop);break;
                case 'team-name':view=new TeamNameScreen(w,h,noop);break;
                case 'missions':view=new MissionsScreen(w,h,noop,noop);break;
                case 'team':view=new TeamScreen(w,h,noop,noop,noop,noop,noop,noop);break;
                case 'training':view=new TrainingScreen(w,h,GameData.mainPlayer(),noop);break;
                case 'skills':view=new SkillScreen(w,h,GameData.mainPlayer(),noop);break;
                case 'equipment':view=new EquipmentScreen(w,h,noop);break;
                case 'shop':view=new ShopScreen(w,h,noop,noop);break;
                case 'build':view=new BuildScreen(w,h,noop,noop);break;
                case 'scout':view=new ScoutScreen(w,h,noop,noop);break;
                case 'special':view=new SpecialCardsScreen(w,h,noop);break;
                case 'trade':view=new TradeEnhanceScreen(w,h,noop);break;
                case 'pregame':view=new PregameScreen(w,h,noop,noop,noop);break;
            }
            addChild(view);setTimeout(capture,700);
        }
        private function capture():void {
            shot(String(names[index]));
            if(!baseline) {checkControls(view);exercise();checkControls(view);}
            if(names[index]=='intro') {
                setTimeout(function():void {shot('intro-vs');checkControls(view);
                    setTimeout(function():void {shot('intro-stadium');checkControls(view);
                        setTimeout(function():void {shot('intro-fireball');checkControls(view);advance();},1250);
                    },1900);
                },900);return;
            }
            if(!baseline&&names[index]=='special') {click('OPEN BATTER SHOP');setTimeout(function():void {shot('special-shop');checkControls(view);click('X');advance();},700);return;}
            advance();
        }
        private function advance():void {index++;next();}
        private function check(value:Boolean,message:String):void {if(!value)throw new Error(names[index]+': '+message);}
        private function dispatch(d:DisplayObject):void {check(d!=null,'Missing control');d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function exercise():void {
            var d:DisplayObject,i:int,old:int=callbacks;
            if(names[index]=='team-select') {
                var cells:int=0;
                for(i=0;i<view.numChildren;i++) {
                    d=view.getChildAt(i);
                    if(d is Sprite&&Sprite(d).buttonMode&&!(d is UIButton)) {
                        cells++;var r:Rectangle=d.getBounds(d);
                        check(r.left>=-2&&r.top>=-2&&r.right<=74&&r.bottom<=44,'Club logo/label escaped its cell '+r);
                        dispatch(d);
                    }
                }
                check(cells==27,'Expected 27 visible clubs');check(callbacks==old,'Selecting a preview navigated away');
            }
            else if(names[index]=='roadmap') {dispatch(named(view,'league_4'));click('<');click('>');shot('roadmap-major');}
            else if(names[index]=='shop') {
                for(i=0;i<4;i++)click('NEXT');click('PREV');click('PREV');
                var cards:Array=collect(view,ShopItemCard);check(cards.length==9,'Expected nine shop items');dispatch(cards[0]);shot('shop-detail');
                click('STADIUM');check(collect(view,ShopItemCard).length>0,'Empty stadium category');
                click('ENERGY');check(collect(view,ShopItemCard).length>0,'Empty energy category');
            }
            else if(names[index]=='equipment') {
                for each(var slot:String in ['bat','glove','belt','helmet','shoes','goggles']) {dispatch(view.getChildByName(slot));checkControls(view);}
                shot('equipment-goggles');
            }
            else if(names[index]=='character'||names[index]=='missions') {
                var tabs:Array=[];
                for(i=0;i<view.numChildren;i++){d=view.getChildAt(i);if(d is Sprite&&Sprite(d).buttonMode&&!(d is UIButton))tabs.push(d);}
                for each(d in tabs){dispatch(d);checkControls(view);}
                shot(String(names[index])+'-alternate');
            }
            else if(names[index]=='season') {for(i=0;i<9;i++)click('>');for(i=0;i<9;i++)click('<');checkControls(view);}
            else if(names[index]=='modes') {
                for(i=0;i<view.numChildren;i++){d=view.getChildAt(i);if(d is Sprite&&Sprite(d).buttonMode&&!(d is UIButton))dispatch(d);}
                check(callbacks==old+2,'Two playable mode callbacks expected');
            }
            else if(names[index]=='scout') {click('AUTO PICK\nC 20,000');shot('scout-prospect');}
        }
        private function collect(c:DisplayObjectContainer,type:Class):Array {var result:Array=[];for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is type)result.push(d);else if(d is DisplayObjectContainer)result=result.concat(collect(d as DisplayObjectContainer,type));}return result;}
        private function named(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=named(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function checkControls(c:DisplayObjectContainer):void {
            for(var i:int=0;i<c.numChildren;i++) {
                var d:DisplayObject=c.getChildAt(i);if(!d.visible||d.alpha==0)continue;
                if(d is UIButton||d is TextField||d is TeamLogoView||d is CharacterPortrait||(d is Sprite&&Sprite(d).buttonMode)) {var r:Rectangle=d.getBounds(view);if(r.x < -3||r.y < -3||r.right > 963||r.bottom > heightValue+3)throw new Error(names[index]+' element outside viewport: '+d.name+' '+r);}
                if(d is DisplayObjectContainer)checkControls(d as DisplayObjectContainer);
            }
        }
        private function label(c:DisplayObjectContainer):String {var s:String='';for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is TextField)s+=TextField(d).text;else if(d is DisplayObjectContainer)s+=label(d as DisplayObjectContainer);}return s.replace(/\r/g,'\n');}
        private function button(c:DisplayObjectContainer,text:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is UIButton&&label(d as DisplayObjectContainer)==text)return d;if(d is DisplayObjectContainer){var f:DisplayObject=button(d as DisplayObjectContainer,text);if(f)return f;}}return null;}
        private function click(text:String):void {var d:DisplayObject=button(view,text);if(!d)throw new Error('Missing '+text);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function shot(name:String):void {var b:BitmapData=new BitmapData(960,heightValue,false,0x132a3c);b.draw(view);write('qa/v058-'+(baseline?'before-':'')+name+'.png',b.encode(b.rect,new PNGEncoderOptions()));b.dispose();report.push(name);}
        private function write(path:String,bytes:ByteArray):void {var f:File=new File(File.applicationDirectory.nativePath).resolvePath(path);f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(bytes);s.close();}
        private function finish(message:String,code:int):void {if(ended)return;ended=true;var b:ByteArray=new ByteArray();b.writeUTFBytes(message);write('qa/smoke-menu-presentation'+(baseline?'-before':'')+'.txt',b);NativeApplication.nativeApplication.exit(code);}
    }
}
