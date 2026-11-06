package com.bh {
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;

    import com.bh.core.Game;
    import com.bh.model.GameData;
    import com.bh.ui.LobbyScreen;
    import com.bh.ui.TeamScreen;
    import com.bh.ui.TrainingScreen;
    import com.bh.ui.ScoutScreen;
    import com.bh.ui.EquipmentScreen;
    import com.bh.ui.ShopScreen;
    import com.bh.ui.BuildScreen;
    import com.bh.ui.SkillScreen;
    import com.bh.ui.PregameScreen;
    import com.bh.ui.LineupScreen;
    import com.bh.ui.SpecialCardsScreen;
    import com.bh.ui.SeasonGoalScreen;
    import com.bh.ui.TeamSelectionScreen;
    import com.bh.ui.TeamNameScreen;
    import com.bh.ui.CharacterMakerScreen;
    import com.bh.ui.MissionsScreen;
    import com.bh.ui.HallOfFameScreen;
    import com.bh.ui.MysteryInventoryScreen;
    import com.bh.ui.TradeEnhanceScreen;
    import com.bh.ui.SeasonRoadmapScreen;
    import com.bh.ui.TravelMapScreen;
    import com.bh.ui.MatchIntroScreen;
    import com.bh.ui.ModeSelectScreen;
    import com.bh.ui.PostSeasonScreen;
    import com.bh.ui.OnlineLobbyScreen;
    import com.bh.ui.SocialScreen;
    import com.bh.ui.FriendVisitScreen;
    import com.bh.ui.MatchSocialBar;
    import com.bh.online.OnlineClient;
    import com.bh.online.FriendInvite;
    import com.bh.ui.HomeRunDerbyScreen;
    import com.bh.ui.ArrivalMapScreen;
    import com.bh.ui.RoadmapToMajorScreen;
    import com.bh.audio.AudioManager;
    import com.bh.ui.MenuEntrance;

    public class Main extends Sprite {
        private static const GAME_W:Number = 960;
        private static const GAME_H:Number = 720;
        private static const MATCH_H:Number = GAME_H-MatchSocialBar.HEIGHT;

        private var currentScreen:Sprite;
        private var menuEntrance:MenuEntrance;
        private var rootContainer:Sprite;
        private var backgroundLayer:Sprite;
        private var matchSocial:MatchSocialBar;

        public function Main() {
            super();

            if (stage) {
                init();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            }
        }

        private function onAddedToStage(e:Event):void {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            init();
        }

        private function init():void {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            backgroundLayer = new Sprite();
            addChild(backgroundLayer);

            rootContainer = new Sprite();
            rootContainer.addEventListener(Event.ADDED,onScreenAdded);
            addChild(rootContainer);

            stage.addEventListener(
                Event.RESIZE,
                onStageResize
            );

            GameData.init();

            stage.addEventListener(
                KeyboardEvent.KEY_DOWN,
                onGlobalKeyDown
            );

            layoutStage();

            if (GameData.onboardingActive()) {
                resumeFirstGameExperience();
            }
            else if(GameData.tutorialActive()&&GameData.starterTutorial.stage<=6){showLineupFromPregame();}
            else if (GameData.seasonComplete || GameData.seasonGoalSet) {
                showLobby();
            }
            else {
                showSeasonGoal(showPregame);
            }
        }

        private function onScreenAdded(e:Event):void {
            if(e.target!==currentScreen||currentScreen.parent!==rootContainer)return;
            if(currentScreen is Game||currentScreen is SeasonRoadmapScreen||currentScreen is LineupScreen||currentScreen is TravelMapScreen||currentScreen is ArrivalMapScreen||currentScreen is MatchIntroScreen)return;
            if(menuEntrance)menuEntrance.dispose();menuEntrance=new MenuEntrance(currentScreen);menuEntrance.track(currentScreen,0,240,0,8);menuEntrance.play();
        }
        private function onStageResize(e:Event):void {
            layoutStage();
        }

        private function layoutStage():void {
            if (!stage || !backgroundLayer || !rootContainer) {
                return;
            }

            backgroundLayer.graphics.clear();
            backgroundLayer.graphics.beginFill(0x000000);
            backgroundLayer.graphics.drawRect(
                0,
                0,
                stage.stageWidth,
                stage.stageHeight
            );
            backgroundLayer.graphics.endFill();

            var contentHeight:Number=GAME_H;
            stage.frameRate=currentScreen is Game?60:30;
            var scale:Number = Math.min(
                stage.stageWidth / GAME_W,
                stage.stageHeight / contentHeight
            );

            scale = Math.min(
                1,
                scale
            );

            rootContainer.scaleX = scale;
            rootContainer.scaleY = scale;

            rootContainer.x = Math.round(
                (stage.stageWidth - GAME_W * scale) / 2
            );

            rootContainer.y = Math.round(
                (stage.stageHeight - contentHeight * scale) / 2
            );
        }

        private function resumeFirstGameExperience():void {
            if (GameData.onboardingStep == GameData.ONBOARDING_TEAM) {
                showOnboardingTeamSelection();
            }
            else if (GameData.onboardingStep == GameData.ONBOARDING_CHARACTER) {
                showOnboardingCharacterMaker();
            }
            else if (GameData.onboardingStep == GameData.ONBOARDING_ARRIVAL) {
                showFirstArrival();
            }
            else if (GameData.onboardingStep == GameData.ONBOARDING_HOME) {
                showLobby();
            }
            else if (GameData.onboardingStep == GameData.ONBOARDING_GOAL) {
                showSeasonGoal();
            }
            else if (GameData.onboardingStep == GameData.ONBOARDING_ROADMAP) {
                showPregame();
            }
            else if (GameData.onboardingStep == GameData.ONBOARDING_TRAVEL) {
                showTravelMap();
            }
            else if (GameData.onboardingStep == GameData.ONBOARDING_LINEUP) {
                showLineupFromPregame();
            }
            else {
                GameData.completeOnboarding();
                showLobby();
            }
        }

        private function showOnboardingTeamSelection():void {
            if(!GameData.teamSelectionOpen()){resumeFirstGameExperience();return;}
            clearCurrentScreen();
            AudioManager.playMusic("locker_room");

            var select:TeamSelectionScreen =
                new TeamSelectionScreen(
                    GAME_W,
                    GAME_H,
                    onFirstTeamSelected,
                    skipFirstGameTutorial
                );

            currentScreen = select;
            rootContainer.addChild(currentScreen);
        }

        private function onFirstTeamSelected():void {
            GameData.setOnboardingStep(
                GameData.ONBOARDING_CHARACTER
            );
            showOnboardingCharacterMaker();
        }

        private function showOnboardingCharacterMaker():void {
            if(!GameData.characterCreationOpen()){resumeFirstGameExperience();return;}
            clearCurrentScreen();
            AudioManager.playMusic("locker_room");

            var maker:CharacterMakerScreen =
                new CharacterMakerScreen(
                    GAME_W,
                    GAME_H,
                    onFirstCharacterDone,
                    null
                );

            currentScreen = maker;
            rootContainer.addChild(currentScreen);
        }

        private function onFirstCharacterDone():void {
            GameData.setOnboardingStep(
                GameData.ONBOARDING_ARRIVAL
            );
            showFirstArrival();
        }

        private function showFirstArrival():void {
            clearCurrentScreen();
            AudioManager.playMusic("baseball_heroes");

            var arrival:ArrivalMapScreen =
                new ArrivalMapScreen(
                    GAME_W,
                    GAME_H,
                    onFirstArrivalDone
                );

            currentScreen = arrival;
            rootContainer.addChild(currentScreen);
        }

        private function onFirstArrivalDone():void {
            GameData.setOnboardingStep(
                GameData.ONBOARDING_HOME
            );
            showLobby();
        }

        private function onLobbyPlay():void {
            if (
                GameData.onboardingStep ==
                GameData.ONBOARDING_HOME
            ) {
                GameData.setOnboardingStep(
                    GameData.ONBOARDING_GOAL
                );
                showSeasonGoal();
                return;
            }

            showPregame();
        }

        private function onSeasonGoalDone():void {
            if (
                GameData.onboardingStep ==
                GameData.ONBOARDING_GOAL
            ) {
                GameData.setOnboardingStep(
                    GameData.ONBOARDING_ROADMAP
                );
                showPregame();
                return;
            }

            showLobby();
        }

        private function onRoadmapContinue():void {
            if (GameData.seasonComplete) {
                if(GameData.postSeasonInProgress()){showPostSeason();return;}
                if (GameData.prepareNextSeason()) showSeasonGoal(showPregame);
                return;
            }
            if (redirectSeasonSetup()) return;
            if (
                GameData.onboardingStep ==
                GameData.ONBOARDING_ROADMAP
            ) {
                GameData.setOnboardingStep(
                    GameData.ONBOARDING_TRAVEL
                );
            }

            // The first gameplay travels to the opponent after the season card
            // selection. Apply the same flow to all regular-season games.
            showTravelMap();
        }

        private function onTravelComplete():void {
            if (
                GameData.onboardingStep ==
                GameData.ONBOARDING_TRAVEL
            ) {
                GameData.setOnboardingStep(
                    GameData.ONBOARDING_LINEUP
                );
            }

            showLineupFromPregame();
        }

        private function replayFirstGameTutorial():void {
            GameData.restartOnboarding();
            resumeFirstGameExperience();
        }

        private function skipFirstGameTutorial():void {
            GameData.completeOnboarding();
            showLobby();
        }

        private function showLobby():void {
            if(FriendInvite.pending.length&&GameData.onboardingStep>=GameData.ONBOARDING_HOME){showHomeFriends();return;}
            clearCurrentScreen();
            GameData.postSeasonMode=false;

            AudioManager.playMusic("baseball_heroes");

            var lobby:LobbyScreen = new LobbyScreen(
                GAME_W,
                GAME_H,
                onLobbyPlay,
                showTeam,
                showFriendDraft,
                showShop,
                showBuild,
                showMissions,
                null,
                null,
                showSeasonGoal,
                showTeamName,
                showModes,
                showRoadmapToMajor,
                showLineup,
                showHomeTraining,
                showHallOfFame,
                showHomeFriends,
                showFriendVisit
            );

            currentScreen = lobby;
            rootContainer.addChild(currentScreen);
            layoutStage();
        }

        private function showFriendVisit(id:String):void {
            clearCurrentScreen();currentScreen=new FriendVisitScreen(new OnlineClient(),id,showLobby,showFriendVisit);
            rootContainer.addChild(currentScreen);layoutStage();
        }
        private function showHomeFriends(initialTab:String="FRIENDS"):void {
            clearCurrentScreen();currentScreen=new SocialScreen(new OnlineClient(),showLobby,initialTab,FriendInvite.consume(),showFriendVisit);
            rootContainer.addChild(currentScreen);layoutStage();
        }
        private function showModes():void {
            clearCurrentScreen();
            GameData.postSeasonMode=false;
            AudioManager.playMusic("baseball_heroes");

            var modes:ModeSelectScreen = new ModeSelectScreen(
                GAME_W,
                GAME_H,
                showLobby,
                showPregame,
                showHomeRunDerby,
                replayFirstGameTutorial,
                showOnline,
                showPostSeason
            );

            currentScreen = modes;
            rootContainer.addChild(currentScreen);
        }

        private function showOnline():void {
            clearCurrentScreen();
            AudioManager.playMusic("locker_room");
            currentScreen=new OnlineLobbyScreen(GAME_W,GAME_H,showModes);
            rootContainer.addChild(currentScreen);
            layoutStage();
        }

        private function showPostSeason():void {
            clearCurrentScreen();GameData.ensurePostSeason();GameData.postSeasonMode=true;
            AudioManager.playMusic("baseball_heroes");
            currentScreen=new PostSeasonScreen(GAME_W,GAME_H,showLobby,showPostSeasonTravel,startAfterPostSeason);
            rootContainer.addChild(currentScreen);layoutStage();
        }
        private function startAfterPostSeason():void {
            GameData.postSeasonMode=false;
            if(GameData.prepareNextSeason())showSeasonGoal(showPregame);else showPostSeason();
        }
        private function showPostSeasonTravel():void {
            if(!GameData.ensurePostSeason()||!com.bh.model.PostSeason.activeSeries(GameData.postSeason)){showPostSeason();return;}
            clearCurrentScreen();GameData.postSeasonMode=true;
            AudioManager.playMusic("baseball_heroes");
            currentScreen=new TravelMapScreen(GAME_W,GAME_H,showPostSeasonLineup,showPostSeason);
            rootContainer.addChild(currentScreen);layoutStage();
        }
        private function showPostSeasonLineup():void {
            clearCurrentScreen();GameData.postSeasonMode=true;AudioManager.playMusic("locker_room");
            currentScreen=new LineupScreen(GAME_W,GAME_H,showPostSeason,showPostSeasonIntro,postCards,postTrade);
            rootContainer.addChild(currentScreen);layoutStage();
        }
        private function postCards():void {showSpecialCards(showPostSeasonLineup);}
        private function postTrade():void {showTradeEnhance(showPostSeasonLineup);}
        private function showPostSeasonIntro():void {
            clearCurrentScreen();GameData.postSeasonMode=true;
            currentScreen=new MatchIntroScreen(GAME_W,GAME_H,launchPostSeasonGame,showPostSeasonLineup);
            rootContainer.addChild(currentScreen);layoutStage();
        }
        private function launchPostSeasonGame():void {
            if(!GameData.startPostSeasonGame()){showPostSeason();return;}
            clearCurrentScreen();AudioManager.stopMusic();
            currentScreen=new Game(GAME_W,MATCH_H,showPostSeason,showPostSeason);
            rootContainer.addChild(currentScreen);installMatchSocial();layoutStage();
        }

        private function showRoadmapToMajor():void {
            clearCurrentScreen();
            AudioManager.playMusic(
                "baseball_heroes"
            );

            var roadmap:RoadmapToMajorScreen =
                new RoadmapToMajorScreen(
                    GAME_W,
                    GAME_H,
                    showLobby,
                    showRoadmapFriends
                );

            currentScreen =
                roadmap;

            rootContainer.addChild(
                currentScreen
            );
        }

        private function showRoadmapFriends():void {
            clearCurrentScreen();currentScreen=new SocialScreen(new OnlineClient(),showRoadmapToMajor,"GIFTS");rootContainer.addChild(currentScreen);layoutStage();
        }
        private function showHomeRunDerby():void {
            clearCurrentScreen();
            AudioManager.stopMusic();

            var derby:HomeRunDerbyScreen = new HomeRunDerbyScreen(
                GAME_W,
                GAME_H,
                showModes
            );

            currentScreen = derby;
            rootContainer.addChild(currentScreen);
        }

        private function showSeasonGoal(doneCallback:Function = null):void {
            clearCurrentScreen();
            AudioManager.playMusic("locker_room");

            var goals:SeasonGoalScreen =
                new SeasonGoalScreen(
                    GAME_W,
                    GAME_H,
                    doneCallback != null ? doneCallback : onSeasonGoalDone
                );

            currentScreen = goals;
            rootContainer.addChild(currentScreen);
        }

        private function showTeamName():void {
            clearCurrentScreen();
            AudioManager.playMusic("locker_room");

            var nameScreen:TeamNameScreen =
                new TeamNameScreen(
                    GAME_W,
                    GAME_H,
                    showLobby
                );

            currentScreen = nameScreen;
            rootContainer.addChild(currentScreen);
        }

        private function showHallOfFame():void {
            clearCurrentScreen();GameData.postSeasonMode=false;
            currentScreen=new HallOfFameScreen(GAME_W,GAME_H,showLobby,showMissions);
            rootContainer.addChild(currentScreen);layoutStage();
        }
        private function showMissions():void {
            clearCurrentScreen();
            AudioManager.playMusic("locker_room");

            var missions:MissionsScreen =
                new MissionsScreen(
                    GAME_W,
                    GAME_H,
                    showLobby,
                    showShop
                );

            currentScreen = missions;
            rootContainer.addChild(currentScreen);
        }

        private function showPregame():void {
            GameData.postSeasonMode=false;
            // A reload or ESC during new-season goals must not bypass setup.
            if (!GameData.seasonComplete && !GameData.seasonGoalSet &&
                GameData.onboardingStep == GameData.ONBOARDING_COMPLETE) {
                showSeasonGoal(showPregame);
                return;
            }
            clearCurrentScreen();

            AudioManager.playMusic(
                "baseball_heroes"
            );

            var roadmap:SeasonRoadmapScreen =
                new SeasonRoadmapScreen(
                    GAME_W,
                    GAME_H,
                    showLobby,
                    onRoadmapContinue
                );

            currentScreen = roadmap;
            rootContainer.addChild(currentScreen);
        }

        private function showTravelMap():void {
            if (redirectSeasonSetup()) return;
            clearCurrentScreen();

            AudioManager.playMusic(
                "baseball_heroes"
            );

            var travel:TravelMapScreen =
                new TravelMapScreen(
                    GAME_W,
                    GAME_H,
                    onTravelComplete,
                    showLobby
                );

            currentScreen = travel;
            rootContainer.addChild(currentScreen);
        }

        private function startSeasonGame():void {
            if (redirectSeasonSetup()) return;
            if (
                GameData.onboardingStep ==
                GameData.ONBOARDING_LINEUP
            ) {
                GameData.completeOnboarding();
            }

            clearCurrentScreen();

            AudioManager.playMusic(
                "baseball_heroes"
            );

            var intro:MatchIntroScreen =
                new MatchIntroScreen(
                    GAME_W,
                    GAME_H,
                    launchSeasonGame,
                    showLineupFromPregame
                );

            currentScreen = intro;
            rootContainer.addChild(currentScreen);
        }

        private function launchSeasonGame():void {
            if (redirectSeasonSetup()) return;
            if (!GameData.startSeasonGame()) {
                showLobby();
                return;
            }

            clearCurrentScreen();
            AudioManager.stopMusic();

            var game:Game = new Game(
                GAME_W,
                MATCH_H,
                showLobby,
                function():void{if(GameData.tutorialActive())showLobby();else showTravelMap();}
            );

            currentScreen = game;
            rootContainer.addChild(currentScreen);
            installMatchSocial();
            layoutStage();
        }

        private function installMatchSocial():void {
            matchSocial=new MatchSocialBar({SHOP:showShop,LINEUP:showLineup,BUILD:showBuild,RIVAL:showOnline,HALL:showHallOfFame,HOME:showLobby,FRIENDS:showHomeFriends,VISIT:showFriendVisit});
            matchSocial.y=MATCH_H;rootContainer.addChild(matchSocial);
            currentScreen.addEventListener("match-finished",onMatchFinished);
        }
        private function onMatchFinished(e:Event):void {if(matchSocial)matchSocial.setFinished();}

        private function showLineupFromPregame():void {
            if (redirectSeasonSetup()) return;
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            var lineup:LineupScreen =
                new LineupScreen(
                    GAME_W,
                    GAME_H,
                    showLobby,
                    startSeasonGame,
                    showSpecialCardsFromPregameLineup,
                    showTradeFromPregameLineup
                );

            currentScreen = lineup;
            rootContainer.addChild(currentScreen);
            layoutStage();
        }

        private function showLineup():void {
            if (redirectSeasonSetup()) return;
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            var lineup:LineupScreen =
                new LineupScreen(
                    GAME_W,
                    GAME_H,
                    showLobby,
                    startSeasonGame,
                    showSpecialCardsFromTeamLineup,
                    showTradeFromTeamLineup
                );

            currentScreen = lineup;
            rootContainer.addChild(currentScreen);
            layoutStage();
        }

        private function redirectSeasonSetup():Boolean {
            if (GameData.seasonComplete) {
                showPregame();
                return true;
            }
            if (!GameData.seasonGoalSet && GameData.onboardingStep == GameData.ONBOARDING_COMPLETE) {
                showSeasonGoal(showPregame);
                return true;
            }
            return false;
        }

        private function showTeam():void {
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            var team:TeamScreen = new TeamScreen(
                GAME_W,
                GAME_H,
                showLobby,
                showTraining,
                showEquipment,
                showSkills,
                showLineup,
                showSpecialCards
            );

            currentScreen = team;
            rootContainer.addChild(currentScreen);
        }

        private function showSpecialCards(
            backCallback:Function = null,initialMode:String="DETAILS"
        ):void {
            clearCurrentScreen();

            AudioManager.playMusic(
                "locker_room"
            );

            if (backCallback == null) {
                backCallback = showTeam;
            }

            var cards:SpecialCardsScreen =
                new SpecialCardsScreen(
                    GAME_W,
                    GAME_H,
                    backCallback,initialMode
                );

            currentScreen = cards;
            rootContainer.addChild(currentScreen);
        }

        private function showSpecialCardsFromPregameLineup():void {
            showSpecialCards(
                showLineupFromPregame
            );
        }

        private function showSpecialCardsFromTeamLineup():void {
            showSpecialCards(
                showLineup
            );
        }

        private function showTradeEnhance(
            backCallback:Function
        ):void {
            clearCurrentScreen();

            AudioManager.playMusic(
                "locker_room"
            );

            var trade:TradeEnhanceScreen =
                new TradeEnhanceScreen(
                    GAME_W,
                    GAME_H,
                    backCallback
                );

            currentScreen = trade;
            rootContainer.addChild(currentScreen);
        }

        private function showTradeFromPregameLineup():void {
            showSpecialCards(showLineupFromPregame,"TRADE");
        }

        private function showTradeFromTeamLineup():void {
            showSpecialCards(showLineup,"TRADE");
        }

        private function showHomeTraining():void {showTraining(GameData.mainPlayer(),showLobby);}

        private function showTraining(player:Object = null,backCallback:Function=null):void {
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            if (player == null) {
                player = GameData.mainPlayer();
            }

            var training:TrainingScreen = new TrainingScreen(
                GAME_W,
                GAME_H,
                player,
                backCallback!=null?backCallback:showTeam
            );

            currentScreen = training;
            rootContainer.addChild(currentScreen);
        }

        private function showSkills(
            player:Object = null
        ):void {
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            if (player == null) {
                player =
                    GameData.mainPlayer();
            }

            var skills:SkillScreen =
                new SkillScreen(
                    GAME_W,
                    GAME_H,
                    player,
                    showTeam
                );

            currentScreen = skills;
            rootContainer.addChild(currentScreen);
        }

        private function showEquipment():void {
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            var equipment:EquipmentScreen = new EquipmentScreen(
                GAME_W,
                GAME_H,
                showTeam,
                showShop,
                false,null,null,showMysteryInventory
            );

            currentScreen = equipment;
            rootContainer.addChild(currentScreen);
        }

        private function showMysteryInventory():void {
            clearCurrentScreen();AudioManager.playMusic("shop");
            currentScreen=new MysteryInventoryScreen(GAME_W,GAME_H,showLobby,showShop,showEquipment);
            rootContainer.addChild(currentScreen);
        }

        private function showShop():void {
            clearCurrentScreen();

            AudioManager.playMusic("shop");

            var shop:ShopScreen = new ShopScreen(
                GAME_W,
                GAME_H,
                showLobby,
                showBuild,
                showEquipment
            );

            currentScreen = shop;
            rootContainer.addChild(currentScreen);
        }

        private function showBuild():void {
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            var build:BuildScreen = new BuildScreen(
                GAME_W,
                GAME_H,
                showLobby,
                showShop
            );

            currentScreen = build;
            rootContainer.addChild(currentScreen);
        }

        private function showFriendDraft():void {
            clearCurrentScreen();currentScreen=new com.bh.ui.FriendDraftScreen(GAME_W,GAME_H,showLobby,showOnline,showScout);rootContainer.addChild(currentScreen);layoutStage();
        }
        private function showScout():void {
            clearCurrentScreen();

            AudioManager.playMusic("locker_room");

            var scout:ScoutScreen = new ScoutScreen(
                GAME_W,
                GAME_H,
                showLobby,
                showTeam,
                showFriendDraft
            );

            currentScreen = scout;
            rootContainer.addChild(currentScreen);
        }

        private function onGlobalKeyDown(e:KeyboardEvent):void {
            if (e.keyCode != Keyboard.ESCAPE) return;
            if(currentScreen is Game&&Game(currentScreen).handleMatchEscape())return;
            if(matchSocial&&matchSocial.handleEscape())return;

            if (
                GameData.onboardingActive() &&
                !(currentScreen is Game)
            ) {
                skipFirstGameTutorial();
                return;
            }

            if(currentScreen is FriendVisitScreen){FriendVisitScreen(currentScreen).handleEscape();return;}
            if(currentScreen is SocialScreen){SocialScreen(currentScreen).handleEscape();return;}
            if(currentScreen is OnlineLobbyScreen&&OnlineLobbyScreen(currentScreen).handleEscape())return;
            if(currentScreen is LobbyScreen){LobbyScreen(currentScreen).handleEscape();return;}
            if(currentScreen is SeasonRoadmapScreen&&SeasonRoadmapScreen(currentScreen).handleEscape())return;

            if (
                currentScreen is Game ||
                currentScreen is TeamScreen ||
                currentScreen is TrainingScreen ||
                currentScreen is ScoutScreen ||
                currentScreen is EquipmentScreen ||
                currentScreen is ShopScreen ||
                currentScreen is BuildScreen ||
                currentScreen is SkillScreen ||
                currentScreen is PregameScreen ||
                currentScreen is LineupScreen ||
                currentScreen is SpecialCardsScreen ||
                currentScreen is SeasonGoalScreen ||
                currentScreen is TeamSelectionScreen ||
                currentScreen is TeamNameScreen ||
                currentScreen is CharacterMakerScreen ||
                currentScreen is HallOfFameScreen ||
                currentScreen is MysteryInventoryScreen ||
                currentScreen is MissionsScreen ||
                currentScreen is TradeEnhanceScreen ||
                currentScreen is SeasonRoadmapScreen ||
                currentScreen is TravelMapScreen ||
                currentScreen is MatchIntroScreen ||
                currentScreen is ModeSelectScreen ||
                currentScreen is PostSeasonScreen ||
                currentScreen is OnlineLobbyScreen ||
                currentScreen is HomeRunDerbyScreen ||
                currentScreen is ArrivalMapScreen ||
                currentScreen is RoadmapToMajorScreen
            ) {
                showLobby();
            }
        }

        private function clearCurrentScreen():void {
            if(menuEntrance){menuEntrance.dispose();menuEntrance=null;}
            if (!currentScreen) return;
            if(matchSocial){currentScreen.removeEventListener("match-finished",onMatchFinished);matchSocial.dispose();rootContainer.removeChild(matchSocial);matchSocial=null;}

            if (currentScreen is Game) {
                Game(currentScreen).dispose();
            }
            else if (currentScreen is FriendVisitScreen) {FriendVisitScreen(currentScreen).dispose();}
            else if (currentScreen is LobbyScreen) {
                LobbyScreen(currentScreen).dispose();
            }
            else if (currentScreen is TeamScreen) {
                TeamScreen(currentScreen).dispose();
            }
            else if (currentScreen is TrainingScreen) {
                TrainingScreen(currentScreen).dispose();
            }
            else if (currentScreen is ScoutScreen) {
                ScoutScreen(currentScreen).dispose();
            }
            else if (currentScreen is EquipmentScreen) {
                EquipmentScreen(currentScreen).dispose();
            }
            else if (currentScreen is ShopScreen) {
                ShopScreen(currentScreen).dispose();
            }
            else if (currentScreen is BuildScreen) {
                BuildScreen(currentScreen).dispose();
            }
            else if (currentScreen is SkillScreen) {
                SkillScreen(currentScreen).dispose();
            }
            else if (currentScreen is PregameScreen) {
                PregameScreen(currentScreen).dispose();
            }
            else if (currentScreen is LineupScreen) {
                LineupScreen(currentScreen).dispose();
            }
            else if (
                currentScreen is
                SpecialCardsScreen
            ) {
                SpecialCardsScreen(currentScreen).dispose();
            }
            else if (currentScreen is SeasonGoalScreen) {
                SeasonGoalScreen(currentScreen).dispose();
            }
            else if (currentScreen is TeamSelectionScreen) {
                TeamSelectionScreen(currentScreen).dispose();
            }
            else if (currentScreen is TeamNameScreen) {
                TeamNameScreen(currentScreen).dispose();
            }
            else if (currentScreen is com.bh.ui.FriendDraftScreen) {com.bh.ui.FriendDraftScreen(currentScreen).dispose();}
            else if (currentScreen is CharacterMakerScreen) {
                CharacterMakerScreen(currentScreen).dispose();
            }
            else if (currentScreen is MysteryInventoryScreen) {MysteryInventoryScreen(currentScreen).dispose();}
            else if (currentScreen is HallOfFameScreen) {HallOfFameScreen(currentScreen).dispose();}
            else if (currentScreen is MissionsScreen) {
                MissionsScreen(currentScreen).dispose();
            }
            else if (currentScreen is TradeEnhanceScreen) {
                TradeEnhanceScreen(currentScreen).dispose();
            }
            else if (currentScreen is SeasonRoadmapScreen) {
                SeasonRoadmapScreen(currentScreen).dispose();
            }
            else if (currentScreen is TravelMapScreen) {
                TravelMapScreen(currentScreen).dispose();
            }
            else if (currentScreen is MatchIntroScreen) {
                MatchIntroScreen(currentScreen).dispose();
            }
            else if (currentScreen is ModeSelectScreen) {
                ModeSelectScreen(currentScreen).dispose();
            }
            else if (currentScreen is PostSeasonScreen) {
                PostSeasonScreen(currentScreen).dispose();
            }
            else if (currentScreen is com.bh.ui.SocialScreen) {com.bh.ui.SocialScreen(currentScreen).dispose();}
            else if (currentScreen is OnlineLobbyScreen) {
                OnlineLobbyScreen(currentScreen).dispose();
            }
            else if (currentScreen is HomeRunDerbyScreen) {
                HomeRunDerbyScreen(currentScreen).dispose();
            }
            else if (currentScreen is ArrivalMapScreen) {
                ArrivalMapScreen(currentScreen).dispose();
            }
            else if (currentScreen is RoadmapToMajorScreen) {
                RoadmapToMajorScreen(currentScreen).dispose();
            }

            if (
                rootContainer &&
                rootContainer.contains(currentScreen)
            ) {
                rootContainer.removeChild(currentScreen);
            }

            currentScreen = null;
            layoutStage();
        }
    }
}
