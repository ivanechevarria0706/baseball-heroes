package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.*;
 import com.bh.online.OnlineClient;import com.bh.model.*;import com.bh.visual.FriendDraftPortrait;
 /** Recruitment uses accepted account friendships, never unaccepted search results. */
 public class FriendLineupOverlay extends Sprite {
  private var body:Sprite=new Sprite(),api:OnlineClient=new OnlineClient(),closeAction:Function,changed:Function;
  private var controls:Array=[],portraits:Array=[],people:Array=[],page:int=0,alive:Boolean=true,loading:Boolean=true,notice:String="",useAction:Function,targetSlot:int;
  public function FriendLineupOverlay(onClose:Function,onChanged:Function,onUse:Function=null,slot:int=-1){
   name="friend-lineup-overlay";closeAction=onClose;changed=onChanged;useAction=onUse;targetSlot=slot;graphics.beginFill(0x031827,.84);graphics.drawRect(0,0,960,720);graphics.endFill();addChild(body);
   addEventListener(MouseEvent.CLICK,block);addEventListener(MouseEvent.MOUSE_DOWN,block);refresh();
  }
  private function block(e:MouseEvent):void{e.stopPropagation();}
  private function label(s:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint=0xffffff):TextField{return ClassicInventorySkin.text(body,s,x,y,w,h,size,color,"left",size>22);}
  private function button(s:String,id:String,x:Number,y:Number,w:Number,fn:Function,enabled:Boolean=true):void{
   var b:Sprite=ClassicInventorySkin.button(s,w,34,0x6ba52a);b.name=id;b.x=x;b.y=y;b.mouseChildren=false;b.buttonMode=b.mouseEnabled=enabled;b.alpha=enabled?1:.5;body.addChild(b);
   var cb:Function=function(e:MouseEvent):void{e.stopImmediatePropagation();if(alive&&enabled)fn();};b.addEventListener(MouseEvent.CLICK,cb);controls.push({b:b,cb:cb});
  }
  private function clear():void{for each(var c:Object in controls){c.b.removeEventListener(MouseEvent.CLICK,c.cb);if(c.b is ClassicActionButton)ClassicActionButton(c.b).dispose();}controls=[];for each(var p:FriendDraftPortrait in portraits)p.dispose();portraits=[];while(body.numChildren)body.removeChildAt(0);body.graphics.clear();}
  private function refresh():void{
   loading=true;notice="Cargando amigos aceptados…";render();
   if(!api.user){loading=false;notice="Inicia sesión para cargar a tus amigos.";render();return;}
   api.request("GET","/social",null,function(data:Object):void{if(!alive)return;GameData.applySocialSnapshot(data);if(changed!=null)changed();people=FriendRoster.list();loading=false;notice="";render();},function(message:String,code:int):void{if(!alive)return;loading=false;notice="No se pudieron actualizar los amigos. Pulsa REFRESH para reintentar.";render();});
  }
  private function recruit(id:String):void{
   var result:Object=GameData.recruitFriend(id);
   notice=result.status=="OK"?"Amigo incorporado a SUBSTITUTE. Cierra esta ventana y arrástralo al puesto que prefieras.":result.status=="OWNED"?"Este amigo ya está en tu equipo.":result.status=="ROSTER_FULL"?"Tu plantilla tiene 30 jugadores. Libera un puesto antes de reclutar.":result.status=="MATCH_ACTIVE"?"Termina el partido pendiente antes de incorporar jugadores.":result.status=="NOT_READY"?"Tu amigo debe terminar de crear su personaje primero.":"Actualiza la lista: solo puedes incorporar amigos aceptados.";
   if(result.status=="OK"&&changed!=null)changed(result.player);render();
  }
  private function render():void{
   clear();ClassicChrome.panel(body.graphics,76,65,808,594);ClassicChrome.bar(body.graphics,84,73,792,55);
   label("FRIENDS IN YOUR LINEUP",102,82,619,40,28);button("CLOSE","friend-lineup-close",744,84,114,function():void{if(closeAction!=null)closeAction();});
   label("Incorpora a tus amigos aceptados al banco y usa los mismos controles que con tus otros jugadores.",101,140,756,44,15,0xd4eef6);
   var pages:int=Math.max(1,Math.ceil(people.length/5));page=Math.max(0,Math.min(page,pages-1));
   for(var i:int=page*5;i<Math.min(people.length,page*5+5);i++)row(people[i],196+(i%5)*68);
   if(!loading&&!people.length)label("Todavía no tienes amigos aceptados. Agrégalos desde HOME → FRIENDS; después vuelve aquí.",135,281,686,110,20,0xffe397);
   button("<","friend-lineup-prev",103,547,52,function():void{page--;render();},!loading&&page>0);label((page+1)+" / "+pages,177,550,154,30,15);
   button(">","friend-lineup-next",279,547,52,function():void{page++;render();},!loading&&page<pages-1);button("REFRESH","friend-lineup-refresh",702,547,152,refresh,!loading);
   var currentOrder:Array=GameData.visibleLineupPlayers(),heroSelected:Boolean=targetSlot>=0&&targetSlot<currentOrder.length&&currentOrder[targetSlot]===GameData.mainPlayer();
   var msg:TextField=label(notice|| (heroSelected?"Elegiste el puesto del héroe. Cierra esta ventana y selecciona otra fila de LINEUP para colocar a tu amigo.":"USE IN # coloca al amigo en el puesto elegido. Tus partidos no alteran la carrera de tu amigo."),103,596,751,49,13,0xffe397);msg.wordWrap=msg.multiline=true;msg.name="friend-lineup-message";
  }
  private function row(m:Object,y:Number):void{
   var owned:Object=GameData.friendPlayer(String(m.id)),active:Boolean=false;for each(var p:Object in GameData.visibleLineupPlayers())if(p.friendId===m.id)active=true;
   var order:Array=GameData.visibleLineupPlayers(),heroSlot:Boolean=targetSlot>=0&&targetSlot<order.length&&order[targetSlot]===GameData.mainPlayer(),canUse:Boolean=owned&&!active&&!heroSlot&&targetSlot>=0&&useAction!=null;
   ClassicChrome.well(body.graphics,101,y,754,61,owned!=null,true);
   var portrait:FriendDraftPortrait=new FriendDraftPortrait(m,48,52);portrait.x=109;portrait.y=y+4;body.addChild(portrait);portraits.push(portrait);
   var title:TextField=label(String(m.name),174,y+5,434,28,18,0x254a5b);LineupTypography.fit(title,18,0x254a5b,"left",false,11);
   label("LV "+int(m.profile.level||1)+(owned?active?"  ·  IN LINEUP":"  ·  ON BENCH":"  ·  FRIEND"),175,y+34,430,22,12,0x426b78);
   var id:String=String(m.id);button(owned?active?"IN LINEUP":heroSlot?"CHOOSE SLOT":canUse?"USE IN #"+(targetSlot+1):"RECRUITED":"RECRUIT","friend-recruit-"+id,660,y+13,181,function():void{if(owned){if(canUse)useAction(owned);}else recruit(id);},!loading&&(canUse||!owned&&m.profile.heroReady===true));
   if(m.profile.heroReady!==true)label("Character not ready",476,y+36,172,19,10,0x8c4932);
  }
  public function dispose():void{if(!alive)return;alive=false;api.dispose();clear();removeEventListener(MouseEvent.CLICK,block);removeEventListener(MouseEvent.MOUSE_DOWN,block);closeAction=changed=useAction=null;}
 }
}
