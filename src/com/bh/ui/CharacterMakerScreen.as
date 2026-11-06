package com.bh.ui {
 import flash.display.*;import flash.events.MouseEvent;import flash.text.*;
 import com.bh.model.GameData;import com.bh.model.HeroStyleCatalog;import flash.geom.Rectangle;import com.bh.visual.*;
 /** Every selectable style is a complete original head, with hair rooted in its own scalp. */
 public class CharacterMakerScreen extends Sprite {
  private var appearance:Object,tab:String="STYLE",page:int=0,layer:Sprite=new Sprite(),preview:CreationArtwork,handlers:Array=[],art:Array=[],buttons:Array=[],done:Function,back:Function,alive:Boolean=true,completed:Boolean=false;
  private static const STYLES:Array=["Wavy","Crop","Spiky","Fringe","Curls","Swept Back","Parted","Braids"];
  public function CharacterMakerScreen(w:Number,h:Number,onDone:Function,onBack:Function=null){
   name="character-maker";done=onDone;back=onBack;GameData.init();appearance=JSON.parse(JSON.stringify(GameData.heroAppearance()));appearance.artVersion=1;appearance.avatarStyle=HeroStyleCatalog.style(appearance);page=int(appearance.avatarStyle/8);addChild(layer);render();
  }
  private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int=14,color:uint=0xffffff,center:Boolean=true):TextField {
   var f:TextField=new TextField();f.defaultTextFormat=new TextFormat("Arial",size,color,true,null,null,null,null,center?"center":"left");f.text=value;f.x=x;f.y=y;f.width=w;f.height=h;f.selectable=f.mouseEnabled=false;LineupTypography.fit(f,size,color,center?"center":"left",size>=24,9);layer.addChild(f);return f;
  }
  private function button(id:String,title:String,x:Number,y:Number,w:Number,h:Number,fn:Function,color:uint=0x1689b5):void {
   var b:UIButton=new UIButton(title,w,h,color,color,0xd6efff,13);b.name=id;b.x=x;b.y=y;layer.addChild(b);b.addEventListener(MouseEvent.CLICK,fn);handlers.push({view:b,fn:fn});buttons.push(b);
  }
  private function clear():void {
   for each(var h:Object in handlers)h.view.removeEventListener(MouseEvent.CLICK,h.fn);handlers=[];
   for each(var b:UIButton in buttons)b.dispose();buttons=[];
   if(preview){preview.dispose();preview=null;}for each(var a:HeroAvatarArtwork in art)a.dispose();art=[];
   while(layer.numChildren)layer.removeChildAt(0);layer.graphics.clear();
  }
  private function selectTab(value:String):Function {return function(e:MouseEvent):void{if(!alive||completed)return;tab=value;page=value=="STYLE"?int(appearance.avatarStyle/8):0;render();};}
  private function option(value:int):Function {return function(e:MouseEvent):void {
   if(!alive||completed)return;
   if(tab=="STYLE"){appearance.avatarStyle=value;appearance.hair=value%8;appearance.shape=value%8;}
   else appearance[tab=="SKIN"?"skinColor":tab=="HAIR"?"hairColor":"eyeColor"]=value;
   render();
  };}
  private function selected():int {return int(appearance[tab=="STYLE"?"avatarStyle":tab=="SKIN"?"skinColor":tab=="HAIR"?"hairColor":"eyeColor"]);}
  private function render():void {
   clear();TravelMapArtwork.drawBackdrop(layer.graphics,960,720);var map:TravelMapArtwork=new TravelMapArtwork();map.y=-110;layer.addChild(map);var chrome:Sprite=new Sprite();layer.addChild(chrome);var g:Graphics=chrome.graphics;
   ClassicChrome.panel(g,20,145,588,548);ClassicChrome.panel(g,619,145,321,548);ClassicChrome.bar(g,27,153,574,60);
   var title:TextField=label("CREATE YOUR HERO",43,162,542,46,32);ClassicChrome.title(title,32);
   ClassicChrome.well(g,633,160,294,374,false,false);g.beginFill(0x24663b);g.drawRect(636,163,287,367);g.endFill();
   g.beginFill(0x99754e);g.drawRect(636,318,287,212);g.endFill();g.lineStyle(3,0xece7d8,.65);g.moveTo(637,411);g.lineTo(779,518);g.lineTo(923,411);g.lineStyle();
   var tabs:Array=["STYLE","SKIN","HAIR","EYES"];
   for(var i:int=0;i<tabs.length;i++)button("creator-tab-"+tabs[i],tabs[i]=="HAIR"?"HAIR COLOR":tabs[i]=="EYES"?"EYE COLOR":tabs[i],61+i*132,225,122,29,selectTab(tabs[i]),tab==tabs[i]?0x3faed0:0x126d9d);
   var colors:Array=tab=="STYLE"?null:VisualProfile.palette(tab=="SKIN"?"skin":tab=="HAIR"?"hair":"eyes"),count:int=colors?colors.length:HeroStyleCatalog.COUNT;
   page=Math.max(0,Math.min(Math.ceil(count/8)-1,page));
   for(i=page*8;i<Math.min(count,page*8+8);i++){
    var col:int=(i%8)%4,row:int=int((i%8)/4),x:Number=61+col*132,y:Number=268+row*185,chosen:Boolean=selected()==i;
    ClassicChrome.well(g,x,y,122,174,chosen);ClassicChrome.fill(g,x+7,y+7,108,120,chosen?[0xcdf8ff,0x80c5da]:[0xe5eff0,0xb7cbcf],[0,255],6);
    var a:Object=JSON.parse(JSON.stringify(appearance));if(tab=="STYLE")a.avatarStyle=i;else a[tab=="SKIN"?"skinColor":tab=="HAIR"?"hairColor":"eyeColor"]=i;
    var head:HeroAvatarArtwork=new HeroAvatarArtwork(a,HomeSprite.paletteFor("Hero",GameData.teamAccent,a,{}));var bounds:Rectangle=head.getBounds(head),fit:Number=Math.min(.65,104/Math.max(1,bounds.width),112/Math.max(1,bounds.height));head.scaleX=head.scaleY=fit;head.x=x+61-(bounds.x+bounds.width*.5)*fit;head.y=y+11-bounds.y*fit+(112-bounds.height*fit)*.5;layer.addChild(head);art.push(head);
    if(colors){g.lineStyle(1,0x53616a);g.beginFill(uint(colors[i]));g.drawRoundRect(x+11,y+131,22,16,4);g.endFill();g.lineStyle();}
    label(tab=="STYLE"?HeroStyleCatalog.nameFor(i,String(appearance.gender)):(tab=="SKIN"?"Tone ":tab=="HAIR"?"Hair ":"Eyes ")+(i+1),x+(colors?34:4),y+130,colors?81:114,21,12,0x284658);
    label(chosen?"SELECTED":"FREE",x+4,y+151,114,20,11,chosen?0x1684a5:0x6b746a);
    var hit:Sprite=new Sprite();hit.name="creator-option-"+i;hit.x=x;hit.y=y;hit.graphics.beginFill(0xffffff,0);hit.graphics.drawRect(0,0,122,174);hit.graphics.endFill();hit.buttonMode=true;layer.addChild(hit);var fn:Function=option(i);hit.addEventListener(MouseEvent.CLICK,fn);handlers.push({view:hit,fn:fn});
   }
   if(count>8){button("creator-prev","<",66,648,50,29,function(e:MouseEvent):void{page=Math.max(0,page-1);render();});button("creator-next",">",548,648,50,29,function(e:MouseEvent):void{page=Math.min(Math.ceil(count/8)-1,page+1);render();});label((page+1)+" / "+Math.ceil(count/8),240,651,180,23,12,0xc4e6ef);}
   else label("Cabeza y cabello forman un solo sprite.",62,653,530,25,12,0xc4e6ef);
   preview=new CreationArtwork(appearance,GameData.teamAccent,"",GameData.uniformNumber,"STYLE");preview.x=780;preview.y=288;preview.scaleX=preview.scaleY=1.03;layer.addChild(preview);
   label((appearance.gender=="F"?"FEMALE":"MALE")+"  /  "+HeroStyleCatalog.nameFor(int(appearance.avatarStyle),String(appearance.gender)),643,172,274,25,14,0xffe3a0);
   button("creator-gender",appearance.gender=="F"?"FEMALE":"MALE",659,552,112,38,function(e:MouseEvent):void{appearance.gender=appearance.gender=="F"?"M":"F";render();},0x9360c4);
   button("creator-random","RANDOM",789,552,112,38,function(e:MouseEvent):void{appearance.avatarStyle=int(Math.random()*HeroStyleCatalog.COUNT);appearance.hair=appearance.shape=int(appearance.avatarStyle)%8;appearance.skinColor=int(Math.random()*8);appearance.hairColor=int(Math.random()*20);appearance.eyeColor=int(Math.random()*8);page=int(selected()/8);render();},0x5d9d65);
   label("Elige tu estilo y colores.\nLa identidad se confirma una sola vez.",640,596,278,36,12,0xc5e8ed);
   button("creator-select","SELECT",704,637,156,37,onSelect,0x67ae2e);
   if(back!=null&&GameData.teamSelectionOpen())button("creator-back","BACK",847,14,84,30,onBack);
  }
  private function onSelect(e:MouseEvent):void {if(!alive||completed||!GameData.characterCreationOpen())return;completed=true;appearance.etc=0;GameData.setHeroAppearance(appearance);if(done!=null)done();}
  private function onBack(e:MouseEvent):void {if(!alive||completed)return;completed=true;if(back!=null)back();}
  public function dispose():void {if(!alive)return;alive=false;clear();done=back=null;}
 }
}
