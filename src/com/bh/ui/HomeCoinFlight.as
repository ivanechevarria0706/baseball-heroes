package com.bh.ui {
 import flash.display.*;import flash.events.Event;import flash.utils.getTimer;
 import com.bh.visual.InterfaceSprite;
 /** Visual receipt only. Money is committed by the caller before any flight starts. */
 public class HomeCoinFlight extends Sprite {
  private var coins:Array=[],clock:Function,dead:Boolean=false,listening:Boolean=false;
  public function HomeCoinFlight(timeSource:Function=null){name="home-coin-flight";mouseEnabled=mouseChildren=false;clock=timeSource!=null?timeSource:getTimer;
   for(var i:int=0;i<24;i++){var coin:InterfaceSprite=new InterfaceSprite("coin",23,23);coin.visible=false;addChild(coin);coins.push({view:coin,at:-1,sx:0,sy:0,delay:0});}
  }
  public function send(px:Number,py:Number,count:int=3):void {
   if(dead)return;var now:Number=Number(clock()),n:int=0;
   for each(var c:Object in coins)if(c.at<0&&n<count){c.at=now;c.sx=px-11;c.sy=py-11;c.delay=n*75;c.view.x=c.sx;c.view.y=c.sy;c.view.scaleX=c.view.scaleY=1;c.view.alpha=1;c.view.visible=false;n++;}
   if(n&&!listening){listening=true;addEventListener(Event.ENTER_FRAME,tick);}
  }
  private function tick(e:Event):void {if(dead)return;var now:Number=Number(clock()),active:Boolean=false;
   for each(var c:Object in coins)if(c.at>=0){var p:Number=(now-c.at-c.delay)/850;if(p>=1){c.view.visible=false;c.at=-1;continue;}active=true;if(p<0)continue;
    c.view.visible=true;var q:Number=p*p*(3-2*p);c.view.x=c.sx+(564-c.sx)*q;c.view.y=c.sy+(9-c.sy)*q-Math.sin(p*Math.PI)*64;
    c.view.scaleX=(.55+.45*Math.abs(Math.cos(p*Math.PI*4)))*(1-p*.30);c.view.scaleY=1-p*.30;c.view.alpha=p<.88?1:(1-p)/.12;
   }
   if(!active){removeEventListener(Event.ENTER_FRAME,tick);listening=false;}
  }
  public function dispose():void {if(dead)return;dead=true;removeEventListener(Event.ENTER_FRAME,tick);for each(var c:Object in coins)c.view.visible=false;coins=[];listening=false;}
 }
}
