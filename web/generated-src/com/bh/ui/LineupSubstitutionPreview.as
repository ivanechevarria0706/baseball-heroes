package com.bh.ui {
 import flash.display.Sprite;import flash.text.TextField;import com.bh.model.GameData;import com.bh.visual.CharacterPortrait;
 /** Read-only comparison. Hovering never assigns a player or saves the career. */
 public class LineupSubstitutionPreview extends Sprite {
  private var portrait:CharacterPortrait,key:String="";
  public function LineupSubstitutionPreview(){name="lineup-substitution-preview";mouseEnabled=mouseChildren=false;visible=false;}
  private function label(s:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String="left"):TextField{var t:TextField=ClassicInventorySkin.text(this,s,x,y,w,h,size,color,align);LineupTypography.fit(t,size,color,align,false,8);return t;}
  public function show(incoming:Object,current:Object,slot:int):void {
   visible=true;var next:String=String(incoming.name)+"|"+String(incoming.specialCardId)+"|"+String(current.name)+"|"+slot;
   if(next==key)return;key=next;clear();ClassicChrome.panel(graphics,0,0,226,119);ClassicChrome.bar(graphics,5,5,216,20);
   label(current===GameData.mainPlayer()?"YOUR HERO":"REPLACE #"+(slot+1),11,6,202,20,11,0xffe495);
   if(current===GameData.mainPlayer()) {var tip:TextField=label("Tu héroe permanece en LINEUP. Elige otro puesto para colocar al suplente.",12,36,201,71,11,0xe8f2f5);tip.wordWrap=tip.multiline=true;LineupTypography.fit(tip,11,0xe8f2f5,"left",false,10);return;}
   portrait=new CharacterPortrait(incoming,29,32,true);portrait.x=9;portrait.y=29;addChild(portrait);
   label("OUT  "+String(current.name),44,29,171,15,9,0xffd772);label("IN     "+String(incoming.name),44,44,171,15,9,0x9eebc8);
   var stats:Array=[['CON','contact'],['POW','power'],['SPE','speed'],['LUCK','luck']];
   for(var i:int=0;i<4;i++){
    var old:int=GameData.matchStat(current,stats[i][1]),value:int=GameData.matchStat(incoming,stats[i][1]),delta:int=value-old,y:Number=64+i*12.5;
    graphics.beginFill(i%2==0?0x154660:0x123a53);graphics.drawRect(7,y,212,12.5);graphics.endFill();
    label(stats[i][0],11,y-1,53,15,9,0xbbdce8);label(String(old),75,y-1,33,15,10,0xffd772,"right");label(">",114,y-1,12,15,9,0x7fa6bd,"center");
    label(String(value),130,y-1,33,15,10,0x9eebc8,"right");label((delta>0?"+":"")+delta,170,y-1,43,15,10,delta>0?0xa5ee79:delta<0?0xff9e88:0xc4d8df,"right");
   }
  }
  private function clear():void{if(portrait){portrait.dispose();portrait=null;}while(numChildren)removeChildAt(0);graphics.clear();}
  public function dispose():void{clear();key="";visible=false;}
 }
}
