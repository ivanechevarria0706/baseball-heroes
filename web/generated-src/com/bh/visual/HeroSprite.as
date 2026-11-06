package com.bh.visual {
    import flash.display.*;import flash.geom.*;import com.bh.model.GameData;import com.bh.game.SwingMotion;
    /** Modular illustrated poses. All views attach the same saved HeroHead. */
    public class HeroSprite extends Sprite {
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v097/hero-atlas.png")] private static const Body097:Class;
        private static var source097:BitmapData,banks:Object={},neutral:Object={},serial:int=0;
        private static const BOX097:Array=[[69, 40, 262, 320], [413, 39, 262, 321], [778, 33, 297, 327], [1122, 42, 259, 318], [68, 371, 293, 332], [417, 373, 239, 330], [764, 372, 278, 331], [1085, 468, 341, 235], [48, 788, 390, 250], [459, 704, 281, 330], [799, 724, 270, 313], [1143, 711, 282, 326]];
        private static const NECK097:Array=[[194, 117], [539, 117], [904, 115], [1248, 117], [221, 469], [584, 463], [911, 470], [1170, 482], [165, 802], [647, 790], [962, 797], [1298, 812]];
        private static const FEET097:Array=[195, 540, 920, 1260, 230, 570, 900, 1197, 189, 625, 945, 1295];
        private static const MAP097:Array=[4,4,5,5,6,6,7,8,9,10,11,4,0,4,3,3,6,6,8,9,9,10,11,4];
        private static const FACING:Array=[120,120,115,105,100,95,90,110,135,150,135,120,30,115,15,0,105,90,105,130,140,135,120,120];
        private static const BODY_HEIGHT:Number=140, BODY_WIDTH:Number=.76;
        private var bitmap:Bitmap=new Bitmap(null,"auto",true),head:*,bank:Object,key:String,p:Object,mode:String,unit:Number,index:int=-1,dead:Boolean=false;
        private var direction:Number=0,targetDirection:Number=0;
        private var matchBody:MatchBodyArtwork;private static const MATCH_MAP:Array=[0,1,2,3,4,5,7,8,9,10,11,0,12,13,14,15,6,6,8,9,10,11,0,1];
        private var referenceBody:ReferenceBatterArtwork,faceMask:Shape;
        private var avatarBody:HeroAvatarArtwork;private var details:FaceDetails,costume:CostumeArtwork;
        public function HeroSprite(playerName:String,accent:uint,appearance:Object=null,mode:String="home",unit:Number=1,gear:Object=null,protectedHead:Boolean=false) {
            this.mode=mode;this.unit=unit;mouseEnabled=mouseChildren=false;
            if(!appearance){var player:Object=GameData.playerByName(playerName);appearance=player?player.appearance:null;}
            if(!appearance){var seed:int=VisualProfile.seed(playerName);appearance={shape:seed%8,hair:int(seed/7)%8,eyes:int(seed/11)%8,nose:int(seed/13)%8,mouth:int(seed/17)%8};}
            p=HomeSprite.paletteFor(playerName,accent,appearance,gear);
            if(int(appearance.artVersion)>=1&&mode=="batter"){
                referenceBody=new ReferenceBatterArtwork(p,150);referenceBody.scaleX=referenceBody.scaleY=unit;addChild(referenceBody);
                head=new HeroHead(appearance,p,"",false);head.scaleX=head.scaleY=unit*.78;addChild(head);
                faceMask=new Shape();faceMask.graphics.beginFill(0);faceMask.graphics.drawRect(-220,-100,440,140);faceMask.graphics.endFill();addChild(faceMask);head.mask=faceMask;
                referenceBody.helmetLayer.scaleX=referenceBody.helmetLayer.scaleY=unit;addChild(referenceBody.helmetLayer);
                referenceBody.helmetLayer.visible=int(p.costume)<0&&ClassicWearables.helmet(String(p.helmetName))==null;
                costume=new CostumeArtwork(p);addChild(costume);costume.scaleX=costume.scaleY=unit*.93;setFrame(0);return;
            }
            
            if(int(appearance.artVersion)>=1&&mode=="home"){avatarBody=new HeroAvatarArtwork(appearance,p,"body");avatarBody.scaleX=avatarBody.scaleY=unit;addChild(avatarBody);head=new HeroHead(appearance,p,"",protectedHead);head.scaleX=head.scaleY=unit;addChild(head);costume=new CostumeArtwork(p,mode!="home"||protectedHead);costume.attach(head);setFrame(0);return;}
            if(!source097)source097=Bitmap(new Body097()).bitmapData;
            key="";for each(var field:String in ["skin","uniform","bat","batName","shoe","belt","glove","costume","shoeTheme","gloveTheme","beltTheme","helmetName","gogglesName","gloveName","shoesName","beltName"])key+=p[field]+":";
            if(!banks[key])banks[key]={frames:{},refs:0,used:0};bank=banks[key];bank.refs++;bank.used=++serial;
            // User-approved batter head is frozen at 0.8.6; other views retain their renderer.
            var hp:Object={};for(var pk:String in p)hp[pk]=p[pk];
            if(ClassicWearables.family(String(p.gogglesName),ClassicWearables.GOGGLES)>=0)hp.goggles=0;
            addChild(bitmap);head=mode=="batter"&&int(appearance.artVersion)<1?new BatterHead086(appearance,hp,"",true):new HeroHead(appearance,hp,"",protectedHead);addChild(head);head.scaleX=head.scaleY=unit;if(mode=="batter"&&int(appearance.artVersion)<1){details=new FaceDetails(int(appearance.etc));details.y=-39;head.addChild(details);}
            costume=new CostumeArtwork(p,mode!="home"||protectedHead);costume.attach(head);setFrame(0);
        }
        public function get frameIndex():int{return index;}
        public function get hasReferenceBatter():Boolean{return referenceBody!=null;}
        public function supportKey(frame:int):String {return referenceBody&&ReferenceBatterArtwork.mapped(frame)<=1?"rear":"plant";}
        public function warmAll():void {if(referenceBody){referenceBody.warmAll();return;}var saved:int=index;for(var i:int=0;i<(mode=="batter"?24:4);i++)setFrame(i);setFrame(saved);}
        public function get headFacing():int{return referenceBody?30:matchBody?matchBody.facing:mode=="batter"?(index<=11||index==13||index>=16?180:0):head.facing;}
        public function get headStyle():String{return referenceBody?"1.0.43":matchBody?"1.0.39":mode=="batter"?"0.8.6":"0.8.7";}
        public function advanceHead(milliseconds:int):void {
            // The 0.8.6 batter switches its two original views with the body pose.
            // Keep this call compatible with ClassicBatter without changing its art.
        }
        public function setFrame(value:int,animated:Boolean=false):void {
            if(dead)return;value=Math.max(0,Math.min(mode=="batter"?23:3,value));if(value==index)return;index=value;
            if(referenceBody){
                referenceBody.setFrame(value);var at:Point=referenceBody.anchor();head.x=at.x*unit;head.y=(at.y+2)*unit;head.rotation=referenceBody.tilt;head.setFacing(30);head.setExpression(value==12?2:value==14?3:0);
                faceMask.x=head.x;faceMask.y=head.y;faceMask.rotation=head.rotation;faceMask.scaleX=head.scaleX;faceMask.scaleY=head.scaleY;
                costume.x=head.x;costume.y=head.y;costume.rotation=head.rotation;costume.setRear(false);return;
            }
            if(matchBody){matchBody.setFrame(MATCH_MAP[value]);var mount:Point=matchBody.anchor();head.x=mount.x*unit;head.y=(mount.y+2)*unit;head.rotation=value==12?5:0;head.setFacing(matchBody.facing);head.setExpression(value==12?2:value==14?3:0);costume.setRear(matchBody.facing>90);return;}
            if(avatarBody){avatarBody.y=value==1?unit:0;head.x=0;head.y=-134*unit+(value==1?unit:0);head.rotation=value==3?-3:0;head.setExpression(value);return;}
            var fresh:int=mode=="batter"?MAP097[value]:value;
            var n:int=100+fresh;
            var r:Array=BOX097[fresh],neck:Array=NECK097[fresh];
            var feet:Number=FEET097[fresh],s:Number=BODY_HEIGHT/(r[1]+r[3]-neck[1])*unit;
            var bodyWidth:Number=.82;
            if(!bank.frames[n]){
                if(!neutral[n]){
                    var clean:BitmapData=new BitmapData(r[2],r[3],true,0);clean.copyPixels(source097,new Rectangle(r[0],r[1],r[2],r[3]),new Point());isolate(clean,int(neck[0]-r[0]),int(neck[1]-r[1]));neutral[n]=clean;}
                var b:BitmapData=BitmapData(neutral[n]).clone();recolor(b,r,neck,fresh);bank.frames[n]=b;
            }
            bitmap.bitmapData=bank.frames[n];bitmap.scaleY=s;bitmap.scaleX=s*bodyWidth;bitmap.x=(r[0]-feet)*s*bodyWidth;bitmap.y=-r[3]*s;
            // Seat the jaw inside the existing stump, leaving a short visible neck.
            // Rotate around that mount so tilted poses do not pull it out of the collar.
            head.x=(neck[0]-feet)*s*bodyWidth;head.y=-(BODY_HEIGHT+9)*unit;head.scaleX=unit;head.rotation=mode=="batter"?(n==15?14:n==9?-8:n==12?8:0):0;
            targetDirection=mode=="batter"?FACING[value]:0;
            if(mode=="batter"){head.setRear(value<=11||value==13||value>=16);if(details)details.visible=!(value<=11||value==13||value>=16);}
            else if(!animated){direction=targetDirection;head.setFacing(direction);}
            head.setExpression(mode=="home"?(value==1?1:value==3?3:0):(value==12?2:value==14?3:0));
            costume.setRear(mode=="batter"&&(value<=11||value==13||value>=16));
        }
        public function swingAnchor(frame:int,key:String):Point {
            if(referenceBody){var native:Point=referenceBody.anchor(key,frame);native.x*=unit;native.y*=unit;return native;}
            if(key=="contact")return contactPoint();
            if(!matchBody)return key=="tip"?contactPoint():new Point();
            var mapped:int=MATCH_MAP[frame],f:Object=MatchPoseStore.frames("batter")[mapped],anchor:Array=SwingMotion.pose(mapped)[key];
            var first:Object=MatchPoseStore.frames("batter")[0],scale:Number=BODY_HEIGHT/(first.ground[1]-first.neck[1])*unit;
            return new Point((anchor[0]-f.ground[0])*scale,(anchor[1]-f.ground[1])*scale);
        }
        public function contactPoint():Point {if(referenceBody){var native:Point=referenceBody.anchor("contact",6);native.x*=unit;native.y*=unit;return native;}if(matchBody){var point:Point=matchBody.anchor("contact",7);point.x*=unit;point.y*=unit;return point;}var r:Array=BOX097[7],s:Number=BODY_HEIGHT/(r[1]+r[3]-NECK097[7][1])*unit;return new Point((1420-FEET097[7])*s*.82,(546-r[1]-r[3])*s);}
        private function isolate(b:BitmapData,x:int,y:int):void {
            // A neighboring bat can enter this silhouette's bounding rectangle.
            // Keep only the connected actor, once when its cached frame is made.
            var mask:BitmapData=new BitmapData(b.width,b.height,true,0);mask.threshold(b,b.rect,new Point(),">",0x08000000,0xffffffff,0xff000000);mask.floodFill(x,y,0xff00ff00);
            var pixels:Vector.<uint>=b.getVector(b.rect),connected:Vector.<uint>=mask.getVector(mask.rect);for(var i:int=0;i<pixels.length;i++)if(connected[i]!=0xff00ff00)pixels[i]=0;b.setVector(b.rect,pixels);mask.dispose();
        }
        private function recolor(b:BitmapData,r:Array,neck:Array,frame:int=-1):void {
            var pixels:Vector.<uint>=b.getVector(b.rect);
            // Resolve catalogue families once per pose, never for each pixel.
            var batName:String=String(p.batName),gloveName:String=String(p.gloveName),shoesName:String=String(p.shoesName);
            var useClassicBat:Boolean=ClassicWearables.hasBat(batName),useClassicGlove:Boolean=ClassicWearables.hasGlove(gloveName),useClassicShoes:Boolean=ClassicWearables.hasShoes(shoesName);
            for(var i:int=0;i<pixels.length;i++){
                var y:int=int(i/b.width),x:int=i-y*b.width;
                var q:uint=pixels[i],red:int=(q>>16)&255,green:int=(q>>8)&255,blue:int=q&255;if((q>>>24)<16||Math.max(red,green,blue)<38)continue;
                var target:uint,base:uint,change:Boolean=true,bodyY:Number=(y+r[1]-neck[1])/(r[1]+r[3]-neck[1]);
                if(red>green*1.5&&red>blue*1.7&&green<100){target=CostumeArtwork.cloth(int(p.costume),(x+r[0]-neck[0])/(r[1]+r[3]-neck[1]),(y+r[1]-neck[1])/(r[1]+r[3]-neck[1]),uint(p.uniform));base=0xc71923;}
                else if(red>green*1.05&&green>blue*1.12&&red>90){
                    if(blue<green*.68){target=useClassicBat?PoseMaterials.classicBat(batName,x+r[0],y+r[1],frame,uint(p.bat)):int(p.batTheme)>=0?PoseMaterials.bat(int(p.batTheme),x+r[0],y+r[1],frame,uint(p.bat)):uint(p.bat);base=0xe5a34c;}else{target=bodyY>.16&&bodyY<.43?p.glove:p.skin;base=0xf3ba97;}
                }else if((int(p.gloveTheme)>=0||useClassicGlove)&&PoseMaterials.glove(x+r[0],y+r[1],frame)&&red>145&&Math.max(red,green,blue)-Math.min(red,green,blue)<28){target=useClassicGlove?ClassicWearables.glovePaint(gloveName,x+r[0],y+r[1],uint(p.glove)):uint(p.glove);base=0xe7e5e1;}
                else if((int(p.costume)>=0||p.rookieBlack)&&bodyY>.02&&bodyY<.43&&red>160&&Math.max(red,green,blue)-Math.min(red,green,blue)<28){target=CostumeArtwork.cloth(int(p.costume),(x+r[0]-neck[0])/(r[1]+r[3]-neck[1]),bodyY,uint(p.uniform));base=0xe7e5e1;}
                else if(y+r[1]>neck[1]+(r[1]+r[3]-neck[1])*.38&&y+r[1]<neck[1]+(r[1]+r[3]-neck[1])*.60&&red<85&&Math.max(red,green,blue)-Math.min(red,green,blue)<12){target=p.belt;base=0x333333;}
                else if(y+r[1]>neck[1]+(r[1]+r[3]-neck[1])*.78&&red<100&&Math.max(red,green,blue)-Math.min(red,green,blue)<18){target=useClassicShoes?ClassicWearables.shoePaint(shoesName,(x+r[0]-neck[0])/(r[1]+r[3]-neck[1]),bodyY,uint(p.shoe),true):uint(p.shoe);base=0x333333;}
                else change=false;
                if(change){var shade:Number=.299*(red-((base>>16)&255))+.587*(green-((base>>8)&255))+.114*(blue-(base&255));var nr:int=Math.max(0,Math.min(255,((target>>16)&255)+shade)),ng:int=Math.max(0,Math.min(255,((target>>8)&255)+shade)),nb:int=Math.max(0,Math.min(255,(target&255)+shade));pixels[i]=(q&0xff000000)|(nr<<16)|(ng<<8)|nb;}
            }b.setVector(b.rect,pixels);
        }
        public function dispose():void {if(dead)return;dead=true;costume.dispose();if(referenceBody){referenceBody.dispose();head.dispose();return;}if(matchBody){matchBody.dispose();head.dispose();return;}if(avatarBody){avatarBody.dispose();head.dispose();return;}bitmap.bitmapData=null;head.dispose();bank.refs--;bank.used=++serial;var idle:Array=[];for(var k:String in banks)if(!banks[k].refs)idle.push({key:k,used:banks[k].used});idle.sortOn("used",Array.NUMERIC);while(idle.length>6){var gone:String=idle.shift().key;for each(var b:BitmapData in banks[gone].frames)b.dispose();delete banks[gone];}}
    }
}
