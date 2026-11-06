package com.bh.ui {
    import flash.display.*;import flash.text.*;import com.bh.model.GameData;
    /** Retained meter; only the countdown text changes each second. */
    public class LineupCardEnergy extends Sprite {
        public var cardId:String;private var lastEnergy:int=-1,field:TextField,w:Number;
        public function LineupCardEnergy(id:String,width:Number){cardId=id;w=width;mouseEnabled=mouseChildren=false;field=ClassicInventorySkin.text(this,"",17,-2,w-18,24,11,0xffffff,"center",true);field.name="special-energy-value";refresh();}
        public static function countdown(id:String):String {var s:Object=GameData.specialCardState(id);if(!s)return "0:00:00";var seconds:int=Math.max(0,Math.ceil((Number(s.rechargeAt)-new Date().time)/1000));return int(seconds/3600)+":"+(int(seconds/60)%60<10?"0":"")+int(seconds/60)%60+":"+(seconds%60<10?"0":"")+seconds%60;}
        public function refresh():Boolean {
            var energy:int=GameData.specialCardEnergy(cardId),changed:Boolean=energy!=lastEnergy;field.text=energy>0?energy+"/2":countdown(cardId);field.textColor=energy>0?0xffffff:0xd7dddc;
            if(changed){lastEnergy=energy;graphics.clear();graphics.lineStyle(1,energy>0?0x3b592a:0x435152);ClassicChrome.fill(graphics,1,1,w-2,18,energy>0?[0xb7e762,0x58ae1c,0x2b6e16]:[0x83908c,0x4c5f58,0x2d403b],[0,120,255],18);
                if(energy>0)ClassicChrome.fill(graphics,19,4,(w-22)*energy/2,6,[0xdfff9d,0x8dda28],[0,255],6);
                graphics.lineStyle(1,0x53695b);graphics.beginFill(energy>0?0xf6fbec:0xa0aaa5);graphics.drawCircle(10,9,9);graphics.endFill();graphics.lineStyle(1,0x66834f);graphics.moveTo(7,2);graphics.curveTo(13,7,7,16);graphics.lineStyle();graphics.beginFill(energy>0?0x92d627:0x667972);graphics.moveTo(13,5);graphics.lineTo(8,12);graphics.lineTo(12,12);graphics.lineTo(9,19);graphics.lineTo(18,9);graphics.lineTo(13,9);graphics.lineTo(16,5);graphics.endFill();}
            return changed;
        }
    }
}
