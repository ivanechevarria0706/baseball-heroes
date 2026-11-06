package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.ByteArray;import flash.utils.Timer;import flash.events.TimerEvent;
 /** Native pose windows and bounded palette caches. Nothing is repainted per animation tick. */
 public class MatchPoseStore {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1039/motion.json",mimeType="application/octet-stream")] private static const Layout:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1039/batter.png")] private static const Batter:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1039/pitcher.png")] private static const Pitcher:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1039/fielding.png")] private static const Fielding:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1039/runner.png")] private static const Runner:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1039/rear.png")] private static const Rear:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1060/fielding-detail.png")] private static const FieldingDetail:Class;
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1060/motion-detail.json",mimeType="application/octet-stream")] private static const DetailLayout:Class;
  private static var warmTimer:Timer,jobs:Array=[],queued:Object={};
  private static var layout:Object,sheets:Object={},neutral:Object={},banks:Object={},serial:int=0,created:int=0;
  public static function frames(kind:String):Array {if(!layout){var bytes:ByteArray=new Layout() as ByteArray;layout=JSON.parse(bytes.readUTFBytes(bytes.length));bytes=new DetailLayout() as ByteArray;var detail:Object=JSON.parse(bytes.readUTFBytes(bytes.length));layout.sheets.fielding.frames=layout.sheets.fielding.frames.concat(detail.frames);}return layout.sheets[kind].frames;}
  private static function source(kind:String):BitmapData {if(!sheets[kind]){var type:Class=kind=="batter"?Batter:kind=="pitcher"?Pitcher:kind=="fielding"?Fielding:kind=="runner"?Runner:Rear;sheets[kind]=Bitmap(new type()).bitmapData;}return sheets[kind];}
  private static function frameSource(kind:String,f:Object):BitmapData {if(f.sourceDetail){if(!sheets.detail)sheets.detail=Bitmap(new FieldingDetail()).bitmapData;return sheets.detail;}return source(kind);}
  public static function acquire(kind:String,p:Object):Object {
   var key:String=kind;for each(var field:String in (kind=="rear"?["skin","hair","helmet"]:["uniform","skin","bat","shoe","belt","glove","costume","batTheme","batName","gloveName","shoesName","beltName"]))key+=":"+p[field];
   if(!banks[key])banks[key]={key:key,kind:kind,palette:p,frames:{},refs:0,used:0};var bank:Object=banks[key];bank.refs++;bank.used=++serial;return bank;
  }
  public static function pixels(bank:Object,index:int):BitmapData {
   bank.used=++serial;if(bank.frames[index])return bank.frames[index];
   var f:Object=frames(bank.kind)[index],r:Array=f.rect,b:BitmapData;
   var patterned:Boolean=int(bank.palette.costume)>=0||(bank.kind=="batter"&&(int(bank.palette.batTheme)>=0||ClassicWearables.hasBat(String(bank.palette.batName))));
   if(patterned){b=new BitmapData(r[2],r[3],true,0);b.copyPixels(frameSource(bank.kind,f),new Rectangle(r[0],r[1],r[2],r[3]),new Point());tint(b,bank.palette,bank.kind,f);}
   else b=materialPixels(bank.kind,index,bank.palette);
   bank.frames[index]=b;created++;return b;
  }
  /** Classify each source pose once. Common palette changes use native bitmap operations. */
  private static function materialPixels(kind:String,index:int,p:Object):BitmapData {
   var id:String=kind+"/"+index,entry:Object=neutral[id];
   if(!entry){
    var f:Object=frames(kind)[index],r:Array=f.rect,original:BitmapData=new BitmapData(r[2],r[3],true,0);original.copyPixels(frameSource(kind,f),new Rectangle(r[0],r[1],r[2],r[3]),new Point());
    var data:Vector.<uint>=original.getVector(original.rect),groups:Object={},rear:Boolean=kind=="rear",bat:Boolean=kind=="batter";
    for(var i:int=0;i<data.length;i++){
     var q:uint=data[i],red:int=q>>16&255,g:int=q>>8&255,blue:int=q&255;if((q>>>24)<16||Math.max(red,g,blue)<32)continue;
     var field:String="",base:uint=0,y:int=int(i/original.width),bodyY:Number=rear?0:(y+r[1]-f.neck[1])/Math.max(1,f.ground[1]-f.neck[1]);
     if(rear&&blue>g*1.2&&red>g*1.12&&blue>red*.9){field="hair";base=0x593477;}
     else if(blue>red*1.3&&blue>g*1.12&&blue>35){field=rear?"helmet":"uniform";base=rear?0x123c89:0x083a91;}
     else if(red>g*1.1&&g>blue*1.13&&blue>g*.60&&red>115&&red-g>28){field="skin";base=0xf9b780;}
     else if(!rear&&red>g*1.12&&g>blue*1.4&&blue<g*.68&&red>75){field=bat?"bat":"glove";base=bat?0xe6ab49:0x9d622b;}
     else if(!rear&&bodyY>.30&&bodyY<.52&&red<120&&Math.max(red,g,blue)-Math.min(red,g,blue)<24){field="belt";base=0x35373b;}
     else if(!rear&&bodyY>.72&&red<120&&Math.max(red,g,blue)-Math.min(red,g,blue)<24){field="shoe";base=0x35373b;}
     if(field!=""){
      if(!groups[field])groups[field]=new Vector.<uint>(data.length,true);
      var grey:int=Math.max(0,Math.min(255,128+.299*(red-(base>>16&255))+.587*(g-(base>>8&255))+.114*(blue-(base&255))));
      Vector.<uint>(groups[field])[i]=(q&0xff000000)|(grey<<16)|(grey<<8)|grey;data[i]=0;
     }
    }
    original.setVector(original.rect,data);entry={base:original,layers:[]};
    for(var material:String in groups){
     var full:BitmapData=new BitmapData(original.width,original.height,true,0);full.setVector(full.rect,groups[material]);var bounds:Rectangle=full.getColorBoundsRect(0xff000000,0,false);
     if(bounds.width>0&&bounds.height>0){var layer:BitmapData=new BitmapData(bounds.width,bounds.height,true,0);layer.copyPixels(full,bounds,new Point());entry.layers.push({field:material,pixels:layer,point:new Point(bounds.x,bounds.y)});}full.dispose();
    }neutral[id]=entry;
   }
   var output:BitmapData=BitmapData(entry.base).clone();
   for each(var part:Object in entry.layers){var color:uint=uint(p[part.field]),tinted:BitmapData=BitmapData(part.pixels).clone();tinted.colorTransform(tinted.rect,new ColorTransform(1,1,1,1,(color>>16&255)-128,(color>>8&255)-128,(color&255)-128,0));output.copyPixels(tinted,tinted.rect,part.point,null,null,true);tinted.dispose();}
   return output;
  }
  private static function tint(b:BitmapData,p:Object,kind:String,f:Object):void {
   var data:Vector.<uint>=b.getVector(b.rect),rear:Boolean=kind=="rear",bat:Boolean=kind=="batter",r:Array=f.rect;
   var batName:String=String(p.batName),classicBat:Boolean=bat&&ClassicWearables.hasBat(batName);
   for(var i:int=0;i<data.length;i++){
    var q:uint=data[i],red:int=q>>16&255,g:int=q>>8&255,blue:int=q&255;if((q>>>24)<16||Math.max(red,g,blue)<32)continue;
    var target:uint,base:uint,change:Boolean=true,y:int=int(i/b.width),x:int=i-y*b.width,bodyY:Number=rear?0:(y+r[1]-f.neck[1])/Math.max(1,f.ground[1]-f.neck[1]);
    if(rear&&blue>g*1.2&&red>g*1.12&&blue>red*.9){target=p.hair;base=0x593477;}
    else if(blue>red*1.3&&blue>g*1.12&&blue>35){target=rear?uint(p.helmet):uint(p.uniform);base=rear?0x123c89:0x083a91;}
    else if(red>g*1.1&&g>blue*1.13&&blue>g*.60&&red>115&&red-g>28){target=p.skin;base=0xf9b780;}
    else if(!rear&&red>g*1.12&&g>blue*1.4&&blue<g*.68&&red>75){
     target=bat?uint(p.bat):uint(p.glove);base=bat?0xe6ab49:0x9d622b;
     if(classicBat)target=ClassicWearables.batPaint(batName,x,y,Math.max(b.width,b.height),target);
     else if(bat&&int(p.batTheme)>=0)target=CostumeArtwork.batPaint(int(p.batTheme),x,y,target);
    }
    else if(!rear&&bodyY>.30&&bodyY<.52&&red<120&&Math.max(red,g,blue)-Math.min(red,g,blue)<24){target=p.belt;base=0x35373b;}
    else if(!rear&&bodyY>.72&&red<120&&Math.max(red,g,blue)-Math.min(red,g,blue)<24){target=p.shoe;base=0x35373b;}
    else if(!rear&&int(p.costume)>=0&&bodyY>.02&&bodyY<.48&&red>160&&Math.max(red,g,blue)-Math.min(red,g,blue)<30){target=CostumeArtwork.cloth(int(p.costume),(x+r[0]-f.neck[0])/Math.max(1,f.ground[1]-f.neck[1]),bodyY,uint(p.uniform));base=0xededed;}
    else change=false;
    if(change){var shade:Number=.299*(red-(base>>16&255))+.587*(g-(base>>8&255))+.114*(blue-(base&255));var nr:int=Math.max(0,Math.min(255,(target>>16&255)+shade)),ng:int=Math.max(0,Math.min(255,(target>>8&255)+shade)),nb:int=Math.max(0,Math.min(255,(target&255)+shade));data[i]=(q&0xff000000)|(nr<<16)|(ng<<8)|nb;}
   }b.setVector(b.rect,data);
  }
  /** At most one native frame per timer tick; never prepare four complete teams in a constructor. */
  public static function warmDeferred(bank:Object):void {
   for(var n:int=0;n<frames(bank.kind).length;n++){var id:String=bank.key+"/"+n;if(!bank.frames[n]&&!queued[id]){jobs.push({bank:bank,index:n,id:id});queued[id]=true;}}
   if(!warmTimer){warmTimer=new Timer(40);warmTimer.addEventListener(TimerEvent.TIMER,warmTick);}if(jobs.length)warmTimer.start();
  }
  private static function warmTick(e:TimerEvent):void {
   while(jobs.length){var job:Object=jobs.shift();delete queued[job.id];var bank:Object=job.bank;if(banks[bank.key]===bank&&bank.refs>0&&!bank.frames[job.index]){pixels(bank,job.index);break;}}
   if(!jobs.length)warmTimer.stop();
  }
  public static function release(bank:Object):void {
   bank.refs--;bank.used=++serial;var idle:Array=[];for(var key:String in banks)if(!banks[key].refs)idle.push(banks[key]);idle.sortOn("used",Array.NUMERIC);
   while(idle.length>6){var old:Object=idle.shift();for each(var pixels:BitmapData in old.frames)pixels.dispose();delete banks[old.key];}
  }
  private static function materialCount():int {var n:int=0;for(var k:String in neutral)n++;return n;}
  public static function stats():Object {var total:int=0,active:int=0,bytes:Number=0;for each(var b:Object in banks){total++;if(b.refs)active++;for each(var p:BitmapData in b.frames)bytes+=p.width*p.height*4;}return {banks:total,activeBanks:active,cachedBytes:bytes,materialPoses:materialCount(),queuedFrames:jobs.length,createdFrames:created};}
 }
}
