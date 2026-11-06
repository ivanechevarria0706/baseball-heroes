package {
    import flash.display.*;
    import flash.events.*;
    import flash.text.TextField;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.utils.setTimeout;
    import flash.geom.Rectangle;
    import com.bh.model.GameData;
    import com.bh.ui.*;
    public class CardSmoke extends Sprite {
        private var shop:BatterShopOverlay;
        private var collection:SpecialCardsScreen;
        private var updates:int=0;
        private var closed:int=0;
        private var checks:Array=[];
        public function CardSmoke() {
            stage.scaleMode="noScale";stage.align="TL";
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{
                e.preventDefault();write("FAIL: "+e.error);NativeApplication.nativeApplication.exit(1);
            });
            GameData.init();GameData.coins=100000;GameData.cash=100;
            shop=new BatterShopOverlay(function():void{closed++;},function(card:Object):void{updates++;});addChild(shop);
            setTimeout(buy,700);
        }
        private function find(c:DisplayObjectContainer,n:String):Sprite {
            for(var i:int=0;i<c.numChildren;i++){
                var ch:DisplayObject=c.getChildAt(i);if(ch.name==n)return ch as Sprite;
                if(ch is DisplayObjectContainer){var f:Sprite=find(ch as DisplayObjectContainer,n);if(f)return f;}
            }return null;
        }
        private function textOf(c:DisplayObjectContainer):String {
            var value:String="";for(var i:int=0;i<c.numChildren;i++){
                var ch:DisplayObject=c.getChildAt(i);if(ch is TextField)value+=TextField(ch).text;
                else if(ch is DisplayObjectContainer)value+=textOf(ch as DisplayObjectContainer);
            }return value;
        }
        private function countCopies():int {var total:int=0;for each(var c:Object in GameData.ownedSpecialCards())total+=1+GameData.specialCardCopies(c.id);return total;}
        private function buy():void {
            shot(shop,"shop");var p:Sprite=find(shop,"pack_class_C");var before:int=countCopies();
            GameData.coins=0;p.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(GameData.coins!=0||countCopies()!=before)throw new Error("Insufficient funds changed balance/inventory");
            GameData.coins=100000;
            p.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            p.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(GameData.coins!=94000||countCopies()!=before+1)throw new Error("Purchase charged or granted more than once");
            shot(shop,"sealed");
            stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));
            stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));
            setTimeout(function():void{
                shot(shop,"revealed");
                if(updates!=1)throw new Error("Duplicate reveal callback");
                stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,13));
                if(GameData.coins!=94000)throw new Error("Keyboard confirmation charged again");
                find(shop,"shop_close").dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                if(closed!=1)throw new Error("Shop failed to close after keyboard confirmation");
                shop.dispose();removeChild(shop);
                checks.push("PASS: insufficient funds do not grant a card; one charge/grant; repeated input ignored during reveal; SPACE opens; ENTER confirms; shop closes.");
                showCollection();
            },550);
        }
        private function showCollection():void {
            GameData.specialOwned={};GameData.specialEquipped=[null,null,null,null,null];GameData.specialSlotsUnlocked=5;
            for each(var c:Object in GameData.specialCardCatalog())GameData.specialOwned[c.id]={level:1,copies:0,atBats:0,hits:0,rbi:0};
            GameData.specialCombo();
            collection=new SpecialCardsScreen(960,540,function():void{});addChild(collection);
            setTimeout(function():void{
                shot(collection,"collection-first");
                var all:Array=GameData.ownedSpecialCards();var seen:Object={};
                var pages:int=Math.ceil(all.length/5);
                for(var page:int=0;page<pages;page++){
                    var visible:Array=[];gatherCards(collection,visible);
                    if(visible.length>5)throw new Error("Collection overflows page");
                    for each(var v:SpecialBatterCardView in visible){
                        var b:Rectangle=v.getBounds(collection);
                        if(b.bottom>425||b.right>630)throw new Error("Card overlaps controls");
                        seen[v.data.id]=true;
                    }
                    if(page<pages-1)find(collection,"collection_next").dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                }
                var last:Object=all[all.length-1];
                find(collection,"collection_card_"+last.id).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                for(var i:int=0;i<collection.numChildren;i++){
                    var button:UIButton=collection.getChildAt(i) as UIButton;
                    if(button&&textOf(button)=="EQUIP")button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                }
                if(!GameData.isSpecialCardEquipped(last.id))throw new Error("Last page card did not equip");
                for each(c in all)if(!seen[c.id])throw new Error("Unreachable collection card");
                shot(collection,"collection-last");collection.dispose();removeChild(collection);
                checks.push("PASS: all "+all.length+" cards reachable over "+pages+" pages; bounds fit; last-page selection/equip works.");
                write(checks.join("\n"));NativeApplication.nativeApplication.exit();
            },700);
        }
        private function gatherCards(c:DisplayObjectContainer,out:Array):void {
            for(var i:int=0;i<c.numChildren;i++){
                var ch:DisplayObject=c.getChildAt(i);
                if(ch is SpecialBatterCardView)out.push(ch);
                else if(ch is DisplayObjectContainer)gatherCards(ch as DisplayObjectContainer,out);
            }
        }
        private function shot(c:Sprite,n:String):void {
            var b:BitmapData=new BitmapData(960,540,false,0x0c263d);b.draw(c);
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/cards-"+n+".png");f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();
        }
        private function write(value:String):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/smoke-cards.txt");f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();
        }
    }
}
