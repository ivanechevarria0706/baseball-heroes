package com.bh.visual {
    import flash.display.*;import com.bh.model.GameData;
    /** The creator displays the very same modular actor as HOME. */
    public class CreationArtwork extends Sprite {
        private var actor:HeroSprite,head:HeroHead;
        public function CreationArtwork(a:Object,accent:uint,trait:String="",number:int=32,previewTab:String="") {
            mouseEnabled=mouseChildren=false;
            if(!trait){graphics.beginFill(0,.18);graphics.drawEllipse(-56,215,120,14);graphics.endFill();actor=new HeroSprite("Hero",accent,a,"home",1.1,GameData.equipped,int(a.artVersion)<1&&previewTab!="HAIR");actor.y=217;addChild(actor);}
            else {var palette:Object=HomeSprite.paletteFor("Hero",accent,a,{});head=new HeroHead(a,palette,trait);head.y=50;addChild(head);}
        }
        public function dispose():void {if(actor)actor.dispose();if(head)head.dispose();}
    }
}
