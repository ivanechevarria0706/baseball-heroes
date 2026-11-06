package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;
    import com.bh.online.*;import com.bh.model.GameData;import com.bh.visual.*;
    import flash.utils.Timer;
    /** Account-backed recruitment, gifts and inbox. Previewing never sends an action. */
    public class SocialScreen extends Sprite {
        private var api:OnlineClient,back:Function,body:Sprite=new Sprite(),hud:MatchResourceBar;
        private var state:Object,tab:String="FRIENDS",page:int=0,playerIndex:int=0,chosenFriend:String="";
        private var query:String="",target:String="",search:TextField,shareField:TextField,sharing:Boolean=false,visitFriend:Function,poll:Timer;
        private var status:TextField,alive:Boolean=true,loading:Boolean=false,retryAllowed:Boolean=false;
        private var pendingPath:String,pending:Object,notice:String="",review:Object;
        private var controls:Array=[],art:Array=[];
        public function SocialScreen(client:OnlineClient,onBack:Function,initialTab:String="FRIENDS",inviteTarget:String="",onVisit:Function=null) {
            api=client;back=onBack;tab=initialTab;target=inviteTarget;query=target;visitFriend=onVisit;name="social-screen";
            TravelMapArtwork.drawBackdrop(graphics,960,720);addChild(body);refresh();
            poll=new Timer(10000);poll.addEventListener(TimerEvent.TIMER,pollFriends);poll.start();
        }
        private function text(value:String,x:Number,y:Number,w:Number,h:Number=28,size:int=15,color:uint=0xffffff,align:String="left"):TextField {return ClassicInventorySkin.text(body,value,x,y,w,h,size,color,align,size>=22);}
        private function button(value:String,id:String,x:Number,y:Number,w:Number,fn:Function,color:uint=0x287aad,enabled:Boolean=true,h:Number=34):Sprite {
            var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.x=x;b.y=y;b.name=id;b.mouseEnabled=b.buttonMode=enabled;b.alpha=enabled?1:.45;body.addChild(b);
            var handler:Function=function(e:MouseEvent):void{if(alive&&!loading&&enabled)fn();};b.addEventListener(MouseEvent.CLICK,handler);controls.push({view:b,handler:handler});return b;
        }
        private function release():void {
            if(search){search.removeEventListener(Event.CHANGE,onSearch);search=null;}shareField=null;
            for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}controls=[];
            for each(var a:Object in art)a.dispose();art=[];if(hud){hud.dispose();hud=null;}while(body.numChildren)body.removeChildAt(0);body.graphics.clear();status=null;
        }
        private function clear():void {
            release();hud=new MatchResourceBar(960,true);body.addChild(hud);
            ClassicChrome.panel(body.graphics,20,68,920,635);ClassicChrome.bar(body.graphics,28,76,904,49);
            icon("scout",37,84,41,32);text("FRIENDS",89,80,590,39,27);button("CLOSE","social-close",831,83,94,exit,0xb5403d);
            status=text(notice,40,654,880,40,12,0xffe58b);status.name="social-status";
        }
        private function refresh():void {if(!alive||api.busy)return;if(pending){transmit();return;}review=null;loading=true;notice="Cargando amigos y bandeja…";clear();api.request("GET","/social",null,received,error);}
        private function received(data:Object):void {
            if(!alive)return;var path:String=pendingPath;state=data;loading=false;pending=null;pendingPath=null;review=null;retryAllowed=false;GameData.applySocialSnapshot(data);
            notice=path=="/social/gift"?"Regalo enviado y guardado. Tu amigo puede recogerlo cuando se conecte.":path=="/social/claim"?"Premio recogido y guardado en tu cuenta.":path=="/social/add"||path=="/social/register"?"Solicitud guardada. Tu amigo puede aceptarla aquí mismo, en FRIENDS.":path=="/social/accept"||path=="/social/friend/accept"?"¡Ya son amigos! Pueden visitarse y enviarse regalos.":"";
            if(target==state.userId){query="";notice="Este es tu propio enlace. Usa SHARE LINK para enviárselo a un amigo.";}target="";render();
        }
        private function render():void {
            clear();var incoming:int=0;for each(var l:Object in state.links)if(l.friend==state.userId&&l.status=="pending")incoming++;for each(var g:Object in state.gifts)if(!g.claimed)incoming++;
            for each(var request:Object in state.requests)if(request.receiver==state.userId&&request.status=="pending")incoming++;
            tabButton("FRIENDS","social-tab-friends",35,206);tabButton("GIFTS","social-tab-gifts",260,206);tabButton("INBOX","social-tab-inbox",485,206,incoming);tabButton("BATTER LINKS","social-tab-register",710,214);
            button("REFRESH","social-refresh",789,612,135,refresh,0x426f85,true,30);
            if(tab=="FRIENDS")quickFriends();else if(tab=="REGISTER")register();else if(tab=="GIFTS")gifts();else inbox();
            if(!notice)status.text=tab=="FRIENDS"?"Busca a tu amigo y pulsa ADD FRIEND. Las solicitudes aparecen aquí; no necesitan publicar equipos.":tab=="REGISTER"?"Vincular un bateador es opcional; no es necesario para agregar amigos.":tab=="GIFTS"?"Un regalo gratis por amigo al día (UTC). Revísalo antes de enviarlo.":"Recoger un regalo lo guarda una sola vez, incluso después de recargar.";
            if(review)drawReview();
            if(retryAllowed)drawRetry();
            if(sharing)drawShare();
        }
        private function pollFriends(e:TimerEvent):void {if(alive&&state&&tab=="FRIENDS"&&!loading&&!sharing&&!review&&!pending&&(!stage||stage.focus!=search))refresh();}
        private function relationship(id:String):Object {
            for each(var r:Object in state.requests)if(r.status=="pending"&&(r.requester==id||r.receiver==id))return r;
            for each(var l:Object in state.links)if(l.status=="pending"&&((l.owner==state.userId&&l.friend==id)||(l.friend==state.userId&&l.owner==id)))return {legacy:true,owner:l.owner,player:l.player,incoming:l.friend==state.userId};
            return null;
        }
        private function quickFriends():void {
            ClassicChrome.well(body.graphics,39,185,648,38,false,true);
            var displayQuery:String=query;if(/^[a-f0-9]{32}$/.test(query))for each(var candidate:Object in state.members)if(candidate.id==query)displayQuery=String(candidate.name);
            search=new TextField();search.name="social-search";search.type=TextFieldType.INPUT;search.x=51;search.y=190;search.width=622;search.height=28;search.maxChars=256;search.defaultTextFormat=new TextFormat("Arial",16,0x24465a);search.text=displayQuery;search.selectable=true;body.addChild(search);search.addEventListener(Event.CHANGE,onSearch);
            if(!displayQuery.length)text("Search name or paste a friend link",53,191,610,27,15,0x758d99);
            button("SHARE LINK","social-share",704,187,220,showShare,0x65a62c);
            var value:String=query.replace(/^\s+|\s+$/g,"").toLowerCase(),match:Array=/[?&]friend=([a-f0-9]{32})/i.exec(value);if(match)value=String(match[1]);
            var list:Array=[];for each(var m:Object in state.members)if(m.id!=state.userId&&(!value||String(m.name).toLowerCase().indexOf(value)>=0||m.id==value))list.push(m);
            list.sort(function(a:Object,b:Object):Number{var ap:int=relationship(a.id)&&!a.connected?0:a.connected?1:2,bp:int=relationship(b.id)&&!b.connected?0:b.connected?1:2;return ap!=bp?ap-bp:String(a.name).toLowerCase()<String(b.name).toLowerCase()?-1:1;});
            var pages:int=Math.max(1,Math.ceil(list.length/5));page=Math.max(0,Math.min(page,pages-1));
            for(var i:int=page*5;i<Math.min(list.length,page*5+5);i++)quickRow(list[i],236+(i%5)*70);
            if(!list.length)text(value?"NO PLAYERS FOUND":"INVITE YOUR FIRST FRIEND",120,302,720,42,26,0xffe58b,"center");
            if(!list.length)text(value?"Revisa el nombre o pega el enlace de tu amigo.":"Pulsa SHARE LINK y envíaselo. Puede crear su cuenta y agregarte desde el enlace.",150,358,660,91,17,0xdaf1ff,"center");
            pager(pages,40,601,700);
        }
        private function onSearch(e:Event):void {if(loading)return;var caret:int=search.caretIndex;query=search.text;page=0;notice="";render();if(stage){stage.focus=search;search.setSelection(caret,caret);}}
        private function quickRow(m:Object,y:Number):void {
            ClassicChrome.well(body.graphics,39,y,883,65,m.connected===true,true);face(m,44,y+5,52,55);text(m.name,110,y+5,417,27,19,0x294c5e);
            text(m.connected?"FRIEND":m.team?String(m.team.name):"Cuenta disponible · no requiere publicar equipo",110,y+34,510,23,12,0x45606f);
            var r:Object=relationship(String(m.id));
            if(m.connected){button(GameData.friendPlayer(String(m.id))?"RECRUITED":"RECRUIT","social-quick-recruit-"+m.id,535,y+16,114,function():void{var result:Object=GameData.recruitFriend(String(m.id));notice=result.status=="OK"?"Amigo incorporado a SUBSTITUTE. Puedes colocarlo en LINEUP.":result.status=="ROSTER_FULL"?"Tu plantilla está llena (30 jugadores).":result.status=="MATCH_ACTIVE"?"Termina el partido pendiente primero.":"Tu amigo debe crear su personaje primero.";render();},0x6ba52a,!GameData.friendPlayer(String(m.id))&&m.profile.heroReady===true);button("GIFTS","social-quick-gift-"+m.id,658,y+16,128,function():void{chosenFriend=m.id;tab="GIFTS";page=0;notice="";render();},0x287aad);button(m.team?"VISIT":"FRIEND","social-quick-visit-"+m.id,792,y+16,118,function():void{if(visitFriend!=null)visitFriend(String(m.id));},0x6ba52a,m.team&&visitFriend!=null);}
            else if(r&&(r.legacy?r.incoming:r.receiver==state.userId)){button("ACCEPT","social-quick-accept-"+m.id,652,y+16,128,function():void{reply(r,true);},0x6ba52a);button("REJECT","social-quick-reject-"+m.id,792,y+16,118,function():void{reply(r,false);},0xb24f43);}
            else if(r){text("REQUEST SENT",579,y+19,178,27,12,0x6b592b,"center");button("CANCEL","social-quick-cancel-"+m.id,792,y+16,118,function():void{if(r.legacy)mutate("/social/remove",{owner:r.owner,player:r.player});else mutate("/social/friend/cancel",{friendship:r.id});},0x6f8290);}
            else button("ADD FRIEND","social-add-"+m.id,702,y+16,208,function():void{mutate("/social/add",{friend:m.id});},0x6ba52a);
        }
        private function reply(r:Object,accept:Boolean):void {if(r.legacy)mutate(accept?"/social/accept":"/social/reject",{owner:r.owner,player:r.player});else mutate(accept?"/social/friend/accept":"/social/friend/reject",{friendship:r.id});}
        private function showShare():void {sharing=true;review=null;render();FriendInvite.copy(shareField.text);if(stage){stage.focus=shareField;shareField.setSelection(0,shareField.text.length);}}
        private function drawShare():void {
            var shield:Sprite=new Sprite();shield.name="social-share-panel";shield.graphics.beginFill(0x061b2d,.9);shield.graphics.drawRect(25,179,910,466);shield.graphics.endFill();body.addChild(shield);var plate:Sprite=new Sprite();ClassicChrome.panel(plate.graphics,91,238,778,318);body.addChild(plate);
            text("PLAY WITH YOUR FRIENDS",116,255,728,43,28,0xffe79a,"center");text("Envía este enlace a tu amigo. Al entrar podrá agregarte; tú aceptas la solicitud aquí.",123,309,714,49,16,0xe5f5ff,"center");
            ClassicChrome.well(plate.graphics,117,373,726,45,false,true);shareField=new TextField();shareField.name="social-share-value";shareField.defaultTextFormat=new TextFormat("Arial",14,0x254a5b);shareField.text=FriendInvite.link(api.baseURL,String(state.userId));shareField.x=127;shareField.y=382;shareField.width=706;shareField.height=28;shareField.selectable=true;body.addChild(shareField);
            text("El enlace está listo. Si no se copió, selecciónalo y usa Ctrl+C.",124,430,712,35,14,0xcdeeff,"center");button("COPY LINK","social-share-copy",164,488,290,function():void{FriendInvite.copy(shareField.text);if(stage){stage.focus=shareField;shareField.setSelection(0,shareField.text.length);}},0x6ba52a);button("DONE","social-share-done",494,488,290,function():void{sharing=false;render();},0x426f85);
        }
        private function tabButton(value:String,id:String,x:Number,w:Number,count:int=0):void {button(value+(count?" ("+count+")":""),id,x,134,w,function():void{tab=value;page=0;review=null;notice="";render();},tab==value?0x2da2c9:0x426f85,true,36);}
        private function icon(kind:String,x:Number,y:Number,w:Number,h:Number):void {var a:Sprite=(kind=="scout"||kind=="batter")?new RecruitmentArtwork(kind=="scout"?"friends":"roster",w,h):InventoryArtwork.supports(kind)?new InventoryArtwork(kind,w,h):new InterfaceSprite(kind,w,h);a.x=x;a.y=y;body.addChild(a);}
        private function face(m:Object,x:Number,y:Number,w:Number,h:Number):void {
            ClassicChrome.well(body.graphics,x,y,w,h,false,true);
            if(m.profile){var p:Object=m.profile,head:HeroHead=new HeroHead(p.appearance||{},HomeSprite.paletteFor(m.name,uint(p.accent||0x247ab2),p.appearance||{},{}));head.scaleX=head.scaleY=Math.min(w/150,h/175);head.x=x+w/2;head.y=y+h-2;body.addChild(head);art.push(head);}
            else icon("scout",x+5,y+7,w-10,h-14);
        }
        private function ownPlayers():Array {var out:Array=[];for each(var m:Object in state.members)if(m.id==state.userId&&m.team)for(var i:int=0;i<m.team.players.length;i++)if(i!=m.team.heroIndex)out.push(m.team.players[i]);return out;}
        private function memberName(id:String):String {for each(var m:Object in state.members)if(m.id==id)return String(m.name);return "Friend";}
        private function playerName(owner:String,id:String):String {for each(var m:Object in state.members)if(m.id==owner&&m.team)for each(var p:Object in m.team.players)if(p.id==id)return String(p.name);return "Regular batter";}
        private function register():void {
            var players:Array=ownPlayers();if(!players.length){empty("PUBLISH YOUR LINEUP","Publica primero tu alineación en RIVAL para vincular a tus compañeros con amigos.","batter");return;}
            playerIndex%=players.length;var p:Object=players[playerIndex],link:Object=null;
            for each(var l:Object in state.links)if(l.owner==state.userId&&l.player==p.id)link=l;
            ClassicChrome.panel(body.graphics,35,190,357,432);ClassicChrome.bar(body.graphics,43,198,341,37);text("REGULAR BATTER",52,204,320,27,18,0xffffff,"center");
            var local:Object;for each(var r:Object in GameData.roster)if(r.socialId==p.id)local=r;
            var portrait:CharacterPortrait=new CharacterPortrait(local||p,116,117,true);portrait.x=155;portrait.y=246;body.addChild(portrait);art.push(portrait);
            text(p.name,63,367,300,33,24,0xffe89d,"center");button("‹","social-player-prev",56,287,49,function():void{playerIndex=(playerIndex+players.length-1)%players.length;notice="";render();});button("›","social-player-next",322,287,49,function():void{playerIndex++;notice="";render();});
            text((playerIndex+1)+" / "+players.length+"   ·   "+(link?link.status=="accepted"?"REGISTERED":"REQUEST PENDING":"CHOOSE A FRIEND"),50,409,327,28,12,0xc9eeff,"center");
            ClassicChrome.well(body.graphics,49,447,329,111,false,true);icon("scout",62,465,63,62);text("¿QUÉ GANAS?",136,456,230,26,16,0x335971);text("Añade el 5% de su promedio.\nMás capacidad de equipo.\nCrecimiento más rápido.",136,484,230,67,12,0x354c55);
            if(link)button("REMOVE LINK","social-remove",52,575,323,function():void{mutate("/social/remove",{owner:state.userId,player:p.id});},0xa64d41);
            else text("Elige un amigo a la derecha.\nLa solicitud no modifica tus jugadores.",55,574,317,43,12,0xcdeaf4,"center");
            var members:Array=[];for each(var m:Object in state.members)if(m.id!=state.userId&&m.team)members.push(m);members.sortOn("name",Array.CASEINSENSITIVE);
            var pages:int=Math.max(1,Math.ceil(members.length/5));page=Math.max(0,Math.min(page,pages-1));text("FRIENDS & PUBLISHED TEAMS",419,183,486,25,14,0xffe58b);
            for(var i:int=page*5;i<Math.min(members.length,page*5+5);i++)friendRow(members[i],p,419,212+(i%5)*74);
            if(!members.length)text("Tus amigos aparecerán aquí cuando publiquen su alineación.",448,323,425,110,19,0xcdeeff,"center");pager(pages,419,594,486);
        }
        private function friendRow(m:Object,p:Object,x:Number,y:Number):void {
            ClassicChrome.well(body.graphics,x,y,486,68,m.connected===true,true);face(m,x+5,y+5,56,58);text(m.name,x+70,y+4,250,26,18,0x254a5b);text(String(m.team.name),x+70,y+30,250,20,11,0x385563);text(m.connected?"FRIEND  ·  AVG "+(Number(m.profile.avg)/1000).toFixed(3):"PUBLISHED LINEUP",x+70,y+48,250,17,10,0x327c35);
            var link:Object;for each(var l:Object in state.links)if(l.owner==state.userId&&(l.friend==m.id||l.player==p.id))link=l;
            if(!link)button("REGISTER","social-register-"+m.id,x+332,y+19,143,function():void{mutate("/social/register",{friend:m.id,player:p.id});},0x70a929);
            else text(link.friend==m.id?(link.status=="accepted"?"REGISTERED":"PENDING"):"BATTER LINKED",x+329,y+22,151,31,12,0x6b592b,"center");
        }
        private function friends():Array {var out:Array=[];for each(var m:Object in state.members)if(m.connected)out.push(m);out.sortOn("name",Array.CASEINSENSITIVE);return out;}
        private function sentTo(id:String):Boolean {for each(var g:Object in state.sent)if(g.receiver==id)return true;return false;}
        private function gifts():void {
            var list:Array=friends();if(!list.length){empty("NO FRIENDS YET","Agrega un amigo o acepta su solicitud desde FRIENDS para intercambiar regalos.","scout");return;}
            var pages:int=Math.max(1,Math.ceil(list.length/5));page=Math.max(0,Math.min(page,pages-1));var selected:Object;
            for(var i:int=page*5;i<Math.min(list.length,page*5+5);i++)if(list[i].id==chosenFriend)selected=list[i];if(!selected){selected=list[page*5];chosenFriend=selected.id;}
            text("CHOOSE A FRIEND",41,185,265,29,17,0xffe58b);for(i=page*5;i<Math.min(list.length,page*5+5);i++)giftFriend(list[i],222+(i%5)*70);pager(pages,39,594,265);
            ClassicChrome.panel(body.graphics,323,190,600,432);text(selected.name,341,205,560,36,25,0xffe79a,"center");text(sentTo(selected.id)?"GIFT SENT TODAY":"ONE FREE GIFT TODAY",341,245,560,26,14,0xc5eeff);
            var kinds:Array=["energy","key","letter"];for(i=0;i<3;i++)giftTile(selected,kinds[i],339+i*190,286);
            text("El destinatario recoge el regalo desde su bandeja.\nNo necesita estar conectado para que lo reciba.",344,554,556,48,13,0xe2f5ff,"center");
        }
        private function giftFriend(m:Object,y:Number):void {
            var b:Sprite=new Sprite();b.name="social-friend-"+m.id;b.x=39;b.y=y;b.mouseChildren=false;b.buttonMode=true;ClassicChrome.well(b.graphics,0,0,265,63,m.id==chosenFriend);body.addChild(b);
            face(m,44,y+4,51,54);text(m.name,103,y+4,190,27,17,0x294c5e);text(sentTo(m.id)?"SENT TODAY":"GIFT AVAILABLE",103,y+34,190,21,10,sentTo(m.id)?0x816439:0x2a7a29);
            var h:Function=function(e:MouseEvent):void{if(loading||review)return;chosenFriend=m.id;notice="";render();};b.addEventListener(MouseEvent.CLICK,h);controls.push({view:b,handler:h});
        }
        private function giftName(kind:String):String{return kind=="energy"?"+1 ENERGY":kind=="key"?"+1 MYSTERY KEY":"+1 DOUBLE-A LETTER";}
        private function giftArt(kind:String,x:Number,y:Number,w:Number,h:Number):void {var a:SocialGiftArtwork=new SocialGiftArtwork(kind,w,h);a.x=x;a.y=y;body.addChild(a);art.push(a);}
        private function giftTile(m:Object,kind:String,x:Number,y:Number):void {
            ClassicChrome.well(body.graphics,x,y,177,244,false,true);giftArt(kind,x+33,y+31,111,109);text(giftName(kind),x+7,y+153,163,48,16,0x274d60,"center");button(sentTo(m.id)?"SENT":"SEND GIFT","social-"+kind+"-"+m.id,x+9,y+202,159,function():void{review={friend:m.id,name:m.name,kind:kind};render();},0x6fa72a,!sentTo(m.id),32);
        }
        private function drawReview():void {
            var shield:Sprite=new Sprite();shield.name="social-gift-review";shield.graphics.beginFill(0x061b2d,.86);shield.graphics.drawRect(25,179,910,466);shield.graphics.endFill();body.addChild(shield);
            var plate:Sprite=new Sprite();ClassicChrome.panel(plate.graphics,202,212,556,378);body.addChild(plate);
            text("SEND GIFT",225,230,510,39,27,0xffe79a,"center");giftArt(review.kind,247,301,112,123);text(review.name,380,290,345,45,24,0xffffff);text(giftName(review.kind),380,342,345,46,19,0xffe79a);text("Este será tu regalo de hoy para este amigo.\nEl envío se guarda al confirmar.",243,432,478,57,15,0xe4f1f8,"center");
            button("CANCEL","social-gift-cancel",235,526,219,function():void{review=null;notice="";render();},0x577b91);button("SEND GIFT","social-gift-confirm",488,526,233,function():void{var r:Object=review;review=null;mutate("/social/gift",{friend:r.friend,kind:r.kind});},0x70a929);
        }
        private function inbox():void {
            var entries:Array=[];for each(var req:Object in state.requests)if(req.receiver==state.userId&&req.status=="pending")entries.push({type:"friend",value:req});for each(var l:Object in state.links)if(l.friend==state.userId&&l.status=="pending")entries.push({type:"request",value:l});for each(var g:Object in state.gifts)if(!g.claimed)entries.push({type:"gift",value:g});
            var pages:int=Math.max(1,Math.ceil(entries.length/5));page=Math.max(0,Math.min(page,pages-1));text("INBOX  ·  "+entries.length+" PENDING",42,184,864,31,19,0xffe58b);if(!entries.length){empty("ALL CAUGHT UP","No tienes solicitudes ni regalos pendientes. REFRESH consulta la bandeja sin repetir premios.","case");return;}
            for(var i:int=page*5;i<Math.min(entries.length,page*5+5);i++)inboxRow(entries[i],224+(i%5)*71);pager(pages,40,602,880);
        }
        private function inboxRow(entry:Object,y:Number):void {
            var v:Object=entry.value;ClassicChrome.well(body.graphics,39,y,882,65,false,true);
            if(entry.type=="friend"){icon("scout",48,y+8,61,48);text(memberName(v.requester),124,y+4,448,27,20,0x294c5e);text("Solicitud de amistad",124,y+35,448,22,12,0x45606f);button("ACCEPT","social-accept-"+v.requester,589,y+16,151,function():void{reply(v,true);},0x68a82b);button("REJECT","social-reject-"+v.requester,753,y+16,155,function():void{reply(v,false);},0xb24f43);}
            else if(entry.type=="request") {icon("scout",48,y+8,61,48);text(memberName(v.owner),124,y+4,448,27,20,0x294c5e);text("Batter: "+playerName(v.owner,v.player),124,y+35,448,22,12,0x45606f);button("ACCEPT","social-accept-"+v.owner,589,y+16,151,function():void{mutate("/social/accept",{owner:v.owner,player:v.player});},0x68a82b);button("REJECT","social-reject-"+v.owner,753,y+16,155,function():void{mutate("/social/reject",{owner:v.owner,player:v.player});},0xb24f43);}
            else {giftArt(v.kind,48,y+5,61,54);text(v.senderName,124,y+3,530,29,20,0x294c5e);text(giftName(v.kind),124,y+34,530,24,13,0x506b30);button("COLLECT","social-claim-"+v.id,736,y+16,171,function():void{if(v.kind=="key"&&int(GameData.mysteryInventory.keys)>=40){notice="Tienes 40 llaves. Abre una caja antes de recoger otra.";render();return;}mutate("/social/claim",{gift:v.id});},0x68a82b);}
        }
        private function empty(title:String,hint:String,kind:String):void {icon(kind,398,264,164,122);text(title,170,416,620,39,27,0xffe79a,"center");text(hint,173,468,614,92,17,0xdaf1ff,"center");}
        private function pager(pages:int,x:Number,y:Number,w:Number):void {button("‹","social-prev",x,y,53,function():void{page=Math.max(0,page-1);notice="";render();},0x4b7793,page>0,30);text((page+1)+" / "+pages,x+59,y+1,w-118,27,14,0xffffff,"center");button("›","social-next",x+w-53,y,53,function():void{page=Math.min(pages-1,page+1);notice="";render();},0x4b7793,page<pages-1,30);}
        private function mutate(path:String,data:Object):void {if(loading)return;if(pending){if(status)status.text="Reintenta la acción pendiente antes de realizar otra.";return;}data.requestId=OnlineClient.requestId();pendingPath=path;pending=data;transmit();}
        private function transmit():void {if(!alive||api.busy||!pending)return;loading=true;retryAllowed=false;notice="Guardando…";if(status)status.text=notice;api.request("POST",pendingPath,pending,received,error);}
        private function drawRetry():void {status.width=658;button("RETRY","social-retry",718,654,202,function():void{if(pending)transmit();else refresh();},0xb08229);}
        private function error(message:String,code:int):void {if(!alive)return;loading=false;retryAllowed=code==0||code>=500;notice=message;if(!retryAllowed){pending=null;pendingPath=null;}if(state)render();else{clear();if(retryAllowed)drawRetry();}}
        private function exit():void {if(loading)return;if(sharing){sharing=false;render();return;}if(review){review=null;render();return;}if(back!=null)back();}
        public function handleEscape():void {exit();}
        public function dispose():void {if(!alive)return;alive=false;poll.stop();poll.removeEventListener(TimerEvent.TIMER,pollFriends);api.dispose();release();back=null;visitFriend=null;review=null;pending=null;}
    }
}
