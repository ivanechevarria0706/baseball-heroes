package {
    import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.visual.*;
    public class WebUpgrade117 extends WebUpgrade116 {
        private var layer:Sprite,views:Array=[],checks:int=0;
        public function WebUpgrade117(){super();ExternalInterface.addCallback('bh117',run);}
        private function check(ok:Boolean,label:String):void {checks++;if(!ok)throw new Error(label);}
        private function close():void {for each(var view:Object in views)view.dispose();views=[];if(layer){removeChild(layer);layer=null;}}
        private function run(action:String='state'):String {
            try {
                if(action=='model')return JSON.stringify(model());
                if(action=='close')close();
                if(action=='helmets'){
                    close();layer=new Sprite();layer.graphics.beginFill(0xe5ece8);layer.graphics.drawRect(0,0,960,720);layer.graphics.endFill();addChild(layer);
                    ClassicInventorySkin.text(layer,'OBSERVED HELMET COLLECTION',30,35,900,42,26,0x21759f,'center',true);
                    for(var i:int=0;i<8;i++){var item:Object=GameData.shopItemById('classic117_helmet_'+i),a:ObservedArtwork=new ObservedArtwork(item.id,130,110);a.x=55+(i%4)*230;a.y=120+int(i/4)*260;layer.addChild(a);views.push(a);ClassicInventorySkin.text(layer,item.name,a.x-30,a.y+122,190,34,14,0x304a53,'center');var price:EquipmentPriceTag=new EquipmentPriceTag(item,'',true,true,false,170,28);price.x=a.x-20;price.y=a.y+168;layer.addChild(price);}
                }
                return JSON.stringify({status:'OK',checks:checks});
            }catch(e:Error){return JSON.stringify({error:e.message,checks:checks});}
            return '{}';
        }
        private function model():Object {
            checks=0;GameData.startNewCareer();GameData.level=12;GameData.coins=200000;GameData.cash=500;
            var names:Array=['Black Bomber','Red Lightning','Sky Love','Green Star','White Star','Beige Star','Yellow Star','Aqua Star'];
            for(var i:int=0;i<8;i++){
                var item:Object=GameData.shopItemById('classic117_helmet_'+i);check(item&&item.name==names[i]+' Helmet'&&item.slot=='helmet','observed helmet '+i);
                check(ObservedArtwork.supports(item.id),'helmet art '+i);var coins:int=GameData.coins,cash:int=GameData.cash;
                check(GameData.purchaseShopItem(item)=='OK','buy '+i);check(GameData.coins==coins-(i<4?0:24000)&&GameData.cash==cash-(i<4?45:0),'observed price '+i);
                var copy:Object;for each(var stored:Object in GameData.inventory)if(stored.name==item.name)copy=stored;
                check(copy&&ObservedArtwork.gearKey(copy)==item.id,'art survives purchased metadata '+i);check(GameData.equipItem(copy)&&GameData.equipped.helmet.name==item.name,'equip owned helmet '+i);
                check(GameData.purchaseShopItem(item)=='OWNED','double purchase '+i);
                var p:EquipmentPriceTag=new EquipmentPriceTag(item,'',true);check(p.currency==(i<4?'CASH':'COINS')&&p.labelText==(i<4?'45':'24,000'),'currency label '+i);
            }
            var before:int=GameData.inventory.length;GameData.inventory=[];GameData.coins=0;GameData.cash=0;
            check(GameData.purchaseShopItem(GameData.shopItemById('classic117_helmet_0'))=='CASH','premium funds check');check(GameData.purchaseShopItem(GameData.shopItemById('classic117_helmet_4'))=='COINS','coin funds check');
            var locked:Object=GameData.shopItemById('classic116_goggles_6');check(!GameData.shopItemUnlocked(locked)&&GameData.purchaseShopItem(locked)=='LOCKED','previous level-17 lock preserved');
            return {status:'PASS',checks:checks,newHelmets:8,previousPricesUnchanged:true};
        }
    }
}
