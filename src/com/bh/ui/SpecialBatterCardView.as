package com.bh.ui {
    import flash.display.Sprite;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;
    import com.bh.model.GameData;
    import com.bh.visual.SpecialCardIllustration;
    import com.bh.visual.ObservedArtwork;

    /** Portrait card composition from the supplied video at 03:12.
     * Artwork and card rules remain the current local catalog's approximations.
     */
    public class SpecialBatterCardView extends Sprite {
        public var data:Object;
        private var face:Sprite=new Sprite();
        private var portrait:SpecialCardIllustration;
        private var labels:Sprite=new Sprite();
        private var selected:Boolean=false;
        public function SpecialBatterCardView(cardData:Object,w:Number=140,h:Number=220) {
            data=cardData;buttonMode=true;useHandCursor=true;mouseChildren=false;
            face.scaleX=face.scaleY=Math.min(w/140,h/208);
            face.x=(w-140*face.scaleX)/2;face.y=(h-208*face.scaleY)/2;addChild(face);
            portrait=new SpecialCardIllustration(data);
            var observed:Boolean=ObservedArtwork.supports(data.catalogId?String(data.catalogId):String(data.id));
            portrait.x=observed?4:-7;portrait.y=observed?19:24;portrait.scaleX=portrait.scaleY=observed?1.06:1.24;face.addChild(portrait);face.addChild(labels);
            draw();
        }
        private function draw():void {
            var hero:Boolean=data.grade=="HERO",owned:Boolean=GameData.ownsSpecialCard(String(data.id));
            var color:uint=data.cardClass=="C"?0x80ce1f:data.cardClass=="B"?0x34b3e7:data.cardClass=="A"?0xffc829:0xed633d;
            face.scrollRect=new flash.geom.Rectangle(0,0,140,208);
            face.graphics.clear();face.graphics.lineStyle(2,selected?0xffdb38:0x151e24);
            face.graphics.beginFill(hero?0x3c3c3b:0xe1e5e4);face.graphics.drawRoundRect(0,0,140,208,3,3);face.graphics.endFill();
            var m:Matrix=new Matrix();m.createGradientBox(132,165,Math.PI/2,4,19);
            face.graphics.lineStyle();face.graphics.beginGradientFill(GradientType.LINEAR,[color,0x164a56],[1,1],[0,255],m);face.graphics.drawRect(4,19,132,165);face.graphics.endFill();
            face.graphics.beginFill(hero?0x27292a:0xf8fbf6);face.graphics.drawRect(3,3,134,15);face.graphics.endFill();
            labels.graphics.clear();
            labels.graphics.beginFill(0x0e1920,.70);labels.graphics.drawRect(4,132,132,51);labels.graphics.endFill();
            labels.graphics.beginFill(hero?0x242626:0xcbd0d0);labels.graphics.drawRect(4,184,132,20);labels.graphics.endFill();
            while(labels.numChildren)labels.removeChildAt(0);
            label(String(data.name),4,2,132,17,11,hero?0xffffff:0x273c45,"center");
            // The original class, stars and grade are already in the observed video window.
            if(!ObservedArtwork.supports(data.catalogId?String(data.catalogId):String(data.id))){
            labels.graphics.lineStyle(1.5,0x203e1a);ClassicChrome.fill(labels.graphics,9,23,30,34,[0xe8ffd0,color,0x356721],[0,95,255],8);labels.graphics.lineStyle();
            var cls:TextField=label(String(data.cardClass),9,21,30,36,25,0xffffff,"center");cls.name="special-card-class";LineupTypography.apply(cls,25,0xffffff,"center",true);cls.filters=[new GlowFilter(0x183414,1,2,2,5)];
            var count:int=hero?3:data.grade=="ELITE"?3:data.grade=="RARE"?2:1;
            for(var i:int=0;i<count;i++)star(93+i*10,25,4,0xffd22a);
            label(String(data.grade=="A"?"NORM":data.grade),76,30,57,20,12,hero?0xffe241:0xffffff,"right").filters=[new GlowFilter(0x0f3140,1,2,2,5)];
            }
            var enhancement:int=owned?GameData.specialCardLevel(String(data.id))-1:0;
            label("AVG ."+data.avg,8,134,121,16,11,0xffffff,"left");
            if(enhancement>0)label("+"+enhancement,100,133,33,18,13,0xff6861,"right").filters=[new GlowFilter(0x52201c,1,2,2,4)];
            label(GameData.specialAbilityLabel(data),8,150,125,16,10,0xffd062,"left");
            label("Combo +"+int(data.combo),8,165,125,15,10,0xffffff,"left");
            if(owned) {
                labels.graphics.lineStyle(1,0x727f82);labels.graphics.beginFill(0xe5eeee);labels.graphics.drawCircle(52,194,6);labels.graphics.endFill();
                labels.graphics.lineStyle(1,0x659c35);labels.graphics.moveTo(48,190);labels.graphics.curveTo(54,192,49,198);labels.graphics.lineStyle();
                label(GameData.specialCardEnergy(String(data.id))+"/2",63,186,40,20,12,hero?0xffffff:0x253e40,"left");
            } else label("NOT OWNED",9,186,121,20,10,0x5d7075,"center");
            if(owned&&GameData.isSpecialCardEquipped(String(data.id)))label("★",117,182,19,21,14,0xffd54b,"center");
            filters=selected?[new GlowFilter(0xffd944,.85,5,5,2)]:[];
        }
        private function star(cx:Number,cy:Number,r:Number,color:uint):void {
            labels.graphics.lineStyle(.5,0x666137);labels.graphics.beginFill(color);
            for(var i:int=0;i<10;i++){var angle:Number=-Math.PI/2+i*Math.PI/5,rr:Number=i%2==0?r:r*.45;var x:Number=cx+Math.cos(angle)*rr,y:Number=cy+Math.sin(angle)*rr;if(i==0)labels.graphics.moveTo(x,y);else labels.graphics.lineTo(x,y);}
            labels.graphics.endFill();labels.graphics.lineStyle();
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String):TextField {
            var t:TextField=new TextField();var f:TextFormat=new TextFormat("Arial",size,color,true);f.align=align;
            t.defaultTextFormat=f;t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=false;t.mouseEnabled=false;
            labels.addChild(t);return t;
        }
        public function setSelected(value:Boolean):void {selected=value;draw();}
        public function refresh():void {draw();}
        public function dispose():void {if(portrait){portrait.dispose();portrait=null;}}
    }
}
