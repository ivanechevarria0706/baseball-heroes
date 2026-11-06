package com.bh.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.filters.GlowFilter;
    import flash.utils.getTimer;
    import com.bh.model.GameData;
    import com.bh.audio.AudioCueSequence;
    import com.bh.audio.OriginalAudioBank;
    import com.bh.audio.GameplayAudio;
    import com.bh.audio.AudioManager;
    import flash.media.SoundChannel;
    import com.bh.visual.CharacterPortrait;
    import com.bh.visual.TeamLogoView;
    import com.bh.visual.LeagueBadgeView;

    /** Classic result card. Presentation never awards currency or changes season state. */
    public class GameResultPanel extends Sprite {
        private var board:Sprite=new Sprite(),confetti:Sprite=new Sprite();private var scoreboard:ScoreboardPanel;
        private var summary:Object,homeCallback:Function,nextCallback:Function;
        private var controls:Array=[],views:Array=[],papers:Array=[];
        private var coins:TextField,xp:TextField,rank:TextField,rankBadge:Sprite;
        private var levelOverlay:LevelUpOverlay;
        private var batOverlay:BatExpiredOverlay;
        private var batShown:Boolean=false;private var bonusShown:Boolean=false,bonusOverlay:SpecialMatchBonus;
        private var rewardTiles:Array=[],rewardTargets:Array=[];private var rewardTip:Sprite=new Sprite(),tipTitle:TextField,tipBody:TextField;private var tipParts:Object={};
        private var clock:Function,startedAt:int=-1,paintedAt:int=-1,boardHomeX:Number=0,presentationEnd:int=6800,activeAwards:int=0,settled:Boolean=false;
        private var cues:AudioCueSequence,outcome:Sprite=new Sprite();
        private var levelShown:Boolean=false,leaving:Boolean=false,disposed:Boolean=false;
        private var scoreLayer:Sprite=new Sprite(),scoresLayer:Sprite=new Sprite(),lineStart:int=0,lineCount:int=9;
        private var screenW:Number,screenH:Number;
        public function GameResultPanel(w:Number,h:Number,data:Object,home:Function,next:Function=null,timeSource:Function=null){
            name='game-result';clock=timeSource!=null?timeSource:getTimer;screenW=w;screenH=h;summary=data;homeCallback=home;nextCallback=next;
            graphics.beginFill(0x092237,.22);graphics.drawRect(0,0,w,h);graphics.endFill();
            confetti.mouseEnabled=confetti.mouseChildren=false;addChild(confetti);addChild(board);
            var scale:Number=Math.min(w/960,h/720);board.scaleX=board.scaleY=scale;board.x=(w-960*scale)/2;boardHomeX=board.x;board.y=(h-720*scale)/2;
            drawBoard();drawScore();drawBatters();drawRewards();makeRewardTip();drawScoresDock(scale);
            drawOutcome();for each(var award:Object in rewardTiles)board.setChildIndex(award.pop,board.numChildren-1);if(summary.win)makeConfetti();
            presentationEnd=Math.max(4800,2700+activeAwards*430+1500);if(summary.win)presentationEnd=Math.max(presentationEnd,Math.ceil(OriginalAudioBank.sound("victory").length)+80);
            cues=new AudioCueSequence(clock);renderPresentation(-1);addEventListener(Event.ENTER_FRAME,onFrame);addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
        }
        private function box(x:Number,y:Number,w:Number,h:Number,color:uint,border:uint=0):void {
            var g:Graphics=board.graphics;if(border)g.lineStyle(2,border);else g.lineStyle();
            g.beginFill(color);g.drawRoundRect(x,y,w,h,10);g.endFill();g.lineStyle();
        }
        private function label(id:String,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint=0x344e5c,align:String='left'):TextField {
            var t:TextField=new TextField();t.name=id;t.defaultTextFormat=new TextFormat('Arial',size,color,true,null,null,null,null,align);t.text=value;LineupTypography.apply(t,size,color,align,size>=24);t.x=x;t.y=y;t.width=w;t.height=h;t.mouseEnabled=t.selectable=false;board.addChild(t);return t;
        }
        private function fit(t:TextField,size:int,min:int=9):void {
            var f:TextFormat=t.defaultTextFormat;while(t.textWidth>t.width-5&&size>min){f.size=--size;t.defaultTextFormat=f;t.setTextFormat(f);}
            if(t.name.indexOf('result-player-')==0&&t.textWidth>t.width-5){var value:String=t.text;while(value.length>1&&t.textWidth>t.width-5){value=value.substr(0,value.length-1);t.text=value+'...';}}
        }
        private function drawBoard():void {
            ResultPaperSkin.paper(board.graphics,224,64,512,638);
            var league:int=summary.leagueIndex!==undefined?int(summary.leagueIndex):GameData.leagueIndex;
            board.graphics.beginFill(0xf8f9f3);board.graphics.drawEllipse(423,38,114,83);board.graphics.endFill();
            var badge:LeagueBadgeView=new LeagueBadgeView(league,String(summary.league||GameData.leagueShortName()),79);badge.x=441;badge.y=37;board.addChild(badge);views.push(badge);
            var opponent:Object=summary.opponent||GameData.opponentForGame(int(summary.game));
            logo(305,163,String(summary.teamCity||GameData.teamCity),summary.teamAccent!==undefined?uint(summary.teamAccent):GameData.teamAccent,'H');
            logo(655,163,String(opponent.city),uint(opponent.accent),String(opponent.teamName).charAt(0));
            for(var i:int=0;i<2;i++){
                var x:Number=388+i*102;board.graphics.lineStyle(1,0x899193);ClassicChrome.fill(board.graphics,x,145,82,64,[0xc8c9c6,0xa2a7a6,0x646f73],[0,105,255],5);board.graphics.lineStyle();
                ResultPaperSkin.outlined(board,i==0?'final-home-score':'final-away-score',String(i==0?summary.homeScore:summary.awayScore),x+3,141,76,70,51,i==0&&summary.win?0xffc437:0xe1e5e6,0x3b4850,2);
            }
            label('score-colon',':',466,153,28,44,33,0x68777c,'center');
            label('result-title',summary.draw?'TIE':summary.win?'YOU WIN':'YOU LOSE',375,211,210,22,14,summary.win?0xa7781a:0x596a73,'center');
            var season:String=summary.competition=='POST SEASON'?'POST SEASON · '+summary.roundName+' · GAME '+summary.game:'SEASON '+(summary.season||GameData.seasonNumber)+' · GAME '+summary.game+' / 30';
            var t:TextField=label('result-season',season,248,111,464,18,10,0x68777c,'center');fit(t,10);
        }

        private function logo(cx:Number,cy:Number,city:String,color:uint,letter:String):void {var v:TeamLogoView=new TeamLogoView(city,color,letter,74);v.x=cx-37;v.y=cy-37;board.addChild(v);views.push(v);}
        private function drawScore():void {
            board.addChild(scoreLayer);scoreLayer.name='result-line-score';
            var home:Array=summary.homeLine as Array,away:Array=summary.awayLine as Array;
            lineCount=Math.max(9,home?home.length:0,away?away.length:0);lineStart=Math.max(0,lineCount-9);renderLineScore();
            if(lineCount>9){
                button('RESULT_INNINGS_PREV','<',229,259,20,function(e:MouseEvent):void{lineStart=Math.max(0,lineStart-1);renderLineScore();},0x6c8796);
                button('RESULT_INNINGS_NEXT','>',711,259,20,function(e:MouseEvent):void{lineStart=Math.min(lineCount-9,lineStart+1);renderLineScore();},0x6c8796);
            }
        }
        private function renderLineScore():void {
            while(scoreLayer.numChildren)scoreLayer.removeChildAt(0);scoreLayer.graphics.clear();
            var g:Graphics=scoreLayer.graphics,home:Array=summary.homeLine as Array,away:Array=summary.awayLine as Array;
            var opponent:Object=summary.opponent||GameData.opponentForGame(int(summary.game));
            g.lineStyle(1,0x8d9c9f);ClassicChrome.fill(g,250,251,460,29,[0xd44845,0xa32b31],[0,255],2);ClassicChrome.fill(g,250,280,460,29,[0x0f94cf,0x0364a8],[0,255],2);g.lineStyle();
            ResultPaperSkin.text(scoreLayer,'score-away-team',String(opponent.city).toUpperCase(),254,256,112,22,12,0xffffff,'left');
            ResultPaperSkin.text(scoreLayer,'score-home-team',String(summary.teamCity||GameData.teamCity).toUpperCase(),254,285,112,22,12,0xffffff,'left');
            for(var i:int=0;i<9;i++){
                var inning:int=lineStart+i,x:Number=370+i*29;
                ResultPaperSkin.text(scoreLayer,'inning-header-'+inning,String(inning+1),x,230,29,19,12,0x536470);
                g.lineStyle(1,0x81949b);ClassicChrome.fill(g,x,252,29,56,[0x5f686b,0x48555a],[0,255],0);g.lineStyle(1,0xe6f0f0,.22);g.moveTo(x,280);g.lineTo(x+29,280);g.lineStyle();
                ResultPaperSkin.text(scoreLayer,'inning-away-'+inning,cell(away,inning),x,255,29,22,14,0xffffff);
                ResultPaperSkin.text(scoreLayer,'inning-home-'+inning,cell(home,inning),x,284,29,22,14,0xffffff);
            }
            ResultPaperSkin.text(scoreLayer,'total-header','R',634,230,35,19,12,0x536470);ResultPaperSkin.text(scoreLayer,'hits-header','H',671,230,35,19,12,0x536470);
            ResultPaperSkin.text(scoreLayer,'score-away',String(summary.awayScore),634,253,35,24,16,0xffdf58);
            ResultPaperSkin.text(scoreLayer,'score-home',String(summary.homeScore),634,282,35,24,16,0xffdf58);
            ResultPaperSkin.text(scoreLayer,'score-away-hits',summary.awayHits!==undefined?String(summary.awayHits):'-',671,253,35,24,16,0xffffff);
            ResultPaperSkin.text(scoreLayer,'score-home-hits',String(summary.scoring&&summary.scoring.teamHits!==undefined?summary.scoring.teamHits:summary.hits),671,282,35,24,16,0xffffff);
        }

        private function cell(values:Array,index:int):String{return values&&index<values.length&&values[index]!==null&&values[index]!==undefined?String(values[index]):'–';}
        private function drawBatters():void {
            var rows:Array=summary.boxScore as Array;
            for(var col:int=0;col<2;col++){
                var xx:Number=251+col*231;
                for(var j:int=0;j<3;j++)label('stat-header-'+col+'-'+j,['HIT','HR','RBI'][j],xx+150+j*26,316,26,18,10,0x71838c,'center');
            }
            if(!rows||rows.length==0){
                var legacy:TextField=label('legacy-result','Individual totals were not recorded for this match.',264,368,430,48,15,0x6a7c86,'center');legacy.wordWrap=true;
                label('legacy-totals','TEAM · HIT '+summary.hits+'  HR '+summary.homeRuns+'  RBI '+summary.rbi,265,421,430,35,18,0x286788,'center');
            }else for(var i:int=0;i<Math.min(9,rows.length);i++){
                var p:Object=rows[i],x:Number=251+int(i/5)*231,y:Number=339+(i%5)*30;
                var isHero:Boolean=String(p.name)==String(summary.heroName||GameData.mainPlayer().name);
                var isMvp:Boolean=summary.scoring&&summary.scoring.mvp&&(summary.scoring.mvpSlot!==undefined?int(summary.scoring.mvpSlot)==i:isHero);
                if(isMvp){var crown:Sprite=new Sprite();crown.name='result-mvp-crown';crown.x=x-17;crown.y=y+9;crown.graphics.lineStyle(1,0x825513);crown.graphics.beginFill(0xffd135);crown.graphics.moveTo(0,0);crown.graphics.lineTo(4,3);crown.graphics.lineTo(7,-3);crown.graphics.lineTo(10,3);crown.graphics.lineTo(14,0);crown.graphics.lineTo(12,10);crown.graphics.lineTo(2,10);crown.graphics.lineTo(0,0);crown.graphics.endFill();board.addChild(crown);}
                box(x,y,226,28,isHero?0xffedb2:(i%2?0xe4e8e5:0xeef1ec));
                label('result-slot-'+i,String(i+1),x,y+3,20,24,16,0x304b59,'center');
                var portrait:CharacterPortrait=new CharacterPortrait(p,25,27,isHero);portrait.x=x+21;portrait.y=y;board.addChild(portrait);views.push(portrait);
                var n:TextField=label('result-player-'+i,String(p.name),x+48,y+4,100,21,11,isHero?0xad6618:0x3b535e);fit(n,11);
                var hit:Sprite=new Sprite();hit.name='result-player-target-'+i;hit.graphics.beginFill(0xffffff,.01);hit.graphics.drawRect(0,0,148,28);hit.graphics.endFill();hit.x=x;hit.y=y;hit.addEventListener(MouseEvent.ROLL_OVER,showRewardTip);hit.addEventListener(MouseEvent.ROLL_OUT,hideRewardTip);board.addChild(hit);rewardTargets.push(hit);tipParts[hit.name]={fullName:String(p.name),hits:p.hits,homeRuns:p.homeRuns,rbi:p.rbi};
                for(j=0;j<3;j++)label('result-'+['hits','hr','rbi'][j]+'-'+i,String(p[['hits','homeRuns','rbi'][j]]),x+150+j*26,y+4,26,23,13,0x486776,'center');
            }
            if(summary.scoring&&summary.scoring.mvp){var m:TextField=label('result-mvp-name','MVP · '+String(summary.scoring.mvpName),253,494,300,18,11,0x7d6930);fit(m,11);}
            rankBadge=new Sprite();rankBadge.x=577;rankBadge.y=457;rankBadge.rotation=-12;board.addChild(rankBadge);
            ResultPaperSkin.outlined(rankBadge,'rank-label','RANK',0,13,77,45,25,0x56bfff,0x233a4b,2);
            ResultPaperSkin.outlined(rankBadge,'result-rank',performanceRank(),73,-9,67,76,59,summary.win?0xc17dec:0x98a5ae,0x203e51,3);rankBadge.alpha=0;
        }

        private function drawRewards():void {
            var parts:Array=summary.scoring?summary.scoring.breakdown:[{id:'GAME',points:0,coins:summary.rewardCoins,xp:summary.rewardXp,active:true}];
            for(var i:int=0;i<parts.length;i++){
                var part:Object=parts[i],xx:Number=480-parts.length*92/2+i*92;
                var slot:Sprite=new Sprite();slot.name='result-award-'+part.id;slot.x=xx;slot.y=548;board.addChild(slot);
                ResultPaperSkin.reward(slot.graphics,0,0,84,65,false,String(part.id)=='BONUS');
                ResultPaperSkin.outlined(slot,'reward-title-'+part.id,part.id+(part.id=='RANK'&&summary.scoring?' '+summary.scoring.rank:''),3,14,78,23,14,0xb5bdbc,0x717e82,1);
                var lit:Sprite=new Sprite();lit.name='result-award-lit-'+part.id;slot.addChild(lit);ResultPaperSkin.reward(lit.graphics,0,0,84,65,true,String(part.id)=='BONUS');
                ResultPaperSkin.outlined(lit,'reward-earned-'+part.id,part.id+(part.id=='RANK'&&summary.scoring?' '+summary.scoring.rank:''),3,14,78,23,14,0xffe161,0x644617,1);lit.visible=false;
                var value:TextField=ResultPaperSkin.text(slot,'reward-points-'+part.id,'0',3,40,78,20,12,part.active?0x75501a:0x637274);
                var pop:Sprite=new Sprite();pop.name='result-award-pop-'+part.id;pop.mouseEnabled=pop.mouseChildren=false;board.addChild(pop);ResultPaperSkin.reward(pop.graphics,-76,-58,152,116,true,String(part.id)=='BONUS');
                ResultPaperSkin.star(pop.graphics,0,-5,41);ResultPaperSkin.outlined(pop,'award-stamp-'+part.id,String(part.id),-70,-5,140,49,30,0xfff5c5,0x322d20,2);pop.visible=false;
                rewardTiles.push({text:value,data:part,index:part.active?activeAwards++:-1,lit:lit,pop:pop,x:xx+42,y:580});
                var target:Sprite=new Sprite();target.name='reward-target-'+part.id;target.graphics.beginFill(0xffffff,.01);target.graphics.drawRect(0,0,84,65);target.graphics.endFill();target.x=xx;target.y=548;target.buttonMode=true;target.addEventListener(MouseEvent.ROLL_OVER,showRewardTip);target.addEventListener(MouseEvent.ROLL_OUT,hideRewardTip);board.addChild(target);rewardTargets.push(target);tipParts[target.name]=part;
            }
            ResultPaperSkin.icon(board,'COINS',254,526,29);
            var art:Sprite=ResultPaperSkin.outlined(board,'result-coins','+'+formatNumber(summary.rewardCoins),270,508,156,38,29,0xffdf40,0x4a4e37,2);coins=art.getChildByName('result-coins') as TextField;
            art=ResultPaperSkin.outlined(board,'result-xp','+'+formatNumber(summary.rewardXp)+' XP',427,508,150,38,27,0x91d5eb,0x456375,2);xp=art.getChildByName('result-xp') as TextField;
            label('result-record',summary.competition=='POST SEASON'?'SERIES '+summary.wins+'-'+summary.losses+' · 3 WINS REQUIRED':'RECORD '+summary.wins+'-'+summary.losses+' · STANDING #'+summary.rank,250,619,460,20,10,0x496675,'center');
            var message:String=summary.seasonComplete?(summary.promoted?'SEASON COMPLETE · PROMOTED!':'SEASON COMPLETE'):'NEXT · GAME '+(int(summary.game)+1)+' / 30';
            if(summary.competition=='POST SEASON')message=summary.draw?'TIE · Replay with no series win awarded':summary.postStatus=='champion'?'WORLD CHAMPION!':summary.postStatus=='eliminated'?'ELIMINATED · View the completed bracket':summary.seriesComplete?'SERIES WON · Advance to the next round':'NEXT · Continue the series';
            if(summary.mysteryAward){var a:Object=summary.mysteryAward;if(int(a.boxes)>0)message='MYSTERY BOX + '+a.keys+' KEY · INVENTORY > MYSTERY';else if(int(a.coins)>0)message=a.special?'SPECIAL BONUS +500 COINS INCLUDED':'RIVAL BONUS +2,000 COINS INCLUDED · +'+a.keys+' KEY';else if(int(a.keys)>0)message+=' · +'+a.keys+' KEY';}
            var note:TextField=label('result-next',message,246,684,468,16,9,0x357a96,'center');fit(note,9);
            button('RESULT_HOME','HOME',256,643,144,onHome,0x89969c);
            button('RESULT_NEXT',summary.competition=='POST SEASON'?'POST SEASON':summary.seasonComplete?'SEASON':'NEXT MATCH',412,643,292,onNext,0x6aad31);
        }
        private function drawScoresDock(scale:Number):void {
            var dock:Sprite=new Sprite();dock.name='result-scores-dock';dock.x=746;dock.y=590;board.addChild(dock);ClassicChrome.panel(dock.graphics,0,0,198,83);
            var open:UIButton=new UIButton('LEADERBOARD',186,29,0x1685b9,0x329fd0,0xbdeaff);open.name='RESULT_LEADERBOARD';open.x=6;open.y=5;open.addEventListener(MouseEvent.CLICK,openScores);dock.addChild(open);controls.push({b:open,fn:openScores});
            ResultPaperSkin.text(dock,'result-total-score','SCORE  '+formatNumber(summary.scoring?summary.scoring.total:0),8,43,182,29,18,0xffe075,'center',true);
            scoresLayer.name='result-scores-overlay';scoresLayer.visible=false;scoresLayer.graphics.beginFill(0x061e30,.6);scoresLayer.graphics.drawRect(0,0,screenW,screenH);scoresLayer.graphics.endFill();addChild(scoresLayer);
            scoreboard=new ScoreboardPanel(summary);scoreboard.scaleX=scoreboard.scaleY=scale;scoreboard.x=(screenW-314*scale)/2;scoreboard.y=(screenH-632*scale)/2;scoresLayer.addChild(scoreboard);
            var close:UIButton=new UIButton('BACK',100,30,0x61899d,0x81a9bd,0xdaeff8);close.name='RESULT_LEADERBOARD_CLOSE';close.x=scoreboard.x+321*scale;close.y=scoreboard.y+6*scale;close.scaleX=close.scaleY=scale;close.addEventListener(MouseEvent.CLICK,closeScores);scoresLayer.addChild(close);controls.push({b:close,fn:closeScores});
        }
        private function openScores(e:MouseEvent):void {e.stopPropagation();settlePresentation();if(disposed||levelOverlay||bonusOverlay||batOverlay||(summary.levelUp&&!levelShown))return;scoresLayer.visible=true;}
        private function closeScores(e:MouseEvent):void {e.stopPropagation();scoresLayer.visible=false;}
        private function countText(t:TextField,value:String):void {for(var i:int=0;i<t.parent.numChildren;i++){var d:DisplayObject=t.parent.getChildAt(i);if(d is TextField)TextField(d).text=value;}}

        private function makeRewardTip():void {
            rewardTip.name="reward-tooltip";rewardTip.mouseEnabled=rewardTip.mouseChildren=false;rewardTip.visible=false;
            rewardTip.graphics.lineStyle(2,0x72b6d7);rewardTip.graphics.beginFill(0xfffef2);rewardTip.graphics.drawRoundRect(0,0,330,88,8);rewardTip.graphics.endFill();
            tipTitle=new TextField();tipTitle.defaultTextFormat=new TextFormat("Arial",15,0x23658a,true);tipTitle.x=10;tipTitle.y=6;tipTitle.width=310;tipTitle.height=22;rewardTip.addChild(tipTitle);
            tipBody=new TextField();tipBody.defaultTextFormat=new TextFormat("Arial",12,0x344f5c);tipBody.wordWrap=true;tipBody.x=10;tipBody.y=29;tipBody.width=310;tipBody.height=56;rewardTip.addChild(tipBody);board.addChild(rewardTip);
        }
        private function showRewardTip(e:MouseEvent):void {
            var target:Sprite=e.currentTarget as Sprite,p:Object=tipParts[target.name];
            rewardTip.x=Math.max(245,Math.min(384,target.x-110));rewardTip.y=447;rewardTip.visible=true;
            if(p.fullName!==undefined){tipTitle.text='BATEADOR';tipBody.text=p.fullName+'\nHIT '+p.hits+' · HR '+p.homeRuns+' · RBI '+p.rbi;LineupTypography.apply(tipTitle,15,0x23658a,'left');LineupTypography.apply(tipBody,12,0x344f5c,'left');return;}
            tipTitle.text=String(p.id)+(p.active?" · GANADO":" · SIN GANAR");LineupTypography.apply(tipTitle,15,0x23658a,'left');
            var rule:String=p.condition?HelpText.es(String(p.condition)):"Premio guardado de una versión anterior.";
            tipBody.text=rule+"\n"+(p.potentialXp!==undefined?"Premio: "+p.potentialXp+" XP · "+formatNumber(p.potentialCoins)+" Coins":"Guardado: "+p.xp+" XP · "+formatNumber(p.coins)+" Coins");LineupTypography.apply(tipBody,12,0x344f5c,'left');HelpText.fit(tipBody,12,10);
        }
        private function hideRewardTip(e:MouseEvent):void {rewardTip.visible=false;}
        private function button(id:String,value:String,x:Number,y:Number,w:Number,fn:Function,color:uint):void {var b:UIButton=new UIButton(value,w,38,color,color,0xd7e5e8);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,fn);board.addChild(b);controls.push({b:b,fn:fn});}
        private function drawOutcome():void {
            outcome.name='result-outcome-stamp';outcome.x=480;outcome.y=130;outcome.mouseEnabled=outcome.mouseChildren=false;
            if(summary.win)ResultPaperSkin.star(outcome.graphics,0,0,91);
            ResultPaperSkin.outlined(outcome,'result-outcome',summary.draw?'TIE GAME':summary.win?'YOU WIN':'YOU LOSE',-236,-48,472,93,66,summary.win?0xffdf39:summary.draw?0xa5e4f5:0xc7d5dd,0x172a36,3);board.addChild(outcome);
        }
        private function makeConfetti():void {
            var colors:Array=[0xffcd35,0x58aeda,0xa5d84c,0xff8b26,0xb064bc];
            for(var i:int=0;i<48;i++){var s:Sprite=new Sprite();s.graphics.beginFill(colors[i%5]);s.graphics.drawRect(-5,-3,10+i%4*2,7+i%3*2);s.graphics.endFill();confetti.addChild(s);papers.push(s);}
            // The source has paper in front of the result sheet as well as behind it.
            setChildIndex(confetti,getChildIndex(board));confetti.mouseEnabled=confetti.mouseChildren=false;
        }
        private function unit(age:Number,start:Number,duration:Number):Number{return Math.max(0,Math.min(1,(age-start)/duration));}
        private function renderPresentation(age:int):void {
            paintedAt=age;var ms:int=settled?presentationEnd:age,slide:Number=unit(ms,650,420),ease:Number=1-Math.pow(1-slide,3);
            board.visible=ms>=650;board.x=boardHomeX+(1-ease)*screenW;board.alpha=1;
            var stamp:Number=unit(ms,1380,240),out:Number=unit(ms,3400,320);outcome.visible=ms>=1380&&out<1;outcome.scaleX=outcome.scaleY=1+.55*Math.pow(1-stamp,2);outcome.alpha=stamp*(1-out);outcome.rotation=-2*(1-stamp);
            var season:DisplayObject=board.getChildByName('result-season');if(season)season.visible=!outcome.visible;
            for each(var tile:Object in rewardTiles){
                var since:int=ms-2800-int(tile.index)*430,progress:Number=unit(since,230,200);tile.text.text=formatNumber(tile.index<0?0:int(Number(tile.data.points||0)*progress));tile.lit.visible=tile.index>=0&&since>=230;
                var pop:Sprite=tile.pop;pop.visible=tile.index>=0&&since>=0&&since<430;
                if(pop.visible){var q:Number=unit(since,160,270),fly:Number=q*q;pop.x=480+(Number(tile.x)-480)*fly;pop.y=485+(Number(tile.y)-485)*fly;pop.scaleX=pop.scaleY=(1.16-.16*unit(since,0,150))*(1-.45*fly);pop.alpha=1-unit(since,350,80);}
            }
            var ratio:Number=unit(ms,2700+activeAwards*430,1500);countText(coins,'+'+formatNumber(int(summary.rewardCoins*ratio)));countText(xp,'+'+formatNumber(int(summary.rewardXp*ratio))+' XP');
            var rankPop:Number=unit(ms,1050,200);rankBadge.alpha=rankPop;rankBadge.scaleX=rankBadge.scaleY=.85+.15*rankPop;
            for(var i:int=0;i<papers.length;i++){var paper:Sprite=papers[i],fall:int=ms-1640;paper.visible=fall>=0;paper.x=((i*137)%960)*screenW/960+Math.sin(fall/550+i)*23;paper.y=-90+((i*83+Math.max(0,fall)*.145)%(screenH+160));paper.rotation=i*37+fall*.075;paper.alpha=1-unit(ms,presentationEnd-600,800);}
        }
        private function onFrame(e:Event):void {
            if(disposed||!stage)return;if(startedAt<0){startedAt=int(clock());if(!summary.draw)cues.enqueue(summary.win?GameplayAudio.VICTORY:GameplayAudio.DEFEAT,0,.82);}
            var elapsed:int=Math.max(0,int(clock())-startedAt);cues.advance();renderPresentation(elapsed);
            var ready:Boolean=settled||elapsed>=presentationEnd;
            if(!bonusShown&&ready){bonusShown=true;if(summary.mysteryAward&&summary.mysteryAward.special){bonusOverlay=new SpecialMatchBonus(screenW,screenH,summary,closeBonus);addChild(bonusOverlay);}}
            if(!levelShown&&ready&&!bonusOverlay&&summary.levelUp){levelShown=true;levelOverlay=new LevelUpOverlay(screenW,screenH,summary.levelUp,closeLevelUp);addChild(levelOverlay);}
            if(!batShown&&ready&&!bonusOverlay&&!levelOverlay&&(!summary.levelUp||levelShown)){
                batShown=true;if(GameData.consumableBats.expired){batOverlay=new BatExpiredOverlay(screenW,screenH,closeBat);addChild(batOverlay);}
            }
            if(elapsed>presentationEnd+1000&&batShown)removeEventListener(Event.ENTER_FRAME,onFrame);
        }
        private function settlePresentation():void {settled=true;renderPresentation(presentationEnd);}
        private function onRemoved(e:Event):void {if(e.target===this)dispose();}
        private function performanceRank():String {if(summary.scoring)return summary.scoring.rank;var score:Number=(summary.win?1.8:0)+int(summary.hits)*.65+int(summary.homeRuns)*1.45+int(summary.rbi)*.55;return score>=7.5?'S':score>=5.2?'A':score>=3.1?'B':score>=1.3?'C':'D';}
        private function formatNumber(value:int):String{return String(value).replace(/\B(?=(\d{3})+(?!\d))/g,',');}
        private function closeBonus():void {if(bonusOverlay){bonusOverlay.dispose();removeChild(bonusOverlay);bonusOverlay=null;}}
        private function closeBat():void {if(batOverlay){batOverlay.dispose();removeChild(batOverlay);batOverlay=null;}}
        private function closeLevelUp():void {if(levelOverlay){levelOverlay.dispose();removeChild(levelOverlay);levelOverlay=null;}}
        private function onHome(e:MouseEvent):void {e.stopPropagation();settlePresentation();leave(homeCallback);}
        private function onNext(e:MouseEvent):void {e.stopPropagation();settlePresentation();leave(nextCallback!=null?nextCallback:homeCallback);}
        private function leave(callback:Function):void {if(disposed||leaving||scoresLayer.visible||(!bonusShown&&summary.mysteryAward&&summary.mysteryAward.special)||bonusOverlay||levelOverlay||batOverlay||GameData.consumableBats.expired||(summary.levelUp&&!levelShown))return;leaving=true;if(callback!=null)callback();}
        public function dispose():void {if(disposed)return;disposed=true;if(cues)cues.dispose();removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);removeEventListener(Event.ENTER_FRAME,onFrame);closeLevelUp();closeBat();closeBonus();if(scoreboard)scoreboard.dispose();for each(var target:Sprite in rewardTargets){target.removeEventListener(MouseEvent.ROLL_OVER,showRewardTip);target.removeEventListener(MouseEvent.ROLL_OUT,hideRewardTip);}rewardTargets=[];for each(var control:Object in controls){control.b.removeEventListener(MouseEvent.CLICK,control.fn);control.b.dispose();}controls=[];for each(var view:Object in views)view.dispose();views=[];papers=[];}
    }
}
