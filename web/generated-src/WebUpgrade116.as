package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.visual.*;import com.bh.game.SpecialAbilityResolver;
    public class WebUpgrade116 extends WebAutoplay115 {
        private var layer:Sprite,views:Array=[],checks:int=0;
        public function WebUpgrade116(){super();ExternalInterface.addCallback('bh116',run);}
        private function check(ok:Boolean,label:String):void {checks++;if(!ok)throw new Error(label);}
        private function close():void {for each(var view:Object in views)view.dispose();views=[];if(layer){removeChild(layer);layer=null;}}
        private function canvas():void {close();layer=new Sprite();layer.graphics.beginFill(0xe5ece8);layer.graphics.drawRect(0,0,960,720);layer.graphics.endFill();addChild(layer);}
        private function run(action:String='state',value:String=''):String {
            try {
                if(action=='model')return JSON.stringify(model());
                if(action=='close')close();
                if(action=='cards'){
                    canvas();var i:int=0;for each(var card:Object in GameData.specialCardCatalog())if(ObservedArtwork.supports(String(card.id))){var c:SpecialBatterCardView=new SpecialBatterCardView(card,126,208);c.x=24+i*133;c.y=95;layer.addChild(c);views.push(c);i++;}
                    ClassicInventorySkin.text(layer,'OBSERVED SPECIAL BATTERS',40,30,880,40,26,0x1a669a,'center',true);
                }
                if(action=='gear'){
                    canvas();i=0;for each(var item:Object in EquipmentCatalog.items())if(ObservedArtwork.supports(String(item.id))){var art:ObservedArtwork=new ObservedArtwork(item.id,70,60);art.x=24+(i%8)*117;art.y=20+int(i/8)*136;layer.addChild(art);views.push(art);ClassicInventorySkin.text(layer,String(item.name),art.x-8,art.y+62,102,36,11,0x244954,'center');ClassicInventorySkin.text(layer,GameData.shopPriceLabel(item),art.x-8,art.y+103,102,24,11,0x957326,'center');i++;}
                }
                if(action=='shop'){
                    close();layer=new Sprite();addChild(layer);GameData.level=12;GameData.coins=100000;GameData.cash=1000;GameData.specialMatch=null;
                    var screen:EquipmentScreen=new EquipmentScreen(960,720,function():void{},function():void{},true,function():void{});layer.addChild(screen);views.push(screen);
                }
                return JSON.stringify({status:'OK',checks:checks});
            }catch(e:Error){return JSON.stringify({error:e.message,checks:checks});}
            return '{}';
        }
        private function model():Object {
            checks=0;var ids:Array=['howard_d','billie_k','marvin_k','garret_d','john_g','darren_s','benny_c'],avgs:Array=[305,298,282,282,281,277,339],innings:Array=[9,4,8,8,7,3,4],chances:Array=[.65,.65,.5,.5,.5,.5,.8];
            for(var i:int=0;i<ids.length;i++){
                var id:String='card_'+ids[i],c:Object=SpecialCardInventory.catalog(id);check(c&&c.avg==avgs[i]&&c.combo==1&&c.triggerInning==innings[i],'observed profile '+id);check(GameData.specialAbilityChance(c)==chances[i],'ability '+id);
                var resolver:SpecialAbilityResolver=new SpecialAbilityResolver(function():Number{return 0;});check(resolver.resolve(c,1)=='','no early inning '+id);check(resolver.resolve(c,innings[i])==c.guaranteedHit&&resolver.resolve(c,innings[i])=='','one ability attempt '+id);
                var state:Object=SpecialCardInventory.fresh('qa116_'+i,id);state.enhancement=2;var owned:Object=SpecialCardInventory.describe(state.instanceId,state);check(owned.catalogId==id&&owned.avg==avgs[i]+20,'enhanced instance '+id);
                var a:ObservedArtwork=new ObservedArtwork(id,124,113);check(a.numChildren==1,'observed art '+id);a.dispose();
            }
            var all:Array=EquipmentCatalog.items(),count:int=0;GameData.level=12;GameData.coins=1000000;GameData.cash=10000;GameData.specialMatch=null;
            for each(var item:Object in all)if(String(item.id).indexOf('classic116_')==0){
                count++;check(ObservedArtwork.supports(item.id),'gear art '+item.id);var coins:int=GameData.coins,cash:int=GameData.cash;
                if(int(item.unlockLevel)>12){check(!GameData.shopItemUnlocked(item)&&GameData.purchaseShopItem(item)=='LOCKED','observed level lock '+item.id);GameData.level=17;}
                check(GameData.purchaseShopItem(item)=='OK','buy '+item.id);check(GameData.coins==coins-int(item.coinPrice)&&GameData.cash==cash-int(item.cashPrice),'exact cost '+item.id);
                check(GameData.purchaseShopItem(item)=='OWNED','no duplicate purchase '+item.id);var copy:Object;for each(var stored:Object in GameData.inventory)if(stored.name==item.name)copy=stored;check(copy&&ObservedArtwork.gearKey(copy)==item.id,'owned art survives stripped metadata '+item.id);check(GameData.equipItem(item),'equip '+item.id);check(GameData.equipped[item.slot].id==item.id,'equipped identity '+item.id);GameData.level=12;
            }
            check(count==32,'32 observed equipment entries');check(GameData.specialCardCatalog().length==40,'additive 40-card catalogue');
            var poor:Object=GameData.shopItemById('classic116_bat_4');GameData.coins=0;GameData.cash=0;GameData.inventory=[];check(GameData.purchaseShopItem(poor)=='COINS','insufficient funds unchanged');
            return {status:'PASS',checks:checks,observedCards:7,newGear:count};
        }
    }
}
