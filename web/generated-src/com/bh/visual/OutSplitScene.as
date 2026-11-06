package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.filters.GlowFilter;import com.bh.model.*;import com.bh.game.BaseballArt;
 /** Fly catch closeup and Ground Out reception use distinct retained camera compositions. */
 public class OutSplitScene extends Sprite {
  private var top:Sprite=new Sprite(),bottom:Sprite=new Sprite(),fly:Sprite=new Sprite(),actor:FieldingSprite,flyActor:FieldingSprite,runner:RunnerSprite,w:Number,h:Number;
  private var incoming:Shape=new Shape(),trail:BallFlightTrail=new BallFlightTrail(),dust:Array=[],upperMask:Shape=new Shape(),shoeMask:Shape=new Shape();
  private var flyBurst:ComicCatchBurst=new ComicCatchBurst(),flyWord:PitchCalloutArtwork,groundWord:PitchCalloutArtwork;
  private var kind:String="GROUND OUT",lastMs:Number=0,dead:Boolean=false,defender:Object,receiver:Object,baseX:Number,baseY:Number;
  public function OutSplitScene(width:Number,height:Number,color:uint,defenderIdentity:Object=null,receiverIdentity:Object=null){
   w=width;h=height;mouseEnabled=mouseChildren=false;name="out-result-scene";var order:Array=MatchRosterIdentity.opponent(GameData.currentOpponent());
   defender=MatchRosterIdentity.resolve(defenderIdentity,"LF");receiver=receiverIdentity||MatchRosterIdentity.atPosition(order,"1B");baseX=w*.71;baseY=h*.84;
   drawGround();addChild(top);addChild(bottom);
   actor=new FieldingSprite(color,String(receiver.name),receiver,true);actor.scaleX=actor.scaleY=2;actor.x=w*.66;actor.y=h*.60;actor.warmAll();top.addChild(actor);top.addChild(trail);BaseballArt.draw(incoming.graphics,9);top.addChild(incoming);
   upperMask.graphics.beginFill(0xffffff);upperMask.graphics.moveTo(0,52);upperMask.graphics.lineTo(w,52);upperMask.graphics.lineTo(w,h*.44);upperMask.graphics.lineTo(0,h*.71);upperMask.graphics.endFill();addChild(upperMask);top.mask=upperMask;
   runner=new RunnerSprite(GameData.mainPlayer());runner.warmAll();runner.scaleX=runner.scaleY=1.7;runner.y=baseY;bottom.addChild(runner);
   shoeMask.graphics.beginFill(0xffffff);shoeMask.graphics.drawRect(baseX-280,baseY-125,500,158);shoeMask.graphics.endFill();bottom.addChild(shoeMask);runner.mask=shoeMask;
   for(var i:int=0;i<8;i++){var puff:Shape=new Shape();puff.graphics.beginFill(0xf0d8a4,.65);puff.graphics.drawEllipse(-14,-6,28,12);puff.graphics.endFill();bottom.addChild(puff);dust.push(puff);}
   groundWord=new PitchCalloutArtwork("GROUND OUT",0xffa843);groundWord.x=w*.23;groundWord.y=h*.39;groundWord.rotation=-12;groundWord.scaleX=groundWord.scaleY=1.18;addChild(groundWord);
   var field:Shape=new Shape(),m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI/2,0,52);field.graphics.beginGradientFill("linear",[0x184f2b,GameData.stadiumAccent("field",0x278745),0x3c9450],[1,1,1],[0,115,255],m);field.graphics.drawRect(0,52,w,h-106);field.graphics.endFill();
   for(i=0;i<19;i++){field.graphics.beginFill(i%2?0xffffff:0x072d19,.035);field.graphics.drawRect(0,52+i*34,w,17+i*.8);field.graphics.endFill();}for(i=0;i<260;i++){var gx:Number=i*173%int(w),gy:Number=74+i*101%int(h-150);field.graphics.lineStyle(.7,0xc4df95,.07);field.graphics.moveTo(gx-2,gy);field.graphics.lineTo(gx,gy-3);field.graphics.lineTo(gx+2,gy);}field.graphics.lineStyle();field.cacheAsBitmap=true;fly.addChild(field);
   flyBurst.x=w*.61;flyBurst.y=h*.49;fly.addChild(flyBurst);
   flyActor=new FieldingSprite(color,String(defender.name),defender,true);flyActor.warmAll();flyActor.setFrame(10);flyActor.x=w*.61;flyActor.y=h*.82;flyActor.filters=[new GlowFilter(0xffffff,1,10,10,8,1)];fly.addChild(flyActor);
   flyWord=new PitchCalloutArtwork("FLY OUT",0xf94b67);flyWord.x=w*.25;flyWord.y=h*.35;flyWord.rotation=-13;fly.addChild(flyWord);addChild(fly);stop();
  }
  private function drawGround():void {
   var g:Graphics=top.graphics,m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI/2);g.beginGradientFill("linear",[0x1682b5,0x8cd6e8],[1,1],[0,255],m);g.drawRect(0,52,w,h-106);g.endFill();
   for(var i:int=0;i<24;i++){g.lineStyle(i%3==0?3:1,0xffffff,.10+(i%3)*.025);g.moveTo(-60,88+i*20);g.lineTo(w+40,50+i*20);}g.lineStyle();
   g=bottom.graphics;m.createGradientBox(w,h,Math.PI/2);g.beginGradientFill("linear",[0xa5754c,0xe3bd83],[1,1],[0,255],m);g.moveTo(0,h*.71);g.lineTo(w,h*.44);g.lineTo(w,h-54);g.lineTo(0,h-54);g.endFill();
   for(i=0;i<380;i++){var px:Number=(i*173)%int(w),py:Number=h*.71+(i*97)%int(h*.21);g.beginFill(i%2?0x794d31:0xffe5b0,.09);g.drawCircle(px,py,1+i%2);g.endFill();}
   g.lineStyle(8,0xffffff,.65);g.moveTo(w*.46,h-54);g.lineTo(w*.90,h*.48);g.lineStyle();
   g.beginFill(0x3d291d,.2);g.drawEllipse(baseX-68,baseY-4,145,25);g.endFill();
   g.lineStyle(2,0x6d7375);g.beginFill(0x9ca6a4);g.moveTo(baseX-60,baseY-14);g.lineTo(baseX+30,baseY-31);g.lineTo(baseX+77,baseY-6);g.lineTo(baseX-18,baseY+14);g.endFill();g.lineStyle(2,0xd9d9cb);g.beginFill(0xfffbed);g.moveTo(baseX-60,baseY-23);g.lineTo(baseX+30,baseY-40);g.lineTo(baseX+77,baseY-15);g.lineTo(baseX-18,baseY+5);g.endFill();g.lineStyle();g.lineStyle(2,0xffffff,.7);g.moveTo(baseX-52,baseY-23);g.lineTo(baseX+29,baseY-37);g.lineTo(baseX+67,baseY-16);g.lineStyle();
   g.lineStyle(7,0x11394f);g.moveTo(0,h*.71);g.lineTo(w,h*.44);g.lineStyle(2,0xffffff,.85);g.moveTo(0,h*.71-5);g.lineTo(w,h*.44-5);g.lineStyle();
  }
  public function begin(value:String):void {if(dead)return;kind=value;lastMs=0;}
  public function at(ms:Number):void {if(dead)return;visible=true;lastMs=ms=Math.max(0,ms);var isFly:Boolean=kind=="FLY OUT";fly.visible=isFly;top.visible=bottom.visible=groundWord.visible=!isFly;
   if(isFly){incoming.visible=false;trail.hide();flyBurst.at(ms);flyActor.setFrame(10);var p:Number=Math.min(1,ms/250),pop:Number=.78+.22*(1-Math.pow(1-p,3))+.06*Math.sin(p*Math.PI);flyActor.scaleX=flyActor.scaleY=2.20*pop;flyActor.rotation=(1-p)*-5;var wordP:Number=Math.max(0,Math.min(1,(ms-160)/200));flyWord.visible=wordP>0;flyWord.alpha=wordP;flyWord.scaleX=flyWord.scaleY=1.38*(.8+.2*wordP+.10*Math.sin(wordP*Math.PI));return;}
   actor.setFrame(ms<100?3:ms<200?0:10);actor.x=w*.66+(1-Math.min(1,ms/290))*w*.018;
   var glove:Point=top.globalToLocal(actor.localToGlobal(actor.anchor(false,10))),pFlight:Number=Math.min(1,ms/290),startX:Number=w*1.06,startY:Number=h*.12;
   incoming.visible=ms<290;incoming.x=startX+(glove.x-startX)*pFlight;incoming.y=startY+(glove.y-startY)*pFlight;incoming.rotation=ms*.7;trail.follow(incoming.x,incoming.y,glove.x-startX,glove.y-startY,pFlight);if(ms>=290)trail.hide();
   if(ms<360)runner.runAt(ms);else runner.arrive(ms-360);runner.x=baseX-180*(1-Math.min(1,ms/360));
   var q:Number=Math.max(0,Math.min(1,(ms-360)/460));for(var i:int=0;i<dust.length;i++){var puff:Shape=dust[i];puff.visible=ms>=360&&ms<820;puff.x=baseX-38+i*12+(i-3)*q*15;puff.y=baseY-3-q*(8+i%3*4);puff.scaleX=1+q*.8;puff.scaleY=1+q*.5;puff.alpha=1-q;}
   groundWord.alpha=Math.max(0,Math.min(1,(ms-300)/180));groundWord.scaleX=groundWord.scaleY=1.18*(.88+.12*groundWord.alpha);
  }
  public function stop():void {visible=false;incoming.visible=false;trail.hide();for each(var puff:Shape in dust)puff.visible=false;}
  public function dispose():void {if(dead)return;stop();dead=true;actor.dispose();flyActor.dispose();runner.dispose();flyBurst.dispose();trail.dispose();top.mask=null;runner.mask=null;}
 }
}
