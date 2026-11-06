package com.bh.ui {
    import flash.display.*;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.utils.getTimer;
    import flash.filters.GlowFilter;
    import com.bh.online.OnlineClient;
    import com.bh.model.GameData;
    import com.bh.model.MLB2026Catalog;
    import com.bh.visual.*;
    import com.bh.game.HomeHero;

    /** Friend cosmetics are explicit render inputs. A visit never equips remote gear. */
    public class FriendVisitScreen extends Sprite {
        private var api:OnlineClient,id:String,back:Function,navigate:Function;
        private var scene:Sprite=new Sprite(),chrome:Sprite=new Sprite(),drops:Sprite=new Sprite();
        private var state:Object,visit:Object,pending:Object,pendingPath:String,dialog:Sprite;
        private var alive:Boolean=true,loading:Boolean=true,retryAllowed:Boolean=false;
        private var background:MatchStadium,hero:HomeHero,header:MatchResourceBar;
        private var art:Array=[],railArt:Array=[],dropArt:Array=[],controls:Array=[],dropControls:Array=[],dropViews:Object={};
        private var railPage:int=0,burst:Sprite,burstAt:int=0,burstBase:Number=0;
        private var coins:HomeCoinFlight,actors:Array=[],dropMotion:Array=[],clockLabel:TextField,nextClock:int=0;
        private var tooltip:Sprite=new Sprite(),hovered:String="",tipText:TextField;
        private var message:TextField,sceneKey:String="",notice:String="Cargando el estadio de tu amigo…";
        public function FriendVisitScreen(client:OnlineClient,friend:String,onBack:Function,onVisit:Function) {
            name="friend-visit";api=client;id=friend;back=onBack;navigate=onVisit;
            graphics.beginFill(0x165479);graphics.drawRect(0,0,960,720);graphics.endFill();
            graphics.beginFill(0xa27234);graphics.drawRect(0,540,960,180);graphics.endFill();
            addChild(scene);addChild(drops);addChild(chrome);coins=new HomeCoinFlight();addChild(coins);
            tooltip.mouseEnabled=tooltip.mouseChildren=false;ClassicChrome.well(tooltip.graphics,0,0,184,29);tipText=label(tooltip,"",5,4,174,22,12,0x31516c,"center");tooltip.visible=false;addChild(tooltip);
            addEventListener(Event.ENTER_FRAME,animateScene);renderChrome();open();
        }
        private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number=24,size:int=14,color:uint=0xffffff,align:String="left"):TextField {
            return ClassicInventorySkin.text(parent,value,x,y,w,h,size,color,align,color==0xffffff||color==0xffeea5||color==0xffef9f);
        }
        private function button(parent:Sprite,key:String,value:String,x:Number,y:Number,w:Number,action:Function,enabled:Boolean=true,color:uint=0x2480aa):void {
            var view:Sprite=ClassicInventorySkin.button(value,w,35,color);view.x=x;view.y=y;view.name=key;view.mouseEnabled=enabled;view.alpha=enabled?1:.45;parent.addChild(view);
            var handler:Function=function(e:MouseEvent):void{if(alive&&enabled)action();};view.addEventListener(MouseEvent.CLICK,handler);controls.push({view:view,handler:handler});
        }
        private function open():void {if(api.busy)return;send("/social/visit",{friend:id,requestId:OnlineClient.requestId()});}
        private function send(path:String,data:Object):void {pendingPath=path;pending=data;transmit();}
        private function transmit():void {
            if(!alive||api.busy)return;loading=true;retryAllowed=false;notice="Guardando la visita…";renderChrome();updateDrops();
            api.request("POST",pendingPath,pending,received,error);
        }
        private function received(data:Object):void {
            if(!alive)return;
            var claim:String=pending&&pending.object?String(pending.object):"";
            state=data;visit=data.visit;loading=false;pending=null;retryAllowed=false;closeDialog();
            GameData.applySocialSnapshot(data);
            notice=claim=="energy"?"+1 ENERGY para ti · +1 ENERGY para tu amigo":claim?"+20 COINS · Premio guardado":"Recoge los objetos del campo y comparte energía con tu amigo.";
            var key:String=JSON.stringify({profile:visit.profile,team:visit.team});
            if(key!=sceneKey){sceneKey=key;drawScene();}
            updateDrops();renderChrome();if(hero&&claim){hero.celebrate();showBurst(claim);if(claim!="energy"&&dropViews[claim])coins.send(dropViews[claim].x,dropViews[claim].y);}
        }
        private function error(value:String,code:int):void {
            if(!alive)return;loading=false;retryAllowed=code==0||code>=500;notice=value;closeDialog();
            if(!retryAllowed)pending=null;renderChrome();updateDrops();
        }
        private function clearControls():void {for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}controls=[];}
        private function renderChrome():void {
            clearControls();for each(var oldFace:Object in railArt)oldFace.dispose();railArt=[];if(header){header.dispose();header=null;}while(chrome.numChildren)chrome.removeChildAt(0);chrome.graphics.clear();
            header=new MatchResourceBar(960,true);chrome.addChild(header);
            ClassicChrome.fill(chrome.graphics,191,74,602,40,[0xb8e6fa,0x2580b0,0x174a70],[0,100,255],12);
            label(chrome,visit?"VISITING · "+String(visit.name):"FRIEND STADIUM",202,79,578,34,23,0xffffff,"center");
            button(chrome,"visit-home","GO HOME",18,617,170,function():void{if(!loading&&!dialog)back();},!loading&&!dialog,0x287eb4);
            button(chrome,"visit-refresh","REFRESH",805,78,139,refresh,!loading&&!dialog);
            if(retryAllowed)button(chrome,"visit-retry","RETRY",805,121,139,transmit,!loading,0xe2aa28);
            ClassicInventorySkin.panel(chrome.graphics,0,534,960,184);
            ClassicChrome.well(chrome.graphics,12,543,230,40,false,true);
            message=label(chrome,notice,256,580,686,18,11,0xffeea5);message.name="visit-status";message.multiline=message.wordWrap=false;LineupTypography.fit(message,11,0xffeea5,"left");
            clockLabel=label(chrome,"",21,663,164,39,11,0xcfeeff,"center");clockLabel.name="visit-daily-reset";nextClock=0;
            if(!visit)return;
            var p:Object=visit.profile;
            var claimed:int=0;for each(var obj:Object in visit.objects)if(obj.claimed)claimed++;
            label(chrome,"VISIT REWARDS   "+claimed+" / "+visit.objects.length,22,553,210,25,14,0x32536b,"center");
            drawRewardTrack();
            ClassicInventorySkin.panel(chrome.graphics,815,351,130,171);
            label(chrome,String(visit.name),821,356,118,25,14,0xffffff,"center");ClassicChrome.bar(chrome.graphics,822,385,116,24);
            label(chrome,"LV "+p.level,824,385,113,23,14,0xffe79a,"center");
            label(chrome,"AVG\nHR\nRBI",825,420,65,86,14);label(chrome,(Number(p.avg)/1000).toFixed(3)+"\n"+p.hr+"\n"+p.rbi,887,420,49,86,14,0xffe79a,"right");
            label(chrome,String(visit.team.name),192,116,594,30,20,0xffffff,"left");
            var friends:Array=[];for each(var m:Object in state.members)if(m.connected===true)friends.push(m);
            friends.sortOn("name",Array.CASEINSENSITIVE);
            var pages:int=Math.max(1,Math.ceil(friends.length/6));railPage=Math.max(0,Math.min(railPage,pages-1));
            for(var i:int=railPage*6;i<Math.min(friends.length,railPage*6+6);i++)drawFriend(friends[i],204+(i%6)*104);
            button(chrome,"visit-friends-prev","‹",875,594,59,function():void{railPage--;renderChrome();},railPage>0&&!loading&&!dialog);
            button(chrome,"visit-friends-next","›",875,635,59,function():void{railPage++;renderChrome();},railPage<pages-1&&!loading&&!dialog);
            label(chrome,(railPage+1)+" / "+pages,851,678,91,23,12,0xd7f3ff,"center");
        }
        private function drawFriend(m:Object,x:Number):void {
            var profile:Object=m.profile||{},tile:Sprite=new Sprite();tile.x=x;tile.y=599;chrome.addChild(tile);
            ClassicChrome.well(tile.graphics,0,0,100,111,m.id==id);if(m.id==id){tile.graphics.lineStyle(3,0xffda53);tile.graphics.drawRoundRect(1,1,98,109,7);tile.graphics.lineStyle();}
            label(tile,m.name,4,3,92,21,11,0x365268,"center");
            var face:HeroHead=new HeroHead(profile.appearance||{},HomeSprite.paletteFor(m.name,uint(profile.accent||0x247ab2),profile.appearance||{},{}));face.x=50;face.y=85;face.scaleX=face.scaleY=.36;tile.addChild(face);railArt.push(face);
            label(tile,m.id==id?"VISITING":"LV "+int(profile.level||1),4,88,92,20,11,m.id==id?0x856326:0x365268,"center");
            var other:String=m.id;var handler:Function=friendHandler(other);tile.name="visit-friend-"+other;tile.buttonMode=true;tile.mouseChildren=false;tile.addEventListener(MouseEvent.CLICK,handler);controls.push({view:tile,handler:handler});
        }
        private function friendHandler(other:String):Function {return function(e:MouseEvent):void{if(!loading&&!dialog&&other!=id)navigate(other);};}
        private function refresh():void {if(loading)return;pending=null;open();}
        private function drawScene():void {
            releaseScene();background=new MatchStadium(960,540,visit.profile.stadium);scene.addChild(background);
            var team:Object=visit.team,p:Object=visit.profile,gear:Object={};
            for(var slot:String in p.equipment){var item:Object=GameData.shopItemById(String(p.equipment[slot]));if(item)gear[slot]=item;}
            var h:Object=team.players[int(team.heroIndex)];
            hero=new HomeHero(710,529,uint(p.accent),int(p.number),h.name,null,gear,p.appearance);hero.scaleX=hero.scaleY=1.30;scene.addChild(hero);
            var badge:LeagueBadgeView=new LeagueBadgeView(int(p.league),["ROOKIE","A","AA","AAA","MAJOR"][int(p.league)],74);badge.x=14;badge.y=106;scene.addChild(badge);art.push(badge);
            var logo:TeamLogoView=new TeamLogoView(String(p.city),uint(team.accent),"H",77);logo.x=14;logo.y=195;scene.addChild(logo);art.push(logo);
            var n:int=0;
            for(var i:int=0;i<team.players.length;i++)if(i!=team.heroIndex){
                var member:Object=team.players[i],catalog:Object=MLB2026Catalog.named(String(member.name)),tile:Sprite=new Sprite();tile.name="visit-teammate-"+i;tile.x=145+n*58;tile.y=263+(n%3)*3;scene.addChild(tile);
                tile.graphics.beginFill(0x183e2c,.24);tile.graphics.drawEllipse(5,72,39,8);tile.graphics.endFill();
                var actor:Sprite;
                if(catalog&&MLBPlayerArtwork.indexFor(catalog)>=0){actor=new MLBPlayerArtwork(catalog,49,81);}
                else {var seed:int=VisualProfile.seed(member.name),appearance:Object={artVersion:1,avatarStyle:seed%16,skinColor:int(seed/7)%5,hairColor:int(seed/11)%20,eyeColor:int(seed/13)%8,gender:"M"};actor=new HeroSprite(member.name,uint(team.accent),appearance,"home",.27,{},false);actor.x=24;actor.y=80;}
                tile.addChild(actor);art.push(actor);actors.push({view:actor,y:actor.y});n++;
            }
            createDrops();
        }
        private function createDrops():void {
            clearDrops();
            var kinds:Array=["glove","helmet","bat","ball","energy"],positions:Array=[[305,414],[405,369],[480,443],[196,461],[594,455]];
            for(var i:int=0;i<kinds.length;i++){
                var kind:String=kinds[i],s:Sprite=new Sprite();s.name="visit-drop-"+kind;s.x=positions[i][0];s.y=positions[i][1];s.buttonMode=true;s.mouseChildren=false;
                s.graphics.beginFill(0xffffff,.01);s.graphics.drawRect(-35,-28,70,56);s.graphics.endFill();
                var ring:Shape=new Shape();ring.graphics.lineStyle(2,0xffee54,.9);ring.graphics.beginFill(0xffe35a,.2);ring.graphics.drawEllipse(-31,-18,62,38);ring.graphics.endFill();ring.alpha=0;s.addChild(ring);
                if(kind=="glove"||kind=="bat"||kind=="ball"){var w:Number=kind=="bat"?67:kind=="ball"?27:43,h:Number=kind=="bat"?20:kind=="ball"?27:33,pixels:HomeSceneArtwork=new HomeSceneArtwork(kind,w,h);pixels.x=-w/2;pixels.y=-h/2;s.addChild(pixels);dropArt.push(pixels);}
                else if(kind=="energy"){var can:SocialGiftArtwork=new SocialGiftArtwork("energy",36,53);can.x=-18;can.y=-27;s.addChild(can);dropArt.push(can);}
                else {var original:InterfaceSprite=new InterfaceSprite("helmet",49,45);original.x=-24;original.y=-23;s.addChild(original);}
                var handler:Function=dropHandler(kind),over:Function=dropHover(kind,true),out:Function=dropHover(kind,false);s.addEventListener(MouseEvent.CLICK,handler);s.addEventListener(MouseEvent.ROLL_OVER,over);s.addEventListener(MouseEvent.ROLL_OUT,out);dropControls.push({view:s,handler:handler,over:over,out:out});dropViews[kind]=s;dropMotion.push({id:kind,view:s,ring:ring,y:s.y,mix:0});drops.addChild(s);
            }
        }
        private function dropHandler(kind:String):Function {return function(e:MouseEvent):void {if(loading||dialog||!visit)return;for each(var o:Object in visit.objects)if(o.id==kind&&o.claimed)return;if(kind=="energy")showEnergy();else claim(kind);};}
        private function updateDrops():void {tooltip.visible=false;hovered="";if(!visit)return;for each(var o:Object in visit.objects){var s:Sprite=dropViews[o.id];if(s){s.filters=[];s.visible=!o.claimed;s.mouseEnabled=!loading&&!dialog;s.alpha=loading?.5:1;}}}
        private function claim(kind:String):void {send("/social/visit/claim",{friend:id,day:int(visit.day),object:kind,requestId:OnlineClient.requestId()});}
        private function showEnergy():void {
            dialog=new EnergySharePanel(visit,function():void{if(!loading)claim("energy");},closeEnergy);addChild(dialog);updateDrops();
        }
        private function closeEnergy():void {closeDialog();renderChrome();updateDrops();}
        private function closeDialog():void {if(dialog){EnergySharePanel(dialog).dispose();if(dialog.parent)removeChild(dialog);dialog=null;}}
        private function showBurst(kind:String):void {
            endBurst();var source:Sprite=dropViews[kind];if(!source)return;
            burst=new Sprite();burst.mouseEnabled=burst.mouseChildren=false;burst.x=source.x-65;burstBase=source.y-35;burst.y=burstBase;
            ClassicInventorySkin.icon(burst,kind=="energy"?"energy":"coin",4,2,.8);label(burst,kind=="energy"?"+1 ENERGY":"+20 COINS",32,2,113,30,17,0xffef9f);
            burstAt=getTimer();addChild(burst);addEventListener(Event.ENTER_FRAME,animateBurst);
        }
        private function animateBurst(e:Event):void {if(!burst)return;var progress:Number=(getTimer()-burstAt)/750;burst.y=burstBase-30*progress;burst.alpha=Math.min(1,(1-progress)*2);if(progress>=1)endBurst();}
        private function endBurst():void {removeEventListener(Event.ENTER_FRAME,animateBurst);if(burst&&burst.parent)burst.parent.removeChild(burst);burst=null;}
        private function dropHover(kind:String,on:Boolean):Function {return function(e:MouseEvent):void {if(!alive||loading||dialog)return;var s:Sprite=dropViews[kind];if(!s||!s.visible)return;s.filters=on?[new GlowFilter(0xffe94d,.85,8,8,2)]:[];if(on){hovered=kind;tipText.text=kind=="energy"?"Compartir 1 ENERGY":"Recoger 20 COINS";tooltip.x=Math.max(12,Math.min(752,s.x-92));tooltip.y=s.y-65;tooltip.visible=true;}else if(hovered==kind){hovered="";tooltip.visible=false;}};}
        private function drawRewardTrack():void {for(var i:int=0;i<visit.objects.length;i++){var o:Object=visit.objects[i],x:Number=256+i*137;ClassicChrome.well(chrome.graphics,x,548,131,30,Boolean(o.claimed),!o.claimed);var a:Sprite=o.id=="energy"?new SocialGiftArtwork("energy",21,25):o.id=="helmet"?new InterfaceSprite("helmet",25,25):new HomeSceneArtwork(String(o.id),25,25);a.x=x+5;a.y=550;chrome.addChild(a);if("dispose" in a)railArt.push(a);a.alpha=o.claimed?.45:1;label(chrome,o.claimed?"COLLECTED":o.id=="energy"?"+1 ENERGY":"20 COINS",x+32,553,93,20,10,o.claimed?0x9ceca3:0x31516c,"center");}}
        private function animateScene(e:Event):void {if(!alive)return;var now:int=getTimer();for(var i:int=0;i<actors.length;i++)actors[i].view.y=actors[i].y+Math.sin(now/440+i)*.65;for each(var d:Object in dropMotion){var active:Boolean=!loading&&!dialog&&d.view.visible,over:Boolean=active&&hovered==d.id;d.mix+=((over?1:0)-d.mix)*.22;d.ring.alpha=active?(d.id=="energy"?.22+.1*Math.sin(now/350):0)+d.mix*.65:0;d.view.y=d.y-(d.id=="energy"&&active?Math.sin(now/360)*1.6:0);}if(clockLabel&&visit&&now>=nextClock){nextClock=now+1000;var seconds:int=Math.max(0,int(((Number(visit.day)+1)*86400000-new Date().time)/1000));clockLabel.text=seconds>0?"RESETS IN\n"+pad(int(seconds/3600))+":"+pad(int(seconds/60)%60)+":"+pad(seconds%60):"REFRESH FOR\nDAILY REWARDS";}}
        private function pad(value:int):String {return value<10?"0"+value:String(value);}
        private function clearDrops():void {tooltip.visible=false;hovered="";for each(var c:Object in dropControls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);c.view.removeEventListener(MouseEvent.ROLL_OVER,c.over);c.view.removeEventListener(MouseEvent.ROLL_OUT,c.out);}dropControls=[];for each(var a:Object in dropArt)a.dispose();dropArt=[];dropMotion=[];dropViews={};while(drops.numChildren)drops.removeChildAt(0);}
        public function handleEscape():void {if(loading)return;if(dialog)closeEnergy();else back();}
        private function releaseScene():void {actors=[];if(background){background.dispose();background=null;}if(hero){hero.dispose();hero=null;}for each(var a:Object in art)a.dispose();art=[];while(scene.numChildren)scene.removeChildAt(0);}
        public function dispose():void {if(!alive)return;alive=false;removeEventListener(Event.ENTER_FRAME,animateScene);api.dispose();endBurst();coins.dispose();clearControls();closeDialog();releaseScene();for each(var face:Object in railArt)face.dispose();railArt=[];if(header)header.dispose();clearDrops();back=navigate=null;}
    }
}
