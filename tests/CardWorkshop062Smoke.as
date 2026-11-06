package {
    import flash.display.*;import flash.events.*;import flash.filesystem.*;import flash.desktop.NativeApplication;import flash.utils.*;
    import com.bh.model.*;import com.bh.ui.*;
    public class CardWorkshop062Smoke extends Sprite {
        private var screen:SpecialCardsScreen,step:int=0,wallet:int,operations:Array;
        public function CardWorkshop062Smoke() {
            stage.scaleMode="noScale";stage.align="TL";stage.frameRate=60;
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish("FAIL: "+e.error,1);});
            GameData.init();GameData.specialOwned={};GameData.specialEquipped=["a",null,null,null,null];GameData.specialMatch=null;GameData.specialSlotsUnlocked=5;GameData.cash=100;GameData.coins=10000;
            var base:Object=SpecialCardCatalog.pick("C","HERO",0);
            for each(var id:String in ["a","b","c","d","e"])GameData.specialOwned[id]=SpecialCardInventory.fresh(id,base.id);
            GameData.specialOwned.b.enhancement=4;GameData.specialOwned.b.level=5;GameData.specialOwned.b.charges=0;GameData.specialOwned.b.rechargeAt=new Date().time+10800000;
            screen=new SpecialCardsScreen(960,720,function():void{});addChild(screen);
            operations=[
                function():void{shot("collection");click("collection_card_b");click("card_manage");},
                function():void{shot("enhance");click("enhance_max");},
                function():void{shot("enhance-confirm");check(GameData.specialOwned.b.enhancement==4,"Review spent before confirm");click("workshop_cancel");check(GameData.cash==100,"Cancel charged");click("enhance_cash");wallet=GameData.cash;confirmTwice();check(GameData.cash==wallet-3&&GameData.specialOwned.b.enhancement==5,"Double enhance charged / incorrect copy");},
                function():void{shot("enhance-result");click("workshop_again");click("workshop_charge");},
                function():void{shot("charge");click("charge_cash");},
                function():void{wallet=GameData.cash;confirmTwice();check(GameData.cash==wallet-2&&GameData.specialOwned.b.charges==2,"Charge transaction wrong");click("workshop_close");click("card_trade");click("workshop_card_a");click("workshop_card_c");click("workshop_card_d");click("workshop_card_e");},
                function():void{shot("trade");click("trade_cash");},
                function():void{shot("trade-confirm");wallet=GameData.cash;confirmTwice();check(GameData.cash==wallet-13&&GameData.ownedSpecialCards().length==3,"Trade duplicated / equipped card selected");check(GameData.ownsSpecialCard("a")&&GameData.ownsSpecialCard("b"),"Wrong copies consumed");},
                function():void{shot("trade-result");click("workshop_close");check(!find(screen,"card_workshop"),"Overlay did not close");check(GameData.specialOwned.b.enhancement==5,"Other upgrade changed");shot("collection-after");screen.dispose();finish("PASS: real collection/management buttons; select specific duplicate; cancel without spending; +4 to +5; timed energy view and full recharge; exclude equipped copy; three-card trade, result reveal, no double confirmation charge; 960x720 captures.",0);}
            ];next();
        }
        private function next():void{setTimeout(function():void{try{operations[step++]();if(step<operations.length)next();}catch(e:Error){finish("FAIL: step "+step+" / "+e.message+"\n"+e.getStackTrace(),1);}},800);}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var r:DisplayObject=find(d as DisplayObjectContainer,id);if(r)return r;}}return null;}
        private function click(id:String):void{var d:DisplayObject=find(screen,id);check(d!=null,"Missing button "+id);check(InteractiveObject(d).mouseEnabled,"Disabled button "+id);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function confirmTwice():void{var b:DisplayObject=find(screen,"workshop_confirm");check(b!=null,"No confirmation");b.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));b.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function shot(label:String):void{var b:BitmapData=new BitmapData(960,720,false,0x193849);b.draw(screen);var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/v062-"+label+".png");f.parent.createDirectory();var o:FileStream=new FileStream();o.open(f,FileMode.WRITE);o.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));o.close();b.dispose();}
        private function finish(value:String,code:int):void{var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/smoke-cards062-ui.txt");f.parent.createDirectory();var o:FileStream=new FileStream();o.open(f,FileMode.WRITE);o.writeUTFBytes(value);o.close();NativeApplication.nativeApplication.exit(code);}
    }
}
