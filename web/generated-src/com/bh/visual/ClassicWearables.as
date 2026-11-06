package com.bh.visual {
    import flash.display.*;
    import flash.geom.Matrix;
    /** Visible motifs reconstructed from the supplied shop frames. No economy data. */
    public class ClassicWearables {
        public static const HELMETS:Array=["Black Bomber","Red Lightning","Sky Love","Green Star","White Star","Beige Star","Yellow Star","Aqua Star"];
        public static const GOGGLES:Array=["Shooting-Star","Sky Love","Pink Love","Panda","Red Lightning","Lightning","Camo","Spider"];
        public static const GLOVES:Array=["Sleepy Bear","Spider","Purple Star","Blue Lightning","Blue Bomber","Camo","Pink Love","Panda"];
        private static const SHELLS:Array=[0x737573,0xbd3028,0x32a2cd,0x347e30,0xdf6b86,0x467fa8,0xcda82d,0x615b88];
        public static function family(name:String,names:Array):int {for(var i:int=0;i<names.length;i++)if(name==names[i]||name.indexOf(names[i]+" ")==0)return i;return -1;}
        public static function helmetColor(name:String,fallback:uint):uint {var n:int=family(name,HELMETS);return n<0?fallback:uint(SHELLS[n]);}
        public static function hasGlove(name:String):Boolean {return family(name,GLOVES)>=0;}
        public static function hasBat(name:String):Boolean {return name.indexOf("Breaker ")==0||family(name,["Sky Love","Green Star","Black Bomber","Red Lightning"])>=0;}
        public static function hasShoes(name:String):Boolean {return family(name,["Black Bomber","Red Lightning","Sky Love","Green Star","Green","Pink","Sky Blue","Purple"])>=0;}
        public static function batLabel(name:String):String {return name.indexOf("Breaker ")==0?"BREAKER":name.indexOf("Black Bomber")==0?"BOMBER":name.indexOf("Red Lightning")==0?"LIGHTNING":name.indexOf("Green Star")==0?"STAR":"LOVE";}
        private static function star(g:Graphics,x:Number,y:Number,r:Number,color:uint,outline:uint=0):void {
            g.lineStyle(outline?1.8:0,outline);g.beginFill(color);
            for(var i:int=0;i<10;i++){var a:Number=-Math.PI/2+i*Math.PI/5,rr:Number=i%2?r*.43:r;if(i==0)g.moveTo(x+Math.cos(a)*rr,y+Math.sin(a)*rr);else g.lineTo(x+Math.cos(a)*rr,y+Math.sin(a)*rr);}g.endFill();g.lineStyle();
        }
        private static function heart(g:Graphics,x:Number,y:Number,w:Number,h:Number,color:uint,outline:uint=0):void {
            g.lineStyle(outline?1.8:0,outline);g.beginFill(color);g.moveTo(x,y+h*.45);
            g.curveTo(x-w*.8,y-h*.15,x-w*.42,y-h*.45);g.curveTo(x-w*.14,y-h*.68,x,y-h*.25);
            g.curveTo(x+w*.14,y-h*.68,x+w*.42,y-h*.45);g.curveTo(x+w*.8,y-h*.15,x,y+h*.45);g.endFill();g.lineStyle();
        }
        private static function lightning(g:Graphics,x:Number,y:Number,size:Number,color:uint):void {
            g.lineStyle(1.5,0x5e2525);g.beginFill(color);g.moveTo(x+size*.18,y-size);g.lineTo(x-size*.54,y+size*.12);g.lineTo(x-size*.08,y+size*.12);g.lineTo(x-size*.25,y+size);g.lineTo(x+size*.63,y-size*.25);g.lineTo(x+size*.12,y-size*.25);g.endFill();g.lineStyle();
        }
        private static function shell(g:Graphics,color:uint,rear:Boolean):void {
            g.lineStyle(2.8,0x111719);var m:Matrix=new Matrix();m.createGradientBox(114,100,Math.PI/2,-57,rear?-91:-116);
            g.beginGradientFill(GradientType.LINEAR,[VisualProfile.lighter(color,.35),color,VisualProfile.darker(color,.28)],[1,1,1],[0,120,255],m);
            if(rear){g.moveTo(-54,-18);g.curveTo(-65,-51,-44,-76);g.curveTo(-23,-96,10,-90);g.curveTo(49,-85,54,-55);g.curveTo(61,-21,39,5);g.curveTo(9,31,-29,18);g.curveTo(-50,10,-54,-18);}
            else {g.moveTo(-54,-46);g.curveTo(-52,-114,0,-116);g.curveTo(53,-113,54,-44);g.lineTo(35,-55);g.curveTo(0,-69,-35,-54);g.lineTo(-54,-46);}g.endFill();g.lineStyle();
        }
        public static function helmet(name:String,rear:Boolean=false):Sprite {
            var n:int=family(name,HELMETS);if(n<0)return null;
            var layer:Sprite=new Sprite(),surface:Sprite=new Sprite(),clip:Shape=new Shape(),detail:Sprite=new Sprite();
            layer.name=rear?"classic-helmet-rear":"classic-helmet-front";layer.mouseEnabled=layer.mouseChildren=false;
            shell(surface.graphics,SHELLS[n],rear);layer.addChild(surface);shell(clip.graphics,0xffffff,rear);layer.addChild(clip);layer.addChild(detail);detail.mask=clip;
            var g:Graphics=detail.graphics,cy:Number=rear?-58:-88;
            if(n==1)lightning(g,8,cy,27,0xffe8d3);
            else if(n==2){heart(g,-19,cy+5,34,39,0xb7f4fa,0x248eb8);heart(g,21,cy-8,24,29,0xb7f4fa,0x248eb8);}
            else if(n==3){star(g,-16,cy-7,18,0xfce939);star(g,18,cy+10,11,0xffe83a);star(g,-34,cy+16,7,0xffe83a);}
            else if(n>=4){star(g,1,cy,29,n==4?0xfff5ec:n==7?0x99e1dc:0xf6d88b,0x3e496b);star(g,1,cy,18,SHELLS[n]);}
            else star(g,0,cy,31,0xffdf77,0xb89a4c);
            // Gloss, rim, stitching and ear guard remain above the printed motif.
            g=surface.graphics;g.lineStyle(1,0xffffff,.32);g.moveTo(-38,rear?-64:-84);g.curveTo(0,rear?-80:-108,36,rear?-64:-85);g.lineStyle();
            var finish:Shape=new Shape();g=finish.graphics;layer.addChild(finish);
            if(rear){g.lineStyle(2.8,0x111719);g.beginFill(VisualProfile.darker(SHELLS[n],.3));g.drawEllipse(25,-26,27,43);g.endFill();g.beginFill(0x18202b);g.drawEllipse(32,-18,12,26);g.endFill();}
            else {g.lineStyle(2.2,0x111719);g.beginFill(VisualProfile.darker(SHELLS[n],.28));g.moveTo(-54,-47);g.curveTo(-7,-66,54,-45);g.lineTo(63,-38);g.curveTo(5,-48,-54,-40);g.lineTo(-54,-47);g.endFill();}
            g.lineStyle();g.beginFill(0xffffff,.48);g.drawEllipse(-34,rear?-81:-105,24,7);g.endFill();
            layer.y=rear?-20:-39;layer.scaleY=.94;if(rear)layer.scaleX=1.06;return layer;
        }
        public static function drawGoggles(g:Graphics,name:String,color:uint):Boolean {
            var n:int=family(name,GOGGLES);if(n<0)return false;
            g.lineStyle(3,0x14232b);g.moveTo(-48,-43);g.lineTo(-37,-39);g.moveTo(48,-43);g.lineTo(37,-39);
            if(n==1||n==2){heart(g,-22,-38,29,28,0xe6faff,0x19252d);heart(g,22,-38,29,28,0xe6faff,0x19252d);heart(g,-22,-38,25,24,n==2?0xe7a5b9:0x88d7ef,color);heart(g,22,-38,25,24,n==2?0xe7a5b9:0x88d7ef,color);}
            else {
                g.lineStyle(3.5,0x14232b);g.beginFill(n==3?0x424b53:0xbcf2ff,n==3?.6:.22);
                g.drawRoundRect(-39,-54,35,28,n==7?4:11);g.drawRoundRect(4,-54,35,28,n==7?4:11);g.endFill();
                g.lineStyle(2.2,color);g.drawRoundRect(-39,-54,35,28,9);g.drawRoundRect(4,-54,35,28,9);
                if(n==4||n==5){lightning(g,-27,-40,9,n==4?0xff615d:0xffe784);lightning(g,21,-40,9,n==4?0xff615d:0xffe784);}
                if(n==0){star(g,-23,-40,7,0xffe98b);star(g,22,-40,7,0xffe98b);}
                if(n==6){g.lineStyle(3,0x678756);g.moveTo(-32,-52);g.lineTo(-22,-48);g.moveTo(8,-29);g.lineTo(21,-32);g.moveTo(31,-49);g.lineTo(36,-42);}
                if(n==7){g.lineStyle(1,0x3d4348);for(var i:int=0;i<3;i++){g.moveTo(-37+i*9,-52);g.lineTo(-8,-28+i*7);g.moveTo(8+i*9,-52);g.lineTo(36,-28+i*7);}}
            }
            g.lineStyle(2.5,color);g.moveTo(-5,-41);g.curveTo(0,-45,5,-41);g.lineStyle(1.6,0xffffff,.75);g.moveTo(-31,-48);g.lineTo(-24,-45);g.moveTo(13,-48);g.lineTo(20,-45);g.lineStyle();return true;
        }
        public static function shoePaint(name:String,x:Number,y:Number,color:uint,known:Boolean=false):uint {
            if(!known&&!hasShoes(name))return color;
            var lace:Number=(y-.80)*42;
            if(y>.80&&y<.94&&int(lace)%2==0)return 0xe9edf1;
            if(y>.96)return 0xddd9d1;
            if(name.indexOf("Red Lightning")==0)return int(x*25+y*18)%6==0?0xf4cf6e:0x922b36;
            if(name.indexOf("Green Star")==0)return int(x*30+y*21)%9==0?0xf7e679:0x294b24;
            if(name.indexOf("Sky Love")==0)return int(x*22+y*16)%8==0?0xc0edf0:0x266477;
            return color;
        }
        public static function glovePaint(name:String,x:Number,y:Number,color:uint):uint {
            var n:int=family(name,GLOVES);if(n<0)return color;
            if(n==5)return (int(x/6)+int(y/5))%3==0?0x394535:0x8b9b68;
            if(n==7)return int(x/8)%3==0?0x242a31:0xe9e6d9;
            if(n==1)return (int(x/8)+int(y/8))%4==0?0x33333b:color;
            if(n==3)return int((x+y)/10)%4==0?0xeff6a5:color;
            return int(y/5)%5==0?0xf1ece0:color;
        }
        public static function batPaint(name:String,along:Number,across:Number,length:Number,color:uint):uint {
            var t:Number=along/Math.max(1,length);
            if(t<.20)return int(along/4)%2==0?0x202e35:0xd6e5e6;
            if(name.indexOf("Breaker ")==0)return t>.42&&t<.57?0xe8d278:int((along+across*.8)/12)%8==0?0xe8d278:color;
            if(name.indexOf("Red Lightning")==0)return Math.abs(across+along*.12)%14<3?0xffc76b:color;
            if(name.indexOf("Black Bomber")==0)return t>.40&&t<.62?0xe5bd67:0x30373c;
            if(name.indexOf("Green Star")==0)return int(along/10)%5==0&&Math.abs(across)<6?0xf9e46b:color;
            return int(along/13)%4==0?0xadeaf2:color;
        }
    }
}
