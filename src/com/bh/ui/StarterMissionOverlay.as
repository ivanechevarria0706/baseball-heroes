package com.bh.ui {
    import flash.display.Sprite;import flash.events.MouseEvent;import flash.text.*;
    /** Shows the already credited reward; both buttons only acknowledge it. */
    public class StarterMissionOverlay extends Sprite {
        private var controls:Array=[],alive:Boolean=true;
        public function StarterMissionOverlay(close:Function){
            name="starter-mission-complete";graphics.beginFill(0x031626,.6);graphics.drawRect(0,0,960,720);graphics.endFill();
            ClassicChrome.well(graphics,264,179,432,354);ClassicChrome.bar(graphics,274,190,412,53);
            label("MISIÓN COMPLETA",283,201,394,38,27,0xffffff);label("SIGUE LO BÁSICO",290,263,380,38,25,0x2b749e);
            ClassicInventorySkin.icon(this,"coin",438,315,1.75);label("40,000",307,365,347,53,40,0xc89225);
            label("Premio recibido. ¡Ya estás listo para tu temporada!",293,420,375,44,14,0x385465);
            for(var i:int=0;i<2;i++){var button:UIButton=new UIButton(i==0?"SKIP":"CONTINUE",i==0?132:209,36,i==0?0x91a4ad:0x7fba32,0xa2d6b2,0xe9fbde,16);button.name=i==0?"starter-reward-skip":"starter-reward-continue";button.x=i==0?293:438;button.y=479;var fn:Function=function(e:MouseEvent):void{if(alive){e.stopImmediatePropagation();close();}};button.addEventListener(MouseEvent.CLICK,fn);addChild(button);controls.push({view:button,fn:fn});}
        }
        private function label(s:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):void{var t:TextField=new TextField();var f:TextFormat=new TextFormat("Arial",size,color,true);f.align="center";t.defaultTextFormat=f;t.text=s;t.x=x;t.y=y;t.width=w;t.height=h;t.multiline=t.wordWrap=true;t.mouseEnabled=false;addChild(t);}
        public function dispose():void{alive=false;for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.fn);c.view.dispose();}controls=[];}
    }
}
