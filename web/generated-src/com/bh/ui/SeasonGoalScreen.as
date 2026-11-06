package com.bh.ui {
 import flash.display.*;import flash.events.*;import flash.geom.*;import flash.filters.*;import flash.text.*;import flash.utils.getTimer;
 import com.bh.model.GameData;import com.bh.visual.LeagueBadgeView;import com.bh.visual.SeasonGoalArtwork;
 /** Goal-setting composition measured from the initial gameplay at 01:44. Animation never generates model goals. */
 public class SeasonGoalScreen extends Sprite {
  private var onDone:Function,header:TravelHeader,badge:LeagueBadgeView;
  private var hrText:TextField,rbiText:TextField,statusText:TextField;
  private var spinButton:Sprite,acceptButton:Sprite,roulette:Sprite=new Sprite();
  private var reels:Array=[],lights:Array=[],rollingAt:int=-1,accepted:Boolean=false,disposed:Boolean=false;
  public function SeasonGoalScreen(w:Number,h:Number,doneCallback:Function) {name="season-goals";onDone=doneCallback;GameData.init();draw(w,h);addChild(roulette);beginRoulette();}
  private function draw(w:Number,h:Number):void {
   var g:Graphics=graphics,m:Matrix=new Matrix();m.createGradientBox(w*1.8,h*1.8,0,-w*.25,-h*.1);
   g.beginGradientFill(GradientType.RADIAL,[0xa66a0d,0x6c3106,0x190c07],[1,1,1],[0,137,255],m);g.drawRect(0,0,w,h);g.endFill();
   for(var i:int=0;i<10;i++){g.beginFill(0xe7a62e,.027);g.moveTo(-280+i*190,95);g.lineTo(-125+i*190,95);g.lineTo(-460+i*190,h);g.lineTo(-615+i*190,h);g.endFill();}
   g.lineStyle(18,0x8c570e,.13);g.moveTo(150,535);g.lineTo(480,235);g.lineTo(810,535);g.lineTo(480,835);g.lineTo(150,535);g.lineStyle();
   header=new TravelHeader();header.alpha=.72;addChild(header);
   g.lineStyle(6,0x171913);ClassicChrome.fill(g,184,184,592,486,[0xfcfcfa,0xe6e6e3,0xcdcdcb],[0,140,255],18);g.lineStyle(2,0xffffff,.95);g.drawRoundRect(187,187,586,480,15);g.lineStyle();
   for(i=0;i<100;i++){var tx:int=194+(i*73)%568,ty:int=199+(i*47)%455;g.beginFill(i%2?0xffffff:0x899194,.045);g.drawCircle(tx,ty,1.2+i%3);g.endFill();}
   badge=new LeagueBadgeView(GameData.leagueIndex,GameData.leagueShortName(),121);badge.x=164;badge.y=149;addChild(badge);
   var ribbon:Sprite=new Sprite();ribbon.x=301;ribbon.y=171;ribbon.rotation=-7;addChild(ribbon);
   ribbon.graphics.beginFill(0x74240a);ribbon.graphics.moveTo(-6,55);ribbon.graphics.lineTo(393,55);ribbon.graphics.lineTo(428,69);ribbon.graphics.lineTo(-9,72);ribbon.graphics.endFill();
   headline(ribbon,"SEASON",0,-24,207,39,30,0x7bdcfa,0x16445c);
   headline(ribbon,"GOAL SETTING",-6,9,430,66,52,0xffdf62,0x62300e);
   g.lineStyle(5,0x0c171c);ClassicChrome.fill(g,582,304,172,169,[0xffffff,0xcdd4d3],[0,255],169);g.lineStyle();
   var coach:SeasonGoalArtwork=new SeasonGoalArtwork(215,224);coach.x=557;coach.y=245;addChild(coach);
   var bubble:Sprite=new Sprite();addChild(bubble);var b:Graphics=bubble.graphics;b.lineStyle(3,0x67b8e1);b.beginFill(0xf9faf9);b.drawRoundRect(205,310,356,140,8);b.endFill();b.beginFill(0xf9faf9);b.moveTo(559,404);b.lineTo(593,400);b.lineTo(562,425);b.endFill();b.lineStyle(3,0xf9faf9);b.moveTo(560,407);b.lineTo(560,420);b.lineStyle();
   label(this,"Establece tus metas de esta\ntemporada",224,324,316,45,16,0x23789e,"center");
   label(this,"El premio depende de los objetivos\nque completes durante la temporada.",220,377,324,56,16,0x353d43,"center");
   drawMachine();
   hrText=label(this,String(GameData.goalTarget())+" "+GameData.goalLabel(),251,507,211,42,28,0x135d87,"center",true);
   rbiText=label(this,String(GameData.seasonGoalRbi)+" RBI",495,507,211,42,28,0x4b8d26,"center",true);
   hrText.filters=[new GlowFilter(0xe6f9ff,1,2,2,6)];rbiText.filters=[new GlowFilter(0xecffe1,1,2,2,6)];
   statusText=label(this,"",226,590,510,21,12,0x37556c,"center");
   acceptButton=ClassicInventorySkin.button("ACCEPT",276,43,0x75b831);acceptButton.name="season-goal-accept";acceptButton.x=337;acceptButton.y=613;addChild(acceptButton);acceptButton.addEventListener(MouseEvent.CLICK,onAccept);
   spinButton=ClassicInventorySkin.button("SPIN AGAIN",119,29,0x447c98);spinButton.name="season-goal-spin";spinButton.x=630;spinButton.y=620;addChild(spinButton);spinButton.addEventListener(MouseEvent.CLICK,onSpin);
  }
  private function drawMachine():void {
   var g:Graphics=graphics;g.lineStyle(2,0x183a57);ClassicChrome.fill(g,224,473,508,116,[0x90e8ff,0x248dbd,0x07527b,0x2a9ccb],[0,57,185,255],6);g.lineStyle(1,0xc9f6ff,.9);g.drawRect(229,478,498,106);g.lineStyle();
   for(var i:int=0;i<2;i++){var x:int=243+i*244;g.lineStyle(3,0x16354f);ClassicChrome.fill(g,x,485,227,92,[0x225c7c,0x06263d,0x407c96],[0,150,255],4);g.lineStyle();ClassicChrome.fill(g,x+8,494,211,69,[0x919b9e,0xf8f9f6,0xd9dedb,0x8b9595],[0,107,174,255],12);g.lineStyle(1,0x7a8587,.3);g.moveTo(x+12,504);g.lineTo(x+215,504);g.moveTo(x+12,552);g.lineTo(x+215,552);g.lineStyle();}
   var bulbs:Sprite=new Sprite();bulbs.mouseEnabled=bulbs.mouseChildren=false;addChild(bulbs);
   for(i=0;i<32;i++){lamp(bulbs,233+i*15.7,480);lamp(bulbs,233+i*15.7,581);}for(i=0;i<5;i++){lamp(bulbs,232,497+i*16);lamp(bulbs,724,497+i*16);}
  }
  private function headline(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,edge:uint):void {
   var offsets:Array=[[-2,-2],[0,-2],[2,-2],[-2,0],[2,0],[-2,2],[0,2],[2,2],[1,4]];
   for each(var d:Array in offsets){var shadow:TextField=label(parent,value,x+d[0],y+d[1],w,h,size,edge,"left",true);ClassicChrome.title(shadow,size,edge,"left");shadow.filters=[];}
   var face:TextField=label(parent,value,x,y,w,h,size,color,"left",true);ClassicChrome.title(face,size,color,"left");face.filters=[];
  }
  private function lamp(parent:Sprite,x:Number,y:Number):void {var s:Sprite=new Sprite();s.x=x;s.y=y;var g:Graphics=s.graphics;g.beginFill(0x102d41);g.drawCircle(0,0,3.8);g.endFill();g.beginFill(0x9cf3ff);g.drawCircle(0,0,2.3);g.endFill();g.beginFill(0xffffff);g.drawCircle(-.6,-.8,1);g.endFill();parent.addChild(s);lights.push(s);}
  private function label(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String="center",heading:Boolean=false):TextField {var t:TextField=new TextField();t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=t.mouseEnabled=false;t.multiline=t.wordWrap=value.indexOf("\n")>=0;LineupTypography.fit(t,size,color,align,heading,10);parent.addChild(t);return t;}
  private function onSpin(e:MouseEvent):void {if(rollingAt>=0||accepted||disposed)return;GameData.spinSeasonGoals();beginRoulette();}
  private function beginRoulette():void {
   finishRoulette();rollingAt=getTimer();spinButton.mouseEnabled=false;spinButton.alpha=.45;statusText.text="La ruleta está girando...";
   var values:Array=[GameData.goalTarget(),GameData.seasonGoalRbi],fields:Array=[hrText,rbiText],suffix:Array=[" "+GameData.goalLabel()," RBI"];
   for(var i:int=0;i<2;i++){var field:TextField=fields[i],window:Sprite=new Sprite(),strip:Sprite=new Sprite();window.name="goal-reel-"+i;window.x=field.x;window.y=494;window.scrollRect=new Rectangle(0,0,211,69);window.addChild(strip);roulette.addChild(window);var count:int=18+i*3;
    for(var j:int=0;j<=count;j++){var t:TextField=new TextField();t.defaultTextFormat=field.defaultTextFormat;t.embedFonts=field.embedFonts;t.antiAliasType=field.antiAliasType;t.text=String(j==count?values[i]:Math.max(1,int(values[i])+(j%7-3)*2))+suffix[i];t.width=211;t.height=42;t.y=j*69+13;t.selectable=t.mouseEnabled=false;t.filters=field.filters;strip.addChild(t);}field.visible=false;reels.push({strip:strip,count:count,field:field,value:values[i]+suffix[i]});
   }
   addEventListener(Event.ENTER_FRAME,onRouletteFrame);
  }
  private function onRouletteFrame(e:Event):void {var age:int=getTimer()-rollingAt;for(var i:int=0;i<reels.length;i++){var r:Object=reels[i],t:Number=Math.min(1,age/(1250+i*280));r.strip.y=-r.count*69*(1-Math.pow(1-t,3));}for(i=0;i<lights.length;i++)lights[i].alpha=((int(age/80)+i)%3==0)?1:.32;if(age>=1530)finishRoulette();}
  private function finishRoulette():void {removeEventListener(Event.ENTER_FRAME,onRouletteFrame);for each(var r:Object in reels){r.field.text=r.value;r.field.visible=true;}while(roulette.numChildren)roulette.removeChildAt(0);reels=[];rollingAt=-1;for each(var l:Sprite in lights)l.alpha=1;if(spinButton){spinButton.mouseEnabled=true;spinButton.alpha=1;}if(statusText)statusText.text="Pulsa ACCEPT para fijar estas metas.";}
  private function onAccept(e:MouseEvent):void {if(accepted||disposed)return;accepted=true;finishRoulette();GameData.acceptSeasonGoals();if(onDone!=null)onDone();}
  public function dispose():void {if(disposed)return;disposed=true;finishRoulette();spinButton.removeEventListener(MouseEvent.CLICK,onSpin);acceptButton.removeEventListener(MouseEvent.CLICK,onAccept);header.dispose();badge.dispose();onDone=null;lights=[];}
 }
}
