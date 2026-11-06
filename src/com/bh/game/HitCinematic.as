package com.bh.game {
    import flash.display.Sprite;
    import flash.display.Shape;
    import com.bh.audio.OriginalAudioBank;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.utils.getTimer;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import com.bh.visual.HitFlightBackdrop;import com.bh.visual.BallFlightTrail;
    import com.bh.visual.CelebrationArtwork;
    import com.bh.visual.HomeRunStory;
    import com.bh.visual.RunnerSprite;
    import com.bh.audio.GameplayAudio;
    import com.bh.audio.AudioCueSequence;
    import com.bh.audio.AudioManager;
    import flash.media.SoundChannel;
    import com.bh.ui.LineupTypography;
    import com.bh.model.GameData;

    public class HitCinematic extends Sprite {
        private var story:HomeRunStory;private var outScene:com.bh.visual.OutSplitScene;
        private var multiplier:int=1,earned:int=0;
        private var hitStreak:int=0,hrStreak:int=0,streakText:TextField;
        private var cinematicAudio:AudioCueSequence;
        private var resultSoundPlayed:Boolean=false,bouncePlayed:Boolean=false;
        private var targetArt:Sprite=new Sprite();
        private var screenW:Number;
        private var screenH:Number;
        private var scene:Sprite;
        private var ball:Sprite;
        private var resultText:TextField;
        private var subText:TextField;
        private var frame:Number = 0;
        private var startedAt:int=0;
        private var frameOffset:Number=0;
        private var clock:Function;
        private var trackingTrail:BallFlightTrail=new BallFlightTrail(),flightBackdrop:HitFlightBackdrop;
        private var distanceText:TextField;
        private var cinematicFielder:Pitcher;
        private var runningHero:RunnerSprite;
        private var resultHero:ClassicBatter;
        private var result:String = "";
        private var rbi:int = 0;
        private var distance:int = 0;
        private var celebrationAsset:CelebrationArtwork;
        private var artW:Number;
        private var artH:Number;
        private var artY:Number;
        private var continueText:TextField;
        private var readyToContinue:Boolean = false;
        private var celebrationStartFrame:Number = -1;
        private var wordStamp:com.bh.visual.ComicResultWords;
        private var handoff:Object;
        private var exitShade:Shape=new Shape(),exitAt:int=-1,resultSoundUntil:int=0;

        public function HitCinematic(w:Number, h:Number,timeSource:Function=null,defenseColor:uint=0xd84f42,defenderIdentity:Object=null) {
            super();
            clock=timeSource!=null?timeSource:getTimer;cinematicAudio=new AudioCueSequence(clock);
            screenW = w;
            screenH = h;
            artW=Math.min(720,w*.78);artH=h*.40;artY=h*.13;
            CelebrationArtwork.warm();
            mouseEnabled = false;
            mouseChildren = false;

            scene = new Sprite();
            scene.name="cinematic-scene";
            scene.y=38;scene.scrollRect=new Rectangle(0,38,w,h-94);
            addChild(scene);
            flightBackdrop=new HitFlightBackdrop(w,h,clock);scene.addChild(flightBackdrop);
            story=new HomeRunStory(w,h);addChild(story);
            targetArt.mouseEnabled=targetArt.mouseChildren=false;scene.addChild(targetArt);
            cinematicFielder=new Pitcher(w*.59,h*.58,defenseColor,defenderIdentity?String(defenderIdentity.name):'Cinematic Fielder',clock,true,defenderIdentity);
            cinematicFielder.scaleX=cinematicFielder.scaleY=.85;cinematicFielder.setFieldingMode(true);
            cinematicFielder.visible=false;scene.addChild(cinematicFielder);
            runningHero=new RunnerSprite(GameData.mainPlayer());runningHero.warmAll();runningHero.scaleX=runningHero.scaleY=.55;runningHero.visible=false;scene.addChild(runningHero);
            resultHero=new ClassicBatter(w*.50,h*.86,uint(GameData.mainPlayer().accent),GameData.uniformNumber,String(GameData.mainPlayer().name),clock);
            resultHero.scaleX=resultHero.scaleY=1.05*h/540;resultHero.visible=false;scene.addChild(resultHero);
            outScene=new com.bh.visual.OutSplitScene(w,h,defenseColor,defenderIdentity);addChild(outScene);addChild(trackingTrail);

            ball = new Sprite();
            ball.name="cinematic-ball";
            drawBall();
            addChild(ball);
            distanceText=makeText('',15,0xffffff,130,30);
            distanceText.x=w-160;distanceText.y=164;
            distanceText.filters=[new GlowFilter(0x142b24,1,3,3,5)];
            addChild(distanceText);

            resultText = makeText("", 56, 0xffffff, 720, 92);
            resultText.name="cinematic-result";
            resultText.x = screenW / 2 - 360;
            resultText.y = screenH*.36;
            resultText.filters = [
                new GlowFilter(0x000000, 0.92, 8, 8, 5, 1),
                new DropShadowFilter(7, 45, 0x000000, 0.70, 5, 5, 2)
            ];
            addChild(resultText);

            subText = makeText("", 25, 0xffef76, 440, 44);
            subText.name="cinematic-detail";
            subText.x = screenW / 2 - 220;
            subText.y = screenH*.36+86;
            subText.filters = [
                new GlowFilter(0x000000, 0.8, 4, 4, 3, 1)
            ];
            addChild(subText);

            streakText=makeText("",24,0xffed57,w-60,42);streakText.name="cinematic-streak";streakText.x=30;streakText.y=88;streakText.filters=[new GlowFilter(0x123e66,1,5,5,4)];addChild(streakText);

            continueText = makeText(
                "",
                13,
                0xffffff,
                260,
                28
            );
            continueText.x = screenW / 2 - 130;
            continueText.y = screenH - 78;
            continueText.visible = false;
            continueText.filters = [
                new GlowFilter(0x000000, 0.85, 4, 4, 2, 1)
            ];
            addChild(continueText);

            exitShade.name="match-scene-fade";exitShade.graphics.beginFill(0);exitShade.graphics.drawRect(0,38,w,h-38);exitShade.graphics.endFill();exitShade.alpha=0;addChild(exitShade);
            visible = false;
        }

        private function drawBall():void {
            BaseballArt.draw(ball.graphics,31);
        }

        public function setPoints(points:int,multiple:int,hits:int=0,hrs:int=0):void {earned=points;multiplier=multiple;hitStreak=hits;hrStreak=hrs;}
        public function play(value:String, runBattedIn:int = 0, feet:int = 0,contactBall:Object=null,flightAlreadyStarted:Boolean=false):void {
            clear();handoff=contactBall;
            result = value;resultSoundPlayed=bouncePlayed=false;
            rbi = runBattedIn;
            distance = feet;
            frame = 0;
            frameOffset=0;startedAt=int(clock());
            readyToContinue = false;
            celebrationStartFrame = -1;
            story.stop();targetArt.graphics.clear();
            scene.visible=true;resultText.rotation=0;resultText.scaleX=resultText.scaleY=1;
            visible = true;
            continueText.visible = false;
            resultText.text = "";
            subText.text = "";
            resultText.y = screenH*.36;
            subText.y = screenH*.36+86;

            streakText.text=hrStreak>=2?hrStreak+" CONSECUTIVE HOME RUNS  ·  ×"+multiplier:hitStreak>=2?hitStreak+" CONSECUTIVE HITS"+(multiplier>1?"  ·  ×"+multiplier:""):"";

            if (isOutResult()) {
                drawOutfieldScene();
                ball.visible = true;
            }
            else {
                drawTrackingScene(0);
                ball.visible = true;
                ball.x = screenW * 0.62;
                ball.y = screenH * 0.63;
                ball.scaleX = ball.scaleY = 1.15;
                ball.rotation = 0;
            }

            if(result=="HOME RUN"){flightBackdrop.hide();trackingTrail.hide();story.begin();}
            if(!isOutResult()&&!flightAlreadyStarted)cinematicAudio.enqueue(result=="HOME RUN"&&rbi>=4?"grand_slam_story.mp3":"hit_flight.mp3",0,.60);
            if(result=="STRIKE OUT"){drawStrikeOut();}
            if(result=="DOUBLE"||result=="TRIPLE"){drawTrackingScene(0);ball.visible=true;}
            if(handoff){ball.x=Number(handoff.x);ball.y=Number(handoff.y);ball.scaleX=ball.scaleY=Number(handoff.scale)/3.44;ball.rotation=Number(handoff.rotation);}
            addEventListener(Event.ENTER_FRAME, onFrame);
        }

        private function onFrame(e:Event):void {
            cinematicAudio.advance();
            if(exitAt>=0){exitShade.alpha=Math.min(1,Math.max(0,(int(clock())-exitAt)/260));if(int(clock())-exitAt>=320){readyToContinue=true;removeEventListener(Event.ENTER_FRAME,onFrame);}return;}
            var previous:Number=frame;
            frame=frameOffset+Math.max(0,int(clock())-startedAt)*30/1000;

            // A third strike has no batted ball to chase or throw from the outfield.
            if(result=="STRIKE OUT"){
                outScene.stop();
                if(frame>=62)showContinuePrompt();
                if(frame>=92){readyToContinue=true;removeEventListener(Event.ENTER_FRAME,onFrame);}
                return;
            }

            if(result=="DOUBLE"||result=="TRIPLE"){
                // Latest supplied video: sky tracking, then a missed diving attempt.
                // Keep the result/fanfare at frame76; only the camera coverage changes.
                scene.visible=true;
                if(frame<44){
                    var tracked:Number=frame/44;
                    ball.visible=true;placeTrackedBall(screenW*(.62-tracked*.16),screenH*.63-Math.sin(tracked*Math.PI*.79)*180,2.1-tracked*1.8);drawTrackingScene(tracked);
                    ball.rotation=frame*30;return;
                }
                if(frame<76){
                    if(previous<44)drawOutfieldScene();trackingTrail.hide();distanceText.text='';
                    var attempt:Number=Math.max(0,Math.min(1,(frame-44)/32));
                    cinematicFielder.visible=true;cinematicFielder.x=screenW*(.69-attempt*.15);cinematicFielder.y=screenH*(.65-Math.sin(attempt*Math.PI)*.035);cinematicFielder.fieldAttempt(attempt);
                    flightBackdrop.fielding(cinematicFielder.x,cinematicFielder.y,cinematicFielder.scaleX);
                    var endX:Number=result=="TRIPLE"?.36:.43;
                    placeTrackedBall(screenW*(.82+(endX-.82)*attempt),screenH*(.14+attempt*attempt*.60),.85-attempt*.57);ball.visible=true;ball.rotation=frame*30;return;
                }
                if(previous<76)drawComicResult();
                animateCelebrationAsset();
                if(previous<178&&frame>=178)drawWordResult();
                if(frame>=232)showContinuePrompt();
                if(frame>=262){readyToContinue=true;removeEventListener(Event.ENTER_FRAME,onFrame);}
                return;
            }
            if(result=="HOME RUN"){
                var storyEnd:int=rbi>=4?160:110;if(frame<storyEnd){story.at(frame*110/storyEnd*1000/30);ball.visible=false;return;}
                if(previous<storyEnd){story.stop();drawComicResult();}
                if(frame>=storyEnd+38)showContinuePrompt();
                if(frame>=storyEnd+72){readyToContinue=true;removeEventListener(Event.ENTER_FRAME,onFrame);}
                animateCelebrationAsset();return;
            }
            if(frame>29&&frame<48&&!isOutResult()){
                var runP:Number=Math.min(1,(frame-29)/15),runEase:Number=1-Math.pow(1-runP,1.7);
                runningHero.visible=true;if(frame<44)runningHero.runAt((frame-29)*1000/30);else runningHero.arrive((frame-44)*1000/30,result=="DOUBLE"||result=="TRIPLE");
                runningHero.x=screenW*(.20+runEase*.42);runningHero.y=screenH*(.86-runEase*.06);
                var travel:Number=Math.min(1,(frame-29)/10);cinematicFielder.x=screenW*(.70-travel*.17);cinematicFielder.y=screenH*(.66-travel*.03);
                if(frame<39){cinematicFielder.fieldMotion(travel);var catchPoint:Point=cinematicFielder.fieldAnchor();ball.visible=true;ball.x=screenW*.8+(catchPoint.x-screenW*.8)*travel;ball.y=screenH*.39+(catchPoint.y-screenH*.39)*travel;ball.scaleX=ball.scaleY=.24;}
                else drawReturnThrow((frame-39)/9);
                flightBackdrop.fielding(cinematicFielder.x,cinematicFielder.y,cinematicFielder.scaleX);
            }
            if (isOutResult()) {
                if(frame<25){var chase:Number=frame/25;cinematicFielder.x=screenW*(.72-chase*.13);cinematicFielder.fieldMotion(chase,result=="FLY OUT");var glovePoint:Point=cinematicFielder.fieldAnchor();ball.visible=true;ball.x=screenW*.84+(glovePoint.x-screenW*.84)*chase;ball.y=result=="GROUND OUT"?screenH*.58+(glovePoint.y-screenH*.58)*chase-Math.abs(Math.sin(chase*Math.PI*3))*25*(1-chase):screenH*.20+chase*chase*(glovePoint.y-screenH*.20);placeTrackedBall(ball.x,ball.y,.28);ball.rotation=frame*25;}
                if(frame<43)flightBackdrop.fielding(cinematicFielder.x,cinematicFielder.y,cinematicFielder.scaleX);
                if (previous<25&&frame>=25){ball.visible=false;drawComedyCatch();cinematicAudio.enqueue(GameplayAudio.CATCH,0,.45);}
                if(frame>=25&&frame<43){if(result=="FLY OUT"){cinematicFielder.fieldMotion(1,true);ball.visible=false;}else drawReturnThrow((frame-25)/18);}
                if (previous<43&&frame>=43) drawComicResult();
                if(frame>=43)outScene.at((frame-43)*1000/30);
                if (previous<62&&frame>=62) showContinuePrompt();
                if (frame >= 92) {
                    readyToContinue = true;
                    removeEventListener(Event.ENTER_FRAME, onFrame);
                }
                animateCelebrationAsset();return;
            }

            if (frame <= 28) {
                var p:Number = frame / 28.0;
                ball.x = screenW * 0.62 - p * screenW * 0.16;
                ball.y = screenH * 0.63 - Math.sin(p * Math.PI * 0.79) * 180;
                var scale:Number = 1.15-p*.85;
                placeTrackedBall(ball.x,ball.y,scale);
                ball.rotation = frame*30;
                drawTrackingScene(p);
            }
            if (previous<29&&frame>=29) {
                trackingTrail.hide();distanceText.text='';
                drawOutfieldScene();
                ball.visible = false;
            }
            if (previous<48&&frame>=48) {
                drawComicResult();
            }
            if (previous<76&&frame>=76) {
                showContinuePrompt();
            }
            if (frame >= 112) {
                readyToContinue = true;
                removeEventListener(Event.ENTER_FRAME, onFrame);
            }
            animateCelebrationAsset();
        }

        private function placeTrackedBall(px:Number,py:Number,size:Number):void {
            var blend:Number=Math.max(0,Math.min(1,frame/5.4));blend=blend*blend*(3-2*blend);
            ball.x=handoff?Number(handoff.x)+(px-Number(handoff.x))*blend:px;
            ball.y=handoff?Number(handoff.y)+(py-Number(handoff.y))*blend:py;
            ball.scaleX=ball.scaleY=handoff?Number(handoff.scale)/3.44+(size-Number(handoff.scale)/3.44)*blend:size;
        }
        private function drawStrikeOut():void {
            drawComicResult();outScene.stop();ball.visible=false;
            resultHero.visible=true;resultHero.queueReaction("STRIKE OUT");
            resultText.text="STRIKE OUT";resultText.y=screenH*.27;subText.y=screenH*.27+85;
        }
        private function drawReturnThrow(progress:Number):void {
            cinematicFielder.fieldThrow(.5);var hand:Point=cinematicFielder.fieldAnchor(true);cinematicFielder.fieldThrow(progress);
            var flight:Number=Math.max(0,Math.min(1,(progress-.5)/.5));ball.visible=progress>=.5;
            ball.x=hand.x+(screenW*.88-hand.x)*flight;ball.y=hand.y+(screenH*.77-hand.y)*flight-Math.sin(flight*Math.PI)*25;
            ball.scaleX=ball.scaleY=.22+flight*.12;ball.rotation=progress*700;ball.visible=progress>=.5&&flight<1;
        }

        private function drawWordResult():void {
            flightBackdrop.hide();trackingTrail.hide();
            playBounce();
            if(celebrationAsset)celebrationAsset.visible=false;targetArt.graphics.clear();
            scene.graphics.clear();var m:Matrix=new Matrix();m.createGradientBox(screenW,screenH,Math.PI/2);
            scene.graphics.beginGradientFill('linear',[0x0e622e,0x12813c],[1,1],[0,255],m);scene.graphics.drawRect(0,38,screenW,screenH-94);scene.graphics.endFill();
            resultText.visible=false;
            if(wordStamp&&wordStamp.parent)wordStamp.parent.removeChild(wordStamp);
            wordStamp=new com.bh.visual.ComicResultWords(result=="DOUBLE"?"TWO\nBASE HIT":"THREE\nBASE HIT");
            wordStamp.x=screenW*.08;wordStamp.y=screenH*.29;wordStamp.rotation=-8;wordStamp.scaleX=wordStamp.scaleY=1.12;addChild(wordStamp);
            subText.y=screenH*.74;
        }

        private function playBounce():void {if(bouncePlayed)return;bouncePlayed=true;cinematicAudio.enqueue("ball_bounce.mp3",0,.60);}

        private function isOutResult():Boolean {
            return result == "FLY OUT" ||
                   result == "GROUND OUT" ||
                   result == "STRIKE OUT";
        }

        private function drawTrackingScene(progress:Number):void {
            // Follow the same trajectory with a retained camera over the equipped stadium.
            flightBackdrop.track(progress,ball.x,ball.y);
            trackingTrail.follow(ball.x,ball.y,-screenW*.16,-180*Math.PI*.79*Math.cos(progress*Math.PI*.79),progress);
            distanceText.text=distance>0?String(int(distance*(.35+progress*.65)))+' FT':'';
        }
        private function drawOutfieldScene():void {
            cinematicFielder.visible=true;cinematicFielder.setFieldingMode(true);
            cinematicFielder.x=screenW*(result=='SINGLE'?.70:result=='DOUBLE'||result=='TRIPLE'?.69:.72);cinematicFielder.y=screenH*(result=='SINGLE'?.66:result=='DOUBLE'||result=='TRIPLE'?.65:.62);
            cinematicFielder.scaleX=cinematicFielder.scaleY=.85*screenH/540;
            scene.graphics.clear();flightBackdrop.fielding(cinematicFielder.x,cinematicFielder.y,cinematicFielder.scaleX);
        }
        private function drawComedyCatch():void {
            // Keep the chased position and camera; resetting here teleported the glove.
            cinematicFielder.fieldMotion(1,result=="FLY OUT");
            cinematicFielder.reactSuccess();
            var catchPoint:Point=cinematicFielder.fieldAnchor();
            var catchX:Number=catchPoint.x;var catchY:Number=catchPoint.y;

            scene.graphics.beginFill(0xffffff, 0.90);
            scene.graphics.drawCircle(catchX,catchY,8);
            scene.graphics.endFill();

            scene.graphics.lineStyle(4, 0xffffff, 0.65);
            for (var i:int = 0; i < 8; i++) {
                var a:Number = Math.PI * 2 * i / 8;
                scene.graphics.moveTo(
                    catchX + Math.cos(a) * 13,
                    catchY + Math.sin(a) * 13
                );
                scene.graphics.lineTo(
                    catchX + Math.cos(a) * 34,
                    catchY + Math.sin(a) * 34
                );
            }
            scene.graphics.lineStyle();
        }

        private function drawComicResult():void {
            flightBackdrop.hide();trackingTrail.hide();
            if(celebrationAsset){celebrationAsset.dispose();if(celebrationAsset.parent)celebrationAsset.parent.removeChild(celebrationAsset);celebrationAsset=null;}
            cinematicFielder.visible=false;runningHero.visible=false;
            targetArt.graphics.clear();targetArt.visible=!isOutResult();
            resultHero.visible=false;
            ball.visible=false;trackingTrail.hide();distanceText.text='';
            scene.graphics.clear();

            var back:uint = 0x1e75ad;
            var main:uint = 0xbff02f;

            if (result == "HOME RUN") {
                back = rbi >= 4 ? 0xd55235 : 0x159ccc;
                main = 0xffd12f;
            }
            else if (isOutResult()) {
                back = 0x21482e;
                main = 0xff5b62;
            }
            else if (result == "TRIPLE") {
                back = 0x6c49a0;
                main = 0xffef65;
            }
            else if (result == "DOUBLE") {
                back = 0x227da3;
                main = 0x8ff2ff;
            }

            scene.graphics.beginFill(back);
            scene.graphics.drawRect(0, 38, screenW, screenH - 94);
            scene.graphics.endFill();

            // Comic radial burst.
            var cx:Number = screenW / 2;
            var cy:Number = screenH * 0.47;
            for (var i:int = 0; i < 34; i++) {
                var angle:Number = Math.PI * 2 * i / 34;
                var inner:Number = 120 + (i % 2) * 17;
                var outer:Number = 410 + (i % 4) * 22;
                scene.graphics.lineStyle(i % 3 == 0 ? 5 : 2, 0xffffff, i % 3 == 0 ? 0.42 : 0.22);
                scene.graphics.moveTo(
                    cx + Math.cos(angle) * inner,
                    cy + Math.sin(angle) * inner
                );
                scene.graphics.lineTo(
                    cx + Math.cos(angle) * outer,
                    cy + Math.sin(angle) * outer
                );
            }
            scene.graphics.lineStyle();

            scene.graphics.beginFill(0xffffff, 0.10);
            scene.graphics.drawEllipse(cx - 250, cy - 100, 500, 200);
            scene.graphics.endFill();

            // Complete original artwork is embedded and shared. Preparing it
            // before play avoids network requests and repeated decoding at hits.
            var celebrationIndex:int = 0;

            if (result == "DOUBLE") {
                celebrationIndex = 2;
            }
            else if (result == "TRIPLE") {
                celebrationIndex = 3;
            }
            else if (result == "HOME RUN") {
                celebrationIndex =
                    rbi >= 4
                    ? 1
                    : 4;
            }

            if (celebrationIndex > 0) {
                celebrationAsset =
                    new CelebrationArtwork(celebrationIndex,artW,artH);

                celebrationAsset.alpha = 0;
                celebrationAsset.scaleX =
                    celebrationAsset.scaleY =
                    0.90;

                celebrationAsset.x =
                    screenW / 2 -
                    artW * .5 * 0.90;

                celebrationAsset.y = artY;
                celebrationStartFrame = frame;

                scene.addChild(
                    celebrationAsset
                );

                resultText.y = screenH*.56;
                subText.y = screenH*.56+78;
            }
            else {
                resultText.y=screenH*.27;subText.y=screenH*.27+85;
                if(isOutResult()){
                    cinematicFielder.visible=true;cinematicFielder.x=screenW*.50;cinematicFielder.y=screenH*.72;
                    cinematicFielder.scaleX=cinematicFielder.scaleY=1.10*screenH/540;cinematicFielder.reactSuccess();
                }else{resultHero.visible=true;resultHero.queueReaction('HIT');}
            }

            var label:String = result;
            if (result == "SINGLE") label = "ONE BASE HIT";
            else if (result == "DOUBLE") label = "TWO BASE HIT";
            else if (result == "TRIPLE") label = "THREE BASE HIT";
            else if (result == "HOME RUN" && rbi >= 4) label = "GRAND SLAM";

            if(!isOutResult()){
                var tg:*=targetArt.graphics;
                for(var target:int=0;target<3;target++){var tx:Number=screenW*(.2+target*.3),ty:Number=screenH*(target%2?.55:.43);tg.lineStyle(8,0xffffff);tg.beginFill(0xed374e);tg.drawCircle(tx,ty,68);tg.endFill();tg.lineStyle(15,0xffffff);tg.drawCircle(tx,ty,40);tg.lineStyle(10,0xf04457);tg.drawCircle(tx,ty,13);}
                tg.lineStyle(16,0x163e66);tg.moveTo(100,screenH*.72);tg.lineTo(screenW*.42,screenH*.58);tg.lineTo(screenW*.73,screenH*.38);tg.lineStyle();

            }
            if(isOutResult()){cinematicFielder.visible=false;outScene.begin(result);outScene.at(0);label="OUT!";resultText.visible=result=="STRIKE OUT";resultText.y=screenH*.48;subText.y=screenH*.77;}
            if(!resultSoundPlayed){
                resultSoundPlayed=true;cinematicAudio.stopAll();
                if(result=="SINGLE"){cinematicAudio.enqueue(GameplayAudio.RESULT_SINGLE,0,.6);playBounce();}
                else if(result=="DOUBLE")cinematicAudio.enqueue(GameplayAudio.RESULT_DOUBLE,0,.6);
                else if(result=="TRIPLE")cinematicAudio.enqueue(GameplayAudio.RESULT_TRIPLE,0,.6);
                else if(result=="HOME RUN")cinematicAudio.enqueue(rbi>=4?"grand_slam.mp3":"home_run.mp3",0,.9);
                else if(result!="STRIKE OUT")cinematicAudio.enqueue("out_result.mp3",0,.65);
                var cue:String=result=="HOME RUN"?(rbi>=4?"grand_slam":"home_run"):isOutResult()?"out_result":"";
                resultSoundUntil=int(clock())+Math.ceil(cue?OriginalAudioBank.sound(cue).length:GameplayAudio.duration(result=="DOUBLE"?GameplayAudio.RESULT_DOUBLE:result=="TRIPLE"?GameplayAudio.RESULT_TRIPLE:GameplayAudio.RESULT_SINGLE));
            }
            resultText.text = label;
            resultText.textColor = main;
            if(earned>0)subText.text="+"+earned+" POINTS"+(multiplier>1?" · ×"+multiplier:"");

            if (distance > 0 && result == "HOME RUN") {
                subText.text = distance + " FT" + (rbi > 0 ? "   +" + rbi + " RUN" + (rbi == 1 ? "" : "S") : "");
            }
            else if (rbi > 0) {
                subText.text = "+" + rbi + (rbi == 1 ? " RUN" : " RUNS");
            }
            else {
                subText.text = "";
            }
        }

        private function animateCelebrationAsset():void {
            if(earned>0&&resultText.text!=""&&subText.text.indexOf("POINTS")<0)subText.appendText("  ·  +"+earned+" POINTS"+(multiplier>1?" ×"+multiplier:"") );
            if (
                !celebrationAsset ||
                celebrationStartFrame < 0
            ) {
                return;
            }

            var progress:Number =
                Math.min(
                    1,
                    Math.max(
                        0,
                        (frame - celebrationStartFrame) /
                        12.0
                    )
                );

            var eased:Number =
                1 -
                Math.pow(
                    1 - progress,
                    3
                );

            var scale:Number =
                0.90 +
                eased * 0.10;

            celebrationAsset.alpha =
                eased;

            celebrationAsset.scaleX =
                celebrationAsset.scaleY =
                scale;

            celebrationAsset.x =
                screenW / 2 -
                artW * .5 * scale;

            celebrationAsset.y =
                artY -
                eased * 12;
        }

        private function showContinuePrompt():void {
            // The original flow feels automatic: the result beat finishes and
            // the next play continues on its own. Keep the same ready state,
            // but do not ask the user to press ENTER.
            readyToContinue = true;
            continueText.visible = false;
        }

        public function canContinue():Boolean {
            return !visible || readyToContinue&&int(clock())>=resultSoundUntil;
        }

        public function isPlaying():Boolean {
            return visible && !readyToContinue;
        }

        public function closeForHandoff():Boolean {if(!visible)return true;if(exitAt<0){exitAt=int(clock());setChildIndex(exitShade,numChildren-1);exitShade.alpha=0;readyToContinue=false;addEventListener(Event.ENTER_FRAME,onFrame);return false;}return int(clock())-exitAt>=320;}

        public function forceResultVisible():void {
            if (!visible||exitAt>=0) return;

            if(result=="DOUBLE"||result=="TRIPLE"){
                if(frame>=202)return;
                frame=202;frameOffset=frame;startedAt=int(clock());scene.visible=true;
                drawComicResult();drawWordResult();readyToContinue=false;return;
            }

            // Optional ENTER fast-forward remains available, but normal
            // gameplay now continues automatically after the result beat.
            // The player never needs ENTER to advance.
            if(result=="HOME RUN"&&frame<(rbi>=4?160:110)){
                story.stop();frame=rbi>=4?160:110;frameOffset=frame;startedAt=int(clock());drawComicResult();
            }
            else if (frame < 48 && !isOutResult()) {
                frame = 48;
                frameOffset=frame;startedAt=int(clock());
                drawComicResult();
            }
            else if (frame < 43 && isOutResult()) {
                frame = 43;
                frameOffset=frame;startedAt=int(clock());
                if(result=="STRIKE OUT")drawStrikeOut();else drawComicResult();
            }
            else return;

            readyToContinue = false;
            continueText.visible = false;
        }

        public function clear():void {
            exitAt=-1;resultSoundUntil=0;exitShade.alpha=0;
            if(wordStamp&&wordStamp.parent)wordStamp.parent.removeChild(wordStamp);wordStamp=null;resultText.visible=true;
            outScene.stop();
            cinematicAudio.stopAll();flightBackdrop.hide();trackingTrail.hide();
            removeEventListener(Event.ENTER_FRAME, onFrame);
            cinematicFielder.visible=false;runningHero.visible=false;
            targetArt.graphics.clear();targetArt.visible=!isOutResult();
            resultHero.visible=false;
            trackingTrail.hide();distanceText.text='';

            if (celebrationAsset) {
                celebrationAsset.dispose();

                if (celebrationAsset.parent) {
                    celebrationAsset.parent.removeChild(
                        celebrationAsset
                    );
                }

                celebrationAsset = null;
            }

            handoff=null;visible = false;
            readyToContinue = false;
            celebrationStartFrame = -1;
            story.stop();targetArt.graphics.clear();
            continueText.visible = false;
            resultText.text = "";
            resultText.rotation=0;resultText.scaleX=resultText.scaleY=1;resultText.height=92;resultText.x=screenW/2-360;
            subText.text = "";
            resultText.y = screenH*.36;
            subText.y = screenH*.36+86;
            streakText.text="";
            scene.graphics.clear();
            ball.visible = false;
        }

        private function makeText(
            text:String,
            size:int,
            color:uint,
            w:Number,
            h:Number
        ):TextField {
            var t:TextField = new TextField();
            var f:TextFormat = new TextFormat("Arial", size, color, true);
            f.align = TextFormatAlign.CENTER;
            t.defaultTextFormat = f;
            t.text = text;
            t.width = w;
            t.height = h;
            t.selectable = false;
            t.mouseEnabled = false;
            LineupTypography.apply(t,size,color,TextFormatAlign.CENTER,size>=40);
            return t;
        }

        public function dispose():void {
            cinematicAudio.dispose();
            clear();
            story.dispose();outScene.dispose();flightBackdrop.dispose();trackingTrail.dispose();
            cinematicFielder.dispose();runningHero.dispose();
            resultHero.dispose();
        }
    }
}


