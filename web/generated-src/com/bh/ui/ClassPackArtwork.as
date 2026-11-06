package com.bh.ui {
    import flash.display.*;import flash.text.*;import flash.geom.Rectangle;import flash.filters.ColorMatrixFilter;
    import com.bh.model.*;import com.bh.visual.SpecialCardIllustration;import com.bh.visual.IllustratedSprite;
    /** Printed class-pack face, reconstructed from the supplied shop footage. */
    public class ClassPackArtwork extends Sprite {
        private static var gray:Object={}; // Four immutable printed portrait textures.
        private var art:SpecialCardIllustration;
        public function ClassPackArtwork(packClass:String,w:Number,h:Number) {
            mouseEnabled=mouseChildren=false;name="class-pack-art-"+packClass;
            var p:Object=SpecialCardCatalog.packById(packClass),cls:String=SpecialCardCatalog.normalizeClass(packClass),c:uint=p?uint(p.color):0x86bd35,g:Graphics=graphics;
            g.lineStyle(1.5,0x2a444e);ClassicChrome.fill(g,0,0,w,h,[0xf8ffff,0xb8c6ca,0x738b96],[0,160,255],6);g.lineStyle();
            ClassicChrome.fill(g,4,4,w-8,h-8,[0x1c363f,0x657578,0x273c44],[0,110,255],3);
            g.lineStyle(2,c);g.drawRect(5,5,w-10,h-10);g.lineStyle();
            var pane:Sprite=new Sprite();pane.x=w*.05;pane.y=h*.17;pane.scrollRect=new Rectangle(0,0,w*.90,h*.65);addChild(pane);
            var sample:Object={id:cls=="C"?"card_rookie_ace":cls=="B"?"card_kai_captain":cls=="A"?"card_leo_lucky":"card_axel_crown",name:"PACK",accent:c};
            art=new SpecialCardIllustration(sample);art.scaleX=art.scaleY=Math.min(w*.94/124,h*.72/113);art.x=(w*.9-124*art.scaleX)/2;art.y=h*.01;var figure:IllustratedSprite=art.getChildAt(0) as IllustratedSprite;
            if(figure){var bitmap:Bitmap=figure.getChildAt(0) as Bitmap;if(bitmap){if(!gray[cls]){var ink:BitmapData=bitmap.bitmapData.clone(),colors:Vector.<uint>=ink.getVector(ink.rect);for(var k:int=0;k<colors.length;k++){var pixel:uint=colors[k],shade:int=int(((pixel>>16)&255)*.299+((pixel>>8)&255)*.587+(pixel&255)*.114);colors[k]=(pixel&0xff000000)|(shade<<16)|(shade<<8)|shade;}ink.setVector(ink.rect,colors);gray[cls]=ink;}bitmap.bitmapData=gray[cls];}}
            pane.addChild(art);
            var head:String=p&&p.unlockLeague>0?SpecialCardCatalog.packLeagueName(p.unlockLeague):"BASEBALL HEROES";
            title(head,3,2,w-6,h*.19,Math.max(9,int(w*.11)),0xffe480);
            g.lineStyle(1,0x3b541e);ClassicChrome.fill(g,w*.07,h*.71,w*.27,h*.22,[0xe6ffb7,c,0x375724],[0,130,255],4);g.lineStyle();
            title(cls,w*.07,h*.69,w*.27,h*.26,Math.max(16,int(w*.26)),0xffffff);
            var grades:Array=[];if(p)for each(var grade:String in p.grades)grades.push(SpecialCardCatalog.gradeLabel(grade));
            if(packClass=="C"&&GameData.tutorialActive()&&GameData.careerStartVersion>=4&&int(GameData.starterTutorial.stage)<=StarterTutorial.CARD)grades=["NORMAL","HERO"];
            grades.reverse();var t:TextField=new TextField();t.text=grades.join("\n");t.x=w*.37;t.y=h*.58;t.width=w*.57;t.height=h*.36;t.multiline=true;t.selectable=t.mouseEnabled=false;LineupTypography.fit(t,Math.max(8,int(w*.09)),0xffffff,"right",false,6);addChild(t);
            g.lineStyle(1,0xffffff,.55);g.moveTo(8,2);g.lineTo(w-8,2);g.lineStyle();
        }
        private function title(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):void {var t:TextField=new TextField();t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=t.mouseEnabled=false;ClassicChrome.title(t,size,color);addChild(t);}
        public function dispose():void {if(art){art.dispose();art=null;}}
    }
}
