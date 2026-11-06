package {
    import flash.display.*;
    import flash.events.*;
    import flash.text.TextField;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.utils.setTimeout;
    import com.bh.model.GameData;
    import com.bh.game.SpecialAbilityResolver;
    import com.bh.ui.*;
    public class AbilitySmoke extends Sprite {
        private var checks:Array=[];
        private var lineup:LineupScreen;
        public function AbilitySmoke() {
            stage.scaleMode="noScale";stage.align="TL";
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{
                e.preventDefault();write("FAIL: "+e.error);NativeApplication.nativeApplication.exit(1);
            });
            setTimeout(run,200);
        }
        private function run():void {
            GameData.init();
            var grades:Array=["NORMAL","RARE","ELITE","HERO"];
            var expected:Array=[500,650,800,1000];
            var currentRoll:Number=0;
            for(var g:int=0;g<grades.length;g++) {
                var card:Object={id:"test_card",grade:grades[g],triggerInning:4,guaranteedHit:"SINGLE"};
                var count:int=0;
                for(var i:int=0;i<1000;i++) {
                    currentRoll=i/1000;
                    var resolver:SpecialAbilityResolver=new SpecialAbilityResolver(function():Number{return currentRoll;});
                    if(resolver.resolve(card,4)=="SINGLE")count++;
                }
                if(count!=expected[g])throw new Error("Wrong chance for "+grades[g]+": "+count);
            }
            var calls:int=0;
            var lenard:Object=GameData.specialCardById("card_lenard_j");
            var attempt:SpecialAbilityResolver=new SpecialAbilityResolver(function():Number{calls++;return calls==1?.75:.10;});
            if(attempt.resolve(lenard,3)!=""||calls!=0)throw new Error("Ineligible inning consumed RNG");
            if(attempt.resolve(lenard,4)!=""||calls!=1)throw new Error("Failed ability did not fall through");
            if(attempt.resolve(lenard,4)!=""||calls!=1)throw new Error("Failed ability was rerolled");
            var nextMatch:SpecialAbilityResolver=new SpecialAbilityResolver(function():Number{return .10;});
            if(nextMatch.resolve(lenard,4)!="SINGLE"||nextMatch.resolve(lenard,4)!="")throw new Error("Match reset/success repeat rule");
            if(GameData.specialAbilityLabel(lenard)!="4th 50% 1B")throw new Error("Card label disagrees with reference");
            checks.push("PASS: 1000 evenly spaced rolls per grade yield 50/65/80/100%; wrong inning never rolls; failures and successes do not repeat; new match resets eligibility.");
            testPrices();
            GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;
            GameData.specialSlotsUnlocked=1;GameData.coins=5000;GameData.cash=200;
            lineup=new LineupScreen(960,540,noop,noop,noop,noop);addChild(lineup);
            setTimeout(testSlotWindow,650);
        }
        private function testPrices():void {
            GameData.specialSlotsUnlocked=1;GameData.coins=999;GameData.cash=128;
            if(GameData.unlockNextSpecialSlot()!="COINS"||GameData.coins!=999||GameData.specialSlotsUnlocked!=1)throw new Error("Insufficient coins modified state");
            GameData.coins=3000;
            if(GameData.nextSpecialSlotPrice()!="C 1,000"||GameData.unlockNextSpecialSlot()!="OK"||GameData.coins!=2000)throw new Error("Slot 2 price");
            if(GameData.nextSpecialSlotPrice()!="C 2,000"||GameData.unlockNextSpecialSlot()!="OK"||GameData.coins!=0)throw new Error("Slot 3 price");
            GameData.cash=55;
            if(GameData.unlockNextSpecialSlot()!="CASH"||GameData.cash!=55||GameData.specialSlotsUnlocked!=3)throw new Error("Insufficient cash modified state");
            GameData.cash=128;
            if(GameData.nextSpecialSlotPrice()!="$ 56"||GameData.unlockNextSpecialSlot()!="OK"||GameData.cash!=72)throw new Error("Slot 4 price");
            if(GameData.nextSpecialSlotPrice()!="$ 72"||GameData.unlockNextSpecialSlot()!="OK"||GameData.cash!=0)throw new Error("Slot 5 price");
            if(GameData.unlockNextSpecialSlot()!="MAX"||GameData.cash!=0||GameData.coins!=0)throw new Error("Max slots charged again");
            checks.push("PASS: slots cost 1000 coins, 2000 coins, 56 cash, 72 cash; insufficient funds and MAX leave balances and slots unchanged.");
        }
        private function testSlotWindow():void {
            // Open the same slot control used by LINE UP, then purchase through its UI.
            var header:Sprite;
            for(var i:int=0;i<lineup.numChildren;i++) {
                var child:Sprite=lineup.getChildAt(i) as Sprite;
                if(child&&child.x==335&&child.y==81)header=child;
            }
            if(!header)throw new Error("Missing LINE UP special slot header");
            header.getChildAt(0).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            var buy:Sprite=find(lineup,"slot_unlock_2");
            if(!buy)throw new Error("Slot window cannot unlock next slot");
            shot(lineup,"slots-before");buy.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(GameData.specialSlotsUnlocked!=2||GameData.coins!=4000||textOf(lineup).indexOf("4,000")<0)throw new Error("Slot purchase did not refresh LINE UP balance");
            if(!find(lineup,"slot_unlock_3"))throw new Error("Next slot purchase missing");
            shot(lineup,"slots-after");
            find(lineup,"types_tab").dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            var t:String=textOf(lineup);for each(var p:String in ["50%","65%","80%","100%"]){if(t.indexOf(p)<0)throw new Error("Missing grade probability "+p);}
            shot(lineup,"slot-types");find(lineup,"slots_close").dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            if(find(lineup,"slot_unlock_3"))throw new Error("Slot window did not close");
            lineup.dispose();removeChild(lineup);
            var view:SpecialBatterCardView=new SpecialBatterCardView(GameData.specialCardById("card_lenard_j"),224,352);view.x=368;view.y=90;
            var page:Sprite=new Sprite();page.addChild(view);addChild(page);
            setTimeout(function():void{
                shot(page,"lenard");view.dispose();removeChild(page);
                checks.push("PASS: LINE UP slot purchase updates header balance and unlocks the next control; TYPES matches resolver; closing removes overlay; Lenard card renders 4th 50% 1B.");
                write(checks.join("\n"));NativeApplication.nativeApplication.exit();
            },300);
        }
        private function find(c:DisplayObjectContainer,n:String):Sprite {
            for(var i:int=0;i<c.numChildren;i++){
                var ch:DisplayObject=c.getChildAt(i);if(ch.name==n)return ch as Sprite;
                if(ch is DisplayObjectContainer){var found:Sprite=find(ch as DisplayObjectContainer,n);if(found)return found;}
            }return null;
        }
        private function textOf(c:DisplayObjectContainer):String {
            var value:String="";for(var i:int=0;i<c.numChildren;i++){
                var ch:DisplayObject=c.getChildAt(i);if(ch is TextField)value+=TextField(ch).text;
                else if(ch is DisplayObjectContainer)value+=textOf(ch as DisplayObjectContainer);
            }return value;
        }
        private function shot(c:Sprite,n:String):void {
            var b:BitmapData=new BitmapData(960,540,false,0x0c263d);b.draw(c);
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/abilities-"+n+".png");f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();
        }
        private function write(value:String):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/smoke-abilities.txt");f.parent.createDirectory();
            var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();
        }
        private function noop(...args):void {}
    }
}
