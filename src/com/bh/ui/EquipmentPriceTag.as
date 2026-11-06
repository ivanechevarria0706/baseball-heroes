package com.bh.ui {
    import flash.display.Sprite;import flash.text.TextField;import com.bh.model.GameData;
    /** Coin prices use orange; premium prices use green, as in the reference shop. */
    public class EquipmentPriceTag extends Sprite {
        public var currency:String,labelText:String;
        public function EquipmentPriceTag(item:Object,state:String,showCost:Boolean,enabled:Boolean=true,applied:Boolean=false,w:Number=108,h:Number=23) {
            mouseEnabled=mouseChildren=false;currency=showCost?(int(item.cashPrice)>0?'CASH':'COINS'):'STATE';
            var premium:Boolean=currency=='CASH',top:uint=enabled?(applied?0x89dbef:showCost&&!premium?0xffe478:0xb8f180):0xd8dcd8,bottom:uint=enabled?(applied?0x1790c5:showCost&&!premium?0xe9a226:0x69aa31):0x969f9b;
            graphics.lineStyle(1.2,0x284838);ClassicInventorySkin.gradient(graphics,0,0,w,h,top,bottom,h);graphics.lineStyle(1,0xf5ffe7);graphics.drawRoundRect(2,2,w-4,h-4,h-3);graphics.lineStyle();
            if(showCost){var icon:Sprite=ClassicInventorySkin.icon(this,premium?'cash':'coin',6,3,.54);icon.alpha=enabled?1:.55;labelText=GameData.shopPriceLabel(item).replace(/^[C$] /,'');}
            else labelText=state;
            var t:TextField=ClassicInventorySkin.text(this,labelText,showCost?24:3,1,showCost?w-29:w-6,h-1,showCost?12:10,applied?0xffffff:enabled?0x534c20:0x515d56,'center');t.name='equipment-price-value';
        }
    }
}
