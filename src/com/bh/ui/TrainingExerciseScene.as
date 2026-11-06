package com.bh.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.TextField;
    import flash.utils.getTimer;
    import com.bh.model.TrainingCatalog;
    import com.bh.visual.TrainingActor;
    import com.bh.visual.TrainingAtlas112;
    import com.bh.visual.TrainingCutout;
    /** Presentation only. Buying/awarding/rest clocks remain owned by GameData. */
    public class TrainingExerciseScene extends Sprite {
        [Embed(source="../../../../assets/sprites/v112/training-room.png")] private static const Room:Class;
        [Embed(source="../../../../assets/sprites/v112/coaches-atlas.png")] private static const Coaches:Class;
        private static var roomSource:BitmapData,coachSource:BitmapData;
        private var background:Bitmap,coach:Bitmap,actor:TrainingActor,continueButton:Sprite,rewardLayer:Sprite,progress:Sprite;
        private var done:Function,started:int,dead:Boolean=false,age:int=0,description:TextField;
        private var kind:String,activity:Object,reward:Object,coachBaseY:Number;
        public static const DURATION:int=4800;
        /** Reuse the existing atlas for a crisp upper-body reward portrait. */
        public static function coachPortrait(discipline:String):Bitmap {
            if(!coachSource)coachSource=Bitmap(new Coaches()).bitmapData;
            var def:Object=TrainingCatalog.discipline(discipline),r:Array=TrainingAtlas112.COACHES[int(def.coach)];
            var pixels:BitmapData=new BitmapData(r[2],r[3],true,0);
            pixels.copyPixels(coachSource,new Rectangle(r[0],r[1],r[2],r[3]),new Point());
            TrainingCutout.isolate(pixels,int(r[2]*.42),int(r[3]*.45));
            var upper:Rectangle=new Rectangle(0,0,r[2],int(r[3]*.48)),portrait:BitmapData=new BitmapData(upper.width,upper.height,true,0);
            portrait.copyPixels(pixels,upper,new Point());pixels.dispose();return new Bitmap(portrait,"auto",true);
        }
        public function TrainingExerciseScene(w:Number,h:Number,player:Object,discipline:String,session:Object,paidReward:Object,onDone:Function) {
            name="training-exercise-scene";kind=discipline;activity=session;reward=paidReward;done=onDone;started=getTimer();
            graphics.beginFill(0x153746);graphics.drawRect(0,67,w,h-67);graphics.endFill();
            if(!roomSource)roomSource=Bitmap(new Room()).bitmapData;if(!coachSource)coachSource=Bitmap(new Coaches()).bitmapData;
            background=new Bitmap(roomSource,"auto",true);background.y=68;background.width=w;background.height=h-68;addChild(background);
            var def:Object=TrainingCatalog.discipline(kind),title:String=String(def.name)+" · "+String(session.name);
            var header:Sprite=new Sprite();ClassicInventorySkin.gradient(header.graphics,90,78,780,54,0x0c79b4,0x06416c,12);addChild(header);
            ClassicInventorySkin.text(this,title,103,83,755,44,25,0xffffff,"center",true);
            var banner:Sprite=new Sprite();banner.graphics.beginFill(0x0b3654,.92);banner.graphics.drawRoundRect(90,148,780,48,10);banner.graphics.endFill();addChild(banner);
            description=ClassicInventorySkin.text(banner,"¡Vamos, tú puedes! El premio y el descanso ya están guardados.",103,160,752,32,15,0xffffff,"center",true);
            var r:Array=TrainingAtlas112.COACHES[int(def.coach)],pixels:BitmapData=new BitmapData(r[2],r[3],true,0);
            pixels.copyPixels(coachSource,new Rectangle(r[0],r[1],r[2],r[3]),new Point());TrainingCutout.isolate(pixels,int(r[2]*.42),int(r[3]*.45));
            var bounds:Rectangle=pixels.getColorBoundsRect(0xff000000,0,false),trimmed:BitmapData=new BitmapData(bounds.width,bounds.height,true,0);trimmed.copyPixels(pixels,bounds,new Point());pixels.dispose();coach=new Bitmap(trimmed,"auto",true);
            var s:Number=250/bounds.height;coach.scaleX=coach.scaleY=s;coach.x=(kind=="running"?285:677)-coach.width/2;coachBaseY=602-coach.height;coach.y=coachBaseY;addChild(coach);
            var list:Array=TrainingCatalog.activities(kind),index:int=0;for(var i:int=0;i<list.length;i++)if(list[i].id==session.id)index=i;
            actor=new TrainingActor(player,kind,index,String(session.id));actor.x=kind=="running"?605:405;actor.y=603;
            if(kind=="running")drawRunningEquipment(String(session.id));addChild(actor);
            rewardLayer=new Sprite();rewardLayer.mouseEnabled=rewardLayer.mouseChildren=false;rewardLayer.x=kind=="running"?0:-180;addChild(rewardLayer);
            ClassicInventorySkin.text(rewardLayer,"+"+session.mastery+" MASTERY",405,224,365,37,23,uint(def.color),"center",true);
            ClassicInventorySkin.text(rewardLayer,"+"+session.xp+" XP",405,259,365,44,27,0x8be9ff,"center",true);
            progress=new Sprite();progress.x=kind=="running"?397:217;progress.y=312;addChild(progress);
            ClassicInventorySkin.text(this,"El entrenador descansa después de la sesión. Puedes usar otra disciplina.",101,633,757,30,14,0xffffff,"center",true);
            continueButton=ClassicInventorySkin.button("CONTINUE",157,36,0x68aa32);continueButton.name="training-animation-continue";continueButton.x=707;continueButton.y=675;addChild(continueButton);continueButton.addEventListener(MouseEvent.CLICK,onContinue);
            addEventListener(Event.ENTER_FRAME,onFrame);render(0);
        }
        private function drawRunningEquipment(id:String):void {
            var props:Sprite=new Sprite(),g:Graphics=props.graphics;props.x=605;props.y=603;addChild(props);
            g.beginFill(0x193d28,.22);g.drawEllipse(-91,-3,182,16);g.endFill();
            if(id=="treadmill") {
                g.lineStyle(3,0x132c3a);g.beginFill(0x718b97);g.drawRoundRect(-100,-1,207,22,8);g.endFill();g.beginFill(0x263742);g.drawRect(-82,2,164,9);g.endFill();g.lineStyle(9,0x718b97);g.moveTo(89,0);g.lineTo(89,-141);g.lineTo(53,-150);g.lineStyle(3,0x162c3b);g.beginFill(0x3d6879);g.drawRoundRect(40,-165,63,27,5);g.endFill();
            }else if(id=="sliding") {
                g.lineStyle(2,0x754e2b);g.beginFill(0xd6ad73);g.drawRoundRect(-100,-1,212,12,8);g.endFill();
            }else if(id=="meters100"||id=="yards30") {
                g.lineStyle(3,0xe6f1d4,.7);g.moveTo(-118,14);g.lineTo(129,14);g.moveTo(-118,-10);g.lineTo(129,-10);
            }else {
                g.beginFill(0xbbe9f4);g.drawRoundRect(-111,-31,13,32,5);g.endFill();g.beginFill(0x3978a1);g.drawRect(-110,-35,11,6);g.endFill();
            }
        }
        private function render(ms:int):void {
            age=ms;if(ms>=3600)actor.complete();else actor.animate(ms);coach.y=coachBaseY+Math.sin(ms/450)*1.2;
            rewardLayer.alpha=Math.max(0,Math.min(1,(ms-1900)/400));rewardLayer.y=-Math.min(12,Math.max(0,ms-2200)/100);
            progress.graphics.clear();ClassicInventorySkin.gradient(progress.graphics,0,0,376,12,0x17485e,0x0c273a,12);
            var f:Number=Math.max(0,Math.min(1,ms/3600));if(f>0)ClassicInventorySkin.gradient(progress.graphics,2,2,372*f,8,0xb5edff,0x259bd1,8);
            if(ms>=3600)description.text="¡Buen trabajo! Tu entrenador está descansando. El premio no se vuelve a cobrar.";
        }
        private function onFrame(e:Event):void {if(dead)return;var elapsed:int=getTimer()-started;render(Math.min(DURATION,elapsed));if(elapsed>=DURATION)finish();}
        private function onContinue(e:MouseEvent):void {finish();}
        private function finish():void {if(dead)return;var callback:Function=done;dispose();if(callback!=null)callback();}
        public function describe():Object {return {age:age,active:!dead,discipline:kind,activity:activity.id,actor:actor?actor.describe():null,reward:reward,presentationOnly:true};}
        public function dispose():void {if(dead)return;dead=true;removeEventListener(Event.ENTER_FRAME,onFrame);continueButton.removeEventListener(MouseEvent.CLICK,onContinue);actor.dispose();background.bitmapData=null;coach.bitmapData.dispose();coach.bitmapData=null;done=null;}
    }
}
