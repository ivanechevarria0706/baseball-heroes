package com.bh.visual {
    import flash.display.*;import flash.geom.Matrix;import com.bh.model.GameData;import com.bh.ui.ClassicInventorySkin;
    /** Reconstructed structures on the measured 960 x 720 stadium camera. */
    public class StadiumUpgradeOverlay extends Sprite {
        private var visitorView:Object,rookieIllustration:Boolean;
        private function itemFor(slot:String):Object {return visitorView?(visitorView.equipped?GameData.shopItemById(String(visitorView.equipped[slot])):null):GameData.activeStadiumItem(slot);}
        public function StadiumUpgradeOverlay(w:Number,h:Number,batting:Boolean=false,view:Object=null,rookieArt:Boolean=false){
            visitorView=view;rookieIllustration=rookieArt;mouseEnabled=mouseChildren=false;scaleX=w/960;scaleY=h/720;
            var item:Object=itemFor("field");if(paid(item))field(item);
            item=itemFor("stand");if(paid(item)){stand(item,false);stand(item,true);}
            item=itemFor("wall");if(paid(item))wall(item);
            item=itemFor("fence");if(paid(item))fence(item);
            item=itemFor("banner");if(paid(item))banner(item);
            item=itemFor("lights");if(paid(item))lights(item);
            item=itemFor("scoreboard");if(paid(item))scoreboard(item);
            cacheAsBitmap=true;
        }
        private function paid(item:Object):Boolean{return item&&(int(item.coinPrice)>0||int(item.cashPrice)>0);}
        private function part(slot:String,item:Object):Sprite {var s:Sprite=new Sprite();s.name="stadium-component-"+slot;s.mouseEnabled=s.mouseChildren=false;addChild(s);return s;}
        private function poly(g:Graphics,color:uint,p:Array,a:Number=1):void {g.beginFill(color,a);g.moveTo(p[0],p[1]);for(var i:int=2;i<p.length;i+=2)g.lineTo(p[i],p[i+1]);g.lineTo(p[0],p[1]);g.endFill();}
        private function dark(color:uint):uint{return ((color>>16&255)*.52<<16)|((color>>8&255)*.52<<8)|((color&255)*.52);}
        private function field(item:Object):void {
            var s:Sprite=part("field",item),maskShape:Shape=new Shape();addChild(maskShape);
            // Even-odd hole preserves the illustrated mound; the grass edge
            // stops above the dirt, foul lines and batter boxes.
            var commands:Vector.<int>=Vector.<int>([1,2,2,3,2,1,3,3,3,3]);
            var data:Vector.<Number>=Vector.<Number>([0,354,960,354,960,481,480,611,0,481,0,354,387,441,387,420,480,420,573,420,573,441,573,461,480,461,387,461,387,441]);
            if(rookieIllustration){
                var edge:Array=[[960,478],[920,488],[880,497],[840,506],[800,514],[760,522],[720,530],[680,535],[640,533],[600,530],[560,529],[520,528],[480,528],[440,528],[400,529],[360,530],[320,533],[280,535],[240,530],[200,523],[160,515],[120,506],[80,498],[40,488],[0,478],[0,354]];
                commands=Vector.<int>([1,2]);data=Vector.<Number>([0,354,960,354]);
                for each(var point:Array in edge){commands.push(2);data.push(point[0],point[1]);}
                commands.push(1,3,3,3,3);data.push(387,441,387,420,480,420,573,420,573,441,573,461,480,461,387,461,387,441);
            }
            maskShape.graphics.beginFill(0xffffff);maskShape.graphics.drawPath(commands,data,GraphicsPathWinding.EVEN_ODD);maskShape.graphics.endFill();s.mask=maskShape;
            s.graphics.beginFill(uint(item.accent),.25);s.graphics.drawRect(0,350,960,300);s.graphics.endFill();
            var c:uint=uint(item.accent);for(var i:int=0;i<9;i++)poly(s.graphics,i%2?0xffffff:dark(c),[-300+i*175,600,-220+i*175,600,420+i*26,354,407+i*26,354],i%2?.07:.10);
            if(String(item.id).indexOf("tropical")>=0){s.graphics.lineStyle(13,0x99db79,.08);for(i=0;i<5;i++){s.graphics.moveTo(-100,430+i*24);s.graphics.curveTo(480,530+i*30,1060,430+i*24);}s.graphics.lineStyle();}
        }
        private function stand(item:Object,right:Boolean):void {
            var s:Sprite=part(right?"stand-right":"stand",item),g:Graphics=s.graphics,c:uint=uint(item.accent);if(right){s.scaleX=-1;s.x=960;}
            var clip:Shape=new Shape();poly(clip.graphics,0xffffff,rookieIllustration?[0,214,71,214,109,323,0,323]:[0,214,74,214,112,318,0,318]);poly(clip.graphics,0xffffff,rookieIllustration?[123,253,312,253,344,323,149,323]:[135,251,309,251,344,319,155,319]);s.addChild(clip);
            var seats:Sprite=new Sprite();s.addChild(seats);seats.mask=clip;g=seats.graphics;g.beginFill(dark(c));g.drawRect(0,210,350,115);g.endFill();
            for(var row:int=0;row<17;row++){
                var yy:Number=217+row*6.3;g.lineStyle(2.4,c);g.moveTo(0,yy);g.lineTo(345,yy);g.lineStyle(1,0xf3daac,.6);g.moveTo(0,yy-1.5);g.lineTo(345,yy-1.5);g.lineStyle();
                for(var j:int=0;j<49;j++){var xx:Number=5+j*7.2;if((row+j*3)%5==0)continue;g.beginFill((row+j)%3==0?0xf2deae:(row+j)%3==1?0x6ac5c8:0xcf7557,.8);g.drawRect(xx,yy-3,2.7,2);g.endFill();}
            }
            g=s.graphics;g.lineStyle(2,0xe2e6cf);g.moveTo(0,212);g.lineTo(rookieIllustration?71:74,212);g.lineTo(rookieIllustration?109:113,323);g.moveTo(rookieIllustration?121:135,251);g.lineTo(312,251);g.lineTo(346,323);g.lineStyle();
        }
        private function wall(item:Object):void {
            var s:Sprite=part("wall",item),g:Graphics=s.graphics,c:uint=uint(item.accent);ClassicInventorySkin.gradient(g,0,334,960,21,c,dark(c),1);
            g.lineStyle(1.5,0xe4ddba,.75);g.moveTo(0,334);g.lineTo(960,334);g.lineStyle(1,dark(c));for(var i:int=0;i<24;i++){g.moveTo(i*41,335);g.lineTo(i*41,355);}g.lineStyle();
        }
        private function fence(item:Object):void {
            var s:Sprite=part("fence",item),g:Graphics=s.graphics,c:uint=uint(item.accent);
            g.lineStyle(4,dark(c));g.moveTo(0,330);g.lineTo(960,330);g.lineStyle(1.5,0xe0ddc0,.9);g.moveTo(0,328);g.lineTo(960,328);g.lineStyle();
            for(var i:int=0;i<12;i++){g.beginFill(c);g.drawRect(i*80+2,335,76,15);g.endFill();g.lineStyle(1,dark(c));g.drawRect(i*80+2,335,76,15);g.lineStyle();ClassicInventorySkin.text(s,i%2?"HEROES":"APEX",i*80+3,335,74,15,8,0xffedb7,"center");}
        }
        private function banner(item:Object):void {
            var s:Sprite=part("banner",item),g:Graphics=s.graphics,c:uint=uint(item.accent);
            for(var i:int=0;i<6;i++){var xx:Number=12+i*160;g.lineStyle(1,0xfff4c9);ClassicInventorySkin.gradient(g,xx,337,145,15,c,dark(c),1);g.lineStyle();ClassicInventorySkin.text(s,i%2?"BASEBALL HEROES":"APEX",xx+3,337,139,15,8,0xfff2ce,"center");}
        }
        private function lights(item:Object):void {
            var s:Sprite=part("lights",item),g:Graphics=s.graphics,c:uint=uint(item.accent),rows:int=item.grade=="ELITE"||item.grade=="HERO"?3:2;
            for(var i:int=0;i<4;i++){
                var xx:Number=Number(rookieIllustration?[54,183,777,906][i]:[22,171,789,938][i]),yy:Number=rookieIllustration?(i==0||i==3?142:166):(i==0||i==3?211:176),bottom:Number=rookieIllustration?(i==0||i==3?214:250):319;
                g.lineStyle(4,0xb3c5bb);g.moveTo(xx,yy+18);g.lineTo(xx,bottom);g.lineStyle(1,0x526f69);
                for(var n:int=0;n<9;n++){var by:Number=yy+24+n*16;if(by+10>bottom)break;g.moveTo(xx-4,by);g.lineTo(xx+4,by+10);g.moveTo(xx+4,by);g.lineTo(xx-4,by+10);}g.lineStyle();
                g.lineStyle(2,0x38534f);ClassicInventorySkin.gradient(g,xx-30,yy-(rows-2)*4,60,22+(rows-2)*8,0xbcc9ae,0x6b8070,3);g.lineStyle();
                for(n=0;n<rows*6;n++){g.beginFill(c);g.drawEllipse(xx-26+(n%6)*9,yy+3+int(n/6)*7-(rows-2)*4,6.5,4.5);g.endFill();}
            }
        }
        private function scoreboard(item:Object):void {
            var s:Sprite=part("scoreboard",item),g:Graphics=s.graphics,c:uint=uint(item.accent),neon:Boolean=String(item.id).indexOf("neon")>=0;
            g.beginFill(0x122e2b,.45);g.drawRect(410,247,145,88);g.endFill();g.lineStyle(2,dark(c));ClassicInventorySkin.gradient(g,410,243,140,88,0xe4deae,c,3);g.lineStyle();
            g.beginFill(neon?0x142a40:0x223f27);g.drawRect(419,260,122,62);g.endFill();g.lineStyle(1,c);g.drawRect(423,263,114,31);g.lineStyle();
            ClassicInventorySkin.text(s,"BASEBALL",425,265,110,15,10,0xe6eaa0,"center");ClassicInventorySkin.text(s,"HEROES",425,279,110,16,12,neon?0x81f4ed:0xdce993,"center");
            for(var i:int=0;i<11;i++){g.beginFill(neon?0x7fe5e5:0xc4d78d,.8);g.drawRect(425+i*10,302,5,3);g.drawRect(425+i*10,310,5,3);g.endFill();}
            g.lineStyle(2,dark(c));g.beginFill(0xf2eed6);g.drawCircle(480,249,12);g.endFill();g.lineStyle(1.5,0x395d4c);g.moveTo(480,240);g.lineTo(480,249);g.lineTo(487,252);g.lineStyle();
            g.beginFill(0xc8d3b1);g.drawCircle(415,245,3);g.drawCircle(545,245,3);g.endFill();
        }
    }
}
