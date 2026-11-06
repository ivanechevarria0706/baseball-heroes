package com.bh.core {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import flash.utils.getTimer;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;

    import com.bh.game.Ball;
    import com.bh.game.SpecialAbilityResolver;
    import com.bh.game.ClassicBatter;
    import com.bh.game.BattingSystem;
    import com.bh.game.Pitcher;
    import com.bh.game.BattingCursor;
    import com.bh.game.StrikeZone;
    import com.bh.game.ContactEffect;
    import com.bh.game.HitCinematic;
    import com.bh.game.GameplayCallout;
    import com.bh.audio.AudioManager;
    import com.bh.audio.GameplayAudio;
    import com.bh.audio.AudioCueSequence;
    import com.bh.game.SwingMotion;
    import com.bh.model.Player;
    import com.bh.model.GameData;
    import com.bh.model.MatchRosterIdentity;
    import com.bh.model.MatchScoring;
    import com.bh.model.MatchMomentum;
    import com.bh.model.CareerAchievements;
    import com.bh.ui.MatchFeedback;import com.bh.game.PitchCadence;
    import com.bh.ui.MatchVictory;
    import com.bh.visual.RunnerSprite;
    import com.bh.model.MatchBoxScore;
    import com.bh.ui.Hud;
    import com.bh.ui.GameResultPanel;
    import com.bh.ui.StadiumDecorationView;
    import com.bh.ui.TeamSimulationPanel;
    import com.bh.ui.LiveMatchScorecard;import com.bh.ui.ClassicActionButton;import com.bh.ui.ClassicInventorySkin;
    import com.bh.visual.AssetImage;
    import com.bh.visual.VisualAssetRegistry;
    import com.bh.visual.MatchStadium;

    public class Game extends Sprite {
        private static const PHASE_WINDUP:String = "WINDUP";
        private static const PHASE_FLIGHT:String = "FLIGHT";
        private static const PHASE_RESULT:String = "RESULT";
        private static const PHASE_GAME_OVER:String = "GAME_OVER";
        private static const PHASE_SIMULATION:String = "SIMULATION";
        private static const PHASE_HERO_INTRO:String = "HERO_INTRO";
        private static const PHASE_READY:String = "READY";

        private var w:Number;
        private var h:Number;

        private var worldLayer:Sprite;
        private var ball:Ball;
        private var batter:ClassicBatter;
        private var pitcher:Pitcher;
        private var cursor:BattingCursor;
        private var strikeZone:StrikeZone;
        private var contact:ContactEffect;
        private var hitCinematic:HitCinematic;
        private var gameplayCallout:GameplayCallout;
        private var batting:BattingSystem;
        private var player:Player;
        private var hud:Hud;
        private var resultPanel:GameResultPanel;
        private var simulationPanel:TeamSimulationPanel;
        private var onHome:Function;
        private var onNextMatch:Function;
        private var referenceStadium:MatchStadium;
        private var pitcherLabel:TextField;
        private var defendersLayer:Sprite = new Sprite();
        private var defenders:Array = [];
        private var defenseRoster:Array,pitcherIdentity:Object;

        private var mainData:Object;
        private var opponent:Object;

        private var battingOrderData:Array = [];
        private var currentBatterIndex:int = 0;
        private var currentData:Object;
        private var pendingAdvance:Boolean = false;
        private var pendingEndPlayerInning:Boolean = false;

        private var gameHits:int = 0;
        private var gameHomeRuns:int = 0;
        private var gameAtBats:int = 0;

        private var opponentBoxScore:MatchBoxScore;
        private var scorecard:LiveMatchScorecard,scorecardButton:ClassicActionButton,inspectionWasPaused:Boolean=false;
        private var boxScore:MatchBoxScore;
        private var scoring:MatchScoring=new MatchScoring();private var momentum:MatchMomentum=new MatchMomentum(),momentumPrepared:Boolean=false;private var feedback:MatchFeedback;
        private var victory:MatchVictory;private var lastComboGain:int=0;
        private var walkOff:Boolean=false;
        private var gameHitMap:Object = {};
        private var gameHrMap:Object = {};

        // Offensive base state.
        // Index 0 = first, 1 = second, 2 = third.
        private var baseRunners:Array = [
            null,
            null,
            null
        ];

        private var phase:String = PHASE_RESULT;
        private var phaseStart:int = 0;
        private var pitchStart:int = 0;

        private var releaseDelay:Number = 0.80;
        private var pitchLength:Number = 1.40;
        private var elapsed:Number = 0;
        private var spaceHeld:Boolean=false;

        private var pitchStartX:Number;
        private var pitchStartY:Number;
        private var pitchEndX:Number;
        private var pitchEndY:Number;

        private var pitchType:String = "FASTBALL";
        private var pitchSpeed:int = 92;
        private var curveStrength:Number = 0;
        private var verticalBreak:Number = 0;

        private var cameraShakeFrames:int = 0;
        private var cameraShakeAmount:Number = 0;

        private var balls:int = 0;
        private var strikes:int = 0;
        private var outs:int = 0;
        private var inning:int = 1;
        private var homeScore:int = 0;
        private var awayScore:int = 0;
        private var homeLine:Array = [];
        private var awayLine:Array = [];
        private var homeHalfStartScore:int = 0;
        private var awayHalfStartScore:int = 0;
        private var attempts:int = 0;
        private var gameRbi:int = 0;

        private var simulationNextAt:int = 0;
        private var pendingSimulationAction:Function;
        private var appliedSimulationPause:int=0;
        private var simulationResultUntil:int=0;
        private var resultAutoAdvanceAt:int = 0;
        private var pendingCinematic:Object;
        private var contactViewUntil:int = 0;
        private var impactCues:AudioCueSequence=new AudioCueSequence();
        private var specialAbilities:SpecialAbilityResolver = new SpecialAbilityResolver();

        // Original-style simulation state.
        private var simulationSide:String = "AWAY";
        private var opponentBatterIndex:int = 0;
        private var opponentOuts:int = 0;
        private var opponentBases:Array = [
            null,
            null,
            null
        ];
        private var opponentHits:int = 0;
        private var announceHeroPlate:Boolean = false;


        public function Game(
            width:Number,
            height:Number,
            homeCallback:Function = null,
            nextMatchCallback:Function = null
        ) {
            super();


            w = width;
            h = height;
            name='classic-match';scrollRect=new Rectangle(0,0,w,h);
            onHome = homeCallback;
            onNextMatch = nextMatchCallback;

            GameData.init();

            mainData =
                GameData.mainPlayer();

            opponent =
                GameData.currentOpponent();

            defenseRoster=MatchRosterIdentity.opponent(opponent);pitcherIdentity=MatchRosterIdentity.atPosition(defenseRoster,"P",8);

            battingOrderData =
                GameData.matchBattingOrderPlayers();

            if (
                !battingOrderData ||
                battingOrderData.length == 0
            ) {
                battingOrderData = [
                    mainData
                ];
            }

            boxScore=new MatchBoxScore(battingOrderData);
            currentBatterIndex = 0;
            currentData =
                battingOrderData[
                    currentBatterIndex
                ];

            worldLayer = new Sprite();
            addChild(worldLayer);

            // MatchStadium already supplies the complete field and decorations.
            drawReferenceStadium();
            // StadiumBackdrop also draws the user's placed decorations.
            worldLayer.addChild(defendersLayer);
            var defensePositions:Array = [[.12,.492,.30],[.72,.481,.30],[.445,.459,.22],[.88,.491,.27]];
            for(var defenderIndex:int=0;defenderIndex<defensePositions.length;defenderIndex++) {
                var dp:Array=defensePositions[defenderIndex];
                var defenderData:Object=MatchRosterIdentity.atPosition(defenseRoster,["LF","RF","SS","CF"][defenderIndex],defenderIndex);
                var defender:Pitcher=new Pitcher(w*dp[0],h*dp[1],uint(opponent.accent),String(defenderData.name),null,true,defenderData);

                defender.scaleX=defender.scaleY=dp[2]*h/540;
                defendersLayer.addChild(defender);defenders.push(defender);
            }

            player = createPlayerFromData(
                currentData
            );

            pitcher = new Pitcher(
                w * 0.50,
                h * 0.552,
                uint(opponent.accent),
                String(pitcherIdentity.name),null,false,pitcherIdentity
            );
            pitcher.scaleX = pitcher.scaleY = 0.54*h/540;
            worldLayer.addChild(pitcher);
            pitcherLabel=new TextField();pitcherLabel.defaultTextFormat=new TextFormat('Arial',11,0xffdc68,true,null,null,null,null,'center');
            pitcherLabel.text=String(pitcherIdentity.name);pitcherLabel.width=150;pitcherLabel.height=23;
            pitcherLabel.x=w*.5-75;pitcherLabel.y=pitcher.y-145*pitcher.scaleY;
            pitcherLabel.selectable=pitcherLabel.mouseEnabled=false;pitcherLabel.name='pitcher-name';
            pitcherLabel.filters=[new GlowFilter(0x173627,1,3,3,5)];worldLayer.addChild(pitcherLabel);

            strikeZone = new StrikeZone(
                w * 0.50,
                h * 0.700,
                98,
                100
            );
            worldLayer.addChild(strikeZone);

            cursor = new BattingCursor(
                strikeZone.x,
                strikeZone.y,
                24
            );
            worldLayer.addChild(cursor);

            batter = new ClassicBatter(
                w * 0.270,
                h * 0.875,
                uint(mainData.accent),
                GameData.uniformNumber,
                String(mainData.name)
            );
            batter.scaleX = batter.scaleY = 1.24*h/540;
            worldLayer.addChild(batter);

            ball = new Ball(pitcher.x + 8, pitcher.y - 18);
            worldLayer.addChild(ball);

            contact = new ContactEffect();
            worldLayer.addChild(contact);

            batting = new BattingSystem();

            hitCinematic = new HitCinematic(w, h, null, uint(opponent.accent),MatchRosterIdentity.atPosition(defenseRoster,"SS",3));
            RunnerSprite.warmVictory(GameData.battingOrderPlayers());
            addChild(hitCinematic);

            gameplayCallout = new GameplayCallout();
            gameplayCallout.x = w * 0.58;
            gameplayCallout.y = h * 0.58;
            addChild(gameplayCallout);

            hud = new Hud(w, h, player);
            hud.setOpponentName(
                String(opponent.teamName)
            );
            hud.setActiveSkill(
                GameData.activeSkillName(
                    currentData
                ) +
                "  ·  COMBO " +
                GameData.specialCombo(true)
            );
            updateBatterContext();
            addChild(hud);feedback=new MatchFeedback(w,h);addChild(feedback);

            simulationPanel =
                new TeamSimulationPanel(
                    w,
                    h
                );

            simulationPanel.configure(
                battingOrderData,
                opponent,
                mainData,defenseRoster
            );

            simulationPanel.x = 0;
            simulationPanel.y = 0;

            addChild(simulationPanel);
            opponentBoxScore=new MatchBoxScore(simulationPanel.opponentRosterSnapshot());
            scorecardButton=ClassicInventorySkin.button("BOX SCORE · B",135,30,0x1c7da8) as ClassicActionButton;scorecardButton.name="match-box-score";scorecardButton.x=12;scorecardButton.y=119;scorecardButton.addEventListener(MouseEvent.CLICK,openScorecard);addChild(scorecardButton);


            addEventListener(Event.ENTER_FRAME, loop);
            addEventListener(MouseEvent.CLICK, onClick);

            if (stage) {
                initStage();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }

            updateHud();

            // The historical game simulates the opposing half-inning
            // before stopping at the Hero's turn.
            startOpponentSimulation();
        }

        private function onAddedToStage(e:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            initStage();
        }

        private function initStage():void {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP,keyUp);stage.addEventListener(Event.DEACTIVATE,releaseKeys);
            stage.focus = this;
        }


        private function pitchDisplayName():String {return pitchType=="FASTBALL"?"4-Seam FB":pitchType=="SINKER"?"2-Seam FB":pitchType;}
        private function currentEffectiveContact():int {
            if (!currentData) return 75;

            return Math.min(
                99,
                GameData.matchContact(currentData) +
                GameData.specialComboContactBonus(true)+(isHeroTurn()?momentum.contactBonus:0)
            );
        }

        private function createPlayerFromData(
            data:Object
        ):Player {
            var p:Player =
                new Player(
                    String(data.name),
                    int(data.level),
                    GameData.matchPower(data),
                    GameData.matchContact(data),
                    GameData.matchSpeed(data)
                );

            var key:String =
                String(data.name);

            p.hits =
                gameHitMap[key] !== undefined
                ? int(gameHitMap[key])
                : 0;

            p.hr =
                gameHrMap[key] !== undefined
                ? Number(gameHrMap[key])
                : 0;

            return p;
        }

        private function advanceBatter():void {
            if(checkWalkOff())return;
            if (
                !battingOrderData ||
                battingOrderData.length == 0
            ) {
                return;
            }

            currentBatterIndex =
                (
                    currentBatterIndex + 1
                ) %
                battingOrderData.length;

            currentData =
                battingOrderData[
                    currentBatterIndex
                ];

            player =
                createPlayerFromData(
                    currentData
                );

            // Only the hero bats manually. Retain its prepared poses across
            // simulated teammates instead of recoloring sixteen hidden frames
            // on every plate appearance and evicting them from the palette cache.

            hud.setActiveSkill(
                GameData.activeSkillName(
                    currentData
                ) +
                "  ·  COMBO " +
                GameData.specialCombo(true)
            );

            updateBatterContext();
            updateHud();
        }

        private function isHeroTurn():Boolean {
            return currentData &&
                   mainData &&
                   String(currentData.name) ==
                   String(mainData.name);
        }

        private function beginCurrentTurn():void {
            if (phase == PHASE_GAME_OVER) {
                return;
            }

            balls = 0;
            strikes = 0;

            if (isHeroTurn()) {
                showHeroTurn();
            }
            else {
                startTeamSimulation();
            }
        }

        private function startTeamSimulation():void {
            clearHitResultVisuals();

            phase = PHASE_SIMULATION;
            simulationSide = "HOME";

            cursor.setActive(false);
            strikeZone.visible = false;
            ball.hideBall();

            batter.visible = false;
            pitcher.visible = false;

            simulationPanel.beginSimulation(
                inning,
                "HOME"
            );

            simulationPanel.setHalfInning(
                "HOME",
                inning
            );

            simulationPanel.setActiveBatter(
                "HOME",
                currentBatterIndex
            );

            simulationPanel.setBases(
                baseRunners[0] != null,
                baseRunners[1] != null,
                baseRunners[2] != null
            );

            simulationPanel.setScore(
                homeScore,
                awayScore,
                inning,
                outs
            );

            simulationNextAt =
                getTimer() +
                Math.max(simulationPanel.simulationDelay(),simulationPanel.entryRemaining());

            hud.setPitchLabel(
                "SIMULATION x" +
                (
                    simulationPanel.simulationDelay() <= 500
                    ? "4"
                    : (
                        simulationPanel.simulationDelay() <= 1000
                        ? "2"
                        : "1"
                    )
                )
            );

            updateHud();
        }

        private function startOpponentSimulation():void {
            clearHitResultVisuals();

            awayHalfStartScore = awayScore;
            phase = PHASE_SIMULATION;
            simulationSide = "AWAY";

            cursor.setActive(false);
            strikeZone.visible = false;
            ball.hideBall();

            batter.visible = false;
            pitcher.visible = false;

            simulationPanel.beginSimulation(
                inning,
                "AWAY"
            );

            simulationPanel.setHalfInning(
                "AWAY",
                inning
            );

            simulationPanel.setActiveBatter(
                "AWAY",
                opponentBatterIndex
            );

            simulationPanel.setBases(
                opponentBases[0] != null,
                opponentBases[1] != null,
                opponentBases[2] != null
            );

            simulationPanel.setScore(
                homeScore,
                awayScore,
                inning,
                opponentOuts
            );

            simulationNextAt =
                getTimer() +
                Math.max(simulationPanel.simulationDelay(),simulationPanel.entryRemaining());

            hud.setPitchLabel(
                "SIMULATING RIVALS..."
            );

            updateHud();
        }

        private function showHeroTurn():void {
            momentumPrepared=false;
            phase = PHASE_HERO_INTRO;
            simulationSide = "HOME";

            batter.visible = false;
            pitcher.visible = false;
            strikeZone.visible = false;
            ball.hideBall();
            cursor.setActive(false);

            simulationPanel.setHalfInning(
                "HOME",
                inning
            );

            simulationPanel.showHeroTurn(
                String(currentData.name),
                inning,
                scoreLabel()
            );

            simulationNextAt =
                getTimer() + simulationPanel.heroTransitionDuration();

            announceHeroPlate = true;

            hud.setPitchLabel(
                "YOUR TURN"
            );

            if (gameplayCallout) {
                gameplayCallout.hide();
            }

            updateHud();
        }

        private function scoreLabel():String {
            return "HEROES " +
                   homeScore +
                   " - " +
                   awayScore +
                   " " +
                   String(opponent.teamName);
        }


        private function specialCardForCurrentBatter():Object {
            return isHeroTurn()?null:GameData.lineupCardForMatchAt(currentBatterIndex);
        }

        private function specialCardSimData(
            card:Object,
            fallback:Object
        ):Object {
            var levelBonus:int=0; // Instance stats already contain enhancement.

            return {
                name:String(card.name),
                power:Math.min(
                    99,
                    int(card.power) +
                    levelBonus
                ),
                contact:Math.min(
                    99,
                    int(card.contact) +
                    levelBonus
                ),
                speed:Math.min(
                    99,
                    int(card.speed) +
                    levelBonus
                ),
                luck:Math.min(
                    99,
                    int(card.luck) +
                    levelBonus
                ),
                accent:uint(card.accent),
                specialCardId:String(card.id),
                fallbackPlayer:fallback
            };
        }

        private function simulateTeammatePlateAppearance():void {
            if (
                phase != PHASE_SIMULATION ||
                isHeroTurn()
            ) {
                return;
            }

            var visualBefore114:Array=baseRunners.concat();

            var fallbackData:Object =
                currentData;

            var specialCard:Object =
                specialCardForCurrentBatter();

            var batterData:Object =
                specialCard
                ? specialCardSimData(
                    specialCard,
                    fallbackData
                )
                : fallbackData;

            var contactValue:int = specialCard?int(batterData.contact):GameData.matchContact(batterData);

            var powerValue:int = specialCard?int(batterData.power):GameData.matchPower(batterData);

            var speedValue:int = specialCard?int(batterData.speed):GameData.matchSpeed(batterData);

            var luckValue:int =
                specialCard
                ? int(batterData.luck)
                : GameData.matchLuck(
                    batterData
                );

            var opponentRating:int =
                int(opponent.rating);

            var walkChance:Number =
                0.055 +
                Math.max(
                    0,
                    luckValue - 60
                ) *
                0.0014;

            var hitChance:Number =
                0.235 +
                (
                    contactValue -
                    opponentRating
                ) *
                0.0032 +
                (
                    luckValue -
                    65
                ) *
                0.0012 +
                GameData.specialComboTeamBonus(true)+(specialCard?0:GameData.friendAverageBonus(fallbackData));

            hitChance =
                Math.max(
                    0.13,
                    Math.min(
                        0.42,
                        hitChance
                    )
                );

            var roll:Number =
                Math.random();

            var result:String;
            var rbi:int = 0;

            var unavailable:Boolean=!specialCard&&!GameData.playerReady(fallbackData);
            if(unavailable){roll=1;hitChance=0;walkChance=0;}
            var forcedHit:String = specialAbilities.resolve(specialCard,inning);
            if(forcedHit!="") {
                simulationPanel.showSpecialCardActivation(specialCard,forcedHit+" ACTIVATED!");
            }

            if (forcedHit != "") {
                var forcedBases:int =
                    forcedHit == "TRIPLE"
                    ? 3
                    : (
                        forcedHit == "DOUBLE"
                        ? 2
                        : 1
                    );

                rbi =
                    advanceRunnersOnHit(
                        forcedBases,
                        batterData
                    );

                gameHits++;
                gameAtBats++;
                gameRbi += rbi;

                if (specialCard) {
                    GameData.recordSpecialCardAtBat(
                        String(specialCard.id),
                        true,
                        rbi
                    );
                }

                result =
                    forcedHit +
                    "  CARD TRIGGER" +
                    (
                        rbi > 0
                        ? "  +" + rbi + " RBI"
                        : ""
                    );
            }
            else if (roll < walkChance) {
                rbi =
                    simulateWalkFor(
                        batterData
                    );

                if (specialCard) {
                    GameData.recordSpecialCardAtBat(
                        String(specialCard.id),
                        false,
                        rbi,
                        true
                    );
                }
                else {
                    GameData.recordWalk(
                        batterData,
                        rbi
                    );
                }

                result =
                    rbi > 0
                    ? "WALK  +1 RBI"
                    : "WALK";
            }
            else if (
                roll <
                walkChance +
                hitChance
            ) {
                var hitType:String =
                    simulatedHitType(
                        powerValue,
                        contactValue,
                        speedValue,
                        luckValue
                    );

                var bases:int =
                    hitType == "HOME RUN"
                    ? 4
                    : (
                        hitType == "TRIPLE"
                        ? 3
                        : (
                            hitType == "DOUBLE"
                            ? 2
                            : 1
                        )
                    );

                rbi =
                    advanceRunnersOnHit(
                        bases,
                        batterData
                    );

                gameHits++;
                gameAtBats++;

                incrementGameMap(
                    gameHitMap,
                    String(batterData.name)
                );

                var homeRun:Boolean =
                    hitType == "HOME RUN";

                if (homeRun) {
                    gameHomeRuns++;

                    incrementGameMap(
                        gameHrMap,
                        String(batterData.name)
                    );
                }

                gameRbi += rbi;

                if (specialCard) {
                    GameData.recordSpecialCardAtBat(
                        String(specialCard.id),
                        true,
                        rbi
                    );
                }
                else {
                    GameData.recordPlateAppearance(
                        batterData,
                        true,
                        homeRun,
                        rbi,
                        hitType
                    );
                }

                result =
                    hitType +
                    (
                        rbi > 0
                        ? "  +" + rbi + " RBI"
                        : ""
                    );
            }
            else {
                outs++;
                gameAtBats++;

                if (specialCard) {
                    GameData.recordSpecialCardAtBat(
                        String(specialCard.id),
                        false,
                        0
                    );
                }
                else {
                    GameData.recordPlateAppearance(
                        batterData,
                        false,
                        false,
                        0
                    );
                }

                result =
                    Math.random() < 0.34
                    ? "STRIKE OUT"
                    : (
                        Math.random() < 0.5
                        ? "GROUND OUT"
                        : "FLY OUT"
                    );
            }

            boxScore.record(currentBatterIndex,batterData,result,rbi);
            scorePlay(result,rbi,batterData===mainData,luckValue);

            var comboGain:int = lastComboGain;

            if (specialCard && result.indexOf("HOME RUN") >= 0) {
                simulationPanel.showSpecialCardResult(specialCard, result);
            }

            simulationPanel.addResultFor(
                "HOME",
                currentBatterIndex,
                specialCard
                ? "★ " +
                  String(
                      batterData.name
                  )
                : String(
                    batterData.name
                ),
                result,
                comboGain
            );

            simulationPanel.setHits(gameHits,opponentHits);
            simulationPanel.setScore(
                homeScore,
                awayScore,
                inning,
                outs
            );

            simulationPanel.setBases(
                baseRunners[0] != null,
                baseRunners[1] != null,
                baseRunners[2] != null
            );

            simulationPanel.showResolvedPlay(visualBefore114,baseRunners,batterData,result);

            updateHud();

            queueSimulationResult(function():void {
                if(checkWalkOff())return;
                advanceBatter();
                if(outs>=3){endPlayerInning();return;}
                if(phase==PHASE_GAME_OVER)return;
                if(isHeroTurn())showHeroTurn();
                else {simulationPanel.setActiveBatter('HOME',currentBatterIndex);simulationNextAt=getTimer()+simulationPanel.nextBatterDelay();}
            });
        }

        private function simulateOpponentPlateAppearance():void {
            if (
                phase != PHASE_SIMULATION ||
                simulationSide != "AWAY"
            ) {
                return;
            }

            var visualBefore114:Array=opponentBases.concat();

            var opponentData:Object =
                simulationPanel.opponentPlayerAt(
                    opponentBatterIndex
                );

            if (!opponentData) {
                return;
            }

            var opponentRating:int =
                opponent &&
                opponent.rating !== undefined
                ? int(
                    opponent.rating
                )
                : 70;

            var hero:Object =
                GameData.mainPlayer();

            var defense:Number =
                (
                    GameData.matchContact(
                        hero
                    ) +
                    GameData.matchSpeed(
                        hero
                    )
                ) /
                2.0;

            var walkChance:Number =
                0.050 +
                Math.max(
                    0,
                    opponentRating - 70
                ) *
                0.0007;

            var hitChance:Number =
                0.225 +
                (
                    opponentRating -
                    defense
                ) *
                0.0032;

            hitChance -=
                GameData.skillDefenseBonus(
                    mainData
                );

            hitChance =
                Math.max(
                    0.12,
                    Math.min(
                        0.39,
                        hitChance
                    )
                );

            var roll:Number =
                Math.random();

            var result:String = "";
            var runs:int = 0;

            if (
                roll <
                walkChance
            ) {
                runs =
                    advanceOpponentWalk();

                result =
                    runs > 0
                    ? "WALK +" +
                      runs +
                      " RBI"
                    : "WALK";
            }
            else if (
                roll <
                walkChance +
                hitChance
            ) {
                var hitType:String =
                    simulatedOpponentHitType(
                        opponentRating
                    );

                var bases:int =
                    hitType == "HOME RUN"
                    ? 4
                    : (
                        hitType == "TRIPLE"
                        ? 3
                        : (
                            hitType == "DOUBLE"
                            ? 2
                            : 1
                        )
                    );

                runs =
                    advanceOpponentRunners(
                        bases,
                        opponentData
                    );

                opponentHits++;

                result =
                    hitType +
                    (
                        runs > 0
                        ? " +" +
                          runs +
                          " RBI"
                        : ""
                    );
            }
            else {
                opponentOuts++;

                var outRoll:Number =
                    Math.random();

                result =
                    outRoll < 0.34
                    ? "STRIKE OUT"
                    : (
                        outRoll < 0.67
                        ? "GROUND OUT"
                        : "FLY OUT"
                    );
            }

            opponentBoxScore.record(opponentBatterIndex,opponentData,result,runs);
            simulationPanel.addResultFor(
                "AWAY",
                opponentBatterIndex,
                String(
                    opponentData.name
                ),
                result,
                0
            );

            simulationPanel.setHits(gameHits,opponentHits);
            simulationPanel.setScore(
                homeScore,
                awayScore,
                inning,
                opponentOuts
            );

            simulationPanel.setBases(
                opponentBases[0] != null,
                opponentBases[1] != null,
                opponentBases[2] != null
            );

            simulationPanel.showResolvedPlay(visualBefore114,opponentBases,opponentData,result);

            queueSimulationResult(function():void {
                opponentBatterIndex=(opponentBatterIndex+1)%9;
                if(opponentOuts>=3){finishOpponentHalf();return;}
                simulationPanel.setActiveBatter('AWAY',opponentBatterIndex);
                simulationNextAt=getTimer()+simulationPanel.nextBatterDelay();
            });
        }

        private function queueSimulationResult(next:Function):void {
            pendingSimulationAction=next;
            simulationResultUntil=getTimer()+simulationPanel.resultDelay();
        }

        private function simulatedOpponentHitType(
            rating:int
        ):String {
            var roll:Number =
                Math.random();

            var homeRunChance:Number =
                0.025 +
                Math.max(
                    0,
                    rating - 70
                ) *
                0.0026;

            var tripleChance:Number =
                0.020 +
                Math.max(
                    0,
                    rating - 75
                ) *
                0.0008;

            var doubleChance:Number =
                0.17 +
                Math.max(
                    0,
                    rating - 72
                ) *
                0.0012;

            if (
                roll <
                homeRunChance
            ) {
                return "HOME RUN";
            }

            if (
                roll <
                homeRunChance +
                tripleChance
            ) {
                return "TRIPLE";
            }

            if (
                roll <
                homeRunChance +
                tripleChance +
                doubleChance
            ) {
                return "DOUBLE";
            }

            return "SINGLE";
        }

        private function advanceOpponentWalk():int {
            var runs:int = 0;

            if (
                opponentBases[0]
            ) {
                if (
                    opponentBases[1]
                ) {
                    if (
                        opponentBases[2]
                    ) {
                        awayScore++;
                        runs = 1;
                    }

                    opponentBases[2] =
                        opponentBases[1];
                }

                opponentBases[1] =
                    opponentBases[0];
            }

            opponentBases[0] = {
                speed:70
            };

            return runs;
        }

        private function advanceOpponentRunners(
            bases:int,
            batterData:Object
        ):int {
            var runs:int = 0;

            if (bases >= 4) {
                for (
                    var h:int = 0;
                    h < 3;
                    h++
                ) {
                    if (
                        opponentBases[h]
                    ) {
                        runs++;
                    }
                }

                runs++;
                awayScore += runs;

                opponentBases = [
                    null,
                    null,
                    null
                ];

                return runs;
            }

            var newBases:Array = [
                null,
                null,
                null
            ];

            for (
                var i:int = 2;
                i >= 0;
                i--
            ) {
                var runner:Object =
                    opponentBases[i];

                if (!runner) continue;

                var target:int =
                    i +
                    bases;

                if (
                    bases == 1 &&
                    i == 1 &&
                    Math.random() < 0.60
                ) {
                    runs++;
                    continue;
                }

                if (
                    bases == 2 &&
                    i == 0 &&
                    Math.random() < 0.50
                ) {
                    runs++;
                    continue;
                }

                if (
                    target >= 3
                ) {
                    runs++;
                }
                else {
                    newBases[
                        target
                    ] = runner;
                }
            }

            newBases[
                bases - 1
            ] = batterData;

            opponentBases =
                newBases;

            awayScore += runs;

            return runs;
        }

        private function finishOpponentHalf():void {
            awayLine[inning - 1] =
                Math.max(
                    0,
                    awayScore - awayHalfStartScore
                );

            homeHalfStartScore = homeScore;

            opponentOuts = 0;
            opponentBases = [
                null,
                null,
                null
            ];

            simulationPanel.setBases(
                false,
                false,
                false
            );

            // If the home team is already ahead after the top of the
            // 9th/extra inning, no bottom half is required.
            if (
                inning >= 9 &&
                homeScore >
                awayScore
            ) {
                finishGame();
                return;
            }

            outs = 0;
            balls = 0;
            strikes = 0;
            clearBases();

            simulationSide = "HOME";

            if (
                isHeroTurn()
            ) {
                showHeroTurn();
            }
            else {
                startTeamSimulation();
            }
        }

        private function simulatedHitType(
            powerValue:int,
            contactValue:int,
            speedValue:int,
            luckValue:int
        ):String {
            var roll:Number =
                Math.random();

            var homeRunChance:Number =
                0.025 +
                Math.max(
                    0,
                    powerValue - 65
                ) *
                0.003 +
                Math.max(
                    0,
                    luckValue - 70
                ) *
                0.001;

            homeRunChance =
                Math.min(
                    0.19,
                    homeRunChance
                );

            var tripleChance:Number =
                0.018 +
                Math.max(
                    0,
                    speedValue - 65
                ) *
                0.0018;

            var doubleChance:Number =
                0.17 +
                Math.max(
                    0,
                    contactValue - 72
                ) *
                0.0012;

            if (
                roll <
                homeRunChance
            ) {
                return "HOME RUN";
            }

            if (
                roll <
                homeRunChance +
                tripleChance
            ) {
                return "TRIPLE";
            }

            if (
                roll <
                homeRunChance +
                tripleChance +
                doubleChance
            ) {
                return "DOUBLE";
            }

            return "SINGLE";
        }

        private function simulateWalkFor(
            batterData:Object
        ):int {
            var rbi:int = 0;

            if (baseRunners[0]) {
                if (baseRunners[1]) {
                    if (baseRunners[2]) {
                        homeScore++;
                        gameRbi++;
                        rbi = 1;
                    }

                    baseRunners[2] =
                        baseRunners[1];
                }

                baseRunners[1] =
                    baseRunners[0];
            }

            baseRunners[0] =
                batterData;

            return rbi;
        }

        private function updateBatterContext():void {
            if (
                !hud ||
                !battingOrderData ||
                battingOrderData.length == 0
            ) {
                return;
            }

            var nextIndex:int =
                (
                    currentBatterIndex + 1
                ) %
                battingOrderData.length;

            var nextData:Object =
                battingOrderData[
                    nextIndex
                ];

            hud.setBatterContext(
                currentBatterIndex + 1,
                String(nextData.name)
            );
        }

        private function drawReferenceStadium():void {
            referenceStadium = new MatchStadium(w, h);
            worldLayer.addChild(referenceStadium);
        }

        private function drawStadium():void {
            var g:* = worldLayer.graphics;

            var sky:uint = GameData.stadiumAccent(
                "background",
                0x69c9ee
            );

            var fieldColor:uint = GameData.stadiumAccent(
                "field",
                0x2f8c4c
            );

            var standColor:uint = GameData.stadiumAccent(
                "stand",
                0x9a6245
            );

            var fenceColor:uint = GameData.stadiumAccent(
                "fence",
                0x237247
            );

            var bannerColor:uint = GameData.stadiumAccent(
                "banner",
                0xd45647
            );

            var scoreColor:uint = GameData.stadiumAccent(
                "scoreboard",
                0x1e7043
            );

            // Bright outdoor stadium.  The surviving gameplay uses a very
            // cheerful blue sky rather than the dark arena of the early remake.
            g.beginFill(sky);
            g.drawRect(0, 0, w, h * 0.36);
            g.endFill();

            // Puffy clouds.
            g.beginFill(0xffffff, 0.88);
            var cloudX:Array = [42, 165, 305, 690, 820, 925];
            var cloudY:Array = [88, 72, 102, 78, 106, 66];
            for (var cl:int = 0; cl < cloudX.length; cl++) {
                g.drawCircle(Number(cloudX[cl]), Number(cloudY[cl]), 20 + cl % 3 * 5);
                g.drawCircle(Number(cloudX[cl]) + 21, Number(cloudY[cl]) + 4, 17 + cl % 2 * 5);
                g.drawCircle(Number(cloudX[cl]) - 19, Number(cloudY[cl]) + 7, 14 + cl % 2 * 4);
            }
            g.endFill();

            // Distant mountains / trees behind the resort-style center-field
            // building seen in the gameplay reference.
            g.beginFill(0x99d7d7, 0.68);
            g.moveTo(0, h * 0.32);
            g.lineTo(w * 0.12, h * 0.20);
            g.lineTo(w * 0.22, h * 0.32);
            g.lineTo(w * 0.34, h * 0.22);
            g.lineTo(w * 0.46, h * 0.32);
            g.lineTo(w * 0.61, h * 0.19);
            g.lineTo(w * 0.75, h * 0.32);
            g.lineTo(w * 0.87, h * 0.21);
            g.lineTo(w, h * 0.32);
            g.lineTo(w, h * 0.38);
            g.lineTo(0, h * 0.38);
            g.endFill();

            // Central cream-colored grand hotel / clubhouse silhouette.
            g.beginFill(0xf0d9a9);
            g.drawRect(w * 0.31, h * 0.205, w * 0.38, h * 0.19);
            g.drawRect(w * 0.265, h * 0.25, w * 0.07, h * 0.145);
            g.drawRect(w * 0.665, h * 0.25, w * 0.07, h * 0.145);
            g.drawRect(w * 0.455, h * 0.15, w * 0.09, h * 0.245);
            g.endFill();

            // Roof accents and center dome.
            g.beginFill(0xb96b3c);
            g.drawRect(w * 0.32, h * 0.214, w * 0.36, h * 0.025);
            g.drawRect(w * 0.456, h * 0.174, w * 0.088, h * 0.024);
            g.endFill();

            g.beginFill(0xe4c97e);
            g.drawCircle(w * 0.50, h * 0.155, 19);
            g.endFill();
            g.beginFill(0x75a85b);
            g.drawCircle(w * 0.50, h * 0.151, 13);
            g.endFill();

            // Windows and arches.
            g.beginFill(0x74a7b6, 0.78);
            for (var win:int = 0; win < 8; win++) {
                g.drawRoundRect(w * 0.335 + win * w * 0.043, h * 0.262, 17, 25, 8, 8);
            }
            g.endFill();

            g.beginFill(0x7d9c6c, 0.95);
            g.drawRoundRect(w * 0.459, h * 0.285, w * 0.082, h * 0.095, 7, 7);
            g.endFill();

            // Palm trees next to the center-field building.
            drawPalmTree(g, w * 0.27, h * 0.31, 0.72);
            drawPalmTree(g, w * 0.73, h * 0.31, 0.72);
            drawPalmTree(g, w * 0.22, h * 0.335, 0.55);
            drawPalmTree(g, w * 0.78, h * 0.335, 0.55);

            // Side grandstands. White stair structures frame the batting camera.
            g.beginFill(0xe7e5dd);
            g.moveTo(0, h * 0.275);
            g.lineTo(w * 0.115, h * 0.275);
            g.lineTo(w * 0.205, h * 0.445);
            g.lineTo(0, h * 0.445);
            g.endFill();

            g.moveTo(w, h * 0.275);
            g.lineTo(w * 0.885, h * 0.275);
            g.lineTo(w * 0.795, h * 0.445);
            g.lineTo(w, h * 0.445);
            g.endFill();

            g.beginFill(standColor);
            g.drawRect(0, h * 0.295, w * 0.19, h * 0.135);
            g.drawRect(w * 0.81, h * 0.295, w * 0.19, h * 0.135);
            g.endFill();

            // Crowd dots in the side stands.
            var crowdColors:Array = [
                0xf0cf55,
                0xd95949,
                0x5d91cc,
                0xf2f2ec,
                0x72b666,
                0x8e71b2
            ];

            for (var row:int = 0; row < 6; row++) {
                for (var seat:int = 0; seat < 19; seat++) {
                    var cc:uint = uint(crowdColors[(row * 3 + seat) % crowdColors.length]);
                    g.beginFill(cc, 0.88);
                    g.drawCircle(8 + seat * 10, h * 0.31 + row * 11, 2.4);
                    g.drawCircle(w - 8 - seat * 10, h * 0.31 + row * 11, 2.4);
                    g.endFill();
                }
            }

            // Central scoreboard in front of the building.
            g.beginFill(0xe9e6d7);
            g.drawRoundRect(w * 0.445, h * 0.295, w * 0.11, h * 0.13, 5, 5);
            g.endFill();
            g.beginFill(0x24352f);
            g.drawRoundRect(w * 0.454, h * 0.31, w * 0.092, h * 0.09, 4, 4);
            g.endFill();
            g.beginFill(scoreColor);
            g.drawRoundRect(w * 0.465, h * 0.325, w * 0.07, h * 0.045, 3, 3);
            g.endFill();

            // Light banks.
            var lightColor:uint = GameData.stadiumAccent("lights", 0xf4fbff);
            for (var tower:int = 0; tower < 6; tower++) {
                var tx:Number = 100 + tower * 152;
                g.lineStyle(2, 0xcdd8dc, 0.9);
                g.moveTo(tx, h * 0.285);
                g.lineTo(tx, h * 0.22);
                g.lineStyle();
                g.beginFill(lightColor, 0.95);
                for (var lamp:int = 0; lamp < 5; lamp++) {
                    g.drawCircle(tx - 11 + lamp * 5.5, h * 0.218, 2.1);
                }
                g.endFill();
            }

            // Outfield wall with sponsor panels.
            g.beginFill(fenceColor);
            g.drawRect(0, h * 0.425, w, h * 0.065);
            g.endFill();

            for (var ad:int = 0; ad < 12; ad++) {
                g.beginFill(ad % 3 == 0 ? bannerColor : 0x1f6c85, 0.92);
                g.drawRoundRect(12 + ad * 80, h * 0.442, 64, 13, 3, 3);
                g.endFill();
            }

            // Grass field.
            g.beginFill(fieldColor);
            g.drawRect(0, h * 0.49, w, h * 0.51);
            g.endFill();

            // Mowing stripes give the field more depth.
            g.beginFill(0xffffff, 0.035);
            for (var stripe:int = 0; stripe < 7; stripe += 2) {
                g.moveTo(stripe * w / 7, h * 0.49);
                g.lineTo((stripe + 1) * w / 7, h * 0.49);
                g.lineTo((stripe + 3) * w / 9, h);
                g.lineTo(stripe * w / 10, h);
                g.endFill();
                g.beginFill(0xffffff, 0.035);
            }
            g.endFill();

            // Infield dirt perspective.
            g.beginFill(0xc98f53);
            g.moveTo(0, h * 0.68);
            g.lineTo(w * 0.28, h);
            g.lineTo(w * 0.72, h);
            g.lineTo(w, h * 0.68);
            g.lineTo(w, h);
            g.lineTo(0, h);
            g.lineTo(0, h * 0.68);
            g.endFill();

            // Green infield island and mound.
            g.beginFill(fieldColor);
            g.drawEllipse(w * 0.34, h * 0.515, w * 0.32, h * 0.245);
            g.endFill();

            g.beginFill(0xd6a266);
            g.drawEllipse(w * 0.47, h * 0.49, w * 0.08, h * 0.038);
            g.endFill();

            // Foul lines and batter boxes.
            g.lineStyle(4, 0xffffff, 0.96);
            g.moveTo(w * 0.30, h);
            g.lineTo(w * 0.46, h * 0.55);
            g.moveTo(w * 0.70, h);
            g.lineTo(w * 0.54, h * 0.55);
            g.lineStyle();

            g.lineStyle(3, 0xffffff, 0.92);
            g.drawRect(w * 0.29, h * 0.80, w * 0.105, h * 0.13);
            g.drawRect(w * 0.605, h * 0.80, w * 0.105, h * 0.13);
            g.lineStyle();

            // Home plate.
            var px:Number = w * 0.49;
            var py:Number = h * 0.855;

            g.beginFill(0xffffff);
            g.moveTo(px - 23, py - 13);
            g.lineTo(px + 23, py - 13);
            g.lineTo(px + 17, py + 8);
            g.lineTo(px, py + 22);
            g.lineTo(px - 17, py + 8);
            g.lineTo(px - 23, py - 13);
            g.endFill();

            // Static fielders help the batting view feel populated like the
            // original capture. The live pitcher is drawn separately on top.
            var rivalColor:uint = opponent && opponent.accent !== undefined
                ? uint(opponent.accent)
                : 0xc84e45;

            drawTinyFielder(g, w * 0.12, h * 0.49, 0.62, rivalColor);
            drawTinyFielder(g, w * 0.86, h * 0.49, 0.62, rivalColor);
            drawTinyFielder(g, w * 0.25, h * 0.56, 0.55, rivalColor);
            drawTinyFielder(g, w * 0.75, h * 0.56, 0.55, rivalColor);
        }

        private function drawPalmTree(
            g:*,
            px:Number,
            py:Number,
            scale:Number
        ):void {
            g.lineStyle(7 * scale, 0x8a5a31, 1);
            g.moveTo(px, py + 34 * scale);
            g.lineTo(px + 4 * scale, py);
            g.lineStyle();

            g.beginFill(0x39964d);
            for (var i:int = 0; i < 5; i++) {
                var angle:Number = -2.3 + i * 0.55;
                g.drawEllipse(
                    px + Math.cos(angle) * 15 * scale - 12 * scale,
                    py + Math.sin(angle) * 10 * scale - 4 * scale,
                    27 * scale,
                    10 * scale
                );
            }
            g.endFill();
        }

        private function drawTinyFielder(
            g:*,
            px:Number,
            py:Number,
            scale:Number,
            color:uint
        ):void {
            g.beginFill(0x000000, 0.16);
            g.drawEllipse(px - 16 * scale, py + 22 * scale, 32 * scale, 8 * scale);
            g.endFill();

            g.beginFill(0xf1f2ef);
            g.drawRoundRect(
                px - 10 * scale,
                py - 2 * scale,
                20 * scale,
                27 * scale,
                8 * scale,
                8 * scale
            );
            g.endFill();

            g.beginFill(color);
            g.drawRect(px - 3 * scale, py - 2 * scale, 6 * scale, 26 * scale);
            g.endFill();

            g.beginFill(0xe6ad84);
            g.drawCircle(px, py - 13 * scale, 9 * scale);
            g.endFill();

            g.beginFill(color);
            g.drawEllipse(
                px - 11 * scale,
                py - 21 * scale,
                22 * scale,
                9 * scale
            );
            g.endFill();

            g.beginFill(0x513625);
            g.drawCircle(px + 12 * scale, py + 1 * scale, 6 * scale);
            g.endFill();
        }


        private function drawPlacedStadiumDecorations():void {
            var entries:Array =
                GameData.stadiumDecorations;

            if (!entries) return;

            for (
                var i:int = 0;
                i < entries.length;
                i++
            ) {
                var entry:Object =
                    entries[i];

                var item:Object =
                    GameData.shopItemById(
                        String(entry.id)
                    );

                if (!item) continue;

                var view:StadiumDecorationView =
                    new StadiumDecorationView(
                        item,
                        i
                    );

                view.x =
                    210 +
                    (
                        Number(entry.x) /
                        556
                    ) *
                    540;

                view.y =
                    190 +
                    (
                        Number(entry.y) -
                        130
                    ) /
                    162 *
                    115;

                var s:Number =
                    Number(entry.scale) *
                    0.75;

                view.scaleX =
                    view.scaleY =
                    s;

                view.mouseEnabled = false;

                worldLayer.addChild(view);
            }
        }

        private function clearHitResultVisuals():void {
            impactCues.cancelPending();if(gameplayCallout)gameplayCallout.hide();if(contact)contact.clear();
            if(hud)hud.setCinematic(false);
            pendingSimulationAction=null;
            simulationResultUntil=0;
            pendingCinematic = null;
            contactViewUntil = 0;
            resultAutoAdvanceAt = 0;

            if (hitCinematic) {
                hitCinematic.clear();
            }

            worldLayer.visible = true;
        }

        private function preparePitchReady():void {
            if (!isHeroTurn()) {
                beginCurrentTurn();
                return;
            }

            clearHitResultVisuals();
            simulationPanel.hidePanel();

            batter.visible = true;
            pitcher.visible = true;
            strikeZone.visible = true;
            batter.alpha=pitcher.alpha=strikeZone.alpha=defendersLayer.alpha=1;
            cursor.setActive(false);
            ball.hideBall();hud.resetPlay();pitcher.resetReady();for each(var readyFielder:Pitcher in defenders)readyFielder.resetReady();
            batter.resetReady();

            phase = PHASE_READY;
            if(!momentumPrepared){
                momentumPrepared=true;var state:Object=momentum.beginPlate(inning,homeScore,awayScore,baseRunners[0]!=null||baseRunners[1]!=null||baseRunners[2]!=null);
                batter.setMomentum(momentum.tier,momentum.comeback);hud.setMomentum(state);simulationPanel.setMomentum(state);
                if(momentum.comeback)feedback.show("¡PUEDES REMONTAR!","Hay corredores en base. Un buen contacto puede cambiar el partido.");
                else if(momentum.tier>0)feedback.show(momentum.tier==3?"¡COMBO AL MÁXIMO!":"¡BONO DE COMBO!",momentum.maxReady?"Conecta dentro del campo para un home run. Los strikes y fouls conservan la carga; un strikeout la reinicia.":"Encadena hits para llenar COMBO. Luck aumenta la carga por hit.");
            }

            hud.setResult("");
            hud.setPitchLabel(
                "CLIC / ESPACIO · PREPARADO"
            );
            showStarterPitchHelp();

            updateHud();
        }

        private var starterCoach:com.bh.ui.StarterCoach;
        private var starterHadHit:Boolean=false,starterHadStrikeout:Boolean=false;
        private function showStarterPitchHelp():void {
            if(starterCoach||!GameData.tutorialActive()||GameData.starterTutorial.stage!=6)return;
            var id:String="",message:String="",target:Rectangle=new Rectangle(390,390,170,145);
            if(!GameData.starterTutorial.hints.pitch){id="pitch";message="Pulsa clic o ESPACIO para iniciar la pichada y repite cuando la bola llegue al plato. Si va fuera de la zona, puedes dejarla pasar.";}
            else if(momentum.maxReady&&!GameData.starterTutorial.hints.max){id="max";message="¡COMBO al máximo! Conecta dentro del campo para un home run. Los strikes y fouls conservan MAX; un strikeout lo reinicia.";target=new Rectangle(4,563,92,86);}
            else if(starterHadStrikeout&&!GameData.starterTutorial.hints.strikeout){id="strikeout";message="Tu strikeout reinició el indicador COMBO. ¡No te desanimes! Los siguientes hits vuelven a llenarlo.";target=new Rectangle(4,563,92,86);}
            else if(starterHadHit&&!GameData.starterTutorial.hints.combo){id="combo";message="Cada hit de tu equipo llena COMBO. Cuando alcance MAX, el fuego bajo tus pies te avisará de la oportunidad de home run.";target=new Rectangle(4,563,92,86);}
            if(!id)return;
            var hint:String=id;
            starterCoach=new com.bh.ui.StarterCoach(message,"¡ENTENDIDO!",function():void{GameData.starterTutorial.hints[hint]=true;GameData.save();starterCoach.dispose();removeChild(starterCoach);starterCoach=null;});
            addChild(starterCoach);starterCoach.pointTo(target,212,220);
        }
        private function startPitch():void {
            if(starterCoach)return;
            if (!isHeroTurn()) {
                beginCurrentTurn();
                return;
            }

            simulationPanel.hidePanel();

            clearHitResultVisuals();

            batter.visible = true;
            pitcher.visible = true;
            strikeZone.visible = true;
            cursor.setActive(false);
            batter.resetReady();

            if (announceHeroPlate) {
                announceHeroPlate = false;
                if (baseRunners[0] != null && baseRunners[1] != null && baseRunners[2] != null) {
                    gameplayCallout.show("BASES LOADED!", 0xb9ef37, 48);
                    AudioManager.playSfx("bases_loaded.mp3", 0.92);
                }
            }

            choosePitch();

            phase = PHASE_WINDUP;
            phaseStart = getTimer();

            ball.hideBall();
            cursor.setActive(false);
            batter.setPitchProgress(0);

            pitcher.throwPitch(releaseDelay);
            for each(var readyDefender:Pitcher in defenders)readyDefender.prepareDefense(releaseDelay);
            hud.setResult("");
            hud.setPitchLabel(
                "VS " +
                pitcherIdentity.name +
                "  OVR " +
                opponent.rating
            );
        }

        private function choosePitch():void {
            var repertoire:Array =
                opponent &&
                opponent.repertoire
                ? opponent.repertoire as Array
                : null;

            if (
                !repertoire ||
                repertoire.length == 0
            ) {
                repertoire = [
                    "FASTBALL",
                    "CHANGEUP"
                ];
            }

            pitchType =
                String(
                    repertoire[
                        int(
                            Math.random() *
                            repertoire.length
                        )
                    ]
                );

            // Pitch choice reacts to the count. With three balls the AI
            // attacks the zone more often; with two strikes it favors its
            // breaking repertoire when available.
            if (
                balls >= 3 &&
                repertoire.indexOf(
                    "FASTBALL"
                ) >= 0 &&
                Math.random() < 0.68
            ) {
                pitchType = "FASTBALL";
            }
            else if (
                strikes >= 2 &&
                repertoire.length > 2 &&
                Math.random() < 0.58
            ) {
                var breaking:Array = [];

                for each (
                    var candidate:String in
                    repertoire
                ) {
                    if (
                        candidate !=
                        "FASTBALL"
                    ) {
                        breaking.push(
                            candidate
                        );
                    }
                }

                if (
                    breaking.length > 0
                ) {
                    pitchType =
                        String(
                            breaking[
                                int(
                                    Math.random() *
                                    breaking.length
                                )
                            ]
                        );
                }
            }

            var rating:int =
                opponent
                ? int(opponent.rating)
                : 70;

            var ratingBoost:Number =
                (rating - 65) /
                100.0;

            curveStrength = 0;
            verticalBreak = 0;

            if (pitchType == "FASTBALL") {
                pitchSpeed =
                    88 +
                    int(ratingBoost * 14) +
                    int(Math.random() * 7);

                pitchLength =
                    1.30 -
                    ratingBoost * 0.28 +
                    Math.random() * 0.08;

                curveStrength =
                    (Math.random() - 0.5) * 5;
            }
            else if (pitchType == "CURVEBALL") {
                pitchSpeed =
                    73 +
                    int(ratingBoost * 9) +
                    int(Math.random() * 6);

                pitchLength =
                    1.50 -
                    ratingBoost * 0.18 +
                    Math.random() * 0.10;

                curveStrength =
                    (
                        Math.random() < 0.5
                        ? -1
                        : 1
                    ) *
                    (
                        28 +
                        Math.random() * 18
                    );

                verticalBreak =
                    5 +
                    Math.random() * 8;
            }
            else if (pitchType == "CHANGEUP") {
                pitchSpeed =
                    77 +
                    int(ratingBoost * 8) +
                    int(Math.random() * 5);

                pitchLength =
                    1.58 -
                    ratingBoost * 0.16 +
                    Math.random() * 0.12;

                curveStrength =
                    (Math.random() - 0.5) * 10;

                verticalBreak =
                    8 +
                    Math.random() * 8;
            }
            else if (pitchType == "SLIDER") {
                pitchSpeed =
                    80 +
                    int(ratingBoost * 10) +
                    int(Math.random() * 6);

                pitchLength =
                    1.40 -
                    ratingBoost * 0.18 +
                    Math.random() * 0.09;

                curveStrength =
                    (
                        Math.random() < 0.5
                        ? -1
                        : 1
                    ) *
                    (
                        43 +
                        Math.random() * 17
                    );

                verticalBreak =
                    3 +
                    Math.random() * 6;
            }
            else if (pitchType == "SINKER") {
                pitchSpeed =
                    84 +
                    int(ratingBoost * 10) +
                    int(Math.random() * 6);

                pitchLength =
                    1.34 -
                    ratingBoost * 0.17 +
                    Math.random() * 0.08;

                curveStrength =
                    (Math.random() - 0.5) * 13;

                verticalBreak =
                    28 +
                    Math.random() * 18;
            }
            else {
                // CUTTER
                pitchSpeed =
                    86 +
                    int(ratingBoost * 11) +
                    int(Math.random() * 6);

                pitchLength =
                    1.29 -
                    ratingBoost * 0.16 +
                    Math.random() * 0.07;

                curveStrength =
                    (
                        Math.random() < 0.5
                        ? -1
                        : 1
                    ) *
                    (
                        19 +
                        Math.random() * 12
                    );

                verticalBreak =
                    2 +
                    Math.random() * 5;
            }

            // Frame measurements are documented in reference_visual/calibration097.
            pitchLength=PitchCadence.duration(pitchType,rating,Math.random(),GameData.matchLeagueIndex());
            if(GameData.matchLeagueIndex()==0){if(pitchType=="FASTBALL")pitchSpeed=82+int(Math.random()*5);else if(pitchType=="SINKER")pitchSpeed=76+int(Math.random()*5);}
            releaseDelay=PitchCadence.RELEASE_DELAY;
        }

        private function releasePitch():void {
            GameplayAudio.play(GameplayAudio.PITCH,.6);
            var hand:Point = pitcher.releasePosition();
            pitchStartX = hand.x;
            pitchStartY = hand.y;

            var command:Number =
                Math.max(
                    0.35,
                    Math.min(
                        0.95,
                        (int(opponent.rating) - 55) / 45.0
                    )
                );

            var strikeChance:Number =
                0.66 +
                command *
                0.10;

            if (balls >= 3) {
                strikeChance += 0.15;
            }
            else if (
                strikes >= 2
            ) {
                strikeChance -= 0.035;
            }

            strikeChance = Math.max(
                0.55,
                Math.min(
                    0.92,
                    strikeChance
                )
            );

            if (
                Math.random() <
                strikeChance
            ) {
                pitchEndX =
                    strikeZone.randomStrikeX(
                        command
                    );
                pitchEndY =
                    strikeZone.randomStrikeY(
                        command
                    );
            }
            else {
                var outside:Object =
                    strikeZone.randomBallPoint();

                pitchEndX =
                    Number(
                        outside.x
                    );

                pitchEndY =
                    Number(
                        outside.y
                    );
            }

            var effectiveContact:int =
                currentEffectiveContact();

            cursor.setTarget(
                pitchEndX,
                pitchEndY
            );

            cursor.setRadius(
                batting.targetRadiusForContact(
                    effectiveContact
                )
            );

            cursor.configureForPitch(
                effectiveContact,
                int(
                    opponent.rating
                ),
                GameData.matchLeagueIndex(),
                pitchType,pitchLength
            );

            cursor.setTimingProgress(0);
            cursor.setActive(true);

            ball.reset(pitchStartX, pitchStartY);

            elapsed = 0;
            pitchStart = getTimer();
            phase = PHASE_FLIGHT;
            hud.setPitchLabel(
                pitcherIdentity.name +
                "  ·  OBSERVA LA BOLA"
            );
        }

        private function loop(e:Event):void {
            if(worldLayer.visible&&!scorecard)updateStadium();
            if(referenceStadium)referenceStadium.advance(getTimer(),!scorecard&&worldLayer.visible&&phase!=PHASE_GAME_OVER&&!(phase==PHASE_SIMULATION&&simulationPanel.isPaused));
            if(scorecard)return;
            impactCues.advance();if(gameplayCallout)gameplayCallout.advance();
            if(scorecardButton){scorecardButton.visible=phase!=PHASE_GAME_OVER;scorecardButton.alpha=canInspect()?1:.4;scorecardButton.buttonMode=canInspect();}
            updateCamera();
            pitcherLabel.visible=pitcher.visible;
            pitcherLabel.alpha=pitcher.alpha;
            defendersLayer.visible = phase != PHASE_SIMULATION && phase != PHASE_HERO_INTRO;

            if (phase == PHASE_SIMULATION) {
                // Shift only simulation deadlines by the panel's accumulated pause.
                var pauseShift:int=simulationPanel.pausedDuration()-appliedSimulationPause;
                if(pauseShift>0){simulationNextAt+=pauseShift;if(pendingSimulationAction!=null)simulationResultUntil+=pauseShift;appliedSimulationPause+=pauseShift;}
                if(simulationPanel.isPaused)return;
                if(pendingSimulationAction!=null){
                    if(getTimer()>=simulationResultUntil){var next:Function=pendingSimulationAction;pendingSimulationAction=null;simulationResultUntil=0;next();}
                    return;
                }
                if (
                    getTimer() >=
                    simulationNextAt
                ) {
                    if (
                        simulationSide ==
                        "AWAY"
                    ) {
                        simulateOpponentPlateAppearance();
                    }
                    else {
                        simulateTeammatePlateAppearance();
                    }
                }

                return;
            }

            if (phase == PHASE_HERO_INTRO) {
                var reveal:Number=simulationPanel.heroReveal();
                batter.visible=pitcher.visible=strikeZone.visible=defendersLayer.visible=reveal>0;
                batter.alpha=pitcher.alpha=strikeZone.alpha=defendersLayer.alpha=reveal;
                if (
                    getTimer() >=
                    simulationNextAt
                ) {
                    preparePitchReady();
                }

                return;
            }

            if (phase == PHASE_READY) {
                return;
            }

            if (phase == PHASE_RESULT) {
                updateResultPhase();
                return;
            }

            if (phase == PHASE_WINDUP) {
                if ((getTimer() - phaseStart) / 1000.0 >= releaseDelay) {
                    releasePitch();
                }
                return;
            }

            if (phase != PHASE_FLIGHT) return;

            elapsed = (getTimer() - pitchStart) / 1000.0;

            var t:Number = Math.min(elapsed / pitchLength, BattingSystem.flightDeadline(pitchLength,GameData.matchLeagueIndex()));

            ball.setProgress(
                t,
                pitchStartX,
                pitchStartY,
                pitchEndX,
                pitchEndY,
                curveStrength,
                verticalBreak
            );

            hud.setPitchProgress(t);
            cursor.setTimingProgress(t);
            batter.setPitchProgress(t);

            if (elapsed/pitchLength >= BattingSystem.flightDeadline(pitchLength,GameData.matchLeagueIndex())) {
                phase = PHASE_RESULT;
                cursor.setActive(false);
                resolveTakenPitch();
            }
        }

        private function updateCamera():void {
            if (cameraShakeFrames > 0) {
                worldLayer.x = (Math.random() - 0.5) * cameraShakeAmount;
                worldLayer.y = (Math.random() - 0.5) * cameraShakeAmount;

                cameraShakeFrames--;

                if (cameraShakeFrames <= 0) {
                    worldLayer.x = 0;
                    worldLayer.y = 0;
                }
            }
        }

        private function playHitCinematic(
            result:String,
            runs:int,
            feet:int,
            showContactFirst:Boolean = false,
            flightAlreadyStarted:Boolean = false
        ):void {
            if(isHeroTurn())simulationPanel.recordBatterResult('HOME',currentBatterIndex,result);
            if(referenceStadium)referenceStadium.celebrate(result);
            if(showContactFirst) {
                for each(var fielder:Pitcher in defenders) fielder.reactHit((w*.61-fielder.x)/w,result=="FLY OUT"||result=="HOME RUN");
                hud.showBallInPlay(result);
                // F.A.F. 06:23.6 -> 06:24.8: hold the batting view before tracking the ball.
                pendingCinematic = {result:result,runs:runs,feet:feet,flightStarted:true};
                if(result.indexOf("OUT")<0)impactCues.enqueue(result=="HOME RUN"&&runs>=4?"grand_slam_story.mp3":"hit_flight.mp3",SwingMotion.CONTACT_MS+(result=="HOME RUN"&&runs>=4?1500:390),.60);
                contactViewUntil = getTimer() + SwingMotion.CONTACT_MS + 1200 + (result=="HOME RUN"?130:0);
                resultAutoAdvanceAt = 0;
                return;
            }
            if (!hitCinematic) {
                return;
            }

            worldLayer.visible = false;
            resultAutoAdvanceAt = 0;
            hitCinematic.play(
                result,
                runs,
                feet,
                {x:ball.x+worldLayer.x,y:ball.y+worldLayer.y,scale:ball.scaleX,rotation:ball.rotation},flightAlreadyStarted
            );

            // The cinematic is a full-screen result beat in Baseball Heroes.
            // Keep it above HUD/callouts so the supplied comic art cannot be
            // hidden behind interface layers.
            if (
                hitCinematic.parent == this
            ) {
                setChildIndex(
                    hitCinematic,
                    numChildren - 1
                );
                hud.setCinematic(true);
                setChildIndex(hud,numChildren-1);
            }
        }

        private function shake(frames:int, amount:Number):void {
            cameraShakeFrames = frames;
            cameraShakeAmount = amount;
        }

        private function keyUp(e:KeyboardEvent):void {if(e.keyCode==Keyboard.SPACE)spaceHeld=false;}
        private function releaseKeys(e:Event):void {spaceHeld=false;}
        private function keyDown(e:KeyboardEvent):void {
            if(e.keyCode==Keyboard.SPACE){e.preventDefault();if(spaceHeld)return;spaceHeld=true;}
            if(scorecard){if(e.keyCode==Keyboard.ESCAPE||e.keyCode==Keyboard.B||e.keyCode==Keyboard.ENTER)closeScorecard();return;}
            if(e.keyCode==Keyboard.B){openScorecard();return;}

            if (
                phase == PHASE_GAME_OVER &&
                e.keyCode == Keyboard.ENTER
            ) {
                returnHome();
                return;
            }

            if (e.keyCode == Keyboard.SPACE) {
                if (phase == PHASE_READY) {
                    startPitch();
                }
                else {
                    performSwing();
                }
            }
            else if (
                e.keyCode == Keyboard.ENTER &&
                phase == PHASE_RESULT
            ) {
                if(pendingCinematic) return;
                // Phase 8S: the first ENTER during a hit animation no longer
                // erases the cinematic before DOUBLE / TRIPLE / HOME RUN art
                // appears. It fast-forwards to the result card. A second ENTER
                // continues to the next batter/pitch.
                if (
                    hitCinematic &&
                    !hitCinematic.canContinue()
                ) {
                    impactCues.stopAll();
                    hitCinematic.forceResultVisible();
                    return;
                }

                continueResultFlow();
            }
        }

        private function updateResultPhase():void {
            if (phase != PHASE_RESULT) {
                return;
            }

            if(pendingCinematic) {
                if(getTimer() >= contactViewUntil) {
                    var queued:Object = pendingCinematic;
                    pendingCinematic = null;
                    contactViewUntil = 0;
                    playHitCinematic(queued.result,queued.runs,queued.feet,false,Boolean(queued.flightStarted));
                }
                return;
            }

            if (
                hitCinematic &&
                hitCinematic.visible
            ) {
                if (!hitCinematic.canContinue()) {
                    return;
                }

                if (resultAutoAdvanceAt <= 0) {
                    resultAutoAdvanceAt = getTimer() + 420;
                }
            }
            else if (resultAutoAdvanceAt <= 0) {
                // Walks and other non-cinematic results should also keep the
                // fast original cadence instead of waiting for ENTER.
                resultAutoAdvanceAt = getTimer() + 650;
            }

            if (
                resultAutoAdvanceAt > 0 &&
                getTimer() >= resultAutoAdvanceAt
            ) {
                continueResultFlow();
            }
        }

        private function continueResultFlow():void {
            if (phase != PHASE_RESULT) {
                return;
            }

            if(hitCinematic&&hitCinematic.visible&&(pendingAdvance||pendingEndPlayerInning)&&!hitCinematic.closeForHandoff())return;
            clearHitResultVisuals();
            if(checkWalkOff())return;

            if (pendingEndPlayerInning) {
                pendingEndPlayerInning = false;
                endPlayerInning();
                return;
            }

            if (pendingAdvance) {
                pendingAdvance = false;
                advanceBatter();
                beginCurrentTurn();
            }
            else {
                // Ball / called strike / foul: show the batting view again,
                // but do not let the pitcher throw until the user clicks or
                // presses SPACE once.
                preparePitchReady();
            }
        }

        private function onClick(e:MouseEvent):void {
            if(scorecard)return;
            if (!isHeroTurn()) {
                return;
            }

            if (phase == PHASE_READY) {
                startPitch();
                return;
            }

            if (phase != PHASE_FLIGHT) {
                return;
            }

            // During pitch flight CLICK and SPACE remain identical swing inputs.
            performSwing();
        }

        private function performSwing():void {
            if (phase != PHASE_FLIGHT || !isHeroTurn()) return;

            var swingT:Number=Math.max(0,Math.min(BattingSystem.flightDeadline(pitchLength,GameData.matchLeagueIndex()),(getTimer()-pitchStart)/1000.0/pitchLength));
            // Input and the displayed contact share one sample, even between two render frames.
            ball.setProgress(swingT,pitchStartX,pitchStartY,pitchEndX,pitchEndY,curveStrength,verticalBreak);
            batter.swing(ball.y);GameplayAudio.play(GameplayAudio.SWING,.55);batter.setPitchProgress(0);phase=PHASE_RESULT;cursor.setActive(false);

            resolve(swingT);
        }

        private function resolve(t:Number):void {
            var skillContact:int =
                GameData.skillContactBonus(
                    currentData,
                    inning,
                    homeScore,
                    awayScore
                );

            var skillPower:int =
                GameData.skillPowerBonus(
                    currentData,
                    inning,
                    homeScore,
                    awayScore
                );

            var effectiveContact:int =
                Math.min(
                    99,
                    player.contact +
                    momentum.contactBonus + skillContact +
                    GameData.specialComboContactBonus(true)
                );

            var effectivePower:int =
                Math.min(
                    99,
                    player.power +
                    momentum.powerBonus + skillPower
                );

            var result:String =
                batting.evaluateTiming(
                    t,
                    effectiveContact,
                    int(
                        opponent.rating
                    ),
                    GameData.matchLeagueIndex(),
                    pitchLength,GameData.skillFoulTolerance(currentData)
                );


            var quality:Number =
                batting.timingQuality(
                    t,
                    effectiveContact,
                    int(
                        opponent.rating
                    ),
                    GameData.matchLeagueIndex(),
                    pitchLength
                );

            var timingLabel:String =
                batting.timingLabel(
                    t,pitchLength
                );

            hud.setPitchLabel(
                pitchDisplayName() +
                "  ·  " +
                pitchSpeed +
                " MPH"
            );

            attempts++;

            if (result == "PERFECT") {
                hud.setResult("NICE!");

                if (gameplayCallout) {
                    gameplayCallout.show(
                        "NICE!",
                        0xd8fbff,
                        42,
                        -8,
                        batter.contactDelay
                    );
                }

                resolveBallInPlay(
                    result,
                    effectivePower,
                    effectiveContact,
                    true,
                    quality
                );
            }
            else if (result == "GOOD") {
                hud.setResult("NICE!");

                if (gameplayCallout) {
                    gameplayCallout.show(
                        "NICE!",
                        0xd8fbff,
                        42,
                        -8,
                        batter.contactDelay
                    );
                }

                resolveBallInPlay(
                    result,
                    effectivePower,
                    effectiveContact,
                    false,
                    quality
                );
            }
            else if (result == "FOUL") {
                if(strikes<2)strikes++;
                batter.holdContact(35);var foulPoint:Point=batter.contactPosition(),foulLead:int=batter.contactDelay;
                impactCues.enqueue(GameplayAudio.HERO_HIT,foulLead,.8);
                contact.burst(foulPoint.x,foulPoint.y,result,foulLead);
                ball.launchHit(result,effectivePower,35,foulLead,foulPoint.x,foulPoint.y);

                shake(4, 3);

                hud.setResult("FOUL");

                if (gameplayCallout) {
                    gameplayCallout.show(
                        "FOUL",
                        0xffa64d,
                        25,0,foulLead,pitchSpeed+" mph / "+pitchDisplayName()+"\n"+timingLabel
                    );
                }
                resultAutoAdvanceAt=getTimer()+foulLead+920;
            }
            else {
                strikes++;
                impactCues.enqueue(GameplayAudio.CATCH,250,.45);impactCues.enqueue(GameplayAudio.STRIKE,720);
                batter.queueReaction("MISS");

                if (strikes >= 3) {
                    completeStrikeout();
                }
                else {
                    resultAutoAdvanceAt=getTimer()+720+Math.ceil(GameplayAudio.duration(GameplayAudio.STRIKE))+80;
                    hud.setResult(
                        "STRIKE"
                    );

                    if (gameplayCallout) {
                        gameplayCallout.show(
                            "STRIKE",
                            0xff6a4f,
                            25,0,720,pitchSpeed+" mph / "+pitchDisplayName()+"\n"+timingLabel
                        );
                    }
                }
            }

            updateHud();
        }

        private function resolveTakenPitch():void {
            GameplayAudio.play(GameplayAudio.CATCH,.45);
            batter.setPitchProgress(0);

            hud.setPitchLabel(
                pitchDisplayName() +
                "  ·  " +
                pitchSpeed +
                " MPH"
            );

            var strike:Boolean =
                isPitchInStrikeZone();

            if (strike) {
                strikes++;
                impactCues.enqueue(GameplayAudio.STRIKE,470);

                if (strikes >= 3) {
                    completeStrikeout();
                }
                else {
                    resultAutoAdvanceAt=getTimer()+470+Math.ceil(GameplayAudio.duration(GameplayAudio.STRIKE))+80;
                    hud.setResult(
                        "CALLED STRIKE"
                    );

                    if (gameplayCallout) {
                        gameplayCallout.show(
                            "STRIKE",
                            0xff6a4f,
                            25,0,470,pitchSpeed+" mph / "+pitchDisplayName()
                        );
                    }
                }
            }
            else {
                balls++;

                if (balls >= 4) {
                    completeWalk();
                }
                else {
                    impactCues.enqueue(GameplayAudio.BALL,270,.55);
                    resultAutoAdvanceAt=getTimer()+270+Math.ceil(GameplayAudio.duration(GameplayAudio.BALL))+80;
                    hud.setResult("BALL");

                    if (gameplayCallout) {
                        gameplayCallout.show(
                            "BALL",
                            0x8fd7ff,
                            30,0,270,pitchSpeed+" mph / "+pitchDisplayName()
                        );
                    }
                }
            }

            updateHud();
        }

        private function isPitchInStrikeZone():Boolean {
            return strikeZone != null &&
                   strikeZone.containsWorldPoint(
                       pitchEndX,
                       pitchEndY
                   );
        }

        private function resolveBallInPlay(
            timing:String,
            effectivePower:int,
            effectiveContact:int,
            perfect:Boolean,
            timingQuality:Number
        ):void {
            var hitType:String =
                determineHitType(
                    timing,
                    effectivePower,
                    effectiveContact,
                    Math.min(
                        99,
                        GameData.matchLuck(
                            currentData
                        ) +
                        GameData.specialComboLuckBonus(true)
                    ),
                    timingQuality
                );

            hitType=momentum.resultOnContact(hitType);
            var contactHold:int=hitType=="HOME RUN"?130:45;
            batter.holdContact(contactHold);var impact:Point=batter.contactPosition(),lead:int=batter.contactDelay;
            impactCues.enqueue(hitType=="HOME RUN"?GameplayAudio.HERO_HOME_RUN:hitType=="OUT"?GameplayAudio.OUT_HIT:GameplayAudio.HERO_HIT,lead);
            contact.burst(impact.x,impact.y,timing,lead);
            ball.launchHit(timing,effectivePower,contactHold,lead,impact.x,impact.y);

            if (hitType == "OUT") {
                boxScore.record(currentBatterIndex,currentData,"OUT",0);
                scorePlay("OUT",0,true);
                gameAtBats++;
                outs++;

                GameData.recordPlateAppearance(
                    currentData,
                    false,
                    false,
                    0
                );

                pendingAdvance = true;
                balls = 0;
                strikes = 0;

                shake(3, 2);

                var outLabel:String =
                    Math.random() < 0.52
                    ? "FLY OUT"
                    : "GROUND OUT";

                hud.setResult("");
                playHitCinematic(
                    outLabel,
                    0,
                    0,
                    true
                );

                batter.queueReaction("OUT");
                pitcher.reactSuccess();

                if (outs >= 3) {
                    pendingEndPlayerInning = true;
                }

                return;
            }

            var bases:int = 1;

            if (hitType == "DOUBLE") {
                bases = 2;
            }
            else if (hitType == "TRIPLE") {
                bases = 3;
            }
            else if (hitType == "HOME RUN") {
                bases = 4;
            }

            var runnersBefore:Array=baseRunners.concat();
            var rbi:int =
                advanceRunnersOnHit(
                    bases,
                    currentData
                );

            hud.animatePlay(runnersBefore,baseRunners.concat(),currentData,bases);
            player.hits++;
            gameHits++;
            gameAtBats++;

            incrementGameMap(
                gameHitMap,
                String(currentData.name)
            );

            var homeRun:Boolean =
                hitType == "HOME RUN";

            if (homeRun) {
                player.hr++;
                gameHomeRuns++;

                incrementGameMap(
                    gameHrMap,
                    String(currentData.name)
                );
            }

            gameRbi += rbi;
            boxScore.record(currentBatterIndex,currentData,hitType,rbi,pitchType);
            scorePlay(hitType,rbi,true);

            GameData.recordPlateAppearance(
                currentData,
                true,
                homeRun,
                rbi,
                hitType
            );

            pendingAdvance = true;
            balls = 0;
            strikes = 0;

            shake(
                perfect ? 10 : 7,
                perfect ? 8 : 5
            );

            hud.setResult("");
            hud.addHeroHitHistory(hitType, rbi);

            var activeSkill:String = GameData.activeSkillId(currentData);
            if (activeSkill == "POWER_HITTER") {
                gameplayCallout.show("POWER HIT", 0xffd43b, 34,0,lead);
                impactCues.enqueue("power_hit.mp3", SwingMotion.CONTACT_MS, 0.88);
            }
            else if (Math.random() < GameData.skillLuckyChance(currentData)) {
                scoring.luckyHits++;feedback.progress("LUCKY HITTER",int(GameData.hallOfFame.stats.luckyHits)+scoring.luckyHits,25);feedback.show("LUCKY HIT  ♣","¡Lucky Hit! Aprovecha a tus corredores en base.");gameplayCallout.show("LUCKY HIT", 0xb7ef3b, 34,0,lead);
                impactCues.enqueue("lucky_hit.mp3", SwingMotion.CONTACT_MS, 0.88);
            }

            var feet:int = 0;
            if (hitType == "HOME RUN") {
                feet = 300 + int(effectivePower * 1.55) + int(Math.random() * 55);
                // The native fanfare belongs to the result stamp, after the flight.
                // HitCinematic owns it so skipping/leaving cannot leave music behind.
            }

            playHitCinematic(
                hitType,
                rbi,
                feet,
                true
            );

            batter.queueReaction(hitType);
            pitcher.reactHit();
        }

        private function determineHitType(
            timing:String,
            power:int,
            contactValue:int,
            luckValue:int,
            timingQuality:Number
        ):String {
            var roll:Number =
                Math.random();

            if (timing == "GOOD") {
                var outChance:Number =
                    0.18 +
                    (
                        int(opponent.rating) -
                        contactValue
                    ) *
                    0.004;

                outChance =
                    Math.max(
                        0.07,
                        Math.min(
                            0.34,
                            outChance
                        )
                    );

                if (roll < outChance) {
                    return "OUT";
                }

                roll =
                    (
                        roll -
                        outChance
                    ) /
                    (
                        1.0 -
                        outChance
                    );
            }

            var hrChance:Number =
                (
                    timing == "PERFECT"
                    ? 0.13
                    : 0.025
                ) +
                Math.max(
                    0,
                    luckValue - 65
                ) *
                0.0013 +
                Math.max(
                    0,
                    power - 65
                ) *
                (
                    timing == "PERFECT"
                    ? 0.008
                    : 0.0025
                );

            timingQuality = Math.max(
                0,
                Math.min(
                    1,
                    timingQuality
                )
            );

            hrChance *=
                0.58 +
                timingQuality *
                0.62;

            hrChance =
                Math.min(
                    timing == "PERFECT"
                        ? 0.44
                        : 0.12,
                    hrChance
                );

            var tripleChance:Number =
                0.025 +
                Math.max(
                    0,
                    player.speed - 65
                ) *
                0.0022;

            tripleChance =
                Math.min(
                    0.12,
                    tripleChance
                );

            var doubleChance:Number =
                (
                    timing == "PERFECT"
                    ? 0.25
                    : 0.17
                ) *
                (
                    0.70 +
                    timingQuality *
                    0.40
                );

            tripleChance=Math.min(.18,tripleChance+GameData.skillTripleBonus(currentData));
            doubleChance=Math.min(.40,doubleChance+GameData.skillDoubleBonus(currentData));
            if (roll < hrChance) {
                return "HOME RUN";
            }

            if (
                roll <
                hrChance +
                tripleChance
            ) {
                return "TRIPLE";
            }

            if (
                roll <
                hrChance +
                tripleChance +
                doubleChance
            ) {
                return "DOUBLE";
            }

            return "SINGLE";
        }

        private function advanceRunnersOnHit(
            bases:int,
            batterData:Object
        ):int {
            var runs:int = 0;

            if (bases >= 4) {
                for (
                    var h:int = 0;
                    h < 3;
                    h++
                ) {
                    if (baseRunners[h]) {
                        runs++;
                    }
                }

                runs++;
                clearBases();
                homeScore += runs;

                return runs;
            }

            var newBases:Array = [
                null,
                null,
                null
            ];

            // Existing runners advance from third to first.
            for (
                var i:int = 2;
                i >= 0;
                i--
            ) {
                var runner:Object =
                    baseRunners[i];

                if (!runner) continue;

                var target:int =
                    i + bases;

                // A runner on second may score on a strong single.
                if (
                    bases == 1 &&
                    i == 1
                ) {
                    var scoreChance:Number =
                        0.48 +
                        Math.max(
                            0,
                            int(runner.speed) - 60
                        ) *
                        0.006;

                    if (
                        Math.random() <
                        Math.min(
                            0.82,
                            scoreChance
                        )
                    ) {
                        runs++;
                        continue;
                    }
                }

                // Runner on first may score on a double.
                if (
                    bases == 2 &&
                    i == 0
                ) {
                    var firstScoreChance:Number =
                        0.34 +
                        Math.max(
                            0,
                            int(runner.speed) - 60
                        ) *
                        0.006;

                    if (
                        Math.random() <
                        Math.min(
                            0.74,
                            firstScoreChance
                        )
                    ) {
                        runs++;
                        continue;
                    }
                }

                if (target >= 3) {
                    runs++;
                }
                else {
                    newBases[target] =
                        runner;
                }
            }

            var batterTarget:int =
                bases - 1;

            if (batterTarget >= 3) {
                runs++;
            }
            else {
                newBases[batterTarget] =
                    batterData;
            }

            baseRunners = newBases;
            if(inning>=9&&simulationSide=="HOME")runs=Math.min(runs,Math.max(0,awayScore-homeScore+1));
            homeScore += runs;

            return runs;
        }

        private function completeWalk():void {
            impactCues.enqueue(GameplayAudio.WALK,0,.6);
            simulationPanel.recordBatterResult('HOME',currentBatterIndex,'WALK');
            var rbi:int = 0;

            if (baseRunners[0]) {
                if (baseRunners[1]) {
                    if (baseRunners[2]) {
                        homeScore++;
                        gameRbi++;
                        rbi = 1;
                    }

                    baseRunners[2] =
                        baseRunners[1];
                }

                baseRunners[1] =
                    baseRunners[0];
            }

            baseRunners[0] =
                currentData;

            boxScore.record(currentBatterIndex,currentData,"WALK",rbi);
            scorePlay("WALK",rbi,true);
            GameData.recordWalk(
                currentData,
                rbi
            );

            pendingAdvance = true;
            balls = 0;
            strikes = 0;

            hud.setResult(
                rbi > 0
                    ? "WALK - RBI!"
                    : "WALK"
            );

            if (gameplayCallout) {
                gameplayCallout.show(
                    rbi > 0
                    ? "BASE ON BALLS + RBI"
                    : "BASE ON BALLS",
                    0x8fd7ff,
                    30
                );
            }

            resultAutoAdvanceAt = getTimer() + Math.max(1100,Math.ceil(GameplayAudio.duration(GameplayAudio.WALK))+80);
            batter.queueReaction("WALK");
        }

        private function completeStrikeout():void {
            starterHadStrikeout=true;momentum.strikeout();
            boxScore.record(currentBatterIndex,currentData,"STRIKE OUT",0);
            scorePlay("STRIKE OUT",0,true);
            balls = 0;
            strikes = 0;
            outs++;
            gameAtBats++;

            GameData.recordPlateAppearance(
                currentData,
                false,
                false,
                0
            );

            pendingAdvance = true;

            hud.setResult("");

            playHitCinematic(
                "STRIKE OUT",
                0,
                0
            );

            batter.queueReaction("STRIKEOUT");
            pitcher.reactSuccess();

            if (outs >= 3) {
                pendingEndPlayerInning = true;
            }
        }

        private function clearBases():void {
            baseRunners = [
                null,
                null,
                null
            ];
        }

        private function incrementGameMap(
            map:Object,
            key:String
        ):void {
            if (map[key] === undefined) {
                map[key] = 0;
            }

            map[key] =
                int(map[key]) + 1;
        }


        private function endPlayerInning():void {
            homeLine[inning - 1] =
                Math.max(
                    0,
                    homeScore - homeHalfStartScore
                );

            // If the user's manual PA produced the third out, advance the
            // batting order before leaving the half-inning.
            if (pendingAdvance) {
                pendingAdvance = false;
                advanceBatter();
            }

            outs = 0;
            balls = 0;
            strikes = 0;
            clearBases();

            simulationPanel.setBases(
                false,
                false,
                false
            );

            if (
                inning >= 9 &&
                homeScore !=
                awayScore
            ) {
                finishGame();
                return;
            }

            inning++;

            hud.setResult("");
            hud.setPitchLabel(
                inning > 9
                ? "EXTRA INNING"
                : "INNING " +
                  inning
            );

            startOpponentSimulation();
        }

        private function simulateOpponentRuns():int {
            var runs:int = 0;

            var main:Object =
                GameData.mainPlayer();

            var defense:Number =
                (
                    GameData.matchContact(main) +
                    GameData.matchSpeed(main)
                ) / 2.0;

            var chance:Number =
                0.34 +
                GameData.matchLeagueIndex() * 0.035 -
                (defense - 70) * 0.0025;

            chance -=
                GameData.skillDefenseBonus(
                    mainData
                );

            chance =
                Math.max(
                    0.10,
                    Math.min(
                        0.55,
                        chance
                    )
                );

            if (Math.random() < chance) {
                runs++;
            }

            if (
                Math.random() <
                chance * 0.42
            ) {
                runs++;
            }

            return runs;
        }

        private function finishGame():void {
            if (phase == PHASE_GAME_OVER) {
                return;
            }

            phase = PHASE_GAME_OVER;

            cursor.setActive(false);
            ball.hideBall();

            var scoreData:Object=scoring.snapshot();
            scoreData.walkOff=walkOff;
            scoreData.awayHits=opponentHits;
            scoreData.fixtureKey=GameData.specialMatch?String(GameData.specialMatch.key):"";
            var summary:Object =
                (GameData.postSeasonMode?GameData.completePostSeasonGame:GameData.completeSeasonGame)(
                    homeScore,
                    awayScore,
                    gameHits,
                    gameHomeRuns,
                    gameAtBats,
                    gameRbi,
                    homeLine,
                    awayLine,
                    boxScore.snapshot(),
                    scoreData
                );

            updateHud();

            hud.setResult("");
            hud.setPitchLabel("GAME OVER");
            hud.setCinematic(true,false);
            simulationPanel.hidePanel();

            if(walkOff||(summary&&summary.postStatus=="champion")){
                victory=new MatchVictory(w,h,summary.postStatus=="champion"?"WORLD CHAMPION!":"WALK-OFF WIN",function():void{
                    if(victory){victory.dispose();if(victory.parent)removeChild(victory);victory=null;}
                    showMatchResult(summary);
                });addChild(victory);
            }else showMatchResult(summary);
        }
        private function showMatchResult(summary:Object):void {
            resultPanel=new GameResultPanel(w,h,summary,returnHome,returnNextMatch);addChild(resultPanel);
            dispatchEvent(new Event("match-finished"));
        }
        private function checkWalkOff():Boolean {
            if(phase==PHASE_GAME_OVER)return true;
            if(simulationSide=="AWAY"||inning<9||homeScore<=awayScore)return false;
            walkOff=true;homeLine[inning-1]=Math.max(0,homeScore-homeHalfStartScore);
            pendingSimulationAction=null;pendingAdvance=false;pendingEndPlayerInning=false;
            finishGame();return true;
        }
        private function scorePlay(result:String,rbi:int,hero:Boolean,luck:int=-1):void {
            if(hero&&/SINGLE|DOUBLE|TRIPLE|HOME RUN/.test(result))starterHadHit=true;
            var event:Object=scoring.record(result,rbi,hero);
            var usedMax:Boolean=hero&&result=="HOME RUN"&&momentum.consumeMax();
            lastComboGain=usedMax?0:momentum.gain(result,luck>=0?luck:GameData.matchLuck(currentData)+(hero?GameData.specialComboLuckBonus(true):0));if(hero&&!usedMax&&/SINGLE|DOUBLE|TRIPLE|HOME RUN/.test(result))lastComboGain+=momentum.boost(GameData.skillComboBonus(currentData));hud.setMomentum(momentum.snapshot());simulationPanel.setMomentum(momentum.snapshot());if(batter)batter.setMomentum(momentum.tier,momentum.comeback);
            hud.setLiveRewards(scoring.playCoins,scoring.playXP);simulationPanel.setLiveRewards(scoring.playCoins,scoring.playXP);
            if(hero){
                var stat:String=result=="SINGLE"?"singles":result=="DOUBLE"?"doubles":result=="TRIPLE"?"triples":result=="HOME RUN"?"homeRuns":result=="WALK"?"walks":"";
                var achievement:Object=CareerAchievements.byId(stat);
                if(achievement){
                    var count:int=int(GameData.hallOfFame.stats[stat])+boxScore.heroValue(stat),target:int=achievement.targets[3];
                    for each(var goal:int in achievement.targets)if(count<=goal){target=goal;break;}
                    feedback.progress(stat=="singles"?"MR. SINGLE":String(achievement.title),count,target);feedback.show((stat=="singles"?"MR. SINGLE":String(achievement.title))+"  "+count+" / "+target,event.hitStreak>=2?event.hitStreak+" consecutive hits · ×"+event.multiplier+" · +"+event.coins+" coins":"Termina el partido para guardar este avance.");
                }
            }
            if(hero)feedback.progress("HARDWORKING HITTER",int(GameData.hallOfFame.stats.heroAttempts)+scoring.heroAttempts,500);
            if(hero)hitCinematic.setPoints(event.points,event.multiplier,event.hitStreak,event.hrStreak);
            hud.setLiveScore(scoring.points,event.points,event.multiplier);
            simulationPanel.setLiveScore(scoring.points);
        }

        private function returnHome():void {
            if (onHome != null) {
                onHome();
            }
        }

        private function returnNextMatch():void {
            if (onNextMatch != null) {
                onNextMatch();
            }
            else if (onHome != null) {
                onHome();
            }
        }

        private function updateStadium():void {
            var displayedBatter:Object=simulationSide=="AWAY"&&simulationPanel?simulationPanel.opponentPlayerAt(opponentBatterIndex):currentData;
            if(referenceStadium)referenceStadium.setMatch(homeScore,awayScore,inning,simulationSide,displayedBatter?String(displayedBatter.name):"");
        }
        private function updateHud():void {
            updateStadium();
            // Simulation owns its resource bar; never draw two HUDs at once.
            hud.visible = phase != PHASE_SIMULATION && phase != PHASE_HERO_INTRO;
            if(hud.visible) {
                hud.setLiveRewards(scoring.playCoins,scoring.playXP,phase==PHASE_GAME_OVER);hud.setMatchProgress(gameHits,gameHomeRuns,gameRbi,phase==PHASE_GAME_OVER,boxScore.heroValue("hits"),boxScore.heroValue("rbi"));
                hud.refresh(player);
                hud.setHalfInning(simulationSide=="AWAY");
                hud.setGameState(
                    homeScore,
                    awayScore,
                    inning,
                    balls,
                    strikes,
                    outs,
                    attempts
                );

                var currentGameHits:int =
                    gameHitMap[
                        String(currentData.name)
                    ] !== undefined
                    ? int(
                        gameHitMap[
                            String(currentData.name)
                        ]
                    )
                    : 0;

                hud.setBatterCareer(
                    currentData,
                    currentGameHits
                );

                hud.setBases(
                    baseRunners[0] != null,
                    baseRunners[1] != null,
                    baseRunners[2] != null
                );

            }

            if (simulationPanel) {
                simulationPanel.setHits(gameHits,opponentHits);
                simulationPanel.setHalfInning(
                    simulationSide,
                    inning
                );

                simulationPanel.setScore(
                    homeScore,
                    awayScore,
                    inning,
                    simulationSide ==
                    "AWAY"
                    ? opponentOuts
                    : outs
                );

                simulationPanel.setBases(
                    simulationSide ==
                    "AWAY"
                    ? opponentBases[0] != null
                    : baseRunners[0] != null,
                    simulationSide ==
                    "AWAY"
                    ? opponentBases[1] != null
                    : baseRunners[1] != null,
                    simulationSide ==
                    "AWAY"
                    ? opponentBases[2] != null
                    : baseRunners[2] != null
                );
            }

            updateBatterContext();
        }

        public function handleMatchEscape():Boolean {if(!scorecard)return false;closeScorecard();return true;}
        private function canInspect():Boolean {return phase==PHASE_SIMULATION||phase==PHASE_READY;}
        private function openScorecard(e:MouseEvent=null):void {
            if(e)e.stopPropagation();if(scorecard||!canInspect())return;
            inspectionWasPaused=phase==PHASE_SIMULATION?simulationPanel.pauseForInspection():false;
            scorecard=new LiveMatchScorecard(w,h,liveMatchSnapshot(),closeScorecard);addChild(scorecard);if(stage)stage.focus=this;
        }
        private function closeScorecard():void {
            if(!scorecard)return;scorecard.dispose();removeChild(scorecard);scorecard=null;
            if(phase==PHASE_SIMULATION)simulationPanel.resumeAfterInspection(inspectionWasPaused);if(stage)stage.focus=this;
        }
        /** Read-only view used by the in-match scorecard; never commits a match. */
        public function liveMatchSnapshot():Object {
            var home:Array=homeLine.concat(),away:Array=awayLine.concat();
            if(simulationSide=="HOME")home[inning-1]=Math.max(0,homeScore-homeHalfStartScore);else away[inning-1]=Math.max(0,awayScore-awayHalfStartScore);
            return {home:boxScore.snapshot(),away:opponentBoxScore?opponentBoxScore.snapshot():[],homeLine:home,awayLine:away,homeName:GameData.teamCity,awayName:String(opponent.city),homeScore:homeScore,awayScore:awayScore,homeHits:gameHits,awayHits:opponentHits,inning:inning,side:simulationSide,phase:phase,paused:scorecard!=null||phase==PHASE_SIMULATION&&simulationPanel.isPaused,pitchElapsed:elapsed};
        }
        public function dispose():void {
            impactCues.dispose();
            if(scorecard){scorecard.dispose();removeChild(scorecard);scorecard=null;}if(scorecardButton){scorecardButton.removeEventListener(MouseEvent.CLICK,openScorecard);scorecardButton.dispose();}

            if(starterCoach){starterCoach.dispose();starterCoach=null;}
            pendingSimulationAction=null;
            simulationResultUntil=0;
            pendingCinematic = null;
            contactViewUntil = 0;
            if(victory){victory.dispose();victory=null;}
            if(feedback)feedback.dispose();if(hud) hud.dispose();
            removeEventListener(Event.ENTER_FRAME, loop);
            removeEventListener(MouseEvent.CLICK, onClick);
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            if (stage) {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
                stage.removeEventListener(KeyboardEvent.KEY_UP,keyUp);stage.removeEventListener(Event.DEACTIVATE,releaseKeys);
            }

            worldLayer.x = 0;
            worldLayer.y = 0;

            if (referenceStadium) {
                referenceStadium.dispose();
                referenceStadium = null;
            }

            if (ball) {
                ball.dispose();
            }

            if (batter) {
                batter.dispose();
            }

            if (pitcher) {
                pitcher.dispose();
            }
            for each(var defender:Pitcher in defenders) defender.dispose();
            defenders = [];

            if (cursor) {
                cursor.dispose();
            }

            if (contact) {
                contact.dispose();
            }

            if (hitCinematic) {
                hitCinematic.dispose();
            }

            if (gameplayCallout) {
                gameplayCallout.dispose();
            }

            if (resultPanel) {
                resultPanel.dispose();
            }

            if (simulationPanel) {
                simulationPanel.dispose();
                simulationPanel.hidePanel();
            }
        }
    }
}


