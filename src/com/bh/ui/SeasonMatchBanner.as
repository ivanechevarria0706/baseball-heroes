package com.bh.ui {
 import flash.display.*;import flash.geom.*;import flash.text.*;
 import com.bh.model.GameData;
 import com.bh.visual.HeroHead;import com.bh.visual.HomeSprite;import com.bh.visual.VisualProfile;import com.bh.visual.HeroSprite;import com.bh.visual.TeamLogoView;import com.bh.visual.CharacterPortrait;
 /** Read-only matchup, reusing saved hero art and recovered club emblems.
  * Composition measured from the initial gameplay, 01:55. */
 public class SeasonMatchBanner extends Sprite {
  private var leftPart:Sprite=new Sprite(),rightPart:Sprite=new Sprite(),versusPart:Sprite=new Sprite();
  private var actors:Array=[],logos:Array=[],portraits:Array=[],rivalHead:HeroHead;
  public function SeasonMatchBanner(opponent:Object,game:int,result:Object) {
   name="season-match-banner";mouseEnabled=mouseChildren=false;scrollRect=new Rectangle(0,0,960,173);
   addChild(leftPart);addChild(rightPart);addChild(versusPart);var g:Graphics=leftPart.graphics;panel(g,[0,21,518,21,470,170,0,170],0x1591c9,0x063f70,0x72c5e9);
   g=rightPart.graphics;panel(g,[520,1,960,1,960,170,473,170],0xe6a52b,0x9a4a0b,0xf4c36d);
   for(var i:int=0;i<10;i++) {
    var x:int=(i*97)%430,y:int=30+(i*23)%129;
    g=leftPart.graphics;g.beginFill(i%2?0x88d8f7:0x034273,.18);g.drawRect(x,y,Math.min(109,462-x),5+i%3*3);g.endFill();
    g=rightPart.graphics;g.beginFill(i%2?0xffdc87:0x723207,.16);g.drawRect(548+x*.7,y-14,Math.min(131,409-x*.7),5+i%3*3);g.endFill();
   }
   var hero:Object=GameData.mainPlayer(),left:HeroSprite=new HeroSprite(String(hero.name),uint(hero.accent),hero.appearance,"home",.61);
   left.x=99;fitActor(left,false);leftPart.addChild(left);actors.push(left);
   var seed:int=VisualProfile.seed(String(opponent.pitcherName)),appearance:Object={shape:seed%8,hair:int(seed/7)%8,eyes:int(seed/11)%8,nose:int(seed/13)%8,mouth:int(seed/17)%8};
   var right:HeroSprite=new HeroSprite(String(opponent.pitcherName),uint(opponent.accent),appearance,"home",.61,{});
   right.x=868;fitActor(right,true);rightPart.addChild(right);actors.push(right);
   emblem(GameData.teamCity,GameData.teamAccent,209,36,94);emblem(opponent.city,uint(opponent.accent),659,24,100);
   var home:CharacterPortrait=new CharacterPortrait(hero,62,62,true);home.x=370;home.y=52;frame(366,48,70,70);leftPart.addChild(home);portraits.push(home);
   var away:Sprite=new Sprite();away.x=548;away.y=42;away.scrollRect=new Rectangle(0,0,62,62);frame(544,38,70,70);away.graphics.beginFill(VisualProfile.lighter(uint(opponent.accent),.72));away.graphics.drawRect(0,0,62,62);away.graphics.endFill();
   rivalHead=new HeroHead(appearance,HomeSprite.paletteFor(String(opponent.pitcherName),uint(opponent.accent),appearance,{}));rivalHead.scaleX=rivalHead.scaleY=.36;rivalHead.x=31;rivalHead.y=62;away.addChild(rivalHead);rightPart.addChild(away);
   text(String(hero.name),346,122,110,22,13,0xffffff);text(String(opponent.pitcherName),525,113,110,22,13,0xffffff);
   text(GameData.teamName.toUpperCase(),177,133,165,20,12,0xd6ecfc);text(String(opponent.teamName).toUpperCase(),638,133,160,20,12,0xffedbf);
   text(GameData.seasonRecord(),177,151,165,20,12,0xffe275);
   text(result&&(result.scoreKnown===undefined||result.scoreKnown)?result.homeScore+" : "+result.awayScore:"GAME "+game,642,151,152,20,12,0xffe275);
   // Hard offset glyphs avoid renderer-dependent blur/outline filters.
   var positions:Array=[[-3,-3],[3,-3],[-3,3],[3,3],[-3,0],[3,0],[0,-3],[0,3],[1,5]];
   for each(var p:Array in positions)heading("VS",443+p[0],61+p[1],91,66,51,0x14262c);
   heading("VS",443,61,91,66,51,0xffffff);setEntrance(1);
  }
  public function setEntrance(p:Number):void {p=Math.max(0,Math.min(1,p));var e:Number=1-Math.pow(1-p,3);leftPart.x=-960*(1-e);rightPart.x=960*(1-e);var zoom:Number=.6+.4*e;versusPart.scaleX=versusPart.scaleY=zoom;versusPart.x=480*(1-zoom);versusPart.y=95*(1-zoom);versusPart.alpha=Math.max(0,Math.min(1,(p-.40)/.60));}
  private function group(x:Number,w:Number=0):Sprite {return x+w/2<460?leftPart:x+w/2>520?rightPart:versusPart;}
  private function fitActor(actor:HeroSprite,mirror:Boolean):void {
   var bounds:Rectangle=actor.getBounds(actor),scale:Number=Math.min(1,166/bounds.height,174/bounds.width);
   actor.scaleX=mirror?-scale:scale;actor.scaleY=scale;actor.y=170-bounds.bottom*scale;
  }
  private function panel(g:Graphics,points:Array,top:uint,bottom:uint,edge:uint):void {
   var m:Matrix=new Matrix();m.createGradientBox(960,170,Math.PI/2);g.lineStyle(5,0x172c36);g.beginGradientFill(GradientType.LINEAR,[top,bottom],[1,1],[0,255],m);g.moveTo(points[0],points[1]);for(var i:int=2;i<points.length;i+=2)g.lineTo(points[i],points[i+1]);g.lineTo(points[0],points[1]);g.endFill();
   g.lineStyle(1.5,edge,.95);g.moveTo(points[0]+2,points[1]+5);g.lineTo(points[2]-6,points[3]+5);g.lineStyle();
  }
  private function frame(x:Number,y:Number,w:Number,h:Number):void {var g:Graphics=group(x,w).graphics;g.lineStyle(2,0x172b3e);ClassicChrome.fill(g,x,y,w,h,[0xffffff,0xbed7df,0x617c86],[0,120,255],3);g.lineStyle();}
  private function emblem(city:String,accent:uint,x:Number,y:Number,size:Number):void {var l:TeamLogoView=new TeamLogoView(city,accent,"",size);l.x=x;l.y=y;group(x,size).addChild(l);logos.push(l);}
  private function text(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):TextField {var t:TextField=ClassicInventorySkin.text(group(x,w),value,x,y,w,h,size,color,"center");LineupTypography.fit(t,size,color,"center");return t;}
  private function heading(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):void {var t:TextField=text(value,x,y,w,h,size,color);ClassicChrome.title(t,size,color);t.filters=[];}
  public function dispose():void {for each(var a:HeroSprite in actors)a.dispose();for each(var l:TeamLogoView in logos)l.dispose();for each(var p:CharacterPortrait in portraits)p.dispose();actors=[];logos=[];portraits=[];if(rivalHead){rivalHead.dispose();rivalHead=null;}}
 }
}
