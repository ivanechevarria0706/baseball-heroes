package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.TextField;import flash.utils.getTimer;
 import com.bh.visual.HeroHead;import com.bh.visual.HomeSprite;
 /** The server awards energy. This panel only previews and confirms the action. */
 public class EnergySharePanel extends Sprite {
  private var paper:Sprite=new Sprite(),shade:Shape=new Shape(),face:HeroHead,can:SocialGiftArtwork;
  private var controls:Array=[],confirm:Function,cancel:Function,started:int,dead:Boolean=false,entered:Boolean=false;
  public function EnergySharePanel(friend:Object,onConfirm:Function,onCancel:Function){
   name="visit-energy-dialog";confirm=onConfirm;cancel=onCancel;
   shade.graphics.beginFill(0x071e33,.65);shade.graphics.drawRect(0,0,960,720);shade.graphics.endFill();addChild(shade);addChild(paper);
   var g:Graphics=paper.graphics;g.lineStyle(2.5,0x18374b);ClassicChrome.fill(g,0,0,543,274,[0xffffff,0xf0f3ee,0xc3cccb],[0,148,255],15);g.lineStyle(1,0xffffff);g.drawRoundRect(4,4,535,266,12);g.lineStyle();
   can=new SocialGiftArtwork("energy",58,84);can.x=28;can.y=14;paper.addChild(can);
   title("SHARING IS",94,8,286,37,28,0x51d8ff);title("CARING!",98,41,279,47,38,0xffd04b);
   var profile:Object=friend.profile||{},appearance:Object=profile.appearance||{};
   g.beginFill(0xffffff);g.drawCircle(459,113,64);g.endFill();g.lineStyle(2,0x60bfdf);g.drawCircle(459,113,64);g.lineStyle();
   face=new HeroHead(appearance,HomeSprite.paletteFor(String(friend.name),uint(profile.accent||0x247ab2),appearance,{}));face.x=459;face.y=160;face.scaleX=face.scaleY=.66;paper.addChild(face);
   g.lineStyle(2,0x59b9e4);g.beginFill(0xffffff);g.moveTo(30,102);g.lineTo(371,102);g.lineTo(371,129);g.lineTo(397,138);g.lineTo(371,146);g.lineTo(371,179);g.lineTo(30,179);g.lineTo(30,102);g.endFill();g.lineStyle();
   var help:TextField=ClassicInventorySkin.text(paper,"Recibes 1 ENERGY y dejas 1 ENERGY para tu amigo.\nAmbos premios se guardan aunque jueguen a distintas horas.",40,110,321,62,14,0x314c61,"center");help.name="visit-energy-help";
   var friendName:TextField=ClassicInventorySkin.text(paper,String(friend.name),387,170,144,24,12,0x314c61,"center");friendName.name="visit-energy-friend-name";
   button("SKIP","visit-energy-cancel",53,203,130,0x728994,function():void{if(cancel!=null)cancel();});
   button("SHARE ENERGY","visit-share-energy",204,203,285,0x67ac33,function():void{if(confirm!=null)confirm();});
   ClassicInventorySkin.text(paper,"Confirma para compartir. SKIP o Escape cierran sin gastar ni cobrar.",24,246,495,20,11,0x426276,"center");
   started=getTimer();animate(null);addEventListener(Event.ENTER_FRAME,animate);
  }
  private function title(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):void {var t:TextField=ClassicInventorySkin.text(paper,value,x,y,w,h,size,color,"left");ClassicChrome.title(t,size,color,"left");}
  private function button(value:String,id:String,x:Number,y:Number,w:Number,color:uint,fn:Function):void {var b:Sprite=ClassicInventorySkin.button(value,w,35,color);b.x=x;b.y=y;b.name=id;paper.addChild(b);var h:Function=function(e:MouseEvent):void{if(!dead&&entered){e.stopPropagation();fn();}};b.addEventListener(MouseEvent.CLICK,h);controls.push({view:b,handler:h});}
  private function animate(e:Event):void {if(dead)return;var p:Number=Math.min(1,(getTimer()-started)/230),q:Number=1-Math.pow(1-p,3),s:Number=.94+.06*q;paper.scaleX=paper.scaleY=s;paper.x=208+(543*(1-s))/2;paper.y=202+(274*(1-s))/2+12*(1-q);paper.alpha=.4+.6*q;shade.alpha=q;entered=p>=.75;if(p>=1)removeEventListener(Event.ENTER_FRAME,animate);}
  public function dispose():void {if(dead)return;dead=true;removeEventListener(Event.ENTER_FRAME,animate);for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);ClassicActionButton(c.view).dispose();}controls=[];face.dispose();can.dispose();confirm=cancel=null;}
 }
}
