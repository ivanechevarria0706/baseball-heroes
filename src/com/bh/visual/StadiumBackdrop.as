package com.bh.visual {
    import flash.display.Sprite;
    /** Alternate screens share the same stadium camera and placement transform. */
    public class StadiumBackdrop extends Sprite {
        private var stadium:MatchStadium;
        public function StadiumBackdrop(w:Number,h:Number,decorations:Boolean=true){
            mouseEnabled=mouseChildren=false;stadium=new MatchStadium(w,h,null,decorations);addChild(stadium);
        }
        public function dispose():void {if(stadium){stadium.dispose();removeChild(stadium);stadium=null;}}
    }
}
