package com.bh.ui {
    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import com.bh.model.GameData;
    import com.bh.visual.TrainingArtwork;
    import com.bh.visual.AchievementArtwork;

    /** Uses the same 640x480 local coordinates as the existing BUILD caller. */
    public class MissionCompleteOverlay extends Sprite {
        private var missionId:String,onClose:Function,mission:Object,claim:Sprite,later:Sprite,coach:Bitmap;
        private var message:TextField,dead:Boolean=false,closing:Boolean=false;
        public function MissionCompleteOverlay(id:String,closeCallback:Function) {
            name="mission-complete";missionId=id;onClose=closeCallback;mission=MissionSkin.find(id);
            graphics.beginFill(0x071828,.58);graphics.drawRect(-320,-240,640,480);graphics.endFill();
            graphics.lineStyle(3,0x334857);ClassicInventorySkin.gradient(graphics,-210,-173,420,353,0xffffff,0xd7dbda,9);graphics.lineStyle(1,0xffffff);graphics.drawRoundRect(-207,-170,414,347,7);graphics.lineStyle();
            var banner:AchievementArtwork=new AchievementArtwork("mission",325,83);banner.x=-202;banner.y=-205;addChild(banner);
            coach=TrainingArtwork.seasonCoach();coach.scaleX=coach.scaleY=Math.min(76/coach.width,90/coach.height);coach.x=119;coach.y=-164;addChild(coach);
            var title:TextField=label(mission?String(mission.title):"MISSION UNAVAILABLE",-188,-115,295,33,14,0x354c5a);title.name="mission-complete-title";
            if(mission)MissionSkin.objectives(this,mission,-188,-69,376,32,9);
            graphics.lineStyle(1.5,0x1d577b);ClassicInventorySkin.gradient(graphics,-187,48,374,65,0x158bd5,0x07528f,5);graphics.lineStyle();
            label("REWARD",-176,53,92,18,9,0xdaf3ff);if(mission)MissionSkin.rewardIcon(this,String(mission.rewardType),-17,50,1);
            var reward:TextField=label(mission?String(mission.reward):"--",-140,86,280,25,14,0xffe17b);reward.name="mission-complete-reward";
            message=label("",-185,117,370,20,9,0x405763);message.name="mission-complete-message";
            later=ClassicInventorySkin.button("LATER",113,28,0x71818a);later.name="mission-later";later.x=-163;later.y=141;later.addEventListener(MouseEvent.CLICK,close);addChild(later);
            claim=ClassicInventorySkin.button("CLAIM",205,28,0x70ad24);claim.name="mission-confirm-claim";claim.x=-32;claim.y=141;claim.addEventListener(MouseEvent.CLICK,onClaim);addChild(claim);refresh();
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):TextField {return ClassicInventorySkin.text(this,value,x,y,w,h,size,color,"center",size>=20);}
        private function refresh():void {
            var paid:Boolean=GameData.missionClaimed(missionId),ready:Boolean=mission!=null&&GameData.missionComplete(missionId);
            claim.mouseEnabled=claim.buttonMode=claim.useHandCursor=ready&&!paid;claim.alpha=claim.mouseEnabled?1:.5;
            TextField(claim.getChildAt(0)).text=paid?"RECEIVED":ready?"CLAIM":"IN PROGRESS";TextField(later.getChildAt(0)).text=paid?"CONTINUE":"LATER";
            message.text=paid?"Premio recibido y guardado.":ready?"Cobra el premio o vuelve después para recogerlo.":"Aún faltan objetivos. No se ha cobrado ningún premio.";
        }
        private function onClaim(e:MouseEvent):void {e.stopPropagation();if(dead||closing||GameData.missionClaimed(missionId)||!mission||!GameData.missionComplete(missionId))return;var answer:String=GameData.claimMission(missionId);refresh();if(answer!="OK"&&answer!="CLAIMED")message.text="No se pudo cobrar. Revisa los objetivos e inténtalo de nuevo.";}
        private function close(e:MouseEvent):void {e.stopPropagation();if(dead||closing)return;closing=true;if(onClose!=null)onClose();}
        public function dispose():void {if(dead)return;dead=true;claim.removeEventListener(MouseEvent.CLICK,onClaim);later.removeEventListener(MouseEvent.CLICK,close);coach.bitmapData.dispose();coach=null;}
    }
}
