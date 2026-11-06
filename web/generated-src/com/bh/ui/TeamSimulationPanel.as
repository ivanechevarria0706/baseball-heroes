package com.bh.ui {
    import com.bh.visual.VisualProfile;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.geom.Matrix;
    import flash.filters.GlowFilter;
    import flash.utils.getTimer;
    import com.bh.audio.AudioManager;
    import com.bh.audio.AudioCueSequence;
    import com.bh.audio.SimulationAudio;
    import com.bh.audio.OriginalAudioBank;
    import com.bh.audio.GameplayAudio;
    import com.bh.model.GameData;
    import com.bh.model.FriendRoster;
    import com.bh.visual.TeamLogoView;
    import com.bh.visual.LeagueBadgeView;
    import com.bh.visual.MLBPlayerArtwork;

    /** Simulation overlay and timed camera handoff, reconstructed from F.A.F. 405–418 s. */
    public class TeamSimulationPanel extends Sprite {
        private var entryCues:AudioCueSequence,introduced:Boolean=false,entryDuration:int=0,entryFirst:Boolean=true;
        private var panelW:Number,panelH:Number;
        private var clock:Function;
        private var resourceBar:MatchResourceBar;
        private var resourceLayer:Sprite=new Sprite(),fixed:Sprite=new Sprite(),left:Sprite=new Sprite(),right:Sprite=new Sprite(),center:Sprite=new Sprite(),effects:Sprite=new Sprite(),shade:Sprite=new Sprite();
        private var homeRows:Array=[],awayRows:Array=[],homePlayers:Array=[],awayPlayers:Array=[],logos:Array=[];
        private var opponent:Object,heroName:String='';
        private var side:String='AWAY',inning:int=1,outs:int=0,activeIndex:int=0;
        private var homeScore:int=0,awayScore:int=0,homeLine:Array=[],awayLine:Array=[];
        private var homeCells:Array=[],awayCells:Array=[],inningHeaders:Array=[],speedButtons:Array=[];
        private var homeTotal:TextField,awayTotal:TextField,leftTotal:TextField,rightTotal:TextField,inningText:TextField,outText:TextField,resources:TextField,scoreText:TextField,comboText:TextField;
        private var firstRunner:Sprite,secondRunner:Sprite,thirdRunner:Sprite;
        private var speed:int=4;
        private var mode:String='HIDDEN',entryAt:int=0,heroAt:int=0;
        private var stamp:Sprite,stampPixels:BitmapData,stampAt:int=0,stampDuration:int=0;
        private var popup:SpecialBatterCardView,popupTitle:TextField,popupAt:int=0;
        private var mlbActors:Array=[];
        private var comboFloat:TextField,comboAt:int=-1;
        private var energyText:TextField,coinText:TextField,cashText:TextField;
        private var disposed:Boolean=false;private var matchCharge:int=0,liveCoins:int=0,liveXP:int=0;
        private var resultSoundMs:int=0;
        private var layoutAt:int=-1,layoutFrom:Object;
        private var diamond:MatchMiniDiamond,comboRing:Sprite=new Sprite(),activeCell:Shape=new Shape();
        private var homeHits:TextField,awayHits:TextField,playText:TextField;
        private var outLights:Array=[];
        private var runFloat:SimulationRunStamp,runAt:int=-1,runSide:String='HOME',runIndex:int=0,runDuration:int=300,lastPaintedCharge:int=-1;
        private var pauseButton:Sprite,pauseNotice:TextField,pausedAt:int=-1,pausedTotal:int=0;
        public function get isPaused():Boolean {return pausedAt>=0;}
        public function pauseForInspection():Boolean {var was:Boolean=isPaused;if(!was){pausedAt=int(clock());entryCues.pause();paintPause();}return was;}
        public function resumeAfterInspection(wasPaused:Boolean):void {if(!wasPaused)resumeSimulation();}
        public function opponentRosterSnapshot():Array {return JSON.parse(JSON.stringify(awayPlayers)) as Array;}
        public function pausedDuration():int {return pausedTotal+(pausedAt>=0?Math.max(0,int(clock())-pausedAt):0);}
        public function simulationNow():int {return int(clock())-pausedDuration();}
        public function TeamSimulationPanel(w:Number=960,h:Number=540,timeSource:Function=null){
            panelW=w;panelH=h;clock=timeSource!=null?timeSource:getTimer;entryCues=new AudioCueSequence(simulationNow);SimulationAudio.preload();
            name='simulation-panel';left.name='home-lineup';right.name='away-lineup';shade.name='hero-transition-shade';
            addChild(resourceLayer);addChild(fixed);addChild(left);addChild(right);addChild(center);addChild(effects);addChild(shade);
            shade.mouseEnabled=false;shade.graphics.beginFill(0x000000);shade.graphics.drawRect(0,38,w,h-38);shade.graphics.endFill();shade.alpha=0;
            visible=false;addEventListener(Event.ENTER_FRAME,onFrame);
        }
        private function text(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,id:String=''):TextField {
            var t:TextField=new TextField();t.text=value;LineupTypography.apply(t,size,color,'center',size>=23);
            // These live fields also contain triangles and en dashes, outside
            // the embedded Latin font range. Keep their device-font fallback.
            if(id=='simulation-inning'||id.indexOf('home-inning-')==0||id.indexOf('away-inning-')==0){t.embedFonts=false;var f:TextFormat=new TextFormat('Arial',size,color,true);f.align='center';t.defaultTextFormat=f;t.setTextFormat(f);}
            t.x=x;t.y=y;t.width=w;t.height=h;t.name=id;t.selectable=false;t.mouseEnabled=false;parent.addChild(t);return t;
        }
        private function box(parent:Sprite,x:Number,y:Number,w:Number,h:Number,fill:uint,border:uint):void {
            parent.graphics.lineStyle(2,border);parent.graphics.beginFill(fill);parent.graphics.drawRoundRect(x,y,w,h,6,6);parent.graphics.endFill();parent.graphics.lineStyle();
        }
        private function clear(parent:Sprite):void {while(parent.numChildren)parent.removeChildAt(0);parent.graphics.clear();}
        public function configure(home:Array,rival:Object,hero:Object,defendingRoster:Array=null):void {
            releaseViews();clear(resourceLayer);clear(fixed);clear(left);clear(right);clear(center);clear(effects);
            homePlayers=home?home:[];opponent=rival;heroName=hero&&hero.name?String(hero.name):'';awayPlayers=defendingRoster||createOpponentRoster(rival);
            homeScore=awayScore=0;homeLine=[];awayLine=[];homeCells=[];awayCells=[];inningHeaders=[];speedButtons=[];outLights=[];lastPaintedCharge=-1;
            buildFixed();buildTeam(left,true);buildTeam(right,false);buildDiamond();buildSpeed();buildPause();
            comboRing=new Sprite();comboRing.x=47;comboRing.y=panelH-47;comboRing.name='simulation-combo-ring';fixed.addChild(comboRing);
            comboFloat=text(effects,'',13,panelH-103,70,30,23,0xb4f768,'combo-gain');comboFloat.filters=[new GlowFilter(0x143226,1,3,3,4)];
            comboText=text(fixed,'',12,panelH-66,70,39,10,0xe4ff8d,'simulation-combo');
            fixed.graphics.lineStyle(2,0x174661);ClassicInventorySkin.gradient(fixed.graphics,panelW-202,panelH-58,198,55,0x23a8dd,0x075995,8);fixed.graphics.lineStyle();
            ClassicInventorySkin.gradient(fixed.graphics,panelW-194,panelH-32,181,23,0x194167,0x082e56,3);
            text(fixed,'LEADERBOARD',panelW-197,panelH-57,187,22,12,0xffffff);
            scoreText=text(fixed,'',panelW-193,panelH-33,181,25,13,0xffffff,'simulation-score');
            runFloat=new SimulationRunStamp();effects.addChild(runFloat);
            refreshValues();setActiveBatter(side,0);setBases(false,false,false);render();
        }
        private function buildFixed():void {
            resourceBar=new MatchResourceBar(panelW);resourceLayer.addChild(resourceBar);
            MatchChrome.score(fixed.graphics,265,56,430,53);
            for(var grid:int=0;grid<12;grid++){fixed.graphics.lineStyle(1,0x071f26,.48);fixed.graphics.moveTo(389+grid*25,59);fixed.graphics.lineTo(389+grid*25,105);}fixed.graphics.lineStyle();
            box(fixed,270,84,115,18,0x1d749f,0x91b8bc);box(fixed,270,61,115,18,0xa33a42,0x91b8bc);
            text(fixed,GameData.teamCity,272,85,111,17,8,0xffffff);
            text(fixed,opponent&&opponent.city?String(opponent.city):'RIVALS',272,62,111,17,8,0xffffff);
            for(var i:int=0;i<9;i++){
                inningHeaders.push(text(fixed,String(i+1),390+i*27,42,27,16,9,0xdce9dd,'inning-header-'+i));
                homeCells.push(text(fixed,'',390+i*27,84,27,18,10,0xffffff,'home-inning-'+i));
                awayCells.push(text(fixed,'',390+i*27,61,27,18,10,0xffffff,'away-inning-'+i));
            }
            // Tighten inning columns to leave room for the original R / H totals.
            for(i=0;i<9;i++){TextField(inningHeaders[i]).x=390+i*25;TextField(homeCells[i]).x=390+i*25;TextField(awayCells[i]).x=390+i*25;}
            text(fixed,'R',624,42,28,16,9,0xffffff);homeTotal=text(fixed,'0',624,84,30,18,11,0xffda65,'home-runs');awayTotal=text(fixed,'0',624,61,30,18,11,0xffffff,'away-runs');
            text(fixed,'H',659,42,28,16,9,0xffffff);homeHits=text(fixed,'0',659,84,30,18,11,0xffffff,'home-hits');awayHits=text(fixed,'0',659,61,30,18,11,0xffffff,'away-hits');
            activeCell=new Shape();fixed.addChild(activeCell);
            var homeLogo:TeamLogoView=new TeamLogoView(GameData.teamCity,GameData.teamAccent,'H',44);homeLogo.x=211;homeLogo.y=58;fixed.addChild(homeLogo);logos.push(homeLogo);
            var awayLogo:TeamLogoView=new TeamLogoView(String(opponent.city),uint(opponent.accent),'R',44);awayLogo.x=705;awayLogo.y=58;fixed.addChild(awayLogo);logos.push(awayLogo);
        }
        private function resourceCapsule(x:Number,w:Number,color:uint):void {
            var g:Graphics=resourceLayer.graphics,m:Matrix=new Matrix();m.createGradientBox(w,24,Math.PI/2,x,7);
            g.lineStyle(2,0xa8d7df);g.beginGradientFill('linear',[0x9dcbd4,color,0x244533],[1,1,1],[0,95,255],m);g.drawRoundRect(x,7,w,24,24,24);g.endFill();g.lineStyle();
        }
        private function buildTeam(parent:Sprite,home:Boolean):void {
            MatchChrome.paper(parent.graphics,0,0,294,43);MatchChrome.paper(parent.graphics,0,48,294,276);
            var city:String=home?GameData.teamCity:opponent&&opponent.city?String(opponent.city):'RIVALS';
            var team:String=home?GameData.teamName:opponent&&opponent.teamName?String(opponent.teamName):'RIVALS';
            var logo:TeamLogoView=new TeamLogoView(city,home?GameData.teamAccent:uint(opponent.accent),home?'H':'R',36);logo.x=home?7:251;logo.y=3;parent.addChild(logo);logos.push(logo);
            MatchChrome.nameplate(parent.graphics,48,5,194,28,home);parent.graphics.lineStyle(1.2,0x20372c);
            ClassicInventorySkin.gradient(parent.graphics,home?249:5,5,39,32,0xa5aea5,0x4d594e,3);parent.graphics.lineStyle();
            var cityLabel:TextField=text(parent,city.toUpperCase(),50,5,190,16,10,0xffffff);LineupTypography.fit(cityLabel,10,0xffffff,'center');var teamLabel:TextField=text(parent,team.toUpperCase(),50,20,190,13,7,0xffffff);LineupTypography.fit(teamLabel,7,0xffffff,'center',false,6);
            var total:TextField=text(parent,'0',home?249:5,3,39,36,27,home?0xffba29:0xe5eeee,home?'home-panel-score':'away-panel-score');total.filters=[new GlowFilter(0x1b302b,1,3,3,5)];
            if(home)leftTotal=total;else rightTotal=total;
            text(parent,'PLAYER',81,48,100,12,7,0x687c74);text(parent,'AVG',227,48,37,12,7,0x687c74);
            var players:Array=home?homePlayers:awayPlayers,rows:Array=home?homeRows:awayRows,slot:int=0,friends:Array=FriendRoster.list();
            for(var i:int=0;i<9;i++){
                var data:Object=i<players.length?players[i]:{name:'PLAYER '+(i+1),avg:'.200'};
                var card:Object=null,friend:Object=null,mood:int=0;
                if(home&&String(data.name)!=heroName){card=GameData.lineupCardForMatchAt(i);
                    var link:Object=GameData.registeredFriend(data);if(link)for each(var member:Object in friends)if(member.id==link.friend){friend=member;break;}
                }
                if(home)mood=card?2:GameData.matchCondition(data);
                var row:SimulationPlayerRow=new SimulationPlayerRow(data,i,home,278,28,card,friend,mood);row.x=8;row.y=61+i*29;parent.addChild(row);rows.push(row);
            }
        }
        private function buildDiamond():void {
            center.x=panelW/2;center.y=panelH*.60;
            diamond=new MatchMiniDiamond(GameData.teamAccent,simulationNow,true);diamond.name='simulation-diamond';diamond.scaleX=diamond.scaleY=.81;diamond.x=-54;diamond.y=-48;center.addChild(diamond);
            firstRunner=diamond.getChildByName('runner-first') as Sprite;firstRunner.name='first-runner';secondRunner=diamond.getChildByName('runner-second') as Sprite;secondRunner.name='second-runner';thirdRunner=diamond.getChildByName('runner-third') as Sprite;thirdRunner.name='third-runner';
            ClassicInventorySkin.gradient(center.graphics,-55,40,110,21,0x546a4f,0x243b2d,12);
            inningText=text(center,'',-56,-76,112,23,12,0xffffff,'simulation-inning');inningText.filters=[new GlowFilter(0x153c33,1,3,3,4)];
            for(var oi:int=0;oi<3;oi++){var light:Shape=new Shape();light.name='out-light-'+oi;light.x=-42+oi*12;light.y=50;light.graphics.lineStyle(1,0x1c2927);light.graphics.beginFill(0xf3c147);light.graphics.drawCircle(0,0,4);light.graphics.endFill();center.addChild(light);outLights.push(light);}
            outText=text(center,'',-10,40,64,22,10,0xffde80,'simulation-outs');outText.filters=inningText.filters;
            playText=text(center,'',-74,66,148,41,11,0xffe27b,'simulation-play-detail');playText.multiline=true;playText.filters=inningText.filters;
        }
        private function runner(x:Number,y:Number,id:String):Sprite {var s:Sprite=new Sprite();s.x=x;s.y=y;s.name=id;s.graphics.lineStyle(2,0x235647);s.graphics.beginFill(0xffe27d);s.graphics.drawCircle(0,0,7);s.graphics.endFill();center.addChild(s);return s;}
        private function buildSpeed():void {
            for(var i:int=0;i<3;i++){
                var s:Sprite=new Sprite();s.name='speed-'+[4,2,1][i];s.x=panelW-49;s.y=180+i*35;s.buttonMode=true;
                text(s,'x'+[4,2,1][i],0,5,34,24,13,0xffffff);fixed.addChild(s);s.addEventListener(MouseEvent.CLICK,onSpeed);speedButtons.push({view:s,value:[4,2,1][i]});
            }paintSpeed();
        }
        private function paintSpeed():void {for each(var item:Object in speedButtons){var s:Sprite=item.view;s.graphics.clear();ClassicChrome.button(s.graphics,34,30,item.value==speed?0xc99b35:0x344a4c,false,false,false);}}
        private function onSpeed(e:MouseEvent):void {e.stopPropagation();if(mode!='SIM')return;for each(var item:Object in speedButtons)if(item.view==e.currentTarget){speed=int(item.value);paintSpeed();break;}}
        private function buildPause():void {
            pauseButton=new Sprite();pauseButton.name='simulation-pause';pauseButton.x=panelW-49;pauseButton.y=119;pauseButton.mouseChildren=false;pauseButton.buttonMode=true;
            fixed.addChild(pauseButton);pauseButton.addEventListener(MouseEvent.CLICK,togglePause);
            pauseNotice=text(fixed,'Autojuego en pausa. Pulsa el triángulo para continuar.',265,116,430,30,13,0xffe58b,'simulation-pause-tip');paintPause();
        }
        private function togglePause(e:MouseEvent):void {
            e.stopPropagation();if(mode!='SIM')return;
            if(isPaused)resumeSimulation();else {pausedAt=int(clock());entryCues.pause();paintPause();}
        }
        private function resumeSimulation():void {
            if(isPaused){pausedTotal+=Math.max(0,int(clock())-pausedAt);pausedAt=-1;entryCues.resume();}paintPause();
        }
        private function paintPause():void {
            if(!pauseButton)return;var g:Graphics=pauseButton.graphics;g.clear();ClassicChrome.button(g,34,32,isPaused?0x8fd35b:0xb6c3bf,false,false,false);g.lineStyle();g.beginFill(0x233b31);
            if(isPaused){g.moveTo(11,7);g.lineTo(25,16);g.lineTo(11,25);g.lineTo(11,7);}else {g.drawRect(10,8,5,16);g.drawRect(21,8,5,16);}g.endFill();pauseNotice.visible=isPaused;
        }
        private var livePoints:int=0;
        public function setMomentum(value:Object):void {matchCharge=int(value.charge);paintCombo();}
        private function paintCombo():void {
            if(!comboText)return;comboText.text=matchCharge>=10?'MAX\nCOMBO':'COMBO\n'+matchCharge+'/10';
            if(lastPaintedCharge==matchCharge)return;lastPaintedCharge=matchCharge;
            var g:Graphics=comboRing.graphics;g.clear();g.lineStyle(2,0x173529);ClassicInventorySkin.gradient(g,-36,-36,72,72,0xffffff,0x7a8a7d,72);
            g.lineStyle(6,0x354b40);g.drawCircle(0,0,28);g.lineStyle(6,matchCharge>=10?0xffb431:0x76d63b,1,false,'normal','round');
            var end:Number=Math.min(1,matchCharge/10)*Math.PI*2;g.moveTo(0,28);for(var a:Number=0;a<=end;a+=.05)g.lineTo(Math.sin(a)*28,Math.cos(a)*28);
            g.lineStyle(2,0xffffff);ClassicInventorySkin.gradient(g,-23,-23,46,46,0x8be9fc,0x0f81b6,46);g.lineStyle();
        }
        public function setHits(home:int,away:int):void {if(homeHits){homeHits.text=String(home);awayHits.text=String(away);}}
        public function setLiveRewards(c:int,x:int,committed:Boolean=false):void {liveCoins=committed?0:c;liveXP=committed?0:x;refreshValues();}
        public function setLiveScore(value:int):void {livePoints=value;scoreText.text="SCORE  "+value;}
        public function simulationDelay():int {return speed==4?470:speed==2?880:1650;}
        public function resultDelay():int {return Math.max(popup?1250:speed==4?300:speed==2?520:960,resultSoundMs);}
        public function entryRemaining():int {return mode=="SIM"?Math.max(0,entryDuration-(simulationNow()-entryAt)):0;}
        private function selectSide(value:String):void {if(side==value)return;if(mode=="SIM"){layoutFrom={lx:left.x,ly:left.y,lsx:left.scaleX,lsy:left.scaleY,rx:right.x,ry:right.y,rsx:right.scaleX,rsy:right.scaleY};layoutAt=simulationNow();}side=value;}
        public function nextBatterDelay():int {return Math.max(120,simulationDelay()-resultDelay());}
        public function beginSimulation(value:int,currentSide:String='HOME'):void {
            var entering:Boolean=mode!='SIM';selectSide(currentSide);mode='SIM';inning=value;visible=true;mouseChildren=true;shade.alpha=0;
            if(entering){entryAt=simulationNow();clearTransient();layoutAt=-1;entryFirst=!introduced;var cue:String=entryFirst?'match_teams':'sim_transition',delay:int=entryFirst?0:240;entryDuration=delay+Math.ceil(OriginalAudioBank.sound(cue).length)+80;entryCues.enqueue(cue+'.mp3',delay,.68);introduced=true;}
            refreshValues();render();
        }
        public function setHalfInning(currentSide:String,value:int):void {selectSide(currentSide);inning=value;refreshLine();}
        public function setActiveBatter(currentSide:String,index:int):void {
            selectSide(currentSide);activeIndex=index;
            var activePlayers:Array=side=='HOME'?homePlayers:awayPlayers,sceneKey:String=side+":"+index;
            for(var i:int=0;i<homeRows.length;i++)SimulationPlayerRow(homeRows[i]).setActive(side=='HOME'&&i==index);
            for(i=0;i<awayRows.length;i++)SimulationPlayerRow(awayRows[i]).setActive(side=='AWAY'&&i==index);
            refreshLine();
        }
        public function setScore(home:int,away:int,value:int,currentOuts:int):void {
            inning=value;outs=currentOuts;
            var gain:int=side=='HOME'?home-homeScore:away-awayScore;if(gain>0&&runFloat){runFloat.show(gain);runSide=side;runIndex=activeIndex;var hold:int=Math.max(300,resultDelay()),delay:int=Math.max(140,int(hold*.48));runAt=simulationNow()+delay;runDuration=Math.max(120,hold-delay);}
            if(home>homeScore&&side=='HOME')addRuns(homeLine,inning,home-homeScore);
            if(away>awayScore&&side=='AWAY')addRuns(awayLine,inning,away-awayScore);
            homeScore=home;awayScore=away;refreshValues();
        }
        private function addRuns(line:Array,value:int,runs:int):void {while(line.length<value)line.push(0);line[value-1]=int(line[value-1])+runs;}
        private function refreshValues():void {
            if(!resourceBar)return;resourceBar.refresh(liveCoins,liveXP);
            homeTotal.text=leftTotal.text=String(homeScore);awayTotal.text=rightTotal.text=String(awayScore);
            paintCombo();scoreText.text='SCORE  '+livePoints;refreshLine();
        }
        private function refreshLine():void {
            if(!inningText)return;inningText.text=(side=='AWAY'?'▲ ':'▼ ')+ordinal(inning);outText.text=outs+' OUT'+(outs==1?'':'S');for(var oi:int=0;oi<outLights.length;oi++)outLights[oi].alpha=oi<outs?1:.17;
            var first:int=Math.max(1,inning-8);
            activeCell.graphics.clear();activeCell.graphics.lineStyle(2,0x72d7ee);activeCell.graphics.beginFill(0x14728a,.12);activeCell.graphics.drawRect(390+(inning-first)*25,side=='HOME'?84:61,25,18);activeCell.graphics.endFill();activeCell.graphics.lineStyle();
            for(var i:int=0;i<homeCells.length;i++){
                var n:int=first+i;TextField(inningHeaders[i]).text=String(n);
                TextField(homeCells[i]).text=n>inning||n==inning&&side=='AWAY'?'–':String(n<=homeLine.length?int(homeLine[n-1]):0);
                TextField(awayCells[i]).text=n>inning?'–':String(n<=awayLine.length?int(awayLine[n-1]):0);
                TextField(inningHeaders[i]).textColor=n==inning?0xffdc6e:0xdce9dd;
            }
        }
        public function setBases(first:Boolean,second:Boolean,third:Boolean):void {if(diamond)diamond.setBases([first,second,third]);}
        public function showResolvedPlay(before:Array,after:Array,batter:Object,result:String):void {
            if(!diamond)return;diamond.reset();diamond.setBases([after[0]!=null,after[1]!=null,after[2]!=null]);
            var hold:int=Math.max(240,resultDelay()-40),kind:String=result.replace(/ \+.*/,''),hit:Boolean=/SINGLE|DOUBLE|TRIPLE|HOME RUN/.test(kind);
            if(hit||kind.indexOf('WALK')>=0)diamond.play(before,after,batter,1,hold);
            if(hit||kind=='GROUND OUT'||kind=='FLY OUT')diamond.ballInPlay(kind,hold,(activeIndex+inning+(side=='AWAY'?1:0))%3);
            
        }
        public function recordBatterResult(currentSide:String,index:int,result:String):void {
            var rows:Array=currentSide=='HOME'?homeRows:awayRows;if(index>=0&&index<rows.length)SimulationPlayerRow(rows[index]).setResult(result);
        }
        public function addResultFor(currentSide:String,index:int,playerName:String,result:String,comboGain:int=0):void {
            setActiveBatter(currentSide,index);var rows:Array=currentSide=='HOME'?homeRows:awayRows;if(index<0||index>=rows.length)return;
            var cue:String=GameplayAudio.simulationEvent(result);
            resultSoundMs=cue?Math.ceil(GameplayAudio.duration(cue))+40:0;
            SimulationPlayerRow(rows[index]).setResult(result);clearStamp();stamp=new SimulationResultStamp(result);
            stamp.x=161;stamp.y=14;stamp.rotation=-7;stamp.scaleY=.91;Sprite(rows[index]).addChild(stamp);stampAt=simulationNow();stampDuration=resultDelay();
            if(cue)entryCues.enqueue(cue);
            var rbi:Array=result.match(/\+(\d+) RBI/);playText.text=rbi?'+'+rbi[1]+' RBI':'';
            if(currentSide=='HOME'&&comboGain>0){comboFloat.text='+'+comboGain;comboAt=simulationNow();AudioManager.playSfx('sim_combo.mp3',.92);}
        }
        public function showSpecialCard(cardName:String,grade:String,effect:String):void {
            for each(var card:Object in GameData.specialCardCatalog())if(String(card.name)==cardName){showCard(card,effect);return;}
        }
        public function showSpecialCardResult(card:Object,result:String):void {if(card)showCard(card,result);}
        public function showSpecialCardActivation(card:Object,effect:String):void {if(card)showCard(card,effect);}
        private function showCard(card:Object,headline:String):void {
            clearPopup();popup=new SpecialBatterCardView(card,126,198);popup.name='simulation-special-card';popup.x=panelW/2-63;popup.y=175;popup.mouseEnabled=popup.mouseChildren=false;effects.addChild(popup);
            if(MLBPlayerArtwork.indexFor(card)>=0){var actor:MLBPlayerArtwork=new MLBPlayerArtwork(card,166,245);actor.name="simulation-2026-character";actor.x=panelW/2-7;actor.y=161;effects.addChild(actor);mlbActors.push(actor);}
            popupTitle=text(effects,headline,panelW/2-145,143,290,30,18,0xffe261,'special-headline');popupTitle.filters=[new GlowFilter(0x142832,1,4,4,5)];popupAt=simulationNow();AudioManager.playSfx('sim_special.mp3',.90);
        }
        public function showHeroTurn(playerName:String,value:int,score:String):void {
            entryCues.stopAll();resumeSimulation();clearTransient();inning=value;selectSide('HOME');visible=true;mode='HERO';heroAt=simulationNow();mouseChildren=false;
            var index:int=0;for(var i:int=0;i<homePlayers.length;i++)if(String(homePlayers[i].name)==playerName){index=i;break;}setActiveBatter('HOME',index);
            entryCues.enqueue('sim_hero_in.mp3',420,.70);render();
        }
        public function heroTransitionDuration():int {return 420+Math.ceil(OriginalAudioBank.sound("sim_hero_in").length)+60;}
        public function heroReveal():Number {return mode=='HERO'?ease((simulationNow()-heroAt-660)/280):1;}
        public function hidePanel():void {entryCues.stopAll();resumeSimulation();mode='HIDDEN';visible=false;mouseChildren=false;clearTransient();shade.alpha=0;}
        private function ease(n:Number):Number {n=Math.max(0,Math.min(1,n));return n*n*(3-2*n);}
        private function render():void {
            var now:int=simulationNow(),age:int=now-entryAt,arrival:Number=mode=='SIM'?ease((age-(entryFirst?360:620))/320):1;
            var exit:Number=mode=='HERO'?ease((now-heroAt)/280):0;
            // The supplied auto-play board is tall and compact, with the
            // batting team higher/larger and the other side receding.
            var vertical:Number=panelH/580;
            left.scaleX=side=='HOME'?1.12:.90;right.scaleX=side=='AWAY'?1.12:.90;
            left.scaleY=(side=='HOME'?1.16:.98)*vertical;right.scaleY=(side=='AWAY'?1.16:.98)*vertical;
            left.x=panelW*.09-(1-arrival+exit)*465;right.x=panelW*.59+(1-arrival+exit)*465;
            left.y=panelH*(side=='HOME'?.235:.30);right.y=panelH*(side=='AWAY'?.235:.30);
            if(layoutAt>=0&&layoutFrom){var blend:Number=ease((now-layoutAt)/320);left.x=layoutFrom.lx+(left.x-layoutFrom.lx)*blend;left.y=layoutFrom.ly+(left.y-layoutFrom.ly)*blend;left.scaleX=layoutFrom.lsx+(left.scaleX-layoutFrom.lsx)*blend;left.scaleY=layoutFrom.lsy+(left.scaleY-layoutFrom.lsy)*blend;right.x=layoutFrom.rx+(right.x-layoutFrom.rx)*blend;right.y=layoutFrom.ry+(right.y-layoutFrom.ry)*blend;right.scaleX=layoutFrom.rsx+(right.scaleX-layoutFrom.rsx)*blend;right.scaleY=layoutFrom.rsy+(right.scaleY-layoutFrom.rsy)*blend;if(blend>=1){layoutAt=-1;layoutFrom=null;}}
            left.alpha=right.alpha=arrival*(1-exit);center.alpha=mode=='SIM'?ease((age-(entryFirst?600:860))/160):1-exit;
            if(mode=='HERO'){
                age=now-heroAt;
                shade.alpha=age<660?ease((age-260)/260):1-ease((age-660)/280);
                fixed.alpha=1-ease((age-120)/260);
            }else{shade.alpha=entryFirst?0:1-ease((age-280)/260);fixed.alpha=1;}
        }
        private function onFrame(e:Event):void {
            if(disposed||!visible||isPaused)return;entryCues.advance();render();var now:int=simulationNow();
            var rows:Array=side=='HOME'?homeRows:awayRows;if(activeIndex>=0&&activeIndex<rows.length)SimulationPlayerRow(rows[activeIndex]).animateEmphasis(now);
            if(stamp){var p:Number=(now-stampAt)/stampDuration;stamp.scaleX=1+.16*Math.max(0,1-p*4);stamp.scaleY=stamp.scaleX*.91;stamp.alpha=runAt>=0?Math.min(1,Math.max(0,(runAt-now)/90)):Math.min(1,(1-p)*5);SimulationResultStamp(stamp).advance(p);if(p>=1||runAt>=0&&now>=runAt)clearStamp();}
            if(comboAt>=0){var c:Number=(now-comboAt)/720;comboFloat.y=panelH-85-c*25;comboFloat.alpha=Math.max(0,1-c);if(c>=1){comboFloat.text='';comboAt=-1;}}
            if(popup){var a:Number=(now-popupAt)/1250;popup.alpha=popupTitle.alpha=Math.min(1,(1-a)*5);var zoom:Number=.88+.12*ease((now-popupAt)/180);popup.scaleX=popup.scaleY=zoom;popup.x=panelW/2-(mlbActors.length?141:63)*zoom;for(var i:int=0;i<mlbActors.length;i++)MLBPlayerArtwork(mlbActors[i]).alpha=popup.alpha;if(a>=1)clearPopup();}
            if(runAt>=0){var r:Number=(now-runAt)/runDuration,team:Sprite=runSide=='HOME'?left:right;runFloat.x=team.x+169*team.scaleX;runFloat.y=team.y+(75+runIndex*29)*team.scaleY;runFloat.advance(r);runFloat.scaleX*=team.scaleX;runFloat.scaleY*=team.scaleY;if(r>=1)runAt=-1;}
        }
        private function clearStamp():void {if(stamp&&stamp.parent)stamp.parent.removeChild(stamp);stamp=null;if(stampPixels){stampPixels.dispose();stampPixels=null;}}
        private function clearPopup():void {for each(var actor:MLBPlayerArtwork in mlbActors){actor.dispose();if(actor.parent)actor.parent.removeChild(actor);}mlbActors=[];if(popup){popup.dispose();if(popup.parent)popup.parent.removeChild(popup);popup=null;}if(popupTitle&&popupTitle.parent)popupTitle.parent.removeChild(popupTitle);popupTitle=null;}
        private function clearTransient():void {entryCues.stopAll();clearStamp();clearPopup();resultSoundMs=0;comboAt=-1;runAt=-1;if(comboFloat)comboFloat.text='';if(runFloat)runFloat.clear();if(playText)playText.text='';if(diamond)diamond.reset();}
        private function releaseViews():void {
            entryCues.stopAll();resumeSimulation();if(resourceBar){resourceBar.dispose();resourceBar=null;}if(pauseButton){pauseButton.removeEventListener(MouseEvent.CLICK,togglePause);pauseButton=null;}clearTransient();if(diamond){diamond.dispose();diamond=null;}for each(var row:SimulationPlayerRow in homeRows.concat(awayRows))row.dispose();homeRows=[];awayRows=[];
            for each(var logo:Object in logos)logo.dispose();logos=[];for each(var item:Object in speedButtons)Sprite(item.view).removeEventListener(MouseEvent.CLICK,onSpeed);
        }
        private function createOpponentRoster(rival:Object):Array {return com.bh.model.MatchRosterIdentity.opponent(rival);}
        public function opponentPlayerAt(index:int):Object {return awayPlayers.length?awayPlayers[(index%awayPlayers.length+awayPlayers.length)%awayPlayers.length]:null;}
        private function ordinal(n:int):String {return n+(n%100>=11&&n%100<=13?'th':n%10==1?'st':n%10==2?'nd':n%10==3?'rd':'th');}
        public function dispose():void {if(disposed)return;disposed=true;entryCues.dispose();removeEventListener(Event.ENTER_FRAME,onFrame);releaseViews();visible=false;}
    }
}
