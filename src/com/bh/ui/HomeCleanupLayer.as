package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.TextField;import flash.utils.getTimer;import flash.filters.GlowFilter;import com.bh.model.*;import com.bh.visual.HomeSceneArtwork;
 /** Six existing HOME props become reusable pickup targets; the saved model owns rewards. */
 public class HomeCleanupLayer extends Sprite {
  private var props:Array=[],bursts:Array=[],clock:Function,reward:Function,dead:Boolean=false,nextCheck:Number=0;
  private var coins:HomeCoinFlight;
  public function HomeCleanupLayer(onReward:Function,timeSource:Function=null){name="home-cleanup-layer";reward=onReward;clock=timeSource!=null?timeSource:function():Number{return new Date().time;};mouseEnabled=false;
   for each(var item:Object in StadiumCleanup.items()){var view:Sprite=new Sprite(),padX:Number=Math.max(0,(44-item.w)/2),padY:Number=Math.max(0,(44-item.h)/2);view.name="cleanup-"+item.id;view.x=item.x-padX;view.y=item.y-padY;view.mouseChildren=false;view.buttonMode=view.useHandCursor=true;view.graphics.beginFill(0xffffff,.01);view.graphics.drawRect(0,0,Math.max(44,item.w),Math.max(44,item.h));view.graphics.endFill();
    var art:HomeSceneArtwork=new HomeSceneArtwork(item.id,item.w,item.h);art.x=padX;art.y=padY;view.addChild(art);addChild(view);view.addEventListener(MouseEvent.CLICK,pick);props.push({id:item.id,view:view,art:art});
    var label:TextField=ClassicInventorySkin.text(this,"+20 COINS",item.x-30,item.y-15,120,28,15,0xffdf63,"center",true);label.name="cleanup-reward-"+item.id;label.filters=[new GlowFilter(0x15342a,1,3,3,6)];label.visible=false;bursts.push({id:item.id,view:label,y:label.y,at:-1});
   }coins=new HomeCoinFlight(clock);addChild(coins);refresh();addEventListener(Event.ENTER_FRAME,tick);
  }
  private function refresh():void {var now:Number=Number(clock());for each(var p:Object in props)p.view.visible=StadiumCleanup.ready(GameData.homeCleanup,p.id,now);nextCheck=now+500;}
  private function pick(e:MouseEvent):void {if(dead)return;e.stopPropagation();var id:String=String(e.currentTarget.name).substr(8),amount:int=GameData.collectHomeItem(id,Number(clock()));if(amount<=0){refresh();return;}refresh();for each(var b:Object in bursts)if(b.id==id){b.at=Number(clock());b.view.visible=true;b.view.alpha=1;}for each(var p:Object in props)if(p.id==id)coins.send(p.view.x+p.view.width/2,p.view.y+p.view.height/2);if(reward!=null)reward(amount);}
  private function tick(e:Event):void {if(dead)return;var now:Number=Number(clock());if(now>=nextCheck)refresh();for each(var b:Object in bursts)if(b.at>=0){var p:Number=(now-b.at)/800;b.view.y=b.y-26*p;b.view.alpha=Math.max(0,1-p);if(p>=1){b.view.visible=false;b.at=-1;}}}
  public function dispose():void {if(dead)return;dead=true;removeEventListener(Event.ENTER_FRAME,tick);coins.dispose();for each(var p:Object in props){p.view.removeEventListener(MouseEvent.CLICK,pick);p.art.dispose();}props=[];bursts=[];reward=null;}
 }
}
