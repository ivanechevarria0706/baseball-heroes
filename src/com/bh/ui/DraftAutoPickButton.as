package com.bh.ui {
 import flash.display.Sprite;import flash.display.Graphics;import flash.events.MouseEvent;import flash.geom.Matrix;import flash.text.TextField;
 /** Small raised yellow arrow from the draft reference; no frame listener. */
 public class DraftAutoPickButton extends Sprite {
  private var over:Boolean=false,pressed:Boolean=false;
  public function DraftAutoPickButton() {
   mouseChildren=false;buttonMode=true;
   var title:TextField=ClassicInventorySkin.text(this,"AUTO PICK",9,14,154,27,18,0x483a12,"center",true);LineupTypography.apply(title,18,0x483a12,"center",true);
   paint();addEventListener(MouseEvent.ROLL_OVER,onOver);addEventListener(MouseEvent.ROLL_OUT,onOut);addEventListener(MouseEvent.MOUSE_DOWN,onDown);addEventListener(MouseEvent.MOUSE_UP,onUp);
  }
  private function outline(g:Graphics,dy:Number):void {g.moveTo(0,17+dy);g.lineTo(86,dy);g.lineTo(172,17+dy);g.lineTo(147,17+dy);g.lineTo(147,43+dy);g.lineTo(25,43+dy);g.lineTo(25,17+dy);g.lineTo(0,17+dy);}
  private function paint():void {
   var g:Graphics=graphics,m:Matrix=new Matrix();g.clear();g.lineStyle();g.beginFill(0x092438,.45);outline(g,4);g.endFill();
   m.createGradientBox(172,43,Math.PI/2,0,pressed?2:0);g.lineStyle(2,0x79602c);g.beginGradientFill("linear",over?[0xffffff,0xffeb7c,0xf1bf28]:[0xfff6bd,0xffdc5a,0xd6a521],[1,1,1],[0,120,255],m);outline(g,pressed?2:0);g.endFill();g.lineStyle(1,0xffffcf,.85);g.moveTo(9,16+(pressed?2:0));g.lineTo(86,3+(pressed?2:0));g.lineTo(163,16+(pressed?2:0));g.lineStyle();
  }
  private function onOver(e:MouseEvent):void{over=true;paint();}private function onOut(e:MouseEvent):void{over=pressed=false;paint();}private function onDown(e:MouseEvent):void{pressed=true;paint();}private function onUp(e:MouseEvent):void{pressed=false;paint();}
  public function dispose():void{removeEventListener(MouseEvent.ROLL_OVER,onOver);removeEventListener(MouseEvent.ROLL_OUT,onOut);removeEventListener(MouseEvent.MOUSE_DOWN,onDown);removeEventListener(MouseEvent.MOUSE_UP,onUp);}
 }
}
