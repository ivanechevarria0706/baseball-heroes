package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.ByteArray;import com.bh.model.GameData;
 /** Exact supplied atlas, assembled with the saved custom face. All material work is cached. */
 public class ReferenceBatterArtwork extends Sprite {
  [Embed(source="../../../../assets/sprites/v1043/batter-helmet.png")] private static const Sheet:Class;
  [Embed(source="../../../../assets/sprites/v1043/batter.json",mimeType="application/octet-stream")] private static const Layout:Class;
  private static var data:Object,source:BitmapData,neutral:Object={},banks:Object={},serial:int=0,created:int=0;
  private var bank:Object,p:Object,body:Bitmap=new Bitmap(null,"auto",true),hat:Bitmap=new Bitmap(null,"auto",true),badge:TeamLogoView,capBadge:TeamLogoView;
  public var helmetLayer:Sprite=new Sprite();
  private var index:int=-1,unit:Number,dead:Boolean=false;
  public function ReferenceBatterArtwork(palette:Object,height:Number=150,teamCity:String=null,teamAccent:uint=0){
   p=palette;mouseEnabled=mouseChildren=false;helmetLayer.mouseEnabled=helmetLayer.mouseChildren=false;name="reference-batter-body";helmetLayer.name="reference-batter-helmet";
   var key:String="";for each(var field:String in ["uniform","skin","bat","shoe","belt","glove","helmet","costume","batTheme","batName","shoesName","beltName"])key+=":"+p[field];
   if(!banks[key])banks[key]={key:key,frames:{},refs:0,used:0,p:p};bank=banks[key];bank.refs++;bank.used=++serial;
   var first:Object=frames()[0];unit=height/(first.ground[1]-first.neck[1]);
   if(teamCity==null){teamCity=GameData.teamCity;teamAccent=GameData.teamAccent;}
   addChild(body);badge=new TeamLogoView(teamCity,teamAccent,"",12);addChild(badge);
   helmetLayer.addChild(hat);capBadge=new TeamLogoView(teamCity,teamAccent,"",20);helmetLayer.addChild(capBadge);setFrame(0);
  }
  public static function frames():Array {if(!data){var bytes:ByteArray=new Layout() as ByteArray;data=JSON.parse(bytes.readUTFBytes(bytes.length));}return data.frames;}
  public static function mapped(logical:int):int {frames();return int(data.map[Math.max(0,Math.min(23,logical))]);}
  public function setFrame(logical:int):void {
   if(dead)return;var next:int=mapped(logical);if(next==index)return;index=next;bank.used=++serial;
   var f:Object=frames()[index],r:Array=f.rect,entry:Object=pixels(bank,index);
   body.bitmapData=entry.body;hat.bitmapData=entry.hat;body.scaleX=body.scaleY=hat.scaleX=hat.scaleY=unit;
   body.x=hat.x=(r[0]-f.ground[0])*unit;body.y=hat.y=(r[1]-f.ground[1])*unit;
   badge.visible=f.logo!=null;
   if(badge.visible){badge.scaleX=badge.scaleY=Math.min(12,f.logo[2]*unit)/12;badge.x=(f.logo[0]+f.logo[2]*.5-f.ground[0])*unit-badge.width*.5;badge.y=(f.logo[1]+f.logo[3]*.5-f.ground[1])*unit-badge.height*.5;}
   capBadge.visible=f.capLogo!=null;
   if(capBadge.visible){capBadge.x=(f.capLogo[0]+f.capLogo[2]*.5-f.ground[0])*unit-10;capBadge.y=(f.capLogo[1]+f.capLogo[3]*.5-f.ground[1])*unit-10;}
  }
  public function anchor(key:String="neck",logical:int=-1):Point {
   var n:int=logical<0?index:mapped(logical),f:Object=frames()[n],a:Array=f[key]||f.neck;
   // The lifted-leg pose rests on the rear cleat, not the front shoe in the air.
   if(key=="rear")a=n==0?[83,460]:n==1?[526,460]:f.plant;
   if(key=="contact")a=[f.grip[0]+(f.tip[0]-f.grip[0])*.80,f.grip[1]+(f.tip[1]-f.grip[1])*.80];
   return new Point((a[0]-f.ground[0])*unit,(a[1]-f.ground[1])*unit);
  }
  public function get tilt():Number {return frames()[index].tilt;}
  public function warmAll():void {for(var i:int=0;i<10;i++)pixels(bank,i);}
  private static function spans(poly:Array,rect:Array):Array {
   var rows:Array=[];for(var y:int=0;y<rect[3];y++){var py:Number=y+rect[1]+.5,xs:Array=[];
    for(var j:int=0,k:int=poly.length-1;j<poly.length;k=j++)if((poly[j][1]>py)!=(poly[k][1]>py))xs.push(poly[j][0]+(py-poly[j][1])*(poly[k][0]-poly[j][0])/(poly[k][1]-poly[j][1])-rect[0]);
    xs.sort(Array.NUMERIC);rows.push(xs);
   }return rows;
  }
  private static function inside(row:Array,x:Number):Boolean {for(var i:int=0;i+1<row.length;i+=2)if(x>=row[i]&&x<=row[i+1])return true;return false;}
  private static function inRect(r:Array,x:Number,y:Number):Boolean {return r&&x>=r[0]&&y>=r[1]&&x<r[0]+r[2]&&y<r[1]+r[3];}
  private static function wood(q:uint):Boolean {var r:int=q>>16&255,g:int=q>>8&255,b:int=q&255;return r>g*1.08&&g>b*1.4&&r>75&&b<g*.68;}
  private static function blue(q:uint):Boolean {return (q&255)>(q>>16&255)*1.3&&(q&255)>(q>>8&255)*1.12&&(q&255)>35;}
  private static function prepare(n:int):Object {
   if(neutral[n])return neutral[n];if(!source)source=Bitmap(new Sheet()).bitmapData;
   var f:Object=frames()[n],r:Array=f.rect,original:BitmapData=new BitmapData(r[2],r[3],true,0);original.copyPixels(source,new Rectangle(r[0],r[1],r[2],r[3]),new Point());
   // Bounding rectangles can contain the next player's bat. Retain this connected silhouette only.
   var mask:BitmapData=new BitmapData(r[2],r[3],true,0);mask.threshold(original,original.rect,new Point(),">",0x08000000,0xffffffff,0xff000000);
   var sx:int=int(f.neck[0]-r[0]),sy:int=int(f.neck[1]+70-r[1]);if(mask.getPixel32(sx,sy)!=0xffffffff){for(var probe:int=0;probe<50;probe++)if(mask.getPixel32(sx,sy+probe)==0xffffffff){sy+=probe;break;}}
   mask.floodFill(sx,sy,0xff00ff00);var connected:Vector.<uint>=mask.getVector(mask.rect);mask.dispose();
   var pixels:Vector.<uint>=original.getVector(original.rect),bodyData:Vector.<uint>=new Vector.<uint>(pixels.length,true),hatData:Vector.<uint>=new Vector.<uint>(pixels.length,true),groups:Object={},headRows:Array=spans(f.head,r),hatRows:Array=spans(f.helmet,r);
   var ax:Number=f.grip[0],ay:Number=f.grip[1],dx:Number=f.tip[0]-ax,dy:Number=f.tip[1]-ay,den:Number=dx*dx+dy*dy;
   for(var i:int=0;i<pixels.length;i++){
    var q:uint=pixels[i];if(connected[i]!=0xff00ff00||(q>>>24)<8)continue;
    var y:int=int(i/r[2]),x:int=i-y*r[2],wx:Number=x+r[0],wy:Number=y+r[1],rr:int=q>>16&255,g:int=q>>8&255,b:int=q&255;
    var head:Boolean=inside(headRows[y],x),hatArea:Boolean=inside(hatRows[y],x),nearWood:Boolean=false;
    var along:Number=Math.max(0,Math.min(1,((wx-ax)*dx+(wy-ay)*dy)/den)),distance:Number=Math.pow(wx-ax-along*dx,2)+Math.pow(wy-ay-along*dy,2);
    if(distance<400){nearWood=wood(q);if(!nearWood&&Math.max(rr,g,b)<70)for(var oy:int=-2;oy<=2&&!nearWood;oy++)for(var ox:int=-2;ox<=2;ox++){var xx:int=x+ox,yy:int=y+oy;if(xx>=0&&xx<r[2]&&yy>=0&&yy<r[3]&&wood(pixels[yy*r[2]+xx])){nearWood=true;break;}}}
    var field:String="",base:uint=0,part:String="body",out:uint=q;
    if(head&&!nearWood){
     if(!hatArea)continue;
     var nearBlue:Boolean=blue(q);if(!nearBlue&&Math.max(rr,g,b)<80)for(oy=-2;oy<=2&&!nearBlue;oy++)for(ox=-2;ox<=2;ox++){xx=x+ox;yy=y+oy;if(xx>=0&&xx<r[2]&&yy>=0&&yy<r[3]&&blue(pixels[yy*r[2]+xx])){nearBlue=true;break;}}
     if(!nearBlue&&!(rr>155&&g>160&&b>165))continue;
     part="hat";
     if(inRect(f.capLogo,wx,wy)){out=(q&0xff000000)|0x08378d;rr=8;g=55;b=141;}
     if(blue(out)){field="helmet";base=0x083a91;}
    }else {
     if(inRect(f.logo,wx,wy)&&blue(q)){out=(q&0xff000000)|0xececf0;rr=g=236;b=240;}
     if(nearWood&&wood(out)){field="bat";base=0xe6ab49;}
     else if(blue(out)){field="uniform";base=0x083a91;}
     else if(rr>g*1.10&&g>b*1.13&&b>g*.60&&rr>115){field="skin";base=0xf9b780;}
     else if(wy>f.neck[1]+(f.ground[1]-f.neck[1])*.30&&wy<f.neck[1]+(f.ground[1]-f.neck[1])*.52&&rr<120&&Math.max(rr,g,b)-Math.min(rr,g,b)<24){field="belt";base=0x35373b;}
     else if(wy>f.neck[1]+(f.ground[1]-f.neck[1])*.72&&rr<120&&Math.max(rr,g,b)-Math.min(rr,g,b)<24){field="shoe";base=0x35373b;}
     else if(wy<f.neck[1]+(f.ground[1]-f.neck[1])*.48&&rr>160&&Math.max(rr,g,b)-Math.min(rr,g,b)<30){field="cloth";base=0xededed;}
    }
    if(field!=""&&Math.max(rr,g,b)>=32){
     var id:String=part+":"+field;if(!groups[id])groups[id]=new Vector.<uint>(pixels.length,true);
     var grey:int=Math.max(0,Math.min(255,128+.299*(rr-(base>>16&255))+.587*(g-(base>>8&255))+.114*(b-(base&255))));Vector.<uint>(groups[id])[i]=(q&0xff000000)|(grey<<16)|(grey<<8)|grey;
    }else if(part=="hat")hatData[i]=out;else bodyData[i]=out;
   }
   var bodyBase:BitmapData=new BitmapData(r[2],r[3],true,0),hatBase:BitmapData=new BitmapData(r[2],r[3],true,0);bodyBase.setVector(bodyBase.rect,bodyData);hatBase.setVector(hatBase.rect,hatData);original.dispose();
   var layers:Array=[];for(var material:String in groups){var full:BitmapData=new BitmapData(r[2],r[3],true,0);full.setVector(full.rect,groups[material]);var bounds:Rectangle=full.getColorBoundsRect(0xff000000,0,false);if(bounds.width&&bounds.height){var layer:BitmapData=new BitmapData(bounds.width,bounds.height,true,0);layer.copyPixels(full,bounds,new Point());var parts:Array=material.split(":");layers.push({part:parts[0],field:parts[1],pixels:layer,point:new Point(bounds.x,bounds.y)});}full.dispose();}
   neutral[n]={body:bodyBase,hat:hatBase,layers:layers};return neutral[n];
  }
  private static function pixels(bank:Object,n:int):Object {
   if(bank.frames[n])return bank.frames[n];var entry:Object=prepare(n),body:BitmapData=BitmapData(entry.body).clone(),hat:BitmapData=BitmapData(entry.hat).clone(),p:Object=bank.p;
   for each(var part:Object in entry.layers){
    var c:uint=part.field=="cloth"?0xededed:uint(p[part.field]),tinted:BitmapData=BitmapData(part.pixels).clone();
    var classic:Boolean=part.field=="bat"&&ClassicWearables.hasBat(String(p.batName)),pattern:Boolean=(part.field=="cloth"&&int(p.costume)>=0)||(part.field=="bat"&&(classic||int(p.batTheme)>=0));
    if(pattern){
     var values:Vector.<uint>=tinted.getVector(tinted.rect),f:Object=frames()[n],r:Array=f.rect,height:Number=frames()[0].ground[1]-frames()[0].neck[1];
     for(var i:int=0;i<values.length;i++){var q:uint=values[i];if(!(q>>>24))continue;var y:int=int(i/tinted.width),x:int=i-y*tinted.width,wx:Number=r[0]+part.point.x+x,wy:Number=r[1]+part.point.y+y;
      c=part.field=="cloth"?CostumeArtwork.cloth(int(p.costume),(wx-f.neck[0])/height,(wy-f.neck[1])/height,uint(p.uniform)):classic?ClassicWearables.batPaint(String(p.batName),x,y,Math.max(tinted.width,tinted.height),uint(p.bat)):CostumeArtwork.batPaint(int(p.batTheme),x,y,uint(p.bat));
      var shade:int=int(q&255)-128;values[i]=(q&0xff000000)|(Math.max(0,Math.min(255,(c>>16&255)+shade))<<16)|(Math.max(0,Math.min(255,(c>>8&255)+shade))<<8)|Math.max(0,Math.min(255,(c&255)+shade));
     }tinted.setVector(tinted.rect,values);
    }else tinted.colorTransform(tinted.rect,new ColorTransform(1,1,1,1,(c>>16&255)-128,(c>>8&255)-128,(c&255)-128,0));
    var dest:BitmapData=part.part=="hat"?hat:body;dest.copyPixels(tinted,tinted.rect,part.point,null,null,true);tinted.dispose();
   }
   bank.frames[n]={body:body,hat:hat};created++;return bank.frames[n];
  }
  public static function stats():Object {var count:int=0,bytes:Number=0;for each(var bank:Object in banks){count++;for each(var f:Object in bank.frames)bytes+=f.body.width*f.body.height*8;}return {banks:count,createdFrames:created,cachedBytes:bytes};}
  public function dispose():void {if(dead)return;dead=true;body.bitmapData=hat.bitmapData=null;badge.dispose();capBadge.dispose();bank.refs--;bank.used=++serial;var idle:Array=[];for each(var old:Object in banks)if(!old.refs)idle.push(old);idle.sortOn("used",Array.NUMERIC);while(idle.length>3){old=idle.shift();for each(var frame:Object in old.frames){frame.body.dispose();frame.hat.dispose();}delete banks[old.key];}}
 }
}
