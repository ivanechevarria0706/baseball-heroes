package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.ByteArray;import com.bh.model.HeroStyleCatalog;
 /** Original illustrated heads and standing body. Hair and face share one native frame. */
 public class HeroAvatarArtwork extends Sprite {
  [Embed(source="../../../../assets/sprites/v1038/heads.png")] private static const Heads:Class;
  [Embed(source="../../../../assets/sprites/v1038/body.png")] private static const Body:Class;
  private static const RECTS:Array=[[31,64,271,265],[355,88,241,243],[646,59,265,271],[954,81,274,249],[40,371,247,243],[357,367,246,247],[642,375,282,240],[975,380,243,233],[34,651,260,252],[332,667,295,232],[653,659,264,244],[947,665,289,257],[27,949,281,224],[329,931,280,241],[638,953,295,225],[978,951,234,229]];
  private static const JAWS:Array=[[168,327],[475,330],[783,328],[1092,329],[163,613],[479,613],[787,612],[1097,612],[165,900],[479,899],[789,902],[1091,898],[163,1171],[477,1172],[788,1174],[1095,1177]];
  [Embed(source="../../../../assets/sprites/v1044/heads-extra.png")] private static const ExtraHeads:Class;
  [Embed(source="../../../../assets/sprites/v1044/heads-extra.json",mimeType="application/octet-stream")] private static const ExtraLayout:Class;
  private static var heads:BitmapData,extraHeads:BitmapData,extra:Object,body:BitmapData,cache:Object={},serial:int=0;
  private static function extraFrames():Array {if(!extra){var bytes:ByteArray=new ExtraLayout() as ByteArray;extra=JSON.parse(bytes.readUTFBytes(bytes.length));}return extra.frames;}
  private var bitmap:Bitmap,key:String,bank:Object,dead:Boolean=false;
  public function HeroAvatarArtwork(a:Object,p:Object,part:String="head") {
   mouseEnabled=mouseChildren=false;name="original-hero-"+part;
   var style:int=HeroStyleCatalog.style(a),extended:Boolean=style>=8,index:int=extended?16+style-8+(a.gender=="F"?8:0):style+(a.gender=="F"?8:0),isHead:Boolean=part=="head";
   var frame:Object=isHead&&extended?extraFrames()[index-16]:null;
   key=isHead?part+":"+index+":"+p.skin+":"+p.hair+":"+p.eye:part+":"+p.skin+":"+p.uniform;
   var r:Array=isHead?(extended?frame.rect:RECTS[index]):[218,193,818,992];
   if(!cache[key]){
    if(isHead&&extended&&!extraHeads)extraHeads=Bitmap(new ExtraHeads()).bitmapData;
    if(isHead&&!heads)heads=Bitmap(new Heads()).bitmapData;if(!isHead&&!body)body=Bitmap(new Body()).bitmapData;
    var pixels:BitmapData=new BitmapData(r[2],r[3],true,0);pixels.copyPixels(isHead?(extended?extraHeads:heads):body,new Rectangle(r[0],r[1],r[2],r[3]),new Point());if(isHead&&extended)isolate(pixels,int(frame.jaw[0]-r[0]),int(frame.jaw[1]-r[1]-10));paint(pixels,p,isHead);cache[key]={pixels:pixels,refs:0,used:0};
   }
   bank=cache[key];bank.refs++;bank.used=++serial;bitmap=new Bitmap(bank.pixels,"auto",true);addChild(bitmap);
   var scale:Number=isHead?(extended?Number(frame.scale):.55):140/992;var jaw:Array=isHead?(extended?frame.jaw:JAWS[index]):null;bitmap.scaleX=bitmap.scaleY=scale;
   bitmap.x=isHead?(r[0]-jaw[0])*scale:-(628-r[0])*scale;
   bitmap.y=isHead?(r[1]-jaw[1])*scale:-140;
  }
  private static function isolate(b:BitmapData,x:int,y:int):void {
   var mask:BitmapData=new BitmapData(b.width,b.height,true,0);mask.threshold(b,b.rect,new Point(),">",0x08000000,0xffffffff,0xff000000);mask.floodFill(x,y,0xff00ff00);
   var pixels:Vector.<uint>=b.getVector(b.rect),connected:Vector.<uint>=mask.getVector(mask.rect);for(var i:int=0;i<pixels.length;i++)if(connected[i]!=0xff00ff00)pixels[i]=0;b.setVector(b.rect,pixels);mask.dispose();
  }
  private static function paint(b:BitmapData,p:Object,head:Boolean):void {
   var pixels:Vector.<uint>=b.getVector(b.rect);
   for(var i:int=0;i<pixels.length;i++){
    var q:uint=pixels[i],r:int=q>>16&255,g:int=q>>8&255,blue:int=q&255;if((q>>>24)<16||Math.max(r,g,blue)<32)continue;
    var target:uint,base:uint,change:Boolean=true;
    if(head&&blue>g*1.18&&r>g*1.12&&blue>r*.90){target=p.hair;base=0x593477;}
    else if(r>g*1.15&&g>blue*1.19&&r>100){target=p.skin;base=0xf9b780;}
    else if(!head&&blue>r*1.8&&blue>g*1.3&&blue>45){target=p.uniform;base=0x073792;}
    else if(head&&r>38&&r<105&&g>25&&g<85&&blue<g*.92&&r>g*1.12){target=p.eye;base=0x59452b;}
    else change=false;
    if(change){var shade:Number=.299*(r-(base>>16&255))+.587*(g-(base>>8&255))+.114*(blue-(base&255));var nr:int=Math.max(0,Math.min(255,(target>>16&255)+shade)),ng:int=Math.max(0,Math.min(255,(target>>8&255)+shade)),nb:int=Math.max(0,Math.min(255,(target&255)+shade));pixels[i]=(q&0xff000000)|(nr<<16)|(ng<<8)|nb;}
   }b.setVector(b.rect,pixels);
  }
  public function dispose():void {
   if(dead)return;dead=true;bitmap.bitmapData=null;bank.refs--;bank.used=++serial;
   var idle:Array=[];for(var name:String in cache)if(!cache[name].refs)idle.push({key:name,used:cache[name].used});idle.sortOn("used",Array.NUMERIC);
   while(idle.length>48){var gone:String=idle.shift().key;cache[gone].pixels.dispose();delete cache[gone];}
  }
 }
}
