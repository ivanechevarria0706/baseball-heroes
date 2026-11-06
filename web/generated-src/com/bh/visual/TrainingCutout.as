package com.bh.visual {
    import flash.display.BitmapData;
    import flash.geom.Point;
    /** Retain the actor connected to its mount; discard neighboring atlas fragments. */
    public class TrainingCutout {
        public static function isolate(pixels:BitmapData,x:int,y:int):void {
            var mask:BitmapData=new BitmapData(pixels.width,pixels.height,true,0),point:Point=new Point();
            mask.threshold(pixels,pixels.rect,point,">",0x08000000,0xffffffff,0xff000000);
            x=Math.max(0,Math.min(mask.width-1,x));y=Math.max(0,Math.min(mask.height-1,y));
            if(!mask.getPixel32(x,y)) {
                var found:Boolean=false;
                for(var radius:int=1;radius<=40&&!found;radius++)for(var yy:int=Math.max(0,y-radius);yy<=Math.min(mask.height-1,y+radius)&&!found;yy++)for(var xx:int=Math.max(0,x-radius);xx<=Math.min(mask.width-1,x+radius);xx++)if(mask.getPixel32(xx,yy)){x=xx;y=yy;found=true;break;}
                if(!found){mask.dispose();return;}
            }
            mask.floodFill(x,y,0xff00ff00);
            // Native threshold clears other components without repainting retained pixels.
            pixels.threshold(mask,mask.rect,point,"!=",0xff00ff00,0x00000000,0xffffffff,false);mask.dispose();
        }
    }
}
