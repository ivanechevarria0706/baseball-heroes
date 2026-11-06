package com.bh.ui {
    import flash.display.Sprite;
    /** Shared shop navigation. Stadium purchases use the actual BUILD preview. */
    public class ShopScreen extends Sprite {
        private var w:Number,h:Number,onHome:Function,onBuild:Function,onInventory:Function;
        private var browser:Sprite;
        public function ShopScreen(width:Number,height:Number,homeCallback:Function,buildCallback:Function,inventoryCallback:Function=null) {
            w=width;h=height;onHome=homeCallback;onBuild=buildCallback;onInventory=inventoryCallback;
            name="classic-shop";showCategory("EQUIPMENT");
        }
        private function showCategory(category:String):void {
            if(category=="STADIUM"&&onBuild!=null){onBuild();return;}
            clearBrowser();
            browser=category=="ENERGY"?new EnergyShopScreen(w,h,onHome,onInventory,showCategory):new EquipmentScreen(w,h,onHome,null,true,onInventory,showCategory);
            addChild(browser);
        }
        private function clearBrowser():void {
            if(!browser)return;
            if(browser is EnergyShopScreen)EnergyShopScreen(browser).dispose();
            else if(browser is EquipmentScreen)EquipmentScreen(browser).dispose();
            if(browser.parent==this)removeChild(browser);browser=null;
        }
        public function dispose():void {clearBrowser();}
    }
}
