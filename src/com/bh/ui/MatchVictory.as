package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.utils.getTimer;import flash.text.*;import flash.filters.GlowFilter;import flash.geom.Rectangle;
 import com.bh.visual.*;import com.bh.model.GameData;
 /** Panoramic team arrival, then champion presentation, before the result screen. */
 public class MatchVictory extends Sprite {
 private var started:int,done:Boolean=false,callback:Function,actors:Array=[],papers:Array=[],title:TextField,runner:RunnerSprite,panorama:Sprite=new Sprite(),stadium:StadiumBackdrop,cup:Sprite=new Sprite(),champion:Boolean;
 public function MatchVictory(w:Number,h:Number,message:String,complete:Function){name="match-victory";callback=complete;champion=message.indexOf("CHAMPION")>=0;
 graphics.beginFill(0x0b2435,.82);graphics.drawRect(0,48,w,h-48);graphics.endFill();
 title=new TextField();LineupTypography.apply(title,52,0xffe653,"center",true);title.text=message;title.width=w;title.height=83;title.y=101;title.filters=[new GlowFilter(0x102b41,1,6,6,5)];title.mouseEnabled=false;addChild(title);
 panorama.y=194;panorama.scrollRect=new Rectangle(0,0,w,350);panorama.name="victory-panorama";addChild(panorama);stadium=new StadiumBackdrop(w,510,false);stadium.y=-80;panorama.addChild(stadium);
 var order:Array=GameData.battingOrderPlayers();for(var i:int=0;i<6;i++){var a:RunnerSprite=new RunnerSprite(order[(i+1)%order.length],i%2==0?5:4);a.x=610+i*55;a.y=310+(i%2)*14;a.scaleX=a.scaleY=.68;a.cheer(i%2==0);actors.push(a);panorama.addChild(a);}
 runner=new RunnerSprite(GameData.mainPlayer());runner.x=-80;runner.y=340;panorama.addChild(runner);
 var g:Graphics=cup.graphics;g.lineStyle(4,0x7b4d17);g.beginFill(0xffd657);g.moveTo(-48,-84);g.lineTo(48,-84);g.curveTo(48,-25,10,-17);g.lineTo(10,17);g.lineTo(40,25);g.lineTo(40,39);g.lineTo(-40,39);g.lineTo(-40,25);g.lineTo(-10,17);g.lineTo(-10,-17);g.curveTo(-48,-25,-48,-84);g.endFill();g.lineStyle(9,0xeebf42);g.moveTo(-47,-71);g.curveTo(-94,-88,-65,-40);g.lineTo(-40,-28);g.moveTo(47,-71);g.curveTo(94,-88,65,-40);g.lineTo(40,-28);g.lineStyle();cup.x=620;cup.y=500;cup.visible=false;addChild(cup);
 for(i=0;i<48;i++){var s:Shape=new Shape();s.graphics.beginFill([0xffd94b,0x60c5e9,0xf5789a,0xa0df54][i%4]);s.graphics.drawRect(-4,-3,9,6);s.graphics.endFill();addChild(s);papers.push(s);}
 var hint:TextField=new TextField();LineupTypography.apply(hint,17,0xffffff,"center");hint.text="CLIC · CONTINUAR";hint.width=w;hint.height=28;hint.y=627;hint.mouseEnabled=false;addChild(hint);
 started=getTimer();addEventListener(Event.ENTER_FRAME,tick);addEventListener(MouseEvent.CLICK,skip);
 }
 private function tick(e:Event):void {var ms:int=getTimer()-started,p:Number=Math.min(1,ms/1900);runner.runAt(ms);runner.x=-80+755*p;runner.y=340-32*p-Math.abs(Math.sin(ms/110))*7*(1-p);runner.scaleX=runner.scaleY=1.45-.74*p;if(ms>=1900){runner.cheer();runner.y=308-Math.abs(Math.sin(ms/150))*6;for(var j:int=0;j<actors.length;j++)actors[j].y=310+(j%2)*14-Math.abs(Math.sin(ms/150+j))*7;}
 if(champion&&ms>=2300){cup.visible=true;cup.scaleX=cup.scaleY=.65+.35*Math.min(1,(ms-2300)/500);if(runner.parent==panorama){panorama.removeChild(runner);addChildAt(runner,getChildIndex(cup));}runner.x=450;runner.scaleX=runner.scaleY=1.1;runner.cheer(true);runner.y=600;}
 for(var i:int=0;i<papers.length;i++){var s:Shape=papers[i];s.visible=ms>=1500;s.x=(i*137)%960+Math.sin(ms/400+i)*18;s.y=180+((i*39+ms*.16)%380);s.rotation=i*43+ms*.1;}if(ms>(champion?4700:3700))finish();}
 private function skip(e:MouseEvent):void {e.stopPropagation();if(getTimer()-started>500)finish();}
 private function finish():void {if(done)return;done=true;removeEventListener(Event.ENTER_FRAME,tick);removeEventListener(MouseEvent.CLICK,skip);if(callback!=null)callback();}
 public function dispose():void {done=true;callback=null;removeEventListener(Event.ENTER_FRAME,tick);removeEventListener(MouseEvent.CLICK,skip);for each(var a:RunnerSprite in actors)a.dispose();runner.dispose();stadium.dispose();actors=[];papers=[];}
 }
}
