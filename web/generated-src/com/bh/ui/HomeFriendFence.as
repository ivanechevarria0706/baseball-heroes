package com.bh.ui {
 import flash.display.*;import flash.events.MouseEvent;import flash.text.*;import flash.utils.getTimer;
 import com.bh.visual.FriendDraftPortrait;
 /** Eight reference-style cards above the teammates; accepted accounts only. */
 public class HomeFriendFence extends Sprite {
  private var people:Array=[],cards:Array=[],controls:Array=[],faces:Array=[],page:int=0,dead:Boolean=false,covered:Boolean=false;
  private var visit:Function,addFriend:Function,inbox:Function,signature:String="",tip:Sprite=new Sprite(),title:TextField,hint:TextField;
  private var requests:int=0,gifts:int=0,started:int=0,hovered:Object;
  public function HomeFriendFence(onVisit:Function,onAdd:Function,onInbox:Function){name="home-friend-fence";mouseEnabled=false;visit=onVisit;addFriend=onAdd;inbox=onInbox;
   tip.name="home-fence-tooltip";tip.mouseEnabled=tip.mouseChildren=false;ClassicChrome.well(tip.graphics,0,0,206,44);title=label(tip,"",7,3,192,21,12,0x24485b);hint=label(tip,"",7,23,192,17,10,0x57707b);tip.visible=false;update([],0,0);
  }
  private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):TextField {var t:TextField=ClassicInventorySkin.text(parent,value,x,y,w,h,size,color,"center",true);t.mouseEnabled=false;return t;}
  private function bind(view:Sprite,kind:String,fn:Function):void {view.addEventListener(kind,fn);controls.push({view:view,kind:kind,fn:fn});}
  private function clear():void {hovered=null;tip.visible=false;for each(var c:Object in controls)c.view.removeEventListener(c.kind,c.fn);controls=[];for each(var face:FriendDraftPortrait in faces)face.dispose();faces=[];cards=[];while(numChildren)removeChildAt(0);}
  public function update(values:Array,pendingRequests:int=0,pendingGifts:int=0):void {if(dead)return;var accepted:Array=[],seen:Object={};for each(var member:Object in values)if(member&&member.connected===true&&member.id is String&&!seen[member.id]){seen[member.id]=true;accepted.push(member);}
   var next:String=JSON.stringify({members:accepted,requests:Math.max(0,pendingRequests),gifts:Math.max(0,pendingGifts)});if(next==signature)return;signature=next;people=accepted;requests=Math.max(0,pendingRequests);gifts=Math.max(0,pendingGifts);page=Math.max(0,Math.min(page,int(Math.max(0,people.length-1)/8)));render();
  }
  private function render():void {clear();started=getTimer();for(var i:int=0;i<8;i++)makeCard(i,page*8+i<people.length?people[page*8+i]:null);
   if(people.length>8){arrow("home-fence-prev",117,219,false,page>0);arrow("home-fence-next",608,219,true,page<Math.ceil(people.length/8)-1);label(this,(page+1)+"/"+Math.ceil(people.length/8),603,249,40,16,9,0xe6f7ff);}
   if(requests||gifts){var button:Sprite=ClassicInventorySkin.button(requests?"REQUESTS "+requests:"GIFTS "+gifts,119,25,requests?0xc68d2b:0x267fad);button.name=requests?"home-fence-requests":"home-fence-gifts";button.x=648;button.y=211;button.mouseChildren=false;addChild(button);bind(button,MouseEvent.CLICK,function(e:MouseEvent):void {if(dead||covered)return;e.stopPropagation();if(requests){if(addFriend!=null)addFriend();}else if(inbox!=null)inbox();});}
   addChild(tip);
  }
  private function makeCard(index:int,member:Object):void {
   var card:Sprite=new Sprite();card.name="home-fence-slot-"+index;card.x=145+index*58;card.y=204;card.mouseChildren=false;card.buttonMode=card.useHandCursor=true;card.graphics.beginFill(0xffffff,.01);card.graphics.drawRect(0,0,49,51);card.graphics.endFill();addChild(card);
   var paper:Sprite=new Sprite();paper.mouseEnabled=paper.mouseChildren=false;card.addChild(paper);var g:Graphics=paper.graphics;
   g.beginFill(0x103726,.28);g.drawRoundRect(2,5,49,49,5);g.endFill();ClassicChrome.well(g,0,0,49,49,false,true);g.lineStyle(1,0x435c66,.5);g.moveTo(8,-2);g.lineTo(8,3);g.moveTo(40,-2);g.lineTo(40,3);g.lineStyle();
   var ready:Boolean=member&&member.team;
   if(ready){var face:FriendDraftPortrait=new FriendDraftPortrait(member,39,39);face.x=5;face.y=5;paper.addChild(face);faces.push(face);}
   else {g.beginFill(0xc3cbd0);g.drawCircle(24.5,18,9);g.drawRoundRect(11,28,27,16,10);g.endFill();g.beginFill(0xe1e6e8,.5);g.drawCircle(22,15,5);g.endFill();}
   var plus:Sprite=new Sprite();plus.x=46;plus.y=3;plus.mouseEnabled=false;paper.addChild(plus);
   if(!member){g=plus.graphics;g.lineStyle(1,0x76511d);ClassicChrome.fill(g,-6,-6,13,13,[0xfff3b5,0xe7af3b,0xb36f1b],[0,110,255],13);g.lineStyle(1.4,0xffffff);g.moveTo(-3,0);g.lineTo(3,0);g.moveTo(0,-3);g.lineTo(0,3);g.lineStyle();}
   else if(!ready){g=plus.graphics;g.beginFill(0x397ba0);g.drawCircle(0,0,6);g.endFill();g.beginFill(0xffffff);g.drawCircle(-2.5,0,.8);g.drawCircle(0,0,.8);g.drawCircle(2.5,0,.8);g.endFill();}
   var line:Shape=new Shape();line.graphics.lineStyle(2,0x91e4ff);line.graphics.drawRoundRect(1,1,47,47,5);line.alpha=0;paper.addChild(line);
   var entry:Object={view:card,paper:paper,line:line,plus:plus,member:member,ready:ready,index:index,hover:false,mix:0};cards.push(entry);
   bind(card,MouseEvent.ROLL_OVER,function(e:MouseEvent):void {if(dead||covered)return;entry.hover=true;hovered=entry;showTip(entry);});bind(card,MouseEvent.ROLL_OUT,function(e:MouseEvent):void {entry.hover=false;if(hovered==entry){hovered=null;tip.visible=false;}});
   bind(card,MouseEvent.CLICK,function(e:MouseEvent):void {if(dead||covered)return;e.stopPropagation();tip.visible=false;if(entry.ready&&visit!=null)visit(String(entry.member.id));else if(addFriend!=null)addFriend();});
  }
  private function showTip(entry:Object):void {var m:Object=entry.member;title.text=m?String(m.name):"ADD FRIEND";hint.text=m?(entry.ready?"Visitar estadio · LV "+int(m.profile&&m.profile.level||1):"Tu amigo está creando su personaje"):(requests?requests+" solicitudes pendientes":"Buscar amigos o compartir enlace");LineupTypography.fit(title,12,0x24485b,"center");LineupTypography.fit(hint,10,0x57707b,"center");tip.x=Math.max(103,Math.min(603,entry.view.x-78));tip.y=154;tip.visible=true;}
  private function arrow(id:String,x:Number,y:Number,right:Boolean,enabled:Boolean):void {var b:Sprite=ClassicInventorySkin.button(right?"›":"‹",24,25,0x307c9d);b.name=id;b.x=x;b.y=y;b.mouseChildren=false;b.mouseEnabled=b.buttonMode=enabled;b.alpha=enabled?1:.4;addChild(b);bind(b,MouseEvent.CLICK,function(e:MouseEvent):void {if(dead||covered||!enabled)return;e.stopPropagation();page+=right?1:-1;render();});}
  public function setCovered(value:Boolean):void {if(covered==value||dead)return;covered=value;if(value){hovered=null;tip.visible=false;for each(var c:Object in cards)c.hover=false;}}
  public function advance(now:int):void {if(dead)return;for each(var c:Object in cards){var p:Number=Math.max(0,Math.min(1,(now-started-c.index*25)/260)),lift:Number=covered?0:c.hover?1:0;c.mix+=(lift-c.mix)*.25;c.paper.y=6*Math.pow(1-p,3)-c.mix*1.8;c.line.alpha=c.mix*.9;c.plus.scaleX=c.plus.scaleY=1+c.mix*.12;}if(hovered&&!covered&&!tip.visible)showTip(hovered);}
  public function dispose():void {if(dead)return;dead=true;clear();visit=addFriend=inbox=null;people=[];}
 }
}
