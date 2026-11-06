package com.bh.ui {
    import flash.display.Sprite;
    import com.bh.visual.BuildArtwork;
    import com.bh.visual.TeamLogoView;

    public class StadiumDecorationView extends Sprite {
        public var data:Object;
        public var decorationIndex:int;
        private var selected:Boolean=false,badge:TeamLogoView,art:BuildArtwork;

        public function StadiumDecorationView(item:Object,index:int){
            data=item;decorationIndex=index;buttonMode=useHandCursor=true;mouseChildren=false;
            if(item&&item.city){
                badge=new TeamLogoView(String(item.city),uint(item.accent),"",60);badge.x=-30;badge.y=-48;addChild(badge);
            }else{
                var key:String="prop_flag",id:String=item?String(item.id):"";
                for each(var kind:String in ["flag","star","ball","trophy","fireworks"])if(id.indexOf(kind)>=0){key="prop_"+kind;break;}
                art=new BuildArtwork(key,60,68);art.x=-30;art.y=-43;addChild(art);
            }
            draw();
        }
        public function setSelected(value:Boolean):void {selected=value;draw();}
        private function draw():void {
            graphics.clear();
            if(selected){
                graphics.lineStyle(2,0xffe36d,.95);
                if(badge)graphics.drawCircle(0,0,27);else graphics.drawRoundRect(-34,-47,68,76,8);
                graphics.lineStyle();
            }
            if(badge){
                graphics.lineStyle(4,0xc3cbd1);graphics.moveTo(0,10);graphics.lineTo(0,25);
                graphics.lineStyle(7,0x64717a);graphics.moveTo(-17,25);graphics.lineTo(17,25);graphics.lineStyle();
            }
        }
        public function dispose():void {
            if(badge){badge.dispose();removeChild(badge);badge=null;}
            if(art){removeChild(art);art=null;}
        }
    }
}
