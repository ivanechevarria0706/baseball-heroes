package com.bh.visual {
    import flash.display.*;
    import flash.geom.*;

    /** Embedded atlases with reference-counted, bounded palette caches.
     * Originals retain their alpha; cropping and palette adaptation occur in memory.
     */
    public class IllustratedSprite extends Sprite {
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v060/batter-atlas.png")] private static const BatterSheet:Class;
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v095/pitcher-atlas.png")] private static const PitcherSheet:Class;
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v060/characters-atlas.png")] private static const CharacterSheet:Class;
        private static var sheets:Object={};
        private static var banks:Object={},serial:int=0;
        private var frames:Object={},bitmap:Bitmap=new Bitmap(null,"auto",true);
        private var bank:Object,bankKey:String;
        private var kind:String,palette:Object,unit:Number,disposed:Boolean=false;
        private var rows:Array;
        private var index:int=-1;
        public function IllustratedSprite(kind:String,unit:Number=1,palette:Object=null) {
            this.kind=kind;this.unit=unit;this.palette=palette;mouseEnabled=mouseChildren=false;
            rows=kind=="batter"?SpriteFrameLayout.BATTER:kind=="pitcher"?SpriteFrameLayout.PITCHER:SpriteFrameLayout.CHARACTERS;
            bankKey=kind;
            for each(var key:String in ["uniform","helmet","bat","skin","shoe"])bankKey+=":"+(palette&&palette[key]!==undefined?palette[key]:"-");
            if(!banks[bankKey])banks[bankKey]={frames:{},refs:0,used:0};
            bank=banks[bankKey];bank.refs++;bank.used=++serial;frames=bank.frames;
            if(!sheets[kind]) {
                var type:Class=kind=="batter"?BatterSheet:kind=="pitcher"?PitcherSheet:CharacterSheet;
                sheets[kind]=Bitmap(new type()).bitmapData;
            }
            addChild(bitmap);setFrame(0);
        }
        public function get frameIndex():int {return index;}
        public function warmAll():void {var saved:int=index;for(var i:int=0;i<rows.length;i++)setFrame(i);setFrame(saved);}
        public function get sourceFrame():Array {return rows[index].concat();}
        public function setFrame(value:int):void {
            if(disposed)return;value=Math.max(0,Math.min(rows.length-1,value));if(value==index)return;index=value;
            var r:Array=rows[index];
            if(!frames[index]) {
                var b:BitmapData=new BitmapData(r[2],r[3],true,0);
                b.copyPixels(sheets[kind],new Rectangle(r[0],r[1],r[2],r[3]),new Point());
                if(palette)recolor(b,r);
                frames[index]=b;
            }
            bitmap.bitmapData=frames[index];bitmap.scaleX=bitmap.scaleY=unit;
            bitmap.x=-Number(r[4])*unit;bitmap.y=-Number(r[5])*unit;
        }
        /** Convert a point measured on the original sheet into actor-local space. */
        public function sheetPoint(px:Number,py:Number):Point {
            var r:Array=rows[index];return new Point((px-r[0]-r[4])*unit,(py-r[1]-r[5])*unit);
        }
        private function recolor(b:BitmapData,r:Array):void {
            var regions:Object=kind=="batter"?colorRegions(b):null;
            b.lock();
            for(var yy:int=0;yy<b.height;yy++)for(var xx:int=0;xx<b.width;xx++) {
                var pixel:uint=b.getPixel32(xx,yy);if((pixel>>>24)<12)continue;
                var red:int=(pixel>>16)&255,green:int=(pixel>>8)&255,blue:int=pixel&255;
                var target:uint,reference:uint,change:Boolean=false;
                if(kind=="pitcher") {
                    if(blue>red*1.08&&red>green*1.2&&blue>45){target=palette.uniform;reference=0x693d91;change=true;}
                } else if(kind=="batter") {
                    if(blue>red*1.3&&blue>green*1.08&&blue>45) {
                        target=regions.labels[yy*b.width+xx]==regions.helmet?palette.helmet:palette.uniform;reference=0x0869d7;change=true;
                    } else if(red>green*1.08&&green>blue*1.22&&red>90) {
                        // The bat and skin overlap in hue. Connected material
                        // regions avoid recoloring cel shadows as patchy skin.
                        if(regions.labels[yy*b.width+xx]==regions.bat){target=palette.bat;reference=0xe5ae47;}
                        else {target=palette.skin;reference=0xe6ad80;}
                        change=true;
                    } else if(yy>Number(r[5])-35&&Math.max(red,green,blue)-Math.min(red,green,blue)<22&&red<100) {
                        target=palette.shoe;reference=0x303438;change=true;
                    }
                }
                if(change) {
                    var lum:Number=.299*red+.587*green+.114*blue;
                    var base:Number=.299*((reference>>16)&255)+.587*((reference>>8)&255)+.114*(reference&255);
                    var delta:Number=lum-base;
                    var nr:int=Math.max(0,Math.min(255,((target>>16)&255)+delta));
                    var ng:int=Math.max(0,Math.min(255,((target>>8)&255)+delta));
                    var nb:int=Math.max(0,Math.min(255,(target&255)+delta));
                    b.setPixel32(xx,yy,(pixel&0xff000000)|(nr<<16)|(ng<<8)|nb);
                }
            }
            b.unlock();
        }
        private function colorRegions(b:BitmapData):Object {
            var w:int=b.width,h:int=b.height,total:int=w*h;
            var types:Vector.<int>=new Vector.<int>(total,true),labels:Vector.<int>=new Vector.<int>(total,true);
            var i:int,pixel:uint,red:int,green:int,blue:int;
            for(i=0;i<total;i++) {
                pixel=b.getPixel32(i%w,int(i/w));if((pixel>>>24)<12)continue;
                red=(pixel>>16)&255;green=(pixel>>8)&255;blue=pixel&255;
                if(blue>red*1.3&&blue>green*1.08&&blue>45)types[i]=1;
                else if(red>green*1.08&&green>blue*1.22&&red>90)types[i]=2;
            }
            var id:int=0,largest:Array=[0,0,0],best:Array=[0,0,0];
            for(i=0;i<total;i++) {
                if(!types[i]||labels[i])continue;id++;
                var queue:Vector.<int>=new <int>[i],at:int=0;labels[i]=id;
                while(at<queue.length) {
                    var pos:int=queue[at++],x:int=pos%w;
                    if(x>0)visit(pos-1,types[i],id,types,labels,queue);
                    if(x<w-1)visit(pos+1,types[i],id,types,labels,queue);
                    if(pos>=w)visit(pos-w,types[i],id,types,labels,queue);
                    if(pos<total-w)visit(pos+w,types[i],id,types,labels,queue);
                }
                if(queue.length>largest[types[i]]){largest[types[i]]=queue.length;best[types[i]]=id;}
            }
            return {labels:labels,helmet:best[1],bat:best[2]};
        }
        private function visit(pos:int,type:int,id:int,types:Vector.<int>,labels:Vector.<int>,queue:Vector.<int>):void {
            if(types[pos]!=type||labels[pos])return;labels[pos]=id;queue.push(pos);
        }
        public function dispose():void {
            if(disposed)return;disposed=true;bitmap.bitmapData=null;
            bank.refs--;bank.used=++serial;frames={};
            // Keep a small number of idle palettes for returning batters. Active
            // actors retain their textures; no texture is freed while displayed.
            var idle:Array=[];
            for(var key:String in banks)if(banks[key].refs==0)idle.push({key:key,used:banks[key].used});
            idle.sortOn("used",Array.NUMERIC);
            while(idle.length>6) {
                var expired:String=idle.shift().key;
                for each(var b:BitmapData in banks[expired].frames)b.dispose();delete banks[expired];
            }
        }
    }
}
