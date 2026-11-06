package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    /** Seven supplied reference bats plus twelve reconstructed collector bats. */
    public class GearArtwork extends Sprite {
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/equipment092/sheet.png")] private static const Sheet:Class;
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v097/bats-atlas.png")] private static const Collector:Class;
        private static var frames:Array=[],collector:Array=[];
        private static const COLLECTOR:Array=[[72, 9, 131, 480], [319, 9, 136, 480], [570, 9, 136, 479], [826, 9, 134, 480], [1075, 9, 137, 480], [1333, 8, 131, 480], [66, 515, 140, 483], [319, 515, 137, 483], [563, 516, 143, 483], [821, 516, 142, 483], [1071, 515, 146, 484], [1325, 515, 147, 484]];
        private static const BOXES:Array=[[60,14,61,210],[178,14,61,210],[296,14,61,210],[414,14,61,210],[532,14,61,210],[650,14,61,210],[768,14,61,210]];
        public function GearArtwork(itemName:String,height:Number=72){
            mouseEnabled=mouseChildren=false;warm();
            var index:int=itemName.indexOf("APEX")==0?1:itemName.indexOf("EXTREME")==0?2:itemName.indexOf("ALL STAR")==0?3:itemName.toUpperCase().indexOf("LUCK")>=0?6:itemName.toUpperCase().indexOf("POWER")>=0?5:itemName.toUpperCase().indexOf("CONTACT")>=0?4:0;
            var pixels:BitmapData=frames[index];
            if(itemName.indexOf("COLLECTOR ")==0){if(!collector.length){var sheet:BitmapData=Bitmap(new Collector()).bitmapData;for each(var box:Array in COLLECTOR){var cropped:BitmapData=new BitmapData(box[2],box[3],true,0);cropped.copyPixels(sheet,new Rectangle(box[0],box[1],box[2],box[3]),new Point());collector.push(cropped);}sheet.dispose();}for(var i:int=0;i<GearPieceArtwork.THEMES.length;i++)if(itemName.indexOf("COLLECTOR "+GearPieceArtwork.THEMES[i]+" ")==0){pixels=collector[i];break;}}
            var b:Bitmap=new Bitmap(pixels,"auto",true);b.scaleX=b.scaleY=height/pixels.height;b.x=-b.width*.5;b.y=-height*.5;addChild(b);
        }
        private static function warm():void {
            if(frames.length)return;var sheet:BitmapData=Bitmap(new Sheet()).bitmapData;
            for each(var box:Array in BOXES){var b:BitmapData=new BitmapData(box[2],box[3],true,0);b.copyPixels(sheet,new Rectangle(box[0],box[1],box[2],box[3]),new Point());frames.push(b);}
            sheet.dispose();
        }
    }
}
