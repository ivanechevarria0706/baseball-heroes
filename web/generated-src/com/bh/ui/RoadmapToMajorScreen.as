package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;
    import com.bh.model.*;import com.bh.visual.*;
    /** Career overlay reconstructed from the supplied 14:14 roadmap sequence. */
    public class RoadmapToMajorScreen extends Sprite {
        private var w:Number,h:Number,back:Function,friends:Function,selected:int,viewStep:int=-1;
        private var background:MatchStadium,body:Sprite=new Sprite(),badgeArt:Array=[],controls:Array=[],status:TextField;
        public function RoadmapToMajorScreen(width:Number,height:Number,onBack:Function,onFriends:Function=null){
            w=width;h=height;back=onBack;friends=onFriends;name="roadmap-to-major";GameData.init();selected=GameData.leagueIndex;
            background=new MatchStadium(w,h);addChild(background);addChild(body);render();
        }
        private function text(value:String,x:Number,y:Number,width:Number,height:Number=26,size:int=15,color:uint=0xffffff,align:String="left"):TextField {
            var t:TextField=ClassicInventorySkin.text(body,value,x,y,width,height,size,color,align);t.multiline=true;t.wordWrap=true;return t;
        }
        private function button(id:String,value:String,x:Number,y:Number,width:Number,fn:Function,color:uint=0x2184b6,height:Number=32):Sprite {
            var b:Sprite=ClassicInventorySkin.button(value,width,height,color);b.x=x;b.y=y;b.name=id;body.addChild(b);
            var handler:Function=function(e:MouseEvent):void{fn();};b.addEventListener(MouseEvent.CLICK,handler);controls.push({view:b,handler:handler});return b;
        }
        private function enabled(b:Sprite,value:Boolean):void {b.mouseEnabled=b.mouseChildren=b.buttonMode=value;b.alpha=value?1:.45;}
        private function clear():void {for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}controls=[];for each(var badge:LeagueBadgeView in badgeArt)badge.dispose();badgeArt=[];while(body.numChildren)body.removeChildAt(0);body.graphics.clear();}
        private function addBadge(index:int,x:Number,y:Number,size:Number,alpha:Number=1):void {var b:LeagueBadgeView=new LeagueBadgeView(index,GameData.roadmapLeagueName(index),size);b.x=x;b.y=y;b.alpha=alpha;body.addChild(b);badgeArt.push(b);}
        private function setStatus(value:String):void {status.text=value;LineupTypography.fit(status,11,0xffe6a1,"center",false,9);}
        private function render():void {
            clear();body.graphics.beginFill(0x061526,.38);body.graphics.drawRect(0,0,w,h);body.graphics.endFill();
            ClassicInventorySkin.panel(body.graphics,163,54,634,603);ClassicChrome.bar(body.graphics,169,60,622,42);
            ClassicChrome.title(text("THE ROADMAP TO MAJOR",182,65,552,36,25,0xffffff,"center"),25);button("roadmap-close","X",742,65,40,back,0xb5403d);
            var stage:Object=GameData.roadmapCatalog()[selected],steps:Array=stage.objectives,step:int=0,past:Boolean=selected<GameData.leagueIndex,complete:Boolean=GameData.roadmapStageComplete(selected),claimed:Boolean=GameData.roadmapStageClaimed(selected);
            ClassicChrome.title(text(selected==1?"GET TO DOUBLE-A!":String(stage.title),252,111,456,28,19,0xffffff,"center"),19);
            for each(var o:Object in steps)if(past||GameData.roadmapProgressValue(String(o.type))>=int(o.target))step++;else break;
            if(viewStep<0)viewStep=Math.min(steps.length-1,step);
            text((viewStep+1)+" OF "+steps.length,389,140,182,25,18,0x8ddfff,"center");
            addBadge(selected,187,122,70);addBadge(Math.min(4,selected+1),704,122,70,.55);
            body.graphics.lineStyle(4,0x032e52);body.graphics.moveTo(276,177);body.graphics.lineTo(685,177);body.graphics.lineStyle(1,0x84c6de,.7);body.graphics.moveTo(276,175);body.graphics.lineTo(685,175);body.graphics.lineStyle();
            for(var i:int=0;i<steps.length;i++){
                var nx:Number=300+i*int(365/Math.max(1,steps.length-1)),done:Boolean=past||GameData.roadmapProgressValue(String(steps[i].type))>=int(steps[i].target);
                body.graphics.lineStyle(i==viewStep?3:1,i==viewStep?0xffdd56:0x9dcee5);body.graphics.beginFill(0x123c5d);body.graphics.drawCircle(nx,177,12);body.graphics.endFill();body.graphics.lineStyle();
                ClassicChrome.fill(body.graphics,nx-8,169,16,16,done?[0xd2ffa3,0x4a9b40]:[0x85c1dc,0x28617f],[0,255],16);
                if(done){body.graphics.lineStyle(2.5,0xffffff);body.graphics.moveTo(nx-4,177);body.graphics.lineTo(nx-1,180);body.graphics.lineTo(nx+5,173);body.graphics.lineStyle();}
                if(selected==GameData.leagueIndex&&i==Math.min(steps.length-1,step)){
                    body.graphics.beginFill(0xffd854);body.graphics.moveTo(nx,193);body.graphics.lineTo(nx-5,200);body.graphics.lineTo(nx+5,200);body.graphics.endFill();
                    text("YOU ARE HERE",nx-58,199,116,20,10,0xffe887,"center");
                }
                addStepButton(i,steps.length);
            }
            text("Requirement",196,214,530,23,14,0x9bdcf7);ClassicChrome.well(body.graphics,196,240,568,141);
            var objective:Object=steps[viewStep],progress:int=GameData.roadmapProgressValue(String(objective.type));
            text(String(objective.label),214,253,past?352:440,52,17,0x35434a);
            text(past?"COMPLETED":Math.min(int(objective.target),progress)+" / "+objective.target,past?566:663,253,past?183:86,29,past?15:19,past?0x377b37:0x963d36,"right");
            text(complete?"Requisitos completos. Recoge tu premio una sola vez.":"Pulsa cada paso para consultar su requisito.",214,308,534,23,12,0x577387);
            ClassicChrome.fill(body.graphics,201,335,558,40,[0xc5d4d3,0xf3f8ef],[0,255],5);
            var box:InventoryArtwork=new InventoryArtwork(MysteryCatalog.forLeague(selected),55,36);box.x=211;box.y=337;body.addChild(box);
            text("Reward :",276,338,95,19,11,0x577387);text("MYSTERY BOX",276,353,265,23,15,0x35434a);
            var claim:Sprite=button("roadmap-claim",claimed?"CLAIMED":"COLLECT BOX",563,340,184,claimBox,0x78aa2a);enabled(claim,complete&&!claimed);
            text("Optional",196,394,530,25,14,0x9bdcf7);ClassicChrome.well(body.graphics,196,423,568,159);
            if(selected==1){
                addBadge(2,210,435,33);text("Consigue 7 recomendaciones Double-A",253,434,395,38,15,0x35434a);text(Math.min(7,CareerAchievements.count(GameData.roadmapJourney.letters['1']))+" / 7",666,435,82,27,18,0x963d36,"right");
                var ask:Sprite=button("roadmap-ask-friends","ASK FRIENDS",548,476,196,function():void{if(friends!=null)friends();},0xe1a926,28);enabled(ask,friends!=null);
                var cup:AchievementArtwork=new AchievementArtwork("gold",33,27);cup.x=210;cup.y=509;body.addChild(cup);
                text("World champion",253,509,395,26,15,0x35434a);text((GameData.roadmapJourney.champions['1']===true?1:0)+" / 1",666,508,82,27,18,0x963d36,"right");
                ClassicChrome.fill(body.graphics,201,542,558,35,[0xc5d4d3,0xf3f8ef],[0,255],5);
                var coin:InterfaceSprite=new InterfaceSprite("coin",27,27);coin.x=211;coin.y=547;body.addChild(coin);text("Reward :  4,000",248,548,294,25,15,0x35434a);
                var bonus:Sprite=button("roadmap-optional-claim",GameData.roadmapJourney.claims['1']===true?"CLAIMED":"COLLECT",563,545,184,claimBonus,0x78aa2a);enabled(bonus,RoadmapJourney.optionalReady(GameData.roadmapJourney,1)&&GameData.roadmapJourney.claims['1']!==true);
            }else text("Aquí se guardan tus metas de carrera.\nLas opcionales están en SINGLE-A.",214,444,531,89,16,0x557185);
            enabled(button("roadmap-prev","<",197,603,47,function():void{selected=Math.max(0,selected-1);viewStep=-1;render();}),selected>0);enabled(button("roadmap-next",">",717,603,47,function():void{selected=Math.min(4,selected+1);viewStep=-1;render();}),selected<4);
            status=text(GameData.roadmapLeagueName(selected)+" · "+(GameData.roadmapStageClaimed(selected)?"REWARD CLAIMED":"Las metas opcionales no frenan el ascenso."),250,603,460,40,11,0xffe6a1,"center");status.name="roadmap-status";
        }
        private function addStepButton(index:int,count:int):void {
            var hit:Sprite=new Sprite();hit.name="roadmap-step-"+index;hit.graphics.beginFill(0xffffff,0);hit.graphics.drawCircle(0,0,17);hit.graphics.endFill();hit.x=300+index*int(365/Math.max(1,count-1));hit.y=177;hit.buttonMode=true;body.addChild(hit);
            var handler:Function=function(e:MouseEvent):void{viewStep=index;render();};hit.addEventListener(MouseEvent.CLICK,handler);controls.push({view:hit,handler:handler});
        }
        private function claimBox():void {var result:Object=GameData.roadmapClaimStage(selected);render();setStatus(result.status=="OK"?"MYSTERY BOX + "+result.keys+" KEYS":result.status=="FULL"?"Inventario lleno. Abre una caja primero.":result.status=="CLAIMED"?"Ya cobraste este premio.":"Cumple los requisitos para recoger la caja.");}
        private function claimBonus():void {var result:Object=RoadmapJourney.claimOptional(GameData.roadmapJourney,selected);if(result.status=="OK"){GameData.coins+=int(result.coins);GameData.save();}render();setStatus(result.status=="OK"?"+C 4,000":result.status=="CLAIMED"?"Ya cobraste este premio.":"Completa ambas metas opcionales.");}
        public function dispose():void {clear();background.dispose();}
    }
}
