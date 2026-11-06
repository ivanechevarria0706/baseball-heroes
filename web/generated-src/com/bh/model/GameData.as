package com.bh.model {
    import com.bh.platform.WebSave;
    import flash.utils.ByteArray;

    public class GameData {
        private static const SAVE_NAME:String =
            "baseballHeroesRemakeSave";

        private static const SAVE_VERSION:int = 24;

        public static var initialized:Boolean = false;

        // Account-level resources.
        public static var level:int = 1;
        public static var xp:int = 0;
        public static var careerStartVersion:int = 4;
        public static var levelProgress:int = 0;
        public static var maxEnergy:int = 25;
        public static var energy:int = 25;
        public static var energyAt:String="0";public static var scoreRewardTotal:int=0;
        public static var scoreHistory:Object={best:0,matches:[]};
        public static var coins:int = 6000;
        public static var cash:int = 0;

        // Season / league progression.
        // Historical Baseball Heroes used five league levels and
        // 30-game regular seasons. Promotion rules here are a
        // reconstruction approximation until exact server rules
        // can be recovered.
        public static var leagueIndex:int = 0;
        public static var seasonNumber:int = 1;
        public static var seasonGame:int = 1;
        public static var seasonWins:int = 0;
        public static var seasonLosses:int = 0;
        public static var seasonHits:int = 0;
        public static var seasonHomeRuns:int = 0;
        public static var seasonRbi:int = 0;
        public static var seasonComplete:Boolean = false;
        public static var seasonHistory:Array = [];
        public static var seasonResults:Array = [];
        public static var lastGameSummary:Object = null;
        public static var lastSeasonSummary:Object = null;
        public static var postSeason:Object = null;
        public static var postSeasonHistory:Array = [];
        public static var hallOfFame:Object=CareerAchievements.create();
        public static var mysteryInventory:Object=MysteryInventory.create();
        public static var friendDraft:Array=[];
        public static var socialState:Object={links:[],totals:{energy:0,key:0,letter:0}};
        // Presentation context only; the paid fixture and bracket are persisted.
        public static var postSeasonMode:Boolean = false;
        public static var lastLevelUpSummary:Object = null;
        // RUNNING prices, durations and rewards are visible in the supplied video.
        // Step thresholds/tier ranges remain local reconstruction rules.
        public static var runningTraining:Object = {};

        // Roadmap to Major.
        // This is account-level progression, intentionally separate from
        // season stats because the historical Roadmap survives season resets.
        public static var roadmapGames:int = 0;
        public static var roadmapWins:int = 0;
        public static var roadmapHomeRuns:int = 0;
        public static var roadmapRbi:int = 0;
        public static var roadmapClaims:Object = {};
        public static var roadmapLastReward:Object = null;
        public static var roadmapJourney:Object = {seasons:{},letters:{},champions:{},claims:{},fixtures:[]};

        // Interface/onboarding state reconstructed from the 2012-era gameplay.
        public static var teamName:String = "IVAN HEROES";
        public static var teamCity:String = "ST. LOUIS";
        public static var teamAccent:uint = 0xd24b38;
        public static var uniformNumber:int = 32;

        // First-game experience reconstructed from the first gameplay.
        // Existing Phase 8T and older saves are migrated directly to COMPLETE
        // so active careers are never forced through the tutorial.
        public static const ONBOARDING_TEAM:int = 0;
        public static const ONBOARDING_CHARACTER:int = 1;
        public static const ONBOARDING_ARRIVAL:int = 2;
        public static const ONBOARDING_HOME:int = 3;
        public static const ONBOARDING_GOAL:int = 4;
        public static const ONBOARDING_ROADMAP:int = 5;
        public static const ONBOARDING_TRAVEL:int = 6;
        public static const ONBOARDING_LINEUP:int = 7;
        public static const ONBOARDING_COMPLETE:int = 99;
        public static var onboardingStep:int = ONBOARDING_TEAM;

        public static var starterTutorial:Object=StarterTutorial.create(true);
        public static var seasonGoalType:String="HIT";
        public static var seasonGoalHits:int=70,seasonHeroHits:int=0,seasonHeroRbi:int=0;
        public static var seasonGoalSet:Boolean = false;
        public static var seasonGoalHomeRuns:int = 15;
        public static var seasonGoalRbi:int = 55;

        public static var missionClaims:Object = {};
        public static var homeCleanup:Object=StadiumCleanup.create();
        public static var gateIncomeCollected:int = 0;
        public static var gateIncomeLastDay:String = "";
        public static var gateIncomeLastAt:Number = 0;

        private static const LEAGUES:Array = [
            "ROOKIE",
            "SINGLE-A",
            "DOUBLE-A",
            "TRIPLE-A",
            "MAJOR"
        ];

        public static var roster:Array = [];
        public static var battingOrder:Array = [];
        public static var lastScouted:Object = null;

        // Special Batter Cards.
        // Historical material describes up to five Special Batters,
        // grades, Combo boosts, inning-based guaranteed hits, individual
        // improvement and combining cards. Exact server formulas are lost,
        // so costs/weights below are reconstruction approximations.
        public static var specialOwned:Object = {};
        public static var specialSerial:int=0;
        public static var specialMatch:Object=null;
        public static var specialEquipped:Array = [
            null,
            null,
            null,
            null,
            null
        ];
        public static var specialSlotsUnlocked:int = 1;
        public static var specialPositions:Array = null;
        public static var lastSpecialDraw:Object = null;

        public static var inventory:Array = [];
        public static var consumableBats:Object=ConsumableBats.create();

        public static var equipped:Object = {
            bat:null,
            glove:null,
            belt:null,
            helmet:null,
            shoes:null,
            goggles:null
        };

        // Stadium / Build Mode.
        // We save ownership by catalog id so old saves remain compact
        // and the visual catalog can evolve without serializing UI data.
        public static var stadiumOwned:Array = [];
        public static var stadiumActive:Object = {
            background:"stadium_background_mountain",
            field:"stadium_field_classic",
            stand:"stadium_stand_brown",
            scoreboard:"stadium_scoreboard_classic",
            banner:"stadium_banner_red",
            fence:"stadium_fence_plain",
            lights:"stadium_lights_basic",
            wall:"stadium_wall_green"
        };

        // Placeable Build Mode decorations.
        // Each entry is {id:String, x:Number, y:Number, scale:Number}.
        public static var stadiumDecorations:Array = [];

        private static var scoutCounter:int = 0;
        private static var saveObject:WebSave;

        public static function init():void {
            if (initialized) {refreshEnergy();return;}

            initialized = true;

            createDefaults();
            load();refreshEnergy();
        }

        public static function refreshEnergy(now:Number=-1):void {
            if(now<0)now=new Date().time;
            var before:int=energy,oldAt:String=energyAt,state:Object=AccountEnergy.settle(energy,maxEnergy,energyAt,now);
            energy=int(state.energy);energyAt=String(state.at);
            if(initialized&&(before!=energy||oldAt!=energyAt))save();
        }
        public static function applyScoreRewards(total:int):void {total=Math.max(0,total);if(total>scoreRewardTotal){coins+=total-scoreRewardTotal;scoreRewardTotal=total;save();}}
        public static function energyCountdown():String {
            refreshEnergy();if(energy>=maxEnergy)return "FULL";
            var seconds:Number=Math.max(0,(Number(energyAt)-new Date().time)/1000);
            return "NEXT "+AccountEnergy.clock(seconds)+"  FULL "+AccountEnergy.clock(seconds+(maxEnergy-energy-1)*300);
        }
        public static function recordScore(summary:Object):void {ScoreHistory.record(scoreHistory,summary);}

        private static function createDefaults():void {
            level = 1;
            xp = 0;
            careerStartVersion = 4;
            levelProgress = 0;
            maxEnergy = 25;
            energy = 20;energyAt=String(new Date().time+AccountEnergy.INTERVAL);scoreRewardTotal=0;scoreHistory={best:0,matches:[]};
            coins = 6000;
            cash = 0;

            leagueIndex = 0;
            seasonNumber = 1;
            seasonGame = 1;
            homeCleanup=StadiumCleanup.create();
            seasonWins = 0;
            seasonLosses = 0;
            seasonHits = 0;
            seasonHomeRuns = 0;
            seasonRbi = 0;
            seasonComplete = false;
            seasonHistory = [];
            seasonResults = [];
            lastGameSummary = null;
            lastSeasonSummary = null;
            friendDraft=[];socialState={links:[],totals:{energy:0,key:0,letter:0}};postSeason=null;postSeasonHistory=[];postSeasonMode=false;hallOfFame=CareerAchievements.create();mysteryInventory=MysteryInventory.create();
            lastLevelUpSummary = null;
            runningTraining = {mastery:0, availableAt:"0", activity:"", lastReward:null};

            roadmapGames = 0;
            roadmapWins = 0;
            roadmapHomeRuns = 0;
            roadmapRbi = 0;
            roadmapClaims = {};
            roadmapLastReward = null;
            roadmapJourney = RoadmapJourney.create();

            teamName = "IVAN HEROES";
            teamCity = "ST. LOUIS";
            teamAccent = 0xd24b38;
            uniformNumber = 32;
            onboardingStep = ONBOARDING_TEAM;

            starterTutorial=StarterTutorial.create(true);
            seasonGoalType="HIT";seasonGoalHits=70;seasonHeroHits=seasonHeroRbi=0;
            seasonGoalSet = false;
            seasonGoalHomeRuns = 15;
            seasonGoalRbi = 55;

            missionClaims = {};
            gateIncomeCollected = 0;
            gateIncomeLastDay = "";
            gateIncomeLastAt = 0;

            scoutCounter = 0;
            lastScouted = null;

            roster = createDefaultRoster();
            battingOrder = defaultBattingOrder();
            roster[0].skillPoints=0;roster[0].skillInvestment={contact:1,power:1,luck:1};
            battingOrder.push(battingOrder.shift());
            for(var starterIndex:int=1;starterIndex<roster.length;starterIndex++){roster[starterIndex].baseAverage=".200";roster[starterIndex].avg=".200";}

            specialSerial=0;specialMatch=null;
            specialOwned = {};
            specialEquipped = [
                null,
                null,
                null,
                null,
                null
            ];
            specialSlotsUnlocked = 1;specialPositions=null;
            lastSpecialDraw = null;

            addDefaultSpecialCards();

            inventory = createDefaultInventory();
            consumableBats=ConsumableBats.create();

            equipped = {
                bat:findInventoryItem("Rookie Bat"),
                glove:findInventoryItem("Field Glove"),
                belt:findInventoryItem("Rookie Belt"),
                helmet:findInventoryItem("Rookie Helmet"),
                shoes:findInventoryItem("Speed Cleats"),
                goggles:null
            };

            stadiumOwned = [
                "stadium_background_mountain",
                "stadium_field_classic",
                "stadium_stand_brown",
                "stadium_scoreboard_classic",
                "stadium_banner_red",
                "stadium_fence_plain",
                "stadium_lights_basic",
                "stadium_wall_green"
            ];

            stadiumActive = {
                background:"stadium_background_mountain",
                field:"stadium_field_classic",
                stand:"stadium_stand_brown",
                scoreboard:"stadium_scoreboard_classic",
                banner:"stadium_banner_red",
                fence:"stadium_fence_plain",
                lights:"stadium_lights_basic",
                wall:"stadium_wall_green"
            };

            stadiumDecorations = [];
        }

        private static function createDefaultInventory():Array {
            return [
                // Starter ownership only. Advanced items must be earned/bought.
                equipment("Rookie Bat", "bat", "NORMAL", 0x9a6334, 2, 0, 0, 0),

                equipment("Field Glove", "glove", "NORMAL", 0x9a6334, 0, 1, 1, 0),

                // New historical categories start with one free Rookie item.
                equipment("Rookie Belt", "belt", "NORMAL", 0x33404a, 0, 1, 0, 0),
                equipment("Rookie Helmet", "helmet", "NORMAL", 0x2d6292, 0, 1, 0, 0),

                equipment("Speed Cleats", "shoes", "NORMAL", 0x27333e, 0, 0, 3, 0),

                equipment("Rookie Goggles", "goggles", "NORMAL", 0x5f7c8e, 0, 1, 0, 1)
            ];
        }

        public static function player(
            name:String,
            pos:String,
            playerLevel:int,
            power:int,
            contact:int,
            speed:int,
            avg:String,
            hr:int,
            rbi:int,
            rating:int,
            grade:String,
            accent:uint
        ):Object {
            return {
                name:name,
                pos:pos,
                level:playerLevel,
                power:power,
                contact:contact,
                speed:speed,
                luck:Math.max(
                    40,
                    Math.min(
                        99,
                        int(
                            contact * 0.58 +
                            speed * 0.42
                        )
                    )
                ),
                avg:avg,
                hr:hr,
                rbi:rbi,
                rating:rating,

                // Baselines are kept so training raises OVR gradually
                // instead of replacing it with a raw attribute average.
                baseRating:rating,
                basePower:power,
                baseContact:contact,
                baseSpeed:speed,
                baseLuck:Math.max(
                    40,
                    Math.min(
                        99,
                        int(
                            contact * 0.58 +
                            speed * 0.42
                        )
                    )
                ),

                xp:0,
                careerHits:0,
                careerAtBats:0,
                doubles:0,
                triples:0,
                walks:0,
                grade:grade,
                accent:accent,
                appearance:null,

                // Skill system.
                skillPoints:1,
                activeSkill:"BATTING_EYE",
                skillLevels:{
                    POWER_HITTER:0,
                    BATTING_EYE:1,
                    CLUTCH:0,
                    SPEEDSTER:0
                }
            };
        }

        public static function equipment(
            name:String,
            slot:String,
            grade:String,
            accent:uint,
            power:int,
            contact:int,
            speed:int,
            luck:int = 0
        ):Object {
            return {
                name:name,
                slot:slot,
                grade:grade,
                accent:accent,
                power:power,
                contact:contact,
                speed:speed,
                luck:luck
            };
        }

        public static function mainPlayer():Object {
            init();

            if (!roster || roster.length == 0) {
                roster = createDefaultRoster();
                save();
            }

            return roster[0];
        }

        public static function setTeamIdentity(
            name:String,
            city:String,
            accent:uint,
            number:int = 32
        ):void {
            if (name && name.length > 0) {
                teamName = name.toUpperCase();
            }

            // NAME edits the club label and uniform number, never its chosen city.
            if (teamSelectionOpen() && city && city.length > 0) {
                teamCity = city.toUpperCase();
            }

            if (teamSelectionOpen()) teamAccent = accent;
            uniformNumber = Math.max(
                0,
                Math.min(
                    99,
                    number
                )
            );

            var hero:Object = mainPlayer();
            hero.accent = teamAccent;
            StarterTutorial.event(starterTutorial,"name");
            save();
        }

        public static function setHeroAppearance(
            appearance:Object
        ):void {
            if (!appearance || !characterCreationOpen()) return;

            var hero:Object = mainPlayer();
            hero.appearance = {
                shape:int(appearance.shape),
                hair:int(appearance.hair),
                eyes:int(appearance.eyes),
                nose:int(appearance.nose),
                mouth:int(appearance.mouth),
                skinColor:int(appearance.skinColor),
                hairColor:int(appearance.hairColor),
                eyeColor:int(appearance.eyeColor),
                etc:Math.max(0,Math.min(7,int(appearance.etc))),
                artVersion:1,avatarStyle:HeroStyleCatalog.style(appearance),
                gender:appearance.gender=="F"?"F":"M"
            };

            save();
        }

        public static function onboardingActive():Boolean {
            init();
            return onboardingStep < ONBOARDING_COMPLETE;
        }

        public static function teamSelectionOpen():Boolean {
            return onboardingStep == ONBOARDING_TEAM;
        }

        public static function characterCreationOpen():Boolean {
            return onboardingStep == ONBOARDING_CHARACTER;
        }

        public static function setOnboardingStep(
            value:int
        ):void {
            onboardingStep = value;
            save();
        }

        public static function completeOnboarding():void {
            onboardingStep = ONBOARDING_COMPLETE;
            save();
        }

        public static function restartOnboarding():void {
            // Replay guidance without reopening confirmed team/character choices.
            if (onboardingStep >= ONBOARDING_ARRIVAL) onboardingStep = ONBOARDING_HOME;
            save();
        }

        public static function heroAppearance():Object {
            var hero:Object = mainPlayer();
            ensurePlayerMetadata(hero);

            if (!hero.appearance) {
                hero.appearance = defaultAppearance();
            }

            return hero.appearance;
        }

        private static function defaultAppearance():Object {
            return {
                artVersion:1,avatarStyle:0,gender:"M",etc:0,
                shape:0,
                hair:2,
                eyes:1,
                nose:0,
                mouth:1,
                skinColor:0,
                hairColor:0,
                eyeColor:0
            };
        }

        public static function spinSeasonGoals():Object {
            var hrValues:Array = [10, 12, 15, 18, 20];
            var rbiValues:Array = [30, 40, 45, 55, 65];

            seasonGoalHomeRuns =
                int(
                    hrValues[
                        int(
                            Math.random() *
                            hrValues.length
                        )
                    ]
                );

            seasonGoalRbi =
                int(
                    rbiValues[
                        int(
                            Math.random() *
                            rbiValues.length
                        )
                    ]
                );

            // HIT targets are visible in the tutorial video; random ranges remain a reconstruction.
            if(seasonGoalType=="HIT")seasonGoalHits=int([60,70,80][int(Math.random()*3)]);
            save();

            return {
                hr:goalTarget(),
                rbi:seasonGoalRbi
            };
        }

        public static function acceptSeasonGoals():void {
            seasonGoalSet = true;
            save();
        }

        public static function goalLabel():String {return seasonGoalType=="HIT"?"HIT":"HR";}
        public static function goalTarget():int {return seasonGoalType=="HIT"?seasonGoalHits:seasonGoalHomeRuns;}
        public static function goalCurrent():int {return seasonGoalType=="HIT"?seasonHeroHits:seasonHomeRuns;}
        public static function rbiCurrent():int {return seasonGoalType=="HIT"?seasonHeroRbi:seasonRbi;}
        public static function seasonGoalProgress():String {return goalLabel()+" "+goalCurrent()+"/"+goalTarget()+"   RBI "+rbiCurrent()+"/"+seasonGoalRbi;}
        public static function tutorialActive():Boolean {return StarterTutorial.active(starterTutorial);}
        public static function tutorialEvent(action:String,value:String=""):void {if(StarterTutorial.event(starterTutorial,action,value))save();}
        public static function skipStarterTutorial():void {StarterTutorial.skip(starterTutorial);save();}
        public static function useStarterCard():Boolean {
            if(!tutorialActive()||starterTutorial.stage!=StarterTutorial.SUBSTITUTE||lineupLocked()||!ownsSpecialCard(starterTutorial.cardId))return false;
            // The existing match engine substitutes special slot 1 for the first non-hero batter.
            specialEquipped[0]=starterTutorial.cardId;
            StarterTutorial.event(starterTutorial,"substitute",starterTutorial.cardId);save();return true;
        }
        public static function allocateHeroStat(stat:String):Boolean {
            if(["contact","power","luck"].indexOf(stat)<0||tutorialActive()&&starterTutorial.stage<StarterTutorial.POINT)return false;
            var hero:Object=mainPlayer();if(int(hero.skillPoints)<1||int(hero[stat])>=99)return false;
            hero[stat]=int(hero[stat])+1;hero.skillPoints=int(hero.skillPoints)-1;
            if(hero.skillInvestment)hero.skillInvestment[stat]=int(hero.skillInvestment[stat])+1;
            recalculateRating(hero);
            StarterTutorial.event(starterTutorial,"point");save();return true;
        }
        public static function claimStarterReward():int {
            if(missionClaimed("tutorial_basics"))return 0;
            var amount:int=StarterTutorial.claim(starterTutorial);if(amount==0)return 0;
            var nextClaims:Object={tutorial_basics:true};for(var id:String in missionClaims)nextClaims[id]=missionClaims[id];
            coins+=amount;missionClaims=nextClaims;save();return amount;
        }

        public static function canCollectGateIncome():Boolean {
            if (
                isNaN(gateIncomeLastAt) ||
                gateIncomeLastAt <= 0
            ) {
                return true;
            }

            var now:Number =
                new Date().time;

            return now -
                   gateIncomeLastAt >=
                   21600000;
        }

        public static function gateIncomeAmount():int {
            var amount:int = 450;

            var upgradeSlots:Array = [
                "background",
                "field",
                "stand",
                "scoreboard",
                "fence",
                "lights"
            ];

            for each (
                var slot:String in
                upgradeSlots
            ) {
                var item:Object =
                    activeStadiumItem(
                        slot
                    );

                if (
                    item &&
                    int(item.coinPrice) > 0
                ) {
                    amount += 175;
                }
            }

            amount +=
                stadiumDecorations
                ? stadiumDecorations.length *
                  50
                : 0;

            return amount;
        }

        public static function gateIncomeDailyAmount():int {
            return gateIncomeAmount() * 4;
        }

        public static function gateIncomeCountdownLabel():String {
            if (canCollectGateIncome()) {
                return "READY";
            }

            var remaining:Number =
                21600000 -
                (
                    new Date().time -
                    gateIncomeLastAt
                );

            if (remaining < 0) {
                remaining = 0;
            }

            var hours:int =
                int(
                    remaining /
                    3600000
                );

            var minutes:int =
                int(
                    (
                        remaining %
                        3600000
                    ) /
                    60000
                );

            var minuteText:String =
                minutes < 10
                ? "0" + minutes
                : String(minutes);

            return hours +
                   ":" +
                   minuteText;
        }

        public static function collectGateIncome():int {
            if (!canCollectGateIncome()) {
                return 0;
            }

            var amount:int =
                gateIncomeAmount();

            coins += amount;
            gateIncomeCollected++;
            StarterTutorial.event(starterTutorial,"tickets");

            gateIncomeLastAt =
                new Date().time;

            gateIncomeLastDay =
                todayKey();

            save();

            return amount;
        }

        private static function todayKey():String {
            var d:Date = new Date();

            return d.fullYear +
                   "-" +
                   (d.month + 1) +
                   "-" +
                   d.date;
        }

        public static function mysteryOpen(kind:String):Object {
            var result:Object=MysteryInventory.open(mysteryInventory,kind);if(result.status=="OK")save();return result;
        }
        public static function mysteryOpenPack(packClass:String="C"):Object {
            if(MysteryCatalog.CLASSES.indexOf(packClass)<0)return {status:"INVALID"};
            if(mysteryInventory.pending)return {status:"PENDING"};
            if(int(mysteryInventory.packs[packClass])<=0)return {status:"EMPTY"};
            var card:Object=SpecialCardCatalog.pick(packClass,SpecialCardCatalog.classPackGrade(Math.random(),packClass),Math.random());
            if(!card)card=SpecialCardCatalog.pick(packClass,"A",Math.random());
            if(!card)return {status:"INVALID"};
            mysteryInventory.packs[packClass]--;mysteryInventory.serial++;
            mysteryInventory.pending={id:"mystery-"+mysteryInventory.serial,source:MysteryCatalog.packKind(packClass),type:"CARD",amount:1,cardId:card.id};save();
            return {status:"OK",reward:mysteryInventory.pending};
        }
        public static function mysteryCollect(id:String):Object {
            var r:Object=mysteryInventory.pending;if(!r||String(r.id)!=id)return {status:"STALE"};
            if(r.type=="COINS")coins+=int(r.amount);
            else if(r.type=="CASH")cash+=int(r.amount);
            else if(r.type=="ENERGY")energy=Math.min(maxEnergy,energy+int(r.amount));
            else if(r.type=="KEY")MysteryInventory.addKeys(mysteryInventory,int(r.amount));
            else if(r.type=="PACK"){
                var cls:String=MysteryCatalog.CLASSES.indexOf(r.packClass)>=0?String(r.packClass):"C";
                if(int(mysteryInventory.packs[cls])>=50){coins+=int(MysteryCatalog.box(String(r.source)).coins[0]);r.converted=true;}
                else mysteryInventory.packs[cls]=int(mysteryInventory.packs[cls])+1;
            }
            else if(r.type=="CARD"){if(!grantSpecialCard(String(r.cardId)))return {status:"INVALID"};}
            else if(r.type=="GEAR"){
                var item:Object=MysteryCatalog.gearById(String(r.itemId));if(!item)return {status:"INVALID"};
                if(ownsShopItem(item)){coins+=int(r.duplicateCoins);r.converted=true;}
                else inventory.push(equipment(String(item.name),String(item.slot),String(item.grade),uint(item.accent),int(item.power),int(item.contact),int(item.speed),int(item.luck)));
            }
            else return {status:"INVALID"};
            mysteryInventory.pending=null;save();return {status:"OK",reward:r};
        }
        public static function seasonEventType(game:int):String {return game==12||game==28?"SPECIAL":game==30?"RIVAL":"REGULAR";}

        public static function hallAvailable():int {return CareerAchievements.available(hallOfFame);}
        public static function claimHallTrophy(id:String,tier:int):Object {
            var result:Object=CareerAchievements.claim(hallOfFame,id,tier);
            if(result.status=="OK"){coins+=int(result.coins);save();}return result;
        }
        private static function recordCareerMatch(key:String,home:int,away:int,rows:Array,extra:Boolean=false,raw:Object=null):void {
            if(CareerAchievements.match(hallOfFame,key,String(mainPlayer().name),home,away,rows,extra)){growRegularPlayers(rows);
                for each(var member:Object in roster)PlayerCondition.advance(member,key);
                if(raw){CareerAchievements.add(hallOfFame,"heroAttempts",Math.min(100,int(raw.heroAttempts)));CareerAchievements.add(hallOfFame,"luckyHits",Math.min(100,int(raw.luckyHits)));}
            }
        }

        public static function missionCatalog():Array {
            var hero:Object = mainPlayer();
            ensurePlayerMetadata(hero);

            var trained:int =
                Math.max(
                    0,
                    int(hero.power) -
                    int(hero.basePower)
                ) +
                Math.max(
                    0,
                    int(hero.contact) -
                    int(hero.baseContact)
                ) +
                Math.max(
                    0,
                    int(hero.luck) -
                    int(hero.baseLuck)
                );

            var missions:Array = [
                {
                    id:"stadium_growth",
                    icon:"STADIUM",
                    title:"LOCAL STADIUM GROWTH",
                    description:"Mejora el estadio para atraer público y cobrar entradas.",
                    reward:"1 SKILL POINT",
                    rewardType:"SKILL",
                    rewardValue:1,
                    objectives:[
                        {
                            label:"Compra 1 decoración para el estadio",
                            current:Math.max(
                                0,
                                stadiumOwned.length - 8
                            ),
                            target:1
                        },
                        {
                            label:"Cobra entradas una vez",
                            current:gateIncomeCollected,
                            target:1
                        }
                    ]
                },
                {
                    id:"hero_growth",
                    icon:"HERO",
                    title:"IMPROVE YOUR ABILITIES",
                    description:"Entrena a tu héroe y mejora Contact, Power y Luck.",
                    reward:"800 COINS",
                    rewardType:"COINS",
                    rewardValue:800,
                    objectives:[
                        {
                            label:"Improve a batting ability",
                            current:trained,
                            target:1
                        },
                        {
                            label:"Reach Hero Level 9",
                            current:int(hero.level),
                            target:9
                        }
                    ]
                },
                {
                    id:"draft_growth",
                    icon:"DRAFT",
                    title:"BUILD YOUR TEAM",
                    description:"Usa Draft para fichar otro jugador y reforzar el club.",
                    reward:"2,000 COINS",
                    rewardType:"COINS",
                    rewardValue:2000,
                    objectives:[
                        {
                            label:"Ficha 1 jugador mediante Draft",
                            current:Math.max(
                                0,
                                roster.length - 12
                            ),
                            target:1
                        },
                        {
                            label:"Juega 3 partidos de temporada",
                            current:seasonWins + seasonLosses,
                            target:3
                        }
                    ]
                }
                ,{id:"pitch_master",icon:"HERO",title:"ULTIMATE HITTER",description:"Consigue tres hits contra cada familia de pichadas en partidos terminados.",reward:"800 COINS",rewardType:"COINS",rewardValue:800,objectives:[{label:"Hits against breaking balls",current:hallOfFame.stats.pitchBreaking,target:3},{label:"Hits against four-seam fastballs",current:hallOfFame.stats.pitchFourSeam,target:3},{label:"Hits against two-seam fastballs",current:hallOfFame.stats.pitchTwoSeam,target:3}]}
                ,{id:"close_games",icon:"HERO",title:"CLOSE GAME",description:"Gana dos partidos por una carrera.",reward:"750 COINS",rewardType:"COINS",rewardValue:750,objectives:[{label:"One-run wins",current:hallOfFame.stats.closeWins,target:2}]}
                ,{id:"multi_single",icon:"HERO",title:"MULTI-HIT",description:"Logra al menos tres singles del héroe en tres partidos terminados.",reward:"820 COINS",rewardType:"COINS",rewardValue:820,objectives:[{label:"Games with three hero singles",current:hallOfFame.stats.multiHitGames,target:3}]}
            ];
            if(starterTutorial.enabled&&!starterTutorial.skipped)missions.unshift({id:"tutorial_basics",icon:"HERO",title:"FOLLOW THE BASICS",description:"Abre un C Pack, sustituye un bateador, ordena el equipo, termina un partido y usa un punto.",reward:"40,000 COINS",rewardType:"COINS",rewardValue:40000,objectives:[{label:"Completa las lecciones iniciales",current:starterTutorial.stage>=StarterTutorial.CLAIM?1:0,target:1}]});
            return missions;
        }

        public static function missionComplete(
            id:String
        ):Boolean {
            var catalog:Array = missionCatalog();

            for each (
                var mission:Object in catalog
            ) {
                if (
                    mission &&
                    String(mission.id) == id
                ) {
                    for each (
                        var objective:Object in
                        mission.objectives
                    ) {
                        if (
                            int(objective.current) <
                            int(objective.target)
                        ) {
                            return false;
                        }
                    }

                    return true;
                }
            }

            return false;
        }

        public static function missionClaimed(
            id:String
        ):Boolean {
            return missionClaims != null &&
                   Boolean(
                       missionClaims[id]
                   );
        }

        public static function claimMission(
            id:String
        ):String {
            if(id=="tutorial_basics")return claimStarterReward()>0?"OK":missionClaimed(id)?"CLAIMED":"INCOMPLETE";
            if (missionClaimed(id)) {
                return "CLAIMED";
            }

            if (!missionComplete(id)) {
                return "INCOMPLETE";
            }

            var catalog:Array = missionCatalog();

            for each (
                var mission:Object in catalog
            ) {
                if (
                    mission &&
                    String(mission.id) == id
                ) {
                    if (
                        mission.rewardType ==
                        "SKILL"
                    ) {
                        var hero:Object = mainPlayer();
                        hero.skillPoints =
                            int(hero.skillPoints) +
                            int(mission.rewardValue);
                    }
                    else {
                        coins +=
                            int(
                                mission.rewardValue
                            );
                    }

                    if (!missionClaims) {
                        missionClaims = {};
                    }

                    missionClaims[id] = true;
                    save();
                    return "OK";
                }
            }

            return "NOT_FOUND";
        }

        public static function trainingCost(
            p:Object,
            stat:String
        ):int {
            if (!p || !isTrainableStat(stat)) return 0;

            var value:int = int(p[stat]);

            return 1200 +
                   Math.max(0, value - 50) * 80;
        }

        public static function runningActivities():Array {
            return TrainingCatalog.activities("running");
        }

        private static function normalizeRunningTraining():void {
            if(!runningTraining || typeof runningTraining!="object" || runningTraining is Array)runningTraining={};
            var mastery:Number=Number(runningTraining.mastery);
            runningTraining.mastery=isFinite(mastery)?Math.max(0,Math.min(10000000,Math.floor(mastery))):0;
            var available:Number=Number(runningTraining.availableAt);
            // Ruffle 0.6.0's JSON parser truncates integer literals to 32 bits.
            // Store UTC milliseconds as text, then convert only for arithmetic.
            runningTraining.availableAt=String(isFinite(available)?Math.max(0,available):0);
            if(!(runningTraining.activity is String))runningTraining.activity="";
            if(!runningTraining.lastReward)runningTraining.lastReward=null;
        }

        public static function runningRemaining():Number {
            normalizeRunningTraining();
            return Math.max(0,Number(runningTraining.availableAt)-new Date().time);
        }

        public static function runningStep():int {
            return trainingStep("running");
        }

        public static function startRunningTraining(id:String):Object {
            return startDisciplineTraining("running",id);
        }

        public static function trainingState(discipline:String):Object {
            if(!TrainingCatalog.discipline(discipline))return null;
            normalizeRunningTraining();
            if(discipline=="running")return runningTraining;
            if(!runningTraining.disciplines||typeof runningTraining.disciplines!="object"||runningTraining.disciplines is Array)
                runningTraining.disciplines={};
            var state:Object=TrainingCatalog.normalize(runningTraining.disciplines[discipline]);
            runningTraining.disciplines[discipline]=state;
            return state;
        }

        public static function trainingRemaining(discipline:String):Number {
            var state:Object=trainingState(discipline);
            return state?Math.max(0,Number(state.availableAt)-new Date().time):0;
        }

        public static function trainingStep(discipline:String):int {
            var info:Object=trainingInfo(discipline);return info?int(info.step):0;
        }

        public static function trainingInfo(discipline:String):Object {
            var state:Object=trainingState(discipline);return state?TrainingMastery.info(state):null;
        }

        public static function trainingPendingReward(discipline:String):Object {
            var state:Object=trainingState(discipline),r:Object=state?state.lastReward:null;
            return r&&r.receipt is String&&r.acknowledged===false&&r.masteryResult&&
                (int(r.skillPoints)>0||int(r.energy)>0)?r:null;
        }

        public static function acknowledgeTrainingReward(discipline:String,receipt:String):Boolean {
            var r:Object=trainingPendingReward(discipline);
            if(!r||r.receipt!=receipt)return false;
            r.acknowledged=true;save();return true;
        }

        public static function startDisciplineTraining(discipline:String,id:String):Object {
            init();
            if(!TrainingCatalog.discipline(discipline))return {ok:false,error:"Disciplina no disponible."};
            var activity:Object=null;
            for each(var row:Object in TrainingCatalog.activities(discipline))if(row.id==id)activity=row;
            if(!activity)return {ok:false,error:"Sesión no disponible."};
            var state:Object=trainingState(discipline);
            if(trainingRemaining(discipline)>0)return {ok:false,error:"Este entrenador está descansando. Puedes entrenar con otro."};
            if(coins<int(activity.cost))return {ok:false,error:"Necesitas "+activity.cost+" Coins para esta sesión."};
            var masteryResult:Object=TrainingMastery.advance(state,int(activity.mastery));
            coins-=int(activity.cost);
            state.availableAt=String(new Date().time+Number(activity.hours)*3600000);
            state.activity=id;
            xp+=int(activity.xp);
            var levelUp:Object=applyLevelProgress(int(activity.xp));
            var points:int=masteryResult.skillPoints,energyReward:int=masteryResult.energy;
            if(points>0){var hero:Object=mainPlayer();hero.skillPoints=int(hero.skillPoints)+points;}
            if(energyReward>0) {
                // Settle recovery without a separate save midway through this purchase.
                var settled:Object=AccountEnergy.settle(energy,maxEnergy,energyAt,new Date().time);
                energy=int(settled.energy)+energyReward;energyAt=energy>=maxEnergy?"0":String(settled.at);
            }
            var reward:Object={ok:true,discipline:discipline,name:activity.name,cost:activity.cost,mastery:activity.mastery,
                               xp:activity.xp,skillPoints:points,energy:energyReward,step:masteryResult.step,levelUp:levelUp,
                               masteryResult:masteryResult,receipt:String(new Date().time)+"-"+int(Math.random()*1000000000),
                               acknowledged:points<=0&&energyReward<=0};
            state.lastReward=reward;
            save();return reward;
        }

        public static function train(
            p:Object,
            stat:String
        ):Boolean {
            if (!p || !isTrainableStat(stat)) return false;

            ensurePlayerMetadata(p);

            var cost:int = trainingCost(p, stat);

            if (coins < cost) return false;
            if (int(p[stat]) >= 99) return false;

            coins -= cost;
            p[stat] = int(p[stat]) + 1;
            p.xp = int(p.xp) + 25;

            while (int(p.xp) >= 100) {
                p.xp = int(p.xp) - 100;
                p.level = int(p.level) + 1;
                p.skillPoints = int(p.skillPoints) + 1;
            }

            recalculateRating(p);
            save();

            return true;
        }

        public static function recalculateRating(p:Object):void {
            if (!p) return;

            ensurePlayerMetadata(p);

            var gains:int =
                (int(p.power) - int(p.basePower)) +
                (int(p.contact) - int(p.baseContact)) +
                (int(p.speed) - int(p.baseSpeed)) +
                (int(p.luck) - int(p.baseLuck));

            p.rating = Math.min(
                99,
                int(p.baseRating) +
                Math.floor(Math.max(0, gains) / 3)
            );
        }

        private static function normalizeSocial(value:Object):Object {
            var out:Object={links:[],pendingKeys:0,visits:{coins:0,energy:0},totals:{energy:0,key:0,letter:0}};if(!value||value is Array)return out;
            out.pendingKeys=CareerAchievements.count(value.pendingKeys);
            if(value.visits)out.visits={coins:CareerAchievements.count(value.visits.coins),energy:CareerAchievements.count(value.visits.energy)};
            if(value.totals){out.totals.energy=CareerAchievements.count(value.totals.energy);out.totals.key=CareerAchievements.count(value.totals.key);out.totals.letter=CareerAchievements.count(value.totals.letter);}
            if(value.links is Array)for each(var l:Object in value.links.slice(0,100))if(l&&l.player is String&&l.friend is String&&l.name is String)out.links.push({player:l.player,friend:l.friend,name:l.name,average:Math.min(1000,CareerAchievements.count(l.average))});
            return out;
        }
        public static function stablePlayerId(p:Object):String {
            if(!p.socialId)p.socialId="player-"+new Date().time.toString(36)+"-"+int(Math.random()*100000000).toString(36);
            return String(p.socialId);
        }
        public static function applySocialSnapshot(data:Object):void {
            if(!data||!data.totals||!(data.links is Array))return;
            FriendRoster.update(data);
            if(data.visits){
                var priorVisits:Object=socialState.visits||{coins:0,energy:0};
                var visitCoins:int=CareerAchievements.count(data.visits.coins),visitEnergy:int=CareerAchievements.count(data.visits.energy);
                coins+=Math.max(0,visitCoins-CareerAchievements.count(priorVisits.coins));
                energy+=Math.max(0,visitEnergy-CareerAchievements.count(priorVisits.energy));
                socialState.visits={coins:Math.max(visitCoins,CareerAchievements.count(priorVisits.coins)),energy:Math.max(visitEnergy,CareerAchievements.count(priorVisits.energy))};
            }
            var old:Object=socialState.totals,newEnergy:int=CareerAchievements.count(data.totals.energy),newKeys:int=CareerAchievements.count(data.totals.key);
            energy+=Math.max(0,newEnergy-CareerAchievements.count(old.energy));
            socialState.pendingKeys=CareerAchievements.count(socialState.pendingKeys)+Math.max(0,newKeys-CareerAchievements.count(old.key));
            roadmapJourney.letters['1']=Math.min(100000000,CareerAchievements.count(roadmapJourney.letters['1'])+Math.max(0,CareerAchievements.count(data.totals.letter)-CareerAchievements.count(old.letter)));
            socialState.totals={letter:Math.max(CareerAchievements.count(data.totals.letter),CareerAchievements.count(old.letter)),energy:Math.max(newEnergy,CareerAchievements.count(old.energy)),key:Math.max(newKeys,CareerAchievements.count(old.key))};
            socialState.links=[];var friends:Array=[];
            for each(var connectedMember:Object in data.members)if(connectedMember.connected===true&&friends.indexOf(String(connectedMember.id))<0)friends.push(String(connectedMember.id));
            for each(var link:Object in data.links)if(link.status=="accepted"){
                var other:String=link.owner==data.userId?String(link.friend):String(link.owner);
                if(friends.indexOf(other)<0)friends.push(other);
                if(link.owner==data.userId)for each(var member:Object in data.members)if(member.id==link.friend&&member.team)socialState.links.push({player:link.player,friend:member.id,name:member.name,average:CareerAchievements.count(member.team.heroAverage)});
            }
            hallOfFame.stats.friends=friends.length;
            hallOfFame.stats.giftsSent=CareerAchievements.count(data.giftsSent);hallOfFame.stats.giftsReceived=CareerAchievements.count(data.giftsReceived);
            // Older drafts saved only the selection; finish that explicit recruitment now.
            for each(var draftFriend:String in friendDraft)recruitFriend(draftFriend);
            save();
        }
        private static function drainSocialKeys():void {
            if(!socialState||!mysteryInventory)return;
            var pending:int=CareerAchievements.count(socialState.pendingKeys);
            socialState.pendingKeys=pending-MysteryInventory.addKeys(mysteryInventory,pending);
        }
        public static function registeredFriend(p:Object):Object {
            if(!p||p===mainPlayer()||!p.socialId)return null;
            for each(var link:Object in socialState.links)if(link.player==p.socialId)return link;
            return null;
        }
        /** Recruit an accepted friend's character snapshot. Only this career grows it. */
        public static function friendPlayer(id:String):Object {for each(var p:Object in roster)if(p.friendId===id)return p;return null;}
        public static function recruitFriend(id:String):Object {
            init();var member:Object=FriendRoster.find(id);
            if(!FriendRoster.ready||!member)return {status:"NOT_FRIEND"};
            var existing:Object=friendPlayer(id);if(existing)return {status:"OWNED",player:existing};
            var profile:Object=member.profile;
            if(!profile||profile.heroReady!==true||!profile.attributes)return {status:"NOT_READY"};
            if(roster.length>=30)return {status:"ROSTER_FULL"};
            var base:String=String(member.name).substr(0,32),unique:String=base,suffix:int=2;
            while(playerByName(unique))unique=base+" ("+(suffix++)+")";
            var a:Object=profile.attributes;
            var p:Object=player(unique,String(profile.position||"CF"),Math.max(1,int(profile.level)),int(a.power),int(a.contact),int(a.speed),".000",0,0,Math.round((int(a.power)+int(a.contact)+int(a.speed))/3),"NORMAL",uint(profile.accent));
            p.friendId=id;p.friendName=member.name;p.socialId="friend-"+id;p.luck=int(a.luck);p.baseLuck=p.luck;
            p.appearance=JSON.parse(JSON.stringify(profile.appearance));p.skillPoints=0;p.baseAverage=".000";
            ensurePlayerMetadata(p);roster.push(p);save();return {status:"OK",player:p};
        }
        public static function friendAverageBonus(p:Object):Number {var link:Object=registeredFriend(p);return link?Math.min(1,Number(link.average)/1000)*.05:0;}
        public static function teamworkLimit(p:Object):int {return registeredFriend(p)?15:10;}
        private static function growRegularPlayers(rows:Array):void {
            for each(var row:Object in rows||[])if(!row.isHero&&!row.specialCardId&&int(row.atBats)>0)for each(var p:Object in roster)if(p!==mainPlayer()&&p.name==row.name){
                p.teamwork=Math.min(teamworkLimit(p),int(p.teamwork)+1);
                p.xp=int(p.xp)+int(Math.ceil((10+int(row.hits)*4)*(registeredFriend(p)?1.25:1)));
                while(int(p.xp)>=100){p.xp=int(p.xp)-100;p.level=int(p.level)+1;p.contact=Math.min(99,int(p.contact)+1);recalculateRating(p);}
            }
        }
        public static function effectivePower(p:Object):int {return statTotal(p,"power");}
        public static function effectiveContact(p:Object):int {return statTotal(p,"contact");}
        public static function effectiveSpeed(p:Object):int {return statTotal(p,"speed");}
        public static function effectiveLuck(p:Object):int {return statTotal(p,"luck");}
        public static function statTotal(p:Object,stat:String):int {return p?Math.max(0,Math.min(9999,int(p[stat])+(p===mainPlayer()?equipmentBonus(stat):0))):0;}
        public static function matchStat(p:Object,stat:String):int {
            var bonus:int=p===mainPlayer()?equipmentBonus(stat):0,scaled:Number=bonus<=30?bonus:30+Math.sqrt(bonus-30)*2;
            var mood:int=p===mainPlayer()?0:matchCondition(p)*2;
            return Math.max(1,Math.min(99,int(p[stat])+int(scaled)+mood+(stat=="contact"&&p!==mainPlayer()?Math.min(teamworkLimit(p),int(p.teamwork))*.1:0)));
        }
        public static function matchPower(p:Object):int {return matchStat(p,"power");}
        public static function matchContact(p:Object):int {return matchStat(p,"contact");}
        public static function matchSpeed(p:Object):int {return matchStat(p,"speed");}
        public static function matchLuck(p:Object):int {return matchStat(p,"luck");}
        public static function matchCondition(p:Object):int {
            if(!p)return 0;if(p.specialCardId)return 2;
            if(specialMatch&&specialMatch.conditionModifiers&&specialMatch.conditionModifiers[String(p.name)]!==undefined)return Math.max(-2,Math.min(2,int(specialMatch.conditionModifiers[String(p.name)])));
            return PlayerCondition.modifier(p);
        }
        // Compatibility accessors: condition is not a finite participation resource.
        public static function playerEnergy(p:Object):int {return p?PlayerCondition.MAX:0;}
        public static function playerReady(p:Object):Boolean {return p!=null;}
        public static function unstartablePlayers():Array {return [];}
        /** Placement is independent of the five capacity slots and follows visible row swaps. */
        private static function normalizeSpecialPositions():void {
            var order:Array=battingOrderPlayers(),used:Object={},result:Array=[],i:int,pos:int;
            for(i=0;i<5;i++){
                pos=specialPositions&&i<specialPositions.length&&specialPositions[i]!==null?int(specialPositions[i]):-1;
                if(pos<0||pos>=order.length||order[pos]===mainPlayer()||used[pos])pos=-1;
                result.push(pos);if(pos>=0)used[pos]=true;
            }
            for(i=0;i<5;i++)if(result[i]<0)for(pos=0;pos<order.length;pos++)if(order[pos]!==mainPlayer()&&!used[pos]){result[i]=pos;used[pos]=true;break;}
            specialPositions=result;
        }
        public static function matchBattingOrderPlayers():Array {
            if(!lineupLocked()||!(specialMatch.order is Array))return battingOrderPlayers();
            var result:Array=[];for each(var name:String in specialMatch.order){var p:Object=playerByName(name);if(p)result.push(p);}
            return result.length==9?result:battingOrderPlayers();
        }
        private static function placementForMatch():Array {
            if(lineupLocked()){
                if(specialMatch.positions is Array)return specialMatch.positions;
                // A fixture paid before this release retains its historical first non-hero mapping.
                var legacy:Array=[],order:Array=matchBattingOrderPlayers();for(var i:int=0;i<order.length&&legacy.length<5;i++)if(order[i]!==mainPlayer())legacy.push(i);return legacy;
            }
            normalizeSpecialPositions();return specialPositions;
        }
        public static function lineupCardAt(index:int):Object {
            var positions:Array=placementForMatch();
            for(var slot:int=0;slot<specialSlotsUnlocked;slot++)if(positions[slot]===index){
                if(lineupLocked()&&specialMatch.cards[slot])return specialMatch.cards[slot];
                return specialEquipped[slot]!=null?specialCardById(String(specialEquipped[slot])):null;
            }
            return null;
        }
        public static function lineupCardForMatchAt(index:int):Object {
            var positions:Array=placementForMatch();for(var slot:int=0;slot<specialSlotsUnlocked;slot++)if(positions[slot]===index)return specialCardForMatch(slot);return null;
        }
        public static function visibleLineupPlayers():Array {
            var order:Array=matchBattingOrderPlayers(),result:Array=[];for(var i:int=0;i<order.length;i++){var card:Object=lineupCardAt(i);result.push(card?lineupSpecialPlayer(card):order[i]);}return result;
        }
        public static function placeSpecialBatter(id:String,index:int):String {
            init();if(lineupLocked())return "MATCH_ACTIVE";
            if(!ownsSpecialCard(id))return "INVALID";
            var order:Array=battingOrderPlayers();if(index<0||index>=order.length)return "INVALID";
            if(order[index]===mainPlayer())return "HERO";
            normalizeSpecialCards();normalizeSpecialPositions();
            var chosen:int=-1,already:int=specialEquipped.indexOf(id),target:Object=lineupCardAt(index);
            if(target)chosen=specialEquipped.indexOf(String(target.id));
            else if(already>=0)chosen=already;
            else for(var i:int=0;i<specialSlotsUnlocked;i++)if(specialEquipped[i]==null){chosen=i;break;}
            if(chosen<0)return "FULL";
            if(already>=0&&already!=chosen)specialEquipped[already]=null;
            var old:int=int(specialPositions[chosen]);
            for(i=0;i<5;i++)if(i!=chosen&&specialPositions[i]===index)specialPositions[i]=old;
            specialPositions[chosen]=index;specialEquipped[chosen]=id;
            StarterTutorial.event(starterTutorial,"substitute",id);save();return "OK";
        }
        public static function benchSpecialBatter(index:int):String {
            if(lineupLocked())return "MATCH_ACTIVE";
            var card:Object=lineupCardAt(index);if(!card)return "INVALID";
            return unequipSpecialCard(String(card.id))?"OK":"INVALID";
        }
        public static function lineupSpecialPlayer(card:Object):Object {
            if(!card)return null;var p:Object={};for(var key:String in card)p[key]=card[key];
            p.specialCardId=card.id;p.pos="SP";p.level=specialCardLevel(card.id);p.avg=Number(card.avg)/1000;
            p.rating=int((int(p.power)+int(p.contact)+int(p.speed)+int(p.luck))/4);
            var state:Object=specialCardState(card.id);p.hr=0;p.rbi=state?int(state.rbi):0;return p;
        }
        public static var allowUnavailableLineup:Boolean=false;
        public static function autoReadyLineup():void {
            var order:Array=battingOrderPlayers(),used:Array=[],bench:Array=roster.concat();
            for each(var p:Object in order)used.push(String(p.name));
            bench.sortOn("rating",Array.NUMERIC|Array.DESCENDING);
            for(var i:int=0;i<order.length;i++)if(!playerReady(order[i]))for each(var replacement:Object in bench){
                if(playerReady(replacement)&&used.indexOf(String(replacement.name))<0&&replacement.grade!="PITCHER"){
                    used.push(String(replacement.name));order[i]=replacement;break;
                }
            }
            setBattingOrder(order);
        }

        public static function equipmentBonus(stat:String):int {
            if (!isTrainableStat(stat)) return 0;

            var total:int = 0;
            var slots:Array = [
                "bat",
                "glove",
                "belt",
                "helmet",
                "shoes",
                "goggles"
            ];

            if (!equipped) return 0;

            for each (var slot:String in slots) {
                var item:Object = slot=="bat"?matchBat():equipped[slot];

                if (
                    item &&
                    item[stat] !== undefined
                ) {
                    total += int(item[stat]);
                }
            }

            return total;
        }

        public static function batStock(item:Object):int {return ConsumableBats.count(consumableBats,item);}
        public static function matchBat():Object {
            return pendingSpecialMatch()&&specialMatch.batSnapshot?specialMatch.batSnapshot:equipped.bat;
        }
        public static function batStockLabel(item:Object):String {
            if(!ConsumableBats.isBat(item))return "";
            return batStock(item)+" LEFT"+(pendingSpecialMatch()&&specialMatch.batSnapshot&&specialMatch.batSnapshot.consumableId==item.consumableId?" + 1 IN PLAY":"");
        }
        private static function permanentBat():Object {
            var item:Object=findInventoryItem(String(consumableBats.returnName));
            return item&&item.slot=="bat"&&!ConsumableBats.isBat(item)?item:findInventoryItem("Rookie Bat");
        }
        private static function normalizeBats():void {
            consumableBats=ConsumableBats.normalize(consumableBats);
            for each(var item:Object in ConsumableBats.catalog())if(batStock(item)>0&&!findInventoryItem(String(item.name)))inventory.push(item);
            if(ConsumableBats.isBat(equipped.bat)&&batStock(equipped.bat)==0&&!(pendingSpecialMatch()&&specialMatch.batSnapshot&&specialMatch.batSnapshot.consumableId==equipped.bat.consumableId))equipped.bat=permanentBat();
        }
        private static function finishBatUse():void {
            var used:Object=specialMatch?specialMatch.batSnapshot:null;
            if(!ConsumableBats.isBat(used)||batStock(used)>0)return;
            consumableBats.expired={id:String(used.consumableId),fixture:String(specialMatch.key)};
            if(ConsumableBats.isBat(equipped.bat)&&equipped.bat.consumableId==used.consumableId)equipped.bat=permanentBat();
        }
        public static function acknowledgeBatExpired():void {consumableBats.expired=null;save();}

        public static function equipItem(item:Object):Boolean {
            if (!item) return false;

            var slot:String = String(item.slot);
            var validSlots:Array = [
                "bat",
                "glove",
                "belt",
                "helmet",
                "shoes",
                "goggles"
            ];

            if (validSlots.indexOf(slot) < 0) {
                return false;
            }

            if (!equipped) {
                equipped = {
                    bat:null,
                    glove:null,
                    belt:null,
                    helmet:null,
                    shoes:null,
                    goggles:null
                };
            }

            if(slot=="bat"){
                if(pendingSpecialMatch())return false;
                if(ConsumableBats.isBat(item)){
                    if(batStock(item)<=0)return false;
                    if(equipped.bat&&!ConsumableBats.isBat(equipped.bat))consumableBats.returnName=String(equipped.bat.name);
                }else consumableBats.returnName=String(item.name);
            }
            equipped[slot] = item;
            save();

            return true;
        }





        public static function battingOrderPlayers():Array {
            init();
            normalizeBattingOrder();

            var result:Array = [];

            for each (var name:String in battingOrder) {
                var p:Object =
                    playerByName(name);

                if (p) {
                    result.push(p);
                }
            }

            return result;
        }

        public static function playerByName(
            name:String
        ):Object {
            if (!roster) return null;

            for each (var p:Object in roster) {
                if (
                    p &&
                    String(p.name) == name
                ) {
                    return p;
                }
            }

            return null;
        }

        public static function setBattingOrder(
            order:Array
        ):void {
            if (!order) return;

            battingOrder = [];

            for each (var value:* in order) {
                var name:String =
                    value is String
                    ? String(value)
                    : (
                        value &&
                        value.name !== undefined
                        ? String(value.name)
                        : ""
                    );

                if (
                    name != "" &&
                    playerByName(name) &&
                    battingOrder.indexOf(name) < 0
                ) {
                    battingOrder.push(name);
                }

                if (battingOrder.length >= 9) {
                    break;
                }
            }

            normalizeBattingOrder();
            save();
        }

        public static function assignBattingOrder(
            slot:int,
            player:Object
        ):Boolean {
            init();
            normalizeBattingOrder();

            if (
                !player ||
                slot < 0 ||
                slot >= 9
            ) {
                return false;
            }

            var name:String =
                String(player.name);

            var existing:int =
                battingOrder.indexOf(name);

            if (existing >= 0) {
                var oldName:String =
                    String(battingOrder[slot]);

                battingOrder[slot] = name;
                battingOrder[existing] = oldName;
            }
            else {
                battingOrder[slot] = name;
            }

            normalizeBattingOrder();
            save();

            return true;
        }

        public static function substituteBattingOrder(
            slot:int,
            player:Object
        ):String {
            init();if(lineupLocked())return "MATCH_ACTIVE";
            normalizeBattingOrder();normalizeSpecialPositions();
            if(!player||slot<0||slot>=battingOrder.length)return "INVALID";
            if(player.specialCardId)return placeSpecialBatter(String(player.specialCardId),slot);
            var name:String=String(player.name),existing:int=battingOrder.indexOf(name);
            if(!playerByName(name))return "INVALID";
            if(existing>=0&&!lineupCardAt(existing))return "ALREADY";
            if(battingOrder[slot]==String(mainPlayer().name))return "HERO";
            var old:String=String(battingOrder[slot]),card:Object=lineupCardAt(slot);
            if(card)specialEquipped[specialEquipped.indexOf(String(card.id))]=null;
            if(existing>=0&&existing!=slot)battingOrder[existing]=old;
            battingOrder[slot]=name;normalizeBattingOrder();
            StarterTutorial.event(starterTutorial,"substitute",name);save();return "OK";
        }

        public static function moveBattingOrder(
            from:int,
            to:int
        ):Boolean {
            init();if(lineupLocked())return false;
            normalizeBattingOrder();normalizeSpecialPositions();

            if (
                from < 0 ||
                to < 0 ||
                from >= battingOrder.length ||
                to >= battingOrder.length ||
                from == to
            ) {
                return false;
            }

            var temp:* =
                battingOrder[from];

            battingOrder[from] =
                battingOrder[to];

            battingOrder[to] =
                temp;
            for(var slot:int=0;slot<5;slot++){if(specialPositions[slot]===from)specialPositions[slot]=to;else if(specialPositions[slot]===to)specialPositions[slot]=from;}
            if(starterTutorial.stage!=StarterTutorial.REORDER||temp==mainPlayer().name||battingOrder[from]==mainPlayer().name)StarterTutorial.event(starterTutorial,"order");

            save();
            return true;
        }

        public static function autoOptimizeBattingOrder():void {
            init();if(lineupLocked())return;
            var candidates:Array = [];

            for each (var p:Object in roster) {
                if (
                    p &&
                    String(p.pos) != "P"
                ) {
                    candidates.push(p);
                }
            }

            if (candidates.length < 9) {
                for each (var extra:Object in roster) {
                    if (
                        extra &&
                        candidates.indexOf(extra) < 0
                    ) {
                        candidates.push(extra);
                    }
                }
            }

            candidates.sort(
                function(
                    a:Object,
                    b:Object
                ):Number {
                    var scoreA:Number =
                        Number(matchStat(a,"contact")) * 1.20 +
                        Number(matchStat(a,"power")) * 0.95 +
                        Number(matchStat(a,"speed")) * 0.45;

                    var scoreB:Number =
                        Number(matchStat(b,"contact")) * 1.20 +
                        Number(matchStat(b,"power")) * 0.95 +
                        Number(matchStat(b,"speed")) * 0.45;

                    return scoreB - scoreA;
                }
            );

            battingOrder = [];

            for (
                var i:int = 0;
                i < candidates.length &&
                i < 9;
                i++
            ) {
                battingOrder.push(
                    String(candidates[i].name)
                );
            }

            normalizeBattingOrder();
            if(tutorialActive()&&starterTutorial.stage==StarterTutorial.AUTOSORT){
                specialEquipped[0]=starterTutorial.cardId;
                var heroIndex:int=battingOrder.indexOf(String(mainPlayer().name));
                if(heroIndex>=0){battingOrder.splice(heroIndex,1);battingOrder.splice(2,0,String(mainPlayer().name));}
                StarterTutorial.event(starterTutorial,"auto");
            }else StarterTutorial.event(starterTutorial,"order");
            save();
        }

        public static function substitutePlayers():Array {
            var visible:Array=visibleLineupPlayers(),names:Array=[],result:Array=[];
            for each(var active:Object in visible)if(!active.specialCardId)names.push(String(active.name));
            for each(var p:Object in roster)if(p&&names.indexOf(String(p.name))<0)result.push(p);return result;
        }

        public static function lineupSubstitutes():Array {
            var result:Array=[];
            for each(var card:Object in ownedSpecialCards()) {
                if(isSpecialCardEquipped(String(card.id)))continue;
                var p:Object={};for(var key:String in card)p[key]=card[key];
                p.specialCardId=card.id;p.pos="SP";p.level=specialCardLevel(card.id);
                p.rating=int((int(p.power)+int(p.contact)+int(p.speed)+int(p.luck))/4);
                var state:Object=specialCardState(card.id);
                p.avg=Number(card.avg)/1000;
                p.hr=0;p.rbi=int(state.rbi);result.push(p);
            }
            return result.concat(substitutePlayers());
        }

        public static function tradeValue(
            p:Object
        ):int {
            if (!p) return 0;

            return Math.max(
                500,
                int(p.rating) * 75 +
                int(p.level) * 140
            );
        }

        public static function releasePlayer(
            p:Object
        ):int {
            init();

            if (!p || p.friendId) return 0;

            var hero:Object =
                mainPlayer();

            if (
                hero &&
                String(hero.name) ==
                String(p.name)
            ) {
                return 0;
            }

            if (
                roster.length <= 9
            ) {
                return 0;
            }

            var value:int =
                tradeValue(p);

            var removeIndex:int =
                roster.indexOf(p);

            if (removeIndex < 0) {
                return 0;
            }

            var orderIndex:int =
                battingOrder.indexOf(
                    String(p.name)
                );

            roster.splice(
                removeIndex,
                1
            );

            if (orderIndex >= 0) {
                battingOrder.splice(
                    orderIndex,
                    1
                );
            }

            normalizeBattingOrder();

            coins += value;
            save();

            return value;
        }

        public static function recordPlateAppearance(
            p:Object,
            hit:Boolean,
            homeRun:Boolean,
            rbi:int,
            hitType:String = ""
        ):void {
            if (!p) return;

            ensurePlayerMetadata(p);

            p.careerAtBats =
                int(p.careerAtBats) + 1;

            if (hit) {
                p.careerHits =
                    int(p.careerHits) + 1;
            }

            if (homeRun) {
                p.hr =
                    int(p.hr) + 1;
            }

            if (hitType == "DOUBLE") {
                p.doubles =
                    int(p.doubles) + 1;
            }
            else if (hitType == "TRIPLE") {
                p.triples =
                    int(p.triples) + 1;
            }

            if (rbi > 0) {
                p.rbi =
                    int(p.rbi) + rbi;
            }

            var avg:Number =
                int(p.careerHits) /
                Math.max(
                    1,
                    int(p.careerAtBats)
                );

            p.careerAverage=formatAverage(avg);
            p.avg = p.baseAverage!==undefined?String(p.baseAverage):formatAverage(avg);

            save();
        }

        public static function recordWalk(
            p:Object,
            rbi:int = 0
        ):void {
            if (!p) return;

            ensurePlayerMetadata(p);

            p.walks =
                int(p.walks) + 1;

            if (rbi > 0) {
                p.rbi =
                    int(p.rbi) + rbi;
            }

            save();
        }

        private static function defaultBattingOrder():Array {
            var result:Array = [];

            if (!roster) return result;

            for each (var p:Object in roster) {
                if (
                    p &&
                    String(p.pos) != "P"
                ) {
                    result.push(
                        String(p.name)
                    );
                }

                if (result.length >= 9) {
                    break;
                }
            }

            if (result.length < 9) {
                for each (var extra:Object in roster) {
                    if (
                        extra &&
                        result.indexOf(
                            String(extra.name)
                        ) < 0
                    ) {
                        result.push(
                            String(extra.name)
                        );
                    }

                    if (result.length >= 9) {
                        break;
                    }
                }
            }

            return result;
        }

        private static function normalizeBattingOrder():void {
            if (!battingOrder) {
                battingOrder = [];
            }

            var cleaned:Array = [];

            for each (var name:String in battingOrder) {
                if (
                    name != "" &&
                    playerByName(name) &&
                    cleaned.indexOf(name) < 0
                ) {
                    cleaned.push(name);
                }

                if (cleaned.length >= 9) {
                    break;
                }
            }

            var fallback:Array =
                defaultBattingOrder();

            for each (var fallbackName:String in fallback) {
                if (
                    cleaned.indexOf(
                        fallbackName
                    ) < 0
                ) {
                    cleaned.push(
                        fallbackName
                    );
                }

                if (cleaned.length >= 9) {
                    break;
                }
            }

            var hero:Object =
                roster &&
                roster.length > 0
                ? roster[0]
                : null;

            if (hero) {
                var heroName:String =
                    String(hero.name);

                if (
                    cleaned.indexOf(
                        heroName
                    ) < 0
                ) {
                    if (cleaned.length >= 9) {
                        cleaned[8] =
                            heroName;
                    }
                    else {
                        cleaned.push(
                            heroName
                        );
                    }
                }
            }

            battingOrder = cleaned;
        }


        public static function specialCardCatalog():Array {return SpecialCardCatalog.cards();}

        private static function addDefaultSpecialCards():void {
            grantSpecialCard(
                "card_mlb2026_663728",
                true
            );

        }

        public static function specialAbilityChance(card:Object):Number {
            if(!card) return 0;
            switch(String(card.grade)) {
                case "HERO": return 1;
                case "ELITE": return .80;
                case "RARE": return .65;
                case "A": case "NORMAL": case "NORM": return .50;
            }
            return 0;
        }

        public static function specialAbilityLabel(card:Object):String {
            if(!card) return "";
            var n:int=int(card.triggerInning);
            var suffix:String=n%100>=11&&n%100<=13?"th":n%10==1?"st":n%10==2?"nd":n%10==3?"rd":"th";
            var hit:String=String(card.guaranteedHit);
            var shortHit:String=hit=="SINGLE"?"1B":hit=="DOUBLE"?"2B":hit=="TRIPLE"?"3B":hit=="HOME RUN"?"HR":hit;
            return n+suffix+" "+Math.round(specialAbilityChance(card)*100)+"% "+shortHit;
        }

        public static function specialCardById(id:String):Object {
            return SpecialCardInventory.describe(id,specialCardState(id));
        }

        public static function ownedSpecialCards():Array {
            SpecialCardInventory.normalize(specialOwned,new Date().time);
            var result:Array=[];
            for(var id:String in specialOwned) {
                var c:Object=specialCardById(id);if(c)result.push(c);
            }
            result.sortOn(["catalogId","id"],[0,0]);return result;
        }

        public static function ownsSpecialCard(
            id:String
        ):Boolean {
            return specialOwned != null &&
                   specialOwned[id] != null;
        }

        public static function specialCardState(id:String):Object {
            if(!specialOwned)specialOwned={};
            var s:Object=specialOwned[id];
            if(s&&s.instanceId===undefined)SpecialCardInventory.normalize(specialOwned,new Date().time);
            return s;
        }

        private static function grantSpecialCard(id:String,initial:Boolean=false):Object {
            if(!SpecialCardInventory.catalog(id))return null;
            if(initial&&specialOwned[id])return specialOwned[id];
            var uid:String=id;
            if(!initial) {do{uid="special_"+(++specialSerial);}while(specialOwned[uid]);}
            // Replace the dictionary when adding an instance. The browser runtime
            // can omit a dynamic property when serializing a parsed dictionary
            // that was extended in place after a previous save.
            var next:Object={};for(var key:String in specialOwned)next[key]=specialOwned[key];
            var s:Object=SpecialCardInventory.fresh(uid,id);next[uid]=s;specialOwned=next;return s;
        }

        public static function specialCardLevel(
            id:String
        ):int {
            var state:Object =
                specialCardState(id);

            return state
                ? Math.max(
                    1,
                    int(state.level)
                )
                : 0;
        }

        public static function specialCardCopies(id:String):int {
            var s:Object=specialCardState(id),base:String=s?String(s.cardId):id,n:int=0;
            for each(var other:Object in specialOwned)if(other&&other.cardId==base)n++;
            return Math.max(0,n-1);
        }
        public static function ownsSpecialCatalog(id:String):Boolean {
            for each(var s:Object in specialOwned)if(s&&(s.cardId==id||s.instanceId===undefined&&specialOwned[id]==s))return true;
            return false;
        }
        public static function specialCardEnergy(id:String):int {
            var s:Object=specialCardState(id);if(!s)return 0;
            SpecialCardInventory.recover(s,new Date().time);return int(s.charges);
        }
        public static function specialCardEnergyLabel(id:String):String {
            return SpecialCardInventory.energyLabel(specialCardState(id),new Date().time);
        }
        public static function pendingSpecialMatch():Boolean {
            return specialMatch!=null&&(specialMatch.key==specialMatchKey()||
                (postSeason!=null&&specialMatch.key==PostSeason.key(postSeason)));
        }
        /** A paid fixture stays paid while its lineup is prepared again outside the field. */
        public static function lineupLocked():Boolean {return pendingSpecialMatch()&&specialMatch.preparing!==true;}
        public static function prepareLineupEditing():Boolean {
            init();if(!pendingSpecialMatch()||specialMatch.preparing===true)return false;
            var seen:Object={},now:Number=new Date().time;
            for each(var card:Object in specialMatch.cards||[])if(card&&card.id&&!seen[String(card.id)]){
                seen[String(card.id)]=true;var state:Object=specialCardState(String(card.id));
                if(state){SpecialCardInventory.recover(state,now);state.charges=Math.min(2,int(state.charges)+1);if(state.charges==2)state.rechargeAt="0";}
            }
            specialMatch.preparing=true;specialMatch.cards=[null,null,null,null,null];
            // Retain the fixture key, the account-energy payment and the reserved bat use.
            save();return true;
        }
        private static function specialMatchKey():String {return postSeasonMode?PostSeason.key(postSeason):leagueIndex+":"+seasonNumber+":"+seasonGame;}
        public static function specialCardForMatch(slot:int):Object {
            if(lineupLocked())return slot<specialMatch.cards.length?specialMatch.cards[slot]:null;
            var id:String=String(specialEquipped[slot]);
            return specialCardEnergy(id)>0?specialCardById(id):null;
        }
        public static function specialEnhanceQuote(id:String,payment:String,max:Boolean=false):Object {
            var s:Object=specialCardState(id),c:Object=specialCardById(id);
            if(!s||!c)return {status:"NOT_OWNED"};
            if(pendingSpecialMatch())return {status:"MATCH_ACTIVE"};
            if(c.grade!="ELITE"&&c.grade!="HERO")return {status:"GRADE"};
            if(s.enhancement>=5)return {status:"MAX"};
            if(payment!="COINS"&&payment!="CASH"||max&&payment!="CASH")return {status:"PAYMENT"};
            var quote:Object=SpecialCardEconomy.enhance(c.cardClass,c.grade,int(s.enhancement),payment,max);
            quote.status="OK";return quote;
        }
        public static function enhanceSpecialCard(id:String,payment:String,max:Boolean=false):Object {
            var q:Object=specialEnhanceQuote(id,payment,max);if(q.status!="OK")return q;
            if(coins<q.coins)return {status:"COINS"};if(cash<q.cash)return {status:"CASH"};
            coins-=q.coins;cash-=q.cash;
            var success:Boolean=Math.random()<q.chance,s:Object=specialCardState(id);
            if(success){s.enhancement+=q.steps;s.level=1+int(s.enhancement);}
            save();return {status:success?"OK":"FAILED",card:specialCardById(id)};
        }
        public static function specialTradeQuote(ids:Array,payment:String):Object {
            if(!ids||ids.length!=3)return {status:"THREE"};
            if(pendingSpecialMatch())return {status:"MATCH_ACTIVE"};
            var seen:Object={},cls:String="";
            for each(var id:String in ids) {
                if(seen[id])return {status:"DUPLICATE"};seen[id]=true;
                if(!ownsSpecialCard(id))return {status:"NOT_OWNED"};
                if(isSpecialCardEquipped(id))return {status:"EQUIPPED"};
                var c:Object=specialCardById(id);if(!c)return {status:"NOT_OWNED"};
                if(cls&&cls!=c.cardClass)return {status:"CLASS"};cls=c.cardClass;
            }
            if(cls=="S")return {status:"MAX_CLASS"};
            if(payment!="COINS"&&payment!="CASH")return {status:"PAYMENT"};
            var classes:Array=["C","B","A","S"],index:int=classes.indexOf(cls);
            if(index<0)return {status:"CLASS"};
            var quote:Object=SpecialCardEconomy.trade(cls,payment);
            quote.status="OK";quote.fromClass=cls;quote.toClass=classes[index+1];return quote;
        }
        public static function tradeSpecialCards(ids:Array,payment:String):Object {
            var q:Object=specialTradeQuote(ids,payment);if(q.status!="OK")return q;
            if(coins<q.coins)return {status:"COINS"};if(cash<q.cash)return {status:"CASH"};
            var promoted:Boolean=Math.random()<q.chance;
            var resultClass:String=promoted?q.toClass:q.fromClass;
            var card:Object=SpecialCardCatalog.pick(resultClass,SpecialCardCatalog.classPackGrade(Math.random(),resultClass),Math.random());
            if(!card)return {status:"EMPTY"};
            for each(var id:String in ids)delete specialOwned[id];
            coins-=q.coins;cash-=q.cash;
            var state:Object=grantSpecialCard(card.id);CareerAchievements.add(hallOfFame,"trades");save();
            return {status:"OK",promoted:promoted,card:specialCardById(state.instanceId)};
        }
        public static function chargeSpecialCard(id:String):Object {
            var s:Object=specialCardState(id);if(!s)return {status:"NOT_OWNED"};
            if(pendingSpecialMatch())return {status:"MATCH_ACTIVE"};
            specialCardEnergy(id);var price:int=2-int(s.charges);
            if(price<=0)return {status:"FULL"};if(cash<price)return {status:"CASH"};
            cash-=price;s.charges=2;s.rechargeAt="0";save();return {status:"OK"};
        }

        public static function specialClassPackCost(packClass:String):Object {
            var pack:Object=SpecialCardCatalog.packById(packClass);if(!pack)return null;
            // Preserve the paid first-game lesson; later C packs use this video's price.
            return {coins:packClass=="C"&&tutorialActive()&&starterTutorial.stage==StarterTutorial.SHOP?6000:pack.coins,cash:pack.cash,unlockLeague:pack.unlockLeague};
        }

        /** One base edition per catalog ID through direct recruitment. Existing pack duplicates remain valid. */
        public static function recruit2026Normal(id:String):Object {
            init();var c:Object=MLB2026Catalog.entry(id);if(!c||!c.normalPlayer)return {status:"INVALID"};
            if(pendingSpecialMatch())return {status:"MATCH_ACTIVE"};if(tutorialActive())return {status:"TUTORIAL"};
            if(MLBNormalPlayers.owned(int(c.mlbId)))return {status:"ALREADY_OWNED"};if(roster.length>=30)return {status:"ROSTER_FULL"};
            if(coins<1500)return {status:"COINS"};var p:Object=MLBNormalPlayers.make(int(c.mlbId));if(!p)return {status:"INVALID"};
            coins-=1500;roster.push(p);CareerAchievements.add(hallOfFame,"cardsBought");save();return {status:"OK",player:p};
        }
        public static function recruit2026Player(id:String):Object {
            init();var card:Object=MLB2026Catalog.byId(id);
            if(!card)return {status:"INVALID_CARD"};
            if(pendingSpecialMatch())return {status:"MATCH_ACTIVE"};
            if(tutorialActive())return {status:"TUTORIAL"};
            if(ownsSpecialCatalog(id))return {status:"ALREADY_OWNED"};
            var unlock:int=MLB2026Catalog.league(card),price:int=MLB2026Catalog.price(card);
            if(leagueIndex<unlock)return {status:"LOCKED",unlockLeague:unlock};
            if(coins<price)return {status:"COINS"};
            return finishSpecialDraw(card,price,0,"2026");
        }
        public static function drawSpecialClassPack(packClass:String):Object {
            init();
            var cost:Object=specialClassPackCost(packClass);
            if(!cost)return {status:"INVALID_PACK"};
            if(leagueIndex<int(cost.unlockLeague))return {status:"LOCKED",unlockLeague:cost.unlockLeague};
            if(coins<int(cost.coins))return {status:"COINS"};
            if(cash<int(cost.cash))return {status:"CASH"};
            // Keep the first Class C tutorial discovery from the supplied video.
            var card:Object=packClass=="C"&&tutorialActive()&&starterTutorial.stage==StarterTutorial.SHOP?
                specialCardById("card_mlb2026_605244_hero"):
                SpecialCardCatalog.pick(SpecialCardCatalog.normalizeClass(packClass),SpecialCardCatalog.packGrade(packClass,Math.random()),Math.random());
            return finishSpecialDraw(card,int(cost.coins),int(cost.cash),packClass);
        }

        public static function drawSpecialCardPack(premium:Boolean):Object {
            init();var coinCost:int=premium?0:20000;var cashCost:int=premium?5:0;
            if(coins<coinCost)return {status:"COINS"};
            if(cash<cashCost)return {status:"CASH"};
            var cardClass:String=SpecialCardCatalog.mixedClass(Math.random(),premium);
            var card:Object=SpecialCardCatalog.pick(cardClass,
                SpecialCardCatalog.eligibleGrade(cardClass,rollSpecialGrade(premium)),Math.random());
            return finishSpecialDraw(card,coinCost,cashCost,"MIXED");
        }

        private static function finishSpecialDraw(card:Object,coinCost:int,cashCost:int,packClass:String):Object {
            if(!card)return {status:"EMPTY"};
            var wasOwned:Boolean=ownsSpecialCatalog(String(card.id));
            var state:Object=grantSpecialCard(String(card.id));
            coins-=coinCost;cash-=cashCost;CareerAchievements.add(hallOfFame,"cardsBought");
            lastSpecialDraw={status:"OK",card:specialCardById(state.instanceId),newCard:!wasOwned,copies:specialCardCopies(state.instanceId),
                packClass:packClass,coinCost:coinCost,cashCost:cashCost};
            if(packClass=="C")StarterTutorial.event(starterTutorial,"purchase",String(state.instanceId));
            save();return lastSpecialDraw;
        }

        private static function rollSpecialGrade(
            premium:Boolean
        ):String {
            var roll:Number =
                Math.random();

            if (premium) {
                if (roll < 0.28) {
                    return "HERO";
                }

                if (roll < 0.76) {
                    return "ELITE";
                }

                return "RARE";
            }

            if (roll < 0.54) {
                return "A";
            }

            if (roll < 0.84) {
                return "RARE";
            }

            if (roll < 0.97) {
                return "ELITE";
            }

            return "HERO";
        }

        // Historical caller compatibility: obsolete action cannot spend or delete copies.
        public static function combineSpecialCard(id:String):String {return "USE_ENHANCE";}

        public static function isSpecialCardEquipped(
            id:String
        ):Boolean {
            if (!specialEquipped) {
                return false;
            }

            return specialEquipped.indexOf(id) >= 0;
        }

        public static function equipSpecialCard(
            id:String
        ):String {
            init();

            if(lineupLocked())return "MATCH_ACTIVE";
            if (!ownsSpecialCard(id)) {
                return "NOT_OWNED";
            }

            if(tutorialActive()&&starterTutorial.stage==StarterTutorial.SUBSTITUTE&&id==starterTutorial.cardId)
                return useStarterCard()?"OK":"MATCH_ACTIVE";

            if (isSpecialCardEquipped(id)) {
                return "EQUIPPED";
            }

            normalizeSpecialCards();

            for (
                var i:int = 0;
                i < specialSlotsUnlocked;
                i++
            ) {
                if (
                    specialEquipped[i] == null ||
                    String(specialEquipped[i]) == ""
                ) {
                    specialEquipped[i] = id;normalizeSpecialPositions();
                    save();
                    return "OK";
                }
            }

            return "FULL";
        }

        public static function unequipSpecialCard(
            id:String
        ):Boolean {
            if(lineupLocked())return false;
            if (!specialEquipped) {
                return false;
            }

            var index:int =
                specialEquipped.indexOf(id);

            if (index < 0) {
                return false;
            }

            specialEquipped[index] = null;

            save();
            return true;
        }

        public static function equippedSpecialCards():Array {
            normalizeSpecialCards();

            var result:Array = [];

            for (
                var i:int = 0;
                i < specialSlotsUnlocked &&
                i < 5;
                i++
            ) {
                var id:* =
                    specialEquipped[i];

                if (
                    id != null &&
                    String(id) != ""
                ) {
                    var card:Object =
                        specialCardById(
                            String(id)
                        );

                    if (card) {
                        result.push(card);
                    }
                }
            }

            return result;
        }

        // Prices observed at 13:00-13:15 in the supplied first gameplay.
        // Existing unlocked slots are preserved; no retroactive balance changes.
        public static function nextSpecialSlotCost():Object {
            if(specialSlotsUnlocked>=5)return {coins:0,cash:0};
            return specialSlotCost(Math.max(1,specialSlotsUnlocked)+1);
        }
        public static function specialSlotCost(slot:int):Object {
            var costs:Array=[{coins:0,cash:0},{coins:1000,cash:0},{coins:2000,cash:0},{coins:0,cash:56},{coins:0,cash:72}];
            return slot>=1&&slot<=5?costs[slot-1]:{coins:0,cash:0};
        }
        public static function unlockNextSpecialSlot():String {
            normalizeSpecialCards();
            if(specialSlotsUnlocked>=5)return "MAX";
            var cost:Object=nextSpecialSlotCost();
            if(coins<int(cost.coins))return "COINS";
            if(cash<int(cost.cash))return "CASH";
            coins-=int(cost.coins);cash-=int(cost.cash);specialSlotsUnlocked++;
            save();return "OK";
        }
        public static function nextSpecialSlotPrice():String {
            if(specialSlotsUnlocked>=5)return "MAX";
            var cost:Object=nextSpecialSlotCost();
            return cost.coins>0?"C "+String(cost.coins).replace(/\B(?=(\d{3})+(?!\d))/g,","):"$ "+cost.cash;
        }

        public static function specialCombo(inMatch:Boolean=false):int {
            var total:Number=0;
            if(inMatch&&pendingSpecialMatch()) {
                for each(var paid:Object in specialMatch.cards)if(paid)total+=Number(paid.combo);
            } else for each(var card:Object in equippedSpecialCards())if(specialCardEnergy(card.id)>0)total+=Number(card.combo);
            return int(total);
        }

        public static function specialComboTier():String {
            var combo:int =
                specialCombo();

            if (combo >= 80) {
                return "MAX COMBO";
            }

            if (combo >= 60) {
                return "GOLD COMBO";
            }

            if (combo >= 40) {
                return "SILVER COMBO";
            }

            if (combo >= 20) {
                return "BRONZE COMBO";
            }

            return "NO COMBO";
        }

        public static function specialComboContactBonus(inMatch:Boolean=false):int {
            var combo:int =
                specialCombo(inMatch);

            if (combo >= 80) return 8;
            if (combo >= 60) return 6;
            if (combo >= 40) return 4;
            if (combo >= 20) return 2;

            return 0;
        }

        public static function specialComboLuckBonus(inMatch:Boolean=false):int {
            var combo:int =
                specialCombo(inMatch);

            if (combo >= 80) return 8;
            if (combo >= 60) return 6;
            if (combo >= 40) return 4;
            if (combo >= 20) return 2;

            return 0;
        }

        public static function specialComboTeamBonus(inMatch:Boolean=false):Number {
            var combo:int =
                specialCombo(inMatch);

            if (combo >= 80) return 0.075;
            if (combo >= 60) return 0.055;
            if (combo >= 40) return 0.035;
            if (combo >= 20) return 0.018;

            return 0;
        }

        public static function recordSpecialCardAtBat(
            id:String,
            hit:Boolean,
            rbi:int,
            walk:Boolean=false
        ):void {
            var state:Object =
                specialCardState(id);

            if (!state) return;

            if(walk)state.walks=int(state.walks)+1;
            else state.atBats =
                int(state.atBats) + 1;

            if (hit) {
                state.hits =
                    int(state.hits) + 1;
            }

            if (rbi > 0) {
                state.rbi =
                    int(state.rbi) + rbi;
            }

            save();
        }

        private static function normalizeSpecialCards():void {
            if(!specialOwned)specialOwned={};
            SpecialCardInventory.normalize(specialOwned,new Date().time);
            if(!specialEquipped)specialEquipped=[];
            specialSlotsUnlocked=Math.max(1,Math.min(5,specialSlotsUnlocked));
            specialEquipped=specialEquipped.slice(0,5);while(specialEquipped.length<5)specialEquipped.push(null);
            var seen:Object={};
            for(var i:int=0;i<5;i++) {
                var id:String=String(specialEquipped[i]);
                if(i>=specialSlotsUnlocked||!ownsSpecialCard(id)||seen[id])specialEquipped[i]=null;
                else seen[id]=true;
            }
        }

        public static function skillCatalog():Array {return SkillCatalog.items();}

        public static function skillById(
            id:String
        ):Object {
            var skills:Array = skillCatalog();

            for each (var skill:Object in skills) {
                if (
                    skill &&
                    String(skill.id) == id
                ) {
                    return skill;
                }
            }

            return null;
        }

        public static function skillLevel(
            p:Object,
            id:String
        ):int {
            if (!p) return 0;

            ensurePlayerMetadata(p);

            if (!p.skillLevels) {
                return 0;
            }

            var value:* =
                p.skillLevels[id];

            if (value === undefined) {
                return 0;
            }

            return int(value);
        }

        public static function activeSkillId(
            p:Object
        ):String {
            if (!p) return "";

            ensurePlayerMetadata(p);

            return p.activeSkill
                ? String(p.activeSkill)
                : "";
        }

        public static function activeSkillName(
            p:Object
        ):String {
            var id:String =
                activeSkillId(p);

            var skill:Object =
                skillById(id);

            if (!skill) {
                return "NO SKILL";
            }

            var lvl:int =
                skillLevel(
                    p,
                    id
                );

            return String(skill.shortName) +
                   " LV" +
                   lvl;
        }

        public static function setActiveSkill(
            p:Object,
            id:String
        ):Boolean {
            if (!p) return false;

            ensurePlayerMetadata(p);

            var skill:Object =
                skillById(id);

            if (!skill) return false;

            if (
                skillLevel(p, id) <= 0
            ) {
                return false;
            }

            p.activeSkill = id;
            save();

            return true;
        }

        public static function upgradeSkill(
            p:Object,
            id:String
        ):String {
            if (!p) return "INVALID";

            ensurePlayerMetadata(p);

            var skill:Object =
                skillById(id);

            if (!skill) return "INVALID";
            if(SkillCatalog.locked(skill,p,level)!="")return "LOCKED";

            var current:int =
                skillLevel(p, id);

            var maxLevel:int =
                int(skill.maxLevel);

            if (current >= maxLevel) {
                return "MAX";
            }

            var cost:int =
                current <= 0
                ? 1
                : current;

            if (
                int(p.skillPoints) < cost
            ) {
                return "POINTS";
            }

            p.skillPoints =
                int(p.skillPoints) -
                cost;

            p.skillLevels[id] =
                current + 1;

            if (
                activeSkillId(p) == "" ||
                current == 0
            ) {
                p.activeSkill = id;
            }

            save();

            return "OK";
        }

        public static function skillPowerBonus(
            p:Object,
            inning:int,
            homeScore:int,
            awayScore:int
        ):int {
            if (!p) return 0;

            var id:String =
                activeSkillId(p);

            var level:int =
                skillLevel(p, id);

            if (level <= 0) {
                return 0;
            }

            if (id == "POWER_HITTER") {
                return 4 + level * 3;
            }

            if (
                id == "CLUTCH" &&
                inning >= 3 &&
                homeScore <= awayScore
            ) {
                return 5 + level * 4;
            }

            if(id=="SLUGGER")return 7+level*5;
            return 0;
        }

        public static function skillContactBonus(
            p:Object,
            inning:int,
            homeScore:int,
            awayScore:int
        ):int {
            if (!p) return 0;

            var id:String =
                activeSkillId(p);

            var level:int =
                skillLevel(p, id);

            if (level <= 0) {
                return 0;
            }

            if (id == "BATTING_EYE") {
                return 3 + level * 4;
            }

            if (
                id == "CLUTCH" &&
                inning >= 3 &&
                homeScore <= awayScore
            ) {
                return 4 + level * 4;
            }

            if(id=="CONTACT_MASTER")return 5+level*4;
            return 0;
        }

        public static function skillGoodRunBonus(
            p:Object
        ):Number {
            if (!p) return 0;

            var id:String =
                activeSkillId(p);

            var level:int =
                skillLevel(p, id);

            if (
                id == "POWER_HITTER" &&
                level > 0
            ) {
                return 0.05 * level;
            }

            return 0;
        }

        public static function skillDefenseBonus(
            p:Object
        ):Number {
            if (!p) return 0;

            var id:String =
                activeSkillId(p);

            var level:int =
                skillLevel(p, id);

            if (
                id == "SPEEDSTER" &&
                level > 0
            ) {
                return 0.035 * level;
            }

            if(id=="DEFENSE_CAPTAIN"&&level>0)return .045*level;
            return 0;
        }

        public static function skillFoulTolerance(p:Object):Number {return activeSkillId(p)=="PATIENT_HITTER"?.12*skillLevel(p,"PATIENT_HITTER"):0;}
        public static function skillDoubleBonus(p:Object):Number {return activeSkillId(p)=="LINE_DRIVE"?.03*skillLevel(p,"LINE_DRIVE"):0;}
        public static function skillTripleBonus(p:Object):Number {return activeSkillId(p)=="BASE_RUNNER"?.02*skillLevel(p,"BASE_RUNNER"):0;}
        public static function skillComboBonus(p:Object):int {return activeSkillId(p)=="TEAM_SPIRIT"?skillLevel(p,"TEAM_SPIRIT"):0;}
        public static function skillLuckyChance(p:Object):Number {return activeSkillId(p)=="LUCKY_SWING"?.08*skillLevel(p,"LUCKY_SWING"):matchLuck(p)>=82?.22:0;}
        public static function currentOpponent():Object {
            if(postSeasonMode&&PostSeason.opponent(postSeason))return PostSeason.opponent(postSeason);
            return opponentForGame(
                seasonGame
            );
        }

        public static function opponentForGame(
            gameNumber:int,forLeague:int=-1
        ):Object {
            var activeLeague:int=forLeague<0?leagueIndex:Math.max(0,Math.min(4,forLeague));
            var teamNames:Array = [
                "RIVALS",
                "COMETS",
                "TIGERS",
                "SHARKS",
                "BLAZERS",
                "KINGS",
                "GIANTS",
                "STARS"
            ];

            var cityNames:Array = [
                "ST. LOUIS",
                "COLORADO",
                "ARIZONA",
                "HOUSTON",
                "CHICAGO",
                "NEW YORK",
                "SEATTLE",
                "MIAMI"
            ];

            var pitcherNames:Array = MLBNormalPlayers.pitcherNames();

            var accents:Array = [
                0xc84e45,
                0x4b82bb,
                0x8c5bb0,
                0x3b8b70,
                0xd27c39,
                0xc4a338,
                0x52698b,
                0xb95478
            ];

            var mapX:Array = [
                435, 305, 225, 386,
                487, 705, 113, 654
            ];

            var mapY:Array = [
                215, 202, 279, 319,
                150, 145, 109, 359
            ];

            gameNumber =
                Math.max(
                    1,
                    Math.min(
                        30,
                        gameNumber
                    )
                );

            var index:int =
                (
                    gameNumber -
                    1 +
                    activeLeague *
                    2
                ) %
                teamNames.length;

            var rating:int =
                64 +
                activeLeague *
                7 +
                (
                    gameNumber %
                    5
                );

            rating =
                Math.min(
                    96,
                    rating
                );

            var repertoire:Array = [
                "FASTBALL",
                "SINKER",
                "CURVEBALL",
                "CHANGEUP"
            ];

            if (activeLeague >= 1) {
                // Breaking ball already appears in ROOKIE references.
            }

            if (activeLeague >= 2) {
                repertoire.push(
                    "SLIDER"
                );
            }

            if (activeLeague >= 3) {
                // Two-seam family already appears in ROOKIE references.
            }

            if (activeLeague >= 4) {
                repertoire.push(
                    "CUTTER"
                );
            }

            return {
                game:gameNumber,
                teamName:String(
                    teamNames[index]
                ),
                city:String(
                    cityNames[index]
                ),
                pitcherName:String(
                    pitcherNames[index]
                ),
                rating:rating,
                accent:uint(
                    accents[index]
                ),
                mapX:Number(
                    mapX[index]
                ),
                mapY:Number(
                    mapY[index]
                ),
                repertoire:repertoire
            };
        }

        public static function seasonScheduleWindow(
            count:int = 5
        ):Array {
            var result:Array = [];

            count =
                Math.max(
                    1,
                    Math.min(
                        8,
                        count
                    )
                );

            var startGame:int =
                Math.max(
                    1,
                    seasonGame
                );

            if (
                startGame +
                count -
                1 >
                30
            ) {
                startGame =
                    Math.max(
                        1,
                        30 -
                        count +
                        1
                    );
            }

            for (
                var i:int = 0;
                i < count;
                i++
            ) {
                var gameNumber:int =
                    startGame +
                    i;

                var opponent:Object =
                    opponentForGame(
                        gameNumber
                    );

                opponent.current =
                    gameNumber ==
                    seasonGame;

                result.push(
                    opponent
                );
            }

            return result;
        }

        public static function levelXpTarget():int {
            // Local first-level calibration: the reference is already Lv2 at 79 XP.
            // Legacy careers retain their original thresholds and unspent progress.
            if(careerStartVersion>=4&&level==1)return 50;
            return 180 +
                   Math.max(
                       0,
                       level - 1
                   ) *
                   20;
        }

        private static function applyLevelProgress(
            amount:int
        ):Object {
            lastLevelUpSummary = null;

            levelProgress +=
                Math.max(
                    0,
                    amount
                );

            var totalLevels:int = 0;
            var totalCoins:int = 0;
            var totalSkillPoints:int = 0;
            var totalMaxEnergy:int = 0;
            var fromLevel:int = level;

            while (
                levelProgress >=
                levelXpTarget()
            ) {
                levelProgress -=
                    levelXpTarget();

                level++;
                totalLevels++;
                // Level 12 visibly awards 3,000 in the supplied A-league video.
                // Other level rewards are unchanged until observed.
                totalCoins += level==12?3000:2000;
                totalSkillPoints++;
                totalMaxEnergy++;
            }

            if (
                totalLevels <= 0
            ) {
                return null;
            }

            coins += totalCoins;
            maxEnergy +=
                totalMaxEnergy;

            energy=Math.max(energy,maxEnergy);energyAt="0";

            var hero:Object =
                mainPlayer();

            ensurePlayerMetadata(
                hero
            );

            hero.skillPoints =
                int(
                    hero.skillPoints
                ) +
                totalSkillPoints;

            var unlocks:Array=shopCatalog().filter(function(item:Object,index:int,array:Array):Boolean {return int(item.unlockLevel)>fromLevel&&int(item.unlockLevel)<=level&&int(item.unlockLeague)<=leagueIndex;});
            // The level-12 banner previews Panda, Pink Love and Camo first.
            var previews:Array=["Panda","Pink Love","Camo"];
            unlocks.sort(function(a:Object,b:Object):Number {var ai:int=previews.indexOf(a.name),bi:int=previews.indexOf(b.name);return (ai<0?99:ai)-(bi<0?99:bi);});
            lastLevelUpSummary = {
                fromLevel:fromLevel,
                toLevel:level,
                levels:totalLevels,
                coins:totalCoins,
                skillPoints:totalSkillPoints,
                maxEnergy:totalMaxEnergy,
                // Shop access depends on league; account levels grant rewards.
                unlocked:unlocks
            };

            return lastLevelUpSummary;
        }


        public static function shopCatalog():Array {return legacyShopCatalog().concat(ConsumableBats.catalog(),EquipmentCatalog.items(),StadiumCatalog.items());}
        private static function legacyShopCatalog():Array {
            return [
                // ---------- Equipment ----------
                shopItem(
                    "shop_slugger_x",
                    "Slugger X Bat",
                    "EQUIPMENT",
                    "bat",
                    "RARE",
                    0x4f86bf,
                    75000,
                    0,
                    1,
                    9,
                    0,
                    0,
                    "Heavy bat built for long-ball hitters."
                ),
                shopItem(
                    "shop_precision_pro",
                    "Precision Pro Bat",
                    "EQUIPMENT",
                    "bat",
                    "ELITE",
                    0xc05a92,
                    90000,
                    0,
                    2,
                    4,
                    7,
                    0,
                    "Balanced barrel with a large contact sweet spot."
                ),
                shopItem(
                    "shop_diamond_glove",
                    "Diamond Glove",
                    "EQUIPMENT",
                    "glove",
                    "RARE",
                    0x4f86bf,
                    55000,
                    0,
                    1,
                    0,
                    2,
                    4,
                    "Fast transfer glove for defense and mobility."
                ),
                shopItem(
                    "shop_major_cleats",
                    "Major Cleats",
                    "EQUIPMENT",
                    "shoes",
                    "HERO",
                    0xe2b63d,
                    0,
                    12,
                    4,
                    2,
                    2,
                    9,
                    "Top-tier cleats unlocked at Major League.",
                    1
                ),
                shopItem(
                    "shop_power_belt",
                    "Titan Power Belt",
                    "EQUIPMENT",
                    "belt",
                    "RARE",
                    0xb45c43,
                    48000,
                    0,
                    1,
                    4,
                    1,
                    0,
                    "Reinforced belt for stronger rotational power.",
                    0
                ),
                shopItem(
                    "shop_champion_belt",
                    "Champion Belt",
                    "EQUIPMENT",
                    "belt",
                    "ELITE",
                    0xd8ae35,
                    82000,
                    0,
                    2,
                    4,
                    3,
                    0,
                    "High-grade belt balancing power and control.",
                    2
                ),
                shopItem(
                    "shop_pro_helmet",
                    "Pro Batting Helmet",
                    "EQUIPMENT",
                    "helmet",
                    "RARE",
                    0x4d8ec0,
                    52000,
                    0,
                    1,
                    0,
                    4,
                    0,
                    "Protective batting helmet with improved focus.",
                    2
                ),
                shopItem(
                    "shop_hero_helmet",
                    "Hero Helmet",
                    "EQUIPMENT",
                    "helmet",
                    "HERO",
                    0xe2b63d,
                    0,
                    10,
                    3,
                    2,
                    5,
                    0,
                    "Hero-grade helmet with a bright premium finish.",
                    3
                ),
                shopItem(
                    "shop_eagle_goggles",
                    "Eagle Goggles",
                    "EQUIPMENT",
                    "goggles",
                    "RARE",
                    0x45a4c4,
                    60000,
                    0,
                    1,
                    0,
                    3,
                    0,
                    "Wide-vision sports goggles for pitch recognition.",
                    5
                ),
                shopItem(
                    "shop_hero_goggles",
                    "Hero Goggles",
                    "EQUIPMENT",
                    "goggles",
                    "HERO",
                    0xe2b63d,
                    0,
                    10,
                    3,
                    1,
                    3,
                    0,
                    "Premium goggles with the strongest Luck bonus.",
                    8
                ),

                // ---------- Stadium ----------
                // Background / Field / Stand / Fence categories are visible
                // in the original Build Mode bottom dock.
                stadiumShopItem(
                    "stadium_background_mountain",
                    "Mountain Classic",
                    "background",
                    "NORMAL",
                    0x8bc9da,
                    0,
                    0,
                    0,
                    "Classic mountain-and-cloud backdrop."
                ),
                stadiumShopItem(
                    "stadium_background_ocean",
                    "Treasure Island",
                    "background",
                    "RARE",
                    0x2e9fc8,
                    7500,
                    0,
                    0,
                    "Pirate-themed island stadium from the supplied visual archive."
                ),
                stadiumShopItem(
                    "stadium_background_city",
                    "Major City",
                    "background",
                    "RARE",
                    0x77b8d0,
                    12000,
                    0,
                    1,
                    "Downtown Major-style stadium from the supplied visual archive."
                ),
                stadiumShopItem(
                    "stadium_background_triplea",
                    "Triple-A Liberty",
                    "background",
                    "ELITE",
                    0x4b8fc4,
                    44000,
                    0,
                    2,
                    "Triple-A landmark stadium skin supplied from the original visual archive."
                ),
                stadiumShopItem(
                    "stadium_background_holiday",
                    "Holiday Ballpark",
                    "background",
                    "ELITE",
                    0xa56fe0,
                    22000,
                    0,
                    1,
                    "Snowy holiday stadium skin supplied from the original visual archive."
                ),
                stadiumShopItem(
                    "stadium_background_devil",
                    "Devil Castle",
                    "background",
                    "ELITE",
                    0x39495a,
                    36000,
                    0,
                    2,
                    "Moonlit castle stadium skin supplied from the original visual archive."
                ),
                stadiumShopItem(
                    "stadium_background_major_night",
                    "Major Night",
                    "background",
                    "HERO",
                    0x174a8c,
                    52000,
                    0,
                    3,
                    "Major League city-night stadium skin supplied from the original visual archive."
                ),

                stadiumShopItem(
                    "stadium_field_classic",
                    "Classic Field",
                    "field",
                    "NORMAL",
                    0x2c8c49,
                    0,
                    0,
                    0,
                    "Standard Rookie League grass."
                ),
                stadiumShopItem(
                    "stadium_field_pro",
                    "Pro Field",
                    "field",
                    "RARE",
                    0x258342,
                    7500,
                    0,
                    0,
                    "Sharper mowing pattern and richer grass."
                ),
                stadiumShopItem(
                    "stadium_field_tropical",
                    "Tropical Field",
                    "field",
                    "ELITE",
                    0x2c9851,
                    15000,
                    0,
                    1,
                    "Lush upgraded playing surface."
                ),

                stadiumShopItem(
                    "stadium_stand_brown",
                    "Rookie Stand",
                    "stand",
                    "NORMAL",
                    0x8c5d3e,
                    0,
                    0,
                    0,
                    "Simple wooden Rookie League grandstand."
                ),
                stadiumShopItem(
                    "stadium_stand_purple",
                    "Purple Classic",
                    "stand",
                    "RARE",
                    0x6c4aa5,
                    9000,
                    0,
                    0,
                    "Purple grandstand visible in the historical Build Mode."
                ),
                stadiumShopItem(
                    "stadium_stand_green",
                    "Emerald Stand",
                    "stand",
                    "RARE",
                    0x278044,
                    12000,
                    0,
                    1,
                    "Green upgraded grandstand."
                ),

                stadiumShopItem(
                    "stadium_fence_plain",
                    "Plain Fence",
                    "fence",
                    "NORMAL",
                    0x1c6540,
                    0,
                    0,
                    0,
                    "Simple outfield advertising fence."
                ),
                stadiumShopItem(
                    "stadium_fence_apex",
                    "Apex Fence",
                    "fence",
                    "RARE",
                    0xd9a52d,
                    5000,
                    0,
                    0,
                    "Green fence with repeating sponsor panels."
                ),
                stadiumShopItem(
                    "stadium_fence_champion",
                    "Champion Fence",
                    "fence",
                    "ELITE",
                    0x365f83,
                    16000,
                    0,
                    2,
                    "Premium outfield fence treatment."
                ),

                stadiumShopItem(
                    "stadium_scoreboard_classic",
                    "Classic Scoreboard",
                    "scoreboard",
                    "NORMAL",
                    0x1f8048,
                    0,
                    0,
                    0,
                    "The original BH Park center-field board."
                ),
                stadiumShopItem(
                    "stadium_scoreboard_gold",
                    "Golden Scoreboard",
                    "scoreboard",
                    "RARE",
                    0xc18d2c,
                    28000,
                    0,
                    0,
                    "Warm gold stadium display."
                ),
                stadiumShopItem(
                    "stadium_scoreboard_neon",
                    "Neon Scoreboard",
                    "scoreboard",
                    "ELITE",
                    0x336fc4,
                    60000,
                    0,
                    2,
                    "Bright blue modern center-field board."
                ),

                stadiumShopItem(
                    "stadium_banner_red",
                    "Home Run Banner",
                    "banner",
                    "NORMAL",
                    0xd65447,
                    0,
                    0,
                    0,
                    "Classic red outfield advertisement."
                ),
                stadiumShopItem(
                    "stadium_banner_blue",
                    "Victory Banner",
                    "banner",
                    "RARE",
                    0x4e8ec7,
                    18000,
                    0,
                    1,
                    "Blue victory-themed stadium signage."
                ),
                stadiumShopItem(
                    "stadium_banner_gold",
                    "Champions Banner",
                    "banner",
                    "HERO",
                    0xd7aa37,
                    0,
                    8,
                    3,
                    "Premium championship signage."
                ),

                stadiumShopItem(
                    "stadium_lights_basic",
                    "Basic Lights",
                    "lights",
                    "NORMAL",
                    0xeaf5ff,
                    0,
                    0,
                    0,
                    "Standard ballpark light towers."
                ),
                stadiumShopItem(
                    "stadium_lights_pro",
                    "Pro Lights",
                    "lights",
                    "RARE",
                    0x8ed8ff,
                    32000,
                    0,
                    1,
                    "Stronger cool-white stadium illumination."
                ),
                stadiumShopItem(
                    "stadium_lights_gold",
                    "Festival Lights",
                    "lights",
                    "ELITE",
                    0xffdf79,
                    50000,
                    0,
                    2,
                    "Warm celebratory ballpark lighting."
                ),

                stadiumShopItem(
                    "stadium_wall_green",
                    "Green Outfield Wall",
                    "wall",
                    "NORMAL",
                    0x1c6540,
                    0,
                    0,
                    0,
                    "Traditional green outfield wall."
                ),
                stadiumShopItem(
                    "stadium_wall_blue",
                    "Blue Outfield Wall",
                    "wall",
                    "RARE",
                    0x245b7a,
                    22000,
                    0,
                    1,
                    "Cool blue wall treatment for BH Park."
                ),
                stadiumShopItem(
                    "stadium_wall_gold",
                    "Champions Wall",
                    "wall",
                    "HERO",
                    0x8b6c25,
                    65000,
                    0,
                    3,
                    "Premium wall unlocked in Triple-A."
                ),

                // ---------- Placeable Decorations ----------
                stadiumShopItem(
                    "stadium_deco_flag",
                    "Heroes Flag",
                    "decoration",
                    "NORMAL",
                    0xd94f45,
                    12000,
                    0,
                    0,
                    "Placeable team flag for the outfield."
                ),
                stadiumShopItem(
                    "stadium_deco_star",
                    "Victory Star",
                    "decoration",
                    "RARE",
                    0xffd34f,
                    26000,
                    0,
                    1,
                    "Large victory star decoration."
                ),
                stadiumShopItem(
                    "stadium_deco_ball",
                    "Giant Baseball",
                    "decoration",
                    "RARE",
                    0xe8edf1,
                    30000,
                    0,
                    1,
                    "Oversized baseball prop for BH Park."
                ),
                stadiumShopItem(
                    "stadium_deco_trophy",
                    "League Trophy",
                    "decoration",
                    "ELITE",
                    0xe0b13a,
                    52000,
                    0,
                    2,
                    "Placeable league trophy monument."
                ),
                stadiumShopItem(
                    "stadium_deco_fireworks",
                    "Fireworks Tower",
                    "decoration",
                    "HERO",
                    0xb879e7,
                    0,
                    10,
                    3,
                    "Premium celebration tower."
                ),

                // ---------- Resources ----------
                resourceShopItem(
                    "energy_drink",
                    "Energy Drink",
                    "NORMAL",
                    0x4eaa49,
                    7000,
                    0,
                    0,
                    5,
                    "Restore 5 Energy."
                ),
                resourceShopItem(
                    "energy_crate",
                    "Energy Crate",
                    "RARE",
                    0x50a6d5,
                    0,
                    5,
                    0,
                    20,
                    "Restore 20 Energy."
                )
            ];
        }

        private static function shopItem(
            id:String,
            name:String,
            category:String,
            slot:String,
            grade:String,
            accent:uint,
            coinPrice:int,
            cashPrice:int,
            unlockLeague:int,
            power:int,
            contact:int,
            speed:int,
            description:String,
            luck:int = 0
        ):Object {
            return {
                id:id,
                name:name,
                category:category,
                slot:slot,
                grade:grade,
                accent:accent,
                coinPrice:coinPrice,
                cashPrice:cashPrice,
                unlockLeague:unlockLeague,
                power:power,
                contact:contact,
                speed:speed,
                luck:luck,
                description:description,
                energy:0
            };
        }

        private static function stadiumShopItem(
            id:String,
            name:String,
            slot:String,
            grade:String,
            accent:uint,
            coinPrice:int,
            cashPrice:int,
            unlockLeague:int,
            description:String
        ):Object {
            return {
                id:id,
                name:name,
                category:"STADIUM",
                slot:slot,
                grade:grade,
                accent:accent,
                coinPrice:coinPrice,
                cashPrice:cashPrice,
                unlockLeague:unlockLeague,
                power:0,
                contact:0,
                speed:0,
                energy:0,
                description:description
            };
        }

        private static function resourceShopItem(
            id:String,
            name:String,
            grade:String,
            accent:uint,
            coinPrice:int,
            cashPrice:int,
            unlockLeague:int,
            energyAmount:int,
            description:String
        ):Object {
            return {
                id:id,
                name:name,
                category:"ENERGY",
                slot:"resource",
                grade:grade,
                accent:accent,
                coinPrice:coinPrice,
                cashPrice:cashPrice,
                unlockLeague:unlockLeague,
                power:0,
                contact:0,
                speed:0,
                energy:energyAmount,
                description:description
            };
        }

        public static function shopItemsByCategory(
            category:String
        ):Array {
            var result:Array = [];
            var catalog:Array = shopCatalog();

            for each (var item:Object in catalog) {
                if (
                    item &&
                    String(item.category) == category
                ) {
                    result.push(item);
                }
            }

            return result;
        }

        public static function shopItemById(
            id:String
        ):Object {
            var catalog:Array = shopCatalog();

            for each (var item:Object in catalog) {
                if (
                    item &&
                    String(item.id) == id
                ) {
                    return item;
                }
            }

            return null;
        }

        public static function shopItemUnlocked(
            item:Object
        ):Boolean {
            if (!item) return false;

            return leagueIndex >= int(item.unlockLeague) && level >= int(item.unlockLevel||0);
        }

        public static function ownsShopItem(
            item:Object
        ):Boolean {
            if (!item) return false;
            if(ConsumableBats.isBat(item))return false;

            var category:String =
                String(item.category);

            if (category == "EQUIPMENT") {
                return findInventoryItem(
                    String(item.name)
                ) != null;
            }

            if (category == "STADIUM") {
                return ownsStadiumItem(
                    String(item.id)
                );
            }

            // Consumables can be purchased repeatedly.
            return false;
        }

        public static function shopPriceLabel(
            item:Object
        ):String {
            if (!item) return "";

            if (int(item.cashPrice) > 0) {
                return "$ " +
                       int(item.cashPrice);
            }

            if (int(item.coinPrice) <= 0) {
                return "OWNED";
            }

            return "C " +
                   formatInteger(
                       int(item.coinPrice)
                   );
        }

        public static function purchaseShopItem(
            item:Object
        ):String {
            init();

            if (!item) return "INVALID";

            if (!shopItemUnlocked(item)) {
                return "LOCKED";
            }

            // Recheck after natural recovery, including a confirmation left open.
            // Purchased energy below the cap retains its full amount, even above it.
            if (String(item.category) == "ENERGY") {
                if (int(item.energy) <= 0) return "INVALID";
                if (energy >= maxEnergy) return "FULL";
            }

            if (
                String(item.category) != "ENERGY" &&
                ownsShopItem(item)
            ) {
                return "OWNED";
            }

            var coinPrice:int =
                int(item.coinPrice);

            var cashPrice:int =
                int(item.cashPrice);

            if (
                coinPrice > 0 &&
                coins < coinPrice
            ) {
                return "COINS";
            }

            if (
                cashPrice > 0 &&
                cash < cashPrice
            ) {
                return "CASH";
            }

            if(ConsumableBats.isBat(item)&&batStock(item)>ConsumableBats.CAP-int(item.bundle))return "FULL";
            coins -= coinPrice;
            cash -= cashPrice;

            var category:String =
                String(item.category);

            if(ConsumableBats.isBat(item)){
                ConsumableBats.add(consumableBats,item);
                if(!findInventoryItem(String(item.name)))inventory.push(ConsumableBats.byId(String(item.consumableId)));
            }
            else if (category == "EQUIPMENT") {
                inventory.push(
                    equipment(
                        String(item.name),
                        String(item.slot),
                        String(item.grade),
                        uint(item.accent),
                        int(item.power),
                        int(item.contact),
                        int(item.speed),
                        item.luck !== undefined
                        ? int(item.luck)
                        : 0
                    )
                );
            }
            else if (category == "STADIUM") {
                if (!ownsStadiumItem(String(item.id))) {
                    stadiumOwned.push(
                        String(item.id)
                    );
                }
            }
            else if (category == "ENERGY") {
                energy +=
                    Math.max(
                        0,
                        int(item.energy)
                    );
            }

            save();

            return "OK";
        }

        public static function ownsStadiumItem(
            id:String
        ):Boolean {
            if (!stadiumOwned) return false;

            return stadiumOwned.indexOf(id) >= 0;
        }

        public static function ownedStadiumItems():Array {
            var result:Array = [];
            var catalog:Array =
                shopItemsByCategory("STADIUM");

            for each (var item:Object in catalog) {
                if (
                    item &&
                    ownsStadiumItem(
                        String(item.id)
                    )
                ) {
                    result.push(item);
                }
            }

            return result;
        }


        public static function isPlaceableDecoration(
            item:Object
        ):Boolean {
            return item != null &&
                   String(item.category) == "STADIUM" &&
                   String(item.slot) == "decoration";
        }

        public static function addStadiumDecoration(
            item:Object,
            px:Number = 278,
            py:Number = 225
        ):Boolean {
            if (!isPlaceableDecoration(item)) {
                return false;
            }

            if (
                !ownsStadiumItem(
                    String(item.id)
                )
            ) {
                return false;
            }

            if (!stadiumDecorations) {
                stadiumDecorations = [];
            }

            // Max 8 placed decorations to keep the preview readable.
            if (stadiumDecorations.length >= 8) {
                return false;
            }

            stadiumDecorations.push({
                id:String(item.id),
                x:px,
                y:py,
                scale:1.0
            });

            save();
            return true;
        }

        public static function updateStadiumDecoration(
            index:int,
            px:Number,
            py:Number,
            scale:Number = 1.0
        ):Boolean {
            if (
                !stadiumDecorations ||
                index < 0 ||
                index >= stadiumDecorations.length
            ) {
                return false;
            }

            var entry:Object =
                stadiumDecorations[index];

            entry.x =
                Math.max(
                    30,
                    Math.min(
                        526,
                        px
                    )
                );

            entry.y =
                Math.max(
                    130,
                    Math.min(
                        292,
                        py
                    )
                );

            entry.scale =
                Math.max(
                    0.65,
                    Math.min(
                        1.45,
                        scale
                    )
                );

            save();
            return true;
        }

        public static function removeStadiumDecoration(
            index:int
        ):Boolean {
            if (
                !stadiumDecorations ||
                index < 0 ||
                index >= stadiumDecorations.length
            ) {
                return false;
            }

            stadiumDecorations.splice(
                index,
                1
            );

            save();
            return true;
        }

        public static function activateStadiumItem(
            item:Object
        ):Boolean {
            if (!item) return false;

            if (
                String(item.category) != "STADIUM"
            ) {
                return false;
            }

            if (
                !ownsStadiumItem(
                    String(item.id)
                )
            ) {
                return false;
            }

            if (!stadiumActive) {
                stadiumActive = {};
            }

            stadiumActive[
                String(item.slot)
            ] = String(item.id);

            save();
            return true;
        }

        public static function activeStadiumItem(
            slot:String
        ):Object {
            if (!stadiumActive) return null;

            var id:* =
                stadiumActive[slot];

            if (id === undefined || id == null) {
                return null;
            }

            return shopItemById(
                String(id)
            );
        }

        public static function stadiumAccent(
            slot:String,
            fallback:uint
        ):uint {
            var item:Object =
                activeStadiumItem(slot);

            if (!item) return fallback;

            return uint(item.accent);
        }

        public static function stadiumItemName(
            slot:String
        ):String {
            var item:Object =
                activeStadiumItem(slot);

            return item
                ? String(item.name)
                : "NONE";
        }

        public static function requiredLeagueName(
            item:Object
        ):String {
            if (!item) return "";

            var index:int =
                Math.max(
                    0,
                    Math.min(
                        LEAGUES.length - 1,
                        int(item.unlockLeague)
                    )
                );

            return String(LEAGUES[index]);
        }

        private static function formatInteger(
            value:int
        ):String {
            var s:String = String(value);
            var result:String = "";

            while (s.length > 3) {
                result =
                    "," +
                    s.substr(
                        s.length - 3
                    ) +
                    result;

                s =
                    s.substr(
                        0,
                        s.length - 3
                    );
            }

            return s + result;
        }

        public static function roadmapLeagueName(
            index:int
        ):String {
            index =
                Math.max(
                    0,
                    Math.min(
                        LEAGUES.length - 1,
                        index
                    )
                );

            return String(
                LEAGUES[index]
            );
        }

        public static function roadmapOwnedSpecialCount():int {
            var count:int = 0;

            if (!specialOwned) {
                return count;
            }

            for (
                var key:String in
                specialOwned
            ) {
                if (
                    specialOwned[key] != null
                ) {
                    count++;
                }
            }

            return count;
        }

        public static function roadmapCatalog():Array {
            return [
                {
                    league:0,
                    title:"ROOKIE ROAD",
                    description:"Aprende cómo funciona la temporada y forma tu primer club.",
                    rewardLabel:"ROOKIE MYSTERY BOX",
                    objectives:[
                        {
                            type:"games",
                            label:"JUEGA 3 PARTIDOS DE TEMPORADA",
                            target:3
                        },
                        {
                            type:"wins",
                            label:"GANA 1 PARTIDO DE TEMPORADA",
                            target:1
                        },
                        {
                            type:"gate",
                            label:"COBRA ENTRADAS UNA VEZ",
                            target:1
                        }
                    ]
                },
                {
                    league:1,
                    title:"SINGLE-A ROAD",
                    description:"Refuerza tu equipo y reúne Special Batters.",
                    rewardLabel:"SINGLE-A MYSTERY BOX",
                    objectives:[
                        {
                            type:"games",
                            label:"JUEGA 10 PARTIDOS",
                            target:10
                        },
                        {
                            type:"wins",
                            label:"GANA 5 PARTIDOS",
                            target:5
                        },
                        {
                            type:"special",
                            label:"CONSIGUE 3 SPECIAL BATTERS",
                            target:3
                        },
                        {
                            type:"singleASeason",
                            label:"TERMINA UNA TEMPORADA SINGLE-A",
                            target:1
                        }
                    ]
                },
                {
                    league:2,
                    title:"DOUBLE-A ROAD",
                    description:"Demuestra que puedes batear contra pichadas más difíciles.",
                    rewardLabel:"DOUBLE-A MYSTERY BOX",
                    objectives:[
                        {
                            type:"games",
                            label:"JUEGA 20 PARTIDOS",
                            target:20
                        },
                        {
                            type:"wins",
                            label:"GANA 11 PARTIDOS",
                            target:11
                        },
                        {
                            type:"hr",
                            label:"CONECTA 5 HOME RUNS",
                            target:5
                        }
                    ]
                },
                {
                    league:3,
                    title:"TRIPLE-A ROAD",
                    description:"Anota carreras con regularidad antes de llegar a Major.",
                    rewardLabel:"TRIPLE-A MYSTERY BOX",
                    objectives:[
                        {
                            type:"games",
                            label:"JUEGA 35 PARTIDOS",
                            target:35
                        },
                        {
                            type:"wins",
                            label:"GANA 20 PARTIDOS",
                            target:20
                        },
                        {
                            type:"rbi",
                            label:"CONSIGUE 25 RBI",
                            target:25
                        }
                    ]
                },
                {
                    league:4,
                    title:"MAJOR ROAD",
                    description:"Domina la liga más alta y completa el ascenso.",
                    rewardLabel:"MAJOR CHAMPION BOX",
                    objectives:[
                        {
                            type:"games",
                            label:"JUEGA 50 PARTIDOS",
                            target:50
                        },
                        {
                            type:"wins",
                            label:"GANA 30 PARTIDOS",
                            target:30
                        },
                        {
                            type:"hr",
                            label:"CONECTA 15 HOME RUNS",
                            target:15
                        }
                    ]
                }
            ];
        }

        public static function roadmapProgressValue(
            type:String
        ):int {
            if(type=="singleASeason")return RoadmapJourney.completed(roadmapJourney,1)?1:0;
            if (type == "games") {
                return roadmapGames;
            }

            if (type == "wins") {
                return roadmapWins;
            }

            if (type == "hr") {
                return roadmapHomeRuns;
            }

            if (type == "rbi") {
                return roadmapRbi;
            }

            if (type == "gate") {
                return gateIncomeCollected;
            }

            if (type == "special") {
                return roadmapOwnedSpecialCount();
            }

            return 0;
        }

        public static function roadmapStageComplete(
            index:int
        ):Boolean {
            if (index < leagueIndex) {
                return true;
            }

            var catalog:Array =
                roadmapCatalog();

            if (
                index < 0 ||
                index >= catalog.length
            ) {
                return false;
            }

            var stage:Object =
                catalog[index];

            for each (
                var objective:Object in
                stage.objectives
            ) {
                if (
                    roadmapProgressValue(
                        String(
                            objective.type
                        )
                    ) <
                    int(
                        objective.target
                    )
                ) {
                    return false;
                }
            }

            return true;
        }

        public static function roadmapStageClaimed(
            index:int
        ):Boolean {
            if (!roadmapClaims) {
                return false;
            }

            return Boolean(
                roadmapClaims[
                    String(index)
                ]
            );
        }

        public static function roadmapClaimStage(
            index:int
        ):Object {
            init();

            if (
                index < 0 ||
                index >= 5
            ) {
                return {
                    status:"INVALID"
                };
            }

            if (
                roadmapStageClaimed(
                    index
                )
            ) {
                return {
                    status:"CLAIMED"
                };
            }

            if (
                !roadmapStageComplete(
                    index
                )
            ) {
                return {
                    status:"LOCKED"
                };
            }

            if (!roadmapClaims) {
                roadmapClaims = {};
            }

            var kind:String=MysteryCatalog.forLeague(index);
            if(!MysteryInventory.addBox(mysteryInventory,kind))return {status:"FULL"};
            var gained:int=MysteryInventory.addKeys(mysteryInventory,MysteryInventory.keyCost(kind));
            roadmapClaims[String(index)]=true;
            roadmapLastReward={status:"OK",league:index,type:"MYSTERY BOX",amount:1,keys:gained};

            save();

            return roadmapLastReward;
        }

        public static function roadmapStagePercent(
            index:int
        ):Number {
            if (index < leagueIndex) {
                return 1;
            }

            var catalog:Array =
                roadmapCatalog();

            if (
                index < 0 ||
                index >= catalog.length
            ) {
                return 0;
            }

            var objectives:Array =
                catalog[index].objectives as Array;

            if (
                !objectives ||
                objectives.length == 0
            ) {
                return 0;
            }

            var total:Number = 0;

            for each (
                var objective:Object in
                objectives
            ) {
                var target:int =
                    Math.max(
                        1,
                        int(
                            objective.target
                        )
                    );

                total +=
                    Math.min(
                        1,
                        roadmapProgressValue(
                            String(
                                objective.type
                            )
                        ) /
                        target
                    );
            }

            return total /
                   objectives.length;
        }

        public static function leagueName():String {
            var index:int =
                Math.max(
                    0,
                    Math.min(
                        LEAGUES.length - 1,
                        leagueIndex
                    )
                );

            return String(LEAGUES[index]);
        }

        public static function leagueShortName():String {
            if (leagueIndex <= 0) return "R";
            if (leagueIndex == 1) return "A";
            if (leagueIndex == 2) return "AA";
            if (leagueIndex == 3) return "AAA";

            return "MAJOR";
        }

        public static function collectHomeItem(id:String,at:Number=-1):int {init();var amount:int=StadiumCleanup.claim(homeCleanup,id,at<0?new Date().time:at);if(amount>0){coins+=amount;save();}return amount;}
        public static function seasonStandingsLeague():int {return seasonComplete&&lastSeasonSummary&&int(lastSeasonSummary.season)==seasonNumber&&lastSeasonSummary.leagueIndex!==undefined?int(lastSeasonSummary.leagueIndex):leagueIndex;}
        public static function seasonStandingsLeagueName():String {return String(LEAGUES[seasonStandingsLeague()]);}
        public static function seasonStandings():Array {init();var stage:int=seasonStandingsLeague();return SeasonStandings.build(seasonNumber,stage,{city:teamCity,teamName:teamName,accent:teamAccent},seasonWins,seasonLosses,seasonResults,function(n:int):Object{return opponentForGame(n,stage);});}
        public static function seasonRank():int {var table:Array=seasonStandings();for each(var row:Object in table)if(row.home)return int(row.rank);return 1;}

        public static function seasonRecord():String {
            return seasonWins +
                   "-" +
                   seasonLosses;
        }

        public static function seasonLabel():String {
            if (seasonComplete) {
                return "Season " +
                       seasonNumber +
                       " Complete";
            }

            return "Regular Season (" +
                   seasonGame +
                   " of 30)";
        }

        public static function canStartSeasonGame():Boolean {refreshEnergy();return !pendingPostSeasonPayment()&&(pendingSpecialMatch()||energy>=AccountEnergy.COST);}

        public static function pendingPostSeasonPayment():Boolean {return specialMatch!=null&&String(specialMatch.key).indexOf("post:")==0;}
        public static function postSeasonInProgress():Boolean {
            return seasonComplete&&((postSeason&&postSeason.season==seasonNumber&&postSeason.status=="active")||
                ((!postSeason||postSeason.season!=seasonNumber)&&lastSeasonSummary&&lastSeasonSummary.season==seasonNumber&&lastSeasonSummary.playoffs));
        }
        public static function ensurePostSeason():Boolean {
            init();
            if(postSeason&&postSeason.season==seasonNumber)return true;
            if(!seasonComplete||!lastSeasonSummary||!lastSeasonSummary.playoffs||lastSeasonSummary.season!=seasonNumber)return false;
            var completedLeague:int=lastSeasonSummary.leagueIndex!==undefined?int(lastSeasonSummary.leagueIndex):lastGameSummary&&lastGameSummary.leagueIndex!==undefined?int(lastGameSummary.leagueIndex):leagueIndex;
            var clubs:Array=[],table:Array=seasonStandings();
            for each(var standing:Object in table){if(standing.home||clubs.length>=7)continue;var club:Object=standing.club;
                club.repertoire=["FASTBALL","CHANGEUP"];if(completedLeague>=1)club.repertoire.push("CURVEBALL");if(completedLeague>=2)club.repertoire.push("SLIDER");if(completedLeague>=3)club.repertoire.push("CUTTER");clubs.push(club);
            }
            postSeason=PostSeason.create(seasonNumber,completedLeague,Math.max(1,Math.min(4,int(lastSeasonSummary.rank))),
                {city:teamCity,teamName:teamName,accent:teamAccent,rating:mainPlayer().ovr,pitcherName:"Hero",mapX:435,mapY:215,repertoire:["FASTBALL"]},clubs);
            save();return true;
        }
        public static function matchLeagueIndex():int {return postSeasonMode&&postSeason?int(postSeason.leagueIndex):leagueIndex;}
        public static function matchLeagueShortName():String {return ["R","A","AA","AAA","M"][matchLeagueIndex()];}
        public static function ordinalNumber(n:int):String {var mod:int=n%100;return String(n)+(mod>=11&&mod<=13?"TH":n%10==1?"ST":n%10==2?"ND":n%10==3?"RD":"TH");}
        public static function competitionTitle():String {return postSeasonMode&&postSeason?ordinalNumber(int(postSeason.season))+" POST SEASON":ordinalNumber(seasonNumber)+" REGULAR SEASON";}
        public static function competitionDetail():String {return postSeasonMode?PostSeason.label(postSeason)+" · 3 Wins Required":"REGULAR SEASON · GAME "+seasonGame+" / 30";}
        public static function startPostSeasonGame():Boolean {
            init();if(!postSeasonMode||!ensurePostSeason()||!PostSeason.activeSeries(postSeason))return false;
            var key:String=PostSeason.key(postSeason);
            if(specialMatch){if(specialMatch.key!=key)return false;if(specialMatch.preparing===true)reserveMatchCards(key,true);return true;}
            refreshEnergy();if(energy<AccountEnergy.COST||(!allowUnavailableLineup&&unstartablePlayers().length>0))return false;
            reserveMatchCards(key);return true;
        }
        public static function completePostSeasonGame(homeScore:int,awayScore:int,hits:int,homeRuns:int,attempts:int,rbi:int,homeLine:Array=null,awayLine:Array=null,boxScore:Array=null,scoreData:Object=null):Object {
            init();
            var key:String=PostSeason.key(postSeason);
            if(!postSeasonMode||!specialMatch||specialMatch.key!=key)return postSeason?postSeason.lastResult:null;
            var opponent:Object=JSON.parse(JSON.stringify(PostSeason.opponent(postSeason))),round:int=int(postSeason.round);
            var progress:Object=PostSeason.record(postSeason,homeScore,awayScore);if(!progress)return null;
            recordCareerMatch(key,homeScore,awayScore,boxScore,homeLine&&homeLine.length>9,scoreData);
            finishBatUse();specialMatch=null;
            var win:Boolean=homeScore>awayScore,draw:Boolean=homeScore==awayScore;
            // Settle once in the model; the result panel only presents this saved ledger.
            var settled:Object=MatchScoring.settle(scoreData,win,draw,boxScore||[],String(mainPlayer().name),hits,homeRuns,rbi,homeScore);
            var rewardCoins:int=int(settled.rewardCoins),rewardXp:int=int(settled.rewardXp);
            coins+=rewardCoins;xp+=rewardXp;
            var levelUp:Object=rewardXp>0?applyLevelProgress(rewardXp):null;
            var summary:Object={competition:"POST SEASON",leagueIndex:postSeason.leagueIndex,season:postSeason.season,teamName:teamName,teamCity:teamCity,teamAccent:teamAccent,heroName:String(mainPlayer().name),opponent:opponent,boxScore:boxScore?JSON.parse(JSON.stringify(boxScore)):[],atBats:attempts,win:win,draw:draw,homeScore:homeScore,awayScore:awayScore,hits:hits,homeRuns:homeRuns,rbi:rbi,rewardCoins:rewardCoins,rewardXp:rewardXp,game:progress.game,wins:progress.heroWins,losses:progress.rivalWins,rank:postSeason.rank,seasonComplete:postSeason.status!="active",promoted:false,league:String(LEAGUES[int(postSeason.leagueIndex)]),levelUp:levelUp,level:level,levelProgress:levelProgress,levelTarget:levelXpTarget(),maxEnergy:maxEnergy,homeLine:homeLine?homeLine.concat():[],awayLine:awayLine?awayLine.concat():[],round:round,roundName:PostSeason.ROUND_NAMES[round],postStatus:postSeason.status,seriesComplete:progress.seriesComplete};
            summary.scoring=settled;
            summary.walkOff=scoreData?Boolean(scoreData.walkOff):false;
            summary.fixtureKey=key;
            recordScore(summary);postSeason.lastResult=summary;
            if(postSeason.status=="champion")roadmapJourney.champions[String(postSeason.leagueIndex)]=true;
            if(postSeason.status!="active"){
                var found:Boolean=false;
                for each(var history:Object in postSeasonHistory)if(history.season==postSeason.season&&history.leagueIndex==postSeason.leagueIndex)found=true;
                if(!found){var champion:Object=postSeason.teams[postSeason.champion];postSeasonHistory.push({season:postSeason.season,leagueIndex:postSeason.leagueIndex,status:postSeason.status,championCity:champion.city,championName:champion.teamName,teamName:teamName});while(postSeasonHistory.length>30)postSeasonHistory.shift();}
            }
            save();return summary;
        }

        /** Explicit season transition before goals, travel and lineup. No match fee. */
        public static function prepareNextSeason():Boolean {
            init();
            if (!seasonComplete || pendingSpecialMatch() || postSeasonInProgress()) return false;
            beginNextSeason();
            // Last game/season summaries and all career progress remain intact.
            save();
            return true;
        }

        public static function startSeasonGame():Boolean {
            init();
            if(postSeasonMode||pendingPostSeasonPayment())return false;
            // Reopening an unfinished fixture reuses its paid lineup and never charges twice.
            if(pendingSpecialMatch()){if(specialMatch.preparing===true)reserveMatchCards(specialMatchKey(),true);return true;}
            refreshEnergy();if(energy<AccountEnergy.COST||(!allowUnavailableLineup&&unstartablePlayers().length>0))return false;
            // Keep the legacy direct-start fallback; Main prepares earlier so
            // every preview uses this same season/opponent before launch.
            if(seasonComplete&&!prepareNextSeason())return false;
            reserveMatchCards(specialMatchKey());return true;
        }
        private static function reserveMatchCards(key:String,prepaid:Boolean=false):void {
            var reservedBat:Object=prepaid&&specialMatch?specialMatch.batSnapshot:null;
            normalizeSpecialCards();normalizeSpecialPositions();
            var snapshot:Array=[],now:Number=new Date().time;
            for(var i:int=0;i<5;i++) {
                var id:String=String(specialEquipped[i]),s:Object=specialCardState(id);
                if(i<specialSlotsUnlocked&&s&&specialCardEnergy(id)>0) {
                    snapshot.push(specialCardById(id));s.charges--;
                    if(!Number(s.rechargeAt))s.rechargeAt=String(now+SpecialCardInventory.RECOVERY_MS);
                }else snapshot.push(null);
            }
            var unavailable:Array=[],conditionModifiers:Object={};
            for each(var p:Object in battingOrderPlayers())conditionModifiers[String(p.name)]=PlayerCondition.modifier(p);
            allowUnavailableLineup=false;
            normalizeBats();
            var bat:Object=prepaid?reservedBat:equipped.bat?JSON.parse(JSON.stringify(equipped.bat)):null;
            if(!prepaid&&ConsumableBats.isBat(bat))consumableBats.stock[bat.consumableId]=batStock(bat)-1;
            StarterTutorial.event(starterTutorial,"start",key);
            specialMatch={key:key,cards:snapshot,positions:specialPositions.concat(),order:battingOrder.concat(),unavailable:unavailable,conditionModifiers:conditionModifiers,batSnapshot:bat};if(!prepaid)energy-=AccountEnergy.COST;if(Number(energyAt)<=0)energyAt=String(now+AccountEnergy.INTERVAL);save();
        }

        public static function seasonResultForGame(
            gameNumber:int
        ):Object {
            init();

            for each (
                var result:Object in
                seasonResults
            ) {
                if (
                    result &&
                    int(result.game) ==
                    gameNumber
                ) {
                    return result;
                }
            }

            return null;
        }

        public static function seasonTimelineWindow(
            count:int = 7
        ):Array {
            init();

            count = Math.max(
                3,
                Math.min(9, count)
            );

            var half:int = int(count / 2);
            var startGame:int = seasonGame - half;

            startGame = Math.max(
                1,
                Math.min(
                    30 - count + 1,
                    startGame
                )
            );

            var output:Array = [];

            for (
                var i:int = 0;
                i < count;
                i++
            ) {
                var gameNumber:int = startGame + i;
                var opponent:Object = opponentForGame(gameNumber);
                var completed:Object = seasonResultForGame(gameNumber);

                var state:String = "FUTURE";
                if (completed) {
                    state = Boolean(completed.win) ? "WIN" : "LOSS";
                }
                else if (gameNumber == seasonGame) {
                    state = "NEXT";
                }
                else if (gameNumber < seasonGame) {
                    state = "PAST";
                }

                output.push({
                    game:gameNumber,
                    state:state,
                    current:gameNumber == seasonGame,
                    opponent:opponent,
                    result:completed
                });
            }

            return output;
        }

        private static function migrateSeasonResultsFromLegacy():void {
            if (!seasonResults) {
                seasonResults = [];
            }

            if (
                seasonResults.length > 0 ||
                seasonGame <= 1
            ) {
                return;
            }

            var historyCount:int = seasonHistory ? seasonHistory.length : 0;
            if (historyCount <= 0) {
                return;
            }

            var firstGame:int = Math.max(
                1,
                seasonGame - historyCount
            );

            for (
                var i:int = 0;
                i < historyCount;
                i++
            ) {
                var gameNumber:int = firstGame + i;
                var marker:String = String(seasonHistory[i]);
                var opponent:Object = opponentForGame(gameNumber);
                var known:Boolean = false;
                var homeScore:int = -1;
                var awayScore:int = -1;

                if (
                    lastGameSummary &&
                    int(lastGameSummary.game) == gameNumber
                ) {
                    known = true;
                    homeScore = int(lastGameSummary.homeScore);
                    awayScore = int(lastGameSummary.awayScore);
                }

                seasonResults.push({
                    game:gameNumber,
                    win:marker == "W",
                    homeScore:homeScore,
                    awayScore:awayScore,
                    scoreKnown:known,
                    opponentCity:String(opponent.city),
                    opponentTeam:String(opponent.teamName),
                    opponentAccent:uint(opponent.accent)
                });
            }
        }

        public static function completeSeasonGame(
            homeScore:int,
            awayScore:int,
            hits:int,
            homeRuns:int,
            attempts:int,
            rbi:int,
            homeLine:Array = null,
            awayLine:Array = null,
            boxScore:Array = null,
            scoreData:Object = null
        ):Object {
            init();
            if(scoreData&&scoreData.fixtureKey&&(!specialMatch||String(specialMatch.key)!=String(scoreData.fixtureKey)))return lastGameSummary&&lastGameSummary.fixtureKey==scoreData.fixtureKey?lastGameSummary:null;
            recordCareerMatch(leagueIndex+":"+seasonNumber+":"+seasonGame,homeScore,awayScore,boxScore,homeLine&&homeLine.length>9,scoreData);
            finishBatUse();specialMatch=null;

            var completedLeague:int=leagueIndex;
            var completedGame:int =
                seasonGame;

            var completedOpponent:Object =
                opponentForGame(
                    completedGame
                );

            var win:Boolean =
                homeScore >
                awayScore;

            if (win) {
                seasonWins++;
            }
            else {
                seasonLosses++;
            }

            RoadmapJourney.record(roadmapJourney,completedLeague+":"+seasonNumber+":"+completedGame,completedLeague,win,completedGame>=30);
            roadmapGames++;
            if (win) {
                roadmapWins++;
            }
            roadmapHomeRuns +=
                Math.max(
                    0,
                    homeRuns
                );
            roadmapRbi +=
                Math.max(
                    0,
                    rbi
                );

            seasonHits +=
                Math.max(0, hits);

            seasonHomeRuns +=
                Math.max(0, homeRuns);

            seasonRbi +=
                Math.max(0, rbi);

            var mysteryAward:Object=MysteryInventory.recordGame(mysteryInventory,completedLeague+":"+seasonNumber+":"+completedGame,win,completedGame,completedLeague);
            var settled:Object=MatchScoring.settle(scoreData,win,false,boxScore||[],String(mainPlayer().name),hits,homeRuns,rbi,homeScore,int(mysteryAward.coins));
            var rewardCoins:int=int(settled.rewardCoins),rewardXp:int=int(settled.rewardXp);
            coins += rewardCoins;
            xp += rewardXp;

            var levelUp:Object =
                applyLevelProgress(
                    rewardXp
                );

            seasonHistory.push(
                win
                ? "W"
                : "L"
            );

            while (
                seasonHistory.length > 6
            ) {
                seasonHistory.shift();
            }

            seasonResults.push({
                game:completedGame,
                win:win,
                homeScore:homeScore,
                awayScore:awayScore,
                scoreKnown:true,
                opponentCity:String(completedOpponent.city),
                opponentTeam:String(completedOpponent.teamName),
                opponentAccent:uint(completedOpponent.accent)
            });

            while (
                seasonResults.length > 30
            ) {
                seasonResults.shift();
            }

            var completedRank:int=seasonRank();
            var promoted:Boolean = false;
            var madePlayoffs:Boolean = false;

            if (seasonGame >= 30) {
                seasonComplete = true;

                madePlayoffs =
                    completedRank <= 4;

                // Approximation: a strong top-four season promotes
                // one league level. This threshold can be replaced
                // when exact original rules are recovered.
                if (
                    madePlayoffs &&
                    seasonWins >= 18 &&
                    leagueIndex <
                    LEAGUES.length - 1
                ) {
                    leagueIndex++;
                    promoted = true;
                }

                lastSeasonSummary = {
                    leagueIndex:completedLeague,
                    season:seasonNumber,
                    wins:seasonWins,
                    losses:seasonLosses,
                    rank:completedRank,
                    playoffs:madePlayoffs,
                    promoted:promoted,
                    league:leagueName()
                };
                if(madePlayoffs){postSeason=null;ensurePostSeason();}
            }
            else {
                seasonGame++;
            }

            lastGameSummary = {
                leagueIndex:completedLeague,
                season:seasonNumber,
                teamName:teamName,
                teamCity:teamCity,
                teamAccent:teamAccent,
                heroName:String(mainPlayer().name),
                opponent:completedOpponent,
                boxScore:boxScore ? JSON.parse(JSON.stringify(boxScore)) : [],
                atBats:attempts,
                win:win,
                homeScore:homeScore,
                awayScore:awayScore,
                hits:hits,
                homeRuns:homeRuns,
                rbi:rbi,
                rewardCoins:rewardCoins,
                rewardXp:rewardXp,
                game:completedGame,
                mysteryAward:mysteryAward,
                eventType:seasonEventType(completedGame),
                wins:seasonWins,
                losses:seasonLosses,
                rank:completedRank,
                seasonComplete:seasonComplete,
                playoffs:madePlayoffs,
                promoted:promoted,
                league:leagueName(),
                levelUp:levelUp,
                level:level,
                levelProgress:levelProgress,
                levelTarget:levelXpTarget(),
                maxEnergy:maxEnergy,
                homeLine:homeLine ? homeLine.concat() : [],
                awayLine:awayLine ? awayLine.concat() : []
            };

            lastGameSummary.scoring=settled;
            lastGameSummary.walkOff=scoreData?Boolean(scoreData.walkOff):false;
            lastGameSummary.fixtureKey=scoreData?String(scoreData.fixtureKey):completedLeague+":"+seasonNumber+":"+completedGame;
            recordScore(lastGameSummary);
            for each(var goalRow:Object in boxScore||[])if(goalRow.isHero){seasonHeroHits+=Math.max(0,int(goalRow.hits));seasonHeroRbi+=Math.max(0,int(goalRow.rbi));}
            StarterTutorial.event(starterTutorial,"finish",String(lastGameSummary.fixtureKey));
            save();

            return lastGameSummary;
        }

        private static function beginNextSeason():void {
            seasonGoalType="HIT";seasonGoalHits=70;seasonGoalRbi=55;seasonHeroHits=seasonHeroRbi=0;
            seasonNumber++;

            seasonGame = 1;
            seasonWins = 0;
            seasonLosses = 0;
            seasonHits = 0;
            seasonHomeRuns = 0;
            seasonRbi = 0;
            seasonComplete = false;
            seasonGoalSet = false;
            seasonHistory = [];
            seasonResults = [];
        }

        private static function formatAverage(
            value:Number
        ):String {
            var avg:Number =
                Math.max(
                    0,
                    Math.min(
                        0.999,
                        value
                    )
                );

            var s:String =
                avg.toFixed(3);

            if (
                s.indexOf("0.") == 0
            ) {
                s =
                    s.substr(1);
            }

            return s;
        }

        public static function scout(tier:String):Object {
            init();

            var costCoins:int = 0;
            var costCash:int = 0;

            if (tier == "BRONZE") {
                costCoins = 5000;
            }
            else if (tier == "GOLD") {
                costCoins = 20000;
            }
            else if (tier == "PREMIUM") {
                costCash = 5;
            }
            else {
                return null;
            }

            if (
                costCoins > 0 &&
                coins < costCoins
            ) {
                return null;
            }

            if (
                costCash > 0 &&
                cash < costCash
            ) {
                return null;
            }

            if(roster.length>=30||pendingSpecialMatch())return null;
            var candidate:Object=generateCandidate(tier);if(!candidate)return null;
            coins -= costCoins;cash -= costCash;
            CareerAchievements.add(hallOfFame,"cardsBought");

            lastScouted = candidate;

            save();

            return candidate;
        }

        public static function signScouted():Boolean {
            if (!lastScouted) return false;
            if(lastScouted.normalPlayer&&MLBNormalPlayers.owned(int(lastScouted.mlbId)))return false;
            if (!roster || roster.length >= 30) return false;

            ensurePlayerMetadata(lastScouted);

            roster.push(lastScouted);
            lastScouted = null;

            save();

            return true;
        }

        public static function save():void {
            try {
                drainSocialKeys();
                ensureSaveObject();

                saveObject.data.version = SAVE_VERSION;
                saveObject.data.homeCleanup=homeCleanup;
                saveObject.data.starterTutorial=starterTutorial;
                saveObject.data.seasonGoalType=seasonGoalType;
                saveObject.data.seasonGoalHits=seasonGoalHits;
                saveObject.data.seasonHeroHits=seasonHeroHits;
                saveObject.data.seasonHeroRbi=seasonHeroRbi;

                saveObject.data.level = level;
                saveObject.data.careerStartVersion = careerStartVersion;
                saveObject.data.friendDraft=friendDraft;
                saveObject.data.runningTraining = runningTraining;
                saveObject.data.xp = xp;
                saveObject.data.levelProgress = levelProgress;
                saveObject.data.maxEnergy = maxEnergy;
                saveObject.data.energy = energy;
                saveObject.data.energyAt = energyAt;saveObject.data.scoreRewardTotal=scoreRewardTotal;
                saveObject.data.scoreHistory = scoreHistory;
                saveObject.data.coins = coins;
                saveObject.data.cash = cash;

                saveObject.data.leagueIndex =
                    leagueIndex;
                saveObject.data.seasonNumber =
                    seasonNumber;
                saveObject.data.seasonGame =
                    seasonGame;
                saveObject.data.seasonWins =
                    seasonWins;
                saveObject.data.seasonLosses =
                    seasonLosses;
                saveObject.data.seasonHits =
                    seasonHits;
                saveObject.data.seasonHomeRuns =
                    seasonHomeRuns;
                saveObject.data.seasonRbi =
                    seasonRbi;
                saveObject.data.seasonComplete =
                    seasonComplete;
                saveObject.data.seasonHistory =
                    seasonHistory;
                saveObject.data.seasonResults =
                    seasonResults;
                saveObject.data.lastGameSummary =
                    lastGameSummary;
                saveObject.data.lastSeasonSummary =
                    lastSeasonSummary;
                saveObject.data.postSeason=postSeason;
                saveObject.data.postSeasonHistory=postSeasonHistory;
                saveObject.data.hallOfFame=hallOfFame;
                saveObject.data.mysteryInventory=mysteryInventory;
                saveObject.data.socialState=socialState;
                saveObject.data.lastLevelUpSummary =
                    lastLevelUpSummary;

                saveObject.data.roadmapGames =
                    roadmapGames;
                saveObject.data.roadmapWins =
                    roadmapWins;
                saveObject.data.roadmapHomeRuns =
                    roadmapHomeRuns;
                saveObject.data.roadmapRbi =
                    roadmapRbi;
                saveObject.data.roadmapClaims =
                    roadmapClaims;
                saveObject.data.roadmapJourney = roadmapJourney;
                saveObject.data.roadmapLastReward =
                    roadmapLastReward;

                saveObject.data.teamName = teamName;
                saveObject.data.teamCity = teamCity;
                saveObject.data.teamAccent = teamAccent;
                saveObject.data.uniformNumber = uniformNumber;
                saveObject.data.onboardingStep = onboardingStep;
                saveObject.data.seasonGoalSet = seasonGoalSet;
                saveObject.data.seasonGoalHomeRuns = seasonGoalHomeRuns;
                saveObject.data.seasonGoalRbi = seasonGoalRbi;
                saveObject.data.missionClaims = missionClaims;
                saveObject.data.gateIncomeCollected = gateIncomeCollected;
                saveObject.data.gateIncomeLastDay = gateIncomeLastDay;
                // Ruffle truncates long JSON integer literals; keep UTC milliseconds as text.
                saveObject.data.gateIncomeLastAt = String(gateIncomeLastAt);

                saveObject.data.scoutCounter =
                    scoutCounter;
                saveObject.data.lastScouted = lastScouted;

                saveObject.data.roster = roster;
                saveObject.data.battingOrder = battingOrder;
                saveObject.data.specialOwned = specialOwned;
                saveObject.data.specialSerial=specialSerial;
                saveObject.data.specialMatch=specialMatch;
                saveObject.data.specialEquipped = specialEquipped;
                saveObject.data.specialPositions = specialPositions;
                saveObject.data.specialSlotsUnlocked = specialSlotsUnlocked;
                saveObject.data.lastSpecialDraw = lastSpecialDraw;
                saveObject.data.inventory = inventory;
                saveObject.data.consumableBats=consumableBats;
                saveObject.data.equipped = equipped;
                saveObject.data.stadiumOwned = stadiumOwned;
                saveObject.data.stadiumActive = stadiumActive;
                saveObject.data.stadiumDecorations = stadiumDecorations;

                saveObject.flush();
            }
            catch (e:Error) {
                trace("SAVE ERROR: " + e.message);
            }
        }

        public static function load():void {
            try {
                ensureSaveObject();

                if (!saveObject.data.version) {
                    // Fresh save: keep the default ONBOARDING_TEAM state.
                    save();
                    return;
                }

                var loadedVersion:int =
                    int(saveObject.data.version);
                careerStartVersion = int(saveObject.data.careerStartVersion);
                friendDraft=[];if(saveObject.data.friendDraft is Array)for each(var draftId:* in saveObject.data.friendDraft.slice(0,5))if(draftId is String&&draftId.length<=80&&friendDraft.indexOf(draftId)<0)friendDraft.push(draftId);
                runningTraining = saveObject.data.runningTraining && !(saveObject.data.runningTraining is Array)
                    ? saveObject.data.runningTraining : {};
                normalizeRunningTraining();

                if(loadedVersion<21) {
                    // Keep a separate, deep copy before touching legacy card objects.
                    var backup:WebSave=WebSave.getLocal(SAVE_NAME+"_before_v21");
                    if(!backup.data.snapshot) {
                        var bytes:ByteArray=new ByteArray();bytes.writeObject(saveObject.data);bytes.position=0;
                        backup.data.snapshot=bytes.readObject();backup.flush();
                    }
                }

                // All current save fields are backward compatible
                // with version 1. Missing fields are filled below.
                if (saveObject.data.level !== undefined) {
                    level = int(saveObject.data.level);
                }

                if (saveObject.data.xp !== undefined) {
                    xp = int(saveObject.data.xp);
                }

                if (saveObject.data.levelProgress !== undefined) {
                    levelProgress =
                        int(
                            saveObject.data.levelProgress
                        );
                }

                if (saveObject.data.maxEnergy !== undefined) {
                    maxEnergy =
                        int(
                            saveObject.data.maxEnergy
                        );
                }

                if (saveObject.data.energy !== undefined) {
                    energy = int(saveObject.data.energy);
                    scoreRewardTotal=saveObject.data.scoreRewardTotal?int(saveObject.data.scoreRewardTotal):0;energyAt=saveObject.data.energyAt?String(saveObject.data.energyAt):"0";
                    scoreHistory=ScoreHistory.normalize(saveObject.data.scoreHistory);
                }

                if (saveObject.data.coins !== undefined) {
                    coins = int(saveObject.data.coins);
                }

                if (saveObject.data.cash !== undefined) {
                    cash = int(saveObject.data.cash);
                }


                if (saveObject.data.leagueIndex !== undefined) {
                    leagueIndex =
                        int(saveObject.data.leagueIndex);
                }

                if (saveObject.data.seasonNumber !== undefined) {
                    seasonNumber =
                        int(saveObject.data.seasonNumber);
                }

                if (saveObject.data.seasonGame !== undefined) {
                    seasonGame =
                        int(saveObject.data.seasonGame);
                }

                if (saveObject.data.seasonWins !== undefined) {
                    seasonWins =
                        int(saveObject.data.seasonWins);
                }

                if (saveObject.data.seasonLosses !== undefined) {
                    seasonLosses =
                        int(saveObject.data.seasonLosses);
                }

                if (saveObject.data.seasonHits !== undefined) {
                    seasonHits =
                        int(saveObject.data.seasonHits);
                }

                if (saveObject.data.seasonHomeRuns !== undefined) {
                    seasonHomeRuns =
                        int(saveObject.data.seasonHomeRuns);
                }

                if (saveObject.data.seasonRbi !== undefined) {
                    seasonRbi =
                        int(saveObject.data.seasonRbi);
                }

                if (saveObject.data.seasonComplete !== undefined) {
                    seasonComplete =
                        Boolean(saveObject.data.seasonComplete);
                }

                if (saveObject.data.seasonHistory is Array) {
                    seasonHistory =
                        saveObject.data.seasonHistory as Array;
                }

                if (saveObject.data.seasonResults is Array) {
                    seasonResults =
                        saveObject.data.seasonResults as Array;
                }

                if (saveObject.data.lastGameSummary) {
                    lastGameSummary =
                        saveObject.data.lastGameSummary;
                }

                if (saveObject.data.lastSeasonSummary) {
                    lastSeasonSummary =
                        saveObject.data.lastSeasonSummary;
                }
                if(PostSeason.valid(saveObject.data.postSeason))postSeason=saveObject.data.postSeason;
                if(saveObject.data.postSeasonHistory is Array)postSeasonHistory=saveObject.data.postSeasonHistory.slice(-30);

                if (saveObject.data.lastLevelUpSummary) {
                    lastLevelUpSummary =
                        saveObject.data.lastLevelUpSummary;
                }

                if (saveObject.data.roadmapGames !== undefined) {
                    roadmapGames =
                        int(
                            saveObject.data.roadmapGames
                        );
                }

                if (saveObject.data.roadmapWins !== undefined) {
                    roadmapWins =
                        int(
                            saveObject.data.roadmapWins
                        );
                }

                if (saveObject.data.roadmapHomeRuns !== undefined) {
                    roadmapHomeRuns =
                        int(
                            saveObject.data.roadmapHomeRuns
                        );
                }

                if (saveObject.data.roadmapRbi !== undefined) {
                    roadmapRbi =
                        int(
                            saveObject.data.roadmapRbi
                        );
                }

                if (saveObject.data.roadmapClaims) {
                    roadmapClaims =
                        saveObject.data.roadmapClaims;
                }

                if (saveObject.data.roadmapLastReward) {
                    roadmapLastReward =
                        saveObject.data.roadmapLastReward;
                }

                if (saveObject.data.teamName !== undefined) {
                    teamName = String(saveObject.data.teamName);
                }

                if (saveObject.data.teamCity !== undefined) {
                    teamCity = String(saveObject.data.teamCity);
                }

                if (saveObject.data.teamAccent !== undefined) {
                    teamAccent = uint(saveObject.data.teamAccent);
                }

                if (saveObject.data.uniformNumber !== undefined) {
                    uniformNumber = int(saveObject.data.uniformNumber);
                }

                if (saveObject.data.onboardingStep !== undefined) {
                    onboardingStep =
                        int(saveObject.data.onboardingStep);
                }
                else if (loadedVersion < 17) {
                    // Do not interrupt careers created before Phase 8U.
                    onboardingStep = ONBOARDING_COMPLETE;
                }

                if (saveObject.data.seasonGoalSet !== undefined) {
                    seasonGoalSet = Boolean(saveObject.data.seasonGoalSet);
                }

                if (saveObject.data.seasonGoalHomeRuns !== undefined) {
                    seasonGoalHomeRuns = int(saveObject.data.seasonGoalHomeRuns);
                }

                if (saveObject.data.seasonGoalRbi !== undefined) {
                    seasonGoalRbi = int(saveObject.data.seasonGoalRbi);
                }

                if (saveObject.data.missionClaims) {
                    missionClaims = saveObject.data.missionClaims;
                }

                if (saveObject.data.gateIncomeCollected !== undefined) {
                    gateIncomeCollected = int(saveObject.data.gateIncomeCollected);
                }

                if (saveObject.data.gateIncomeLastDay !== undefined) {
                    gateIncomeLastDay = String(saveObject.data.gateIncomeLastDay);
                }

                if (saveObject.data.gateIncomeLastAt !== undefined) {
                    gateIncomeLastAt = Number(saveObject.data.gateIncomeLastAt);
                }

                if (saveObject.data.scoutCounter !== undefined) {
                    scoutCounter =
                        int(saveObject.data.scoutCounter);
                }

                if (saveObject.data.roster is Array) {
                    roster =
                        saveObject.data.roster as Array;
                }
                // A paid unsigned prospect belongs to the save, not only this session.
                lastScouted=null;
                var pendingScout:Object=saveObject.data.lastScouted;
                if(pendingScout&&!(pendingScout is Array)&&pendingScout.normalPlayer&&MLBNormalPlayers.contains(int(pendingScout.mlbId))&&!MLBNormalPlayers.owned(int(pendingScout.mlbId))){lastScouted=pendingScout;ensurePlayerMetadata(lastScouted);}

                if (saveObject.data.battingOrder is Array) {
                    battingOrder =
                        saveObject.data.battingOrder as Array;
                }

                specialPositions=saveObject.data.specialPositions is Array?saveObject.data.specialPositions.concat():null;
                specialSerial=int(saveObject.data.specialSerial);
                specialMatch=saveObject.data.specialMatch;
                if (saveObject.data.specialOwned) {
                    specialOwned =
                        saveObject.data.specialOwned;
                }
                if(loadedVersion<10)addDefaultSpecialCards();

                if (saveObject.data.specialEquipped is Array) {
                    specialEquipped =
                        saveObject.data.specialEquipped as Array;
                }

                if (
                    saveObject.data.specialSlotsUnlocked !==
                    undefined
                ) {
                    specialSlotsUnlocked =
                        int(
                            saveObject.data.specialSlotsUnlocked
                        );
                }

                if (saveObject.data.lastSpecialDraw) {
                    lastSpecialDraw =
                        saveObject.data.lastSpecialDraw;
                }

                if (saveObject.data.inventory is Array) {
                    inventory =
                        saveObject.data.inventory as Array;
                }

                consumableBats=ConsumableBats.normalize(saveObject.data.consumableBats);
                if (saveObject.data.equipped) {
                    equipped =
                        saveObject.data.equipped;
                }

                if (saveObject.data.stadiumOwned is Array) {
                    stadiumOwned =
                        saveObject.data.stadiumOwned as Array;
                }

                if (saveObject.data.stadiumActive) {
                    stadiumActive =
                        saveObject.data.stadiumActive;
                }

                if (saveObject.data.stadiumDecorations is Array) {
                    stadiumDecorations =
                        saveObject.data.stadiumDecorations as Array;
                }

                if (loadedVersion < 18) {
                    migrateSeasonResultsFromLegacy();
                }

                if (loadedVersion < 19) {
                    // Older saves did not keep account-level Roadmap stats.
                    // Seed them from the current season instead of resetting
                    // an active career to zero.
                    roadmapGames =
                        Math.max(
                            roadmapGames,
                            seasonWins +
                            seasonLosses
                        );

                    roadmapWins =
                        Math.max(
                            roadmapWins,
                            seasonWins
                        );

                    roadmapHomeRuns =
                        Math.max(
                            roadmapHomeRuns,
                            seasonHomeRuns
                        );

                    roadmapRbi =
                        Math.max(
                            roadmapRbi,
                            seasonRbi
                        );
                }

                homeCleanup=StadiumCleanup.normalize(saveObject.data.homeCleanup);
                normalizeLoadedData();

                migrateDemonstrationStart();

                // Preserve only provable old totals; unrecorded match/card details start at zero.
                hallOfFame=saveObject.data.hallOfFame&&saveObject.data.hallOfFame.version==1
                    ?CareerAchievements.normalize(saveObject.data.hallOfFame)
                    :CareerAchievements.legacy(mainPlayer(),roadmapWins,scoutCounter);
                mysteryInventory=MysteryInventory.normalize(saveObject.data.mysteryInventory);
            socialState=normalizeSocial(saveObject.data.socialState);
            roadmapJourney=RoadmapJourney.normalize(saveObject.data.roadmapJourney,leagueIndex,lastSeasonSummary,postSeasonHistory);
                // Missing fields identify an existing career: retain its economy and current HR goals.
                starterTutorial=StarterTutorial.normalize(saveObject.data.starterTutorial);
                seasonGoalType=saveObject.data.seasonGoalType=="HIT"?"HIT":"HR";
                seasonGoalHits=saveObject.data.seasonGoalHits>0?int(saveObject.data.seasonGoalHits):70;
                seasonHeroHits=Math.max(0,int(saveObject.data.seasonHeroHits));seasonHeroRbi=Math.max(0,int(saveObject.data.seasonHeroRbi));
                // Write migrated/defaulted fields back.
                save();
            }
            catch (e:Error) {
                trace("LOAD ERROR: " + e.message);

                // Keep the defaults created before load().
                normalizeLoadedData();
            }
        }

        public static function resetSave():void {
            try {
                ensureSaveObject();
                saveObject.clear();

                createDefaults();
                save();
            }
            catch (e:Error) {
                trace("RESET ERROR: " + e.message);
            }
        }

        public static function startNewCareer():void {
            var creationStep:int=onboardingStep;
            var identity:Object={name:teamName,city:teamCity,accent:teamAccent,number:uniformNumber};
            var hero:Object=mainPlayer();
            var heroName:String=String(hero.name),appearance:Object=hero.appearance;
            createDefaults();
            teamName=identity.name;teamCity=identity.city;teamAccent=identity.accent;uniformNumber=identity.number;
            roster[0].name=heroName;roster[0].appearance=appearance;roster[0].accent=teamAccent;
            onboardingStep=creationStep>=ONBOARDING_ARRIVAL?ONBOARDING_HOME:creationStep;
            battingOrder=defaultBattingOrder();
            if(careerStartVersion>=4){battingOrder.push(battingOrder.shift());}else battingOrder[0]=heroName;
            normalizeLoadedData();save();
        }

        private static function migrateDemonstrationStart():void {
            if(careerStartVersion>0)return;
            // Only correct an untouched demo. Earned/imported progress survives.
            var demo:Boolean=level==8&&xp==34432&&levelProgress==0&&leagueIndex==0&&
                seasonNumber==1&&seasonGame==1&&seasonWins==0&&seasonLosses==0&&
                seasonHits==0&&seasonHomeRuns==0&&seasonRbi==0&&roadmapGames==0&&
                !lastGameSummary&&!lastSeasonSummary&&seasonResults.length==0&&
                coins==336450&&cash==30&&scoutCounter==0&&!lastScouted&&roster.length==12;
            var oldLevels:Array=[8,16,17,19,32,35,36,24,29,22,14,11];
            var oldPower:Array=[72,84,71,65,92,88,86,76,62,89,67,58];
            var oldContact:Array=[81,66,82,91,79,85,83,70,60,77,73,55];
            var oldSpeed:Array=[65,51,88,86,60,73,74,58,54,48,55,52];
            for(var i:int=0;demo&&i<roster.length;i++) {
                var p:Object=roster[i];
                if(int(p.level)!=oldLevels[i]||int(p.power)!=oldPower[i]||int(p.contact)!=oldContact[i]||int(p.speed)!=oldSpeed[i]||int(p.xp)!=0||int(p.careerAtBats)!=0||int(p.careerHits)!=0)demo=false;
            }
            for(var key:String in missionClaims)demo=false;
            for(key in roadmapClaims)demo=false;
            if(demo) {
                var step:int=onboardingStep,goal:Boolean=seasonGoalSet,hr:int=seasonGoalHomeRuns,rbi:int=seasonGoalRbi;
                startNewCareer();
                onboardingStep=step;seasonGoalSet=goal;seasonGoalHomeRuns=hr;seasonGoalRbi=rbi;
            } else careerStartVersion=1;
        }

        private static function ensureSaveObject():void {
            if (!saveObject) {
                saveObject =
                    WebSave.getLocal(SAVE_NAME);
            }
        }

        private static function normalizeLoadedData():void {
            if (!roster) {
                roster = [];
            }

            if (roster.length == 0) {
                var defaults:Array = createDefaultRoster();

                for each (var defaultPlayer:Object in defaults) {
                    roster.push(defaultPlayer);
                }
            }

            for each (var p:Object in roster) {
                ensurePlayerMetadata(p);
            }

            normalizeBattingOrder();
            normalizeSpecialCards();

            if (!missionClaims) {
                missionClaims = {};
            }

            if (!roadmapClaims) {
                roadmapClaims = {};
            }

            roadmapGames =
                Math.max(
                    0,
                    roadmapGames
                );

            roadmapWins =
                Math.max(
                    0,
                    roadmapWins
                );

            roadmapHomeRuns =
                Math.max(
                    0,
                    roadmapHomeRuns
                );

            roadmapRbi =
                Math.max(
                    0,
                    roadmapRbi
                );

            if (!teamName || teamName.length == 0) {
                teamName = "IVAN HEROES";
            }

            if (!teamCity || teamCity.length == 0) {
                teamCity = "ST. LOUIS";
            }

            if (!seasonHistory) {
                seasonHistory = [];
            }

            if (!seasonResults) {
                seasonResults = [];
            }

            if (seasonNumber < 1) {
                seasonNumber = 1;
            }

            if (
                onboardingStep < ONBOARDING_TEAM ||
                onboardingStep > ONBOARDING_COMPLETE
            ) {
                onboardingStep = ONBOARDING_COMPLETE;
            }

            if (seasonGame < 1) {
                seasonGame = 1;
            }

            if (seasonGame > 30) {
                seasonGame = 30;
            }

            leagueIndex =
                Math.max(
                    0,
                    Math.min(
                        LEAGUES.length - 1,
                        leagueIndex
                    )
                );

            mergeDefaultInventory();

            if (!equipped) {
                equipped = {
                    bat:null,
                    glove:null,
                    belt:null,
                    helmet:null,
                    shoes:null,
                    goggles:null
                };
            }

            if (equipped.bat === undefined) equipped.bat = null;
            if (equipped.glove === undefined) equipped.glove = null;
            if (equipped.belt === undefined) equipped.belt = null;
            if (equipped.helmet === undefined) equipped.helmet = null;
            if (equipped.shoes === undefined) equipped.shoes = null;
            if (equipped.goggles === undefined) equipped.goggles = null;

            // Ensure a usable starter set for legacy saves.
            if (!equipped.bat) {
                equipped.bat = findInventoryItem("Rookie Bat");
            }

            if (!equipped.glove) {
                equipped.glove = findInventoryItem("Field Glove");
            }

            if (!equipped.belt) {
                equipped.belt = findInventoryItem("Rookie Belt");
            }

            if (!equipped.helmet) {
                equipped.helmet = findInventoryItem("Rookie Helmet");
            }

            if (!equipped.shoes) {
                equipped.shoes = findInventoryItem("Speed Cleats");
            }

            // Eyewear is optional. An empty slot must survive reload.
            // Existing deliberately equipped items are retained.

            normalizeBats();
            normalizeStadiumData();

            if (!stadiumDecorations) {
                stadiumDecorations = [];
            }
        }


        private static function normalizeStadiumData():void {
            var starters:Array = [
                "stadium_background_mountain",
                "stadium_field_classic",
                "stadium_stand_brown",
                "stadium_scoreboard_classic",
                "stadium_banner_red",
                "stadium_fence_plain",
                "stadium_lights_basic",
                "stadium_wall_green"
            ];

            if (!stadiumOwned) {
                stadiumOwned = [];
            }

            for each (var id:String in starters) {
                if (stadiumOwned.indexOf(id) < 0) {
                    stadiumOwned.push(id);
                }
            }

            if (!stadiumActive) {
                stadiumActive = {};
            }

            if (
                stadiumActive.background === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.background)
                )
            ) {
                stadiumActive.background =
                    "stadium_background_mountain";
            }

            if (
                stadiumActive.field === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.field)
                )
            ) {
                stadiumActive.field =
                    "stadium_field_classic";
            }

            if (
                stadiumActive.stand === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.stand)
                )
            ) {
                stadiumActive.stand =
                    "stadium_stand_brown";
            }

            if (
                stadiumActive.fence === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.fence)
                )
            ) {
                stadiumActive.fence =
                    "stadium_fence_plain";
            }

            if (
                stadiumActive.scoreboard === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.scoreboard)
                )
            ) {
                stadiumActive.scoreboard =
                    "stadium_scoreboard_classic";
            }

            if (
                stadiumActive.banner === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.banner)
                )
            ) {
                stadiumActive.banner =
                    "stadium_banner_red";
            }

            if (
                stadiumActive.lights === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.lights)
                )
            ) {
                stadiumActive.lights =
                    "stadium_lights_basic";
            }

            if (
                stadiumActive.wall === undefined ||
                !ownsStadiumItem(
                    String(stadiumActive.wall)
                )
            ) {
                stadiumActive.wall =
                    "stadium_wall_green";
            }
        }

        private static function createDefaultRoster():Array {
            return [player("Hero", "CF", 1, 50, 60, 50, ".000", 0, 0, 55, "HERO", 0x2d6292)].concat(MLBNormalPlayers.starters());
        }

        private static function mergeDefaultInventory():void {
            if (!inventory) {
                inventory = [];
            }

            var defaults:Array =
                createDefaultInventory();

            for each (var item:Object in defaults) {
                if (!findInventoryItem(String(item.name))) {
                    inventory.push(item);
                }
            }
        }

        private static function findInventoryItem(
            itemName:String
        ):Object {
            if (!inventory) return null;

            for each (var item:Object in inventory) {
                if (
                    item &&
                    String(item.name) == itemName
                ) {
                    return item;
                }
            }

            return null;
        }

        private static function ensurePlayerMetadata(p:Object):void {
            if (!p) return;
            PlayerCondition.ensure(p);

            if (p.baseRating === undefined) {
                p.baseRating = int(p.rating);
            }

            if (p.basePower === undefined) {
                p.basePower = int(p.power);
            }

            if (p.baseContact === undefined) {
                p.baseContact = int(p.contact);
            }

            if (p.baseSpeed === undefined) {
                p.baseSpeed = int(p.speed);
            }

            if (p.xp === undefined) {
                p.xp = 0;
            }

            if (p.careerHits === undefined) {
                p.careerHits = 0;
            }

            if (p.careerAtBats === undefined) {
                p.careerAtBats = 0;
            }

            if (p.luck === undefined) {
                p.luck =
                    Math.max(
                        40,
                        Math.min(
                            99,
                            int(
                                int(p.contact) *
                                0.58 +
                                int(p.speed) *
                                0.42
                            )
                        )
                    );
            }

            if (p.baseLuck === undefined) {
                p.baseLuck =
                    int(p.luck);
            }

            if (p.doubles === undefined) {
                p.doubles = 0;
            }

            if (p.triples === undefined) {
                p.triples = 0;
            }

            if (p.walks === undefined) {
                p.walks = 0;
            }

            if (p.skillPoints === undefined) {
                p.skillPoints = 1;
            }

            if (!p.skillLevels) {
                p.skillLevels = {
                    POWER_HITTER:0,
                    BATTING_EYE:1,
                    CLUTCH:0,
                    SPEEDSTER:0
                };
            }

            for each(var knownSkill:Object in SkillCatalog.items())if(knownSkill.unlockLevel>1&&p.skillLevels[knownSkill.id]===undefined)p.skillLevels[knownSkill.id]=0;

            if (
                p.skillLevels.POWER_HITTER === undefined
            ) {
                p.skillLevels.POWER_HITTER = 0;
            }

            if (
                p.skillLevels.BATTING_EYE === undefined
            ) {
                p.skillLevels.BATTING_EYE = 1;
            }

            if (
                p.skillLevels.CLUTCH === undefined
            ) {
                p.skillLevels.CLUTCH = 0;
            }

            if (
                p.skillLevels.SPEEDSTER === undefined
            ) {
                p.skillLevels.SPEEDSTER = 0;
            }

            if (p.appearance === undefined) {
                p.appearance = null;
            }

            if (
                p.activeSkill === undefined ||
                p.activeSkill == null ||
                String(p.activeSkill) == ""
            ) {
                p.activeSkill = "BATTING_EYE";
            }
        }

        private static function isTrainableStat(
            stat:String
        ):Boolean {
            return stat == "power" ||
                   stat == "contact" ||
                   stat == "speed" ||
                   stat == "luck";
        }

        private static function generateCandidate(
            tier:String
        ):Object {
            scoutCounter++;return MLBNormalPlayers.candidate(tier);
        }

        private static function clampStat(value:int):int {
            if (value < 40) return 40;
            if (value > 99) return 99;

            return value;
        }

        private static function clamp99(value:int):int {
            return Math.max(
                1,
                Math.min(99, value)
            );
        }
    }
}
