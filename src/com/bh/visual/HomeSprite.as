package com.bh.visual {
    import flash.display.*;import flash.geom.*;
    import com.bh.model.GameData;
    /** Front-view bitmap actor shared by HOME, the wardrobe and hero portraits. */
    public class HomeSprite extends Sprite {
        [Embed(source="../../../../assets/sprites/v061/home-atlas.png")] private static const Sheet:Class;
        private static var source:BitmapData;
        private static const RECTS:Array=[[132,30,438,595,195,592],[733,30,438,595,195,592],[132,641,438,594,195,591],[733,641,438,594,195,591]];
        private static var banks:Object={},serial:int=0;
        private var bank:Object,key:String,bitmap:Bitmap=new Bitmap(null,'auto',true),glasses:Sprite=new Sprite();
        private var palette:Object,index:int=-1,disposed:Boolean=false;
        public function HomeSprite(palette:Object){
            this.palette=palette;mouseEnabled=mouseChildren=false;
            if(!source)source=Bitmap(new Sheet()).bitmapData;
            key='';for each(var field:String in ['helmet','uniform','hair','eye','skin','bat','glove','belt','shoe'])key+=palette[field]+':';
            if(!banks[key])banks[key]={frames:{},refs:0,used:0};bank=banks[key];bank.refs++;bank.used=++serial;
            addChild(bitmap);addChild(glasses);drawGlasses();setFrame(0);
        }
        public static function paletteFor(playerName:String,accent:uint,appearance:Object=null,gear:Object=null):Object {
            var p:Object=HeroArtwork.palette(playerName,accent,appearance);gear=gear!=null?gear:GameData.equipped;
            var defaults:Object={helmet:accent,bat:0xc49a58,glove:0x9a6334,belt:0x33404a,goggles:0,shoes:0x27333e};
            for(var slot:String in defaults){var item:Object=gear?gear[slot]:null;p[slot=='shoes'?'shoe':slot]=item&&item.accent!==undefined?uint(item.accent):defaults[slot];}
            p.gogglesStyle=gear&&gear.goggles?String(gear.goggles.grade):'';
            p.costume=CostumeArtwork.theme(gear?gear.helmet:null);p.goggleTheme=CostumeArtwork.theme(gear?gear.goggles:null);
            p.beltTheme=CostumeArtwork.theme(gear?gear.belt:null);p.shoeTheme=CostumeArtwork.theme(gear?gear.shoes:null);p.gloveTheme=CostumeArtwork.theme(gear?gear.glove:null);
            for each(var selectedSlot:String in ["helmet","goggles","glove","shoes","belt"])p[selectedSlot+"Name"]=gear&&gear[selectedSlot]?String(gear[selectedSlot].name):"";
            if((!appearance||int(appearance.artVersion)<1)&&GameData.careerStartVersion>=4&&p.helmetName=="Rookie Helmet"){p.helmet=0x303237;p.uniform=0x272b30;p.rookieBlack=true;}
            p.helmet=ClassicWearables.helmetColor(String(p.helmetName),uint(p.helmet));
            p.batName=gear&&gear.bat?String(gear.bat.name):"Rookie Bat";p.batTheme=CostumeArtwork.theme(gear?gear.bat:null);
            if(int(p.costume)>=0)p.uniform=uint(CostumeArtwork.COLORS[int(p.costume)]);
            return p;
        }
        public function get frameIndex():int{return index;}
        public function warmAll():void{var saved:int=index;for(var i:int=0;i<4;i++)setFrame(i);setFrame(saved);}
        public function setFrame(value:int):void {
            if(disposed)return;value=Math.max(0,Math.min(3,value));if(value==index)return;index=value;
            var r:Array=RECTS[index];
            if(!bank.frames[index]){var b:BitmapData=new BitmapData(r[2],r[3],true,0);b.copyPixels(source,new Rectangle(r[0],r[1],r[2],r[3]),new Point());recolor(b);bank.frames[index]=b;}
            bitmap.bitmapData=bank.frames[index];bitmap.x=-r[4];bitmap.y=-r[5];
            glasses.y=index>=2?1:0;
        }
        private function recolor(b:BitmapData):void {
            b.lock();
            for(var y:int=0;y<b.height;y++)for(var x:int=0;x<b.width;x++){
                var pixel:uint=b.getPixel32(x,y);if((pixel>>>24)<16)continue;
                var r:int=(pixel>>16)&255,g:int=(pixel>>8)&255,blue:int=pixel&255;
                if(Math.max(r,g,blue)<40)continue; // Preserve the original dark ink.
                var target:uint,base:uint,change:Boolean=true;
                if(blue>r*1.3&&blue>g*1.05&&blue>40){target=palette.helmet;base=0x0761ce;}
                else if(blue>r*1.04&&r>g*1.2&&blue>35){target=palette.hair;base=0x632b83;}
                else if(g>r*1.18&&g>blue*1.05&&g>30){target=palette.eye;base=0x3b8e43;}
                else if(r>g*1.5&&r>blue*1.3&&y>b.height*.5){
                    if(y>b.height*.666&&y<b.height*.707&&x>130&&x<250){target=palette.belt;base=0xab1746;}
                    else if(g>blue*1.6&&g>0){target=palette.glove;base=0xf58205;}
                    else {target=palette.uniform;base=0xe71520;}
                }
                else if(r>g*1.06&&g>blue*1.15&&r>70){
                    if(blue<g*.56){target=palette.bat;base=0xffb548;}
                    else {target=palette.skin;base=0xfdbf86;}
                }
                else if(y>b.height*.86&&Math.max(r,g,blue)-Math.min(r,g,blue)<22&&r>=27&&r<110){target=palette.shoe;base=0x363438;}
                else change=false;
                if(change){
                    var delta:Number=.299*(r-((base>>16)&255))+.587*(g-((base>>8)&255))+.114*(blue-(base&255));
                    var nr:int=Math.max(0,Math.min(255,((target>>16)&255)+delta)),ng:int=Math.max(0,Math.min(255,((target>>8)&255)+delta)),nb:int=Math.max(0,Math.min(255,(target&255)+delta));
                    b.setPixel32(x,y,(pixel&0xff000000)|(nr<<16)|(ng<<8)|nb);
                }
            }
            b.unlock();
        }
        private function drawGlasses():void {
            if(!palette.goggles)return;
            var g:Graphics=glasses.graphics,color:uint=uint(palette.goggles);
            // Separate eyewear keeps the selected eyes and blinking visible.
            g.lineStyle(7,0x17242d);g.beginFill(0xe4f7ff,.10);
            var sport:Boolean=palette.gogglesStyle=='ELITE'||palette.gogglesStyle=='HERO';
            if(sport){g.drawRoundRect(-100,-408,200,70,30,28);}else{g.drawRoundRect(-98,-408,88,70,13,13);g.drawRoundRect(10,-408,88,70,13,13);}
            g.endFill();g.lineStyle(4,color);
            if(sport)g.drawRoundRect(-100,-408,200,70,30,28);else{g.drawRoundRect(-98,-408,88,70,13,13);g.drawRoundRect(10,-408,88,70,13,13);}
            g.moveTo(-10,-383);g.lineTo(10,-383);g.moveTo(-98,-384);g.lineTo(-111,-390);g.moveTo(98,-384);g.lineTo(111,-390);g.lineStyle();
        }
        public function dispose():void {
            if(disposed)return;disposed=true;bitmap.bitmapData=null;bank.refs--;bank.used=++serial;
            var idle:Array=[];for(var name:String in banks)if(banks[name].refs==0)idle.push({key:name,used:banks[name].used});idle.sortOn('used',Array.NUMERIC);
            while(idle.length>4){var expired:String=idle.shift().key;for each(var b:BitmapData in banks[expired].frames)b.dispose();delete banks[expired];}
        }
    }
}
