package com.bh.ui {
 import flash.display.*;import flash.text.TextField;import com.bh.visual.CharacterPortrait;
 /** Retains its illustrated portrait when selection changes. */
 public class TeamRosterTile extends Sprite {
  public var data:Object;private var portrait:CharacterPortrait,selected:Boolean=false;
  public function TeamRosterTile(p:Object,index:int,inLineup:Boolean){data=p;name="team-player-"+index;buttonMode=useHandCursor=true;mouseChildren=false;paint();portrait=new CharacterPortrait(p,43,49,true);portrait.x=7;portrait.y=29;addChild(portrait);
   var t:TextField=ClassicInventorySkin.text(this,String(p.name),6,4,92,23,12,0x244252);t.name="roster-name";LineupTypography.fit(t,12,0x244252,"left",false,9);
   ClassicInventorySkin.text(this,String(p.pos),55,29,44,18,12,0x31536b,"center");ClassicInventorySkin.text(this,"OVR "+p.rating,52,51,50,20,10,0x31536b,"center");
   ClassicInventorySkin.text(this,inLineup?"IN LINEUP":"RESERVE",5,79,94,18,9,inLineup?0x276c37:0x5b6870,"center");
  }
  public function setSelected(value:Boolean):void {selected=value;paint();}
  private function paint():void {graphics.clear();ClassicChrome.well(graphics,0,0,104,101,selected,true);if(selected){graphics.lineStyle(2,0xffd65b);graphics.drawRoundRect(1,1,102,99,8);graphics.lineStyle();}}
  public function dispose():void {if(portrait){portrait.dispose();portrait=null;}}
 }
}
