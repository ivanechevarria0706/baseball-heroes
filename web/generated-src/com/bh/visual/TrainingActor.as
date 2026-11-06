package com.bh.visual {
    import flash.display.*;
    import flash.geom.*;
    import com.bh.model.GameData;
    /** Training-only body poses. Uses the unchanged saved 0.8.6 face without a helmet. */
    public class TrainingActor extends Sprite {
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v112/stretching-atlas.png")] private static const Stretch:Class;
        [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v112/lifting-atlas.png")] private static const Lift:Class;
        private static var sources:Object={},banks:Object={},serial:int=0;
        private var body:Bitmap,head:BatterHead086,details:FaceDetails,runner:RunnerSprite,runnerMount:Sprite;
        private var p:Object,kind:String,activity:String,row:int,bank:Object,key:String,index:int=-1,dead:Boolean=false;
        private const UNIT:Number=.72,HEAD:Number=.75;
        public function TrainingActor(player:Object,discipline:String,activityIndex:int,activityId:String) {
            mouseEnabled=mouseChildren=false;kind=discipline;row=Math.max(0,Math.min(5,activityIndex));activity=activityId;
            p=HomeSprite.paletteFor(String(player.name),uint(player.accent),player.appearance,player===GameData.mainPlayer()?GameData.equipped:{});
            var a:Object=player.appearance||{shape:0,hair:0,eyes:0,nose:0,mouth:0};
            if(kind=="running") {
                runner=new RunnerSprite(player);runner.scaleX=runner.scaleY=.90;addChild(runner);
                // Reuse its illustrated body, attach the unhelmeted saved face locally.
                // Neither the existing runner nor its approved head source is edited.
                runnerMount=runner.getChildAt(1) as Sprite;runnerMount.visible=false;runner.warmAll();
            }else{
                if(!sources[kind])sources[kind]=Bitmap(kind=="stretching"?new Stretch():new Lift()).bitmapData;
                key=[kind,p.uniform,p.skin,p.shoe].join(":");
                if(!banks[key])banks[key]={frames:{},refs:0,used:0};bank=banks[key];bank.refs++;bank.used=++serial;
                body=new Bitmap(null,"auto",true);addChild(body);
            }
            head=new BatterHead086(a,p,"",false);head.scaleX=head.scaleY=HEAD;addChild(head);
            details=new FaceDetails(int(a.etc));details.y=-39;head.addChild(details);head.setRear(false);
            if(body){for(var i:int=0;i<4;i++)setFrame(row*4+i);}
            animate(0);
        }
        private function setFrame(n:int):void {
            if(dead||n==index)return;index=n;
            var meta:Array=(kind=="stretching"?TrainingAtlas112.STRETCHING:TrainingAtlas112.LIFTING)[n],box:Array=meta[0],neck:Array=meta[1];
            if(!bank.frames[n]) {
                var pixels:BitmapData=new BitmapData(box[2],box[3],true,0);
                pixels.copyPixels(sources[kind],new Rectangle(box[0],box[1],box[2],box[3]),new Point());TrainingCutout.isolate(pixels,int(neck[0]-box[0]),int(neck[1]-box[1]));tint(pixels);bank.frames[n]=pixels;
            }
            body.bitmapData=bank.frames[n];body.scaleX=UNIT*.76;body.scaleY=UNIT;
            body.x=(box[0]-meta[2])*UNIT*.76;body.y=(box[1]-meta[3])*UNIT;
            head.x=(neck[0]-meta[2])*UNIT*.76;head.y=(neck[1]-meta[3])*UNIT-2;head.rotation=meta[4];
        }
        private function tint(b:BitmapData):void {
            var pixels:Vector.<uint>=b.getVector(b.rect);
            for(var i:int=0;i<pixels.length;i++) {
                var q:uint=pixels[i],r:int=(q>>16)&255,g:int=(q>>8)&255,blue:int=q&255;
                if((q>>>24)<16||Math.max(r,g,blue)<38)continue;
                var target:uint,base:uint,change:Boolean=true;
                if(blue>r*1.4&&blue>g*1.22&&blue>70){target=uint(p.uniform);base=0x084dcc;}
                else if(r>175&&g>120&&g<215&&blue>75&&blue<185&&r>g*1.1&&g>blue*1.08){target=uint(p.skin);base=0xf7b582;}
                else change=false;
                if(change){var shade:Number=.299*(r-((base>>16)&255))+.587*(g-((base>>8)&255))+.114*(blue-(base&255));pixels[i]=(q&0xff000000)|(Math.max(0,Math.min(255,((target>>16)&255)+shade))<<16)|(Math.max(0,Math.min(255,((target>>8)&255)+shade))<<8)|Math.max(0,Math.min(255,(target&255)+shade));}
            }
            b.setVector(b.rect,pixels);
        }
        public function animate(ms:Number):void {
            if(dead)return;ms=Math.max(0,ms);
            if(runner) {
                if(activity=="sliding")runner.arrive(ms%1100,true);
                else runner.runAt(ms*(activity=="meters100"?1.2:activity=="mile"?.78:activity=="longrun"?.65:1));
                index=runner.frameIndex;head.x=runnerMount.x*.90;head.y=runnerMount.y*.90;head.rotation=activity=="sliding"?-5:6;
            }else setFrame(row*4+int(ms/240)%4);
        }
        public function describe():Object {return {discipline:kind,activity:activity,frame:index,headStyle:"0.8.6",identity:head.identity(),skin:p.skin,uniform:p.uniform,headX:head.x,headY:head.y,headRotation:head.rotation};}
        public function complete():void {if(dead)return;if(runner){runner.cheer(true);index=runner.frameIndex;head.x=runnerMount.x*.90;head.y=runnerMount.y*.90;head.rotation=0;}else setFrame(row*4+3);head.setExpression(3);}
        public function dispose():void {
            if(dead)return;dead=true;head.dispose();
            if(runner){runner.dispose();runner=null;}
            if(body){body.bitmapData=null;bank.refs--;bank.used=++serial;var idle:Array=[];for(var k:String in banks)if(!banks[k].refs)idle.push({key:k,used:banks[k].used});idle.sortOn("used",Array.NUMERIC);while(idle.length>2){var gone:String=idle.shift().key;for each(var image:BitmapData in banks[gone].frames)image.dispose();delete banks[gone];}}
        }
    }
}
