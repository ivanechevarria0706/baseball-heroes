package com.bh.ui {
    import flash.display.*;import flash.geom.*;import com.bh.visual.AssetImage;
    /** Diagonal paper fold, timed by its owner; it never awards or draws cards. */
    public class CardPeelReveal extends Sprite {
        private var card:SpecialBatterCardView,cover:Sprite,cardMask:Shape=new Shape(),coverMask:Shape=new Shape(),fold:Shape=new Shape();
        private var w:Number,h:Number;
        public function CardPeelReveal(view:SpecialBatterCardView,packClass:String,width:Number,height:Number,assetPath:String="") {
            name="card-peel";mouseEnabled=mouseChildren=false;w=width;h=height;card=view;card.x=card.y=0;addChild(card);
            cover=assetPath?new AssetImage(assetPath,w,h,AssetImage.CONTAIN):new ClassPackArtwork(packClass,w,h);cover.name="pack-cover";addChild(cover);
            cardMask.name="revealed-mask";coverMask.name="sealed-mask";addChild(cardMask);addChild(coverMask);card.mask=cardMask;cover.mask=coverMask;
            fold.name="paper-fold";addChild(fold);progress(0);
        }
        private function clip(points:Array,cut:Number,low:Boolean):Array {
            var out:Array=[];if(!points.length)return out;var previous:Point=points[points.length-1],insideBefore:Boolean=low?previous.x+previous.y<=cut:previous.x+previous.y>=cut;
            for each(var current:Point in points){var inside:Boolean=low?current.x+current.y<=cut:current.x+current.y>=cut;
                if(inside!=insideBefore){var a:Number=(cut-previous.x-previous.y)/(current.x+current.y-previous.x-previous.y);out.push(new Point(previous.x+(current.x-previous.x)*a,previous.y+(current.y-previous.y)*a));}
                if(inside)out.push(current);previous=current;insideBefore=inside;
            }return out;
        }
        private function polygon(g:Graphics,points:Array):void {if(!points.length)return;g.moveTo(points[0].x,points[0].y);for(var i:int=1;i<points.length;i++)g.lineTo(points[i].x,points[i].y);g.lineTo(points[0].x,points[0].y);}
        public function progress(value:Number):void {
            var p:Number=Math.max(0,Math.min(1,value)),cut:Number=(w+h)*p,rect:Array=[new Point(0,0),new Point(w,0),new Point(w,h),new Point(0,h)];
            card.mask=cardMask;cover.mask=coverMask;cardMask.visible=coverMask.visible=true;
            cardMask.graphics.clear();cardMask.graphics.beginFill(0xffffff);polygon(cardMask.graphics,clip(rect,cut,true));cardMask.graphics.endFill();
            coverMask.graphics.clear();coverMask.graphics.beginFill(0xffffff);polygon(coverMask.graphics,clip(rect,cut,false));coverMask.graphics.endFill();
            var g:Graphics=fold.graphics;g.clear();if(p>0&&p<1){var band:Array=clip(clip(rect,cut,false),cut+Math.sin(p*Math.PI)*31,true),m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI/4);g.lineStyle(.7,0x82979d,.6);g.beginGradientFill(GradientType.LINEAR,[0xf9ffff,0xdce7e9,0xffffff],[1,1,1],[0,120,255],m);polygon(g,band);g.endFill();}
            cover.visible=p<1;if(p>=1){card.mask=null;cover.mask=null;cardMask.visible=coverMask.visible=false;}
        }
        public function dispose():void {card.mask=null;cover.mask=null;card.dispose();Object(cover).dispose();fold.graphics.clear();}
    }
}
