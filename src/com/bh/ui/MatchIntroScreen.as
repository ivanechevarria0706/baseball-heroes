package com.bh.ui {
 import flash.geom.Matrix;import flash.display.*;import flash.events.*;import flash.text.*;import flash.ui.Keyboard;import flash.utils.getTimer;
 import com.bh.game.BaseballArt;import com.bh.audio.AudioCueSequence;import com.bh.model.GameData;
 import com.bh.visual.MatchStadium;import com.bh.visual.IntroEmblemArtwork;
 /** Illustrated orbital emblem over the same configured ballpark used in play.
  * Presentation only: GameData still reserves the match in the continuation. */
 public class MatchIntroScreen extends Sprite {
  public static const DURATION:int=5160;
  private static const RING_ANGLES:Array=[-46,31,76];
  private var cues:AudioCueSequence;
  private var onContinue:Function,onBack:Function,clock:Function,startedAt:int=-1,paintedAt:int=-1;
  private var completed:Boolean=false,dead:Boolean=false,attachedStage:Stage;
  private var stadium:MatchStadium,header:TravelHeader,logo:Sprite=new Sprite(),orbits:Sprite=new Sprite(),rings:Array=[];
  private var flyingBall:Sprite=new Sprite(),ballLeather:Sprite=new Sprite(),baseballWord:Sprite=new Sprite();
  private var play:Sprite=new Sprite(),flash:Sprite=new Sprite(),skipButton:UIButton,backButton:UIButton;
  private var screenW:Number,screenH:Number;
  public function MatchIntroScreen(w:Number,h:Number,continueCallback:Function,backCallback:Function=null,timeSource:Function=null) {
   name="season-match-intro";screenW=w;screenH=h;onContinue=continueCallback;onBack=backCallback;clock=timeSource!=null?timeSource:getTimer;GameData.init();
   stadium=new MatchStadium(w,h);addChild(stadium);
   graphics.beginFill(0x06111c);graphics.drawRect(0,0,w,h);graphics.endFill();
   var shade:Shape=new Shape();shade.graphics.beginFill(0x061a20,.27);shade.graphics.drawRect(0,0,w,h);shade.graphics.endFill();addChild(shade);
   header=new TravelHeader(false,GameData.postSeasonMode?GameData.competitionTitle():"");addChild(header);
   orbits.x=w*.5;orbits.y=h*.49;orbits.mouseEnabled=orbits.mouseChildren=false;addChild(orbits);
   for(var i:int=0;i<3;i++) {
    var ring:Sprite=new Sprite(),g:Graphics=ring.graphics;g.lineStyle(12,i==1?0xbad7de:0x155b86,.96);g.drawCircle(0,0,207);g.lineStyle(2,i==1?0xf2ffff:0x69bbdb,.9);g.drawCircle(0,0,202);g.lineStyle(1,0x082f4b,.9);g.drawCircle(0,0,214);g.lineStyle();
    // Small retained highlights give the orbit band texture without a redraw loop.
    for(var j:int=0;j<24;j++){var a:Number=j*Math.PI/12;g.beginFill(i==1?0xffffff:0xb9eafa,.52);g.drawCircle(Math.cos(a)*207,Math.sin(a)*207,1.3);g.endFill();}
    orbits.addChild(ring);rings.push(ring);
   }
   logo.x=w*.5;logo.y=h*.49;logo.mouseEnabled=logo.mouseChildren=false;var emblem:IntroEmblemArtwork=new IntroEmblemArtwork(474,330);emblem.x=-237;emblem.y=-165;logo.addChild(emblem);addChild(logo);
   flyingBall.mouseEnabled=flyingBall.mouseChildren=false;var fire:Shape=new Shape(),fg:Graphics=fire.graphics;
   var fm:Matrix=new Matrix();fm.createGradientBox(220,150,0,-192,-75);fg.beginGradientFill(GradientType.LINEAR,[0x7e1606,0xd92a00,0xff9b1a],[1,1,1],[0,125,255],fm);fg.moveTo(15,-40);fg.curveTo(-30,-95,-75,-57);fg.curveTo(-117,-48,-148,-72);fg.curveTo(-139,-30,-192,-25);fg.curveTo(-125,2,-177,43);fg.curveTo(-111,20,-89,60);fg.curveTo(-39,43,15,40);fg.lineTo(15,-40);fg.endFill();
   fg.beginGradientFill(GradientType.LINEAR,[0xe53900,0xff7200,0xffd338],[1,1,1],[0,140,255],fm);fg.moveTo(-5,-34);fg.curveTo(-47,-67,-75,-27);fg.curveTo(-94,-13,-126,-22);fg.curveTo(-110,-1,-143,19);fg.curveTo(-85,5,-66,36);fg.curveTo(-30,25,-5,34);fg.endFill();
   fg.beginFill(0xffcf35);fg.moveTo(-21,-20);fg.curveTo(-57,-35,-77,-3);fg.curveTo(-58,-9,-92,20);fg.curveTo(-55,5,-21,20);fg.endFill();flyingBall.addChild(fire);BaseballArt.draw(ballLeather.graphics,54);flyingBall.addChild(ballLeather);addChild(flyingBall);
   baseballWord.x=w*.5;baseballWord.y=h*.49;baseballWord.mouseEnabled=baseballWord.mouseChildren=false;headline(baseballWord,"BASEBALL",-270,-65,540,120,78,0x86e5ff);addChild(baseballWord);
   play.x=w*.5;play.y=h*.80;play.mouseEnabled=play.mouseChildren=false;addChild(play);headline(play,"PLAY BALL!",-230,-40,460,80,64,0xffe571);
   flash.graphics.beginFill(0xfff3cf);flash.graphics.drawRect(0,104,w,h-104);flash.graphics.endFill();flash.mouseEnabled=false;addChild(flash);
   var kind:String=GameData.postSeasonMode?"REGULAR":GameData.seasonEventType(GameData.seasonGame);
   if(kind!="REGULAR")label(kind+" MATCH · "+(kind=="SPECIAL"?"WIN: MYSTERY BOX · LOSE: 500 COINS":"WIN BONUS: 2,000 COINS"),130,111,w-260,28,16,0xffe47b);
   label(GameData.competitionDetail(),190,h-109,w-380,26,16,0xffffff);
   label("Pulsa SKIP o Enter para comenzar.",235,h-78,w-470,22,12,0xd8edf6);
   skipButton=new UIButton("SKIP",92,32,0x234f72,0x3476a2,0x92c8e5);skipButton.name="match-intro-skip";skipButton.x=w-108;skipButton.y=h-45;skipButton.addEventListener(MouseEvent.CLICK,onSkip);addChild(skipButton);
   if(onBack!=null){backButton=new UIButton("BACK",92,32,0x5d6265,0x73797d,0xb8c0c4);backButton.name="match-intro-back";backButton.x=16;backButton.y=h-45;backButton.addEventListener(MouseEvent.CLICK,onBackClick);addChild(backButton);}
   cues=new AudioCueSequence(clock);addEventListener(Event.ENTER_FRAME,onFrame);addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
   if(stage)installStageEvents();else addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
   render(-1);
  }
  private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):void {var t:TextField=ClassicInventorySkin.text(this,value,x,y,w,h,size,color,"center");LineupTypography.fit(t,size,color,"center");}
  private function headline(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):void {
   var offsets:Array=[[-2,-2],[2,-2],[-2,2],[2,2],[-2,0],[2,0],[0,-2],[0,2],[1,4]];
   for each(var p:Array in offsets){var t:TextField=ClassicInventorySkin.text(parent,value,x+p[0],y+p[1],w,h,size,0x173c50,"center");ClassicChrome.title(t,size,0x173c50);t.filters=[];}
   t=ClassicInventorySkin.text(parent,value,x,y,w,h,size,color,"center");ClassicChrome.title(t,size,color);t.filters=[];
  }
  private function unit(ms:Number,start:Number,duration:Number):Number{return Math.max(0,Math.min(1,(ms-start)/duration));}
  private function render(ms:int):void {
   paintedAt=ms;var t:int=ms-1720,enter:Number=unit(t,1050,450),ease:Number=1-Math.pow(1-enter,3),exit:Number=unit(t,2350,600);
   logo.visible=t>=1050&&exit<1;logo.scaleX=(.35+.65*ease)*(1-exit*.85);logo.scaleY=.65+.35*ease;logo.rotation=(1-ease)*-12;logo.alpha=ease*(1-exit);
   orbits.visible=t>=620&&t<3200;orbits.alpha=unit(t,620,180)*(1-unit(t,2800,400));
   for(var i:int=0;i<rings.length;i++){rings[i].rotation=RING_ANGLES[i]+Math.max(0,t)*(i%2?-.07:.055);rings[i].scaleX=.24+.70*Math.abs(Math.sin(Math.max(0,t)/680+i*1.07));}
   baseballWord.visible=t>=620&&t<1400;var word:Number=unit(t,620,320);baseballWord.scaleX=.18+.82*(1-Math.pow(1-word,3));baseballWord.scaleY=.8+.2*word;baseballWord.alpha=unit(t,620,110)*(1-unit(t,1180,220));
   flyingBall.visible=(t>=0&&t<640)||(t>=2470&&t<3360);var flight:Number=unit(t,0,640);
   if(t<640){flyingBall.x=-130+(screenW+320)*flight;flyingBall.y=screenH*.92-(screenH+120)*flight+Math.sin(flight*Math.PI)*-65;flyingBall.scaleX=flyingBall.scaleY=2.25-1.55*flight;flyingBall.rotation=-35;}
   else{var toward:Number=unit(t,2470,890);flyingBall.x=screenW*.5;flyingBall.y=screenH*.49;flyingBall.scaleX=flyingBall.scaleY=.55+13*toward*toward;flyingBall.rotation=toward*90;}
   ballLeather.rotation=Math.max(0,t)*.20;
   play.alpha=0; // Source ends with a baseball wipe into the team presentation.
   var zoom:Number=1.025-.025*unit(ms,0,5100);stadium.scaleX=stadium.scaleY=zoom;stadium.x=screenW*(1-zoom)/2;stadium.y=screenH*(1-zoom)/2;
   flash.alpha=unit(t,3180,180);
  }
  private function onFrame(e:Event):void {if(dead||completed||!stage)return;if(startedAt<0){startedAt=int(clock());cues.enqueue("match_confirm.mp3",0,.70);cues.enqueue("match_intro.mp3",1720,.78);}var elapsed:int=Math.max(0,int(clock())-startedAt);cues.advance();render(elapsed);if(elapsed>=DURATION)finish();}
  private function onRemoved(e:Event):void {if(e.target===this)dispose();}
  private function onAddedToStage(e:Event):void {removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);installStageEvents();}
  private function installStageEvents():void {attachedStage=stage;if(attachedStage)attachedStage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);}
  private function onSkip(e:MouseEvent):void {e.stopPropagation();finish();}
  private function onBackClick(e:MouseEvent):void {e.stopPropagation();if(completed||dead)return;completed=true;cleanupListeners();var callback:Function=onBack;onContinue=onBack=null;if(callback!=null)callback();}
  private function onKeyDown(e:KeyboardEvent):void {if(e.keyCode==Keyboard.SPACE||e.keyCode==Keyboard.ENTER)finish();}
  private function finish():void {if(completed||dead)return;completed=true;cleanupListeners();var callback:Function=onContinue;onContinue=onBack=null;if(callback!=null)callback();}
  private function cleanupListeners():void {removeEventListener(Event.REMOVED_FROM_STAGE,onRemoved);if(cues)cues.dispose();removeEventListener(Event.ENTER_FRAME,onFrame);removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);if(attachedStage){attachedStage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);attachedStage=null;}}
  public function dispose():void {if(dead)return;dead=true;completed=true;cleanupListeners();stadium.dispose();header.dispose();skipButton.removeEventListener(MouseEvent.CLICK,onSkip);skipButton.dispose();if(backButton){backButton.removeEventListener(MouseEvent.CLICK,onBackClick);backButton.dispose();}onContinue=onBack=null;}
 }
}
