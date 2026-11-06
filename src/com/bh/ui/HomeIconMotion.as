package com.bh.ui {
 import flash.display.*;import flash.events.MouseEvent;import flash.geom.Rectangle;import flash.geom.Matrix;import flash.text.TextField;
 /** One HOME clock; retained art, fixed hit targets and conditional reward notices. */
 public class HomeIconMotion extends Sprite {
  private var entries:Array=[],dead:Boolean=false,covered:Boolean=false,last:int=-1,progressDone:int=0,progressTotal:int=0;
  public function HomeIconMotion(){name="home-icon-motion";mouseEnabled=mouseChildren=false;}
  public function bind(view:Sprite,id:String):void {
   if(dead||["PLAY","LEAGUE","TEAM","ROADMAP","DRAFT","HERO","MISSIONS","TRAIN","HALL","COLLECT","SHOP","LINEUP","BUILD","MODES"].indexOf(id)<0)return;
   var bounds:Rectangle=view.getBounds(view),art:Sprite=new Sprite(),parts:Array=[],titles:Array=[];
   for(var i:int=0;i<view.numChildren;i++)if(!(view.getChildAt(i) is TextField))parts.push(view.getChildAt(i));else titles.push(view.getChildAt(i));
   var cx:Number=bounds.x+bounds.width/2,cy:Number=bounds.y+Math.min(bounds.height-16,58)/2;
   art.name="home-icon-art-"+id;art.x=cx;art.y=cy;art.mouseEnabled=art.mouseChildren=false;
   for each(var child:DisplayObject in parts){child.x-=cx;child.y-=cy;art.addChild(child);}view.addChildAt(art,0);
   var shine:Shape=new Shape();shine.name="home-icon-shine-"+id;var g:Graphics=shine.graphics;
   g.beginFill(0xffffff);g.moveTo(0,-6);g.lineTo(1.5,-1.5);g.lineTo(6,0);g.lineTo(1.5,1.5);g.lineTo(0,6);g.lineTo(-1.5,1.5);g.lineTo(-6,0);g.lineTo(-1.5,-1.5);g.lineTo(0,-6);g.endFill();shine.visible=false;view.addChild(shine);
   var ribbon:Sprite=new Sprite();ribbon.name="home-alert-"+id;ribbon.mouseEnabled=ribbon.mouseChildren=false;ribbon.visible=false;
   var left:Boolean=view.x<100,rw:Number=id=="HALL"?86:123;ribbon.x=id=="HALL"?view.x-3:view.x+(left?68:-123);ribbon.y=view.y+(id=="HALL"?51:16);addChild(ribbon);
   var text:TextField=ClassicInventorySkin.text(ribbon,"",7,3,rw-12,18,11,0xffffff,"center",true);text.name="home-alert-text-"+id;
   var e:Object={view:view,id:id,art:art,cx:cx,cy:cy,shine:shine,ribbon:ribbon,text:text,ribbonY:ribbon.y,rw:rw,titles:titles,style:"",progress:false,hover:false,pressed:false,mix:0,ready:false,count:0,phase:entries.length*.61};paintRibbon(e,false);
   e.over=function(event:MouseEvent):void{if(!covered)e.hover=true;};e.out=function(event:MouseEvent):void{e.hover=e.pressed=false;};e.down=function(event:MouseEvent):void{if(!covered)e.pressed=true;};e.up=function(event:MouseEvent):void{e.pressed=false;};
   view.addEventListener(MouseEvent.ROLL_OVER,e.over);view.addEventListener(MouseEvent.ROLL_OUT,e.out);view.addEventListener(MouseEvent.MOUSE_DOWN,e.down);view.addEventListener(MouseEvent.MOUSE_UP,e.up);entries.push(e);
  }
  private function paintRibbon(e:Object,progress:Boolean):void {var style:String=progress?"PROGRESS":"REWARD";if(e.style==style)return;e.style=style;var g:Graphics=e.ribbon.graphics,w:Number=e.rw,m:Matrix=new Matrix();g.clear();m.createGradientBox(w,23,Math.PI/2,0,0);g.lineStyle(1.2,progress?0x123b5c:0x653a12);g.beginGradientFill(GradientType.LINEAR,progress?[0x83dfff,0x227fba,0x12517e]:[0xffe6a4,0xc98229,0x945117],[1,1,1],[0,115,255],m);g.moveTo(9,0);g.lineTo(w-2,0);g.lineTo(w,2);g.lineTo(w,21);g.lineTo(w-2,23);g.lineTo(9,23);g.lineTo(0,11.5);g.lineTo(9,0);g.endFill();g.lineStyle(1,0xffffff,.7);g.moveTo(10,2);g.lineTo(w-4,2);g.lineStyle(1,0x062538,.45);g.moveTo(10,21);g.lineTo(w-4,21);g.lineStyle();}
  private function sync(e:Object):void {e.progress=e.id=="MISSIONS"&&!e.ready&&progressDone>0;var value:String=e.id=="HERO"?"SKILL POINTS +"+e.count:e.id=="MISSIONS"?(e.progress?progressDone+"/"+progressTotal+" COMPLETE":"CLAIM REWARD"):e.id=="HALL"?"HALL +"+e.count:"";
   if(e.text.text!=value){e.text.text=value;LineupTypography.fit(e.text,11,0xffffff,"center");}paintRibbon(e,e.progress);e.ribbon.visible=!covered&&(e.ready||e.progress)&&value!="";if(e.id=="HALL")for each(var title:TextField in e.titles)title.visible=!e.ribbon.visible;
  }
  public function notice(id:String,ready:Boolean,count:int=0):void {for each(var e:Object in entries)if(e.id==id){e.ready=ready;e.count=count;sync(e);}}
  public function missionProgress(done:int,total:int):void {progressDone=total>0&&done>0&&done<total?done:0;progressTotal=total;for each(var e:Object in entries)if(e.id=="MISSIONS")sync(e);}
  public function setCovered(value:Boolean):void {if(dead||covered==value)return;covered=value;for each(var e:Object in entries){if(value)e.hover=e.pressed=false;sync(e);e.shine.visible=false;}}
  public function advance(now:int):void {if(dead)return;var dt:Number=last<0?33:Math.max(0,Math.min(100,now-last));last=now;var smooth:Number=1-Math.exp(-dt/65);
   for each(var e:Object in entries){var target:Number=!covered&&e.hover?1:0;e.mix+=(target-e.mix)*smooth;
    var t:Number=now/1000+e.phase,p:Number=((t%4.8)+4.8)%4.8,attention:Boolean=!covered&&e.ready;
    // Labels and the clickable rectangle stay fixed. Only the sprite lifts.
    var idle:Number=attention?Math.max(0,Math.sin(p*Math.PI/.6))*(p<.6?2.2:0):0;
    if(e.id=="PLAY"&&!covered)idle+=Math.sin(t*2.4)*.65;
    e.art.y=e.cy-e.mix*2-idle+(e.pressed?2:0);e.art.scaleX=e.art.scaleY=1+e.mix*.045+(attention?.012*Math.sin(t*3):0)-(e.pressed?.055:0);
    e.art.rotation=e.id=="MISSIONS"&&!covered?Math.sin(t*5)*1.4:0;
    var glint:Boolean=!covered&&(e.hover||attention)&&p<.48;
    e.shine.visible=glint;if(glint){e.shine.x=e.cx+Math.sin(p/.48*Math.PI)*16;e.shine.y=e.cy-15;e.shine.alpha=Math.sin(p/.48*Math.PI);e.shine.scaleX=e.shine.scaleY=.5+e.shine.alpha*.65;}
    e.ribbon.y=e.ribbonY-(attention?Math.sin(t*3)*.7:0);
   }
  }
  public function dispose():void {if(dead)return;dead=true;for each(var e:Object in entries){e.view.removeEventListener(MouseEvent.ROLL_OVER,e.over);e.view.removeEventListener(MouseEvent.ROLL_OUT,e.out);e.view.removeEventListener(MouseEvent.MOUSE_DOWN,e.down);e.view.removeEventListener(MouseEvent.MOUSE_UP,e.up);e.art.x=e.cx;e.art.y=e.cy;e.art.scaleX=e.art.scaleY=1;e.art.rotation=0;e.shine.visible=e.ribbon.visible=false;for each(var title:TextField in e.titles)title.visible=true;}entries=[];}
 }
}
