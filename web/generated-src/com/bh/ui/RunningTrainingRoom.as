package com.bh.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.getTimer;
    import com.bh.model.GameData;
    import com.bh.model.TrainingCatalog;
    import com.bh.visual.TrainingArtwork;
    import com.bh.visual.CharacterPortrait;
    import com.bh.visual.LeagueBadgeView;

    public class RunningTrainingRoom extends Sprite {
        private var w:Number,h:Number,player:Object,back:Function;
        private var room:Bitmap,coach:Bitmap,badge:LeagueBadgeView;
        private var panel:Sprite,controls:Array=[],startButtons:Array=[],activityArt:Array=[];
        private var portraits:Array=[],coins:TextField,xp:TextField,level:TextField,energy:TextField;
        private var remaining:TextField,mastery:TextField,message:TextField;
        private var stations:Array=[],discipline:String="running";
        private var bar:Sprite,legacy:AttributeTrainingScreen,nextTick:int=0;
        private var lastReady:Boolean;
        private var exercise:TrainingExerciseScene;
        private var stars:MasteryStars,rewardOverlay:TrainingMasteryOverlay,disposing:Boolean=false;
        public function RunningTrainingRoom(width:Number,height:Number,p:Object,onBack:Function) {
            w=width;h=height;player=p;back=onBack;name="training-room";GameData.init();
            room=TrainingArtwork.image();room.width=w;room.height=624;room.y=68;addChild(room);
            graphics.beginFill(0x183444);graphics.drawRect(0,0,w,h);graphics.endFill();
            drawHud();
            label(this,"TRAINING",104,80,290,35,24);
            drawStations();
            label(this,"Cada entrenador tiene su propio descanso. El premio se recibe al empezar.",100,203,758,36,14,0xffffff,"center");
            button(this,"attributes-open","ATTRIBUTES",691,505,173,36,openAttributes,0x315d77);
            var rail:Sprite=new Sprite();addChild(rail);ClassicInventorySkin.panel(rail.graphics,91,550,779,157);
            label(this,"YOUR TEAM · "+String(player.name),108,558,724,22,13,0xffe4a0);
            var order:Array=GameData.battingOrderPlayers();
            for(var i:int=0;i<7&&i<order.length;i++) {
                var portrait:CharacterPortrait=new CharacterPortrait(order[i],74,74,true);
                portrait.x=110+i*104;portrait.y=586;addChild(portrait);portraits.push(portrait);
                label(this,String(order[i].name),103+i*104,665,92,21,11,0xffffff,"center");
            }
            button(this,"training-back","BACK",753,15,141,36,back,0x315d77);
            refreshHud();addEventListener(Event.ENTER_FRAME,onFrame);showPendingReward();
        }
        private function label(parent:Sprite,text:String,x:Number,y:Number,width:Number,height:Number,size:int=14,color:uint=0xffffff,align:String="left"):TextField {
            return ClassicInventorySkin.text(parent,text,x,y,width,height,size,color,align,true);
        }
        private function button(parent:Sprite,id:String,text:String,x:Number,y:Number,width:Number,height:Number,action:Function,color:uint=0xe1a926):Sprite {
            var b:Sprite=ClassicInventorySkin.button(text,width,height,color);b.x=x;b.y=y;b.name=id;
            var handler:Function=function(e:MouseEvent):void{action();};b.addEventListener(MouseEvent.CLICK,handler);
            parent.addChild(b);controls.push({view:b,handler:handler,owner:parent});return b;
        }
        private function drawHud():void {
            graphics.beginFill(0x113d55,.94);graphics.drawRect(0,0,w,67);graphics.endFill();
            badge=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),59);badge.x=28;badge.y=3;addChild(badge);
            ClassicInventorySkin.gradient(graphics,111,15,208,33,0x2379a8,0x103c59,32);
            level=label(this,"",117,18,54,28,18);xp=label(this,"",174,22,137,23,13,0xc7e8f3);
            ClassicInventorySkin.icon(this,"energy",342,15,.9);energy=label(this,String(GameData.energy),380,20,88,25,18,0xa6e965);
            ClassicInventorySkin.icon(this,"coin",473,18,1);coins=label(this,"",509,21,184,24,17,0xffdc77);
        }
        private function refreshHud():void {
            coins.text=String(GameData.coins);xp.text=String(GameData.xp)+" XP";level.text="LV "+GameData.level;energy.text=String(GameData.energy);
            for each(var station:Object in stations) {
                var time:Number=GameData.trainingRemaining(station.id),info:Object=GameData.trainingInfo(station.id);
                station.timer.text=(info.master?"MASTER":"STEP "+info.step)+" · "+(time>0?clock(time):"READY");
                station.board.visible=time>0;station.boardTime.text=clock(time);
                station.progress.graphics.clear();
                ClassicInventorySkin.gradient(station.progress.graphics,0,0,220,12,0x143348,0x0b2230,12);
                var fill:Number=Number(info.progress)/Number(info.target);
                if(fill>0)ClassicInventorySkin.gradient(station.progress.graphics,2,2,216*fill,8,0xc2f5ff,uint(station.color),8);
            }
        }
        private function drawStations():void {
            var defs:Array=TrainingCatalog.disciplines();
            for(var i:int=0;i<defs.length;i++) {
                var a:Object=defs[i],x:Number=100+i*257;
                label(this,a.name,x,119,235,27,18,uint(a.color));
                var timer:TextField=label(this,"",x,148,238,24,13,0xffe69d);timer.name=a.id+"-room-timer";
                var progress:Sprite=new Sprite();progress.x=x;progress.y=178;addChild(progress);
                button(this,a.id+"-open",a.name,36+i*197,505,184,36,disciplineAction(a.id),uint(a.color));
                var board:Sprite=new Sprite();board.x=42+i*197;board.y=347;addChild(board);
                board.graphics.lineStyle(3,0x79522d);board.graphics.beginFill(0xe9ce8d);board.graphics.drawRoundRect(0,0,146,149,5);board.graphics.endFill();board.graphics.lineStyle();
                label(board,a.name,4,11,138,24,14,0x5a4029,"center");label(board,"ON\nBREAK",8,39,130,62,23,0x46301c,"center");
                var boardTime:TextField=label(board,"",4,102,138,24,17,0x46301c,"center");
                button(board,a.id+"-break-open","VIEW",25,126,96,22,disciplineAction(a.id),uint(a.color));
                stations.push({id:a.id,color:a.color,timer:timer,progress:progress,board:board,boardTime:boardTime});
            }
        }
        private function disciplineAction(id:String):Function {
            return function():void {openActivities(id);};
        }
        private function openActivities(id:String="running"):void {
            if(panel||legacy||exercise||rewardOverlay)return;
            discipline=id;var def:Object=TrainingCatalog.discipline(id);if(!def)return;
            panel=new Sprite();panel.name=id+"-activities";addChild(panel);
            panel.graphics.beginFill(0x031421,.62);panel.graphics.drawRect(0,67,w,h-67);panel.graphics.endFill();
            ClassicInventorySkin.panel(panel.graphics,84,76,792,563);
            ClassicInventorySkin.gradient(panel.graphics,90,82,780,43,0x1085bd,0x05659e,11);
            label(panel,def.name,281,84,403,44,27,0xffffff,"center");
            button(panel,"running-close","×",817,86,46,34,closeActivities,0xaf3d3e);
            for(var group:int=0;group<3;group++)label(panel,["Beginner","Expert","Pro"][group],119+group*107,134,107,23,12,0x8bdfff,"center");
            bar=new Sprite();panel.addChild(bar);
            mastery=label(panel,"",119,184,320,22,11,0xffffff,"center");mastery.name=id+"-mastery";
            label(panel,id=="running"?"Repítelo: ¡yo puedo hacerlo!":id=="stretching"?"¡Con calma! Cada sesión mejora tu flexibilidad.":"¡Un esfuerzo más! Sigue entrenando.",469,145,300,47,15,0xffffff);
            coach=TrainingArtwork.coachFor(id);coach.x=782;coach.y=136;coach.width=62;coach.height=73;panel.addChild(coach);
            var activities:Array=TrainingCatalog.activities(id);
            for(var i:int=0;i<activities.length;i++)drawActivity(activities[i],i);
            remaining=label(panel,"",116,210,718,24,14,0xffe69b);remaining.name=id+"-remaining";
            message=label(panel,"Recibes el premio al empezar. Después, el entrenador descansa.",113,602,734,31,13,0xf1f0cf,"center");message.name="running-status";
            refreshPanel();
        }
        private function drawActivity(a:Object,index:int):void {
            var x:Number=112+(index%3)*246,y:Number=243+int(index/3)*177,card:Sprite=new Sprite();panel.addChild(card);
            card.graphics.lineStyle(2,0x718998);ClassicInventorySkin.gradient(card.graphics,x,y,235,168,0xffffff,0xb9c8d0,10);card.graphics.lineStyle();
            ClassicInventorySkin.gradient(card.graphics,x+6,y+30,223,49,0x0677b5,0x2abddb,1);
            label(card,a.name,x+6,y+4,223,25,15,0x243846,"center");
            var picture:Bitmap=TrainingArtwork.activity(index,discipline);picture.x=x+6;picture.y=y+30;picture.width=223;picture.height=49;card.addChild(picture);activityArt.push(picture);
            label(card,a.hours+(int(a.hours)==1?" Hr":" Hrs"),x+12,y+83,62,24,14,0x31768b);
            var b:Sprite=button(panel,discipline+"-start-"+a.id,"START  ▶",x+104,y+82,118,25,activityAction(String(a.id)));
            startButtons.push({view:b,activity:a});
            label(card,"Cost",x+13,y+113,57,22,12,0x566672);
            label(card,"C "+a.cost,x+82,y+110,131,24,15,0x785a16);
            label(card,"Rewards",x+13,y+141,59,22,11,0x566672);
            label(card,String(a.mastery)+" M   "+a.xp+" XP",x+78,y+137,151,27,13,0x146888);
        }
        private function activityAction(id:String):Function {
            return function():void {
                var reward:Object=GameData.startDisciplineTraining(discipline,id);
                refreshHud();refreshPanel();
                message.text=reward.ok?"+"+reward.mastery+" Mastery · +"+reward.xp+" XP"+
                    (reward.skillPoints>0?" · +"+reward.skillPoints+" SKILL POINTS":"")+
                    (reward.levelUp?" · LV "+GameData.level:""):String(reward.error);
                if(reward.ok){
                    var session:Object=null;for each(var a:Object in TrainingCatalog.activities(discipline))if(a.id==id)session=a;
                    closeActivities();exercise=new TrainingExerciseScene(w,h,player,discipline,session,reward,closeExercise);addChild(exercise);
                }
            };
        }
        private function closeExercise():void {if(!exercise)return;exercise.dispose();if(exercise.parent==this)removeChild(exercise);exercise=null;refreshHud();if(!disposing)showPendingReward();}
        private function showPendingReward():void {
            if(disposing||exercise||rewardOverlay||legacy||panel)return;
            for each(var d:Object in TrainingCatalog.disciplines()) {
                var reward:Object=GameData.trainingPendingReward(d.id);
                if(!reward)continue;
                var id:String=d.id,receipt:String=reward.receipt;
                rewardOverlay=new TrainingMasteryOverlay(w,h,id,reward,function():void {
                    GameData.acknowledgeTrainingReward(id,receipt);
                    rewardOverlay.dispose();removeChild(rewardOverlay);rewardOverlay=null;refreshHud();showPendingReward();
                });addChild(rewardOverlay);break;
            }
        }
        private function refreshPanel():void {
            if(!panel)return;
            var info:Object=GameData.trainingInfo(discipline),progress:int=info.progress;
            mastery.text=(info.master?"MASTER · ":"")+progress+" / "+info.target;
            if(stars&&stars.parent==panel)panel.removeChild(stars);
            stars=new MasteryStars(info.stars,320);stars.x=119;stars.y=158;panel.addChild(stars);
            bar.graphics.clear();ClassicInventorySkin.gradient(bar.graphics,119,190,320,12,0x16486b,0x1f5781,12);
            if(progress>0)ClassicInventorySkin.gradient(bar.graphics,121,192,316*progress/info.target,8,0xa0edff,0x25b5e9,8);
            var time:Number=GameData.trainingRemaining(discipline);lastReady=time<=0;
            remaining.text=time>0?"ON BREAK  "+clock(time):masteryTip();
            for each(var b:Object in startButtons){var can:Boolean=time<=0&&GameData.coins>=int(b.activity.cost);b.view.alpha=can?1:.45;b.view.mouseEnabled=time<=0;b.view.mouseChildren=false;b.view.buttonMode=time<=0;}
        }
        private function clock(ms:Number):String {
            var total:int=Math.ceil(ms/1000),hours:int=int(total/3600),minutes:int=int(total/60)%60,seconds:int=total%60;
            return (hours<10?"0":"")+hours+":"+(minutes<10?"0":"")+minutes+":"+(seconds<10?"0":"")+seconds;
        }
        private function closeActivities():void {
            if(!panel)return;
            releaseControls(panel);
            if(coach){coach.bitmapData.dispose();coach=null;}
            for each(var picture:Bitmap in activityArt)picture.bitmapData.dispose();activityArt=[];
            removeChild(panel);panel=null;startButtons=[];bar=null;refreshHud();
        }
        private function openAttributes():void {
            if(rewardOverlay)return;closeActivities();if(legacy||exercise)return;
            legacy=new AttributeTrainingScreen(w,h,player,function():void{legacy.dispose();removeChild(legacy);legacy=null;refreshHud();});addChild(legacy);
        }
        private function onFrame(e:Event):void {
            if(getTimer()<nextTick)return;nextTick=getTimer()+1000;refreshHud();
            if(panel){var time:Number=GameData.trainingRemaining(discipline);remaining.text=time>0?"ON BREAK  "+clock(time):masteryTip();if(lastReady!=(time<=0))refreshPanel();}
        }
        private function masteryTip():String {return GameData.trainingInfo(discipline).master?"Al llenar esta barra de MASTER, recibes 5 ENERGY.":"Próxima estrella: tu héroe gana 2 SKILL POINTS.";}
        private function releaseControls(owner:Sprite=null):void {
            for(var i:int=controls.length-1;i>=0;i--)if(owner==null||controls[i].owner==owner){controls[i].view.removeEventListener(MouseEvent.CLICK,controls[i].handler);controls.splice(i,1);}
        }
        public function dispose():void {
            disposing=true;removeEventListener(Event.ENTER_FRAME,onFrame);closeExercise();closeActivities();releaseControls();
            if(rewardOverlay){rewardOverlay.dispose();removeChild(rewardOverlay);rewardOverlay=null;}
            if(legacy){legacy.dispose();legacy=null;}
            for each(var portrait:CharacterPortrait in portraits)portrait.dispose();portraits=[];
            if(badge)badge.dispose();if(room){room.bitmapData.dispose();room=null;}
        }
    }
}
