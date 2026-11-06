package com.bh.ui {
    import flash.display.*;import flash.events.MouseEvent;import flash.events.TimerEvent;import flash.geom.*;import flash.text.TextField;import flash.utils.Timer;import flash.utils.getTimer;
    import com.bh.visual.TeamLogoView;import com.bh.visual.HeroHead;import com.bh.visual.HomeSprite;
    /** Shared travel/arrival frame. Receives the real journey, never charges it. */
    public class JourneyChrome extends Sprite {
        private static var guardStage:Stage,guardTimer:Timer,guardUntil:int=0;
        private var hud:MatchResourceBar,status:TextField,percent:TextField,fill:Shape=new Shape(),skip:ClassicActionButton,controls:Array=[],art:Array=[];
        private var data:Object,footer:Number,last:int=-1,dead:Boolean=false;
        public function JourneyChrome(w:Number,h:Number,options:Object,forward:Function,back:Function=null) {
            name="journey-chrome";data=options;footer=h-118;hud=new MatchResourceBar(w,true);addChild(hud);
            ClassicChrome.title(label(options.title,115,59,w-260,45,30),30);label(options.transport,128,110,650,27,16,0xffe384);
            if(back!=null)button("HOME","season-travel-home",w-126,73,110,34,back,0x426f8b);
            ClassicChrome.panel(graphics,0,footer,w,116);ClassicChrome.bar(graphics,137,footer+7,w-274,33);
            if(options.hero){var hero:Object=options.hero;ClassicChrome.well(graphics,24,footer+8,78,75);
                var head:HeroHead=new HeroHead(hero.appearance||{},HomeSprite.paletteFor(hero.name,uint(hero.accent),hero.appearance||{},{})),b:Rectangle=head.getBounds(head),s:Number=Math.min(73/Math.max(1,b.width),70/Math.max(1,b.height));head.scaleX=head.scaleY=s;head.x=26+(74-b.width*s)/2-b.x*s;head.y=footer+10+(71-b.height*s)/2-b.y*s;addChild(head);art.push(head);
                label(String(hero.name),6,footer+87,122,24,12,0xffe49a,"center");
            }else logo(options.fromCity,uint(options.fromAccent),21,footer+7,80);
            logo(options.toCity,uint(options.toAccent),w-105,footer+7,80);
            status=label("",147,footer+9,w-294,30,20,0xffffff,"center");status.name="journey-status";
            label(options.detail,147,footer+43,w-294,24,12,0xd6effb,"center");
            ClassicChrome.well(graphics,150,footer+77,459,22,false,false);fill.x=154;fill.y=footer+81;ClassicChrome.fill(fill.graphics,0,0,451,14,[0xc5ff68,0x6eb32d],[0,255],10);addChild(fill);
            percent=label("",618,footer+73,127,28,14,0xffe384,"center");percent.name="journey-progress";
            skip=button("SKIP",options.arrival?"arrival-map-skip":"season-travel-skip",w-194,footer+72,178,35,forward,0x74aa30);setProgress(0);
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint=0xffffff,align:String="left"):TextField {return ClassicInventorySkin.text(this,value,x,y,w,h,size,color,align,size>=24);}
        private function logo(city:String,accent:uint,x:Number,y:Number,size:Number):void {var a:TeamLogoView=new TeamLogoView(city,accent,city.substr(0,1),size);a.x=x;a.y=y;addChild(a);art.push(a);label(city,x-14,y+80,size+28,23,11,0xffffff,"center");}
        private function button(value:String,id:String,x:Number,y:Number,w:Number,h:Number,fn:Function,color:uint):ClassicActionButton {var b:ClassicActionButton=new ClassicActionButton(value,w,h,color);b.name=id;b.x=x;b.y=y;var handler:Function=function(e:MouseEvent):void{if(!dead&&fn!=null){protectNavigation(stage);fn();}};b.addEventListener(MouseEvent.CLICK,handler);controls.push({view:b,handler:handler});addChild(b);return b;}
        // Keep a fast second click from landing on PLAY/collect in the next screen.
        // The guard outlives this panel for 350ms, without retaining the panel.
        private static function protectNavigation(target:Stage):void {clearGuard();if(!target)return;guardStage=target;guardUntil=getTimer()+350;target.addEventListener(MouseEvent.CLICK,absorbClick,true,1000,true);guardTimer=new Timer(350,1);guardTimer.addEventListener(TimerEvent.TIMER_COMPLETE,releaseGuard);guardTimer.start();}
        private static function absorbClick(e:MouseEvent):void {if(getTimer()>=guardUntil){clearGuard();return;}e.stopImmediatePropagation();e.preventDefault();}
        private static function releaseGuard(e:TimerEvent):void {clearGuard();}
        private static function clearGuard():void {if(guardStage)guardStage.removeEventListener(MouseEvent.CLICK,absorbClick,true);if(guardTimer){guardTimer.stop();guardTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,releaseGuard);}guardStage=null;guardTimer=null;}
        public function setProgress(value:Number):void {
            if(dead)return;var p:Number=Math.max(0,Math.min(1,value)),n:int=int(p*100);if(n==last)return;last=n;percent.text=n+"%";fill.scrollRect=new Rectangle(0,0,451*p,14);
            var statusValue:String=p>=1?(data.arrival?"WELCOME TO "+data.toCity:data.local?"HOME GAME · READY":"ARRIVED · READY"):data.arrival?"YOUR FIRST CLUB AWAITS":data.local?"HOME GAME · PREPARING":"TRAVELING TO "+data.toCity;
            if(status.text!=statusValue){status.text=statusValue;LineupTypography.fit(status,20,0xffffff,"center",false,12);}
            if(skip){var t:TextField=skip.getChildAt(0) as TextField,caption:String=p>=1?(data.arrival?"GO TO CLUB":"LINE UP"):"SKIP";if(t&&t.text!=caption)t.text=caption;}
        }
        public function dispose():void {if(dead)return;dead=true;for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);c.view.dispose();}controls=[];for each(var a:Object in art)a.dispose();art=[];hud.dispose();}
    }
}
