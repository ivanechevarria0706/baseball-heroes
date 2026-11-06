package com.bh.ui {
    import flash.display.*;
    import flash.geom.Matrix;
    import flash.events.Event;
    import flash.utils.getTimer;
    import com.bh.visual.BatterHead086;
    import com.bh.visual.HomeSprite;
    import flash.text.*;
    import flash.filters.GlowFilter;
    import com.bh.model.Player;
    import com.bh.model.GameData;
    import com.bh.visual.CharacterPortrait;
    import com.bh.visual.TeamLogoView;
    import com.bh.visual.LeagueBadgeView;

    /** Batting HUD for the classic match frame, using live remake data. */
    public class Hud extends Sprite {
        private var screenW:Number,screenH:Number;
        private var player:Player;
        private var resourceBar:MatchResourceBar;
        private var playerNameText:TextField,statLine:TextField,activeSkillText:TextField,nextBatterText:TextField;
        private var resultText:TextField,pitchLabel:TextField;
        private var homeScoreText:TextField,awayScoreText:TextField,homeNameText:TextField,awayNameText:TextField,inningText:TextField;
        private var ballDots:Array=[],strikeDots:Array=[],outDots:Array=[],baseTiles:Array=[],runnerMarkers:Array=[];
        private var avgText:TextField,hrText:TextField,rbiText:TextField,hitText:TextField,comboValueText:TextField;
        private var seasonHrText:TextField,seasonRbiText:TextField,leaderScoreText:TextField;
        private var hitHistoryText:TextField,heroHitHistory:Array=[],historyBack:Shape=new Shape();
        private var heroPortrait:Sprite,leagueBadge:LeagueBadgeView,homeTeamLogo:TeamLogoView,awayTeamLogo:TeamLogoView;
        private var diamond:MatchMiniDiamond,skillValues:Array=[],inningArrow:Shape=new Shape();
        private var portraitName:String='';
        private var comboRing:Sprite=new Sprite();private var momentum:Object={charge:0,max:10,tier:0};private var liveCoins:int=0,liveXP:int=0;
        private var lastCombo:int=-1;
        private var livePoints:int=0;
        private var matchHits:int=0,matchHomeRuns:int=0,matchRbi:int=0,matchHeroHits:int=0,matchHeroRbi:int=0;
        private var cinematicMask:Shape;

        public function Hud(w:Number,h:Number,p:Player) {
            screenW=w;screenH=h;player=p;GameData.init();mouseEnabled=false;mouseChildren=false;
            drawTop();drawBottom();
            pitchLabel=text('',13,0xffffff,330,23,w/2-165,h*.775,'pitch-label');outline(pitchLabel);
            resultText=text('',21,0xffffff,340,34,w*.60-170,h*.70,'timing-detail');outline(resultText);
            refresh(p);setBases(false,false,false);
        }
        private function text(value:String,size:int,color:uint,w:Number,h:Number,px:Number,py:Number,id:String='',align:String='center'):TextField {
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat('Arial',size,color,true,null,null,null,null,align);
            t.text=value;t.width=w;t.height=h;t.x=px;t.y=py;t.name=id;t.selectable=false;t.mouseEnabled=false;
            addChild(t);return t;
        }
        private function outline(t:TextField):void {t.filters=[new GlowFilter(0x142c39,.95,3,3,5)];}
        private function panel(px:Number,py:Number,w:Number,h:Number,color:uint,border:uint,r:Number=5):void {
            if(color==0xc9cdc4||color==0x929f96)MatchChrome.paper(graphics,px,py,w,h);else MatchChrome.score(graphics,px,py,w,h);
        }
        private function capsule(px:Number,py:Number,w:Number,h:Number,top:uint,bottom:uint):void {
            var m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI/2,px,py);
            graphics.lineStyle(2,0xb1dbe2);graphics.beginGradientFill(GradientType.LINEAR,[top,bottom,0x153744],[1,1,1],[0,95,255],m);
            graphics.drawRoundRect(px,py,w,h,h,h);graphics.endFill();graphics.lineStyle();
        }
        private function drawTop():void {
            resourceBar=new MatchResourceBar(screenW);addChild(resourceBar);
            drawScoreboard();drawMiniDiamond(screenW-184,49);
        }
        private function drawScoreboard():void {
            var cx:Number=screenW/2;
            panel(cx-106,54,67,42,0x24414b,0x79b7c5,3);panel(cx+40,54,67,42,0x24414b,0x79b7c5,3);
            homeScoreText=text('0',35,0xffae26,63,43,cx-104,51,'home-score');outline(homeScoreText);
            awayScoreText=text('0',35,0xdde6e8,63,43,cx+42,51,'away-score');outline(awayScoreText);
            LineupTypography.apply(homeScoreText,35,0xffae26,TextFormatAlign.CENTER,true);LineupTypography.apply(awayScoreText,35,0xdde6e8,TextFormatAlign.CENTER,true);
            homeScoreText.filters=awayScoreText.filters=[new GlowFilter(0x0e232e,1,3,3,8)];
            panel(cx-30,54,62,15,0x335e6b,0x83bac5,2);
            inningText=text('1ST',10,0xffffff,47,16,cx-16,53,'inning');
            inningArrow.x=cx-21;inningArrow.y=62;addChild(inningArrow);setHalfInning(false);
            baseTiles.push(baseTile(cx+15,87,'base-first'),baseTile(cx,75,'base-second'),baseTile(cx-15,87,'base-third'));
            graphics.beginFill(0x1c4654,.85);graphics.drawRect(cx-106,102,214,19);graphics.endFill();
            text('B',11,0xd7e5e9,16,17,cx-101,102);createDots(ballDots,cx-80,111,3,'balls');
            text('S',11,0xd7e5e9,16,17,cx-21,102);createDots(strikeDots,cx,111,2,'strikes');
            text('O',11,0xd7e5e9,16,17,cx+43,102);createDots(outDots,cx+67,111,2,'outs');
            var rival:Object=GameData.currentOpponent();
            homeTeamLogo=new TeamLogoView(GameData.teamCity,GameData.teamAccent,'H',61);homeTeamLogo.x=cx-190;homeTeamLogo.y=50;addChild(homeTeamLogo);
            awayTeamLogo=new TeamLogoView(String(rival.city),uint(rival.accent),String(rival.teamName).substr(0,1),61);awayTeamLogo.x=cx+128;awayTeamLogo.y=50;addChild(awayTeamLogo);
            homeNameText=text(GameData.teamName,8,0xffffff,102,14,cx-211,110,'home-name');outline(homeNameText);fit(homeNameText,8,6);
            awayNameText=text(String(rival.teamName),8,0xffffff,102,14,cx+108,110,'away-name');outline(awayNameText);fit(awayNameText,8,6);
            text(GameData.seasonWins+'W '+GameData.seasonLosses+'L',9,0xffd778,96,15,cx-208,122);
        }
        private function baseTile(px:Number,py:Number,id:String):Sprite {
            var s:Sprite=new Sprite();s.x=px;s.y=py;s.name=id;addChild(s);return s;
        }
        private function paintBase(s:Sprite,occupied:Boolean):void {
            s.graphics.clear();s.graphics.lineStyle(1.5,0xb0d3d9);s.graphics.beginFill(occupied?0xffc352:0x315b65);
            s.graphics.moveTo(0,-7);s.graphics.lineTo(8,0);s.graphics.lineTo(0,7);s.graphics.lineTo(-8,0);s.graphics.lineTo(0,-7);s.graphics.endFill();
        }
        private function drawMiniDiamond(px:Number,py:Number):void {
            diamond=new MatchMiniDiamond(GameData.teamAccent);diamond.x=px;diamond.y=py;diamond.name="match-minimap";addChild(diamond);
        }
        public function setHalfInning(top:Boolean):void {var g:Graphics=inningArrow.graphics;g.clear();g.beginFill(0xffd85e);g.moveTo(-6,top?3:-3);g.lineTo(6,top?3:-3);g.lineTo(0,top?-4:4);g.endFill();}
        public function setPitchProgress(value:Number):void {diamond.pitch(value);}
        public function animatePlay(before:Array,after:Array,batter:Object,bases:int):void {diamond.play(before,after,batter,bases);}
        public function showBallInPlay(result:String):void {diamond.ballInPlay(result);}
        public function resetPlay():void {diamond.reset();}
        private function runner(px:Number,py:Number,id:String):Sprite {
            var s:Sprite=new Sprite();s.name=id;s.x=px;s.y=py;s.graphics.lineStyle(1.4,0x213c46);s.graphics.beginFill(0xf4cea2);s.graphics.drawCircle(0,0,7);s.graphics.endFill();
            s.graphics.beginFill(GameData.teamAccent);s.graphics.drawRoundRect(-8,-8,16,8,6,6);s.graphics.drawRect(-8,-3,18,3);s.graphics.endFill();s.graphics.lineStyle();s.graphics.beginFill(0xffffff);s.graphics.drawRoundRect(-6,6,12,6,3,3);s.graphics.endFill();addChild(s);return s;
        }
        private function createDots(arr:Array,px:Number,py:Number,count:int,id:String):void {
            for(var i:int=0;i<count;i++){var s:Sprite=new Sprite();s.x=px+i*19;s.y=py;s.name=id+'-'+i;arr.push(s);addChild(s);}paintDots(arr,0,0xffcc52);
        }
        private function paintDots(arr:Array,value:int,color:uint):void {
            for(var i:int=0;i<arr.length;i++){var g:Graphics=Sprite(arr[i]).graphics;g.clear();g.lineStyle(1.2,0x17363c);g.beginFill(i<value?color:0x234b53);g.drawEllipse(-6,-5,12,10);g.endFill();if(i<value){g.lineStyle();g.beginFill(0xffffff,.4);g.drawEllipse(-3,-3,5,2);g.endFill();}}
        }
        private function drawBottom():void {
            var y:Number=screenH-52;
            panel(128,y,448,50,0x555954,0xe8eeeb,5);
            panel(579,y,216,50,0xc9cdc4,0xf3f5ef,5);
            panel(800,y,screenW-803,50,0x145180,0xb4d7e8,7);
            graphics.beginFill(0x859591);graphics.drawRect(130,y+1,444,3);graphics.endFill();
            // Name sits above the skill bar, leaving room for larger stat values.
            playerNameText=text('',12,0xffffff,252,20,146,y-24,'batter-name','left');outline(playerNameText);
            text('SKILL',9,0xf1f2e9,48,15,144,y+4,'','left');
            statLine=text('',13,0xe6eee7,235,22,144,y+18,'skill-values','left');statLine.visible=false;
            for(var skill:int=0;skill<3;skill++){
                var sx:Number=145+skill*78,c:uint=uint([0x47b6dd,0xed5375,0x76d32e][skill]);
                graphics.lineStyle(1,0x203c45);ClassicChrome.fill(graphics,sx,y+22,19,16,[ClassicChrome.blend(c,0xffffff,.5),c,ClassicChrome.blend(c,0x173143,.2)],[0,100,255],5);graphics.lineStyle();
                text(['C','P','L'][skill],10,0xffffff,19,17,sx,y+22);
                skillValues.push(text('',16,0xffffff,54,23,sx+21,y+17,'skill-'+skill,'left'));
            }
            activeSkillText=text('',7,0xc8d7d7,234,13,145,y+38,'active-skill','left');
            for(var i:int=0;i<4;i++){
                graphics.lineStyle(1,0x9daba5,.65);graphics.moveTo(383+i*47,y+5);graphics.lineTo(383+i*47,y+45);graphics.lineStyle();
                text(['AVG','HR','RBI','HIT'][i],9,0xcddbd8,47,15,384+i*47,y+4);
            }
            avgText=text('.000',14,0xffffff,47,22,384,y+20,'avg');hrText=text('0',14,0xffffff,47,22,431,y+20,'hr');rbiText=text('0',14,0xffffff,47,22,478,y+20,'rbi');hitText=text('0',14,0xffffff,47,22,525,y+20,'hits');
            text('Season\nGoal!',12,0x344c4c,69,37,582,y+5).multiline=true;
            panel(653,y+6,65,38,0x929f96,0x52645e,3);panel(723,y+6,66,38,0x929f96,0x52645e,3);
            text(GameData.goalLabel(),10,0x4b6864,63,15,654,y+6);text('RBI',10,0x4b6864,63,15,725,y+6);
            seasonHrText=text('',12,0x8f681a,63,20,654,y+21,'season-hr');seasonRbiText=text('',12,0x8f681a,63,20,725,y+21,'season-rbi');
            capsule(804,y+3,screenW-811,19,0x65b4d6,0x145687);text('LEADERBOARD',10,0xffffff,screenW-813,17,805,y+3);
            leaderScoreText=text('',12,0xffffff,screenW-813,23,805,y+26,'leader-score');
            nextBatterText=text('',9,0xffffff,157,29,screenW-161,y-35,'next-batter');nextBatterText.multiline=true;nextBatterText.wordWrap=true;outline(nextBatterText);
            graphics.lineStyle(2,0xd4e9ec);graphics.beginFill(0x284653);graphics.drawCircle(40,y+21,32);graphics.endFill();graphics.lineStyle();
            comboRing.x=40;comboRing.y=y+21;addChild(comboRing);
            comboValueText=text('',8,0xffffff,53,31,14,y+7,'combo');comboValueText.multiline=true;
            historyBack.x=screenW-194;historyBack.y=screenH-218;addChild(historyBack);
            hitHistoryText=text('',10,0xffffff,179,112,screenW-194,screenH-218,'hit-history','left');hitHistoryText.multiline=true;outline(hitHistoryText);
        }
        private function fit(t:TextField,normal:int,minimum:int):void {
            var f:TextFormat=t.defaultTextFormat;f.size=normal;t.setTextFormat(f);
            for(var size:int=normal-1;(t.textWidth>t.width-5||t.textHeight>t.height-2)&&size>=minimum;size--){f.size=size;t.setTextFormat(f);}
            if((t.name=='home-name'||t.name=='away-name'||t.name=='batter-name'||t.name=='next-batter')&&(t.textWidth>t.width-5||t.textHeight>t.height-2)){
                var full:String=t.text;
                while(full.length>1&&(t.textWidth>t.width-5||t.textHeight>t.height-2)){full=full.substr(0,full.length-1);t.text=full+'…';t.setTextFormat(f);}
            }
        }
        private function refreshPortrait(data:Object):void {
            var name:String=data?String(data.name):player.name;if(name==portraitName&&heroPortrait)return;
            if(heroPortrait){Object(heroPortrait).dispose();removeChild(heroPortrait);}
            if(data&&String(data.name)==String(GameData.mainPlayer().name)){
                var appearance:Object=data.appearance||GameData.heroAppearance();
                var face:BatterHead086=new BatterHead086(appearance,HomeSprite.paletteFor(name,uint(data.accent),appearance),"",false);
                face.scaleX=face.scaleY=.46;face.x=105;face.y=screenH-3;heroPortrait=face;
            }else{heroPortrait=new CharacterPortrait(data?data:GameData.mainPlayer(),62,54,true);heroPortrait.x=73;heroPortrait.y=screenH-54;}
            heroPortrait.name='batter-portrait';addChild(heroPortrait);portraitName=name;
        }
        private function refreshCombo():void {
            var value:int=int(momentum.charge);comboValueText.text=value>=10?'MAX\nCOMBO':'COMBO\n'+value+'/10';if(value==lastCombo)return;lastCombo=value;
            var g:Graphics=comboRing.graphics;g.clear();g.lineStyle(6,0x516d76);g.drawCircle(0,0,26);
            // Dynamic match charge; the separate lineup card bonus stays in GameData.
            g.lineStyle(6,value>=10?0xff9b2e:0x48caff,1,false,'normal','round');var end:Number=Math.min(1,value/10)*Math.PI*2;
            g.moveTo(0,26);for(var a:Number=0;a<=end;a+=.06)g.lineTo(Math.sin(a)*26,Math.cos(a)*26);
            g.lineStyle(2,0xc5eaff);g.drawCircle(0,0,21);g.lineStyle();
        }
        public function refresh(p:Player):void {
            player=p;resourceBar.refresh(liveCoins,liveXP);playerNameText.text=p.name;fit(playerNameText,11,8);
            var data:Object=GameData.playerByName(p.name);var luck:int=data?GameData.effectiveLuck(data):0;
            var skills:Array=[data?GameData.effectiveContact(data):p.contact,data?GameData.effectivePower(data):p.power,luck];for(var si:int=0;si<3;si++){TextField(skillValues[si]).text=String(skills[si]);fit(skillValues[si],16,11);}
            refreshPortrait(data);refreshCombo();refreshSeason();
        }
        private function refreshSeason():void {
            seasonHrText.text=(GameData.goalCurrent()+(GameData.seasonGoalType=='HIT'?matchHeroHits:matchHomeRuns))+'/'+GameData.goalTarget();seasonRbiText.text=(GameData.rbiCurrent()+(GameData.seasonGoalType=='HIT'?matchHeroRbi:matchRbi))+'/'+GameData.seasonGoalRbi;
            leaderScoreText.text='SCORE  '+formatNumber(livePoints);
            fit(seasonHrText,12,9);fit(seasonRbiText,12,9);fit(leaderScoreText,12,8);
        }
        public function setMomentum(value:Object):void {momentum=value;refreshCombo();}
        public function setLiveRewards(c:int,x:int,committed:Boolean=false):void {liveCoins=committed?0:c;liveXP=committed?0:x;}
        public function setLiveScore(value:int,earned:int=0,multiplier:int=1):void {livePoints=value;refreshSeason();if(earned>0)leaderScoreText.text="+"+formatNumber(earned)+(multiplier>1?" ×"+multiplier:"")+"  ·  "+formatNumber(value);}
        public function setMatchProgress(hits:int,homeRuns:int,rbi:int,committed:Boolean=false,heroHits:int=0,heroRbi:int=0):void {
            // Season totals are committed at GAME OVER. Display the live match before that,
            // then stop adding it so the final refresh cannot count the same result twice.
            matchHeroHits=committed?0:Math.max(0,heroHits);matchHeroRbi=committed?0:Math.max(0,heroRbi);matchHits=committed?0:Math.max(0,hits);matchHomeRuns=committed?0:Math.max(0,homeRuns);matchRbi=committed?0:Math.max(0,rbi);refreshSeason();
        }
        public function setCinematic(value:Boolean,showFooter:Boolean=true):void {
            if(value){
                if(!cinematicMask){cinematicMask=new Shape();addChild(cinematicMask);}
                cinematicMask.graphics.clear();cinematicMask.graphics.beginFill(0xffffff);
                cinematicMask.graphics.drawRect(0,0,screenW,44);cinematicMask.graphics.endFill();
                cinematicMask.graphics.beginFill(0xffffff);cinematicMask.graphics.drawRect(0,44,80,28);cinematicMask.graphics.drawRect(screenW-180,44,180,150);cinematicMask.graphics.endFill();
                if(showFooter){cinematicMask.graphics.beginFill(0xffffff);cinematicMask.graphics.drawRect(0,screenH-87,screenW,87);cinematicMask.graphics.endFill();}
            }
            mask=value?cinematicMask:null;
            if(cinematicMask)cinematicMask.visible=value;
        }
        public function setGameState(homeScore:int,awayScore:int,inning:int,balls:int,strikes:int,outs:int,attempts:int):void {
            homeScoreText.text=String(homeScore);awayScoreText.text=String(awayScore);fit(homeScoreText,35,21);fit(awayScoreText,35,21);
            inningText.text=ordinal(inning);paintDots(ballDots,balls,0x6ed2ee);paintDots(strikeDots,strikes,0xffc75d);paintDots(outDots,outs,0xff776d);
        }
        public function setBases(first:Boolean,second:Boolean,third:Boolean):void {
            var occupied:Array=[first,second,third];for(var i:int=0;i<3;i++)paintBase(baseTiles[i],occupied[i]);diamond.setBases(occupied);
        }
        public function setOpponentName(name:String):void {awayNameText.text=name.toUpperCase();fit(awayNameText,8,6);}
        public function setBatterContext(spot:int,nextName:String):void {nextBatterText.text='#'+spot+' NEXT\n'+nextName.toUpperCase();fit(nextBatterText,9,7);}
        public function setBatterCareer(data:Object,gameHits:int):void {
            if(!data)return;avgText.text=String(data.avg);hrText.text=String(data.hr);rbiText.text=String(data.rbi);hitText.text=String(gameHits);
            fit(avgText,14,10);fit(hrText,14,10);fit(rbiText,14,10);fit(hitText,14,10);refreshSeason();
        }
        public function setPitchLabel(value:String):void {pitchLabel.text=value;fit(pitchLabel,13,10);}
        public function setActiveSkill(label:String):void {activeSkillText.text=label;fit(activeSkillText,7,6);}
        public function setResult(value:String):void {
            resultText.text=value.indexOf('\n')>=0?value.substr(value.indexOf('\n')+1):'';
            resultText.textColor=value.indexOf('NICE')>=0||value.indexOf('GOOD')>=0?0x68dff7:(value.indexOf('FOUL')>=0?0xffd75e:0xff4f5c);
        }
        public function addHeroHitHistory(hitType:String,rbi:int):void {
            var label:String=hitType;if(hitType=='SINGLE')label='ONE BASE HIT';else if(hitType=='DOUBLE')label='TWO BASE HIT';else if(hitType=='TRIPLE')label='THREE BASE HIT';else if(hitType=='HOME RUN'&&rbi>=4)label='GRAND SLAM';
            heroHitHistory.unshift({label:label,bonus:rbi>0?' +'+rbi:''});while(heroHitHistory.length>7)heroHitHistory.pop();refreshHistory();
        }
        public function clearHeroHitHistory():void {heroHitHistory=[];refreshHistory();}
        private function refreshHistory():void {var lines:Array=[],g:Graphics=historyBack.graphics;g.clear();for(var i:int=0;i<heroHitHistory.length;i++){lines.push((heroHitHistory.length-i)+'  '+heroHitHistory[i].label+heroHitHistory[i].bonus);g.beginFill(0x163442,.72);g.drawRoundRect(0,i*15,179,14,3);g.endFill();}hitHistoryText.text=lines.join('\n');var f:TextFormat=hitHistoryText.defaultTextFormat;f.leading=0;hitHistoryText.setTextFormat(f);}
        private function ordinal(n:int):String {var last:int=n%10;return n+(n%100>=11&&n%100<=13?'TH':last==1?'ST':last==2?'ND':last==3?'RD':'TH');}
        private function formatNumber(n:int):String {var s:String=String(n),out:String='';while(s.length>3){out=','+s.substr(s.length-3)+out;s=s.substr(0,s.length-3);}return s+out;}
        public function dispose():void {
            if(resourceBar)resourceBar.dispose();if(diamond)diamond.dispose();if(heroPortrait){Object(heroPortrait).dispose();heroPortrait=null;}if(leagueBadge){leagueBadge.dispose();leagueBadge=null;}
            if(homeTeamLogo){homeTeamLogo.dispose();homeTeamLogo=null;}if(awayTeamLogo){awayTeamLogo.dispose();awayTeamLogo=null;}
        }
    }
}
