package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;
    import com.bh.online.OnlineClient;import com.bh.visual.MatchStadium;

    /** Shared schedule and standings, read from authoritative league responses. */
    public class PrivateLeagueScreen extends Sprite {
        private var api:OnlineClient,onBack:Function,background:MatchStadium,body:Sprite=new Sprite();
        private var statusText:TextField,nameField:TextField,actions:Array=[];
        private var listing:Object,league:Object,matchView:RivalMatchScreen;
        private var page:int=0,round:int=1,loading:Boolean=false,alive:Boolean=true;
        private var retryPath:String,retryBody:Object,retryDone:Function;
        public function PrivateLeagueScreen(client:OnlineClient,back:Function) {
            api=client;onBack=back;name="private-leagues";background=new MatchStadium(960,540);addChild(background);
            graphics.beginFill(0x806136);graphics.drawRect(0,540,960,180);graphics.endFill();addChild(body);loadList();
        }
        private function text(value:String,x:Number,y:Number,w:Number,h:Number=26,size:int=14,color:uint=0xffffff):TextField {return ClassicInventorySkin.text(body,value,x,y,w,h,size,color);}
        private function button(label:String,id:String,x:Number,y:Number,w:Number,fn:Function,color:uint=0x2178ae):void {
            var b:Sprite=ClassicInventorySkin.button(label,w,32,color);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{if(!loading)fn();});body.addChild(b);actions.push(b);
        }
        private function clear():void {
            while(body.numChildren)body.removeChildAt(0);body.graphics.clear();actions=[];
            ClassicInventorySkin.panel(body.graphics,50,63,860,605);text("PRIVATE LEAGUE",77,78,650,32,24);
            statusText=text("",78,601,800,49,13,0xffe59a);button("RIVAL","league_back",789,81,96,onBack);
        }
        private function busy(message:String):void {loading=true;if(statusText)statusText.text=message;for each(var b:Sprite in actions)b.alpha=.55;}
        private function idle():void {loading=false;for each(var b:Sprite in actions)b.alpha=1;}
        private function loadList():void {
            if(!alive||api.busy)return;league=null;clear();busy("Loading leagues…");
            api.request("GET","/leagues",null,function(data:Object):void{if(!alive)return;listing=data;idle();drawList();},error);
        }
        private function drawList():void {
            clear();text("Calendario de ida y vuelta · 2 a 8 equipos",78,132,780,30,19,0xffdc74);
            var leagues:Array=listing.leagues,pages:int=Math.max(1,Math.ceil(leagues.length/5));page=Math.min(page,pages-1);
            if(!leagues.length)text("Aún no hay ligas abiertas.\nCrea una para que tus amigos entren\ncon sus equipos publicados.",80,224,470,102,18,0xd0e7f1);
            for(var i:int=page*5;i<Math.min(leagues.length,page*5+5);i++)leagueRow(leagues[i],190+(i%5)*65);
            text("CREATE A LEAGUE",624,190,248,30,18,0xffdd76);
            text("Name",625,234,220,24,13);
            nameField=new TextField();nameField.name="league_name";nameField.type=TextFieldType.INPUT;nameField.defaultTextFormat=new TextFormat("Arial",15,0x143148);nameField.text="Friends League";nameField.x=625;nameField.y=263;nameField.width=245;nameField.height=32;nameField.maxChars=36;nameField.background=true;nameField.backgroundColor=0xf1f8fa;body.addChild(nameField);
            button("CREATE","league_create",625,317,245,function():void{mutate("/leagues",{name:nameField.text},acceptLeague);},0x338446);
            text("Cada miembro juega sus partidos de local.\n\nEl organizador inicia la liga cuando todos entren.",625,370,243,130,14,0xd4e8f2);
            button("PREVIOUS","league_list_prev",79,546,123,function():void{page=Math.max(0,page-1);drawList();});text((page+1)+" / "+pages,220,551,85);
            button("NEXT","league_list_next",330,546,123,function():void{page=Math.min(pages-1,page+1);drawList();});button("REFRESH","league_refresh",628,546,240,loadList);
            statusText.text="Las ligas son de tu grupo. Publica tu equipo en RIVAL antes de entrar.";
        }
        private function leagueRow(item:Object,y:Number):void {
            text(item.name+"\n"+stateLabel(item.status)+" · "+item.count+" / 8 teams",79,y,364,51,14);
            button(item.joined?"OPEN":"JOIN","league_open_"+item.id,453,y+5,130,function():void{
                if(item.joined)loadLeague(item.id);else confirmJoin(item);
            });
        }
        private function stateLabel(status:String):String {return status=="open"?"REGISTRATION":status=="running"?"IN PROGRESS":status=="complete"?"FINISHED":"CANCELED";}
        private function confirmJoin(item:Object):void {
            clear();text("JOIN "+item.name,79,147,790,39,22,0xffdd76);
            text("Entrarás con tu equipo publicado.\nAl empezar, las alineaciones quedan fijas.\nJugarás con cada rival de local y de visitante.",79,218,785,142,19);
            button("JOIN","league_join_confirm",261,433,214,function():void{mutate("/leagues/"+item.id+"/join",{},acceptLeague);},0x338446);
            button("BACK","league_join_cancel",500,433,192,drawList);
        }
        private function loadLeague(id:String):void {
            if(api.busy)return;busy("Refreshing league…");api.request("GET","/leagues/"+id,null,acceptLeague,error);
        }
        private function acceptLeague(data:Object):void {if(!alive)return;league=data;idle();round=Math.max(1,Math.min(round,int(league.rounds)));drawLeague();}
        private function member(id:String):Object {for each(var m:Object in league.members)if(m.id==id)return m;return {teamName:"Team",name:"Player"};}
        private function drawLeague():void {
            clear();text(league.name,78,132,610,30,21,0xffdf78);text(stateLabel(league.status),714,137,170,23,13,0xc4e8fc);
            if(league.status=="open"||league.status=="cancelled"){drawEnrollment();return;}
            text("STANDINGS",78,183,430,24,16);text("SCHEDULE · ROUND "+round+" / "+league.rounds,554,183,340,26,16);
            var cols:Array=[80,112,285,321,353,385,416,479],widths:Array=[27,166,35,31,31,31,60,51],headers:Array=["#","TEAM","GP","W","L","T","PCT","RD"];
            for(var c:int=0;c<cols.length;c++)text(headers[c],cols[c],220,widths[c],22,11,0x9ed9f8);
            var rows:Array=league.standings;
            for(var i:int=0;i<rows.length;i++) {
                var r:Object=rows[i],values:Array=[r.rank,r.teamName,r.played,r.wins,r.losses,r.ties,r.pct,r.differential>0?"+"+r.differential:r.differential];
                if(r.id==api.user.id){body.graphics.beginFill(0x79b445,.25);body.graphics.drawRoundRect(74,248+i*31,462,30,4);body.graphics.endFill();}
                for(c=0;c<cols.length;c++)text(String(values[c]),cols[c],252+i*31,widths[c],29,12,r.id==api.user.id?0xffe59a:0xffffff);
            }
            var fi:int=0;for each(var f:Object in league.fixtures)if(f.round==round)fixtureRow(f,226+(fi++)*72);
            button("‹","league_round_prev",556,542,65,function():void{round=Math.max(1,round-1);drawLeague();});
            button("MY NEXT GAME","league_next_mine",634,542,154,nextMine);
            button("›","league_round_next",801,542,65,function():void{round=Math.min(league.rounds,round+1);drawLeague();});
            button("LEAGUES","league_list",80,543,121,loadList);button("REFRESH","league_reload",215,543,190,function():void{loadLeague(league.id);});
            statusText.text="Finished: "+league.completed+" / "+league.fixtures.length+" · PCT: (victorias + medio empate) / partidos.\nDesempate: diferencia de carreras y luego carreras anotadas. Si persiste, comparten puesto.";
            if(league.status=="complete") {
                var names:Array=[];for each(var id:String in league.champions)names.push(member(id).teamName);
                statusText.text=(names.length>2?"SHARED CHAMPIONSHIP · "+names.length+" teams tied for first place.":(names.length>1?"CHAMPIONS: ":"CHAMPION: ")+names.join(" · "))+"\nCalendario terminado. Los resultados están guardados para todos.";
            }
        }
        private function drawEnrollment():void {
            text("REGISTERED TEAMS · "+league.members.length+" / 8",79,195,497,28,17);
            var i:int=0;for each(var m:Object in league.members){text((++i)+". "+m.name+(m.id==league.ownerId?" · ORGANIZER":""),90,243+(i-1)*35,335,27,14);text(m.teamName+" · v"+m.teamVersion,432,245+(i-1)*35,417,27,13,0xcde8f5);}
            text("Al empezar se fijan los equipos y el calendario de ida y vuelta.\nJueguen a su ritmo: no necesitan conectarse a la vez.",79,518,776,38,12,0xd1e7f1);
            if(league.status=="open") {
                if(league.ownerId==api.user.id){button("START LEAGUE","league_start",79,560,188,confirmStart,0x338446);button("CANCEL LEAGUE","league_cancel",282,560,196,confirmCancel);}
                else button("LEAVE LEAGUE","league_leave",80,560,198,confirmLeave);
            }
            button("REFRESH","league_reload",492,560,181,function():void{loadLeague(league.id);});button("LEAGUES","league_list",689,560,180,loadList);
            statusText.text=league.status=="open"?"Pueden actualizar sus equipos hasta que el organizador inicie la liga.":"Inscripción cancelada. Puedes crear otra liga o unirte a una.";
        }
        private function confirmStart():void {confirmation("Start "+league.name+"?",league.members.length+" teams · "+(league.members.length*(league.members.length-1))+" partidos.\nSe cierran las inscripciones y las alineaciones quedan fijas hasta el final.","league_start_confirm","START",function():void{round=1;mutate("/leagues/"+league.id+"/start",{},acceptLeague);});}
        private function confirmCancel():void {confirmation("Cancel registration?","La liga no empezará. Se conservan los equipos publicados.","league_cancel_confirm","CANCEL LEAGUE",function():void{mutate("/leagues/"+league.id+"/cancel",{},acceptLeague);});}
        private function confirmLeave():void {confirmation("Leave this league?","Puedes volver a entrar mientras estén abiertas las inscripciones.","league_leave_confirm","LEAVE",function():void{mutate("/leagues/"+league.id+"/leave",{},function(data:Object):void{league=null;listing=data;drawList();});});}
        private function confirmation(title:String,description:String,id:String,yes:String,accept:Function):void {
            clear();text(title,79,161,796,65,23,0xffdd76);text(description,79,252,787,143,19);button(yes,id,244,438,233,accept,0x338446);button("BACK","league_confirm_back",501,438,192,drawLeague);
        }
        private function fixtureRow(f:Object,y:Number):void {
            var home:Object=member(f.homeId),away:Object=member(f.awayId);
            text(home.teamName+"  /  "+away.teamName,555,y,325,39,12);
            text(f.status=="scheduled"?(f.homeId==api.user.id?"YOU PLAY AT HOME":"PLAYED BY "+home.name):f.home+" – "+f.away+" · "+(f.status=="complete"?(f.forfeit?"FORFEIT":"FINAL"):"IN PROGRESS"),555,y+41,206,29,10,0xbde3f6);
            if(f.matchId)button(f.homeId==api.user.id&&f.status=="playing"?"RESUME":"VIEW","league_fixture_"+f.id,771,y+35,101,function():void{getMatch(f.matchId);});
            else if(f.homeId==api.user.id)button("PLAY","league_fixture_"+f.id,771,y+35,101,function():void{mutate("/leagues/"+league.id+"/fixtures/"+f.id+"/play",{},openMatch);},0x338446);
        }
        private function nextMine():void {for each(var f:Object in league.fixtures)if(f.homeId==api.user.id&&f.status!="complete"){round=f.round;drawLeague();return;}statusText.text="Terminaste todos tus partidos de local.";}
        private function getMatch(id:String):void {busy("Opening game…");api.request("GET","/matches/"+id,null,openMatch,error);}
        private function openMatch(data:Object):void {idle();body.visible=false;matchView=new RivalMatchScreen(api,data,function():void{matchView.dispose();removeChild(matchView);matchView=null;body.visible=true;loadLeague(league.id);});addChild(matchView);}
        private function mutate(path:String,data:Object,callback:Function):void {data.requestId=OnlineClient.requestId();retryPath=path;retryBody=data;retryDone=callback;transmit();}
        private function transmit():void {busy("Saving…");api.request("POST",retryPath,retryBody,function(data:Object):void{if(!alive)return;idle();var callback:Function=retryDone;retryBody=null;retryDone=null;callback(data);},error);}
        private function error(message:String,status:int):void {
            if(!alive)return;idle();
            if(status==401){api.forget();clear();statusText.text="Tu sesión terminó. Vuelve a RIVAL e inicia sesión.";return;}
            if(retryBody&&(status==0||status>=500)){clear();text("Conexión interrumpida. Reintenta\nsin volver a crear la liga o el partido.",79,230,780,88,21);button("RETRY","league_retry",354,409,237,transmit);}
            else {retryBody=null;retryDone=null;if(league)drawLeague();else if(listing)drawList();else {clear();button("RETRY","league_retry",350,350,238,loadList);}}
            statusText.text=message;
        }
        public function dispose():void {alive=false;if(matchView)matchView.dispose();api.dispose();background.dispose();}
    }
}
