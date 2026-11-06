package com.bh.ui {
    import flash.display.Sprite;
    import com.bh.visual.ObservedArtwork;
    import com.bh.visual.InterfaceSprite;
    import com.bh.visual.GearArtwork;
    import com.bh.visual.GearPieceArtwork;
    /** Shared illustrated accessory, centred like the former native fallback. */
    public class BasicGearIcon extends Sprite {
        public function BasicGearIcon(item:Object){
            mouseEnabled=mouseChildren=false;
            var slot:String=item&&item.slot?String(item.slot):"glove",key:String=ObservedArtwork.gearKey(item),art:Sprite;
            if(key!=""){art=new ObservedArtwork(key,68,64);art.x=-34;art.y=-32;}
            else if(item&&GearPieceArtwork.supports(String(item.name)))art=new GearPieceArtwork(String(item.name),slot,64);
            else if(slot=="bat")art=new GearArtwork(item?String(item.name):"Rookie Bat",64);
            else {art=new InterfaceSprite("gear_"+slot,60,60);art.x=art.y=-30;}
            addChild(art);
        }
    }
}
