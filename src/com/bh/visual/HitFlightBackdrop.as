package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.getTimer;import com.bh.model.GameData;
 /** The equipped ballpark's skyline with a retained outfield floor, free of the batting mound/plate. */
 public class HitFlightBackdrop extends Sprite {
  private var w:Number,h:Number,camera:Sprite=new Sprite(),stadium:MatchStadium,stadiumMask:Shape=new Shape(),lawn:Shape=new Shape(),rays:Shape=new Shape(),shadow:Shape=new Shape();
  private var groundTop:Number,mode:String="HIDDEN",lastProgress:Number=0,dead:Boolean=false;
  private var clock:Function,fieldAt:int=0,fieldFromX:Number,fieldFromY:Number;
  public function HitFlightBackdrop(width:Number,height:Number,timeSource:Function=null) {
   clock=timeSource!=null?timeSource:getTimer;
   name="hit-flight-backdrop";w=width;h=height;mouseEnabled=mouseChildren=false;addChild(camera);
   groundTop=h*.98;var field:uint=GameData.stadiumAccent("field",0x278745),g:Graphics=lawn.graphics,m:Matrix=new Matrix();m.createGradientBox(w*2,h*2,Math.PI/2,0,groundTop);
   g.beginGradientFill(GradientType.LINEAR,[mix(field,0x073020,.34),field,mix(field,0x77b94c,.20)],[1,1,1],[0,125,255],m);g.drawRect(0,groundTop,w*2,h*2);g.endFill();
   for(var row:int=0;row<18;row++){var y:Number=groundTop+20+Math.pow(row,1.45)*15,band:Number=8+row*3;g.beginFill(row%2?0x143e27:0xc6e77a,row%2?.05:.045);g.drawRect(0,y,w*2,band);g.endFill();}
   for(var i:int=0;i<360;i++){var gx:Number=(i*173)%int(w*2),gy:Number=groundTop+22+(i*137)%int(h*2-40),blade:Number=2+(gy-groundTop)/h*1.4;g.lineStyle(.7,i%2?0x164f2f:0xa8cf67,.07);g.moveTo(gx-blade,gy);g.lineTo(gx,gy-blade);g.lineTo(gx+blade*.5,gy);}
   g.lineStyle();lawn.cacheAsBitmap=true;camera.addChild(lawn);
   stadium=new MatchStadium(w*2,h*2,null,false);stadium.name="flight-equipped-stadium";camera.addChild(stadium);
   stadiumMask.graphics.beginFill(0xffffff);stadiumMask.graphics.drawRect(0,0,w*2,groundTop);stadiumMask.graphics.endFill();camera.addChild(stadiumMask);stadium.mask=stadiumMask;
   var rg:Graphics=rays.graphics;for(i=0;i<30;i++){var angle:Number=i*Math.PI*2/30,inner:Number=125+i%3*25,outer:Number=1500;rg.lineStyle(i%3==0?3:1,0xffffff,i%3==0?.22:.10);rg.moveTo(Math.cos(angle)*inner,Math.sin(angle)*inner);rg.lineTo(Math.cos(angle)*outer,Math.sin(angle)*outer);}rg.lineStyle();addChild(rays);
   shadow.graphics.beginFill(0x082e1a,.26);shadow.graphics.drawEllipse(-21,-5,42,10);shadow.graphics.endFill();addChild(shadow);visible=false;
  }
  private function mix(a:uint,b:uint,t:Number):uint {return (int(((a>>16)&255)*(1-t)+((b>>16)&255)*t)<<16)|(int(((a>>8)&255)*(1-t)+((b>>8)&255)*t)<<8)|int((a&255)*(1-t)+(b&255)*t);}
  public function track(progress:Number,ballX:Number,ballY:Number):void {
   if(dead)return;mode="TRACK";visible=true;var p:Number=Math.max(0,Math.min(1,progress));lastProgress=p;
   camera.x=-w*.42-p*w*.17;camera.y=-h*.35+Math.sin(p*Math.PI)*h*.28-p*p*h*.36;
   rays.x=ballX;rays.y=ballY;rays.visible=p>.05&&p<.9;rays.alpha=Math.sin(p*Math.PI)*.34;
   shadow.x=ballX;shadow.y=ballY+55+p*28;shadow.visible=shadow.y>camera.y+groundTop+8;shadow.scaleX=1-p*.56;shadow.scaleY=1-p*.28;shadow.alpha=.8;
  }
  public function fielding(actorX:Number,actorY:Number,scale:Number=1):void {
   if(dead)return;
   if(mode!="FIELD"){fieldAt=int(clock());fieldFromX=mode=="TRACK"?camera.x:-w*.48;fieldFromY=mode=="TRACK"?camera.y:-h*.64;}
   mode="FIELD";visible=true;var p:Number=Math.max(0,Math.min(1,(int(clock())-fieldAt)/240)),ease:Number=p*p*(3-2*p);
   camera.x=fieldFromX+(-w*.48-fieldFromX)*ease;camera.y=fieldFromY+(-h*.64-fieldFromY)*ease;rays.visible=false;shadow.visible=false;shadow.x=actorX;shadow.y=actorY+3;shadow.scaleX=scale*1.12;shadow.scaleY=scale;shadow.alpha=.65;
  }
  public function hide():void {visible=false;mode="HIDDEN";rays.visible=shadow.visible=false;}
  public function dispose():void {if(dead)return;dead=true;hide();stadium.mask=null;stadium.dispose();stadiumMask.graphics.clear();lawn.graphics.clear();rays.graphics.clear();shadow.graphics.clear();}
 }
}
