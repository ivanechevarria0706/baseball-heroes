package com.bh.visual {
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import com.bh.model.GameData;
    /** One camera transform for existing saved coordinates. No save migration. */
    public class StadiumPlacement {
        public static function position(entry:Object,w:Number=960,h:Number=720):Point {
            return new Point((210+Number(entry.x)/556*540)*w/960,
                (252+(Number(entry.y)-130)/162*77)*h/720);
        }
        public static function stored(point:Point,w:Number=960,h:Number=720):Point {
            return new Point((point.x*960/w-210)/540*556,
                130+(point.y*720/h-252)/77*162);
        }
        public static function place(view:DisplayObject,entry:Object,w:Number=960,h:Number=720):void {
            var p:Point=position(entry,w,h);view.x=p.x;view.y=p.y;
            view.scaleX=Number(entry.scale)*.75*w/960;view.scaleY=Number(entry.scale)*.75*h/720;
        }
        public static function dragBounds():Rectangle {
            var a:Point=position({x:30,y:130}),b:Point=position({x:526,y:292});
            return new Rectangle(a.x,a.y,b.x-a.x,b.y-a.y);
        }
        public static function profile(preview:Object=null):Object {
            var equipped:Object={};for(var key:String in GameData.stadiumActive)equipped[key]=GameData.stadiumActive[key];
            if(preview&&preview.slot!="decoration")equipped[String(preview.slot)]=String(preview.id);
            return {equipped:equipped,decorations:GameData.stadiumDecorations.concat()};
        }
    }
}
