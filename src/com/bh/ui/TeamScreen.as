package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.TextField;
 import com.bh.model.GameData;import com.bh.model.PlayerCondition;import com.bh.visual.*;
 /** Read-only roster overview. Editing remains in the existing dedicated screens. */
 public class TeamScreen extends Sprite {
  private var callbacks:Object,roster:Array,selected:Object,selectedIndex:int=-1,page:int=0;
  private const PAGE_SIZE:int=12;
  private var hud:MatchResourceBar,rosterLayer:Sprite=new Sprite(),profile:Sprite=new Sprite(),fieldArt:TeamFieldArtwork,tiles:Array=[],markers:Array=[],controls:Array=[],profileArt:Array=[];
  private var pageText:TextField,selectedText:TextField,prev:ClassicActionButton,next:ClassicActionButton,train:ClassicActionButton,skills:ClassicActionButton,dead:Boolean=false;
  public function TeamScreen(w:Number,h:Number,homeCallback:Function,trainCallback:Function,equipCallback:Function,skillCallback:Function,lineupCallback:Function,cardsCallback:Function) {
   name="team-screen";callbacks={home:homeCallback,train:trainCallback,equip:equipCallback,skills:skillCallback,lineup:lineupCallback,cards:cardsCallback};GameData.init();roster=GameData.roster;
   TravelMapArtwork.drawBackdrop(graphics,w,h);hud=new MatchResourceBar(w,true);addChild(hud);
   ClassicChrome.title(label(this,"TEAM  ·  "+GameData.teamName,35,66,775,43,29),29,0xffffff,"left");
   button("team-home","HOME",833,73,104,34,function():void{go("home");},0x426f8b);
   ClassicChrome.panel(graphics,20,116,346,505);ClassicChrome.panel(graphics,376,116,330,505);ClassicChrome.panel(graphics,716,116,224,505);ClassicChrome.panel(graphics,20,630,920,84);
   ClassicChrome.title(label(this,"ROSTER",35,124,150,32,23),23,0xffffff,"left");
   pageText=label(this,"",178,132,98,23,11,0xdceff7,"right","team-roster-page");
   prev=button("team-page-prev","<",283,129,31,27,function():void{changePage(-1);},0x426f8b);next=button("team-page-next",">",320,129,31,27,function():void{changePage(1);},0x426f8b);
   rosterLayer.x=35;rosterLayer.y=169;addChild(rosterLayer);
   ClassicChrome.title(label(this,"ROSTER POSITIONS",389,124,304,32,23),23);
   fieldArt=new TeamFieldArtwork(314,424);fieldArt.x=384;fieldArt.y=165;addChild(fieldArt);buildField();
   label(this,"Posiciones base del roster. LINEUP configura el orden al bate.",389,590,304,27,10,0xe7f3ed,"center");
   ClassicChrome.title(label(this,"PLAYER",731,124,194,32,23),23);
   addChild(profile);buildActions();renderRoster();if(roster.length)selectIndex(0);else drawProfile();
  }
  private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int=13,color:uint=0xffffff,align:String="left",id:String=""):TextField {
   var t:TextField=ClassicInventorySkin.text(parent,value,x,y,w,h,size,color,align);LineupTypography.fit(t,size,color,align,false,9);if(id)t.name=id;return t;
  }
  private function button(id:String,value:String,x:Number,y:Number,w:Number,h:Number,fn:Function,color:uint=0x6fa435):ClassicActionButton {
   var b:ClassicActionButton=new ClassicActionButton(value,w,h,color);b.name=id;b.x=x;b.y=y;addChild(b);
   var handler:Function=function(e:MouseEvent):void{if(!dead&&b.mouseEnabled)fn();};b.addEventListener(MouseEvent.CLICK,handler);controls.push({view:b,handler:handler});return b;
  }
  private function enabled(b:ClassicActionButton,value:Boolean):void {b.mouseEnabled=b.buttonMode=b.useHandCursor=value;b.alpha=value?1:.45;}
  private function go(action:String):void {if(dead)return;var fn:Function=callbacks[action];if(fn==null)return;if(action=="train"||action=="skills"){if(selected)fn(selected);}else fn();}
  private function clearTiles():void {for each(var tile:TeamRosterTile in tiles){tile.removeEventListener(MouseEvent.CLICK,onTile);tile.dispose();}tiles=[];while(rosterLayer.numChildren)rosterLayer.removeChildAt(0);}
  private function renderRoster():void {
   clearTiles();var pages:int=Math.max(1,Math.ceil(roster.length/PAGE_SIZE));page=Math.max(0,Math.min(pages-1,page));
   for(var i:int=page*PAGE_SIZE;i<Math.min(roster.length,(page+1)*PAGE_SIZE);i++){var tile:TeamRosterTile=new TeamRosterTile(roster[i],i,GameData.battingOrder.indexOf(String(roster[i].name))>=0),local:int=i-page*PAGE_SIZE;tile.x=(local%3)*108;tile.y=int(local/3)*110;tile.setSelected(i==selectedIndex);tile.addEventListener(MouseEvent.CLICK,onTile);rosterLayer.addChild(tile);tiles.push(tile);}
   pageText.text=roster.length+" PLAYERS  "+(page+1)+"/"+pages;LineupTypography.fit(pageText,11,0xdceff7,"right",false,9);enabled(prev,page>0);enabled(next,page<pages-1);
  }
  private function changePage(delta:int):void {var p:int=page+delta;if(p<0||p>=Math.ceil(roster.length/PAGE_SIZE))return;page=p;renderRoster();if(tiles.length)selectIndex(roster.indexOf(TeamRosterTile(tiles[0]).data));}
  private function onTile(e:MouseEvent):void {if(!dead)selectIndex(roster.indexOf(TeamRosterTile(e.currentTarget).data));}
  private function buildField():void {
   var positions:Array=[["LF",432,246],["CF",541,205],["RF",650,246],["SS",490,338],["2B",592,338],["3B",430,407],["1B",652,407],["P",541,442],["C",541,547]];
   for each(var entry:Array in positions){var p:Object=null;for each(var candidate:Object in roster)if(String(candidate.pos)==entry[0]){p=candidate;break;}fieldMarker(String(entry[0]),entry[1],entry[2],p);}
  }
  private function fieldMarker(pos:String,x:Number,y:Number,p:Object):void {
   var marker:Sprite=new Sprite();marker.name="team-position-"+pos;marker.x=x-35;marker.y=y-30;marker.mouseChildren=false;marker.buttonMode=marker.useHandCursor=p!=null;addChild(marker);
   if(p){var portrait:CharacterPortrait=new CharacterPortrait(p,38,37,true);portrait.x=16;portrait.y=4;marker.addChild(portrait);markers.push({view:marker,data:p,portrait:portrait});}
   else {marker.addChild(new InterfaceSprite("scout",33,33));markers.push({view:marker,data:null,portrait:null});}
   label(marker,pos,1,2,18,18,9,0x264e67,"center");label(marker,p?String(p.name).substr(0,12):"OPEN",2,43,66,18,10,0x254450,"center");
   var handler:Function=function(e:MouseEvent):void{if(!dead&&p)selectIndex(roster.indexOf(p));};marker.addEventListener(MouseEvent.CLICK,handler);controls.push({view:marker,handler:handler});paintMarker(marker,false);
  }
  private function paintMarker(marker:Sprite,selected:Boolean):void {marker.graphics.clear();ClassicChrome.well(marker.graphics,0,0,70,63,selected,true);if(selected){marker.graphics.lineStyle(2,0xffd65b);marker.graphics.drawRoundRect(1,1,68,61,7);marker.graphics.lineStyle();}}
  private function selectIndex(index:int):void {
   if(dead||index<0||index>=roster.length)return;selectedIndex=index;selected=roster[index];if(int(index/PAGE_SIZE)!=page){page=int(index/PAGE_SIZE);renderRoster();}
   for each(var tile:TeamRosterTile in tiles)tile.setSelected(tile.data===selected);
   for each(var marker:Object in markers)paintMarker(marker.view,marker.data===selected);drawProfile();
  }
  private function clearProfile():void {for each(var art:Object in profileArt){if(art is CharacterPortrait)CharacterPortrait(art).dispose();else if(art is SkillArtwork)SkillArtwork(art).dispose();}profileArt=[];while(profile.numChildren)profile.removeChildAt(0);profile.graphics.clear();}
  private function drawProfile():void {
   clearProfile();enabled(train,selected!=null);enabled(skills,selected!=null);if(!selected){label(profile,"No hay jugadores para mostrar.",732,236,191,80,15,0xffffff,"center");return;}
   var p:Object=selected,g:Graphics=profile.graphics;ClassicChrome.well(g,766,166,124,108,false,false);
   var portrait:CharacterPortrait=new CharacterPortrait(p,94,98,true);portrait.x=781;portrait.y=171;profile.addChild(portrait);profileArt.push(portrait);
   label(profile,String(p.name),731,280,194,41,19,0xffffff,"center","team-selected-name");label(profile,String(p.pos)+"  ·  "+String(p.grade),731,322,194,21,11,0xffdf7a,"center");
   label(profile,"LEVEL "+p.level,731,349,84,24,13,0xe4f0f6);label(profile,"OVR "+p.rating,815,349,84,24,15,0xffdf7a,"right");
   var form:int=p.condition&&p.condition.form!==undefined?Math.max(-2,Math.min(2,int(p.condition.form))):0;ConditionArrow.paint(g,912,359,form,21,24);
   label(profile,"BASE + GEAR",731,382,194,19,10,0xa3ddf1);
   attribute("POWER","POWER_HITTER",Number(p.power),p===GameData.mainPlayer()?GameData.equipmentBonus("power"):0,402,0xe47b4f);
   attribute("CONTACT","BATTING_EYE",Number(p.contact),p===GameData.mainPlayer()?GameData.equipmentBonus("contact"):0,443,0x4bb4dc);
   attribute("LUCK","LUCKY_SWING",Number(p.luck),0,484,0xcba62d);
   var labels:Array=["AVG","HR","RBI"],values:Array=[p.avg,p.hr,p.rbi];for(var i:int=0;i<3;i++){ClassicChrome.well(g,731+i*65,532,62,48,false,false);label(profile,labels[i],733+i*65,536,58,17,10,0xb7dfef,"center");label(profile,String(values[i]),732+i*65,552,60,24,16,0xffffff,"center","team-career-"+labels[i]);}
   label(profile,"FORM  "+PlayerCondition.labelFor(form),732,591,193,22,11,0xd5eef9,"center","team-selected-form");
   selectedText.text="SELECTED  ·  "+String(p.name);LineupTypography.fit(selectedText,17,0xffe387,"left",false,10);
  }
  private function attribute(title:String,id:String,value:Number,bonus:int,y:Number,color:uint):void {
   var g:Graphics=profile.graphics;ClassicChrome.well(g,731,y,194,35,false,false);var icon:SkillArtwork=new SkillArtwork(id,27,27);icon.x=735;icon.y=y+4;profile.addChild(icon);profileArt.push(icon);
   label(profile,title,765,y+2,81,16,10,0xddeef5);label(profile,String(value)+(bonus?" (+"+bonus+")":""),832,y+1,87,22,13,0xffffff,"right","team-stat-"+title);
   ClassicChrome.well(g,765,y+22,153,8,false,false);ClassicChrome.fill(g,768,y+24,147*Math.max(0,Math.min(1,(value+bonus)/100)),4,[ClassicChrome.blend(color,0xffffff,.4),color],[0,255],4);
  }
  private function buildActions():void {
   selectedText=label(this,"SELECTED",35,641,391,25,17,0xffe387,"left","team-selected-footer");label(this,"EQUIP gestiona al héroe; TRAIN y SKILLS usan el jugador seleccionado.",35,671,391,33,11,0xd8edf8);
   var positions:Array=[438,542,646,750,854],ids:Array=["lineup","cards","train","equip","skills"],captions:Array=["LINEUP","CARDS","TRAIN","EQUIP","SKILLS"];
   for(var i:int=0;i<ids.length;i++)action(String(ids[i]),String(captions[i]),positions[i]);
  }
  private function action(id:String,caption:String,x:Number):void {
   var decoration:Sprite=id=="skills"?new AchievementArtwork("skill",32,29):new InterfaceSprite(id=="lineup"?"modes":id=="cards"?"scout":id=="train"?"batter":"helmet",35,29);decoration.x=x+31;decoration.y=634;addChild(decoration);
   var b:ClassicActionButton=button(id=="train"?"team-training":"team-"+id,caption,x,666,96,42,function():void{go(id);},id=="skills"?0xb48631:id=="train"?0x7a9d37:0x327ea2);if(id=="train")train=b;if(id=="skills")skills=b;
  }
  public function dispose():void {
   if(dead)return;dead=true;clearTiles();clearProfile();for each(var marker:Object in markers)if(marker.portrait)CharacterPortrait(marker.portrait).dispose();markers=[];
   for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}controls=[];hud.dispose();fieldArt.dispose();callbacks={};selected=null;
  }
 }
}
