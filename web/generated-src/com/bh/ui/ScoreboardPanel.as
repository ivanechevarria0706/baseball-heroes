package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.utils.*;import flash.text.*;
 import com.bh.online.OnlineClient;import com.bh.model.GameData;
 /** Server-clocked weekly best and all-time best among accepted friends. */
 public class ScoreboardPanel extends Sprite {
  private var api:OnlineClient=new OnlineClient(),state:Object,summary:Object,rows:Sprite=new Sprite(),controls:Array=[],tab:String="weekly",tierPage:int=0,alive:Boolean=true;
  private var status:TextField,countdown:TextField,stamp:int=0,timer:Timer=new Timer(1000);
  public function ScoreboardPanel(data:Object){summary=data;name="scoreboard-panel";graphics.lineStyle(3,0xb9e4f5);graphics.beginFill(0x17689c);graphics.drawRoundRect(0,0,314,632,10);graphics.endFill();ClassicInventorySkin.text(this,"LEADERBOARD",12,10,290,30,25,0xffffff,"center");countdown=ClassicInventorySkin.text(this,"",10,43,294,22,12,0xc7f1ff,"center");addChild(rows);rows.y=76;status=ClassicInventorySkin.text(this,"Connecting…",10,608,294,20,10,0xeaf4f7,"center");status.wordWrap=true;timer.addEventListener(TimerEvent.TIMER,tick);timer.start();load();}
  private function load():void {if(api.busy)return;status.text="Saving score…";var fixture:String=summary.fixtureKey?String(summary.fixtureKey):"";api.request(fixture?"POST":"GET","/scores",fixture?{fixture:fixture,requestId:OnlineClient.requestId()}:null,loaded,failed);}
  private function loaded(value:Object):void {if(!alive)return;state=value;stamp=getTimer();GameData.applyScoreRewards(int(value.rewardTotal));status.text="Tus puntos y los de tus amigos";render();tick();}
  private function failed(message:String,code:int):void {if(!alive)return;status.text="Offline · "+message;state=null;render();}
  private function text(value:String,y:Number,size:int=14,c:uint=0xffffff):TextField {return ClassicInventorySkin.text(rows,value,10,y,294,25,size,c,"center");}
  private function button(value:String,x:Number,y:Number,w:Number,fn:Function,id:String):void {var b:UIButton=new UIButton(value,w,28,0x247eaf,0x309bcb,0xa7d7ea);b.name=id;b.x=x;b.y=y;rows.addChild(b);b.addEventListener(MouseEvent.CLICK,fn);controls.push({b:b,fn:fn});}
  private function clear():void {for each(var c:Object in controls){c.b.removeEventListener(MouseEvent.CLICK,c.fn);c.b.dispose();}controls=[];while(rows.numChildren)rows.removeChildAt(0);rows.graphics.clear();}
  private function render():void {clear();button(tab=="weekly"?"• WEEKLY":"WEEKLY",8,0,145,function(e:MouseEvent):void{tab="weekly";render();},"SCORES_WEEKLY");button(tab=="allTime"?"• ALL TIME":"ALL TIME",161,0,145,function(e:MouseEvent):void{tab="allTime";render();},"SCORES_ALLTIME");
   if(state){var entries:Array=state.entries.concat();entries.sortOn(tab,Array.NUMERIC|Array.DESCENDING);for(var i:int=0;i<Math.min(6,entries.length);i++){var row:Object=entries[i];rows.graphics.beginFill(i%2?0x125786:0x1f75a5);rows.graphics.drawRoundRect(10,39+i*36,294,32,4);rows.graphics.endFill();var name:TextField=ClassicInventorySkin.text(rows,(i+1)+". "+row.name,17,43+i*36,184,24,13,row.id==api.user.id?0xffe267:0xffffff,"left");name.text=name.text.substr(0,23);ClassicInventorySkin.text(rows,number(row[tab]),200,43+i*36,97,24,13,0xffe267,"right");}
    text("MY BEST  "+number(state.best),268,19,0xffe267);text("SCORE  "+number(summary.scoring?summary.scoring.total:0),297,17);text("WEEKLY REWARDS",331,14,0xc4eafa);
    for(i=tierPage*6;i<Math.min(state.tiers.length,(tierPage+1)*6);i++){var t:Object=state.tiers[i],y:Number=361+(i-tierPage*6)*28;ClassicInventorySkin.text(rows,number(t.target)+"  ·  C +"+number(t.coins),13,y,202,25,11,0xffffff,"left");if(t.eligible)claimButton(t.target,y);else ClassicInventorySkin.text(rows,t.claimed?"CLAIMED":"LOCKED",222,y,80,24,11,t.claimed?0xb5e963:0x8dc0d5,"center");}
    if(tierPage>0)button("<",10,328,45,function(e:MouseEvent):void{tierPage--;render();},"SCORES_REWARDS_PREV");
    if((tierPage+1)*6<state.tiers.length)button(">",259,328,45,function(e:MouseEvent):void{tierPage++;render();},"SCORES_REWARDS_NEXT");
   }else{text("MY BEST  "+number(GameData.scoreHistory.best),96,20,0xffe267);text("SCORE  "+number(summary.scoring?summary.scoring.total:0),139,19);text("Ranking waiting for a connection",204,13);button("RETRY",59,261,196,function(e:MouseEvent):void{load();},"SCORES_RETRY");}
  }
  private function claimButton(target:int,y:Number):void {button("CLAIM",221,y,82,function(e:MouseEvent):void{e.stopPropagation();if(api.busy)return;status.text="Collecting reward…";api.request("POST","/scores/claim",{target:target,requestId:OnlineClient.requestId()},loaded,failed);},"SCORES_CLAIM_"+target);}
  private function tick(e:TimerEvent=null):void {if(state&&int(state.remaining)-(getTimer()-stamp)/1000<=0&&!api.busy){api.request("GET","/scores",null,loaded,failed);}
   countdown.text=state?"ENDS IN  "+clock(Math.max(0,int(state.remaining)-(getTimer()-stamp)/1000)):"WEEKLY / ALL TIME";}
  private function clock(s:int):String {var d:int=s/86400,h:int=(s%86400)/3600,m:int=(s%3600)/60;return d+"d "+h+"h "+m+"m";}
  private function number(v:int):String{return String(v).replace(/\B(?=(\d{3})+(?!\d))/g,",");}
  public function dispose():void {alive=false;api.dispose();timer.stop();timer.removeEventListener(TimerEvent.TIMER,tick);clear();}
 }
}
