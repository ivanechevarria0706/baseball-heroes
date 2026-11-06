package com.bh.ui {
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.Font;
    /** Consistent browser lettering; these are substitutes for the unrecovered game fonts. */
    public class LineupTypography {
        [Embed(source="C:/Windows/Fonts/arialbd.ttf", fontName="BHLineup", fontWeight="bold", embedAsCFF="false", unicodeRange="U+0020-U+00FF")]
        private static const Body:Class;
        [Embed(source="C:/Windows/Fonts/ariblk.ttf", fontName="BHLineupHeading", fontWeight="normal", embedAsCFF="false", unicodeRange="U+0020-U+00FF")]
        private static const Heading:Class;
        private static var registered:Boolean=false;
        public static function apply(t:TextField,size:int,color:uint,align:String,heading:Boolean=false):void {
            if(!registered){Font.registerFont(Body);Font.registerFont(Heading);registered=true;}
            var supported:Boolean=!/[^\u0020-\u00ff\r\n]/.test(t.text);
            var f:TextFormat=new TextFormat(supported?(heading?"BHLineupHeading":"BHLineup"):"Arial",size,color,!heading);
            f.align=align;t.embedFonts=supported;t.defaultTextFormat=f;t.setTextFormat(f);
        }
        public static function fit(t:TextField,size:int,color:uint,align:String,heading:Boolean=false,minSize:int=8):void {
            apply(t,size,color,align,heading);
            while(size>minSize&&(t.textHeight+4>t.height||t.textWidth+4>t.width))apply(t,--size,color,align,heading);
        }
    }
}
