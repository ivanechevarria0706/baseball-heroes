package com.bh.visual {
    import flash.display.*;import flash.geom.*;import com.bh.model.GameData;
    /** One saved face in the creator, HOME, portraits and every batting pose.
     * Illustrated hair is generated reconstruction, never claimed as recovered art. */
    public class HeroHead extends Sprite {
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v083/hair-atlas.png")] private static const Sheet:Class;
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v099/volume-hair.png")] private static const VolumeSheet:Class;
        private static var volumeSource:BitmapData;
        private static var source:BitmapData,cache:Object={},order:Array=[];
        private static const BOXES:Array=[[47,79,397,382],[503,98,346,350],[916,43,394,429],[1385,107,334,356],[78,539,326,261],[512,522,315,311],[882,493,444,334],[1364,528,361,305]];
        private static const WIDTHS:Array=[104,98,110,98,92,95,114,104];
        private static const TOPS:Array=[-111,-105,-130,-110,-108,-106,-122,-108];
        // Use the same temple measurements for the skin and the illustrated wig.
        // Hair keeps its own silhouette while its roots follow the selected skull.
        private static const TEMPLE_WIDTHS:Array=[44,45,44,45,44,45,42,45];
        private static const ROOT_WIDTHS:Array=[1.08,1.07,1.04,1.07,1.04,1.06,1.10,1.06];
        private static const ROOT_Y:Array=[-2,-2,-1,-1,-1,-2,1,-1];
        // Long fringes fall toward the brow while the crown stays rooted.
        // Crew Cut, braids and swept-back hair deliberately leave the forehead open.
        private static const FRINGE_HEIGHTS:Array=[1.22,1.18,1,1,1,1,1.20,1.24];
        public static const SHAPE_NAMES:Array=["Chubby","Double Chin","Edgy","Flat Chin","Round","Sharp","Slim","Triangular"];
        private var avatarRear:RearHeroArtwork;private var avatar:HeroAvatarArtwork;private var eyewear:Sprite,gearLogo:TeamLogoView;
        private var face:Sprite=new Sprite(),features:Sprite=new Sprite(),gear:Sprite=new Sprite(),rear:Sprite=new Sprite(),wig:Bitmap;
        private var a:Object,p:Object,trait:String,expression:int=-1;
        private var turned:Sprite=new Sprite(),views:Object={},activeView:Sprite,angle:int=0,protectedHead:Boolean;
        private const INK:uint=0x111719;
        public function HeroHead(appearance:Object,palette:Object,trait:String="",protectedHead:Boolean=false) {
            a=appearance;p=palette;this.trait=trait;this.protectedHead=protectedHead;mouseEnabled=mouseChildren=false;
            if(a&&int(a.artVersion)>=1){avatar=new HeroAvatarArtwork(a,p);addChild(avatar);if(protectedHead){var capClip:Shape=new Shape();capClip.graphics.beginFill(0);capClip.graphics.drawRect(-200,-100,400,210);capClip.graphics.endFill();addChild(capClip);avatar.mask=capClip;addChild(gear);if(int(p.costume)<0&&ClassicWearables.family(String(p.helmetName),ClassicWearables.HELMETS)<0)drawAvatarGear();}return;}
            // The origin is the jaw/nape attachment, not the end of a second neck.
            // The illustrated body already owns the skin between jaw and collar.
            addChild(face);face.scaleX=1;face.scaleY=.94;face.y=-39;
            drawSkin();drawScalp();face.addChild(features);drawFeatures(0);
            var style:int=Math.abs(int(a.hair))%8;
            if(trait!="SHAPE"){
                wig=new Bitmap(hairPixels(style,uint(p.hair)),"auto",true);
                fitHair(wig,style,0);face.addChild(wig);
            }
            face.addChild(gear);if(protectedHead)drawGear();
            rear.scaleX=1.06;rear.scaleY=.94;rear.y=-20;addChild(rear);drawRear();rear.visible=false;
            turned.y=-39;turned.scaleY=.94;addChild(turned);turned.visible=false;
        }
        public function setRear(value:Boolean):void {setFacing(value?120:0);}
        public function get facing():int {return angle;}
        /** Thirteen reusable views; the saved appearance is never mutated. */
        public function setFacing(degrees:Number):void {
            var next:int=Math.max(0,Math.min(180,Math.round(degrees/15)*15));angle=next;
            if(avatar){
                var back:Boolean=protectedHead&&next>90;avatar.visible=!back;gear.visible=!back;
                if(back){if(!avatarRear){avatarRear=new RearHeroArtwork(p);addChild(avatarRear);}avatarRear.visible=true;avatarRear.setFacing(next);}
                else {if(avatarRear)avatarRear.visible=false;avatar.scaleX=1-.15*Math.min(1,next/90);avatar.x=next>0?4:0;}return;
            }
            face.visible=next==0;rear.visible=false;turned.visible=next!=0;
            if(next==0)return;
            var key:String=next+":"+Math.max(0,expression);
            if(!views[key]){views[key]=makeView(next,Math.max(0,expression));turned.addChild(views[key]);}
            if(activeView!=views[key]){if(activeView)activeView.visible=false;activeView=views[key];activeView.visible=true;}
        }
        public function warmFacing():void {if(avatar)return;var saved:int=angle,state:int=expression;for each(var mood:int in [0,2,3]){setExpression(mood);for(var n:int=15;n<=180;n+=15)setFacing(n);}setExpression(state);setFacing(saved);}
        public function identity():String {return JSON.stringify({artVersion:int(a.artVersion),avatarStyle:int(a.avatarStyle),gender:a.gender,shape:int(a.shape),hair:int(a.hair),eyes:int(a.eyes),nose:int(a.nose),mouth:int(a.mouth),skinColor:int(a.skinColor),hairColor:int(a.hairColor),eyeColor:int(a.eyeColor)});}
        /** Measured root fit; independent of color, expression and saved data. */
        public function hairPlacement(degrees:Number=0):Object {
            var style:int=Math.abs(int(a.hair))%8,shape:int=Math.abs(int(a.shape))%8;
            var t:Number=Math.max(0,Math.min(1,degrees/90));
            var skull:Number=Number(TEMPLE_WIDTHS[shape])/44;
            var width:Number=WIDTHS[style]*Number(ROOT_WIDTHS[style])*skull*(1-.43*t);
            // Scale height only slightly with skull width: retain tall quiffs and braids.
            var sy:Number=WIDTHS[style]/BOXES[style][2]*FRINGE_HEIGHTS[style]*(1+(skull-1)*.3);
            // Volume has a low round crown and a deep fringe, rather than a tall quiff.
            var pixelW:Number=style==2?400:BOXES[style][2];
            if(style==2)sy=142/392*(1+(skull-1)*.3);
            return {shape:shape,style:style,x:-width/2+12*t*skull,y:style==2?-110:TOPS[style]+10+ROOT_Y[style],scaleX:width/pixelW,scaleY:sy,width:width};
        }
        private function fitHair(hair:Bitmap,style:int,degrees:Number):void {
            var fit:Object=hairPlacement(degrees);
            hair.scaleX=fit.scaleX;hair.scaleY=fit.scaleY;hair.x=fit.x;hair.y=fit.y;
        }
        /** Glasses sit on the face; opaque bangs can cover their upper rim. */
        public function attachEyewear(layer:Sprite):void {
            if(avatar){eyewear=layer;addChild(layer);return;}
            eyewear=layer;layer.scaleY=1/face.scaleY;layer.y=-face.y/face.scaleY;
            face.addChildAt(layer,wig?face.getChildIndex(wig):face.numChildren);
        }
        private function drawScalp():void {
            if(trait=="SHAPE")return;
            var cap:Sprite=new Sprite(),g:Graphics=cap.graphics;
            var w:Number=Number(TEMPLE_WIDTHS[Math.abs(int(a.shape))%8]);
            var style:int=Math.abs(int(a.hair))%8;
            // Roots follow the exact crown path of the selected head. Short
            // styles expose the forehead; long styles keep covered temples.
            var temple:Number=[-24,-22,-18,-38,-55,-43,-32,-26][style];
            g.lineStyle(2.5,INK);g.beginFill(uint(p.hair));g.moveTo(-w,temple);
            g.lineTo(-w,-45);g.curveTo(-w,-65.30,-w*.707,-79.65);
            g.curveTo(-w*.414,-94,0,-94);g.curveTo(w*.414,-94,w*.707,-79.65);
            g.curveTo(w,-65.30,w,-45);g.lineTo(w,temple);
            g.lineTo(w-5,temple-7);g.lineTo(w-7,-54);
            g.curveTo(18,-71,0,-63);g.curveTo(-18,-71,-w+7,-54);
            g.lineTo(-w+5,temple-7);g.lineTo(-w,temple);g.endFill();
            face.addChild(cap);
        }

        private function drawRear():void {
            var g:Graphics=rear.graphics,c:uint=uint(p.helmet);g.lineStyle(2.8,INK,1,true);g.beginFill(p.skin);
            g.moveTo(24,-24);g.lineTo(45,-14);g.lineTo(46,-1);g.lineTo(53,4);g.lineTo(46,10);g.lineTo(44,19);g.curveTo(30,30,17,26);g.lineTo(16,15);g.endFill();
            g.beginFill(p.hair);g.moveTo(25,-15);g.lineTo(42,-18);g.lineTo(45,1);g.lineTo(34,-4);g.lineTo(30,14);g.lineTo(22,8);g.endFill();
            g.beginFill(c);g.moveTo(-54,-18);g.curveTo(-65,-51,-44,-76);g.curveTo(-23,-96,10,-90);g.curveTo(49,-85,54,-55);g.curveTo(61,-21,39,5);g.curveTo(9,31,-29,18);g.curveTo(-50,10,-54,-18);g.endFill();
            g.beginFill(VisualProfile.darker(c,.18));g.drawEllipse(25,-26,27,43);g.endFill();g.beginFill(0x121b22);g.drawEllipse(32,-18,12,26);g.endFill();
            g.lineStyle();g.beginFill(0xffffff,.85);g.drawEllipse(-31,-78,28,9);g.endFill();
            g.lineStyle(2,INK);g.moveTo(46,18);g.lineTo(40,19);g.lineStyle();
        }
        public function setExpression(value:int):void {if(avatar){expression=value;return;}if(value==expression)return;expression=value;drawFeatures(value);if(angle)setFacing(angle);}
        private function makeView(degrees:int,state:int):Sprite {
            var view:Sprite=new Sprite(),skin:Sprite=new Sprite();view.addChild(skin);var g:Graphics=skin.graphics;
            var t:Number=Math.min(1,degrees/90),back:Number=Math.max(0,(degrees-90)/90);
            view.y=12*back;
            var shape:int=Math.abs(int(a.shape))%8,w:Number=TEMPLE_WIDTHS[shape];
            var left:Number=-w*(1-.62*t),right:Number=w*(1-.04*t),chin:Number=t*14;
            var low:Number=shape==3?41:shape==5?45:44;
            // A turned cheek has its own outline and projecting nose. The
            // far eye/ear recede independently; this is not a flattened front.
            g.lineStyle(2.8,INK,1,true);g.beginFill(p.skin);
            if(back==0){
                g.drawEllipse(left-8,-22,14,28);g.endFill();g.beginFill(p.skin);
                g.moveTo(chin*.3,-94);g.curveTo(right,-94,right,-45);
                g.lineTo(right,-8);g.lineTo(right+Math.max(0,t-.35)*9,4);
                g.lineTo(right,11);g.curveTo(right,29,chin+16,low-5);
                if(shape==3){g.lineTo(chin+10,low);g.lineTo(chin-12,low);}
                else if(shape==2||shape==6){g.lineTo(chin+9,low);g.lineTo(chin-7,low);}
                else {g.curveTo(chin,low+4,chin-16,low-5);}
                g.curveTo(left,29,left,4);g.curveTo(left-2,-25,left,-46);g.curveTo(left,-91,chin*.3,-94);g.endFill();
            }else{
                g.moveTo(23,-35);g.lineTo(44,-25);g.lineTo(45,-6);g.lineTo(51,4);g.lineTo(45,10);g.lineTo(43,23-12*back);
                g.curveTo(35,42-12*back,-5,39-12*back);g.lineTo(-14,25-12*back);g.lineTo(23,-35);g.endFill();
            }
            var nearX:Number=-23+45*t+back*58,farX:Number=23+19*t;
            if(degrees<135){
                var near:Sprite=new Sprite();drawEyes(near.graphics,Math.abs(int(a.eyes))%8,state,-1,2.5*t);
                near.scaleX=(1-.16*t)*(1-back*1.7);near.x=nearX+23*near.scaleX;view.addChild(near);
                if(degrees<90){var far:Sprite=new Sprite();drawEyes(far.graphics,Math.abs(int(a.eyes))%8,state,1,2.5*t);far.scaleX=1-.78*t;far.x=farX-23*far.scaleX;view.addChild(far);}
                var nose:Sprite=new Sprite();drawNose(nose.graphics,Math.abs(int(a.nose))%8);nose.scaleX=1-.35*t;nose.x=46*t+back*10;view.addChild(nose);
                var mouth:Sprite=new Sprite();drawMouth(mouth.graphics,Math.abs(int(a.mouth))%8,state);mouth.scaleX=(1-.60*t)*(1-back);mouth.x=29*t+back*8;mouth.y=-8*back;view.addChild(mouth);
            }
            var style:int=Math.abs(int(a.hair))%8;
            if(degrees<=90){
                var hair:Bitmap=new Bitmap(hairPixels(style,uint(p.hair)),"auto",true);
                fitHair(hair,style,degrees);view.addChild(hair);
            }else{
                var nape:Sprite=new Sprite();var ng:Graphics=nape.graphics;ng.lineStyle(2,INK);ng.beginFill(p.hair);
                ng.moveTo(13,12);ng.lineTo(46,9);ng.lineTo(49,26-12*back);ng.lineTo(38,23-12*back);ng.lineTo(32,34-12*back+(style%3)*3);ng.lineTo(22,27-12*back);ng.lineTo(13,31-12*back);ng.lineTo(13,12);ng.endFill();view.addChildAt(nape,0);
            }
            if(protectedHead){var helmet:Sprite=new Sprite();view.addChild(helmet);drawTurnedHelmet(helmet.graphics,t,back);}
            return view;
        }
        private function drawTurnedHelmet(g:Graphics,t:Number,back:Number):void {
            var c:uint=uint(p.helmet),shade:uint=VisualProfile.darker(c,.23);
            var endX:Number=53-12*back,endY:Number=-46+50*back;
            g.lineStyle(2.8,INK,1,true);g.beginFill(c);
            g.moveTo(-54,-40);g.curveTo(-59,-88,-31,-106);g.curveTo(-5,-123,26,-113);
            g.curveTo(58,-103,56,-66);g.lineTo(endX,endY);
            if(back>0){g.curveTo(27,-40+53*back,-25,-40+45*back);g.curveTo(-54,-40+35*back,-54,-40);}
            else {g.curveTo(11,-65,-38,-48);g.lineTo(-54,-40);}
            g.endFill();
            if(back<.85){
                g.beginFill(shade);g.moveTo(-38+back*75,-49+back*27);g.curveTo(12+back*28,-63+back*20,53,-45+back*27);
                g.lineTo(69-back*10,-37+back*24);g.curveTo(30+back*25,-49+back*22,-38+back*75,-41+back*27);g.endFill();
            }
            var earX:Number=-49+38*t+51*back;
            g.beginFill(shade);g.drawEllipse(earX-13,-27,27,43);g.endFill();
            g.beginFill(0x121b22);g.drawEllipse(earX-6,-19,12,26);g.endFill();
            g.lineStyle();g.beginFill(0xffffff,.76);g.drawEllipse(-32+back*5,-101,25,8);g.endFill();
            if(p.goggles&&back==0){
                g.lineStyle(3.4,uint(p.goggles));g.beginFill(0xe1f5ff,.08);
                g.drawRoundRect(-40+45*t,-15,33*(1-.16*t),32,8);
                if(t<1)g.drawRoundRect(6+19*t,-15,33*(1-.78*t),32,8);g.endFill();
            }else if(p.goggles&&back>0&&back<.5){
                g.lineStyle(2.3,uint(p.goggles));g.beginFill(0xe1f5ff,.08);
                g.drawRoundRect(22+58*back-14*(1-back*1.7),-15,28*(1-back*1.7),29,6);g.endFill();
            }g.lineStyle();
        }
        private function drawSkin():void {
            var g:Graphics=face.graphics,shape:int=Math.abs(int(a.shape))%8;
            // Reconstructed from the eight bald SHAPE previews in the supplied
            // original screenshot. Keep the round crown and short chin; hair
            // covers the crown in the live actor without changing the jaw.
            var wide:Number=TEMPLE_WIDTHS[shape];
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
            while(features.numChildren)features.removeChildAt(0);
            features.addChild(new FaceDetails(int(a.etc)));
        }
        private function drawEyes(g:Graphics,style:int,state:int,eyeSide:int=0,look:Number=0):void {
            var widths:Array=[12,13,12,12.5,12,11.5,13.5,13.5];
            var bottoms:Array=[14,18,12,12,8,10,19,16];
            var tilts:Array=[3,-1,0,6,1,5,0,-2];
            var crowns:Array=[-17,-20,-15,-15,-8,-13,-22,-19];
            var browColor:uint=VisualProfile.darker(uint(p.hair),.42);
            if(Math.max((browColor>>16)&255,(browColor>>8)&255,browColor&255)>115)browColor=0x493328;
            for(var side:int=-1;side<=1;side+=2){
                if(eyeSide!=0&&side!=eyeSide)continue;
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
                    g.lineStyle(1.5,INK);g.beginFill(uint(p.eye));g.drawEllipse(cx+look-irisW/2,irisY-irisH/2,irisW,irisH);g.endFill();
                    g.lineStyle();g.beginFill(0x111719);g.drawEllipse(cx+look-4.6,irisY-irisH*.38,9.2,irisH*.76);g.endFill();
                    g.beginFill(0xffffff);g.drawEllipse(cx+look-3.3,irisY-irisH*.32,3.5,4.2);g.drawCircle(cx+look+2.8,irisY+irisH*.23,.9);g.endFill();
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
        private function drawAvatarGear():void {
            var g:Graphics=gear.graphics,c:uint=uint(p.helmet);g.lineStyle(3,INK,1,true);g.beginFill(c);
            g.moveTo(-73,-96);g.lineTo(-72,-127);g.curveTo(-61,-157,0,-156);g.curveTo(60,-157,72,-127);g.lineTo(73,-96);g.curveTo(0,-119,-73,-96);g.endFill();
            g.beginFill(VisualProfile.darker(c,.24));g.moveTo(-74,-97);g.curveTo(0,-122,74,-97);g.lineTo(81,-88);g.curveTo(0,-109,-78,-88);g.lineTo(-74,-97);g.endFill();
            g.beginFill(c);g.drawRoundRect(-76,-96,14,38,8);g.drawRoundRect(62,-96,14,38,8);g.endFill();
            g.lineStyle();g.beginFill(0xffffff,.30);g.drawEllipse(-44,-143,27,6);g.endFill();
            gearLogo=new TeamLogoView(GameData.teamCity,GameData.teamAccent,"",27);gearLogo.x=-13;gearLogo.y=-140;gear.addChild(gearLogo);
        }
        private function drawGear():void {
            var g:Graphics=gear.graphics,c:uint=uint(p.helmet);g.lineStyle(2.8,INK,1,true);g.beginFill(c);
            g.moveTo(-56,-26);g.curveTo(-59,-91,-14,-101);g.curveTo(42,-112,56,-29);g.lineTo(42,-25);g.curveTo(0,-48,-42,-25);g.lineTo(-56,-26);g.endFill();
            g.beginFill(c);g.drawRoundRect(-56,-29,13,45,8);g.drawRoundRect(43,-29,13,45,8);g.endFill();
            g.beginFill(VisualProfile.darker(c,.22));g.moveTo(-55,-30);g.curveTo(-7,-51,55,-29);g.lineTo(62,-22);g.curveTo(5,-34,-55,-23);g.lineTo(-55,-30);g.endFill();
            g.lineStyle();g.beginFill(0xffffff,.7);g.drawEllipse(-31,-84,25,8);g.endFill();
            gearLogo=new TeamLogoView(GameData.teamCity,GameData.teamAccent,"",24);gearLogo.x=-12;gearLogo.y=-78;gear.addChild(gearLogo);
            if(p.goggles){g.lineStyle(3.4,uint(p.goggles));g.beginFill(0xe1f5ff,.08);g.drawRoundRect(-38,-15,33,32,9);g.drawRoundRect(5,-15,33,32,9);g.endFill();g.moveTo(-5,-1);g.lineTo(5,-1);}g.lineStyle();
        }
        private static function hairPixels(style:int,color:uint):BitmapData {
            if(!source)source=Bitmap(new Sheet()).bitmapData;var key:String=style+":"+color;if(cache[key])return cache[key];
            var r:Array=BOXES[style],b:BitmapData;
            if(style==2){
                // Normalize the large illustration once before per-color work.
                // Each color uses roughly the same number of pixels as the old atlas.
                if(!volumeSource){volumeSource=new BitmapData(400,392,true,0);var full:BitmapData=Bitmap(new VolumeSheet()).bitmapData;
                    // Read the embedded pixels directly. Ruffle can defer draw()
                    // until after a temporary source texture has been disposed.
                    volumeSource.lock();for(var vy:int=0;vy<392;vy++)for(var vx:int=0;vx<400;vx++)
                        volumeSource.setPixel32(vx,vy,full.getPixel32(138+int((vx+.5)*1055/400),67+int((vy+.5)*1033/392)));
                    volumeSource.unlock();full.dispose();}
                b=volumeSource.clone();
            }else {b=new BitmapData(r[2],r[3],true,0);b.copyPixels(source,new Rectangle(r[0],r[1],r[2],r[3]),new Point());}
            b.lock();
            for(var y:int=0;y<b.height;y++)for(var x:int=0;x<b.width;x++){var q:uint=b.getPixel32(x,y),rr:int=(q>>16)&255,gg:int=(q>>8)&255,bb:int=q&255;
                if((q>>>24)<16||Math.max(rr,gg,bb)<38)continue;
                var shade:Number=(.299*rr+.587*gg+.114*bb)-(style==2?53:83);
                var nr:int=Math.max(0,Math.min(255,((color>>16)&255)+shade)),ng:int=Math.max(0,Math.min(255,((color>>8)&255)+shade)),nb:int=Math.max(0,Math.min(255,(color&255)+shade));b.setPixel32(x,y,(q&0xff000000)|(nr<<16)|(ng<<8)|nb);
            }b.unlock();cache[key]=b;order.push(key);
            // Cached bitmaps can be shared by living heads. Eviction releases the
            // cache reference; the runtime frees each texture after its last head.
            while(order.length>24)delete cache[order.shift()];return b;
        }
        public function dispose():void {if(avatarRear){avatarRear.dispose();avatarRear=null;}if(avatar){avatar.dispose();avatar=null;}if(gearLogo){gearLogo.dispose();gearLogo=null;}if(wig)wig.bitmapData=null;for each(var view:Sprite in views)for(var i:int=0;i<view.numChildren;i++)if(view.getChildAt(i) is Bitmap)Bitmap(view.getChildAt(i)).bitmapData=null;views={};while(turned.numChildren)turned.removeChildAt(0);}
    }
}
