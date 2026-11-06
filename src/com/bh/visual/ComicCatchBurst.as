package com.bh.visual {
 import flash.display.*;
 /** Retained comic ink: jagged paper, red paint and scattered black/white droplets. */
 public class ComicCatchBurst extends Sprite {
  private var paper:Shape=new Shape(),paint:Shape=new Shape(),specks:Shape=new Shape();
  public function ComicCatchBurst(){mouseEnabled=mouseChildren=false;name="catch-comic-burst";addChild(paper);addChild(paint);addChild(specks);
   star(paper.graphics,0xffffff,203,135,27);star(paint.graphics,0xc8324e,183,118,31);
   var g:Graphics=specks.graphics;for(var i:int=0;i<78;i++){var a:Number=i*2.39996323,r:Number=120+(i*47)%113,x:Number=Math.cos(a)*r,y:Number=Math.sin(a)*r*.82;g.beginFill(i%3==0?0x071c27:i%3==1?0xffffff:0xec4963);g.drawCircle(x,y,3+(i*7)%14);g.endFill();}cacheAsBitmap=true;
  }
  private function star(g:Graphics,color:uint,outer:Number,inner:Number,points:int):void {g.beginFill(color);for(var i:int=0;i<points*2;i++){var a:Number=i*Math.PI/points,r:Number=i%2?inner:outer-(i*13)%26;if(i==0)g.moveTo(Math.cos(a)*r,Math.sin(a)*r*.87);else g.lineTo(Math.cos(a)*r,Math.sin(a)*r*.87);}g.endFill();}
  public function at(ms:Number):void {var p:Number=Math.max(0,Math.min(1,ms/220)),overshoot:Number=1+Math.sin(p*Math.PI)*.13;scaleX=scaleY=(.35+.65*p)*overshoot;rotation=-11+(1-p)*18;alpha=p;}
  public function dispose():void {paper.graphics.clear();paint.graphics.clear();specks.graphics.clear();visible=false;}
 }
}
