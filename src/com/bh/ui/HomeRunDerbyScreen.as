package com.bh.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.text.TextField;
    import flash.ui.Keyboard;
    import flash.utils.getTimer;
    import flash.geom.Point;
    import com.bh.game.*;
    import com.bh.model.GameData;
    import com.bh.audio.GameplayAudio;
    import com.bh.audio.AudioCueSequence;
    import com.bh.audio.AudioManager;
    import com.bh.visual.MatchStadium;
    import com.bh.visual.AssetImage;
    import com.bh.visual.VisualAssetRegistry;

    /** Derby adaptation using the current match camera. Existing timing, distance,
     * ten-pitch round and 300 Coins/HR are retained, not historical formula claims. */
    public class HomeRunDerbyScreen extends Sprite {
        private static const READY:String="READY",WINDUP:String="WINDUP",FLIGHT:String="FLIGHT",RESULT:String="RESULT",COMPLETE:String="COMPLETE";
        private static const IDEAL:Number=.84,TOTAL:int=10;
        private var screenW:Number,screenH:Number,fieldH:Number,onBack:Function;
        private var rawClock:Function,nextRandom:Function,paused:Boolean=false,pausedAt:int=0,pausedMillis:int=0,dead:Boolean=false;
        private var boundStage:Stage,phase:String=READY,hero:Object;
        private var stadium:MatchStadium,batter:ClassicBatter,pitcher:Pitcher,ball:Ball,impact:ContactEffect;
        private var hud:Sprite=new Sprite(),chrome:Sprite=new Sprite(),history:Sprite=new Sprite(),feedback:Sprite=new Sprite();
        private var feedbackText:TextField,feedbackAt:int=-1,resultLayer:Sprite,pauseLayer:Sprite;
        private var controls:Array=[],resultControls:Array=[],pauseControls:Array=[];
        private var primary:Sprite,pauseButton:Sprite,logo:AssetImage;
        private var pitchText:TextField,scoreText:TextField,distanceText:TextField,statusText:TextField,helpText:TextField;
        private var pitchNumber:int=1,homeRuns:int=0,totalDistance:int=0,bestDistance:int=0,rows:Array=[],rewardApplied:Boolean=false;
        private var pitchStart:int=0,pitchDuration:int=1000,windupEnd:int=0,resultEnd:int=0,swung:Boolean=false;
        private var targetX:Number,targetY:Number,contactY:Number,flightX:Number,flightY:Number;
        private var heldKeys:Object={};
        private var impactCues:AudioCueSequence;

        public function HomeRunDerbyScreen(w:Number,h:Number,backCallback:Function,timeSource:Function=null,randomSource:Function=null) {
            name="home-run-derby";screenW=w;screenH=h;fieldH=h-130;onBack=backCallback;
            rawClock=timeSource!=null?timeSource:getTimer;nextRandom=randomSource!=null?randomSource:Math.random;
            impactCues=new AudioCueSequence(clock);GameData.init();GameplayAudio.preload();hero=GameData.mainPlayer();
            stadium=new MatchStadium(w,fieldH);addChild(stadium);
            batter=new ClassicBatter(w*.270,fieldH*.875,uint(hero.accent),GameData.uniformNumber,String(hero.name),clock);batter.scaleX=batter.scaleY=1.24*fieldH/540;addChild(batter);
            pitcher=new Pitcher(w*.50,fieldH*.552,0xc44d45,"Derby Pitcher",clock);pitcher.scaleX=pitcher.scaleY=.54*fieldH/540;addChild(pitcher);
            ball=new Ball(480,258,clock,nextRandom);addChild(ball);impact=new ContactEffect(clock);addChild(impact);
            chrome.mouseEnabled=chrome.mouseChildren=false;hud.addChild(chrome);addChild(hud);drawHud();
            feedback.mouseEnabled=feedback.mouseChildren=false;feedback.x=w*.64;feedback.y=fieldH*.28;
            ClassicInventorySkin.gradient(feedback.graphics,-170,-27,340,60,0x145f94,0x0c385b,14);
            feedbackText=ClassicInventorySkin.text(feedback,"",-162,-19,324,44,28,0xffef8b,"center",true);feedback.visible=false;addChild(feedback);
            preparePitch();addEventListener(Event.ADDED_TO_STAGE,onAdded);addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);addEventListener(Event.ENTER_FRAME,onFrame);addEventListener(MouseEvent.MOUSE_DOWN,onFieldInput);
        }
        private function clock():int {return (paused?pausedAt:int(rawClock()))-pausedMillis;}
        private function text(value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,parent:Sprite=null):TextField {return ClassicInventorySkin.text(parent||hud,value,x,y,w,h,size,color,"center",size>=18);}
        private function button(value:String,id:String,x:Number,y:Number,w:Number,h:Number,handler:Function,color:uint=0x7caf30,parent:Sprite=null,list:Array=null):Sprite {
            var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,handler);(parent||hud).addChild(b);(list||controls).push({view:b,handler:handler});return b;
        }
        private function drawHud():void {
            ClassicInventorySkin.gradient(chrome.graphics,0,0,screenW,69,0x157cb8,0x08476f,0);
            logo=new AssetImage(VisualAssetRegistry.modeIconPath("home_run_derby"),148,51,AssetImage.CONTAIN);logo.x=8;logo.y=8;hud.addChild(logo);
            text("HOME RUN DERBY",159,5,288,32,20);text(String(hero.name),159,38,288,23,13,0xceefff);
            pitchText=text("",452,9,123,31,18);scoreText=text("",578,6,135,34,20,0xffe98c);distanceText=text("",452,42,262,21,11,0xcdeeff);
            pauseButton=button("II","derby-pause",745,15,45,35,onPauseClick,0x2479a4);
            button("MODES","derby-modes",802,15,143,35,onBackClick,0x416f8b);
            chrome.graphics.beginFill(0x0a3e62);chrome.graphics.drawRect(0,fieldH,screenW,screenH-fieldH);chrome.graphics.endFill();
            ClassicInventorySkin.panel(chrome.graphics,8,fieldH+3,screenW-16,119);
            statusText=text("",25,fieldH+5,575,36,21);statusText.name="derby-status";
            helpText=text("",25,fieldH+42,575,27,12,0xcdeeff);helpText.name="derby-help";
            primary=button("START PITCH","derby-primary",660,fieldH+15,275,40,onPrimaryClick);
            history.x=28;history.y=fieldH+76;hud.addChild(history);drawHistory();
        }
        private function drawHistory():void {
            while(history.numChildren)history.removeChildAt(0);history.graphics.clear();
            for(var i:int=0;i<TOTAL;i++) {
                var completed:Boolean=i<rows.length,active:Boolean=i==pitchNumber-1&&phase!=COMPLETE;
                var s:Sprite=new Sprite();s.name="derby-pitch-"+(i+1);s.x=i*91;history.addChild(s);
                s.graphics.lineStyle(active?2:1,active?0xa4ebff:0x406c88);ClassicInventorySkin.gradient(s.graphics,0,0,84,34,completed?(rows[i].hr?0x4b8c34:0x5b6b7a):0x14567e,completed?(rows[i].hr?0x245b28:0x344556):0x103956,5);
                text(String(i+1),2,7,18,21,12,0xd6edff,s);text(completed?(rows[i].hr?rows[i].feet+" FT":rows[i].label=="MISS"?"MISS":"OUT"):"--",22,6,59,23,12,completed&&rows[i].hr?0xfff29b:0xffffff,s);
            }
        }
        private function primaryLabel(value:String,enabled:Boolean=true):void {
            var t:TextField=primary.getChildAt(0) as TextField;if(t)t.text=value;
            primary.mouseEnabled=primary.buttonMode=enabled;primary.alpha=enabled?1:.55;
        }
        private function preparePitch():void {
            if(pitchNumber>TOTAL){finishDerby();return;}
            impactCues.cancelPending();impact.clear();phase=READY;swung=false;ball.hideBall();pitcher.resetReady();batter.resetReady();feedback.visible=false;
            statusText.text="READY";helpText.text="Clic en el campo o ESPACIO para iniciar; P para pausar.";primaryLabel("START PITCH");updateHud();drawHistory();
        }
        private function startPitch():void {
            if(dead||paused||phase!=READY)return;phase=WINDUP;swung=false;pitcher.throwPitch(.56);windupEnd=clock()+560;
            statusText.text="WINDUP";helpText.text="Observa la pelota: el siguiente clic o ESPACIO hace swing.";primaryLabel("WINDUP",false);
        }
        private function beginFlight():void {
            GameplayAudio.play(GameplayAudio.PITCH,.6);phase=FLIGHT;pitchStart=clock();pitchDuration=900+int(nextRandom()*330);
            var origin:Point=pitcher.releasePosition(),base:Point=batter.aimedContactPosition();
            contactY=base.y+(nextRandom()-.5)*18;
            var contact:Point=batter.aimedContactPosition(contactY),ease:Number=IDEAL*IDEAL*(3-2*IDEAL);
            flightX=origin.x;flightY=origin.y;
            // Ball's cubic path crosses the actual aimed contact pose at .84,
            // then continues beyond the bat for genuinely late swings.
            targetX=flightX+(contact.x-flightX)/ease;targetY=flightY+(contact.y-flightY)/ease;
            ball.reset(flightX,flightY);statusText.text="SWING";helpText.text="Batea cuando la pelota alcance el bat.";primaryLabel("SWING");updateFlight(clock());
        }
        private function updateFlight(now:int):Number {
            var t:Number=Math.max(0,Math.min(1,(now-pitchStart)/pitchDuration));batter.setPitchProgress(t);ball.setProgress(t,flightX,flightY,targetX,targetY,0,0);return t;
        }
        private function swing():void {
            if(dead||paused||phase!=FLIGHT||swung)return;swung=true;var t:Number=updateFlight(clock());batter.swing(contactY);GameplayAudio.play(GameplayAudio.SWING,.55);
            var error:Number=Math.abs(t-IDEAL),power:int=GameData.matchPower(hero),contact:int=GameData.matchContact(hero);
            var sweet:Number=.055+contact/2200.0,good:Number=.125+contact/1700.0;
            if(error<=sweet)recordHomeRun(true);
            else if(error<=good){if(nextRandom()<Math.min(.88,.30+power/180.0))recordHomeRun(false);else recordOut("DEEP FLY",true);}
            else recordOut(t<IDEAL?"TOO EARLY":"TOO LATE");
        }
        private function showFeedback(value:String,color:uint):void {feedbackText.text=value;feedbackText.textColor=color;feedbackAt=clock();feedback.visible=true;feedback.alpha=1;feedback.scaleX=feedback.scaleY=.9;}
        private function recordHomeRun(perfect:Boolean):void {
            phase=RESULT;homeRuns++;var power:int=GameData.matchPower(hero),feet:int=330+int(power*1.15)+int(nextRandom()*58)+(perfect?28:0);feet=Math.min(520,feet);
            totalDistance+=feet;if(feet>bestDistance)bestDistance=feet;rows.push({hr:true,feet:feet,label:perfect?"PERFECT":"GOOD"});
            batter.holdContact(130);var point:Point=batter.contactPosition(),lead:int=batter.contactDelay;ball.launchHit(perfect?"PERFECT":"GOOD",power,130,lead,point.x,point.y);impact.burst(point.x,point.y,perfect?"PERFECT":"GOOD",lead);impactCues.enqueue(GameplayAudio.HERO_HOME_RUN,lead);
            showFeedback("HOME RUN!",0xffe36a);statusText.text=feet+" FT";helpText.text=perfect?"¡Buen contacto! La pelota sale desde el bat.":"Home Run: la distancia se suma al total.";resultEnd=clock()+1150+SwingMotion.CONTACT_MS;primaryLabel("NEXT PITCH",false);updateHud();drawHistory();
        }
        private function recordOut(label:String,fair:Boolean=false):void {
            phase=RESULT;rows.push({hr:false,feet:0,label:label});
            if(fair){batter.holdContact(35);var point:Point=batter.contactPosition(),lead:int=batter.contactDelay;ball.launchHit("GOOD",GameData.matchPower(hero),35,lead,point.x,point.y);impact.burst(point.x,point.y,"GOOD",lead);impactCues.enqueue(GameplayAudio.HERO_HIT,lead);}
            else {ball.hideBall();GameplayAudio.play(GameplayAudio.STRIKE);}
            showFeedback(label,0xffb2a1);statusText.text=label;helpText.text=label=="TOO EARLY"?"Espera a que la pelota se acerque más al bat.":label=="TOO LATE"||label=="MISS"?"Haz swing un poco antes de que la pelota pase.":"Buen contacto, pero la pelota no salió del estadio.";
            resultEnd=clock()+850;primaryLabel("NEXT PITCH",false);updateHud();drawHistory();
        }
        private function updateHud():void {pitchText.text="PITCH "+Math.min(pitchNumber,TOTAL)+"/"+TOTAL;scoreText.text="HR "+homeRuns;distanceText.text="BEST "+bestDistance+" FT   TOTAL "+totalDistance+" FT";}
        private function finishDerby():void {
            if(dead||phase==COMPLETE||rewardApplied)return;phase=COMPLETE;rewardApplied=true;ball.hideBall();feedback.visible=false;
            var reward:int=homeRuns*300;if(reward>0){GameData.coins+=reward;GameData.save();}
            statusText.text="DERBY COMPLETE";helpText.text="Las diez pichadas están registradas abajo.";primaryLabel("COMPLETE",false);drawHistory();
            resultLayer=new Sprite();resultLayer.name="derby-result";resultLayer.graphics.beginFill(0x061526,.57);resultLayer.graphics.drawRect(0,69,screenW,fieldH-69);resultLayer.graphics.endFill();ClassicInventorySkin.panel(resultLayer.graphics,230,140,500,392);addChild(resultLayer);
            text("HOME RUN DERBY",249,155,462,46,28,0xffffff,resultLayer);text("ROUND COMPLETE",249,204,462,27,16,0xd2f0ff,resultLayer);
            text(String(homeRuns),253,247,190,68,46,0xffe77c,resultLayer);text("HOME RUNS",253,317,190,27,16,0xd2f0ff,resultLayer);
            text(bestDistance+" FT",468,249,235,48,30,0xffffff,resultLayer);text("BEST DISTANCE",468,299,235,24,12,0xd2f0ff,resultLayer);text("TOTAL "+totalDistance+" FT",468,331,235,32,18,0xffe77c,resultLayer);
            text("REWARD  +"+reward+" COINS",251,378,458,39,23,0xffe77c,resultLayer);text("El premio ya está aplicado. Volver o recargar no lo duplica.",253,422,454,37,12,0xd2f0ff,resultLayer);
            button("PLAY AGAIN","derby-replay",251,474,217,39,onReplayClick,0x7caf30,resultLayer,resultControls);button("MODES","derby-done",490,474,217,39,onBackClick,0x416f8b,resultLayer,resultControls);updateHud();
        }
        private function onReplayClick(e:MouseEvent):void {
            if(dead||phase!=COMPLETE)return;clearControls(resultControls);if(resultLayer.parent)resultLayer.parent.removeChild(resultLayer);resultLayer=null;
            pitchNumber=1;homeRuns=totalDistance=bestDistance=0;rows=[];rewardApplied=false;preparePitch();
        }
        private function onPauseClick(e:MouseEvent):void {setPaused(!paused);}
        private function syncActors():void {
            batter.dispatchEvent(new Event(Event.ENTER_FRAME));pitcher.dispatchEvent(new Event(Event.ENTER_FRAME));
            ball.dispatchEvent(new Event(Event.ENTER_FRAME));impact.dispatchEvent(new Event(Event.ENTER_FRAME));
        }
        private function setPaused(value:Boolean):void {
            if(dead||value==paused||phase==COMPLETE)return;
            if(value){pausedAt=int(rawClock());paused=true;if(phase==FLIGHT)updateFlight(clock());syncActors();pauseLayer=new Sprite();pauseLayer.name="derby-paused";pauseLayer.graphics.beginFill(0x061526,.68);pauseLayer.graphics.drawRect(0,69,screenW,screenH-69);pauseLayer.graphics.endFill();ClassicInventorySkin.panel(pauseLayer.graphics,258,218,444,263);addChild(pauseLayer);
                text("PAUSED",277,232,406,50,28,0xffffff,pauseLayer);text("La pichada, los personajes y la pelota están detenidos.\nPulsa P, ESPACIO o RESUME para continuar.",277,294,406,68,14,0xd2f0ff,pauseLayer);
                button("RESUME","derby-resume",277,399,190,40,onPauseClick,0x7caf30,pauseLayer,pauseControls);button("MODES","derby-quit",490,399,190,40,onBackClick,0x416f8b,pauseLayer,pauseControls);
            }else {pausedMillis+=int(rawClock())-pausedAt;paused=false;clearControls(pauseControls);if(pauseLayer&&pauseLayer.parent)pauseLayer.parent.removeChild(pauseLayer);pauseLayer=null;}
        }
        private function onFrame(e:Event):void {
            if(dead||paused)return;var now:int=clock();
            if(feedback.visible){var p:Number=(now-feedbackAt)/1150;feedback.scaleX=feedback.scaleY=.9+.1*Math.min(1,p*7);feedback.alpha=p>.75?Math.max(0,(1-p)*4):1;}
            if(phase==WINDUP&&now>=windupEnd){beginFlight();return;}
            if(phase==FLIGHT){if(updateFlight(now)>=1&&!swung)recordOut("MISS");return;}
            if(phase==RESULT&&now>=resultEnd){pitchNumber++;preparePitch();}
        }
        private function primaryInput():void {if(dead||paused)return;if(phase==READY)startPitch();else if(phase==FLIGHT)swing();}
        private function onPrimaryClick(e:MouseEvent):void {e.stopPropagation();primaryInput();}
        private function onFieldInput(e:MouseEvent):void {if(dead||paused||phase==COMPLETE)return;var point:Point=globalToLocal(new Point(e.stageX,e.stageY));if(point.y<75||point.y>=fieldH)return;primaryInput();}
        private function onKeyDown(e:KeyboardEvent):void {
            if(e.keyCode!=80&&e.keyCode!=Keyboard.SPACE)return;
            e.preventDefault();if(heldKeys[e.keyCode])return;heldKeys[e.keyCode]=true;
            if(e.keyCode==80){setPaused(!paused);return;}
            if(paused){setPaused(false);return;}
            primaryInput();
        }
        private function onKeyUp(e:KeyboardEvent):void {delete heldKeys[e.keyCode];}
        private function onDeactivate(e:Event):void {heldKeys={};if(phase==WINDUP||phase==FLIGHT||phase==RESULT)setPaused(true);}
        private function onAdded(e:Event):void {boundStage=stage;if(boundStage){boundStage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);boundStage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);boundStage.addEventListener(Event.DEACTIVATE,onDeactivate);}}
        private function onRemoved(e:Event):void {unbind();}
        private function unbind():void {if(boundStage){boundStage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);boundStage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);boundStage.removeEventListener(Event.DEACTIVATE,onDeactivate);boundStage=null;}heldKeys={};}
        private function onBackClick(e:MouseEvent):void {e.stopPropagation();if(!dead&&onBack!=null)onBack();}
        private function clearControls(list:Array):void {for each(var c:Object in list)c.view.removeEventListener(MouseEvent.CLICK,c.handler);list.length=0;}
        public function dispose():void {if(dead)return;dead=true;impactCues.dispose();unbind();removeEventListener(Event.ENTER_FRAME,onFrame);removeEventListener(Event.ADDED_TO_STAGE,onAdded);removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);removeEventListener(MouseEvent.MOUSE_DOWN,onFieldInput);clearControls(controls);clearControls(resultControls);clearControls(pauseControls);batter.dispose();pitcher.dispose();ball.dispose();impact.dispose();stadium.dispose();logo.dispose();}
    }
}
