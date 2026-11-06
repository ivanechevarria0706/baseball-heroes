package com.bh.visual {
    import flash.display.*;
    import flash.geom.Matrix;
    import com.bh.model.GameData;
    /** Shared line work and materials for the two native hero views. */
    public class HeroArtwork {
        public static const INK:uint=0x14232e;
        public static function palette(name:String,accent:uint,appearance:Object=null):Object {
            var p:Object=GameData.playerByName(name),a:Object=appearance!=null?appearance:(p?p.appearance:null);
            return {skin:VisualProfile.skin(name,a),hair:VisualProfile.hair(name,a),eye:VisualProfile.eyeColor(name,a),uniform:accent,
                helmet:equipment('helmet',accent),bat:equipment('bat',0xc49a58),shoe:equipment('shoes',0x344454),belt:equipment('belt',0x313f4c),goggles:equipment('goggles',0)};
        }
        private static function equipment(slot:String,fallback:uint):uint{var item:Object=GameData.equipped?GameData.equipped[slot]:null;return item&&item.accent!==undefined?uint(item.accent):fallback;}
        public static function poly(g:Graphics,points:Array,color:uint,thickness:Number=2.2):void {g.lineStyle(thickness,INK,1,true);g.beginFill(color);g.moveTo(points[0],points[1]);for(var i:int=2;i<points.length;i+=2)g.lineTo(points[i],points[i+1]);g.lineTo(points[0],points[1]);g.endFill();g.lineStyle();}
        private static function finish(g:Graphics,color:uint,x:Number,y:Number,w:Number,h:Number):void {
            var m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI*.38,x,y);
            g.lineStyle(2.8,INK,1,true);g.beginGradientFill(GradientType.LINEAR,[VisualProfile.lighter(color,.52),color,VisualProfile.darker(color,.48)],[1,1,1],[0,135,255],m);
        }
        public static function bat(g:Graphics,color:uint):void {
            g.clear();finish(g,color,-25,-138,50,148);
            g.moveTo(-4,8);g.lineTo(-4,-24);g.curveTo(-5,-43,-17,-65);g.lineTo(-23,-124);g.curveTo(-24,-134,-14,-136);g.lineTo(14,-136);g.curveTo(24,-134,23,-124);g.lineTo(17,-65);g.curveTo(5,-43,4,-24);g.lineTo(4,8);g.lineTo(-4,8);g.endFill();
            g.lineStyle(3,VisualProfile.lighter(color,.76),.75);g.moveTo(-15,-122);g.lineTo(-11,-72);
            g.lineStyle(1,VisualProfile.darker(color,.45),.4);g.moveTo(13,-124);g.curveTo(8,-98,12,-69);
            g.lineStyle(7,0x354653);g.moveTo(0,-24);g.lineTo(0,5);g.lineStyle(1,0xb0c1c8);for(var y:int=-22;y<4;y+=4){g.moveTo(-3,y);g.lineTo(3,y+2);}poly(g,[-7,5,7,5,7,10,-7,10],0x354653);
        }
        public static function sideHead(g:Graphics,p:Object,back:Number=0):void {
            g.clear();
            if(back<.65){poly(g,[19,12,41,12,43,23,49,27,44,32,41,42,28,44,16,37],p.skin);g.lineStyle(2,INK);g.moveTo(37,23);g.lineTo(42,22);g.moveTo(37,35);g.lineTo(42,34);}
            poly(g,[5,34,29,36,23,52,6,50],0xfffdf1);
            finish(g,p.helmet,-57,-61,114,105);
            g.moveTo(-53,-5);g.curveTo(-57,-38,-29,-54);g.curveTo(2,-69,32,-46);g.curveTo(53,-29,48,-4);g.curveTo(46,22,22,34);g.curveTo(-3,46,-31,24);g.curveTo(-52,12,-53,-5);g.endFill();
            if(back<.7)poly(g,[37,-24,60,-8,48,0,35,-6],VisualProfile.darker(p.helmet,.18));
            var ear:Number=22+back*9;g.lineStyle(2.7,INK);g.beginFill(p.helmet);g.drawEllipse(ear,-1,25,34);g.endFill();g.beginFill(0x0c202e);g.drawEllipse(ear+5,5,14,22);g.endFill();
            g.lineStyle(1.8,VisualProfile.lighter(p.helmet,.45));g.moveTo(32,-42);g.curveTo(21,-25,26,-10);g.lineStyle();
            g.beginFill(0xffffff,.9);g.drawEllipse(-27,-47,24,9);g.endFill();g.beginFill(0xffffff,.22);g.drawEllipse(-33,-46,35,12);g.endFill();
            g.lineStyle(1.4,VisualProfile.lighter(p.helmet,.64),.65);g.moveTo(-47,-16);g.curveTo(-48,-34,-31,-45);g.lineStyle();
        }
        public static function frontHead(g:Graphics,p:Object):void {
            g.clear();poly(g,[-10,31,10,31,11,51,-11,51],p.skin);
            finish(g,p.helmet,-55,-62,110,103);g.moveTo(-51,4);g.curveTo(-57,-41,-22,-58);g.curveTo(15,-70,44,-39);g.curveTo(57,-17,47,19);g.lineTo(32,31);g.lineTo(-34,28);g.lineTo(-51,4);g.endFill();
            poly(g,[-33,-5,-23,-23,22,-23,36,-7,32,27,16,43,-10,43,-30,27],p.skin);
            poly(g,[-35,-7,-20,-28,27,-24,37,-7,18,-14,5,-1,6,-16,-11,-3,-9,-19,-29,-4],p.hair);
            poly(g,[-34,2,-25,5,-26,25,-37,18],VisualProfile.darker(p.helmet,.25));
            poly(g,[31,1,42,-2,41,24,32,30,28,19],p.helmet);
            g.lineStyle(2,INK);g.beginFill(0xfffdf5);g.moveTo(-22,5);g.lineTo(-6,8);g.lineTo(-8,19);g.lineTo(-19,18);g.lineTo(-22,5);g.endFill();g.beginFill(0xfffdf5);g.moveTo(5,8);g.lineTo(23,3);g.lineTo(20,18);g.lineTo(8,19);g.lineTo(5,8);g.endFill();
            g.lineStyle();g.beginFill(p.eye);g.drawEllipse(-15,9,6,9);g.drawEllipse(10,8,6,10);g.endFill();g.beginFill(0xffffff);g.drawCircle(-12,10,1.4);g.drawCircle(13,9,1.4);g.endFill();
            g.lineStyle(1.6,VisualProfile.darker(p.skin,.32));g.moveTo(0,16);g.lineTo(-3,24);g.lineTo(2,24);g.lineStyle(1.8,INK);g.moveTo(-8,32);g.curveTo(1,35,11,30);
            if(p.goggles){g.lineStyle(2.3,p.goggles);g.drawRoundRect(-25,2,22,21,6);g.drawRoundRect(3,1,23,21,6);g.moveTo(-3,10);g.lineTo(3,10);}
            poly(g,[-35,-22,27,-25,39,-16,20,-12,-35,-13],VisualProfile.darker(p.helmet,.13));
            g.lineStyle();g.beginFill(0xffffff,.88);g.drawEllipse(-30,-49,28,9);g.endFill();g.lineStyle(1.5,VisualProfile.lighter(p.helmet,.6),.65);g.moveTo(-46,-14);g.curveTo(-49,-35,-33,-45);g.lineStyle();
        }
    }
}
