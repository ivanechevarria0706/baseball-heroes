package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.*;
 /** Presentation of the award already committed by GameData. */
 public class SpecialMatchBonus extends Sprite {
  private var button:UIButton,close:Function;
  public function SpecialMatchBonus(w:Number,h:Number,summary:Object,done:Function){name="special-match-bonus";close=done;graphics.beginFill(0x051d32,.78);graphics.drawRect(0,0,w,h);graphics.endFill();var p:Sprite=new Sprite();p.x=(w-520)/2;p.y=(h-350)/2;addChild(p);p.graphics.lineStyle(4,0xb9e8f5);p.graphics.beginFill(0x176da2);p.graphics.drawRoundRect(0,0,520,350,18);p.graphics.endFill();ClassicInventorySkin.text(p,"SPECIAL MATCH BONUS",25,15,470,38,26,0xffe36e,"center");for(var i:int=0;i<2;i++){var active:Boolean=Boolean(summary.win)==(i==0),s:Sprite=new Sprite();s.x=34+i*248;s.y=75;s.alpha=active?1:.36;p.addChild(s);s.graphics.lineStyle(3,active?0xffd43b:0xa3beca);s.graphics.beginFill(0xf0f6ef);s.graphics.drawRoundRect(0,0,205,170,10);s.graphics.endFill();ClassicInventorySkin.text(s,i==0?"WIN":"LOSE",7,10,191,32,25,0x215f7c,"center");ClassicInventorySkin.icon(s,i==0?"box":"coin",77,63,1.8);ClassicInventorySkin.text(s,i==0?"MYSTERY BOX":"500 COINS",8,126,189,30,18,0x456572,"center");}ClassicInventorySkin.text(p,summary.win?(int(summary.mysteryAward.boxes)>0?"Mystery Box added to Inventory":"Inventory full · no box added"):"Tu premio incluye 500 Coins",20,253,480,25,14,0xffffff,"center");button=new UIButton("CONTINUE",220,40,0x68ae2b,0x83c63a,0xe3f8bf);button.name="SPECIAL_CONTINUE";button.x=150;button.y=294;p.addChild(button);button.addEventListener(MouseEvent.CLICK,clicked);}
  private function clicked(e:MouseEvent):void {e.stopPropagation();if(close!=null)close();}
  public function dispose():void {button.removeEventListener(MouseEvent.CLICK,clicked);button.dispose();close=null;}
 }
}
