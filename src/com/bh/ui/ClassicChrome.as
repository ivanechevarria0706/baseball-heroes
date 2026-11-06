package com.bh.ui {
    import flash.display.*;
    import flash.geom.Matrix;
    import flash.text.*;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    /** Painted once: layered rims and bevels, with no animated blur surfaces. */
    public class ClassicChrome {
        [Embed(source="C:/Windows/Fonts/impact.ttf",fontName="BHClassicTitle",embedAsCFF="false",unicodeRange="U+0020-U+00FF")]
        private static const Title:Class;
        private static var registered:Boolean=false;
        public static function blend(c:uint,other:uint,amount:Number):uint {return (int(((c>>16)&255)*(1-amount)+((other>>16)&255)*amount)<<16)|(int(((c>>8)&255)*(1-amount)+((other>>8)&255)*amount)<<8)|int((c&255)*(1-amount)+(other&255)*amount);}
        public static function fill(g:Graphics,x:Number,y:Number,w:Number,h:Number,colors:Array,stops:Array,r:Number=8):void {if(w<=0||h<=0)return;var m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI/2,x,y);var alpha:Array=[];for(var i:int=0;i<colors.length;i++)alpha.push(1);g.beginGradientFill(GradientType.LINEAR,colors,alpha,stops,m);g.drawRoundRect(x,y,w,h,Math.max(0,r));g.endFill();}
        public static function panel(g:Graphics,x:Number,y:Number,w:Number,h:Number):void {
            g.lineStyle();g.beginFill(0x001529,.4);g.drawRoundRect(x+1,y+4,w,h,15);g.endFill();
            g.lineStyle(2,0x061c2b);fill(g,x,y,w,h,[0xd9f6ff,0x428cae,0x12384d],[0,72,255],15);
            g.lineStyle(1,0x9fe9ff);fill(g,x+3,y+3,w-6,h-6,[0x1d7cab,0x07365d],[0,255],12);
            g.lineStyle(1,0x062b47);fill(g,x+6,y+6,w-12,h-12,[0x087ab8,0x096ba5,0x074978,0x063b68],[0,55,165,255],9);
            g.lineStyle(1,0xa6ebff,.6);g.moveTo(x+11,y+7);g.lineTo(x+w-11,y+7);g.lineStyle(2,0x031f3a,.7);g.moveTo(x+10,y+h-6);g.lineTo(x+w-10,y+h-6);g.lineStyle();
            // Faint stepped reflections follow the restrained blue original chrome.
            for(var i:int=0;i<3;i++){g.beginFill(0xa3e9ff,.025);g.drawRoundRect(x+10+i*2,y+15+i*27,w-20-i*4,10,4);g.endFill();}
        }
        public static function bar(g:Graphics,x:Number,y:Number,w:Number,h:Number,selected:Boolean=true):void {
            g.lineStyle(1,0x0b2c46);fill(g,x,y,w,h,selected?[0x61d3f6,0x178dc9,0x0575b5,0x034678]:[0x3b91be,0x136598,0x0a3f6e],[0,65,130,255].slice(selected?0:1),8);
            g.lineStyle(1,0xc4f5ff,selected?.75:.3);g.moveTo(x+7,y+2);g.lineTo(x+w-7,y+2);g.lineStyle(1,0x032744,.8);g.moveTo(x+5,y+h-2);g.lineTo(x+w-5,y+h-2);g.lineStyle();
        }
        public static function well(g:Graphics,x:Number,y:Number,w:Number,h:Number,selected:Boolean=false,paper:Boolean=true):void {
            g.lineStyle(1.5,selected?0x1c638a:0x233e4e);fill(g,x,y,w,h,[0xf9ffff,0x90a9b7,0x426579],[0,73,255],8);
            g.lineStyle(1,selected?0xeaffff:0xffffff);fill(g,x+3,y+3,w-6,h-6,paper?(selected?[0xeeffff,0xc6f4ff,0x8fc8de]:[0xffffff,0xf0f3ee,0xbac6c8]):[0x215879,0x0c385a,0x082943],[0,90,255],5);
            g.lineStyle(1,selected?0x82eaff:0xffffff,.65);g.moveTo(x+7,y+4);g.lineTo(x+w-7,y+4);g.lineStyle();
        }
        public static function button(g:Graphics,w:Number,h:Number,color:uint,hover:Boolean=false,pressed:Boolean=false,pill:Boolean=true):void {
            var r:Number=pill?h:9,offset:Number=pressed?1.5:0,c:uint=hover?blend(color,0xffffff,.12):color;
            g.lineStyle();g.beginFill(0x031c2a,.55);g.drawRoundRect(0,2,w,h,r);g.endFill();
            g.lineStyle(1.7,0x142d3d);fill(g,0,offset,w,h-1,[0xffffff,0xbad0d8,0x557283],[0,55,255],r);
            g.lineStyle(1,0xf3ffff);fill(g,3,offset+3,w-6,h-7,[blend(c,0xffffff,pressed?.16:.53),blend(c,0xffffff,.18),c,blend(c,0x061b29,.3)],[0,90,130,255],Math.max(3,r-4));
            g.lineStyle(1,0xffffff,pressed?.22:.7);g.moveTo(7,offset+4);g.lineTo(w-7,offset+4);g.lineStyle(1,blend(c,0x071b27,.5),.9);g.moveTo(7,h-5+offset);g.lineTo(w-7,h-5+offset);g.lineStyle();
        }
        public static function title(t:TextField,size:int,color:uint=0xffffff,align:String="center"):void {
            if(!registered){Font.registerFont(Title);registered=true;}
            var f:TextFormat=new TextFormat("BHClassicTitle",size,color,false);f.align=align;f.letterSpacing=.35;t.embedFonts=true;t.defaultTextFormat=f;t.setTextFormat(f);
            while(size>10&&(t.textHeight+4>t.height||t.textWidth+4>t.width)){f.size=--size;t.defaultTextFormat=f;t.setTextFormat(f);}
            t.filters=[new GlowFilter(color==0xffffff?0x143a55:0xf4ffff,1,2,2,5,1),new DropShadowFilter(1.5,90,0x082b42,.8,0,0,1)];
        }
    }
}
