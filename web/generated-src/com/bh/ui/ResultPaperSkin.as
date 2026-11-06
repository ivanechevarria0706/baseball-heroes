package com.bh.ui {
    import flash.display.*;
    import flash.text.*;
    import com.bh.visual.InterfaceSprite;
    import com.bh.visual.LevelUpArtwork;
    /** Static paper, engraved scores and reward emblems, reconstructed from the videos. */
    public class ResultPaperSkin {
        public static function paper(g:Graphics,x:Number,y:Number,w:Number,h:Number):void {
            g.lineStyle();g.beginFill(0x10212b,.45);g.drawRoundRect(x+3,y+5,w,h,14);g.endFill();
            g.lineStyle(3,0x263b47);ClassicChrome.fill(g,x,y,w,h,[0xffffff,0xf3f3ee,0xd4d7d4],[0,180,255],14);
            g.lineStyle(2,0xffffff);g.drawRoundRect(x+4,y+4,w-8,h-8,10);g.lineStyle();
            // Fixed grain: no textures allocated and no per-frame drawing.
            for(var i:int=0;i<180;i++){g.beginFill(i%2?0xffffff:0x82949d,i%2?.2:.035);g.drawRect(x+10+(i*71)%int(w-20),y+12+(i*97)%int(h-24),3+i%4,2);g.endFill();}
        }
        public static function text(parent:DisplayObjectContainer,id:String,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String="center",heading:Boolean=false):TextField {
            var t:TextField=new TextField();t.name=id;t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=t.mouseEnabled=false;
            LineupTypography.fit(t,size,color,align,heading);parent.addChild(t);return t;
        }
        public static function outlined(parent:DisplayObjectContainer,id:String,value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,edge:uint=0x273b48,radius:Number=2):Sprite {
            var s:Sprite=new Sprite();s.name=id+"-art";s.x=x;s.y=y;s.mouseEnabled=s.mouseChildren=false;parent.addChild(s);
            for(var i:int=0;i<8;i++){var a:Number=i*Math.PI/4;text(s,id+"-outline-"+i,value,Math.cos(a)*radius,Math.sin(a)*radius,w,h,size,edge,"center",true);}
            text(s,id,value,0,0,w,h,size,color,"center",true);return s;
        }
        public static function star(g:Graphics,cx:Number,cy:Number,r:Number):void {
            g.lineStyle(3,0x183b54);g.beginFill(0x389cd0);
            for(var i:int=0;i<=10;i++){var a:Number=-Math.PI/2+i*Math.PI/5,rr:Number=i%2?r*.51:r,x:Number=cx+Math.cos(a)*rr,y:Number=cy+Math.sin(a)*rr;if(i==0)g.moveTo(x,y);else g.lineTo(x,y);}g.endFill();
            g.lineStyle(2,0xd9f5ff);g.moveTo(cx,cy-r+7);g.lineTo(cx+9,cy-12);g.lineTo(cx+r-8,cy-10);g.lineStyle();
            g.beginFill(0x9cddff,.65);g.moveTo(cx,cy-r+6);g.lineTo(cx,cy+4);g.lineTo(cx-r*.72,cy+r*.57);g.lineTo(cx-r*.48,cy-7);g.lineTo(cx,cy-r+6);g.endFill();
        }
        public static function reward(g:Graphics,x:Number,y:Number,w:Number,h:Number,active:Boolean,bonus:Boolean=false):void {
            var bright:uint=active?(bonus?0x9ae1fb:0xffef8e):0xc4c9c8,base:uint=active?(bonus?0x198fc4:0xe4b12c):0x8b9292;
            g.lineStyle(2,0x233944);ClassicChrome.fill(g,x,y,w,h,[0xffffff,0xa9b4b6],[0,255],7);
            g.lineStyle(1,0xffffff);ClassicChrome.fill(g,x+4,y+4,w-8,h-8,[bright,base,ClassicChrome.blend(base,0x374b52,.2)],[0,125,255],4);g.lineStyle();
            for(var i:int=0;i<12;i++){g.beginFill(0xffffff,active?.12:.04);g.drawRect(x+8+(i%6)*10,y+8+int(i/6)*9,4,4);g.endFill();}
        }
        public static function icon(parent:DisplayObjectContainer,id:String,x:Number,y:Number,size:Number=44):void {
            var s:Sprite=new Sprite();s.name="reward-icon-"+id;s.x=x;s.y=y;s.scaleX=s.scaleY=size/44;s.mouseEnabled=s.mouseChildren=false;parent.addChild(s);var g:Graphics=s.graphics;
            var art:Sprite=id=="COINS"?new InterfaceSprite("coin",44,44):id=="MAX ENERGY"?new InterfaceSprite("energy",44,44):new LevelUpArtwork("skill",44,44);
            art.x=art.y=-22;s.addChild(art);
        }
    }
}
