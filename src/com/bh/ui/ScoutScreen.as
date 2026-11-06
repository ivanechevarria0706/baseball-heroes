package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.*;import flash.utils.getTimer;
 import com.bh.model.*;import com.bh.visual.*;
 /** An illustrated prospect desk. The model still owns draw prices and permanent signings. */
 public class ScoutScreen extends Sprite {
  private var back:Function,team:Function,friends:Function,stadium:MatchStadium,hud:MatchResourceBar;
  private var board:Sprite=new Sprite(),preview:Sprite=new Sprite(),recent:Sprite=new Sprite(),tiles:Array=[],finds:Array=[],controls:Array=[],pictures:Array=[],previewArt:Array=[],recentArt:Array=[];
  private var coins:TextField,notice:TextField,signButton:ClassicActionButton,goldButton:ClassicActionButton,selected:Object,dead:Boolean=false,leaving:Boolean=false,animation:Object,focusTile:Sprite;
  private var after:int=0;
  public function ScoutScreen(w:Number,h:Number,homeCallback:Function,teamCallback:Function,friendsCallback:Function=null){
   name="scouting-desk";back=homeCallback;team=teamCallback;friends=friendsCallback;GameData.init();MLBNormalPlayers.resetOffers();
   stadium=new MatchStadium(w,h);addChild(stadium);graphics.beginFill(0x092338,.75);graphics.drawRect(0,0,w,h);graphics.endFill();
   var shade:Shape=new Shape();shade.graphics.beginFill(0x092338,.66);shade.graphics.drawRect(0,57,w,h-57);shade.graphics.endFill();addChild(shade);
   hud=new MatchResourceBar(960,true);addChild(hud);title("SCOUTING OFFICE",35,68,690,42,30);button("draft-home","HOME",826,72,107,35,goHome,0x426f8b);if(friends!=null)button("draft-friends","FRIEND DRAFT",657,72,158,35,goFriends,0x3a88aa);
   var panels:Shape=new Shape();ClassicChrome.panel(panels.graphics,20,118,548,505);ClassicChrome.panel(panels.graphics,581,118,359,505);ClassicChrome.panel(panels.graphics,20,632,548,69);ClassicChrome.panel(panels.graphics,581,632,359,69);addChild(panels);
   title("PROSPECT BOARD",42,127,309,32,21);label(this,"BRONZE PICK",364,132,178,21,12,0xffe49a,"right");label(this,"5,000 Coins per reveal",336,155,206,21,11,0xd9f2ff,"right");
   label(this,"Elige una ficha para descubrir un compañero permanente.",42,166,498,24,12,0xd5efff);
   addChild(board);for(var i:int=0;i<25;i++)makeTile(i);
   notice=label(this,"Los candidatos revelados siguen disponibles durante esta visita.",40,591,506,27,11,0xffeab5);notice.name="draft-notice";
   title("PROSPECT FILE",600,129,320,31,22);addChild(preview);preview.x=596;preview.y=173;
   signButton=button("draft-sign","SIGN PLAYER",597,562,155,43,sign,0x77b237);button("draft-team","MY TEAM",766,562,155,43,goTeam,0x3a88aa);
   label(this,"RECENT FINDS",33,636,130,18,9,0x9adcf6);addChild(recent);
   art(this,"gold",594,641,60,53);goldButton=button("draft-gold","GOLD PICK  20,000",661,643,266,44,gold,0xc6902b);
   if(GameData.lastScouted&&!owned(GameData.lastScouted)){finds.push(GameData.lastScouted);showCandidate(GameData.lastScouted);notice.text="Tu último candidato ya está pagado. Puedes ficharlo sin volver a comprar.";}else empty();
   renderRecent();refresh();addEventListener(Event.ENTER_FRAME,tick);
  }
  private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,align:String="left"):TextField{var t:TextField=ClassicInventorySkin.text(parent,value,x,y,w,h,size,color,align);LineupTypography.fit(t,size,color,align,false,9);return t;}
  private function title(value:String,x:Number,y:Number,w:Number,h:Number,size:int):void{ClassicChrome.title(label(this,value,x,y,w,h,size),size);}
  private function art(parent:Sprite,key:String,x:Number,y:Number,w:Number,h:Number,local:Array=null):RecruitmentArtwork{var a:RecruitmentArtwork=new RecruitmentArtwork(key,w,h);a.x=x;a.y=y;parent.addChild(a);(local||pictures).push(a);return a;}
  private function button(id:String,value:String,x:Number,y:Number,w:Number,h:Number,fn:Function,color:uint):ClassicActionButton{
   var b:ClassicActionButton=new ClassicActionButton(value,w,h,color);b.name=id;b.x=x;b.y=y;addChild(b);var f:Function=function(e:MouseEvent):void{if(!dead&&!leaving&&getTimer()>=after&&b.mouseEnabled)fn();};b.addEventListener(MouseEvent.CLICK,f);controls.push({view:b,fn:f});return b;
  }
  private function owned(p:Object):Boolean{return p&&MLBNormalPlayers.owned(int(p.mlbId));}
  private function enabled(b:ClassicActionButton,value:Boolean):void{b.mouseEnabled=b.buttonMode=b.useHandCursor=value;b.alpha=value?1:.48;}
  private function refresh():void{hud.refresh();enabled(signButton,selected&&!owned(selected)&&GameData.roster.length<30&&!animation);enabled(goldButton,GameData.coins>=20000&&GameData.roster.length<30&&!animation);for each(var t:Object in tiles)t.view.alpha=t.candidate||GameData.coins>=5000&&GameData.roster.length<30?1:.55;}
  private function makeTile(i:int):void{
   var s:Sprite=new Sprite();s.name="draft-tile-"+i;s.x=41+(i%5)*103;s.y=199+int(i/5)*77;s.mouseChildren=false;s.buttonMode=s.useHandCursor=true;board.addChild(s);
   var pivot:Sprite=new Sprite();pivot.x=48;s.addChild(pivot);var backFace:Sprite=new Sprite();backFace.x=-48;pivot.addChild(backFace);art(backFace,"bronze",0,0,96,68);
   var n:TextField=label(backFace,String(i+1),68,43,22,18,10,0xffffff,"center");n.name="draft-number-"+i;
   var item:Object={view:s,pivot:pivot,back:backFace,front:null,candidate:null,index:i};tiles.push(item);
   var handler:Function=function(e:MouseEvent):void{if(dead||leaving||animation||getTimer()<after)return;if(item.candidate){selectTile(item);showCandidate(item.candidate);}else reveal(item);};s.addEventListener(MouseEvent.CLICK,handler);controls.push({view:s,fn:handler});
  }
  private function selectTile(item:Object):void{for each(var t:Object in tiles){t.view.graphics.clear();if(t===item){t.view.graphics.lineStyle(2,0xffe68a);t.view.graphics.drawRoundRect(-1,-2,98,73,8);t.view.graphics.lineStyle();}}}
  private function renderFace(item:Object):void{
   if(item.front){item.pivot.removeChild(item.front);}var front:Sprite=new Sprite();front.x=-48;item.pivot.addChild(front);item.front=front;
   art(front,"bronze",0,0,96,68);var namePlate:Shape=new Shape();ClassicChrome.well(namePlate.graphics,35,8,60,47,false,true);front.addChild(namePlate);
   var portrait:CharacterPortrait=new CharacterPortrait(item.candidate,38,49,true);portrait.x=1;portrait.y=11;front.addChild(portrait);pictures.push(portrait);
   label(front,lastName(item.candidate.name),38,11,54,21,10,0x25465c,"center");label(front,"OVR "+item.candidate.rating,38,35,54,18,9,0x237032,"center");
   if(owned(item.candidate)){art(front,"signed",65,43,30,24);front.name="draft-signed-"+item.index;}
  }
  private function lastName(value:String):String{var a:Array=value.split(" ");return a.length>1?a.slice(1).join(" "):value;}
  private function blocked(cost:int):Boolean{if(GameData.roster.length>=30){notice.text="Tu plantilla está llena. Libera una plaza antes de seguir buscando.";return true;}if(GameData.coins<cost){notice.text="Necesitas "+String(cost)+" Coins para esta búsqueda.";return true;}return false;}
  private function reveal(item:Object):void{
   if(blocked(5000))return;var p:Object=GameData.scout("BRONZE");if(!p){notice.text="No hay candidatos disponibles ahora. Revisa tu plantilla y vuelve a intentarlo.";return;}
   item.candidate=p;finds.push(p);renderFace(item);item.front.visible=false;selectTile(item);animation={item:item,start:getTimer()};after=getTimer()+320;showCandidate(p);renderRecent();refresh();
  }
  private function gold():void{if(blocked(20000))return;after=getTimer()+320;var p:Object=GameData.scout("GOLD");if(!p){notice.text="No hay candidatos disponibles para GOLD PICK.";return;}finds.push(p);showCandidate(p);renderRecent();refresh();}
  private function clearArt(list:Array):void{for each(var p:Object in list)p.dispose();list.length=0;}
  private function clearPreview():void{clearArt(previewArt);while(preview.numChildren)preview.removeChildAt(0);preview.graphics.clear();}
  private function empty():void{selected=null;clearPreview();art(preview,"coach-welcome",52,8,229,255,previewArt);label(preview,"YOUR NEXT TEAMMATE",0,273,328,27,18,0xffe7a1,"center");label(preview,"Elige una ficha Bronze o usa Gold Pick.\nAquí verás al jugador y sus atributos antes de ficharlo.",12,311,303,61,13,0xd7eef9,"center");enabled(signButton,false);}
  private function showCandidate(p:Object):void{
   if(!p||dead)return;selected=p;clearPreview();
   var nameText:TextField=label(preview,String(p.name),0,0,328,45,23,0xffffff,"center");nameText.name="draft-candidate-name";
   label(preview,String(p.pos)+"   ·   NORMAL PLAYER",0,45,328,22,12,0xffe38a,"center");
   ClassicChrome.well(preview.graphics,0,74,178,236,false,true);var actor:MLBPlayerArtwork=new MLBPlayerArtwork(p,170,226);actor.x=4;actor.y=79;preview.addChild(actor);previewArt.push(actor);
   var traits:Array=[["POWER",p.power,0xe28e54],["CONTACT",p.contact,0x73c9f1],["SPEED",p.speed,0x9bdc72],["LUCK",p.luck===undefined?50:p.luck,0xf1d264]];
   for(var i:int=0;i<traits.length;i++){var y:Number=86+i*50;label(preview,traits[i][0],194,y,122,18,10,0xc5eaf5);label(preview,String(traits[i][1]),194,y+16,122,28,21,uint(traits[i][2]),"right");ClassicChrome.bar(preview.graphics,194,y+43,122,5);ClassicInventorySkin.gradient(preview.graphics,195,y+44,Math.max(2,120*Math.min(1,Number(traits[i][1])/100)),3,uint(traits[i][2]),0x385b72,3);}
   label(preview,"OVR "+p.rating,194,289,122,27,20,0xffe694,"right");label(preview,String(p.realTeam||"MLB 2026"),2,317,324,23,12,0xdaf1fc,"center");
   label(preview,owned(p)?"IN YOUR CLUB":"PERMANENT TEAMMATE",0,345,328,24,15,owned(p)?0xaff282:0xffe3a0,"center");
   notice.text=owned(p)?"Este jugador ya está en tu plantilla. No necesitas volver a ficharlo.":"La búsqueda ya está pagada. Pulsa SIGN PLAYER para añadirlo a los suplentes.";refresh();
  }
  private function renderRecent():void{
   clearArt(recentArt);while(recent.numChildren){var old:DisplayObject=recent.removeChildAt(0);old.removeEventListener(MouseEvent.CLICK,recentClick);}
   var start:int=Math.max(0,finds.length-4);for(var i:int=start;i<finds.length;i++){
    var p:Object=finds[i],s:Sprite=new Sprite();s.x=34+(i-start)*131;s.y=657;s.name="draft-recent-"+i;s.mouseChildren=false;s.buttonMode=true;recent.addChild(s);ClassicChrome.well(s.graphics,0,0,125,36,false,true);
    var face:CharacterPortrait=new CharacterPortrait(p,32,34,true);face.x=1;face.y=1;s.addChild(face);recentArt.push(face);label(s,lastName(p.name),37,1,84,19,10,0x315165);label(s,owned(p)?"SIGNED":"OVR "+p.rating,37,18,84,17,9,0x2b783e);
    s.addEventListener(MouseEvent.CLICK,recentClick);s["mouseEnabled"]=true;
   }
  }
  private function recentClick(e:MouseEvent):void{if(dead||leaving||animation||getTimer()<after)return;var n:int=int(String(e.currentTarget.name).replace("draft-recent-",""));showCandidate(finds[n]);}
  private function sign():void{if(!selected||owned(selected)||animation)return;after=getTimer()+320;GameData.lastScouted=selected;if(GameData.signScouted()){notice.text=selected.name+" ya está en tus suplentes.";for each(var t:Object in tiles)if(t.candidate===selected)renderFace(t);renderRecent();showCandidate(selected);}else notice.text="No se pudo fichar. Revisa si tu plantilla está llena.";refresh();}
  private function tick(e:Event):void{if(dead||!animation)return;var item:Object=animation.item,p:Number=Math.min(1,(getTimer()-animation.start)/320);item.pivot.scaleX=Math.max(.035,Math.abs(Math.cos(p*Math.PI)));item.back.visible=p<.5;item.front.visible=p>=.5;if(p>=1){item.pivot.scaleX=1;item.back.visible=false;item.front.visible=true;animation=null;refresh();}}
  private function goFriends():void{if(leaving)return;leaving=true;if(friends!=null)friends();}
  private function goHome():void{if(leaving)return;leaving=true;if(back!=null)back();}
  private function goTeam():void{if(leaving)return;leaving=true;if(team!=null)team();}
  public function dispose():void{if(dead)return;dead=true;removeEventListener(Event.ENTER_FRAME,tick);animation=null;for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.fn);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}controls=[];for(var i:int=0;i<recent.numChildren;i++)recent.getChildAt(i).removeEventListener(MouseEvent.CLICK,recentClick);clearArt(pictures);clearArt(previewArt);clearArt(recentArt);stadium.dispose();hud.dispose();back=team=friends=null;}
 }
}
