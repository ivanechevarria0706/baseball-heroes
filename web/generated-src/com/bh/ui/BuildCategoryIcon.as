package com.bh.ui {
    import flash.display.Sprite;
    import com.bh.visual.BuildArtwork;
    /** Illustrated category symbols, with the previous centered anchor and hit area. */
    public class BuildCategoryIcon extends Sprite {
        public function BuildCategoryIcon(kind:String,color:uint=0x42a1bc){
            mouseEnabled=mouseChildren=false;
            var key:String="category_"+kind;
            if(!BuildArtwork.supports(key))key="category_decoration";
            var art:BuildArtwork=new BuildArtwork(key,66,50);art.x=-33;art.y=-25;addChild(art);
        }
    }
}
