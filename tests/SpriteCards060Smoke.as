package {
    import flash.display.*;
    import flash.events.*;
    import flash.filesystem.*;
    import flash.desktop.NativeApplication;
    import flash.net.SharedObject;
    import flash.utils.setTimeout;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import com.bh.model.*;
    import com.bh.game.SpecialAbilityResolver;
    import com.bh.ui.*;
    public class SpriteCards060Smoke extends Sprite {
        private var checks:Array=[],screen:SpecialCardsScreen;
        private var classes:Array=["S","A","B","C"],grades:Array=["HERO","ELITE","RARE","A"];
        public function SpriteCards060Smoke() {
            stage.scaleMode="noScale";stage.align="TL";
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void {
                e.preventDefault();report("FAIL: "+e.error);NativeApplication.nativeApplication.exit(1);
            });
            setTimeout(run,100);
        }
        private function check(value:Boolean,message:String):void {if(!value)throw new Error(message);}
        private function inventory():int {var n:int=0;for each(var c:Object in GameData.ownedSpecialCards())n+=1+GameData.specialCardCopies(c.id);return n;}
        private function run():void {
            GameData.init();var ids:Object={},pairs:Object={},catalog:Array=GameData.specialCardCatalog();
            check(catalog.length==33,"Expected 33 batters");
            for each(var c:Object in catalog) {
                check(!ids[c.id],"Duplicate id");ids[c.id]=true;
                check(classes.indexOf(c.cardClass)>=0&&grades.indexOf(c.grade)>=0,"Invalid axes");
                var key:String=c.cardClass+"/"+c.grade;pairs[key]=int(pairs[key])+1;
                for each(var stat:String in ["power","contact","speed","luck"])check(c[stat]>=1&&c[stat]<=100,"Stat bounds");
            }
            for each(var cls:String in classes)for each(var grade:String in grades) {
                check(pairs[cls+"/"+grade]>=2,"Missing combination "+cls+grade);
                var expected:Number=grade=="HERO"?1:grade=="ELITE"?.8:grade=="RARE"?.65:.5;
                for(var i:int=0;i<100;i++) {
                    c=SpecialCardCatalog.pick(cls,grade,i/100);
                    check(c&&c.cardClass==cls&&c.grade==grade,"Picker crossed class/grade");
                    var roll:Number=i/100;
                    var resolver:SpecialAbilityResolver=new SpecialAbilityResolver(function():Number{return roll;});
                    var result:String=resolver.resolve(c,c.triggerInning);
                    check((result!="")==Boolean(roll<expected),"Ability probability mismatch");
                    check(resolver.resolve(c,c.triggerInning)=="","Ability repeated");
                }
            }
            var counts:Object={};
            for(i=0;i<1000;i++){grade=SpecialCardCatalog.classPackGrade(i/1000);counts[grade]=int(counts[grade])+1;}
            check(counts.A==600&&counts.RARE==250&&counts.ELITE==120&&counts.HERO==30,"Shop odds disagree with draws");
            checks.push("PASS: 33 unique cards; all 16 class/grade pairs contain at least two batters; 1600 ability trials match each grade and never repeat; pack grade weights match displayed 60/25/12/3 percent.");
            GameData.specialOwned={};GameData.coins=1000000;GameData.cash=100000;
            var before:int=inventory(),coin:int=GameData.coins,cash:int=GameData.cash;
            check(GameData.drawSpecialClassPack("invalid").status=="INVALID_PACK","Invalid pack accepted");
            check(GameData.coins==coin&&GameData.cash==cash&&inventory()==before,"Invalid pack mutated state");
            check(GameData.drawSpecialClassPack("C").card.id=="card_lenard_j","First C discovery changed");
            for each(cls in classes)for(i=0;i<16;i++) {
                var cost:Object=GameData.specialClassPackCost(cls);coin=GameData.coins;cash=GameData.cash;before=inventory();
                var draw:Object=GameData.drawSpecialClassPack(cls);
                check(draw.status=="OK"&&draw.card.cardClass==cls,"Class pack escaped its class");
                check(GameData.coins==coin-cost.coins&&GameData.cash==cash-cost.cash&&inventory()==before+1,"Wrong charge/grant");
            }
            GameData.coins=0;GameData.cash=0;before=inventory();
            check(GameData.drawSpecialClassPack("C").status=="COINS"&&GameData.drawSpecialClassPack("S").status=="CASH","Funds not checked");
            check(inventory()==before&&GameData.coins==0&&GameData.cash==0,"Failed purchase changed inventory");
            check(GameData.specialClassPackCost("B+").cash==25&&GameData.specialClassPackCost("A+").cash==56,"Legacy aliases");
            GameData.coins=2000000;GameData.cash=10000;
            for(i=0;i<20;i++)check(GameData.drawSpecialCardPack(i%2==0).status=="OK","Mixed packs failed");
            checks.push("PASS: 64 class-pack purchases stay in the selected class and grant/charge once; first C grants Lenard; invalid/insufficient requests leave state untouched; old aliases and both mixed packs work.");
            // Preserve the v20 ownership shape: no class/grade field is saved.
            GameData.specialOwned={};GameData.specialEquipped=["card_ken_golden",null,null,null,null];GameData.specialSlotsUnlocked=1;
            GameData.specialOwned.card_ken_golden={level:1,copies:7,atBats:41,hits:27,rbi:18};
            var beforeCombo:int=GameData.specialCombo();
            check(GameData.combineSpecialCard("card_ken_golden")=="OK","Combine failed");
            check(GameData.specialCombo()>beforeCombo&&GameData.specialCardCopies("card_ken_golden")==4,"Combine not applied");
            check(GameData.combineSpecialCard("card_ken_golden")=="OK"&&GameData.combineSpecialCard("card_ken_golden")=="MAX","Level cap");
            GameData.save();GameData.specialOwned={};GameData.specialEquipped=[];GameData.load();
            var state:Object=GameData.specialCardState("card_ken_golden");
            check(state.level==3&&state.copies==1&&state.atBats==41&&state.hits==27&&state.rbi==18,"Save/load lost card progress");
            check(GameData.isSpecialCardEquipped("card_ken_golden"),"Equipped card lost");
            checks.push("PASS: existing v20 card state keeps level/copies/at-bats/hits/RBI/equipped slot on reload; combining consumes exactly three duplicates, improves combo and stops at level three.");
            GameData.specialOwned={card_rookie_ace:{level:1,copies:0,atBats:0,hits:0,rbi:0}};
            GameData.specialEquipped=["card_rookie_ace",null,null,null,null];
            screen=new SpecialCardsScreen(960,720,function():void{});addChild(screen);
            setTimeout(ui,600);
        }
        private function click(name:String):void {var b:DisplayObject=find(screen,name);check(b!=null,"Missing control "+name);b.dispatchEvent(new MouseEvent(MouseEvent.CLICK));}
        private function ui():void {
            click("filter_class_S");shot("empty");check(cards(screen).length==0,"Owned filter leaked cards");
            check(!Sprite(find(screen,"card_equip")).mouseEnabled,"Empty selection can equip");
            click("collection_scope");
            for each(var cls:String in classes)for each(var grade:String in grades) {
                click("filter_class_"+cls);click("filter_grade_"+grade);
                var list:Array=cards(screen);check(list.length>=2,"Combination unreachable in UI");
                for each(var v:SpecialBatterCardView in list)check(v.data.cardClass==cls&&v.data.grade==grade,"UI filter mixed axes");
            }
            click("filter_class_S");click("filter_grade_HERO");shot("s-hero");
            check(!Sprite(find(screen,"card_equip")).mouseEnabled,"Unowned card can equip");
            var before:int=inventory();click("card_equip");click("card_combine");check(inventory()==before,"Preview granted a card");
            click("filter_class_ALL");click("filter_grade_ALL");shot("catalog");
            var seen:Object={};
            for(var page:int=0;page<7;page++) {
                list=cards(screen);check(list.length<=5,"Page overflow");
                for each(v in list){seen[v.data.id]=true;var r:Rectangle=v.getBounds(screen);check(r.right<633&&r.bottom<533,"Card overlaps collection controls");}
                if(page<6)click("collection_next");
            }
            for each(var c:Object in GameData.specialCardCatalog())check(seen[c.id],"Unreachable catalog entry");
            shot("last-page");
            click("filter_class_C");click("filter_grade_A");click("collection_scope");
            click("collection_card_card_rookie_ace");GameData.specialOwned.card_rookie_ace.copies=3;
            click("collection_card_card_rookie_ace");click("card_combine");
            check(GameData.specialCardLevel("card_rookie_ace")==2&&GameData.specialCardCopies("card_rookie_ace")==0,"UI combine failed");shot("combine");
            checks.push("PASS: 16 UI filters; empty/owned/catalog states; unowned previews cannot grant/equip/combine; all 33 cards reachable over seven pages within bounds; duplicate combining works through the UI.");
            screen.dispose();removeChild(screen);report(checks.join("\n"));NativeApplication.nativeApplication.exit();
        }
        private function cards(container:DisplayObjectContainer):Array {
            var out:Array=[];for(var i:int=0;i<container.numChildren;i++) {
                var ch:DisplayObject=container.getChildAt(i);if(ch is SpecialBatterCardView)out.push(ch);
                else if(ch is DisplayObjectContainer)out=out.concat(cards(ch as DisplayObjectContainer));
            }return out;
        }
        private function find(container:DisplayObjectContainer,name:String):DisplayObject {
            for(var i:int=0;i<container.numChildren;i++){var ch:DisplayObject=container.getChildAt(i);if(ch.name==name)return ch;
                if(ch is DisplayObjectContainer){var v:DisplayObject=find(ch as DisplayObjectContainer,name);if(v)return v;}}
            return null;
        }
        private function shot(name:String):void {
            var b:BitmapData=new BitmapData(960,720,false,0x132b3f);b.draw(screen);
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/v060-"+name+".png");f.parent.createDirectory();
            var out:FileStream=new FileStream();out.open(f,FileMode.WRITE);out.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));out.close();b.dispose();
        }
        private function report(text:String):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/smoke-sprite-cards.txt");f.parent.createDirectory();
            var out:FileStream=new FileStream();out.open(f,FileMode.WRITE);out.writeUTFBytes(text);out.close();
        }
    }
}

