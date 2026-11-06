package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    /** One saved face in the creator, HOME, portraits and every batting pose.
     * Illustrated hair is generated reconstruction, never claimed as recovered art. */
    public class BatterHead086 extends Sprite {
        [Embed(source="../../../../assets/sprites/v083/hair-atlas.png")] private static const Sheet:Class;
        private static var source:BitmapData,cache:Object={},order:Array=[];
        private static const BOXES:Array=[[47,79,397,382],[503,98,346,350],[916,43,394,429],[1385,107,334,356],[78,539,326,261],[512,522,315,311],[882,493,444,334],[1364,528,361,305]];
        private static const WIDTHS:Array=[104,98,110,98,92,95,114,104];
        private static const TOPS:Array=[-111,-105,-130,-110,-108,-106,-122,-108];
        public static const SHAPE_NAMES:Array=["Chubby","Double Chin","Edgy","Flat Chin","Round","Sharp","Slim","Triangular"];
        private var face:Sprite=new Sprite(),features:Sprite=new Sprite(),gear:Sprite=new Sprite(),rear:Sprite=new Sprite(),wig:Bitmap;
        private var a:Object,p:Object,trait:String,expression:int=-1;
        private const INK:uint=0x111719;
        public function BatterHead086(appearance:Object,palette:Object,trait:String="",protectedHead:Boolean=false) {
            a=appearance;p=palette;this.trait=trait;mouseEnabled=mouseChildren=false;
            // The origin is the jaw/nape attachment, not the end of a second neck.
            // The illustrated body already owns the skin between jaw and collar.
            addChild(face);face.scaleX=1;face.scaleY=.94;face.y=-39;
            drawSkin();face.addChild(features);drawFeatures(0);
            var style:int=Math.abs(int(a.hair))%8;
            if(trait!="SHAPE"){
                wig=new Bitmap(hairPixels(style,uint(p.hair)),"auto",true);wig.scaleX=wig.scaleY=WIDTHS[style]/BOXES[style][2];
                wig.x=-WIDTHS[style]/2;wig.y=TOPS[style]+10;face.addChild(wig);
            }
            face.addChild(gear);if(protectedHead)drawGear();
            rear.scaleX=1.06;rear.scaleY=.94;rear.y=-20;addChild(rear);drawRear();rear.visible=false;
        }
        public function setRear(value:Boolean):void {face.visible=!value;rear.visible=value;}
        public function identity():String {return JSON.stringify({shape:int(a.shape),hair:int(a.hair),eyes:int(a.eyes),nose:int(a.nose),mouth:int(a.mouth),skinColor:int(a.skinColor),hairColor:int(a.hairColor),eyeColor:int(a.eyeColor)});}
        private function drawRear():void {
            var g:Graphics=rear.graphics,c:uint=uint(p.helmet);g.lineStyle(2.8,INK,1,true);g.beginFill(p.skin);
            g.moveTo(24,-24);g.lineTo(45,-14);g.lineTo(46,-1);g.lineTo(53,4);g.lineTo(46,10);g.lineTo(44,19);g.curveTo(30,30,17,26);g.lineTo(16,15);g.endFill();
            g.beginFill(p.hair);g.moveTo(25,-15);g.lineTo(42,-18);g.lineTo(45,1);g.lineTo(34,-4);g.lineTo(30,14);g.lineTo(22,8);g.endFill();
            g.beginFill(c);g.moveTo(-54,-18);g.curveTo(-65,-51,-44,-76);g.curveTo(-23,-96,10,-90);g.curveTo(49,-85,54,-55);g.curveTo(61,-21,39,5);g.curveTo(9,31,-29,18);g.curveTo(-50,10,-54,-18);g.endFill();
            g.beginFill(VisualProfile.darker(c,.18));g.drawEllipse(25,-26,27,43);g.endFill();g.beginFill(0x121b22);g.drawEllipse(32,-18,12,26);g.endFill();
            g.lineStyle();g.beginFill(0xffffff,.85);g.drawEllipse(-31,-78,28,9);g.endFill();
            g.lineStyle(2,INK);g.moveTo(46,18);g.lineTo(40,19);g.lineStyle();
        }
        public function setExpression(value:int):void {if(value==expression)return;expression=value;drawFeatures(value);}
        private function drawSkin():void {
            var g:Graphics=face.graphics,shape:int=Math.abs(int(a.shape))%8;
            // Reconstructed from the eight bald SHAPE previews in the supplied
            // original screenshot. Keep the round crown and short chin; hair
            // covers the crown in the live actor without changing the jaw.
            var widths:Array=[44,45,44,45,44,45,42,45];
            var wide:Number=widths[shape];
            g.lineStyle(2.8,INK,1,true);g.beginFill(p.skin);
            g.drawEllipse(-wide-10,-22,15,29);g.drawEllipse(wide-5,-22,15,29);g.endFill();
            g.beginFill(p.skin);g.moveTo(0,-94);
            g.curveTo(wide*.414,-94,wide*.707,-79.65);g.curveTo(wide,-65.30,wide,-45);
            g.curveTo(wide+2,-19,wide,5);
            if(shape==0){ // Chubby: full, continuous cheeks.
                g.curveTo(wide,28,25,38);g.curveTo(0,47,-25,38);g.curveTo(-wide,28,-wide,5);
            }else if(shape==1){ // Double Chin: broader lower cheeks and a shallow chin crease.
                g.curveTo(wide,29,27,39);g.curveTo(14,45,0,42);g.curveTo(-14,45,-27,39);g.curveTo(-wide,29,-wide,5);
            }else if(shape==2){ // Edgy: small corners at the base of the jaw.
                g.lineTo(40,27);g.lineTo(24,37);g.lineTo(10,41);g.lineTo(-10,41);g.lineTo(-24,37);g.lineTo(-40,27);g.lineTo(-wide,5);
            }else if(shape==3){ // Flat Chin: round sides, horizontal center.
                g.curveTo(43,27,19,41);g.lineTo(-19,41);g.curveTo(-43,27,-wide,5);
            }else if(shape==4){ // Round: smooth oval with a rounded chin.
                g.curveTo(43,28,22,39);g.curveTo(0,48,-22,39);g.curveTo(-43,28,-wide,5);
            }else if(shape==5){ // Sharp: tapered lower face.
                g.curveTo(42,24,26,35);g.curveTo(9,46,0,45);g.curveTo(-9,46,-26,35);g.curveTo(-42,24,-wide,5);
            }else if(shape==6){ // Slim: narrower cheek and jaw silhouette.
                g.lineTo(36,22);g.lineTo(24,35);g.curveTo(8,44,0,44);g.curveTo(-8,44,-24,35);g.lineTo(-36,22);g.lineTo(-wide,5);
            }else{ // Triangular: broad temples flowing into a narrow, soft chin.
                g.lineTo(39,23);g.curveTo(27,36,12,41);g.curveTo(0,45,-12,41);g.curveTo(-27,36,-39,23);g.lineTo(-wide,5);
            }
            g.curveTo(-wide-2,-19,-wide,-45);g.curveTo(-wide,-65.30,-wide*.707,-79.65);g.curveTo(-wide*.414,-94,0,-94);g.endFill();
            g.lineStyle(1.4,VisualProfile.darker(p.skin,.27));g.moveTo(-wide-5,-14);g.curveTo(-wide+1,-13,-wide,-4);g.moveTo(wide+5,-14);g.curveTo(wide-1,-13,wide,-4);g.lineStyle();
        }
        private function drawFeatures(state:int):void {
            var g:Graphics=features.graphics;g.clear();if(trait=="HAIR"||trait=="SHAPE")return;
            drawEyes(g,Math.abs(int(a.eyes))%8,state);
            drawNose(g,Math.abs(int(a.nose))%8);
            drawMouth(g,Math.abs(int(a.mouth))%8,state);
        }
        private function drawEyes(g:Graphics,style:int,state:int):void {
            var widths:Array=[12,13,12,12.5,12,11.5,13.5,13.5];
            var bottoms:Array=[14,18,12,12,8,10,19,16];
            var tilts:Array=[3,-1,0,6,1,5,0,-2];
            var crowns:Array=[-17,-20,-15,-15,-8,-13,-22,-19];
            var browColor:uint=VisualProfile.darker(uint(p.hair),.42);
            if(Math.max((browColor>>16)&255,(browColor>>8)&255,browColor&255)>115)browColor=0x493328;
            for(var side:int=-1;side<=1;side+=2){
                var cx:Number=side*23,w:Number=widths[style],bottom:Number=bottoms[style],tilt:Number=tilts[style];
                if(state==1||state==3){
                    g.lineStyle(2.8,INK,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
                    g.moveTo(cx-w,2);g.curveTo(cx,state==3?-9:9,cx+w,2);
                }else{
                    if(state==2){bottom*=.86;tilt*=.45;}
                    var left:Number=-8+side*tilt,right:Number=-8-side*tilt,crown:Number=crowns[style];
                    g.lineStyle(2.2,INK,1,true);g.beginFill(0xfffdf5);
                    g.moveTo(cx-w,left);g.curveTo(cx,crown,cx+w,right);
                    g.curveTo(cx+w+1,bottom,cx,bottom);g.curveTo(cx-w-1,bottom,cx-w,left);g.endFill();
                    // Large colored iris surrounding a real black pupil. The
                    // upper lid is drawn over it, avoiding a per-eye raster mask.
                    var irisY:Number=(bottom-8)/2,irisH:Number=(bottom+8)*.88,irisW:Number=style==6||style==1?15:14;
                    g.lineStyle(1.5,INK);g.beginFill(uint(p.eye));g.drawEllipse(cx-irisW/2,irisY-irisH/2,irisW,irisH);g.endFill();
                    g.lineStyle();g.beginFill(0x111719);g.drawEllipse(cx-4.6,irisY-irisH*.38,9.2,irisH*.76);g.endFill();
                    g.beginFill(0xffffff);g.drawEllipse(cx-3.3,irisY-irisH*.32,3.5,4.2);g.drawCircle(cx+2.8,irisY+irisH*.23,.9);g.endFill();
                    g.beginFill(p.skin);g.moveTo(cx-w-1,-28);g.lineTo(cx+w+1,-28);g.lineTo(cx+w+1,right);
                    g.curveTo(cx,crown,cx-w-1,left);g.lineTo(cx-w-1,-28);g.endFill();
                    g.lineStyle(2.7,INK,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
                    g.moveTo(cx-w,left);g.curveTo(cx,crown,cx+w,right);
                }
                var outer:Number=-24-tilt*.5,inner:Number=-24+tilt*.8;
                if(state==2){outer=-20;inner=-29;}else if(state==3){outer=-25;inner=-28;}
                var thickness:Number=style==1||style==6?5.8:style==3?5.3:4.6;
                g.lineStyle(thickness,browColor,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
                g.moveTo(cx-side*10,inner);g.curveTo(cx,-28-(state==3?3:0),cx+side*10,outer);
            }g.lineStyle();
        }
        private function drawNose(g:Graphics,style:int):void {
            var shade:uint=VisualProfile.darker(p.skin,.34),light:uint=VisualProfile.lighter(p.skin,.10);
            g.lineStyle(1.3,shade,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            if(style==0){g.moveTo(1,5);g.lineTo(-2,11);g.curveTo(1,12,4,10);}
            else if(style==1){g.moveTo(0,3);g.lineTo(0,11);g.curveTo(3,13,6,10);}
            else if(style==2){g.beginFill(light);g.drawEllipse(-5,6,10,7);g.endFill();}
            else if(style==3){g.beginFill(shade);g.moveTo(1,3);g.lineTo(-4,11);g.lineTo(6,11);g.lineTo(1,3);g.endFill();}
            else if(style==4){g.moveTo(-6,9);g.curveTo(0,15,6,9);g.moveTo(-4,11);g.lineTo(-2,11);g.moveTo(2,11);g.lineTo(4,11);}
            else if(style==5){g.moveTo(0,1);g.curveTo(-1,7,-4,13);g.curveTo(1,15,6,12);}
            else if(style==6){g.moveTo(-4,6);g.curveTo(-8,11,-5,12);g.curveTo(0,15,5,12);g.curveTo(8,11,4,6);}
            else{g.beginFill(light);g.drawEllipse(-3.5,7,7,6);g.endFill();}
            g.lineStyle();
        }
        private function drawMouth(g:Graphics,style:int,state:int):void {
            var ink:uint=VisualProfile.darker(p.skin,.62);
            if(state==2)style=4;else if(state==3)style=5;
            g.lineStyle(1.7,ink,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            if(style==0){g.moveTo(-11,25);g.curveTo(0,29,12,22);}
            else if(style==1){g.moveTo(-11,24);g.curveTo(0,33,11,24);}
            else if(style==2){g.moveTo(-8,26);g.curveTo(0,25,8,26);}
            else if(style==3){
                g.beginFill(0xfffdf5);g.moveTo(-13,23);g.curveTo(0,27,13,23);g.curveTo(9,34,0,34);g.curveTo(-9,34,-13,23);g.endFill();
            }else if(style==4){g.moveTo(-10,29);g.curveTo(0,22,10,29);}
            else if(style==5||style==7){
                var wide:Number=style==7?13:12,low:Number=style==7?37:36;
                g.beginFill(0x8c3029);g.moveTo(-wide,23);g.curveTo(0,26,wide,23);g.curveTo(wide-2,low,0,low);g.curveTo(-wide+2,low,-wide,23);g.endFill();
                g.lineStyle();g.beginFill(0xf1a09b);g.moveTo(-5,low-2);g.curveTo(0,low-7,5,low-2);g.curveTo(0,low+1,-5,low-2);g.endFill();
                g.beginFill(0xfffdf5);g.moveTo(-wide+2,24);g.curveTo(0,27,wide-2,24);g.lineTo(wide-4,27);g.curveTo(0,29,-wide+4,27);g.lineTo(-wide+2,24);g.endFill();
            }else{g.moveTo(-9,25);g.curveTo(0,30,10,25);}
            g.lineStyle();
        }
        private function drawGear():void {
            var g:Graphics=gear.graphics,c:uint=uint(p.helmet);g.lineStyle(2.8,INK,1,true);g.beginFill(c);
            g.moveTo(-54,-46);g.curveTo(-52,-114,0,-116);g.curveTo(53,-113,54,-44);g.lineTo(35,-55);g.curveTo(0,-69,-35,-54);g.lineTo(-54,-46);g.endFill();
            g.beginFill(VisualProfile.darker(c,.22));g.moveTo(-54,-47);g.curveTo(-7,-66,54,-45);g.lineTo(63,-38);g.curveTo(5,-48,-54,-40);g.lineTo(-54,-47);g.endFill();
            g.lineStyle();g.beginFill(0xffffff,.7);g.drawEllipse(-34,-98,25,8);g.endFill();
            if(p.goggles){g.lineStyle(3.4,uint(p.goggles));g.beginFill(0xe1f5ff,.08);g.drawRoundRect(-38,-15,33,32,9);g.drawRoundRect(5,-15,33,32,9);g.endFill();g.moveTo(-5,-1);g.lineTo(5,-1);}g.lineStyle();
        }
        private static function hairPixels(style:int,color:uint):BitmapData {
            if(!source)source=Bitmap(new Sheet()).bitmapData;var key:String=style+":"+color;if(cache[key])return cache[key];
            var r:Array=BOXES[style],b:BitmapData=new BitmapData(r[2],r[3],true,0);b.copyPixels(source,new Rectangle(r[0],r[1],r[2],r[3]),new Point());b.lock();
            for(var y:int=0;y<b.height;y++)for(var x:int=0;x<b.width;x++){var q:uint=b.getPixel32(x,y),rr:int=(q>>16)&255,gg:int=(q>>8)&255,bb:int=q&255;
                if((q>>>24)<16||Math.max(rr,gg,bb)<38)continue;
                var shade:Number=(.299*rr+.587*gg+.114*bb)-83;
                var nr:int=Math.max(0,Math.min(255,((color>>16)&255)+shade)),ng:int=Math.max(0,Math.min(255,((color>>8)&255)+shade)),nb:int=Math.max(0,Math.min(255,(color&255)+shade));b.setPixel32(x,y,(q&0xff000000)|(nr<<16)|(ng<<8)|nb);
            }b.unlock();cache[key]=b;order.push(key);
            // Cached bitmaps can be shared by living heads. Eviction releases the
            // cache reference; the runtime frees each texture after its last head.
            while(order.length>24)delete cache[order.shift()];return b;
        }
        public function dispose():void {if(wig)wig.bitmapData=null;}
    }
}
