package com.bh.game {
    import flash.display.*;import flash.events.Event;import flash.text.*;import flash.utils.getTimer;
    import com.bh.visual.HomeSprite;import com.bh.visual.HeroSprite;
    /** Shared illustrated front view; origin at the feet, preview never saves gear. */
    public class HomeHero extends Sprite {
        private var art:HeroSprite,jersey:TextField=new TextField(),clock:Function,started:int,pleasedUntil:int=-1,alive:Boolean=true;
        public function HomeHero(px:Number,py:Number,accent:uint,number:int,playerName:String,timeSource:Function=null,equipmentPreview:Object=null,appearance:Object=null,showHeadwear:Boolean=false){
            x=px;y=py;name='home-hero';mouseEnabled=mouseChildren=false;clock=timeSource!=null?timeSource:getTimer;started=int(clock());
            var palette:Object=HomeSprite.paletteFor(playerName,accent,appearance,equipmentPreview);
            graphics.beginFill(0x273125,.22);graphics.drawEllipse(-47,-3,95,12);graphics.endFill();
            art=new HeroSprite(playerName,accent,appearance,'home',.74,equipmentPreview,showHeadwear);art.name='home-illustration';art.warmAll();addChild(art);
            jersey.defaultTextFormat=new TextFormat('Arial',11,palette.uniform,true);jersey.text=String(number);jersey.x=3;jersey.y=-79;jersey.width=23;jersey.height=18;jersey.mouseEnabled=jersey.selectable=false;addChild(jersey);
            addEventListener(Event.ENTER_FRAME,onFrame);
        }
        public function get frameIndex():int{return art.frameIndex;}
        public function celebrate():void{if(alive)pleasedUntil=int(clock())+900;}
        private function onFrame(e:Event):void {
            if(!alive)return;var now:int=int(clock()),elapsed:int=now-started,phase:int=elapsed%6200;
            art.setFrame(now<pleasedUntil?3:elapsed>=700&&elapsed<1250?2:phase>=3900&&phase<4050?1:0);
        }
        public function dispose():void{if(!alive)return;alive=false;removeEventListener(Event.ENTER_FRAME,onFrame);art.dispose();}
    }
}
