package com.bh.ui {
    import flash.display.*;
    import flash.events.MouseEvent;
    import com.bh.model.TrainingCatalog;
    public class TrainingMasteryOverlay extends Sprite {
        private var coach:Bitmap,done:Function,button:Sprite;
        public function TrainingMasteryOverlay(width:Number,height:Number,id:String,reward:Object,onDone:Function) {
            name="training-mastery-reward";done=onDone;
            graphics.beginFill(0x031421,.7);graphics.drawRect(0,0,width,height);graphics.endFill();
            ClassicInventorySkin.gradient(graphics,169,117,622,478,0xffffff,0xcbd5da,18);
            graphics.lineStyle(3,0xffffff);graphics.drawRoundRect(169,117,622,478,18);graphics.lineStyle();
            text(TrainingCatalog.discipline(id).name,223,124,514,53,37,0x936011,"center");
            text("MASTERY",416,169,309,42,29,0x0d7ca9,"center");
            for(var i:int=0;i<3;i++)text(["Beginner","Expert","Pro"][i],204+i*121,217,121,23,15,0x217c9e,"center");
            var stars:MasteryStars=new MasteryStars(reward.masteryResult.stars,363);stars.x=204;stars.y=246;addChild(stars);
            coach=TrainingExerciseScene.coachPortrait(id);
            var scale:Number=Math.min(142/coach.width,169/coach.height);coach.scaleX=coach.scaleY=scale;
            coach.x=609+(142-coach.width)/2;coach.y=211+(169-coach.height)/2;addChild(coach);
            ClassicInventorySkin.gradient(graphics,199,288,390,92,0xffffff,0xe4f4ff,10);
            var energy:int=int(reward.energy),points:int=int(reward.skillPoints);
            text(energy>0?"¡Felicidades! Has completado otra barra de MASTER. Sigue entrenando.":
                "¡Felicidades! Has ganado una estrella de Mastery. Sigue avanzando así.",210,299,367,70,17,0x334b5c,"center");
            text("REWARDS",206,391,526,25,15,0x506674);
            ClassicInventorySkin.gradient(graphics,206,423,548,83,0x158fc8,0x075a9b,7);
            text((points>0?points+" SKILL POINTS":"")+(points>0&&energy>0?"  +  ":"")+(energy>0?energy+" ENERGY":""),221,439,518,47,28,0xffffff,"center");
            text("Premio añadido a tu cuenta. El entrenador conserva su descanso.",194,516,572,27,13,0x40586a,"center");
            button=ClassicInventorySkin.button("CONTINUE",260,35,0x71ae25);button.name="mastery-continue";button.x=350;button.y=551;addChild(button);
            button.addEventListener(MouseEvent.CLICK,finish);
        }
        private function text(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String="left"):void {
            ClassicInventorySkin.text(this,value,x,y,w,h,size,color,align,true);
        }
        private function finish(e:MouseEvent):void {if(done!=null)done();}
        public function dispose():void {button.removeEventListener(MouseEvent.CLICK,finish);done=null;if(coach){coach.bitmapData.dispose();coach=null;}}
    }
}
