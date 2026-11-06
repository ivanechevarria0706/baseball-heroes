package {
    import flash.display.*;import flash.events.*;import flash.geom.*;import flash.filesystem.*;import flash.desktop.NativeApplication;import flash.utils.*;
    import com.bh.model.*;import com.bh.ui.*;
    public class InventoryShop063Smoke extends Sprite {
        private var screen:SpecialCardsScreen,initial:int,coins:int;
        public function InventoryShop063Smoke(){
            stage.scaleMode="noScale";stage.align="TL";
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish("FAIL: "+e.error,1);});
            GameData.init();GameData.specialOwned={};GameData.specialEquipped=[null,null,null,null,null];GameData.specialMatch=null;GameData.specialSlotsUnlocked=5;GameData.coins=100000;
            for each(var c:Object in GameData.specialCardCatalog())GameData.specialOwned[c.id]=SpecialCardInventory.fresh(c.id,c.id);
            screen=new SpecialCardsScreen(960,720,function():void{});addChild(screen);setTimeout(grid,600);
        }
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var r:DisplayObject=find(d as DisplayObjectContainer,id);if(r)return r;}}return null;}
        private function click(id:String):void{var d:DisplayObject=find(screen,id);check(d!=null,"Missing "+id);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function cards(c:DisplayObjectContainer,out:Array):void{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is SpecialBatterCardView&&d.name.indexOf("collection_card_")==0)out.push(d);else if(d is DisplayObjectContainer)cards(d as DisplayObjectContainer,out);}}
        private function grid():void {
            try {
                var seen:Object={},all:Array=GameData.ownedSpecialCards();
                for(var page:int=0;page<6;page++) {
                    var visible:Array=[];cards(screen,visible);check(visible.length<=6,"Grid overflow");
                    for each(var v:SpecialBatterCardView in visible){var face:DisplayObject=v.getChildAt(0),clip:Rectangle=face.scrollRect;check(clip!=null,"Card portrait is not clipped");var tl:Point=screen.globalToLocal(face.localToGlobal(clip.topLeft)),br:Point=screen.globalToLocal(face.localToGlobal(clip.bottomRight));check(tl.x>=165&&br.x<=519&&tl.y>=210&&br.y<=544,"Visible card overlaps grid/footer "+tl+" / "+br);seen[v.data.id]=true;}
                    if(page<5)click("collection_next");
                }
                for each(var c:Object in all)check(seen[c.id],"Unreachable copy "+c.id);
                var last:Object=all[all.length-1];click("collection_card_"+last.id);click("card_equip");check(GameData.isSpecialCardEquipped(last.id),"Last page equip failed");
                initial=GameData.ownedSpecialCards().length;coins=GameData.coins;click("batter_shop_open");setTimeout(buy,700);
            }catch(e:Error){finish("FAIL: "+e.message,1);}
        }
        private function buy():void {
            var b:DisplayObject=find(screen,"pack_class_C");check(b!=null,"Shop unavailable");b.dispatchEvent(new MouseEvent(MouseEvent.CLICK));b.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            check(GameData.coins==coins-6000&&GameData.ownedSpecialCards().length==initial+1,"Pack charged/granted twice");
            stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));setTimeout(revealed,700);
        }
        private function revealed():void {
            check(GameData.lastSpecialDraw&&find(screen,"collection_card_"+GameData.lastSpecialDraw.card.id)!=null,"Purchased instance not selected / callback failed");
            stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,13));click("shop_close");
            check(!find(screen,"shop_close"),"Shop cannot close");screen.dispose();
            finish("PASS: 33 cards reachable across six pages; every card fits inside reference grid without covering footer; last-page equip; shop opens, one 6000-coin purchase, repeated input ignored, reveal callback selects actual new instance, ENTER and close work.",0);
        }
        private function finish(value:String,code:int):void{var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/smoke-inventory-shop063.txt");f.parent.createDirectory();var out:FileStream=new FileStream();out.open(f,FileMode.WRITE);out.writeUTFBytes(value);out.close();NativeApplication.nativeApplication.exit(code);}
    }
}
