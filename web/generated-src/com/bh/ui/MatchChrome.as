package com.bh.ui {
    import flash.display.Graphics;
    /** Shared painted-once materials for the match boards and scorebook. */
    public class MatchChrome {
        public static function paper(g:Graphics,x:Number,y:Number,w:Number,h:Number):void {
            g.lineStyle();g.beginFill(0x052a32,.35);g.drawRoundRect(x+2,y+4,w,h,9);g.endFill();
            g.lineStyle(2,0x203e43);ClassicChrome.fill(g,x,y,w,h,[0xf9ffff,0xa3b4ae,0x526962],[0,100,255],8);
            g.lineStyle(1,0xffffff);ClassicChrome.fill(g,x+4,y+4,w-8,h-8,[0xffffff,0xf1f4e8,0xd2dacf],[0,160,255],4);g.lineStyle();
        }
        public static function nameplate(g:Graphics,x:Number,y:Number,w:Number,h:Number,blue:Boolean=false):void {
            g.lineStyle(1.3,0x203c3e);ClassicChrome.fill(g,x,y,w,h,blue?[0x9ee5ff,0x299ac8,0x0d5b91]:[0xaab8a9,0x637565,0x2b403b],[0,95,255],4);
            g.lineStyle(1,0xffffff,.55);g.moveTo(x+3,y+2);g.lineTo(x+w-3,y+2);g.lineStyle();
        }
        public static function score(g:Graphics,x:Number,y:Number,w:Number,h:Number):void {
            g.lineStyle(2,0x172f36);ClassicChrome.fill(g,x,y,w,h,[0x9db3b7,0x2b5058,0x12323c],[0,60,255],5);
            g.lineStyle(1,0x829fa2,.5);g.moveTo(x+3,y+3);g.lineTo(x+w-3,y+3);g.lineStyle();
        }
        public static function row(g:Graphics,x:Number,y:Number,w:Number,h:Number,active:Boolean,odd:Boolean):void {
            g.lineStyle(1,active?0xd5a337:0xc5cfc4);ClassicChrome.fill(g,x,y,w,h,active?[0xfff9d9,0xf5df95]:odd?[0xf1f4e8,0xe0e7dc]:[0xffffff,0xf1f4e8],[0,255],4);g.lineStyle();
        }
    }
}
