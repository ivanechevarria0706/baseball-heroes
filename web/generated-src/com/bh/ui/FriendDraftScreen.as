package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;
    import com.bh.model.*;import com.bh.online.OnlineClient;
    import com.bh.visual.TeamLogoView;import com.bh.visual.MatchStadium;import com.bh.visual.FriendDraftPortrait;import com.bh.visual.InterfaceSprite;
    /** Accepted friends only. Free selection orders HOME; it never sends social requests. */
    public class FriendDraftScreen extends Sprite {
        private var done:Function,register:Function,recruit:Function,api:OnlineClient,alive:Boolean=true,loading:Boolean=false;
        private var people:Array=[],selected:Array=[],buttons:Array=[],dynamicButtons:Array=[],faces:Array=[];
        private var shell:Sprite=new Sprite(),layer:Sprite=new Sprite(),logo:TeamLogoView,backdrop:MatchStadium;
        private var search:TextField,message:TextField,count:TextField,pageText:TextField,page:int=0,notice:String="";
        private var previous:UIButton,next:UIButton,auto:DraftAutoPickButton;
        public function FriendDraftScreen(w:Number,h:Number,back:Function,registerCallback:Function=null,scoutCallback:Function=null){
            name="friend-draft";done=back;register=registerCallback;recruit=scoutCallback;GameData.init();selected=GameData.friendDraft.concat();
            backdrop=new MatchStadium(w,h);addChild(backdrop);var shade:Shape=new Shape();shade.graphics.beginFill(0x031626,.52);shade.graphics.drawRect(0,0,w,h);shade.graphics.endFill();addChild(shade);
            var scale:Number=Math.min(w/960,h/720);shell.scaleX=shell.scaleY=scale;shell.x=(w-960*scale)/2;shell.y=(h-720*scale)/2;addChild(shell);
            ClassicChrome.panel(shell.graphics,85,40,790,656);ClassicChrome.bar(shell.graphics,94,49,772,59);
            ClassicChrome.title(label(shell,"THE NEW DRAFT BEGINS!",252,57,581,46,34,0xffffff,"center"),36);
            logo=new TeamLogoView(GameData.teamCity,GameData.teamAccent,"",119);logo.x=109;logo.y=85;shell.addChild(logo);
            ClassicChrome.well(shell.graphics,260,114,567,57,false,false);
            label(shell,"Elige hasta cinco amigos. CONTINUE incorpora sus personajes a SUBSTITUTE para usarlos en LINEUP.",274,124,539,41,14,0xe8f5ff);
            label(shell,"EXPECTED POTENTIAL",264,179,320,23,18,0xffdc4f);
            // Only the observed scale is reproduced; no invented potential formula.
            ClassicChrome.fill(shell.graphics,264,206,559,17,[0x06355c,0x084771],[0,255],2);
            for(var tick:int=0;tick<25;tick++) {shell.graphics.lineStyle(1,0x21608a,.65);shell.graphics.moveTo(268+tick*22,209);shell.graphics.lineTo(268+tick*22,220);}
            shell.graphics.lineStyle();label(shell,"WEAK",264,227,95,18,10,0xa1c1d3);label(shell,"GOOD",491,227,95,18,10,0xa1c1d3,"center");label(shell,"STRONG!",728,227,95,18,10,0xa1c1d3,"right");
            ClassicChrome.well(shell.graphics,107,251,743,229,false,false);addChildToShell(layer);
            count=label(shell,"DRAFT 0 / 5 PLAYER",116,487,338,29,21,0xffdc4d);
            auto=new DraftAutoPickButton();auto.name="friend-draft-auto";auto.x=452;auto.y=479;shell.addChild(auto);bind(auto,function():void{autoPick();},buttons);
            label(shell,"Search",643,489,52,22,12,0xd9edfa);
            search=label(shell,"",696,487,140,27,13,0x123f62);search.name="friend-draft-search";search.embedFonts=false;search.defaultTextFormat=new TextFormat("Arial",13,0x123f62,true);search.type=TextFieldType.INPUT;search.selectable=search.mouseEnabled=true;search.maxChars=40;search.background=true;search.backgroundColor=0xeaf7ff;search.border=true;search.borderColor=0x16496c;search.addEventListener(Event.CHANGE,filter);
            previous=button("<","friend-draft-prev",111,548,25,32,prev,0x4196bf);next=button(">","friend-draft-next",824,548,25,32,forward,0x4196bf);
            pageText=label(shell,"1 / 1",402,606,156,19,11,0xbce4fa,"center");pageText.name="friend-draft-page";
            message=label(shell,"Cargando amigos…",115,628,729,25,12,0xd9edfa,"center");message.name="friend-draft-message";
            button("CONTINUE","friend-draft-continue",697,659,151,28,finish,0x81c539);
            button("ADD FRIENDS","friend-draft-register",112,659,218,28,function():void{persist();if(register!=null)register();},0x4196bf);
            if(recruit!=null)button("SCOUT PLAYERS","friend-draft-scout",343,659,335,28,function():void{persist();recruit();},0xb6892a);
            people=FriendRoster.list();if(FriendRoster.ready)normalizeSelected();render();
            if(GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.DRAFT)GameData.claimStarterReward();
            api=new OnlineClient();if(api.user){loading=true;render();api.request("GET","/social",null,function(data:Object):void{if(!alive)return;loading=false;GameData.applySocialSnapshot(data);people=FriendRoster.list();normalizeSelected();render();},function(text:String,code:int):void{if(!alive)return;loading=false;notice="No se actualizaron los amigos. Puedes continuar y volver al draft después.";render();});}
        }
        private function addChildToShell(child:Sprite):void {shell.addChild(child);}
        private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String="left"):TextField {
            var t:TextField=new TextField();t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.multiline=t.wordWrap=true;t.selectable=t.mouseEnabled=false;LineupTypography.fit(t,size,color,align,false,10);parent.addChild(t);return t;
        }
        private function bind(view:Sprite,fn:Function,target:Array):void {var cb:Function=function(e:MouseEvent):void{if(alive){e.stopImmediatePropagation();fn();}};view.addEventListener(MouseEvent.CLICK,cb);target.push({view:view,handler:cb});}
        private function button(value:String,id:String,x:Number,y:Number,w:Number,h:Number,fn:Function,color:uint):UIButton {var b:UIButton=new UIButton(value,w,h,color,0x9bc5d7,0xe9f8ff,13);b.name=id;b.x=x;b.y=y;shell.addChild(b);bind(b,fn,buttons);return b;}
        private function find(id:String):Object {for each(var p:Object in people)if(p.id==id)return p;return null;}
        private function normalizeSelected():void {var known:Array=[];for each(var id:String in selected)if(find(id)&&known.indexOf(id)<0&&known.length<5)known.push(id);selected=known;}
        private function filter(e:Event):void {page=0;notice="";render();}
        private function filtered():Array {var list:Array=[],query:String=search.text.replace(/^\s+|\s+$/g,"").toLowerCase();for each(var p:Object in people)if(query==""||String(p.name).toLowerCase().indexOf(query)>=0)list.push(p);return list;}
        private function clearDynamic():void {for each(var b:Object in dynamicButtons)b.view.removeEventListener(MouseEvent.CLICK,b.handler);dynamicButtons=[];for each(var face:FriendDraftPortrait in faces)face.dispose();faces=[];while(layer.numChildren)layer.removeChildAt(0);layer.graphics.clear();}
        private function face(member:Object,parent:Sprite,x:Number,y:Number,w:Number,h:Number):void {var portrait:FriendDraftPortrait=new FriendDraftPortrait(member,w,h);portrait.x=x;portrait.y=y;parent.addChild(portrait);faces.push(portrait);}
        private function render():void {
            clearDynamic();
            for(var i:int=0;i<25;i++){
                var x:Number=116+(i%5)*144,y:Number=258+int(i/5)*43,p:Object=i<selected.length?find(String(selected[i])):null;
                var cell:Sprite=new Sprite();cell.x=x;cell.y=y;cell.mouseChildren=false;layer.addChild(cell);
                ClassicChrome.well(cell.graphics,0,0,132,37,p!=null,false);
                if(p){cell.name="draft-selected-"+p.id;cell.buttonMode=true;face(p,cell,5,3,29,31);label(cell,String(p.name),39,4,86,27,12,0xffe47f);bind(cell,removeSelection(String(p.id)),dynamicButtons);}
                else {var icon:com.bh.visual.RecruitmentArtwork=new com.bh.visual.RecruitmentArtwork("friends",37,31);icon.x=3;icon.y=3;cell.addChild(icon);label(cell,"OPEN SLOT",43,9,65,18,9,0xb1d8ea);label(cell,(i<9?"0":"")+(i+1),101,10,25,18,9,0x42779a,"right");}
            }
            var list:Array=filtered(),pages:int=Math.max(1,Math.ceil(list.length/5));page=Math.max(0,Math.min(page,pages-1));
            if(list.length==0)label(layer,people.length?"No hay coincidencias. Cambia la búsqueda.":"Tus amigos conectados aparecerán aquí.",145,550,666,35,15,0xa9c9dc,"center");
            for(i=page*5;i<Math.min(list.length,page*5+5);i++){
                p=list[i];var member:Object=p,tile:Sprite=new Sprite(),chosen:Boolean=selected.indexOf(p.id)>=0;tile.name="draft-friend-"+p.id;tile.x=145+(i%5)*134;tile.y=530;tile.buttonMode=true;tile.mouseChildren=false;layer.addChild(tile);
                ClassicChrome.well(tile.graphics,0,0,128,72,chosen,true);face(p,tile,6,7,37,38);
                label(tile,String(p.name),48,8,73,31,12,0x264b61);label(tile,"LV "+int(p.profile&&p.profile.level?p.profile.level:1),48,38,73,17,10,0x507586);
                ClassicChrome.bar(tile.graphics,5,55,118,13,chosen);label(tile,chosen?"SELECTED":"SELECT",8,54,112,17,10,0xffffff,"center");bind(tile,pick(String(member.id)),dynamicButtons);
            }
            previous.mouseEnabled=previous.buttonMode=page>0;previous.alpha=page>0?1:.35;next.mouseEnabled=next.buttonMode=page<pages-1;next.alpha=page<pages-1?1:.35;
            pageText.text=(page+1)+" / "+pages;count.text="DRAFT "+selected.length+" / 5 PLAYER";
            message.text=notice!=""?notice:loading&&people.length==0?"Cargando amigos…":people.length?"Pulsa una ficha para elegirla o retirarla. CONTINUE guarda la selección.":"Todavía no tienes amigos conectados. Puedes continuar y completar el draft después.";
            LineupTypography.fit(message,12,0xd9edfa,"center",false,10);
        }
        private function pick(id:String):Function {return function():void{var i:int=selected.indexOf(id);notice="";if(i>=0)selected.splice(i,1);else if(selected.length<5)selected.push(id);else notice="Ya elegiste cinco. Pulsa una ficha seleccionada para retirarla.";render();};}
        private function removeSelection(id:String):Function{return function():void{var i:int=selected.indexOf(id);if(i>=0)selected.splice(i,1);notice="";render();};}
        private function autoPick():void {selected=[];for each(var p:Object in people){if(selected.length==5)break;selected.push(p.id);}notice="";render();}
        private function prev():void {if(page>0){page--;notice="";render();}}private function forward():void {if(page<Math.ceil(filtered().length/5)-1){page++;notice="";render();}}
        private function persist():Boolean {GameData.friendDraft=selected.slice(0,5);notice="";for each(var id:String in selected){var result:Object=GameData.recruitFriend(id);if(result.status=="ROSTER_FULL")notice="Tu plantilla tiene 30 jugadores. Libera un puesto o retira una selección.";else if(result.status=="NOT_READY")notice="Uno de tus amigos todavía no ha creado su personaje. Retira esa selección para continuar.";else if(result.status=="MATCH_ACTIVE")notice="Termina el partido pendiente antes de incorporar amigos.";else if(result.status=="NOT_FRIEND")notice="Actualiza la lista antes de incorporar a este amigo.";}GameData.save();return notice=="";}
        private function finish():void {if(!persist()){render();return;}GameData.tutorialEvent("draft");if(done!=null)done();}
        public function dispose():void {if(!alive)return;alive=false;if(api)api.dispose();search.removeEventListener(Event.CHANGE,filter);clearDynamic();for each(var b:Object in buttons){b.view.removeEventListener(MouseEvent.CLICK,b.handler);if(b.view is UIButton)UIButton(b.view).dispose();}buttons=[];auto.dispose();logo.dispose();backdrop.dispose();done=register=recruit=null;}
    }
}
