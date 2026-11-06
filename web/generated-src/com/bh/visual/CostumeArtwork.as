package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    /** Wearable layers and cloth materials; the approved face renderer is untouched. */
    public class CostumeArtwork extends Sprite {
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/equipment092/sheet.png")] private static const Sheet:Class;
        private static var source:BitmapData,helmets:Object={};
        private static const HEADS:Array=[[40,284,125,82],[262,285,117,81],[477,285,120,83],[695,284,115,85],[41,591,127,127],[262,628,117,91],[477,628,122,91],[695,626,119,91],[29,949,146,110],[262,965,118,94],[477,963,120,97],[695,962,117,96]];
        public static const COLORS:Array=[0x292d32,0x1b212a,0x20242b,0x0873af,0x539713,0xf4eee2,0x175d94,0xe6dfca,0xb5262d,0x362b22,0xb91e29,0x125ab8];
        private var classicFront:Sprite,classicRear:Sprite;
        private var cap:Bitmap,eyes:Sprite=new Sprite(),rear:Sprite=new Sprite(),p:Object,dead:Boolean=false,showHelmet:Boolean=true;
        public function CostumeArtwork(palette:Object,headwear:Boolean=true) {
            showHelmet=headwear;
            p=palette;mouseEnabled=mouseChildren=false;name="wearable-accessories";
            if(showHelmet&&int(p.costume)>=0){
                var n:int=int(p.costume),r:Array=HEADS[n];
                if(!source)source=Bitmap(new Sheet()).bitmapData;
                if(!helmets[n]){var pixels:BitmapData=new BitmapData(r[2],r[3],true,0);pixels.copyPixels(source,new Rectangle(r[0],r[1],r[2],r[3]),new Point());helmets[n]=pixels;}
                cap=new Bitmap(helmets[n],"auto",true);cap.width=126;cap.scaleY=cap.scaleX;cap.x=-63;cap.y=-49-cap.height;addChild(cap);
                // The rear uses the same material and markings on the existing helmet silhouette.
                var g:Graphics=rear.graphics;g.lineStyle(2,0x141b22);g.beginFill(uint(p.helmet));g.drawEllipse(-53,-108,102,83);g.endFill();
                g.lineStyle(3,n==1?0x2a2422:n>=9?0xead38d:0xd8e3e4,.8);
                for(var i:int=0;i<3;i++){g.moveTo(-37+i*23,-94);g.curveTo(-50+i*28,-64,-32+i*23,-39);}
                if(n==4||n==8){g.lineStyle(3,0x293c1b);g.moveTo(0,-106);g.lineTo(4,-120);}
                if(n==1){g.lineStyle(6,0x20212a);g.moveTo(-35,-80);g.lineTo(-17,-66);g.moveTo(34,-80);g.lineTo(17,-66);}
                if(n==5){g.lineStyle(3,0x37414a);g.drawCircle(0,-72,18);g.moveTo(-9,-63);g.lineTo(9,-63);}
                if(n==11){g.lineStyle(3,0x143056);g.moveTo(-31,-95);g.lineTo(-12,-62);g.lineTo(12,-62);g.lineTo(31,-95);}
                g.lineStyle();addChild(rear);
            }
            classicFront=showHelmet?ClassicWearables.helmet(String(p.helmetName)):null;classicRear=showHelmet?ClassicWearables.helmet(String(p.helmetName),true):null;
            if(classicFront){addChild(classicFront);addChild(classicRear);}
            addChild(eyes);drawEyes();setRear(false);
        }
        private function drawEyes():void {
            if(!p.goggles)return;var g:Graphics=eyes.graphics,c:uint=uint(p.goggles),n:int=int(p.goggleTheme);
            if(ClassicWearables.drawGoggles(g,String(p.gogglesName),c))return;
            g.lineStyle(3.5,0x111b23);g.beginFill(n==0?0x172127:0xbcecf4,n==0?.72:.23);
            g.drawRoundRect(-38,-52,34,25,7);g.drawRoundRect(4,-52,34,25,7);g.endFill();
            g.lineStyle(2,c);g.drawRoundRect(-38,-52,34,25,7);g.drawRoundRect(4,-52,34,25,7);g.moveTo(-4,-42);g.lineTo(4,-42);
            g.moveTo(-39,-44);g.lineTo(-47,-48);g.moveTo(39,-44);g.lineTo(47,-48);
            if(n>=9){g.lineStyle(2,0xffe679);g.moveTo(-30,-47);g.lineTo(-18,-47);g.moveTo(12,-47);g.lineTo(25,-47);}g.lineStyle();
        }
        public function attach(head:DisplayObjectContainer):void {
            // Helmets cover hair; the approved head source and saved face stay intact.
            if(showHelmet&&(int(p.costume)>=0||classicFront)&&head.numChildren){var face:DisplayObjectContainer=head.getChildAt(0) as DisplayObjectContainer;if(face&&!(face is HeroAvatarArtwork))for(var i:int=0;i<face.numChildren;i++)if(face.getChildAt(i) is Bitmap)face.getChildAt(i).visible=false;}
            head.addChild(this);
            if(head is HeroHead&&int(p.costume)<0)HeroHead(head).attachEyewear(eyes);
        }
        public function setRear(value:Boolean):void {if(classicFront){classicFront.visible=!value;classicRear.visible=value;}if(cap)cap.visible=!value;rear.visible=value;eyes.visible=!value&&Boolean(p.goggles);}
        public static function theme(item:Object):int {if(!item||!item.name)return -1;for(var i:int=0;i<GearPieceArtwork.THEMES.length;i++)if(String(item.name).indexOf("COLLECTOR "+GearPieceArtwork.THEMES[i]+" ")==0)return i;return -1;}
        /** Cloth pattern stays inside each illustrated pose's original material mask. */
        public static function cloth(n:int,x:Number,y:Number,color:uint):uint {
            if(n<0)return color;
            if(n==0)return Math.abs(x)<.09?0xc7c6bd:color;
            if(n==1)return (int((x+.6)*19+y*12)%7==0)?0xe4ab30:color;
            if(n==2)return y>.38&&y<.48?0xe9bd24:color;
            if(n==3)return Math.abs(x)<.05?0xe8f7ef:color;
            if(n==4)return Math.abs(x)<.06?0xc5e52b:color;
            if(n==5)return Math.abs(x)<.05?0x3b3430:color;
            if(n==6)return Math.abs(x)<.06?0x2c233b:color;
            if(n==7)return int(y*32+x*5)%5==0?0x897f69:color;
            if(n==8)return Math.abs(x)<.08||y<.07?0xf7f0d7:color;
            if(n==9)return Math.abs(x)<.06?0xcda961:color;
            if(n>=10)return y>.15&&y<.19||Math.abs(x)<.035?0xffd455:color;
            return color;
        }
        public static function batPaint(n:int,x:int,y:int,color:uint):uint {
            if(n<0)return color;
            var stripe:Boolean=int((x+y*.7)/11)%5==0;
            if(n==0)return stripe?0xbfcbd1:0x242931;
            if(n==1)return stripe?0x25252b:0xf3a32b;
            if(n==2)return stripe?0xf4d14b:0x242931;
            if(n==3)return stripe?0xe8ffff:0x36bce6;
            if(n==4)return stripe?0x2b3431:0xf38c1e;
            if(n==5||n==7)return stripe?0x393b3b:0xe8dfc4;
            if(n==6)return stripe?0xb3e038:0x216e9b;
            if(n==8)return stripe?0x59b643:0xc62b35;
            if(n==9)return stripe?0xe4bd59:0x886235;
            if(n==10)return stripe?0xffd655:0xd42c39;
            return stripe?0xdd3a46:0x2577d7;
        }
        public function dispose():void {if(dead)return;dead=true;if(cap)cap.bitmapData=null;}
    }
}
