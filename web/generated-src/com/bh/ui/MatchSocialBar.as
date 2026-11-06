package com.bh.ui {
    import flash.display.*;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import com.bh.model.FriendRoster;
    import com.bh.online.OnlineClient;
    import com.bh.visual.*;
    import com.bh.visual.HomeSprite;

    /** Fixed sibling of Game: mouse clicks cannot become swings. No frame listeners. */
    public class MatchSocialBar extends Sprite {
        public static const HEIGHT:int=130;
        private var content:Sprite=new Sprite(),people:Array=[],faces:Array=[],controls:Array=[],icons:Array=[];
        private var api:OnlineClient,actions:Object,selected:Object;
        private var page:int=0,finished:Boolean=false,alive:Boolean=true,loading:Boolean=false;
        private var notice:String="";
        public function MatchSocialBar(callbacks:Object) {
            name="match-social-bar";actions=callbacks;addChild(content);people=FriendRoster.list();render();
            if(!FriendRoster.ready)load();
        }
        private function text(value:String,x:Number,y:Number,w:Number,h:Number,size:int=11,color:uint=0xffffff,align:String="left"):TextField {
            var t:TextField=ClassicInventorySkin.text(content,value,x,y,w,h,size,color,align,true);return t;
        }
        private function addControl(view:Sprite,id:String,fn:Function,enabled:Boolean=true):void {
            view.name=id;view.mouseChildren=false;view.buttonMode=enabled;
            var handler:Function=function(e:MouseEvent):void {e.stopPropagation();if(alive&&enabled)fn();};
            view.addEventListener(MouseEvent.CLICK,handler);controls.push({view:view,handler:handler});
        }
        private function clear():void {
            for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);if(c.view is ClassicActionButton)ClassicActionButton(c.view).dispose();}controls=[];for each(var icon:AssetImage in icons)icon.dispose();icons=[];
            for each(var face:HeroHead in faces)face.dispose();faces=[];
            while(content.numChildren)content.removeChildAt(0);content.graphics.clear();
        }
        private function render():void {
            clear();ClassicInventorySkin.gradient(content.graphics,0,0,960,HEIGHT,0x0d87c2,0x06568f,5);
            content.graphics.lineStyle(3,0x15394c);content.graphics.moveTo(0,1);content.graphics.lineTo(960,1);content.graphics.lineStyle();
            if(selected)drawProfile();else drawFriends();drawActions();
        }
        private function drawFriends():void {
            var pages:int=Math.max(1,Math.ceil(people.length/7));page=Math.max(0,Math.min(page,pages-1));
            arrow(false,8,22,page>0);arrow(true,8,79,page<pages-1);text((page+1)+"/"+pages,1,55,29,17,8,0xd5eeff,"center");
            for(var i:int=0;i<7;i++){
                var x:int=34+i*104,member:Object=people[page*7+i];
                var tile:Sprite=new Sprite();tile.x=x;tile.y=5;content.addChild(tile);
                MatchChrome.paper(tile.graphics,0,0,99,120);
                if(member){
                    var p:Object=member.profile||{};text(member.name,x+3,7,93,17,10,0x43515b,"center");
                    faceAt(member, x+49,80,.39);
                    text("LV "+int(p.level||1),x+61,56,33,19,9,0x31516c,"center");
                    MatchChrome.nameplate(tile.graphics,4,77,91,39);
                    text("AVG\nHR\nRBI",x+7,82,30,39,9,0xe9eeee);text((Number(p.avg||0)/1000).toFixed(3)+"\n"+int(p.hr||0)+"\n"+int(p.rbi||0),x+38,81,53,40,10,0xffedb6,"right");
                    addControl(tile,"match-friend-"+member.id,profileHandler(member));
                }else{
                    var scouting:RecruitmentArtwork=new RecruitmentArtwork("friends",78,69);scouting.x=10;scouting.y=13;tile.addChild(scouting);
                    text("SCOUT\nFRIENDS",x+3,85,93,34,11,0x6b8391,"center");
                    addControl(tile,"match-empty-"+i,emptyHandler);
                }
            }
            if(notice){var shield:Sprite=new Sprite();shield.x=37;shield.y=25;shield.graphics.beginFill(0x164c70,.96);shield.graphics.drawRoundRect(0,0,718,64,7);shield.graphics.endFill();content.addChild(shield);addControl(shield,"match-social-notice",function():void{notice="";render();});var n:TextField=text(notice+" Pulsa aquí para cerrar.",52,34,688,50,14,0xffedb5,"center");n.multiline=n.wordWrap=true;}
            if(!FriendRoster.ready&&!loading)smallButton("RETRY","match-social-retry",315,93,170,load,true,0xc9962c);
        }
        private function profileHandler(member:Object):Function {return function():void {selected=member;notice="";render();};}
        private function emptyHandler():void {
            if(finished&&actions.FRIENDS!=null){actions.FRIENDS();return;}
            notice="Añade amigos desde ADD FRIENDS en HOME al terminar el partido. Sus perfiles aparecerán aquí.";render();
        }
        private function faceAt(member:Object,x:Number,y:Number,scale:Number):void {
            var p:Object=member.profile||{},face:HeroHead=new HeroHead(p.appearance||{},HomeSprite.paletteFor(member.name,uint(p.accent||0x247ab2),p.appearance||{},{}));
            face.x=x;face.y=y;face.scaleX=face.scaleY=scale;face.mouseEnabled=face.mouseChildren=false;face.cacheAsBitmap=true;content.addChild(face);faces.push(face);
        }
        private function arrow(right:Boolean,x:int,y:int,enabled:Boolean):void {
            var s:Sprite=ClassicInventorySkin.button(right?">":"<",22,25,0x387da7);s.x=x;s.y=y;s.alpha=enabled?1:.4;content.addChild(s);
            addControl(s,right?"match-friends-next":"match-friends-prev",function():void{page+=right?1:-1;notice="";render();},enabled);
        }
        private function smallButton(value:String,id:String,x:Number,y:Number,w:Number,fn:Function,enabled:Boolean=true,color:uint=0x4385aa):void {
            var s:Sprite=ClassicInventorySkin.button(value,w,25,color);s.x=x;s.y=y;s.alpha=enabled?1:.48;content.addChild(s);addControl(s,id,fn,enabled);
        }
        private function drawProfile():void {
            ClassicInventorySkin.panel(content.graphics,34,5,724,120);faceAt(selected,85,112,.51);
            var p:Object=selected.profile||{};text(selected.name,133,11,433,25,18,0xffeb9b);
            text((selected.team?selected.team.name:"TEAM")+" · LV "+int(p.level||1),134,37,425,23,13);
            text("AVG "+(Number(p.avg||0)/1000).toFixed(3)+"     HR "+int(p.hr||0)+"     RBI "+int(p.rbi||0),134,64,425,23,14,0xffedb6);
            text(finished?"Puedes visitar su estadio al terminar.":"El partido continúa. Esta consulta no cambia la alineación.",134,94,425,23,11,0xc7e7f7);
            smallButton("CLOSE","match-profile-close",584,15,157,closeProfile);
            smallButton("VISIT STADIUM","match-profile-visit",584,50,157,function():void{if(actions.VISIT!=null)actions.VISIT(selected.id);},finished,0x6da335);
            text(finished?"":"Disponible al terminar",578,83,169,32,10,0xc7e7f7,"center");
        }
        private function drawActions():void {
            var keys:Array=["SHOP","LINEUP","BUILD","RIVAL","HALL","HOME"],titles:Array=["SHOP","LINEUP","BUILD","RIVAL","HALL OF FAME","HOME"];
            for(var i:int=0;i<keys.length;i++){
                var key:String=keys[i],s:Sprite=new Sprite();s.x=773+(i%2)*91;s.y=7+int(i/2)*35;content.addChild(s);
                MatchChrome.paper(s.graphics,0,0,84,32);drawIcon(s,key);
                ClassicInventorySkin.text(s,titles[i],2,19,80,13,9,0x315365,"center",true);s.alpha=finished?1:.48;addControl(s,"match-nav-"+key,actionHandler(key),finished);
            }
            text(finished?"MATCH COMPLETE":"Disponible al terminar",771,110,184,18,9,0xc6e5f5,"center");
        }
        private function drawIcon(s:Sprite,key:String):void {
            var art:Sprite;
            if(key=="RIVAL"){var image:AssetImage=new AssetImage(VisualAssetRegistry.modeIconPath("rival"),32,20);icons.push(image);art=image;}
            else if(key=="HALL")art=new AchievementArtwork("gold",32,20);
            else art=new InterfaceSprite(key=="SHOP"?"shop":key=="LINEUP"?"batter":"build",32,20);
            art.x=26;art.y=1;s.addChild(art);
        }
        private function actionHandler(key:String):Function {return function():void {if(actions[key]!=null)actions[key]();};}
        public function closeProfile():void {selected=null;notice="";render();}
        public function handleEscape():Boolean {if(selected||notice){closeProfile();return true;}return false;}
        public function setFinished():void {if(!alive)return;finished=true;render();}
        private function load():void {
            if(loading||!alive)return;loading=true;notice="Cargando amigos…";render();if(api)api.dispose();api=new OnlineClient();
            if(!api.user){loading=false;notice="Conecta tu cuenta desde HOME para ver a tus amigos.";render();return;}
            api.request("GET","/social",null,function(result:Object):void {
                if(!alive)return;loading=false;FriendRoster.update(result);people=FriendRoster.list();notice="";render();
            },function(message:String,code:int):void {if(!alive)return;loading=false;notice="No se pudieron cargar tus amigos. Puedes seguir jugando y pulsar RETRY.";render();});
        }
        public function dispose():void {alive=false;if(api)api.dispose();clear();actions=null;selected=null;}
    }
}
