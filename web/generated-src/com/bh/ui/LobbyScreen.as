package com.bh.ui {
    import com.bh.visual.MLBPlayerArtwork;
    import flash.geom.Rectangle;

    import flash.display.Sprite;

    import flash.display.Bitmap;

    import com.bh.visual.TrainingArtwork;

    import com.bh.visual.VisualAssetRegistry;
    import com.bh.visual.InterfaceSprite;
    import com.bh.visual.InventoryArtwork;
    import com.bh.visual.HomeSceneArtwork;import com.bh.visual.AchievementArtwork;

    import flash.display.GradientType;

    import flash.events.Event;

    import flash.events.MouseEvent;

    import flash.geom.Matrix;

    import flash.text.TextField;

    import flash.text.TextFormat;

    import flash.filters.GlowFilter;

    import flash.utils.getTimer;

    import com.bh.model.GameData;
    import com.bh.model.StarterTutorial;
    import com.bh.model.FriendRoster;

    import com.bh.game.HomeHero;

    import com.bh.visual.CharacterPortrait;

    import com.bh.visual.LeagueBadgeView;

    import com.bh.visual.TeamLogoView;

    import com.bh.visual.MatchStadium;

    import com.bh.visual.IllustratedSprite;

    import com.bh.online.OnlineClient;

    import com.bh.visual.HeroHead;

    import com.bh.visual.HomeSprite;



    /** Compact HUD over an open stadium, following the supplied gameplay. */

    public class LobbyScreen extends Sprite {

        private var actions:Object;

        private var friends:Array=[],social:OnlineClient,alive:Boolean=true;

        private var friendStatus:TextField;
        private var friendFence:HomeFriendFence,friendSignature:String="",socialLoaded:Boolean=false,socialError:String="";
        private var nextSocialAt:int=0,pendingRequests:int=0,pendingGifts:int=0;

        private var buttons:Array=[];

        private var disposables:Array=[];

        private var players:Array=[];

        private var backdrop:MatchStadium;

        private var chrome:Sprite=new Sprite();

        private var dossier:PlayerDossier;
        private var statPanel:HeroStatPanel,starterCoach:StarterCoach;
        private var starterDraft:FriendDraftScreen,starterReward:StarterMissionOverlay;

        private var batOverlay:BatExpiredOverlay;

        private var heroInfo:Sprite,batStockText:TextField,cashText:TextField;

        private var screenH:Number;

        private var hero:HomeHero;
        private var homeMotion:HomeIconMotion,coinFlight:HomeCoinFlight;
        private var resourceBar:MatchResourceBar,homeBag:HomeSceneArtwork;

        private var coins:TextField;

        private var energy:TextField;

        private var collectButton:Sprite;

        private var collectText:TextField;

        private var rosterPage:int=0;

        private var rosterLayer:Sprite=new Sprite();

        private var rosterArt:Array=[];

        private var rosterControls:Array=[];

        private var previous:Sprite;

        private var next:Sprite;

        private var pageText:TextField;

        private var toast:TextField;

        private var toastUntil:int=0;

        private var nextRefresh:int=0;

        public function LobbyScreen(w:Number,h:Number,

            playCallback:Function,teamCallback:Function,draftCallback:Function,

            shopCallback:Function,buildCallback:Function,missionsCallback:Function,

            characterCallback:Function,teamSelectCallback:Function,goalCallback:Function,

            renameCallback:Function,modesCallback:Function,roadmapCallback:Function,lineupCallback:Function=null,trainingCallback:Function=null,hallCallback:Function=null,socialCallback:Function=null,visitCallback:Function=null) {

            actions={VISIT:visitCallback,FRIENDS:socialCallback,HALL:hallCallback,PLAY:playCallback,TEAM:teamCallback,DRAFT:draftCallback,

                SHOP:shopCallback,BUILD:buildCallback,MISSIONS:missionsCallback,

                HERO:function():void{openHeroStats(null);},LEAGUE:roadmapCallback,GOALS:goalCallback,

                NAME:renameCallback,MODES:modesCallback,ROADMAP:roadmapCallback,LINEUP:lineupCallback!=null?lineupCallback:teamCallback,TRAIN:trainingCallback!=null?trainingCallback:teamCallback};

            GameData.init();

            screenH=h;name="classic-home";backdrop=new MatchStadium(w,540);

            graphics.beginFill(0x9f6c28);graphics.drawRect(0,0,w,h);graphics.endFill();addChild(backdrop);addChild(chrome);

            friends=FriendRoster.list();for each(var cachedFriend:Object in friends)cachedFriend.connected=true;
            drawResources();drawRail();friendFence=new HomeFriendFence(function(id:String):void{if(actions.VISIT!=null)actions.VISIT(id);},function():void{if(actions.FRIENDS!=null)actions.FRIENDS();},function():void{if(actions.FRIENDS!=null)actions.FRIENDS("INBOX");});addChild(friendFence);disposables.push(friendFence);friendFence.update(friends);drawPlayers();drawGround();drawHero();

            drawNavigation();drawSeason();drawIncome();refreshFriends();

            homeMotion=new HomeIconMotion();addChild(homeMotion);disposables.push(homeMotion);
            for each(var entry:Object in buttons)homeMotion.bind(entry.view,entry.view.name);
            homeMotion.bind(collectButton,"COLLECT");
            coinFlight=new HomeCoinFlight();addChild(coinFlight);disposables.push(coinFlight);refreshHomeNotices();

            if(GameData.onboardingStep==GameData.ONBOARDING_HOME) drawCoach();

            refreshStarterCoach();
            addEventListener(Event.ENTER_FRAME,onFrame);

            if(GameData.consumableBats.expired){batOverlay=new BatExpiredOverlay(w,h,closeBat);addChild(batOverlay);}

        }

        private function panel(x:Number,y:Number,w:Number,h:Number,color:uint,alpha:Number=1):Sprite {

            var s:Sprite=new Sprite();s.x=x;s.y=y;

            s.graphics.lineStyle(1,0xffffff,0.65);s.graphics.beginFill(color,alpha);

            s.graphics.drawRoundRect(0,0,w,h,8,8);s.graphics.endFill();addChild(s);return s;

        }

        private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,align:String="left"):TextField {

            var t:TextField=new TextField();

            var f:TextFormat=new TextFormat("Arial",size,color,true);f.align=align;

            t.defaultTextFormat=f;t.text=value;t.multiline=t.wordWrap=value.indexOf("\n")>=0;LineupTypography.apply(t,size,color,align);t.x=x;t.y=y;t.width=w;t.height=h;

            LineupTypography.fit(t,size,color,align);t.selectable=false;t.mouseEnabled=false;parent.addChild(t);return t;

        }

        private function button(key:String,title:String,x:Number,y:Number,w:Number,h:Number,color:uint=0x086bac):Sprite {

            var b:Sprite=ClassicInventorySkin.button(title,w,h,color);b.x=x;b.y=y;addChild(b);

            register(b,key,function(e:MouseEvent):void{if(actions[key]!=null)actions[key]();});return b;

        }

        private function drawResources():void {
            resourceBar=new MatchResourceBar(960,true);addChild(resourceBar);disposables.push(resourceBar);
            resourceAdd("ADD_COINS",685,11);resourceAdd("ADD_CASH",908,11);
        }

        private function hudBar(x:Number,y:Number,w:Number,h:Number,a:uint,b:uint):void {
            chrome.graphics.lineStyle(2,0x8fc4df);ClassicInventorySkin.gradient(chrome.graphics,x,y,w,h,a,b,h);chrome.graphics.lineStyle();
            chrome.graphics.beginFill(0xffffff,.13);chrome.graphics.drawRoundRect(x+3,y+2,w-6,h/2,12);chrome.graphics.endFill();
        }
        private function resourceAdd(id:String,x:Number,y:Number):void {
            var s:Sprite=ClassicInventorySkin.button('+ADD',35,16,0x8d9ba5);s.x=x;s.y=y;addChild(s);
            register(s,id,function(e:MouseEvent):void{if(actions.SHOP!=null)actions.SHOP();});
        }
        private function drawRail():void {
            var s:Sprite=iconAction('LEAGUE','LEAGUE',14,106,74,66),b:LeagueBadgeView=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),65);b.x=4;s.addChild(b);disposables.push(b);
            s=iconAction('TEAM','TEAM',100,73,78,71);var logo:TeamLogoView=new TeamLogoView(GameData.teamCity,GameData.teamAccent,'H',68);logo.x=5;s.addChild(logo);disposables.push(logo);
            button('NAME','NAME YOUR TEAM',192,75,218,30,0xb78436);label(this,GameData.teamName,195,110,410,25,17,0xffffff).filters=[new GlowFilter(0x173b4c,1,3,3,5)];
            s=iconAction('ROADMAP','ROADMAP',14,193,74,66);ClassicChrome.well(s.graphics,7,1,60,40,false,false);
            ClassicChrome.bar(s.graphics,11,5,25,31);ClassicChrome.fill(s.graphics,38,5,25,31,[0xffde85,0xcb8622],[0,255],4);label(s,String(GameData.seasonWins),10,7,27,27,20,0xffffff,'center');label(s,String(GameData.seasonLosses),38,7,26,27,20,0xffffff,'center');
            s=iconAction('DRAFT','SCOUT',14,279,74,69);sprite(s,'scout',3,0,68,51);
            s=iconAction('HERO','SKILL',14,364,74,69);var skill:AchievementArtwork=new AchievementArtwork('skill',56,51);skill.x=9;s.addChild(skill);
            s=iconAction('MISSIONS','MISSIONS',14,447,74,75);var mission:HomeSceneArtwork=new HomeSceneArtwork('mission',59,61);mission.x=7;s.addChild(mission);disposables.push(mission);
            s=iconAction('TRAIN','TRAIN',866,180,79,75);ClassicChrome.well(s.graphics,8,0,61,59);var coach:Bitmap=TrainingArtwork.image(true);coach.width=50;coach.height=54;coach.x=14;coach.y=2;s.addChild(coach);disposables.push({dispose:function():void{coach.bitmapData.dispose();}});
            s=iconAction('HALL',GameData.hallAvailable()>0?'HALL ('+GameData.hallAvailable()+')':'HALL',865,268,79,71);var cup:AchievementArtwork=new AchievementArtwork('gold',67,50);cup.x=5;s.addChild(cup);
        }

        private function drawPlayers():void {
            var order:Array=GameData.battingOrderPlayers(),main:Object=GameData.mainPlayer(),column:int=0;
            for(var i:int=0;i<order.length;i++){
                var data:Object=order[i];if(String(data.name)==String(main.name))continue;
                var tile:Sprite=new Sprite();tile.x=145+column*58;tile.y=263+(column%3)*3;tile.buttonMode=true;tile.mouseChildren=false;
                tile.graphics.beginFill(0x183e2c,.24);tile.graphics.drawEllipse(5,72,39,8);tile.graphics.endFill();tile.graphics.beginFill(0xffffff,.01);tile.graphics.drawRect(0,0,49,81);tile.graphics.endFill();
                var actor:MLBPlayerArtwork=new MLBPlayerArtwork(data,49,81);actor.x=0;actor.y=0;
                tile.addChild(actor);addChild(tile);disposables.push(actor);players.push({view:actor,y:actor.y});register(tile,'home_player_'+i,profileHandler(data));column++;
            }
        }
        private function drawGround():void {var cleaning:HomeCleanupLayer=new HomeCleanupLayer(function(amount:int):void{refreshResources();});addChild(cleaning);disposables.push(cleaning);}

        private function drawHero():void {
            if(heroInfo&&heroInfo.parent)heroInfo.parent.removeChild(heroInfo);if(batStockText&&batStockText.parent)batStockText.parent.removeChild(batStockText);
            if(homeBag){homeBag.dispose();if(homeBag.parent)homeBag.parent.removeChild(homeBag);homeBag=null;}
            if(GameData.leagueIndex>0){homeBag=new HomeSceneArtwork('duffel',66,43);homeBag.x=745;homeBag.y=484;addChild(homeBag);}
            var data:Object=GameData.mainPlayer();hero=new HomeHero(710,529,uint(data.accent),GameData.uniformNumber,String(data.name),null,GameData.equipped);hero.scaleX=hero.scaleY=1.30;addChild(hero);register(hero,'hero-stat-open',openHeroStats);
            batStockText=label(this,GameData.batStockLabel(GameData.equipped.bat),594,491,145,24,11,0xffef87,'center');batStockText.name='home-bat-stock';
            var info:Sprite=new Sprite();info.x=815;info.y=351;ClassicChrome.well(info.graphics,0,0,130,171,false,false);heroInfo=info;addChild(info);register(info,'hero-profile',profileHandler(data));
            label(info,String(data.name),4,6,122,25,14,0xffffff,'center');ClassicChrome.bar(info.graphics,6,35,118,23);label(info,'TOTAL',7,36,116,22,12,0xdaf4ff,'center');
            var values:Array=[['SKILL',GameData.effectivePower(data)+GameData.effectiveContact(data)+GameData.effectiveSpeed(data)+GameData.effectiveLuck(data)],['AVG',data.avg],['HR',data.hr],['RBI',data.rbi],['HIT',data.careerHits]];
            for(var i:int=0;i<values.length;i++){label(info,values[i][0],11,64+i*20,56,22,11,0xc8e6ec);label(info,String(values[i][1]),70,63+i*20,49,23,14,0xffed9e,'right');}
        }

        private function drawNavigation():void {
            ClassicChrome.panel(chrome.graphics,0,534,960,184);ClassicChrome.bar(chrome.graphics,5,591,950,122,false);
            var play:Sprite=iconAction('PLAY','',10,521,164,72);sprite(play,'play',0,0,164,72,true);
            var scout:Sprite=iconAction('DRAFT_CARD','',33,595,86,117);actions.DRAFT_CARD=actions.FRIENDS;ClassicChrome.well(scout.graphics,0,0,86,117);sprite(scout,'friends',9,8,69,63);ClassicChrome.fill(scout.graphics,5,82,76,29,[0xffec85,0xe9b32e],[0,255],5);label(scout,'ADD FRIENDS',5,87,76,22,10,0x684a1b,'center');
            addChild(rosterLayer);rosterLayer.x=126;rosterLayer.y=595;
            previous=pageArrow('home-roster-prev',7,620,false,function(e:MouseEvent):void{if(rosterPage>0){rosterPage--;renderRoster();}});
            next=pageArrow('home-roster-next',735,620,true,function(e:MouseEvent):void{if(rosterPage<rosterPages()-1){rosterPage++;renderRoster();}});
            pageText=label(this,'',5,653,25,25,10,0xc1e6f5,'center');renderRoster();
            menu('SHOP','SHOP',772,595,'shop');menu('LINEUP','LINEUP',865,595,'lineup');menu('BUILD','BUILD',772,656,'field');menu('MODES','MODES',865,656,'ball');
        }

        private function drawSeason():void {
            label(this,GameData.seasonLabel(),192,518,315,20,12).filters=[new GlowFilter(0x163345,1,3,3,5)];
            var schedule:Array=GameData.seasonScheduleWindow(5);
            for(var i:int=0;i<schedule.length;i++){
                var item:Object=schedule[i],plate:Sprite=new Sprite();plate.x=192+i*63;plate.y=540;ClassicChrome.well(plate.graphics,0,0,57,48,item.current,false);
                var logo:TeamLogoView=new TeamLogoView(String(item.city),uint(item.accent),String(item.teamName).charAt(0),40);logo.x=7;logo.y=3;plate.addChild(logo);disposables.push(logo);
                var result:Object=GameData.seasonResultForGame(int(item.game));if(result)label(plate,result.win?'WIN':'LOSE',2,9,53,28,15,result.win?0xffef86:0xefb2ae,'center');label(plate,String(item.game),40,32,15,16,9,0xffffff,'center');addChild(plate);
            }
            ClassicChrome.well(chrome.graphics,511,540,70,48,false,false);label(this,'Team Rank',511,541,70,18,10,0xd6e7e7,'center');label(this,String(GameData.seasonRank()),519,556,54,32,25,0x9af341,'center');
            var goal:Sprite=iconAction('GOALS','',588,540,112,48);ClassicChrome.well(goal.graphics,0,0,112,48,false,false);label(goal,'Season Goal',2,1,108,18,11,0xd6e7e7,'center');
            for(i=0;i<2;i++){ClassicChrome.well(goal.graphics,4+i*53,20,50,25);label(goal,i==0?GameData.goalLabel():'RBI',5+i*53,19,48,13,9,0x355365,'center');label(goal,i==0?GameData.goalCurrent()+'/'+GameData.goalTarget():GameData.rbiCurrent()+'/'+GameData.seasonGoalRbi,5+i*53,31,48,14,10,0x8b681f,'center');}
            ClassicChrome.panel(chrome.graphics,707,540,242,48);label(this,'MY BEST',718,546,75,18,11,0xe8f5fd);label(this,number(GameData.scoreHistory.best),796,544,138,33,22,0x8dddfb,'right');
        }

        private function drawIncome():void {

            collectButton=new Sprite();collectButton.x=859;collectButton.y=70;collectButton.buttonMode=true;collectButton.mouseChildren=false;collectButton.name='COLLECT';

            collectButton.graphics.beginFill(0xffffff,.01);collectButton.graphics.drawRect(0,0,84,75);collectButton.graphics.endFill();
            sprite(collectButton,'chest',0,-3,84,56);

            collectText=label(collectButton,'',0,53,84,21,11,0xffe376,'center');collectText.filters=[new GlowFilter(0x163345,1,3,3,5)];

            collectButton.addEventListener(MouseEvent.CLICK,onCollect);addChild(collectButton);

            toast=label(this,'',225,459,374,29,13,0xffe17d,'center');toast.filters=[new GlowFilter(0x183d38,1,4,4,4)];refreshResources();

        }

        private function drawCoach():void {
            var guide:StarterCoach=new StarterCoach('¡Vamos a jugar tu primer partido! Pulsa PLAY BALL para fijar tus metas.');guide.name='first-play-guide';guide.pointTo(new Rectangle(10,521,164,72),214,325);guide.mouseEnabled=guide.mouseChildren=false;addChild(guide);disposables.push(guide);
        }

        private function refreshStarterCoach():void {
            if(starterCoach){starterCoach.dispose();if(starterCoach.parent)starterCoach.parent.removeChild(starterCoach);starterCoach=null;}
            if(!alive||!GameData.tutorialActive()||statPanel||starterDraft||starterReward||GameData.onboardingActive()&&GameData.starterTutorial.stage<StarterTutorial.POINT)return;
            var stage:int=int(GameData.starterTutorial.stage),message:String="",action:String="",callback:Function=null;
            if(stage==StarterTutorial.DRAFT){openStarterDraft();return;}
            if(stage==StarterTutorial.REWARD){starterReward=new StarterMissionOverlay(function():void{starterReward.dispose();removeChild(starterReward);starterReward=null;GameData.tutorialEvent("reward");refreshStarterCoach();});addChild(starterReward);return;}
            if(stage==StarterTutorial.POINT){message="¡Bien jugado! Pulsa tu héroe para ver Contact, Power y Luck. Invierte un punto si ya subiste de nivel y cierra el panel.";}
            else if(stage==StarterTutorial.CLAIM){message="¡MISIÓN COMPLETA! SIGUE LO BÁSICO.";action="COBRAR 40,000 COINS";callback=function():void{GameData.claimStarterReward();refreshResources();refreshStarterCoach();};}
            else if(stage==StarterTutorial.NAME){message="¡Tu temporada comienza! Haz clic en NAME para darle nombre a tu equipo.";}
            else if(stage==StarterTutorial.TICKETS){
                message=GameData.canCollectGateIncome()?"Recoge tus primeras Coins de taquilla haciendo clic en TICKETS.":"Ya recogiste tu taquilla. Vuelve cuando el reloj termine para cobrar otra vez.";
                if(!GameData.canCollectGateIncome()){action="¡ENTENDIDO!";callback=function():void{GameData.tutorialEvent("tickets");refreshStarterCoach();};}
            }
            else if(stage<=StarterTutorial.MATCH||stage==StarterTutorial.REORDER||stage==StarterTutorial.AUTOSORT){message="Continúa el tutorial desde LINEUP. Tu sobre y tus pasos completados están guardados.";action="CONTINUAR TUTORIAL";callback=function():void{actions.LINEUP();};}
            else return;
            starterCoach=new StarterCoach(message,action,callback,stage<StarterTutorial.POINT?function():void{GameData.skipStarterTutorial();refreshStarterCoach();}:null);addChild(starterCoach);
            if(stage==StarterTutorial.POINT)starterCoach.pointTo(new Rectangle(632,278,163,251),185,240);
            else if(stage==StarterTutorial.NAME)starterCoach.pointTo(new Rectangle(192,75,218,30),198,240);
            else if(stage==StarterTutorial.TICKETS)starterCoach.pointTo(new Rectangle(859,70,84,75),198,240);
            else {starterCoach.x=220;starterCoach.y=245;}
        }
        private function openStarterDraft():void {
            starterDraft=new FriendDraftScreen(960,screenH,function():void{starterDraft.dispose();removeChild(starterDraft);starterDraft=null;refreshResources();refreshStarterCoach();},function():void{if(actions.FRIENDS!=null)actions.FRIENDS();});addChild(starterDraft);refreshResources();
        }
        private function openHeroStats(e:MouseEvent):void {closeProfile();closeStats();statPanel=new HeroStatPanel(closeStats,function():void{closeStats();if(actions.SHOP!=null)actions.SHOP();});addChild(statPanel);refreshStarterCoach();}
        private function closeStats():void {
            if(statPanel){statPanel.dispose();if(statPanel.parent)statPanel.parent.removeChild(statPanel);statPanel=null;
                // A scoreless loss must not trap a new account behind a point it has not earned.
                if(GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.POINT&&int(GameData.mainPlayer().skillPoints)==0)GameData.tutorialEvent("point");
            }refreshStarterCoach();
        }
        private function profileHandler(player:Object):Function {return function(e:MouseEvent):void {closeProfile();dossier=new PlayerDossier(player,960,screenH,closeProfile,function():void{closeProfile();if(actions.LINEUP!=null)actions.LINEUP();},'LINEUP');addChild(dossier);};}

        private function closeProfile():void {if(dossier){dossier.dispose();if(dossier.parent)dossier.parent.removeChild(dossier);dossier=null;}}

        public function handleEscape():void {closeProfile();closeStats();}

        private function onTeam(e:MouseEvent):void { if(actions.TEAM!=null) actions.TEAM(); }

        private function onCollect(e:MouseEvent):void {

            var amount:int=GameData.collectGateIncome();refreshResources();refreshStarterCoach();

            if(amount>0&&coinFlight)coinFlight.send(901,99,5);

            toast.text=amount>0?"+C "+number(amount)+"  GATE INCOME":"Available at "+GameData.gateIncomeCountdownLabel();

            toastUntil=getTimer()+3000;refreshResources();

        }

        private function refreshResources():void {

            resourceBar.refresh();

            collectText.text=GameData.canCollectGateIncome()?"COLLECT":GameData.gateIncomeCountdownLabel();

            refreshHomeNotices();

        }

        private function refreshHomeNotices():void {
            if(!homeMotion)return;
            var points:int=int(GameData.mainPlayer().skillPoints),ready:int=0,bestDone:int=0,bestTotal:int=0;
            for each(var mission:Object in GameData.missionCatalog()){
                if(GameData.missionClaimed(String(mission.id)))continue;
                var complete:Boolean=true,done:int=0,total:int=mission.objectives.length;for each(var objective:Object in mission.objectives){if(int(objective.current)<int(objective.target))complete=false;else done++;}
                if(complete)ready++;
                else if(done>0&&(bestTotal==0||done/total>bestDone/bestTotal)){bestDone=done;bestTotal=total;}
            }
            var hall:int=GameData.hallAvailable();
            homeMotion.notice("HERO",points>0,points);homeMotion.notice("MISSIONS",ready>0,ready);
            homeMotion.notice("HALL",hall>0,hall);homeMotion.notice("COLLECT",GameData.canCollectGateIncome());
            homeMotion.missionProgress(bestDone,bestTotal);
        }

        private function onFrame(e:Event):void {

            var now:int=getTimer();

            for(var i:int=0;i<players.length;i++) players[i].view.y=players[i].y+Math.sin(now/440+i)*0.65;

            var covered:Boolean=Boolean(dossier||statPanel||batOverlay||starterDraft||starterReward||starterCoach);
            if(homeMotion){homeMotion.setCovered(covered);homeMotion.advance(now);}if(friendFence){friendFence.setCovered(covered);friendFence.advance(now);}
            if(now>=nextRefresh){refreshResources();nextRefresh=now+1000;}
            if(!covered&&now>=nextSocialAt&&social&&!social.busy)refreshFriends();

            if(toastUntil>0&&now>=toastUntil){toast.text="";toastUntil=0;}

        }

        private function register(view:Sprite,id:String,callback:Function,temporary:Boolean=false):void {

            view.name=id;view.mouseEnabled=true;view.buttonMode=true;view.useHandCursor=true;view.mouseChildren=false;view.addEventListener(MouseEvent.CLICK,callback);

            (temporary?rosterControls:buttons).push({view:view,callback:callback});

        }

        private function iconAction(key:String,title:String,x:Number,y:Number,w:Number,h:Number):Sprite {

            var s:Sprite=new Sprite();s.x=x;s.y=y;s.graphics.beginFill(0xffffff,.01);s.graphics.drawRect(0,0,w,h);s.graphics.endFill();addChild(s);

            register(s,key,function(e:MouseEvent):void{if(actions[key]!=null)actions[key]();});

            if(title.length)label(s,title,0,h-15,w,17,9,0xffffff,'center').filters=[new GlowFilter(0x163345,1,3,3,5)];return s;

        }

        private function sprite(parent:Sprite,key:String,x:Number,y:Number,w:Number,h:Number,stretch:Boolean=false):void {
            var art:Sprite=(key=="scout"||key=="friends")?new com.bh.visual.RecruitmentArtwork(key=="scout"?"file":"friends",w,h):InventoryArtwork.supports(key)?new InventoryArtwork(key,w,h):new InterfaceSprite(key,w,h,stretch);art.x=x;art.y=y;parent.addChild(art);
        }

        private function menu(key:String,title:String,x:Number,y:Number,kind:String):void {
            var s:Sprite=iconAction(key,'',x,y,86,57);ClassicChrome.well(s.graphics,0,0,86,57);
            var art:String=kind=='field'?'build':kind=='lineup'?'batter':kind=='shop'?'shop':'modes';
            sprite(s,art,11,2,64,36);
            var t:TextField=label(s,title,3,38,80,19,12,0x324c5a,'center');LineupTypography.apply(t,12,0x324c5a,'center',true);
        }

        private function rosterPages():int{return Math.max(1,Math.ceil(friends.length/6));}

        private function pageArrow(id:String,x:Number,y:Number,right:Boolean,callback:Function):Sprite {

            var s:Sprite=new Sprite();s.x=x;s.y=y;s.graphics.beginFill(0xffffff,.01);s.graphics.drawRect(0,0,20,25);s.graphics.endFill();addChild(s);register(s,id,callback);

            s.graphics.lineStyle(1,0x164665);ClassicInventorySkin.gradient(s.graphics,0,4,19,15,0xffffff,0x86b3c8,15);s.graphics.lineStyle();s.graphics.beginFill(0x315d7a);s.graphics.moveTo(right?7:12,7);s.graphics.lineTo(right?13:6,11);s.graphics.lineTo(right?7:12,15);s.graphics.endFill();return s;

        }

        private function clearRoster():void {

            for each(var entry:Object in rosterControls)entry.view.removeEventListener(MouseEvent.CLICK,entry.callback);rosterControls=[];

            for each(var p:* in rosterArt)p.dispose();rosterArt=[];while(rosterLayer.numChildren)rosterLayer.removeChildAt(0);

        }

        private function refreshFriends():void {
            if(!friendStatus){friendStatus=label(this,"LOADING FRIENDS…",192,493,408,23,12,0xd2edff,"center");friendStatus.name="home-friend-status";}
            if(!social)social=new OnlineClient();nextSocialAt=getTimer()+20000;
            if(!social.user){friendStatus.text="Abre ADD FRIENDS y conecta tu cuenta para ver amigos";return;}if(social.busy)return;
            social.request("GET","/social",null,function(result:Object):void {
                if(!alive)return;var oldSignature:String=friendSignature;friends=[];pendingRequests=pendingGifts=0;socialLoaded=true;socialError="";
                for each(var m:Object in result.members)if(m.connected===true)friends.push(m);
                for each(var request:Object in result.requests)if(request.receiver==result.userId&&request.status=="pending")pendingRequests++;
                for each(var link:Object in result.links)if(link.friend==result.userId&&link.status=="pending")pendingRequests++;
                for each(var gift:Object in result.gifts)if(!gift.claimed)pendingGifts++;
                friends.sort(function(a:Object,b:Object):Number{var ai:int=GameData.friendDraft.indexOf(a.id),bi:int=GameData.friendDraft.indexOf(b.id);if(ai>=0||bi>=0)return (ai<0?99:ai)-(bi<0?99:bi);return String(a.name).toLowerCase()<String(b.name).toLowerCase()?-1:1;});friendSignature=JSON.stringify(friends);GameData.applySocialSnapshot(result);
                if(friendFence)friendFence.update(friends,pendingRequests,pendingGifts);if(oldSignature!=friendSignature)renderRoster();updateFriendStatus();refreshResources();
            },function(message:String,code:int):void {if(!alive)return;nextSocialAt=getTimer()+20000;socialError="Sin conexión. Reintentando amigos…";updateFriendStatus();});
        }
        private function updateFriendStatus():void {if(!friendStatus)return;friendStatus.text=socialError?socialError:pendingRequests?pendingRequests+" solicitud(es) pendiente(s) · ADD FRIENDS":pendingGifts?pendingGifts+" regalo(s) pendiente(s) · GIFTS":!socialLoaded?"LOADING FRIENDS…":friends.length?"":"Pulsa ADD FRIENDS para buscar amigos o compartir tu enlace";}

        private function renderRoster():void {
            clearRoster();var count:int=rosterPages();rosterPage=Math.max(0,Math.min(count-1,rosterPage));updateFriendStatus();
            for(var local:int=0;local<6;local++){
                var index:int=rosterPage*6+local,member:Object=index<friends.length?friends[index]:null,tile:Sprite=new Sprite();tile.x=local*100;ClassicChrome.well(tile.graphics,0,0,96,117);rosterLayer.addChild(tile);
                if(!member){sprite(tile,'friends',11,15,74,66);label(tile,'ADD FRIEND',4,83,88,30,11,0x58798c,'center').wordWrap=true;register(tile,'home-empty-'+local,function(e:MouseEvent):void{if(actions.FRIENDS!=null)actions.FRIENDS();},true);continue;}
                var data:Object=member.profile||{};label(tile,String(member.name),3,3,90,20,11,0x48545b,'center');
                var portrait:HeroHead=new HeroHead(data.appearance||{},HomeSprite.paletteFor(String(member.name),uint(data.accent||0x247ab2),data.appearance||{},{}));portrait.x=47;portrait.y=77;portrait.scaleX=portrait.scaleY=.40;tile.addChild(portrait);rosterArt.push(portrait);
                label(tile,'LV '+int(data.level||1),62,53,30,19,10,0x31516c,'center');MatchChrome.nameplate(tile.graphics,4,76,88,37);label(tile,'AVG\nHR\nRBI',8,78,32,37,9,0xe8ecee);label(tile,(Number(data.avg||0)/1000).toFixed(3)+'\n'+int(data.hr||0)+'\n'+int(data.rbi||0),44,77,42,38,10,0xfff0b5,'right');register(tile,'home-friend-'+member.id,friendVisitHandler(String(member.id)),true);
            }
            previous.alpha=rosterPage>0?1:.4;previous.mouseEnabled=rosterPage>0;next.alpha=rosterPage<count-1?1:.4;next.mouseEnabled=rosterPage<count-1;pageText.text=(rosterPage+1)+'/'+count;
        }

        private function friendVisitHandler(id:String):Function {return function(e:MouseEvent):void {if(actions.VISIT!=null)actions.VISIT(id);};}
        private function number(value:int):String {

            var s:String=String(value),r:String="";

            while(s.length>3){r=","+s.substr(s.length-3)+r;s=s.substr(0,s.length-3);}return s+r;

        }

        private function closeBat():void {if(batOverlay){batOverlay.dispose();removeChild(batOverlay);batOverlay=null;}if(hero){hero.dispose();removeChild(hero);hero=null;}drawHero();resourceBar.refresh();}

        public function dispose():void {
            if(starterDraft){starterDraft.dispose();starterDraft=null;}if(starterReward){starterReward.dispose();starterReward=null;}
            if(statPanel){statPanel.dispose();statPanel=null;}if(starterCoach){starterCoach.dispose();starterCoach=null;}alive=false;if(social)social.dispose();if(batOverlay){batOverlay.dispose();batOverlay=null;}

            closeProfile();clearRoster();removeEventListener(Event.ENTER_FRAME,onFrame);backdrop.dispose();hero.dispose();if(homeBag){homeBag.dispose();homeBag=null;}

            collectButton.removeEventListener(MouseEvent.CLICK,onCollect);

            for each(var entry:Object in buttons){entry.view.removeEventListener(MouseEvent.CLICK,entry.callback);if(entry.view is UIButton) UIButton(entry.view).dispose();else if(entry.view is ClassicActionButton)ClassicActionButton(entry.view).dispose();}

            for each(var d:Object in disposables) if("dispose" in d) d.dispose();

            players=[];buttons=[];disposables=[];

        }

    }

}

