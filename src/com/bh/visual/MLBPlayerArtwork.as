package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.ByteArray;import flash.text.*;
 /** Complete classic cartoon characters. Approved pair uses the exact supplied PNG. */
 public class MLBPlayerArtwork extends Sprite {
  [Embed(source="../../../../assets/reference/v1036/approved-ohtani-judge.png")] private static const Approved:Class;
  [Embed(source="../../../../assets/reference/v1036/players-1.png")] private static const Players1:Class;
  [Embed(source="../../../../assets/reference/v1036/players-2.png")] private static const Players2:Class;
  [Embed(source="../../../../assets/reference/v1036/players-3.png")] private static const Players3:Class;
  private static const IDS:Array=[592450,660271,665742,665489,608070,596019,677594,663728,668227,680757,665926,670623];
  // Sheet index plus x/y/width/height. Rectangles include entire caps, bats and shoes.
  private static const FULL:Array=[[0,1051,61,550,816],[0,226,59,466,818],[1,144,29,430,614],[1,771,28,331,615],[1,164,655,342,577],[1,781,658,315,574],[2,164,12,450,638],[2,761,13,351,637],[2,203,652,321,599],[2,747,653,342,598],[3,237,51,471,826],[3,1049,59,557,818]];
  private static const HEADS:Array=[[0,1081,61,410,469],[0,226,59,452,474],[1,166,29,319,365],[1,770,28,319,370],[1,166,655,325,323],[1,780,658,311,350],[2,171,12,357,377],[2,760,13,336,376],[2,202,652,322,340],[2,746,653,341,341],[3,245,51,439,474],[3,1067,59,422,467]];
  private static var faces:Array,characters:Array;
  [Embed(source="../../../../assets/reference/v1037/art-index.json",mimeType="application/octet-stream")] private static const FrameData:Class;
  private static var frames:Object;
  private var sheet:String="",loaded:Function,ownedPixels:BitmapData,alive:Boolean=true;
  private var matchView:MatchPortraitView,matchOnly:Boolean=false,matchId:int=0,matchFacing:Number=0,matchExpression:int=0,matchBlink:Boolean=false;
  private static function registry():Object {if(!frames){var bytes:ByteArray=new FrameData() as ByteArray;frames=JSON.parse(bytes.readUTFBytes(bytes.length));}return frames;}
  private static function playerId(data:Object):int {if(!data)return 0;if(int(data.mlbId)>0)return int(data.mlbId);var id:String=data.catalogId?String(data.catalogId):data.id?String(data.id):"";return id.indexOf("card_mlb2026_")==0?int(id.substr(13).split("_")[0]):0;}
  public static function indexFor(data:Object):int {var id:int=playerId(data),i:int=IDS.indexOf(id);if(i>=0)return i;var f:Object=registry()[String(id)];return f?int(f.artIndex):-1;}
  private static function prepare():void {
   if(faces)return;faces=[];characters=[];var sheets:Array=[Bitmap(new Approved()).bitmapData,Bitmap(new Players1()).bitmapData,Bitmap(new Players2()).bitmapData,Bitmap(new Players3()).bitmapData];
   for(var i:int=0;i<12;i++){faces.push(window(sheets[HEADS[i][0]],HEADS[i]));characters.push(window(sheets[FULL[i][0]],FULL[i]));}
   for each(var source:BitmapData in sheets)source.dispose();
  }
  private static function window(sheet:BitmapData,f:Array):BitmapData {var pixels:BitmapData=new BitmapData(f[3],f[4],true,0);pixels.copyPixels(sheet,new Rectangle(f[1],f[2],f[3],f[4]),new Point());return pixels;}
  public function MLBPlayerArtwork(data:Object,w:Number=180,h:Number=280,portrait:Boolean=false,pose:int=0,matchOnly:Boolean=false){
   this.matchOnly=matchOnly;matchId=playerId(data);
   mouseEnabled=mouseChildren=false;var index:int=indexFor(data);if(index<0)return;name="mlb-art-"+playerId(data);
   if(index>=12){loadAtlas(data,w,h,portrait);return;}prepare();
   // The legacy pose argument is retained for callers; one complete drawing is displayed unchanged.
   var pixels:BitmapData=portrait?faces[index]:characters[index],image:Bitmap=new Bitmap(pixels,"auto",true),scale:Number=Math.min(w/pixels.width,h/pixels.height);
   if(matchOnly){mountMatch(pixels,w,h);return;}
   image.name=portrait?"mlb-portrait-head":"mlb-full-character";image.scaleX=image.scaleY=scale;image.x=(w-pixels.width*scale)/2;image.y=(h-pixels.height*scale)/2;addChild(image);
   scrollRect=new Rectangle(0,0,w,h);
  }
  private function loadAtlas(data:Object,w:Number,h:Number,portrait:Boolean):void {
   var frame:Object=registry()[String(playerId(data))],rect:Array=portrait?frame.portrait:frame.full;sheet=frame.sheet;
   var waiting:TextField=new TextField();waiting.name="mlb-art-loading";waiting.defaultTextFormat=new TextFormat("Trebuchet MS",11,0xbce6ed,null,null,null,null,null,"center");waiting.width=w;waiting.height=36;waiting.y=(h-36)/2;waiting.text="LOADING";addChild(waiting);
   loaded=function(source:BitmapData):void {
    if(!alive)return;if(!source){waiting.text="IMAGE UNAVAILABLE";return;}if(waiting.parent)removeChild(waiting);
    ownedPixels=new BitmapData(rect[2],rect[3],true,0);ownedPixels.copyPixels(source,new Rectangle(rect[0],rect[1],rect[2],rect[3]),new Point());
    if(matchOnly){mountMatch(ownedPixels,w,h);return;}
    var bitmap:Bitmap=new Bitmap(ownedPixels,"auto",true),scale:Number=Math.min(w/ownedPixels.width,h/ownedPixels.height);
    bitmap.name=portrait?"mlb-portrait-head":"mlb-full-character";bitmap.scaleX=bitmap.scaleY=scale;bitmap.x=(w-ownedPixels.width*scale)/2;bitmap.y=(h-ownedPixels.height*scale)/2;addChild(bitmap);scrollRect=new Rectangle(0,0,w,h);
   };MLBAtlasCache.fetch(sheet,loaded);
  }
  private function mountMatch(pixels:BitmapData,w:Number,h:Number):void {matchView=new MatchPortraitView(pixels,matchId,w,h);addChild(matchView);matchView.setPose(matchFacing,matchExpression,matchBlink);}
  public function setMatchPose(facing:Number,expression:int,blink:Boolean=false):void {matchFacing=facing;matchExpression=expression;matchBlink=blink;if(matchView)matchView.setPose(facing,expression,blink);}
  public function dispose():void {if(!alive)return;alive=false;if(sheet.length&&loaded!=null)MLBAtlasCache.cancel(sheet,loaded);loaded=null;if(matchView){matchView.dispose();matchView=null;}while(numChildren){var image:Bitmap=removeChildAt(0) as Bitmap;if(image)image.bitmapData=null;}if(ownedPixels){ownedPixels.dispose();ownedPixels=null;}}
 }
}
