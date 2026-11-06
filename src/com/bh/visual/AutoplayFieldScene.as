package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.text.*;
 import com.bh.ui.ClassicInventorySkin;import com.bh.ui.ClassicChrome;import com.bh.ui.LineupTypography;import com.bh.game.BaseballArt;import com.bh.model.*;import com.bh.audio.*;
 /** Playback consumes resolved bases and never computes a new match outcome. */
 public class AutoplayFieldScene extends Sprite {
  public static const VIEW_W:int=224,VIEW_H:int=248;
  private var field:AutoplayFieldArtwork,actors:Sprite=new Sprite(),runnerLayer:Sprite=new Sprite(),bat:MatchBatterSprite,pitcher:PitcherBodySprite,defenders:Array=[],runnerActors:Array=[];
  private var ball:Shape=new Shape(),trail:Shape=new Shape(),caption:TextField=new TextField(),pitcherCaption:TextField=new TextField(),cues:AudioCueSequence;
  private var clock:Function,start:int=0,duration:int=600,preparation:int=400,result:String="",batter:Object,defensePlayers:Array=[],defenseKey:String="",batterKey:String="",dead:Boolean=false;
  private var caught:Boolean=false,thrown:Boolean=false,received:Boolean=false,lastProgress:Number=0,maxLegs:Number=1;
  private const LOCATIONS:Array=[[45,94],[112,66],[179,94],[82,122],[185,139],[39,139]],POSITIONS:Array=["LF","CF","RF","SS","1B","3B"];
  public function AutoplayFieldScene(timeSource:Function){
   clock=timeSource;cues=new AudioCueSequence(clock);name="autoplay-live-field";mouseEnabled=mouseChildren=false;
   ClassicChrome.panel(graphics,-3,-3,VIEW_W+6,VIEW_H+6);scrollRect=new Rectangle(-3,-3,VIEW_W+6,VIEW_H+6);
   ClassicInventorySkin.gradient(graphics,0,0,VIEW_W,20,0x226c96,0x0b304c,3);
   field=new AutoplayFieldArtwork(VIEW_W,206);field.y=20;addChild(field);addChild(trail);addChild(actors);actors.addChild(runnerLayer);
   BaseballArt.draw(ball.graphics,2.7);ball.visible=false;addChild(ball);
   caption.width=VIEW_W-6;caption.height=19;caption.x=3;caption.selectable=false;LineupTypography.apply(caption,10,0xffffff,"center",true);caption.text="LIVE PLAY";addChild(caption);
   ClassicInventorySkin.gradient(graphics,0,226,VIEW_W,22,0x164f64,0x092b3b,3);pitcherCaption.width=VIEW_W-6;pitcherCaption.height=21;pitcherCaption.x=3;pitcherCaption.y=228;pitcherCaption.selectable=false;addChild(pitcherCaption);
  }
  public function prepare(player:Object,defenseColor:uint,attackColor:uint,delay:int,roster:Array=null,attackCity:String=null):void{
   if(dead||!player)return;cues.stopAll();clearRunners();batter=player;preparation=Math.max(120,delay);start=int(clock());result="";lastProgress=0;ball.visible=false;trail.graphics.clear();caught=thrown=received=false;
   var defending:Array=roster&&roster.length?roster:MatchRosterIdentity.opponent(GameData.currentOpponent()),key:String=defenseColor+":";
   for each(var member:Object in defending)key+=MatchRosterIdentity.key(member)+";";
   if(key!=defenseKey){
    defenseKey=key;defensePlayers=defending;
    if(pitcher){pitcher.dispose();actors.removeChild(pitcher);}var arm:Object=MatchRosterIdentity.atPosition(defending,"P",8);pitcher=new PitcherBodySprite(defenseColor,String(arm.name),arm);pitcher.scaleX=pitcher.scaleY=.23;pitcher.x=112;pitcher.y=136;actors.addChildAt(pitcher,0);
    for each(var old:FieldingSprite in defenders){old.dispose();actors.removeChild(old);}defenders=[];
    for(var i:int=0;i<POSITIONS.length;i++){member=MatchRosterIdentity.atPosition(defending,POSITIONS[i],i);var f:FieldingSprite=new FieldingSprite(defenseColor,String(member.name),member);f.scaleX=f.scaleY=.16;actors.addChildAt(f,0);defenders.push(f);}
    pitcherCaption.text="P: "+arm.name;LineupTypography.fit(pitcherCaption,9,0xcce8e7,"center",false,8);
   }
   key=MatchRosterIdentity.key(player)+":"+attackColor+":"+attackCity;
   if(key!=batterKey){batterKey=key;if(bat){bat.dispose();actors.removeChild(bat);}bat=new MatchBatterSprite(player,attackColor,attackCity||GameData.teamCity);bat.scaleX=bat.scaleY=.21;bat.x=87;bat.y=206;actors.addChild(bat);}
   resetDefenders();bat.setFrame(0);caption.text=String(player.name).toUpperCase();LineupTypography.fit(caption,10,0xffffff,"center",true,8);
  }
  private function resetDefenders():void {for(var i:int=0;i<defenders.length;i++){var f:FieldingSprite=defenders[i];f.x=LOCATIONS[i][0];f.y=LOCATIONS[i][1];f.rotation=0;f.setFrame(0);}if(pitcher)pitcher.setFrame(0);}
  public function resolve(kind:String,hold:int,before:Array=null,after:Array=null):void {
   if(!bat)return;cues.stopAll();clearRunners();resetDefenders();result=kind.replace(/ \+.*/,"");duration=Math.max(180,hold);start=int(clock());lastProgress=0;caught=thrown=received=false;
   caption.text=result+" · "+batter.name;LineupTypography.fit(caption,10,0xffffff,"center",true,8);
   var hit:Boolean=isHit(),walk:Boolean=result.indexOf("WALK")>=0;
   if(before)for(var i:int=0;i<3;i++)if(before[i])addRunner(before[i],i+1,hit||walk?finishBase(before[i],after,4):i+1);
   if(hit||walk||result=="GROUND OUT")addRunner(batter,0,result=="GROUND OUT"?.93:finishBase(batter,after,result=="HOME RUN"?4:result=="TRIPLE"?3:result=="DOUBLE"?2:1));
   bat.setFrame(walk||result=="STRIKE OUT"?0:6);advance(start);
  }
  private function isHit():Boolean {return result=="SINGLE"||result=="DOUBLE"||result=="TRIPLE"||result=="HOME RUN";}
  private function finishBase(player:Object,after:Array,fallback:int):int {if(after)for(var i:int=0;i<3;i++)if(after[i]&&MatchRosterIdentity.key(after[i])==MatchRosterIdentity.key(player))return i+1;return fallback;}
  private function addRunner(player:Object,from:Number,to:Number):void {var view:RunnerSprite=new RunnerSprite(player);view.scaleX=view.scaleY=.115;runnerLayer.addChild(view);runnerActors.push({view:view,player:player,from:from,to:to});maxLegs=Math.max(maxLegs,to-from);}
  private function clearRunners():void {for each(var route:Object in runnerActors)RunnerSprite(route.view).dispose();runnerActors=[];while(runnerLayer.numChildren)runnerLayer.removeChildAt(0);maxLegs=1;}
  private function localAnchor(actor:DisplayObject,point:Point):Point {return globalToLocal(actor.localToGlobal(point));}
  private function flight(from:Point,to:Point,t:Number,arc:Number):void {t=Math.max(0,Math.min(1,t));ball.x=from.x+(to.x-from.x)*t;ball.y=from.y+(to.y-from.y)*t-Math.sin(t*Math.PI)*arc;ball.scaleX=ball.scaleY=1-.18*Math.sin(t*Math.PI);}
  public function advance(now:int):void {
   if(dead||!bat)return;var elapsed:Number=Math.max(0,now-start),p:Number=Math.min(1,elapsed/(result==""?preparation:duration));
   if(result==""){
    pitcher.setFrame(p<.6?PitcherBodySprite.windupFrame(p/.6):16+Math.min(7,int((p-.6)/.4*8)));bat.setFrame(p<.5?0:3);
    ball.visible=p>=.6;var hand:Point=localAnchor(pitcher,pitcher.releaseAnchor());flight(hand,localAnchor(bat,bat.contact()),(p-.6)/.4,2);ball.rotation=elapsed*.7;return;
   }
   var hit:Boolean=isHit(),ground:Boolean=result=="GROUND OUT",fly:Boolean=result=="FLY OUT",walk:Boolean=result.indexOf("WALK")>=0;
   bat.setFrame(walk||result=="STRIKE OUT"?0:p<.12?6:p<.32?18:p<.55?19:p<.8?20:21);pitcher.setFrame(16+Math.min(7,int(p*8)));
   var contact:Point=localAnchor(bat,bat.contact()),chaser:int=ground?3:0,f:FieldingSprite=defenders[chaser],home:Array=LOCATIONS[chaser],landing:Point=new Point(ground?96:55,ground?132:96),motion:Number=Math.min(1,p/.48);
   if(ground||fly||hit&&result!="HOME RUN"){
    f.x=Number(home[0])+(landing.x-Number(home[0]))*motion;f.y=Number(home[1])+(landing.y-Number(home[1]))*motion;
    f.setFrame(p<.36?[0,1,14,12,13,14][int(elapsed/65)%6]:p<.50?(fly?8:2):p<.58?(fly?9:3):fly?10:p<.72?4+Math.min(2,int((p-.58)/.14*3)):7);
   }
   var receiverIndex:int=result=="DOUBLE"?3:result=="TRIPLE"?5:4,receiver:FieldingSprite=defenders[receiverIndex];
   if(result=="DOUBLE"){var cover:Point=AutoplayRunPath.point(2);receiver.x=82+(cover.x-82)*Math.min(1,p/.5);receiver.y=122+(cover.y-122)*Math.min(1,p/.5);}
   var glove:Point=localAnchor(f,f.anchor()),throwHand:Point=localAnchor(f,f.anchor(true,6)),target:Point=localAnchor(receiver,receiver.anchor(false,8));
   if(result=="HOME RUN"){ball.visible=p<.80;flight(contact,new Point(193,42),p/.80,45);}
   else if(ground||fly||hit){
    if(p<.50){ball.visible=true;flight(contact,glove,p/.5,ground?5:hit?28:45);if(ground)ball.y-=Math.abs(Math.sin(p/.5*Math.PI*3))*4;}
    else if(fly){ball.visible=false;}
    else if(p<.72){ball.visible=false;}
    else {ball.visible=p<.90;receiver.setFrame(p<.82?3:p<.9?8:10);flight(throwHand,target,(p-.72)/.18,8);}
    if(!caught&&p>=.50){caught=true;cues.enqueue(GameplayAudio.CATCH,0,.28);}
    if(!thrown&&!fly&&p>=.72){thrown=true;cues.enqueue(GameplayAudio.PITCH,0,.20);}
    if(!received&&!fly&&p>=.90){received=true;cues.enqueue(GameplayAudio.CATCH,0,.24);}
   }else ball.visible=false;
   trail.graphics.clear();if(ball.visible){trail.graphics.lineStyle(1.2,0xffeaba,.65);trail.graphics.moveTo(ball.x-5,ball.y+4);trail.graphics.lineTo(ball.x,ball.y);trail.graphics.lineStyle();}ball.rotation=elapsed*.75;
   for each(var route:Object in runnerActors){
    var legs:Number=Math.max(0,route.to-route.from),distance:Number=Math.min(legs,Math.max(0,(p-.07)/.78)*maxLegs),point:Point=AutoplayRunPath.point(route.from+distance),view:RunnerSprite=route.view,dir:Point=AutoplayRunPath.point(Math.min(route.to,route.from+distance+.03));
    view.x=point.x;view.y=point.y;view.visible=!(route.to>=4&&distance>=legs);if(Math.abs(dir.x-point.x)>.01)view.scaleX=Math.abs(view.scaleX)*(dir.x<point.x?-1:1);
    if(distance<legs)view.runAt(elapsed);else view.arrive(Math.max(0,elapsed-duration*(.07+legs/maxLegs*.78)),route.to==2||route.to==3);
   }lastProgress=p;
  }
  public function reset():void {if(dead)return;cues.stopAll();result="";start=int(clock());lastProgress=0;ball.visible=false;trail.graphics.clear();clearRunners();resetDefenders();if(bat)bat.setFrame(0);caption.text="LIVE PLAY";}
  public function dispose():void {if(dead)return;dead=true;cues.dispose();clearRunners();field.dispose();if(bat)bat.dispose();if(pitcher)pitcher.dispose();for each(var f:FieldingSprite in defenders)f.dispose();defenders=[];}
 }
}
