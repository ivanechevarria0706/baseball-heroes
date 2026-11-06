package com.bh.visual {
    import flash.display.*;
    import flash.geom.*;
    /** The user's 11_08 sheet, cropped in memory without repainting its art. */
    public class TrainingArtwork {
        [Embed(source="../../../../assets/reference/training/room-sheet.png")] private static const Sheet:Class;
        [Embed(source="../../../../assets/reference/training/running-activities.jpg")] private static const Activities:Class;
        [Embed(source="../../../../assets/reference/training/stretching-reference.jpg")] private static const Stretching:Class;
        [Embed(source="../../../../assets/reference/training/lifting-reference.jpg")] private static const Lifting:Class;
        private static var source:BitmapData;
        private static var activitySource:BitmapData;
        private static var stretchingSource:BitmapData,liftingSource:BitmapData;
        public static function image(coach:Boolean=false):Bitmap {
            if(!source)source=Bitmap(new Sheet()).bitmapData;
            var r:Rectangle=coach?new Rectangle(54,711,84,99):new Rectangle(0,485,880,572);
            var pixels:BitmapData=new BitmapData(r.width,r.height,true,0);
            pixels.copyPixels(source,r,new Point());return new Bitmap(pixels,"auto",true);
        }
        public static function assistant():Bitmap {
            if(!source)source=Bitmap(new Sheet()).bitmapData;
            var r:Rectangle=new Rectangle(9,5,181,200),pixels:BitmapData=new BitmapData(r.width,r.height,true,0);
            pixels.copyPixels(source,r,new Point());return new Bitmap(pixels,"auto",true);
        }
        public static function seasonCoach():Bitmap {return RecruitmentArtwork.coachBitmap();}
        public static function coachFor(discipline:String):Bitmap {
            var src:BitmapData,r:Rectangle;
            if(discipline=="running") {
                if(!activitySource)activitySource=Bitmap(new Activities()).bitmapData;
                src=activitySource;r=new Rectangle(980,96,80,80);
            }else{
                if(!stretchingSource)stretchingSource=Bitmap(new Stretching()).bitmapData;
                if(!liftingSource)liftingSource=Bitmap(new Lifting()).bitmapData;
                src=discipline=="stretching"?stretchingSource:liftingSource;
                r=new Rectangle(963,125,81,87);
            }
            var pixels:BitmapData=new BitmapData(r.width,r.height,true,0);
            pixels.copyPixels(src,r,new Point());return new Bitmap(pixels,"auto",true);
        }
        public static function activity(index:int,discipline:String="running"):Bitmap {
            if(discipline!="running") {
                if(!stretchingSource)stretchingSource=Bitmap(new Stretching()).bitmapData;
                if(!liftingSource)liftingSource=Bitmap(new Lifting()).bitmapData;
                var src:BitmapData=discipline=="stretching"?stretchingSource:liftingSource;
                var rect:Rectangle=new Rectangle([257,522,787][index%3],index<3?261:507,238,71);
                var crop:BitmapData=new BitmapData(rect.width,rect.height,true,0);
                crop.copyPixels(src,rect,new Point());return new Bitmap(crop,"auto",true);
            }
            if(!activitySource)activitySource=Bitmap(new Activities()).bitmapData;
            var x:int=[235,514,793][index%3],y:int=index<3?211:402;
            var r:Rectangle=new Rectangle(x,y,244,62),pixels:BitmapData=new BitmapData(r.width,r.height,true,0);
            pixels.copyPixels(activitySource,r,new Point());return new Bitmap(pixels,"auto",true);
        }
    }
}
