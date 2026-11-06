package com.bh.ui {
    import flash.display.*;
    import flash.geom.Matrix;
    import flash.text.*;
    import flash.filters.GlowFilter;
    import com.bh.visual.InterfaceSprite;
    import com.bh.visual.InventoryArtwork;
    /** UI geometry traced against the supplied 1280x720 inventory recording.
     * Horizontal positions are normalized to the game's 960x720 viewport. */
    public class ClassicInventorySkin {
        public static function gradient(g:Graphics,x:Number,y:Number,w:Number,h:Number,a:uint,b:uint,r:Number=8):void {
            var m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI/2,x,y);
            g.beginGradientFill(GradientType.LINEAR,[a,b],[1,1],[0,255],m);g.drawRoundRect(x,y,w,h,r,r);g.endFill();
        }
        public static function text(parent:Sprite,value:String,x:Number,y:Number,w:Number,h:Number,size:int=12,color:uint=0xffffff,align:String="left",outline:Boolean=false):TextField {
            var t:TextField=new TextField(),f:TextFormat=new TextFormat("Arial",size,color,true);f.align=align;
            t.defaultTextFormat=f;t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=false;t.mouseEnabled=false;t.multiline=true;t.wordWrap=true;
            LineupTypography.fit(t,size,color,align,size>=24);if(outline)t.filters=[new GlowFilter(0x173342,1,2,2,5,1)];parent.addChild(t);return t;
        }
        public static function button(label:String,w:Number=110,h:Number=28,color:uint=0x7caf30):Sprite {
            return new ClassicActionButton(label,w,h,color);
        }
        private static function light(c:uint):uint {
            return (Math.min(255,((c>>16)&255)+65)<<16)|(Math.min(255,((c>>8)&255)+65)<<8)|Math.min(255,(c&255)+65);
        }
        public static function panel(g:Graphics,x:Number,y:Number,w:Number,h:Number):void {
            ClassicChrome.panel(g,x,y,w,h);
        }
        public static function icon(parent:Sprite,kind:String,x:Number,y:Number,scale:Number=1):Sprite {
            var key:String=kind=="box"?"mystery":kind;
            if(InventoryArtwork.supports(key)){
                var recovered:Sprite=new InventoryArtwork(key,36,33);recovered.x=x;recovered.y=y;recovered.scaleX=recovered.scaleY=scale;parent.addChild(recovered);return recovered;
            }
            if(InterfaceSprite.supports(key)){
                var art:Sprite=new InterfaceSprite(key,kind=="coin"||kind=="cash"?28:36,33);
                art.x=x;art.y=y;art.scaleX=art.scaleY=scale;parent.addChild(art);return art;
            }
            var s:Sprite=new Sprite();s.x=x;s.y=y;s.scaleX=s.scaleY=scale;parent.addChild(s);
            return s;
        }
    }
}
