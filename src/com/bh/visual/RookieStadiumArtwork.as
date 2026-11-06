package com.bh.visual {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;

    /** Reconstructed plate, aligned to the existing batting camera and BUILD masks. */
    public class RookieStadiumArtwork extends Sprite {
        [Embed(source="../../../../assets/reference/v1020/rookie-stadium.png")]
        private static const Plate:Class;
        private static var pixels:BitmapData;

        public function RookieStadiumArtwork(w:Number=960,h:Number=720) {
            name="rookie-stadium-artwork";mouseEnabled=mouseChildren=false;
            // Share immutable pixels across HOME, previews and matches. No image download.
            if(!pixels)pixels=Bitmap(new Plate()).bitmapData;
            var picture:Bitmap=new Bitmap(pixels,"auto",true);
            picture.width=w;picture.height=h;addChild(picture);
        }
    }
}
