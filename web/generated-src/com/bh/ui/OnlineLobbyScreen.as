package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.external.ExternalInterface;
    import com.bh.online.*;import com.bh.visual.MatchStadium;

    public class OnlineLobbyScreen extends Sprite {
        public var api:OnlineClient;
        private var back:Function,background:MatchStadium,body:Sprite=new Sprite(),actions:Array=[];
        private var statusText:TextField,serverField:TextField,userField:TextField,passField:TextField,nameField:TextField,inviteField:TextField;
        private var lobby:Object,matchView:RivalMatchScreen,page:int=0;
        private var leagueView:PrivateLeagueScreen;
        private var socialView:SocialScreen;
        private var pendingPath:String,pendingBody:Object,pendingDone:Function;
        private var alive:Boolean=true,loading:Boolean=false;

        public function OnlineLobbyScreen(w:Number,h:Number,onBack:Function,client:OnlineClient=null) {
            name="online-lobby";back=onBack;api=client?client:new OnlineClient();
            background=new MatchStadium(960,720);addChild(background);graphics.beginFill(0x806136);graphics.drawRect(0,540,960,180);graphics.endFill();addChild(body);
            if(api.token.length)refresh();else loginForm();
        }
        private function clear():void {while(body.numChildren)body.removeChildAt(0);body.graphics.clear();actions=[];ClassicInventorySkin.panel(body.graphics,50,63,860,605);ClassicInventorySkin.text(body,"RIVAL · PRIVATE GROUP",77,78,650,30,24);statusText=ClassicInventorySkin.text(body,"",77,595,800,58,13,0xffe59a);button("MODES","online_back",789,81,96,function():void{if(!loading)back();});}
        private function label(value:String,x:Number,y:Number,w:Number,h:Number=24,size:int=14,color:uint=0xffffff):TextField {return ClassicInventorySkin.text(body,value,x,y,w,h,size,color);}
        private function button(value:String,id:String,x:Number,y:Number,w:Number,fn:Function):Sprite {var b:Sprite=ClassicInventorySkin.button(value,w,32,0x2178ae);b.x=x;b.y=y;b.name=id;b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{if(!loading)fn();});body.addChild(b);actions.push(b);return b;}
        private function field(id:String,value:String,x:Number,y:Number,w:Number,password:Boolean=false):TextField {
            var t:TextField=new TextField();t.name=id;t.type=TextFieldType.INPUT;t.defaultTextFormat=new TextFormat("Arial",16,0x143148);t.text=value;t.x=x;t.y=y;t.width=w;t.height=30;t.background=true;t.backgroundColor=0xf1f8fa;t.border=true;t.borderColor=0x17435c;t.displayAsPassword=password;t.maxChars=password?128:120;body.addChild(t);return t;
        }
        private function loginForm():void {
            loading=false;clear();label("Vuelve a iniciar sesiÃƒÂ³n desde la pÃƒÂ¡gina del juego.",78,180,780,60,20);
            ExternalInterface.call("BHWeb.expired");
        }
        private function authenticate(register:Boolean):void {
            try{api.setServer(serverField.text);}catch(e:Error){statusText.text=e.message;return;}
            var data:Object={username:userField.text,password:passField.text};
            if(register){data.name=nameField.text;data.invite=inviteField.text;}
            busy("Connecting…");api.request("POST",register?"/register":"/login",data,function(result:Object):void{api.remember(result);passField.text="";refresh();},error);
        }
        private function busy(message:String):void {loading=true;if(statusText)statusText.text=message;for each(var b:Sprite in actions){b.alpha=.55;}}
        private function idle():void {loading=false;for each(var b:Sprite in actions)b.alpha=1;}
        public function refresh():void {
            if(!alive||api.busy)return;
            if(!api.token.length){loginForm();return;}
            if(!statusText)clear();busy("Loading teams and challenges…");
            api.request("GET","/lobby",null,function(data:Object):void{if(!alive)return;lobby=data;api.user=data.user;idle();drawLobby();},error);
        }
        private function drawLobby():void {
            clear();label("Hello, "+lobby.user.name,78,126,415,27,18,0xffe79d);
            button("PUBLISH MY TEAM","online_publish",78,167,238,previewTeam);
            button("LINK","online_create_invite",329,167,118,createInvite);
            button("REFRESH","online_refresh",460,167,146,refresh);
            button("SIGN OUT","online_logout",654,167,205,logout);
            label("GROUP TEAMS",78,222,380,25,16);label("MY CHALLENGES · HISTORY",493,222,375,25,16);
            var friends:Array=[];for each(var member:Object in lobby.members)if(member.id!=api.user.id)friends.push(member);
            var pages:int=Math.max(1,Math.ceil(Math.max(friends.length,lobby.matches.length)/5));page=Math.min(page,pages-1);
            var own:Object;for each(member in lobby.members)if(member.id==api.user.id)own=member;
            statusText.text=own&&own.team?"Published team: "+own.team.name+" · version "+own.version+". Los retos conservan la alineación inicial.":"Publica tu alineación para que tus amigos puedan retarte.";
            if(!friends.length)label("Aún no hay amigos. Crea una invitación\npara registrar otra cuenta.",79,272,365,76,14,0xcce3ef);
            if(!lobby.matches.length)label("Aquí aparecerán tus partidos.\nLa simulación controla el equipo\nguardado de tu rival.",493,272,375,80,14,0xcce3ef);
            for(var i:int=page*5;i<Math.min(friends.length,page*5+5);i++)friendRow(friends[i],258+(i%5)*56);
            for(i=page*5;i<Math.min(lobby.matches.length,page*5+5);i++)matchRow(lobby.matches[i],258+(i%5)*56);
            button("PREVIOUS","online_prev",80,550,125,function():void{page=Math.max(0,page-1);drawLobby();});label((page+1)+" / "+pages,223,554,95);
            button("NEXT","online_next",330,550,125,function():void{page=Math.min(pages-1,page+1);drawLobby();});
            button("PRIVATE LEAGUE","online_leagues",492,550,180,openLeagues);
            button("FRIENDS / GIFTS","online_social",686,550,182,openSocial);
        }
        private function friendRow(friend:Object,y:Number):void {
            label(friend.name+"\n"+(friend.team?friend.team.name+" · v"+friend.version:"Unpublished lineup"),79,y,253,47,13);
            if(friend.team)button("CHALLENGE","online_challenge_"+friend.id,345,y+4,106,function():void{mutation("/matches",{opponent:friend.id},openMatch);});
        }
        private function matchRow(m:Object,y:Number):void {
            var s:Object=m.state,title:String=m.homeTeam.name+" / "+m.awayTeam.name;
            label(title+"\n"+s.home+" – "+s.away+" · "+(s.status=="complete"?"FINAL":s.status=="cancelled"?"CANCELED":"INNING "+s.inning),493,y,245,47,12);
            button(s.status=="playing"&&m.homeId==api.user.id?"RESUME":"VIEW","online_match_"+m.id,758,y+4,112,function():void{busy("Opening challenge…");api.request("GET","/matches/"+m.id,null,openMatch,error);});
        }
        private function previewTeam():void {
            var team:Object;try{team=OnlineTeam.snapshot();}catch(e:Error){statusText.text=e.message;return;}
            clear();label("PUBLISH LINEUP · "+team.name,78,134,770,28,19,0xffdf78);
            label("Compartirás estos nueve jugadores y sus atributos con tu grupo.\nTu saldo, cartas, contraseña y guardado quedan en tu cuenta.",78,173,780,55,14);
            for(var i:int=0;i<9;i++){var p:Object=team.players[i];label((i+1)+". "+p.name+(i==team.heroIndex?"  ★ HERO":""),90,239+i*30,406);label("PWR "+p.power+"   CON "+p.contact+"   SPD "+p.speed,515,239+i*30,320,24,13,0xe2f0f7);}
            button("PUBLISH","online_publish_confirm",278,546,191,function():void{mutation("/team",{team:team},function(result:Object):void{refresh();});});
            button("BACK","online_publish_cancel",489,546,174,drawLobby);
        }
        private function createInvite():void {
            clear();label("COMPARTE EL JUEGO CON TUS AMIGOS",78,153,760,30,23,0xffdf78);
            label("Abre el enlace en una computadora y elige Create account.\nNo necesitas cÃƒÂ³digo de invitaciÃƒÂ³n.",78,208,780,62,17);
            var link:String=api.baseURL+"/";
            var value:TextField=field("online_share_link",link,144,300,672);value.type=TextFieldType.DYNAMIC;value.selectable=true;
            button("COPY LINK","online_copy_invite",244,367,210,function():void{ExternalInterface.call("BHWeb.copyInvite",link);statusText.text="TambiÃƒÂ©n puedes seleccionar el enlace y copiarlo con Ctrl+C.";});
            button("BACK","online_invite_back",479,367,178,refresh);
        }
        private function logout():void {mutation("/logout",{},function(result:Object):void{api.forget();lobby=null;loginForm();});}
        private function mutation(path:String,data:Object,onDone:Function):void {data.requestId=OnlineClient.requestId();pendingPath=path;pendingBody=data;pendingDone=onDone;transmit();}
        private function transmit():void {if(api.busy)return;busy("Saving…");api.request("POST",pendingPath,pendingBody,function(result:Object):void{idle();var callback:Function=pendingDone;pendingBody=null;pendingDone=null;callback(result);},error);}
        private function openMatch(data:Object):void {idle();body.visible=false;matchView=new RivalMatchScreen(api,data,function():void{matchView.dispose();removeChild(matchView);matchView=null;body.visible=true;refresh();});addChild(matchView);}
        private function openSocial():void {body.visible=false;socialView=new SocialScreen(api,function():void{socialView.dispose();removeChild(socialView);socialView=null;body.visible=true;refresh();});addChild(socialView);}
        private function openLeagues():void {body.visible=false;leagueView=new PrivateLeagueScreen(api,function():void{leagueView.dispose();removeChild(leagueView);leagueView=null;body.visible=true;refresh();});addChild(leagueView);}
        private function error(message:String,status:int):void {
            if(!alive)return;idle();
            if(status==401&&api.token.length){api.forget();loginForm();}
            if(pendingBody&&(status==0||status>=500)){clear();label("No se confirmó si llegó la acción.\nAl reintentar se usa el mismo identificador para evitar duplicados.",78,192,780,90,19);button("RETRY","online_retry",265,350,215,transmit);}
            else if(api.token.length&&lobby==null)button("RETRY","online_retry",695,550,161,refresh);
            if(status>0&&status<500){pendingBody=null;pendingDone=null;}
            statusText.text=message;
        }
        public function handleEscape():Boolean {if(socialView){socialView.handleEscape();return true;}return false;}
        public function dispose():void {alive=false;if(matchView)matchView.dispose();if(leagueView)leagueView.dispose();if(socialView)socialView.dispose();api.dispose();background.dispose();}
    }
}
