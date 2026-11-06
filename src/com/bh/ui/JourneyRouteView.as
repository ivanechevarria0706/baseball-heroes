package com.bh.ui {
    import flash.display.*;import flash.geom.*;import flash.text.TextField;
    import com.bh.visual.AssetImage;import com.bh.visual.TeamLogoView;
    /** Retained map markers and one moving sprite. No model writes or frame listener. */
    public class JourneyRouteView extends Sprite {
        private var origin:Point,target:Point,arc:Number,flight:Boolean,local:Boolean;
        private var trail:Shape=new Shape(),vehicle:Sprite=new Sprite(),image:AssetImage,pins:Array=[];
        private var lastPercent:int=-1,dead:Boolean=false;
        public function JourneyRouteView(a:Point,b:Point,from:String,to:String,fromAccent:uint,toAccent:uint,path:String,league:int,id:String,w:Number=960,arrival:Boolean=false) {
            name="journey-route";mouseEnabled=mouseChildren=false;origin=a;target=b;flight=league>=3;local=Point.distance(a,b)<8;
            arc=local?0:Math.min(arrival?55:flight?70:24,Point.distance(a,b)*.24);
            var g:Graphics=graphics;g.lineStyle(6,0x1c5520,.25);drawPath(g,1);g.lineStyle();
            if(!local){g.lineStyle(2.5,0xffffff,.8);for(var i:int=0;i<32;i+=2){var p:Point=point(i/32),q:Point=point((i+1)/32);g.moveTo(p.x,p.y);g.lineTo(q.x,q.y);}g.lineStyle();}
            addChild(trail);
            var direction:int=b.x>=a.x?1:-1,fromDx:Number=-direction*80,toDx:Number=direction*80,toDy:Number=0;
            if(a.x+fromDx<30||a.x+fromDx>w-30)fromDx=-fromDx;if(b.x+toDx<30||b.x+toDx>w-30)toDx=-toDx;
            if(!local&&Math.abs(a.x+fromDx-b.x-toDx)<154&&Math.abs(a.y-b.y)<75)toDy=b.y<470?74:-74;
            pin(a,from,fromAccent,false,fromDx,0,w);
            if(!local)pin(b,to,toAccent,true,toDx,toDy,w);
            vehicle.name=id;var vw:Number=flight?134:108,vh:Number=flight?74:63;
            image=new AssetImage(path,vw,vh,AssetImage.CONTAIN);image.x=-vw/2;image.y=-vh/2;
            if(b.x<a.x){image.scaleX=-1;image.x=vw/2;}vehicle.addChild(image);addChild(vehicle);setProgress(0);
        }
        private function point(p:Number):Point {return new Point(origin.x+(target.x-origin.x)*p,origin.y+(target.y-origin.y)*p-Math.sin(p*Math.PI)*arc);}
        private function drawPath(g:Graphics,p:Number):void {var at:Point=point(0);g.moveTo(at.x,at.y);for(var i:int=1;i<=40*p;i++){at=point(i/40);g.lineTo(at.x,at.y);}at=point(p);g.lineTo(at.x,at.y);}
        private function pin(at:Point,city:String,color:uint,destination:Boolean,dx:Number,dy:Number,w:Number):void {
            var x:Number=at.x+dx,y:Number=at.y+dy,g:Graphics=graphics;
            g.lineStyle(2,0x173c37,.7);g.moveTo(at.x,at.y);g.lineTo(x,y);g.lineStyle();g.beginFill(0x1d4428);g.drawCircle(at.x,at.y,7);g.endFill();g.beginFill(destination?0xffdc5a:0xf2ffff);g.drawCircle(at.x,at.y,4);g.endFill();
            var marker:Sprite=new Sprite();marker.x=x-26;marker.y=y-43;addChild(marker);ClassicChrome.well(marker.graphics,0,0,52,48,destination,true);
            var logo:TeamLogoView=new TeamLogoView(city,color,city.substr(0,1),43);logo.x=4;logo.y=0;marker.addChild(logo);pins.push(logo);
            var lx:Number=Math.max(5,Math.min(w-150,x-74)),ly:Number=y+39;
            ClassicChrome.fill(g,lx,ly,148,25,[0x226d90,0x0b3c5c],[0,255],12);
            var caption:TextField=ClassicInventorySkin.text(this,city,lx+4,ly+2,140,22,11,destination?0xffe984:0xffffff,"center",false);caption.name=destination?"journey-destination-city":"journey-origin-city";
        }
        public function setProgress(value:Number):void {
            if(dead)return;var p:Number=Math.max(0,Math.min(1,value)),at:Point=point(p);vehicle.x=at.x;vehicle.y=at.y-(local?45:0);
            if(flight&&!local){var dy:Number=target.y-origin.y-Math.cos(p*Math.PI)*Math.PI*arc,tilt:Number=Math.atan2(dy,Math.abs(target.x-origin.x))*180/Math.PI;vehicle.rotation=Math.max(-28,Math.min(28,target.x<origin.x?-tilt:tilt));}
            else vehicle.rotation=local?0:Math.sin(p*Math.PI*2)*1.5;
            var percent:int=int(p*100);if(percent==lastPercent)return;lastPercent=percent;trail.graphics.clear();if(!local&&p>0){trail.graphics.lineStyle(5,0x48652b,.5);drawPath(trail.graphics,p);trail.graphics.lineStyle(3,0xffe16b);drawPath(trail.graphics,p);trail.graphics.lineStyle();}
        }
        public function dispose():void {if(dead)return;dead=true;if(image)image.dispose();for each(var p:TeamLogoView in pins)p.dispose();pins=[];}
    }
}
