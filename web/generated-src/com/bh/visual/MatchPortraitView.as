package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.ByteArray;
 /** Match-only silhouette and a small texture mesh. Card illustrations stay intact. */
 public class MatchPortraitView extends Sprite {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1060/head-layout.json",mimeType="application/octet-stream")] private static const Layout:Class;
  private static var layouts:Object;
  private var pixels:BitmapData,info:Object,mesh:Shape=new Shape(),outline:Shape=new Shape();
  private var facing:Number=0,mood:int=0,closed:Boolean=false,w:Number,h:Number,s:Number,cx:Number,jaw:Number,dead:Boolean=false;
  public function MatchPortraitView(source:BitmapData,id:int,width:Number,height:Number){
   mouseEnabled=mouseChildren=false;name="clean-match-portrait";pixels=source;w=width;h=height;
   if(!layouts){var bytes:ByteArray=new Layout() as ByteArray;layouts=JSON.parse(bytes.readUTFBytes(bytes.length));}
   info=layouts[String(id)];if(!info)throw new Error("Missing match head geometry: "+id);
   if(info.erase&&info.erase.length){pixels=source.clone();for each(var area:Array in info.erase)pixels.fillRect(new Rectangle(area[0],area[1],area[2],area[3]),0);}
   jaw=Number(info.jaw);cx=Number(info.center);
   s=Math.min(w/pixels.width,h/(jaw*pixels.height));addChild(mesh);addChild(outline);mesh.mask=outline;redraw();
  }
  public function setPose(degrees:Number,expression:int,blink:Boolean=false):void {
   if(dead)return;var next:Number=Math.round(Math.max(-75,Math.min(75,degrees))/10)*10;
   if(next==facing&&mood==expression&&closed==blink)return;facing=next;mood=expression;closed=blink;redraw();
  }
  private function point(xn:Number,yn:Number):Point {
   var yaw:Number=facing/90,side:Number=xn-cx;
   // A curved mesh shifts the near cheek and cap separately, around the jaw pivot.
   var xx:Number=side*(1-.16*Math.abs(yaw))+yaw*(.025+Math.sin(yn*Math.PI)*.035)*(1-Math.abs(side)*.5);
   var yy:Number=yn;
   var eye:Number=Number(info.eyeY),radius:Number=.055,distance:Number=Math.abs(yn-eye);
   if(distance<radius*2){var strength:Number=closed?.92:mood==2?.20:0;yy+=(eye-yn)*strength*Math.max(0,1-distance/(radius*2));}
   if(mood==3){var mouth:Number=Number(info.mouthY),weight:Number=Math.max(0,1-Math.abs(yn-mouth)/.10);yy-=weight*Math.abs(side)*.032;}
   return new Point(w*.5+xx*pixels.width*s,h+(yy-jaw)*pixels.height*s+yaw*side*3);
  }
  private function redraw():void {
   var rows:Array=[0,.10,.20,.30,.40,.46,.50,.54,.58,.62,.66,.70,.75,.80,.86,.92,1];
   // Add eye landmarks so a blink closes the eye band without sliding the whole face.
   rows.push(Number(info.eyeY)-.055,Number(info.eyeY),Number(info.eyeY)+.055);rows.sort(Array.NUMERIC);
   var g:Graphics=mesh.graphics;g.clear();
   // Explicit source-pixel matrices keep native Flash and Ruffle sampling identical.
   for(var y:int=0;y<rows.length-1;y++){
    var start:Number=rows[y],end:Number=rows[y+1];if(end-start<.00001)continue;
    var left:Point=point(0,start),right:Point=point(1,start),bottom:Point=point(0,end),dy:Number=(end-start)*pixels.height;
    var a:Number=(right.x-left.x)/pixels.width,b:Number=(right.y-left.y)/pixels.width,c:Number=(bottom.x-left.x)/dy,d:Number=(bottom.y-left.y)/dy;
    var matrix:Matrix=new Matrix(a,b,c,d,left.x-c*start*pixels.height,left.y-d*start*pixels.height);
    g.beginBitmapFill(pixels,matrix,false,true);g.moveTo(left.x,left.y);g.lineTo(right.x,right.y);g.lineTo(right.x+bottom.x-left.x,right.y+bottom.y-left.y);g.lineTo(bottom.x,bottom.y);g.endFill();
   }
   g=outline.graphics;g.clear();g.beginFill(0xffffff);for(var i:int=0;i<info.clip.length;i++){var p:Point=point(info.clip[i][0],info.clip[i][1]);if(i==0)g.moveTo(p.x,p.y);else g.lineTo(p.x,p.y);}g.endFill();
  }
  public function dispose():void {if(dead)return;dead=true;mesh.mask=null;mesh.graphics.clear();outline.graphics.clear();if(info.erase&&info.erase.length)pixels.dispose();pixels=null;}
 }
}
