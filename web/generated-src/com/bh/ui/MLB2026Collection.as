package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.text.*;
 import com.bh.model.GameData;import com.bh.model.MLB2026Catalog;import com.bh.model.MLBNormalPlayers;import com.bh.model.SpecialCardCatalog;
 import com.bh.visual.MLBPlayerArtwork;
 /** The full dated directory is browsable; only illustrated batters enter special batting slots. */
 public class MLB2026Collection extends Sprite {
  private var content:Sprite=new Sprite(),handlers:Array=[],artwork:Array=[],selected:Object,entries:Array,filtered:Array=[],teams:Array=[{id:0,name:"ALL TEAMS"}];
  private var back:Function,confirming:Boolean=false,message:String="",alive:Boolean=true,query:String="",role:String="ALL",rank:String="ALL",team:int=0,page:int=0,teamMenu:Boolean=false,input:TextField;
  public function MLB2026Collection(close:Function){
   name="mlb-2026-collection";back=close;entries=MLB2026Catalog.directory();selected=entries[0];var seen:Object={};
   for each(var c:Object in entries)if(!seen[c.teamId]){seen[c.teamId]=true;teams.push({id:c.teamId,name:c.realTeam});}
   teams.sortOn("name");for(var n:int=0;n<teams.length;n++)if(teams[n].id==0){teams.unshift(teams.splice(n,1)[0]);break;}
   addChild(content);filter();
  }
  private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int=13,color:uint=0xffffff,align:String="left",id:String=""):TextField {
   var t:TextField=ClassicInventorySkin.text(content,value,x,y,w,h,size,color,align,size>=23);t.name=id;
   while(t.textWidth>w-3&&size>8){size--;var f:TextFormat=t.getTextFormat();f.size=size;t.defaultTextFormat=f;t.setTextFormat(f);}return t;
  }
  private function button(id:String,value:String,x:Number,y:Number,w:Number,h:Number,fn:Function,enabled:Boolean=true,color:uint=0x167fac):void {
   var b:Sprite=ClassicInventorySkin.button(value,w,h,color);b.name=id;b.x=x;b.y=y;b.mouseEnabled=enabled;b.mouseChildren=false;b.alpha=enabled?1:.45;content.addChild(b);b.addEventListener(MouseEvent.CLICK,fn);handlers.push({view:b,callback:fn});
  }
  private function clear():void {if(input)input.removeEventListener(Event.CHANGE,search);input=null;for each(var a:Object in handlers)a.view.removeEventListener(MouseEvent.CLICK,a.callback);handlers=[];for each(var s:MLBPlayerArtwork in artwork)s.dispose();artwork=[];while(content.numChildren)content.removeChildAt(0);content.graphics.clear();}
  private function choose(c:Object):Function {return function(e:MouseEvent):void{if(!alive)return;selected=c;confirming=false;message="";render();};}
  private function fold(value:String):String {var from:String="áéíóúüñàèìòùâêîôûäëïöç",to:String="aeiouunaeiouaeiouaeioc";value=value.toLowerCase();for(var i:int=0;i<from.length;i++)value=value.split(from.charAt(i)).join(to.charAt(i));return value;}
  private function filter():void {
   filtered=[];var q:String=fold(query).replace(/^\s+|\s+$/g,"");
   for each(var c:Object in entries)if((role=="ALL"||c.role==role)&&(rank=="ALL"||c.cardClass==rank)&&(!team||c.teamId==team)&&(!q.length||fold(c.name+" "+c.realTeam+" "+c.realPosition).indexOf(q)>=0))filtered.push(c);
   page=0;confirming=false;message="";if(filtered.length)selected=filtered[0];render();
  }
  private function search(e:Event):void {query=input.text;filter();if(stage&&input){stage.focus=input;input.setSelection(query.length,query.length);}}
  private function cycleRole(e:MouseEvent):void {role=role=="ALL"?"BATTER":role=="BATTER"?"PITCHER":"ALL";filter();}
  private function cycleClass(e:MouseEvent):void {var classes:Array=["ALL","S","A","B","C"];rank=classes[(classes.indexOf(rank)+1)%classes.length];filter();}
  private function chooseTeam(id:int):Function {return function(e:MouseEvent):void{team=id;teamMenu=false;filter();};}
  private function render():void {
   clear();var g:Graphics=content.graphics;ClassicChrome.fill(g,0,0,960,720,[0x103b55,0x052334],[0,255]);ClassicChrome.panel(g,20,20,920,680);ClassicChrome.bar(g,29,29,902,57);
   label("2026 PLAYERS",47,39,480,40,30,0xffffff,"left","mlb-title");label("C "+GameData.coins,688,46,170,25,17,0xffdb68,"right","mlb-coins");button("mlb-close","X",878,40,39,32,function(e:MouseEvent):void{if(alive&&back!=null)back();});
   button("mlb-role","ROLE  "+role,46,96,239,27,cycleRole);button("mlb-rank","CLASS  "+rank,294,96,184,27,cycleClass);
   ClassicChrome.well(g,46,131,432,29,false,false);input=new TextField();input.name="mlb-search";input.type=TextFieldType.INPUT;input.defaultTextFormat=new TextFormat("Trebuchet MS",14,0xffffff);input.x=52;input.y=134;input.width=420;input.height=24;input.maxChars=80;input.text=query;content.addChild(input);input.addEventListener(Event.CHANGE,search);
   if(!query.length)label("SEARCH NAME / TEAM / POSITION",55,135,408,22,12,0x8db4c2).mouseEnabled=false;
   label("SNAPSHOT  "+selected.snapshotDate,512,96,399,23,12,0xaed5e0,"right");
   for(var i:int=page*12;i<Math.min(filtered.length,page*12+12);i++)tile(filtered[i],i%12);
   if(!filtered.length)label("NO MATCHING PLAYERS",47,277,431,50,21,0xffdc81,"center","mlb-empty");
   var pages:int=Math.max(1,Math.ceil(filtered.length/12));
   button("mlb-prev","<",46,572,49,29,function(e:MouseEvent):void{if(page>0){page--;render();}},page>0);
   label((page+1)+" / "+pages+"   -   "+filtered.length+" PLAYERS",99,577,322,23,13,0xc6e8ed,"center","mlb-page");
   button("mlb-next",">",429,572,49,29,function(e:MouseEvent):void{if(page<pages-1){page++;render();}},page<pages-1);
   var teamName:String="ALL TEAMS";for each(var tm:Object in teams)if(tm.id==team)teamName=tm.name;
   button("mlb-team-filter",teamName+"  v",46,608,432,31,function(e:MouseEvent):void{teamMenu=!teamMenu;render();});
   ClassicChrome.well(g,502,128,410,465,false,false);label(String(selected.name),517,140,380,32,24,0xffe3a0,"center","mlb-selected-name");
   var pitcher:Boolean=selected.role=="PITCHER",ready:Boolean=selected.artReady;
   label(selected.normalPlayer?"NORMAL PLAYER  /  C":selected.cardClass+"  /  NORMAL",525,177,164,22,15,SpecialCardCatalog.classColor(selected.cardClass),"center","mlb-class");
   if(ready){var body:MLBPlayerArtwork=new MLBPlayerArtwork(selected,192,286);body.x=515;body.y=204;body.name="mlb-body-preview";content.addChild(body);artwork.push(body);}
   else label("ART IN PROGRESS",519,324,186,60,16,0xbce6ed,"center","mlb-art-pending");
   label("2026 SEASON",717,185,174,23,14,0x8edfe7);label(pitcher?"ROLE "+selected.pitchRole+"   THROWS "+selected.pitchHand:"ROLE "+selected.realPosition+"   BATS "+selected.batSide,717,213,174,23,12,0xffffff);
   var stats:String=pitcher?"GAMES  "+selected.seasonGames+"\nERA       "+selected.seasonERA+"\nWHIP    "+selected.seasonWHIP+"\nIP           "+selected.seasonIP+"\nK            "+selected.seasonK:"GAMES  "+selected.seasonGames+"\nAVG      ."+padAVG(selected.avg)+"\nHR         "+selected.seasonHR+"\nRBI        "+selected.seasonRBI+"\nOPS      "+selected.seasonOPS;
   label(stats,717,245,174,117,14,0xffffff,"left","mlb-season-stats");
   label("GAME ATTRIBUTES",717,373,178,24,13,0xffdc81);bar(pitcher?"STUFF":"POWER",int(pitcher?selected.pitchStuff:selected.power),717,402);bar(pitcher?"CONTROL":"CONTACT",int(pitcher?selected.pitchControl:selected.contact),717,433);bar(pitcher?"STAMINA":"SPEED",int(pitcher?selected.pitchStamina:selected.speed),717,464);
   label(String(selected.realTeam),516,501,380,24,13,0xbce6ed,"center","mlb-team");
   label(selected.normalPlayer?"PERMANENT TEAMMATE":pitcher?"PITCHER DIRECTORY":GameData.specialAbilityLabel(selected),518,531,377,22,14,0xffe19a,"center","mlb-special-ability");
   label(selected.sampleStatus=="PROVISIONAL"?"PROVISIONAL  /  LIMITED SEASON SAMPLE":pitcher?"CLASS COMPARED WITH "+selected.pitchRole:"COMBO +"+selected.combo+"     LUCK "+selected.luck,518,554,377,20,11,selected.sampleStatus=="PROVISIONAL"?0xffc86c:0xc3e8ec,"center","mlb-sample");
   var normal:Boolean=selected.normalPlayer===true,owned:Boolean=normal?MLBNormalPlayers.owned(int(selected.mlbId)):!pitcher&&GameData.ownsSpecialCatalog(String(selected.id)),locked:Boolean=GameData.leagueIndex<MLB2026Catalog.league(selected),active:Boolean=GameData.pendingSpecialMatch(),tutorial:Boolean=GameData.tutorialActive(),cost:int=MLB2026Catalog.price(selected);
   var caption:String=pitcher&&!normal?"PITCHER  /  DIRECTORY":!ready?"ART IN PROGRESS":owned?"OWNED":tutorial?"COMPLETE TUTORIAL":locked?"REQUIRES "+SpecialCardCatalog.packLeagueName(MLB2026Catalog.league(selected)):confirming?"CONFIRM  C "+cost:"RECRUIT  C "+cost;
   button("mlb-recruit",caption,516,608,380,40,recruit,(!pitcher||normal)&&ready&&!owned&&!locked&&!active&&!tutorial&&GameData.coins>=cost,0x58a338);
   if(confirming)button("mlb-cancel","CANCEL",520,577,91,22,function(e:MouseEvent):void{confirming=false;render();});
   label(message||(normal?(owned?"Jugador normal en tu plantilla. Se entrena y conserva su progreso.":"Jugador normal permanente por 1,500 Coins. No utiliza cargas de carta especial."):pitcher?"Los lanzadores están clasificados por separado; no ocupan puestos de bateadores especiales.":!ready?"El dibujo de este jugador aún está en preparación.":active?"Termina el partido antes de reclutar.":tutorial?"Termina el tutorial inicial antes de reclutar.":owned?"Ya está en tus cartas. Búscalo entre los sustitutos de LINEUP.":GameData.coins<cost?"No tienes suficientes Coins.":"Reclutar usa Coins. Energía: 2 partidos por carga; recuperación automática."),46,650,850,39,12,0xd4e9ec,"center","mlb-help");
   if(teamMenu){var cover:Sprite=new Sprite();cover.name="mlb-team-menu";ClassicChrome.panel(cover.graphics,44,164,438,400);content.addChild(cover);for(i=0;i<teams.length;i++)button("mlb-team-"+teams[i].id,teams[i].name,53+(i%2)*211,172+int(i/2)*24,204,22,chooseTeam(teams[i].id),true,teams[i].id==team?0x59a83e:0x167fac);}
  }
  private function padAVG(value:Object):String {var s:String=String(value);while(s.length<3)s="0"+s;return s;}
  private function bar(title:String,value:int,x:Number,y:Number):void {label(title,x,y,118,18,11,0xb8d7e2);label(String(value),x+119,y,55,18,12,0xffffff,"right");ClassicChrome.well(content.graphics,x,y+19,171,7,false,false);ClassicChrome.fill(content.graphics,x+1,y+20,169*Math.min(100,value)/100,5,[0x84ead7,0x178f9c],[0,255]);}
  private function tile(c:Object,i:int):void {
   var x:Number=46+(i%3)*148,y:Number=167+int(i/3)*99;
   ClassicChrome.well(content.graphics,x,y,139,94,c.id==selected.id,false);
   if(c.artReady){var view:MLBPlayerArtwork=new MLBPlayerArtwork(c,66,55,true);view.x=x+35;view.y=y+3;content.addChild(view);artwork.push(view);}
   else label(c.realPosition,x+35,y+15,66,40,22,0x87bdca,"center");
   label(String(c.name),x+4,y+58,131,18,11,0xffffff,"center","mlb-name-"+c.mlbId);
   label((c.normalPlayer?"NORMAL C":c.cardClass)+"  /  "+c.realPosition+(c.sampleStatus=="PROVISIONAL"?" *":""),x+4,y+77,131,16,10,SpecialCardCatalog.classColor(c.cardClass),"center");
   var hit:Sprite=new Sprite();hit.name="mlb-player-"+c.mlbId;hit.x=x;hit.y=y;hit.graphics.beginFill(0xffffff,0);hit.graphics.drawRect(0,0,139,94);hit.graphics.endFill();hit.buttonMode=true;content.addChild(hit);var fn:Function=choose(c);hit.addEventListener(MouseEvent.CLICK,fn);handlers.push({view:hit,callback:fn});
  }
  private function recruit(e:MouseEvent):void {
   if(!alive||selected.role=="PITCHER"&&!selected.normalPlayer||!selected.artReady)return;if(!confirming){confirming=true;message="Confirma el reclutamiento de "+selected.name+" por "+MLB2026Catalog.price(selected)+" Coins.";render();return;}
   confirming=false;var result:Object=selected.normalPlayer?GameData.recruit2026Normal(String(selected.id)):GameData.recruit2026Player(String(selected.id));message=result.status=="OK"?(selected.normalPlayer?"Jugador normal recibido en tu plantilla y sustitutos de LINEUP.":"Carta recibida. Ya aparece entre los sustitutos de LINEUP."):result.status=="ROSTER_FULL"?"Tu plantilla ya tiene 30 jugadores.":result.status=="COINS"?"No tienes suficientes Coins.":result.status=="ALREADY_OWNED"?"Ya tienes esta edición.":result.status=="MATCH_ACTIVE"?"Termina el partido antes de reclutar.":"Este jugador todavía está bloqueado por tu liga.";render();
  }
  public function dispose():void {if(!alive)return;alive=false;clear();back=null;}
 }
}
