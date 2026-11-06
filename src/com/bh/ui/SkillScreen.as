package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.*;import flash.utils.getTimer;
 import com.bh.model.*;import com.bh.visual.*;
 /** Illustrated catalog. The existing model owns every requirement, cost and effect. */
 public class SkillScreen extends Sprite {
  private var player:Object,back:Function,layer:Sprite=new Sprite(),controls:Array=[],art:Array=[],selected:String="BATTING_EYE",hud:MatchResourceBar,message:String="",dead:Boolean=false,actionAfter:int=0;
  public function SkillScreen(w:Number,h:Number,p:Object,done:Function){name="skill-screen";player=p;back=done;GameData.init();TravelMapArtwork.drawBackdrop(graphics,w,h);addChild(layer);render();}
  private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int=13,color:uint=0xffffff,align:String="left",id:String=""):TextField {
   var t:TextField=ClassicInventorySkin.text(parent,HelpText.es(value),x,y,w,h,size,color,align);LineupTypography.fit(t,size,color,align,false,10);if(id)t.name=id;return t;
  }
  private function button(id:String,value:String,x:Number,y:Number,w:Number,h:Number,fn:Function,enabled:Boolean=true,color:uint=0x73a932):ClassicActionButton {
   var b:ClassicActionButton=new ClassicActionButton(value,w,h,enabled?color:0x687d88);b.name=id;b.x=x;b.y=y;b.mouseEnabled=b.buttonMode=b.useHandCursor=enabled;layer.addChild(b);
   var handler:Function=function(e:MouseEvent):void{if(!dead&&b.mouseEnabled&&getTimer()>=actionAfter&&fn!=null)fn();};b.addEventListener(MouseEvent.CLICK,handler);controls.push({view:b,fn:handler});return b;
  }
  private function clear():void {
   for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.fn);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}controls=[];
   for each(var a:Object in art)if(a is SkillArtwork)SkillArtwork(a).dispose();art=[];if(hud){hud.dispose();hud=null;}while(layer.numChildren)layer.removeChildAt(0);layer.graphics.clear();
  }
  private function icon(parent:Sprite,id:String,x:Number,y:Number,w:Number,h:Number,locked:Boolean=false):SkillArtwork {
   var s:SkillArtwork=new SkillArtwork(id,w,h,locked);s.x=x;s.y=y;parent.addChild(s);art.push(s);return s;
  }
  private function stars(parent:Sprite,x:Number,y:Number,rank:int):void {
   var g:Graphics=parent.graphics;for(var n:int=0;n<3;n++){g.lineStyle(1,n<rank?0x8f6421:0x738a95);g.beginFill(n<rank?0xffd45e:0xc1cbd0);for(var i:int=0;i<10;i++){var angle:Number=-Math.PI/2+i*Math.PI/5,r:Number=i%2?3.2:7.5,px:Number=x+n*25+Math.cos(angle)*r,py:Number=y+Math.sin(angle)*r;if(i==0)g.moveTo(px,py);else g.lineTo(px,py);}g.endFill();}g.lineStyle();
  }
  private function effectAt(item:Object,rank:int):String {
   if(rank<=0)return "NOT LEARNED";var parts:Array=String(item.effect).split(" / "),prefix:String=String(parts[0]).replace(/[-+]?\d.*$/,"");var value:String=rank==1?parts[0]:prefix+parts[Math.min(parts.length-1,rank-1)];if(item.id=="TEAM_SPIRIT"&&value.indexOf("per hit")<0)value+=" per hit";return value;
  }
  private function requirement(item:Object,rank:int,lock:String):String {
   if(lock!=""){if(GameData.level<int(item.unlockLevel))return "Requiere nivel "+item.unlockLevel+" del héroe.";var previous:Object=GameData.skillById(String(item.requires));return "Primero mejora "+(previous?previous.name:item.requires)+" a rango "+item.requiresRank+".";}
   if(rank>=int(item.maxLevel))return "Has alcanzado el rango máximo de esta habilidad.";
   var cost:int=SkillCatalog.cost(rank);return "Necesitas "+cost+" SKILL POINT"+(cost==1?"":"S")+" para "+(rank==0?"aprenderla.":"mejorarla.");
  }
  private function render():void {
   if(dead)return;clear();hud=new MatchResourceBar(960,true);layer.addChild(hud);
   ClassicChrome.title(label(layer,"PLAYER SKILLS",34,66,785,43,30),30,0xffffff,"left");button("SKILL_BACK","CLOSE",833,72,104,34,function():void{if(back!=null)back();},true,0x426f8b);
   var g:Graphics=layer.graphics;ClassicChrome.panel(g,20,116,610,484);ClassicChrome.panel(g,640,116,300,583);ClassicChrome.panel(g,20,609,610,90);
   ClassicChrome.title(label(layer,"SKILL BOOK",39,124,300,32,23),23,0xffffff,"left");var medal:AchievementArtwork=new AchievementArtwork("skill",34,34);medal.x=370;medal.y=126;layer.addChild(medal);art.push(medal);
   label(layer,"POINTS  "+int(player.skillPoints),408,130,201,27,18,0xffe374,"right","skill-points");label(layer,"Aprende una habilidad y elige cuál usar al batear.",40,162,570,24,12,0xd9f0fb);
   var items:Array=SkillCatalog.items();for(var i:int=0;i<items.length;i++)tile(items[i],35+(i%3)*196,194+int(i/3)*98);
   var activeId:String=GameData.activeSkillId(player),active:Object=GameData.skillById(activeId);if(active)icon(layer,activeId,32,623,63,63);
   label(layer,"ACTIVE SKILL",109,620,485,22,11,0x9ce1ff);label(layer,GameData.activeSkillName(player),109,640,485,28,19,0xffe38a,"left","skill-active");
   label(layer,message!=""?message:"Solo la habilidad activa aplica su efecto al jugar.",109,670,492,22,11,message!=""?0xffe984:0xd7eef7);
   var item:Object=GameData.skillById(selected),rank:int=GameData.skillLevel(player,selected),lock:String=SkillCatalog.locked(item,player,GameData.level),max:int=int(item.maxLevel),isActive:Boolean=activeId==selected;
   var heading:TextField=label(layer,String(item.name).toUpperCase(),658,128,264,45,24,0xffffff,"center","skill-title");ClassicChrome.title(heading,24);
   ClassicChrome.well(g,710,181,160,125,false,false);icon(layer,selected,731,188,118,111,lock!="");
   label(layer,item.branch,663,315,254,24,13,uint(item.accent),"center");label(layer,"RANK "+rank+" / "+max,663,340,254,25,18,0xffe374,"center","skill-rank");
   ClassicChrome.well(g,658,378,264,56,false,false);label(layer,"CURRENT EFFECT",666,384,248,18,10,0x9ce1ff,"center");label(layer,effectAt(item,rank),664,401,252,28,15,0xffffff,"center","skill-effect");
   label(layer,rank>=max?"MAX RANK":"NEXT: "+effectAt(item,rank+1),660,441,260,25,12,0xffe384,"center","skill-next");
   label(layer,item.description,661,475,258,49,13,0xebf5f9,"center","skill-description");label(layer,requirement(item,rank,lock),661,530,258,38,12,lock!=""?0xffd1b0:0xcde9f6,"center","skill-requirement");
   var canUpgrade:Boolean=lock==""&&rank<max&&int(player.skillPoints)>=SkillCatalog.cost(rank);
   button("SKILL_UPGRADE",lock!=""?"LOCKED":rank>=max?"MAX RANK":canUpgrade?(rank==0?"LEARN":"UPGRADE"):"NEED POINTS",661,578,258,43,upgrade,canUpgrade);
   button("SKILL_ACTIVATE",isActive?"ACTIVE":"ACTIVATE",661,632,258,43,activate,rank>0&&!isActive,0xd5a337);
  }
  private function tile(item:Object,x:Number,y:Number):void {
   var rank:int=GameData.skillLevel(player,item.id),lock:String=SkillCatalog.locked(item,player,GameData.level),active:Boolean=GameData.activeSkillId(player)==item.id;
   var p:Sprite=new Sprite();p.name="SKILL_"+item.id;p.x=x;p.y=y;p.buttonMode=p.useHandCursor=true;p.mouseChildren=false;layer.addChild(p);
   var g:Graphics=p.graphics;ClassicChrome.well(g,0,0,187,90,selected==item.id,true);if(selected==item.id){g.lineStyle(2,0xffd65b);g.drawRoundRect(1,1,185,88,8);g.lineStyle();}
   icon(p,String(item.id),7,11,61,61,lock!="");label(p,item.name,75,7,104,35,13,0x224252,"left");
   label(p,lock!=""?"LOCKED":active?"ACTIVE":rank==0?"NOT LEARNED":"RANK "+rank,75,44,103,20,10,active?0x2c7d32:0x4b6573);stars(p,85,75,rank);
   var handler:Function=function(e:MouseEvent):void{if(dead)return;selected=String(item.id);message="";render();};p.addEventListener(MouseEvent.CLICK,handler);controls.push({view:p,fn:handler});
  }
  private function upgrade():void {if(dead||getTimer()<actionAfter)return;actionAfter=getTimer()+300;var result:String=GameData.upgradeSkill(player,selected);message=result=="OK"?"Habilidad mejorada.":result=="POINTS"?"Necesitas más SKILL POINTS.":result=="LOCKED"?"Completa primero los requisitos.":"Esta habilidad ya está al máximo.";render();}
  private function activate():void {if(dead||getTimer()<actionAfter)return;actionAfter=getTimer()+300;message=GameData.setActiveSkill(player,selected)?"Habilidad activa para tu próximo turno al bate.":"Aprende la habilidad antes de activarla.";render();}
  public function dispose():void {if(dead)return;dead=true;clear();back=null;}
 }
}
