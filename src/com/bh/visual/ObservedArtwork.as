package com.bh.visual {
    import flash.display.*;import flash.geom.*;import com.bh.model.EquipmentCatalog;
    /** Pixel windows extracted from the user-supplied video. Cache once per key. */
    public class ObservedArtwork extends Sprite {
        [Embed(source="../../../../assets/reference/v116/card_howard_d.png")] private static const A0:Class;
        [Embed(source="../../../../assets/reference/v116/card_billie_k.png")] private static const A1:Class;
        [Embed(source="../../../../assets/reference/v116/card_marvin_k.png")] private static const A2:Class;
        [Embed(source="../../../../assets/reference/v116/card_garret_d.png")] private static const A3:Class;
        [Embed(source="../../../../assets/reference/v116/card_john_g.png")] private static const A4:Class;
        [Embed(source="../../../../assets/reference/v116/card_darren_s.png")] private static const A5:Class;
        [Embed(source="../../../../assets/reference/v116/card_benny_c.png")] private static const A6:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_0.png")] private static const A7:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_1.png")] private static const A8:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_2.png")] private static const A9:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_3.png")] private static const A10:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_4.png")] private static const A11:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_5.png")] private static const A12:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_6.png")] private static const A13:Class;
        [Embed(source="../../../../assets/reference/v116/classic107_glove_7.png")] private static const A14:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_0.png")] private static const A15:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_1.png")] private static const A16:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_2.png")] private static const A17:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_3.png")] private static const A18:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_4.png")] private static const A19:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_5.png")] private static const A20:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_6.png")] private static const A21:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_shoes_7.png")] private static const A22:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_0.png")] private static const A23:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_1.png")] private static const A24:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_2.png")] private static const A25:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_3.png")] private static const A26:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_4.png")] private static const A27:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_5.png")] private static const A28:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_6.png")] private static const A29:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_bat_7.png")] private static const A30:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_0.png")] private static const A31:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_1.png")] private static const A32:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_2.png")] private static const A33:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_3.png")] private static const A34:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_4.png")] private static const A35:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_5.png")] private static const A36:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_6.png")] private static const A37:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_goggles_7.png")] private static const A38:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_0.png")] private static const A39:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_1.png")] private static const A40:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_2.png")] private static const A41:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_3.png")] private static const A42:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_4.png")] private static const A43:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_5.png")] private static const A44:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_6.png")] private static const A45:Class;
        [Embed(source="../../../../assets/reference/v116/classic116_belt_7.png")] private static const A46:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_0.png")] private static const H0:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_1.png")] private static const H1:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_2.png")] private static const H2:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_3.png")] private static const H3:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_4.png")] private static const H4:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_5.png")] private static const H5:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_6.png")] private static const H6:Class;
        [Embed(source="../../../../assets/reference/v117/classic117_helmet_7.png")] private static const H7:Class;
        private static const SOURCES:Object={"card_howard_d":A0,"card_billie_k":A1,"card_marvin_k":A2,"card_garret_d":A3,"card_john_g":A4,"card_darren_s":A5,"card_benny_c":A6,"classic107_glove_0":A7,"classic107_glove_1":A8,"classic107_glove_2":A9,"classic107_glove_3":A10,"classic107_glove_4":A11,"classic107_glove_5":A12,"classic107_glove_6":A13,"classic107_glove_7":A14,"classic116_shoes_0":A15,"classic116_shoes_1":A16,"classic116_shoes_2":A17,"classic116_shoes_3":A18,"classic116_shoes_4":A19,"classic116_shoes_5":A20,"classic116_shoes_6":A21,"classic116_shoes_7":A22,"classic116_bat_0":A23,"classic116_bat_1":A24,"classic116_bat_2":A25,"classic116_bat_3":A26,"classic116_bat_4":A27,"classic116_bat_5":A28,"classic116_bat_6":A29,"classic116_bat_7":A30,"classic116_goggles_0":A31,"classic116_goggles_1":A32,"classic116_goggles_2":A33,"classic116_goggles_3":A34,"classic116_goggles_4":A35,"classic116_goggles_5":A36,"classic116_goggles_6":A37,"classic116_goggles_7":A38,"classic116_belt_0":A39,"classic116_belt_1":A40,"classic116_belt_2":A41,"classic116_belt_3":A42,"classic116_belt_4":A43,"classic116_belt_5":A44,"classic116_belt_6":A45,"classic116_belt_7":A46,"classic117_helmet_0":H0,"classic117_helmet_1":H1,"classic117_helmet_2":H2,"classic117_helmet_3":H3,"classic117_helmet_4":H4,"classic117_helmet_5":H5,"classic117_helmet_6":H6,"classic117_helmet_7":H7};
        private static var cache:Object={},gearNames:Object;
        public static function supports(key:String):Boolean {return SOURCES[key]!==undefined;}
        public static function gearKey(item:Object):String {
            if(!item)return '';if(item.id&&supports(String(item.id)))return String(item.id);
            if(!gearNames){gearNames={};for each(var entry:Object in EquipmentCatalog.items())if(supports(String(entry.id)))gearNames[String(entry.name)+'|'+String(entry.slot)]=String(entry.id);}
            var key:String=String(item.name)+'|'+String(item.slot);return gearNames[key]===undefined?'':String(gearNames[key]);
        }
        public function ObservedArtwork(key:String,w:Number=72,h:Number=72) {
            name='observed-art-'+key;mouseEnabled=mouseChildren=false;
            if(!supports(key))return;
            if(!cache[key]){var C:Class=SOURCES[key];var pixels:BitmapData=Bitmap(new C()).bitmapData;
                if(key.indexOf('classic')==0)clearExterior(pixels);cache[key]=pixels;}
            var image:Bitmap=new Bitmap(cache[key],'auto',true);image.scaleX=image.scaleY=Math.min(w/image.width,h/image.height);image.x=(w-image.width)/2;image.y=(h-image.height)/2;addChild(image);
        }
        // Remove only connected neutral catalogue background. Ink encloses white details.
        private static function clearExterior(p:BitmapData):void {
            var queue:Array=[],seen:Object={},w:int=p.width,h:int=p.height;
            for(var x:int=0;x<w;x++){queue.push(x,(h-1)*w+x);}for(var y:int=0;y<h;y++){queue.push(y*w,y*w+w-1);}
            p.lock();for(var index:int=0;index<queue.length;index++){
                var k:int=queue[index];if(k<0||k>=w*h||seen[k])continue;seen[k]=true;x=k%w;y=int(k/w);
                var c:uint=p.getPixel(x,y),red:int=c>>16,green:int=(c>>8)&255,blue:int=c&255;
                if(Math.min(red,green,blue)<135||Math.max(red,green,blue)-Math.min(red,green,blue)>85)continue;
                p.setPixel32(x,y,0);if(x>0)queue.push(k-1);if(x<w-1)queue.push(k+1);if(y>0)queue.push(k-w);if(y<h-1)queue.push(k+w);
            }p.unlock();
        }
        public function dispose():void {while(numChildren){var child:DisplayObject=removeChildAt(0);if(child is Bitmap)Bitmap(child).bitmapData=null;}}
    }
}
