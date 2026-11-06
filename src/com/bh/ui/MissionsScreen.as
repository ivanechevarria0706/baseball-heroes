package com.bh.ui {
    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import com.bh.model.GameData;
    import com.bh.game.HomeHero;
    import com.bh.visual.MatchStadium;
    import com.bh.visual.LeagueBadgeView;
    import com.bh.visual.TrainingArtwork;

    /** Compact mission desk based on the supplied mission recording. */
    public class MissionsScreen extends Sprite {
        private var onBack:Function,onShop:Function,backdrop:MatchStadium,hero:HomeHero,badge:LeagueBadgeView;
        private var clock:EnergyClock,coins:TextField,progress:TextField,body:Sprite=new Sprite();
        private var controls:Array=[],detailControls:Array=[],tabs:Array=[],coach:Bitmap,receipt:MissionCompleteOverlay;
        private var groups:Array=["RECORDS","HERO","TEAM","STADIUM"],group:String="HERO",selectedId:String="",dead:Boolean=false,leaving:Boolean=false;

        public function MissionsScreen(w:Number,h:Number,backCallback:Function,shopCallback:Function) {
            name="classic-missions";onBack=backCallback;onShop=shopCallback;GameData.init();
            backdrop=new MatchStadium(w,h);addChild(backdrop);
            var p:Object=GameData.mainPlayer();hero=new HomeHero(862,554,uint(p.accent),GameData.uniformNumber,String(p.name),null,null,p.appearance);addChild(hero);
            header();
            var shade:Sprite=new Sprite();shade.mouseEnabled=false;shade.graphics.beginFill(0x061d2d,.36);shade.graphics.drawRect(0,69,w,h-69);shade.graphics.endFill();addChild(shade);
            var shell:Sprite=new Sprite();shell.mouseEnabled=false;ClassicInventorySkin.panel(shell.graphics,135,116,690,502);
            ClassicChrome.bar(shell.graphics,143,122,674,33);
            ClassicInventorySkin.gradient(shell.graphics,249,159,562,450,0xf8f8f3,0xc4c7c8,7);addChild(shell);
            ClassicChrome.title(label(this,"MISSIONS",317,122,315,32,23),28);
            button(this,"X","mission-home",786,123,28,27,back,0xb54137,controls);
            for(var i:int=0;i<groups.length;i++)createTab(String(groups[i]),i);
            addChild(body);
            progress=label(this,"",151,518,86,49,11,0xdaf4ff);progress.name="mission-total";
            label(this,"Completa los objetivos y cobra el premio una sola vez.",255,623,552,34,12,0xdff5ff);
            var all:Array=GameData.missionCatalog();selectedId=String(all[0].id);group=MissionSkin.category(selectedId);render();
        }
        private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,align:String="center"):TextField {return ClassicInventorySkin.text(parent,value,x,y,w,h,size,color,align,size>=20);}
        private function number(n:int):String {return String(n).replace(/\B(?=(\d{3})+(?!\d))/g,",");}
        private function header():void {
            var chrome:Sprite=new Sprite();chrome.mouseEnabled=false;ClassicInventorySkin.gradient(chrome.graphics,0,0,960,69,0x1669a1,0x0c395b,0);ClassicInventorySkin.gradient(chrome.graphics,95,15,181,30,0x298fc6,0x07517f,27);addChild(chrome);
            badge=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),61);badge.x=9;badge.y=4;addChild(badge);
            label(this,"LV. "+GameData.level+"   XP "+number(GameData.xp),101,20,168,24,13);
            ClassicInventorySkin.icon(this,"energy",305,8);var energy:TextField=label(this,GameData.energy+" / "+GameData.maxEnergy,339,20,129,24,13);clock=new EnergyClock(energy,172);clock.x=315;clock.y=44;addChild(clock);
            ClassicInventorySkin.icon(this,"coin",510,12);coins=label(this,number(GameData.coins),544,20,164,24,14,0xffe48b);coins.name="mission-coins";
            ClassicInventorySkin.icon(this,"cash",749,12);label(this,String(GameData.cash),783,20,151,24,14);
        }
        private function button(parent:Sprite,value:String,id:String,x:Number,y:Number,w:Number,h:Number,handler:Function,color:uint,list:Array):Sprite {
            var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,handler);parent.addChild(b);list.push({view:b,handler:handler});return b;
        }
        private function createTab(id:String,index:int):void {
            var b:Sprite=new Sprite();b.name="mission-category-"+id;b.x=149;b.y=168+index*85;b.mouseChildren=false;b.buttonMode=b.useHandCursor=true;
            MissionSkin.icon(b,id,19,8);label(b,id,2,52,84,22,10,0x244258);b.addEventListener(MouseEvent.CLICK,choose);addChild(b);tabs.push({view:b,id:id});
        }
        private function choose(e:MouseEvent):void {if(dead||receipt||leaving)return;for each(var t:Object in tabs)if(t.view==e.currentTarget){group=t.id;selectedId="";render();return;}}
        private function grouped():Array {var result:Array=[];for each(var m:Object in GameData.missionCatalog())if(MissionSkin.category(String(m.id))==group)result.push(m);return result;}
        private function render():void {
            if(dead)return;clearDetails();var all:Array=GameData.missionCatalog(),list:Array=grouped(),index:int=0;
            for(var i:int=0;i<list.length;i++)if(list[i].id==selectedId)index=i;
            var mission:Object=list[index];if(!mission)return;selectedId=String(mission.id);
            for each(var t:Object in tabs){var g:Graphics=Sprite(t.view).graphics;g.clear();g.lineStyle(2,t.id==group?0xa7f4ff:0x24445d);ClassicInventorySkin.gradient(g,0,0,88,76,t.id==group?0xf1ffff:0xb7d5e5,t.id==group?0xa3d6e2:0x6fa3c3,8);g.lineStyle();}
            var claimed:int=0;for each(var m:Object in all)if(GameData.missionClaimed(String(m.id)))claimed++;
            progress.text="CLAIMED\n"+claimed+" / "+all.length;coins.text=number(GameData.coins);
            var title:TextField=label(body,String(mission.title),260,166,421,32,17,0x384a54);title.name="mission-title";
            var previous:Sprite=button(body,"<","mission-prev",691,167,29,27,prev,0x3686ad,detailControls),next:Sprite=button(body,">","mission-next",771,167,29,27,nextMission,0x3686ad,detailControls);
            enabled(previous,list.length>1);enabled(next,list.length>1);label(body,(index+1)+" / "+list.length,721,171,49,22,10,0x40515e);
            body.graphics.lineStyle(2,0x79afd0);body.graphics.beginFill(0xf9fdff);body.graphics.drawRoundRect(263,211,431,128,9);body.graphics.endFill();
            body.graphics.beginFill(0xf9fdff);body.graphics.moveTo(694,257);body.graphics.lineTo(710,270);body.graphics.lineTo(694,283);body.graphics.endFill();body.graphics.lineStyle();
            label(body,"REWARD",271,217,107,22,11,0x176b9b);MissionSkin.rewardIcon(body,String(mission.rewardType),307,245,1.6);
            var reward:TextField=label(body,String(mission.reward),270,303,112,28,11,0x2a536c);reward.name="mission-reward";
            label(body,String(mission.description),390,230,292,93,13,0x33434f,"left");
            coach=TrainingArtwork.seasonCoach();coach.scaleX=coach.scaleY=Math.min(94/coach.width,127/coach.height);coach.x=752-coach.width/2;coach.y=211;body.addChild(coach);
            MissionSkin.objectives(body,mission,264,355,535,58,13);
            var paid:Boolean=GameData.missionClaimed(selectedId),complete:Boolean=GameData.missionComplete(selectedId);
            var claim:Sprite=button(body,paid?"CLAIMED":complete?"CLAIM REWARD":"IN PROGRESS","mission-claim",421,555,212,34,claimMission,paid?0x71818a:complete?0x70ad24:0x71818a,detailControls);enabled(claim,!paid&&complete);
            if(selectedId=="stadium_growth"&&onShop!=null)button(body,"GO TO SHOP","mission-shop",651,555,146,34,shop,0xa77b27,detailControls);
            label(body,paid?"Premio recibido y guardado.":complete?"¡Objetivos completos! Tu premio está listo.":"Los objetivos se actualizan con tu progreso guardado.",269,591,527,18,9,paid?0x367d34:0x3f5a6d);
        }
        private function enabled(b:Sprite,value:Boolean):void {b.mouseEnabled=b.buttonMode=b.useHandCursor=value;b.alpha=value?1:.5;}
        private function move(delta:int):void {if(dead||receipt||leaving)return;var list:Array=grouped(),index:int=0;for(var i:int=0;i<list.length;i++)if(list[i].id==selectedId)index=i;selectedId=list[(index+delta+list.length)%list.length].id;render();}
        private function prev(e:MouseEvent):void {move(-1);}
        private function nextMission(e:MouseEvent):void {move(1);}
        private function claimMission(e:MouseEvent):void {
            if(dead||receipt||leaving||GameData.missionClaimed(selectedId)||!GameData.missionComplete(selectedId))return;
            // The overlay makes the award explicit; only its CLAIM button mutates the model.
            receipt=new MissionCompleteOverlay(selectedId,closeReceipt);receipt.x=480;receipt.y=360;receipt.scaleX=receipt.scaleY=1.5;addChild(receipt);
        }
        private function closeReceipt():void {if(!receipt)return;receipt.dispose();if(receipt.parent)receipt.parent.removeChild(receipt);receipt=null;render();}
        private function shop(e:MouseEvent):void {if(dead||receipt||leaving||onShop==null)return;leaving=true;onShop();}
        private function back(e:MouseEvent):void {if(dead||receipt||leaving||onBack==null)return;leaving=true;onBack();}
        private function clearControls(list:Array):void {for each(var c:Object in list)c.view.removeEventListener(MouseEvent.CLICK,c.handler);list.length=0;}
        private function clearDetails():void {clearControls(detailControls);if(coach){coach.bitmapData.dispose();coach=null;}while(body.numChildren)body.removeChildAt(0);body.graphics.clear();}
        public function dispose():void {if(dead)return;dead=true;if(receipt){receipt.dispose();receipt=null;}clearDetails();clearControls(controls);for each(var t:Object in tabs)t.view.removeEventListener(MouseEvent.CLICK,choose);tabs=[];clock.dispose();badge.dispose();hero.dispose();backdrop.dispose();}
    }
}
