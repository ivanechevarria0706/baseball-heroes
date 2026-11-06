package com.bh.ui {
 import flash.display.Sprite;import flash.events.MouseEvent;import flash.text.TextField;import com.bh.model.GameData;import com.bh.visual.TeamLogoView;
 /** A read-only league table. The nine scheduled clubs fit one page; old extra clubs can paginate. */
 public class SeasonStandingsOverlay extends Sprite {
  private var close:Function,rows:Array,logos:Array=[],controls:Array=[],body:Sprite=new Sprite(),page:int=0,pageText:TextField,previous:LineupButton,next:LineupButton,dead:Boolean=false;
  public function SeasonStandingsOverlay(onClose:Function){name="season-standings-overlay";close=onClose;mouseEnabled=mouseChildren=true;graphics.beginFill(0x061727,.80);graphics.drawRect(0,0,960,720);graphics.endFill();ClassicChrome.panel(graphics,103,94,754,582);ClassicChrome.bar(graphics,111,102,738,78);
   ClassicInventorySkin.text(this,"TEAM STANDINGS",135,112,610,38,26,0xffe27e,"left",true);ClassicInventorySkin.text(this,GameData.seasonStandingsLeagueName()+" LEAGUE  ·  SEASON "+GameData.seasonNumber,137,151,622,25,13,0xd4edf3,"left");
   add("standings-close","X",810,112,34,34,0xcacaca,function(e:MouseEvent):void{if(close!=null)close();});
   var headers:Array=[["RANK",120,59],["TEAM",224,275],["WINS",514,66],["LOSSES",595,66],["PLAYED",679,66],["PCT",766,66]];ClassicChrome.well(graphics,114,190,730,31,false,false);
   for each(var h:Array in headers)ClassicInventorySkin.text(this,h[0],h[1],197,h[2],24,12,0xd8edf0,h[0]=="TEAM"?"left":"center",true);
   addChild(body);rows=GameData.seasonStandings();previous=add("standings-prev","<",125,584,48,32,0xcacaca,onPrevious);next=add("standings-next",">",788,584,48,32,0xcacaca,onNext);
   pageText=ClassicInventorySkin.text(this,"",238,589,484,25,13,0xffdf79,"center");
   var note:TextField=ClassicInventorySkin.text(this,"Los rivales juegan su jornada al terminar tu partido.\nOrden: porcentaje de victorias; desempate por victorias y nombre.",130,626,700,43,11,0xc0d7df,"center");note.multiline=true;note.wordWrap=true;render();
  }
  private function add(id:String,value:String,x:Number,y:Number,w:Number,h:Number,color:uint,handler:Function):LineupButton {var b:LineupButton=new LineupButton(value,w,h,color,true);b.name=id;b.x=x;b.y=y;b.addEventListener(MouseEvent.CLICK,handler);addChild(b);controls.push({view:b,handler:handler});return b;}
  private function render():void {for each(var logo:TeamLogoView in logos)logo.dispose();logos=[];while(body.numChildren)body.removeChildAt(0);body.graphics.clear();var start:int=page*9;
   for(var i:int=0;i<9&&start+i<rows.length;i++){var r:Object=rows[start+i],y:Number=228+i*38;ClassicChrome.well(body.graphics,115,y,728,36,r.home,false);
    ClassicInventorySkin.text(body,String(r.rank),121,y+6,56,27,17,r.home?0xffdf6b:0xdce9ee,"center",true);
    var icon:TeamLogoView=new TeamLogoView(r.city,uint(r.accent),String(r.teamName).charAt(0),32);icon.x=183;icon.y=y+1;body.addChild(icon);logos.push(icon);
    var title:TextField=ClassicInventorySkin.text(body,String(r.city)+" · "+String(r.teamName)+(r.home?"  (YOU)":""),224,y+6,279,27,12,r.home?0xffe179:0xffffff,"left",true);LineupTypography.fit(title,12,r.home?0xffe179:0xffffff,"left",false,9);
    for each(var n:Array in [[r.wins,514,0x9be76b],[r.losses,595,0xf4b4a3],[r.played,679,0xdde9ec],[Number(r.pct).toFixed(3),766,0xffdf7d]])ClassicInventorySkin.text(body,String(n[0]),n[1],y+6,66,27,16,n[2],"center",true);
   }previous.visible=next.visible=rows.length>9;previous.mouseEnabled=page>0;previous.alpha=page>0?1:.35;next.mouseEnabled=start+9<rows.length;next.alpha=next.mouseEnabled?1:.35;pageText.text="RANK "+(start+1)+" - "+Math.min(rows.length,start+9)+" / "+rows.length+" TEAMS";
  }
  private function onPrevious(e:MouseEvent):void {if(page>0){page--;render();}}
  private function onNext(e:MouseEvent):void {if((page+1)*9<rows.length){page++;render();}}
  public function dispose():void {if(dead)return;dead=true;for each(var l:TeamLogoView in logos)l.dispose();logos=[];for each(var c:Object in controls){c.view.removeEventListener(MouseEvent.CLICK,c.handler);c.view.dispose();}controls=[];close=null;}
 }
}
