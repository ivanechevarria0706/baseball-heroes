package {
    import flash.display.Sprite;import flash.events.*;import flash.desktop.NativeApplication;
    import flash.filesystem.*;import flash.net.SharedObject;
    import com.bh.model.*;import com.bh.game.SpecialAbilityResolver;
    public class CardLifecycle062Smoke extends Sprite {
        private var mode:String;
        public function CardLifecycle062Smoke(){NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,run);}
        private function check(v:Boolean,m:String):void {if(!v)throw new Error(m);}
        private function run(e:InvokeEvent):void {
            mode=e.arguments.length?e.arguments[0]:"rules";
            try {
                GameData.init();
                if(mode=="seed")seed();else if(mode=="reload"||mode=="reload2")migration();else rules();
                finish("PASS: "+mode+" / "+(mode=="rules"?"transaction validation, individual upgrades, independent abilities, failed enhancement, paid retry, charge/recovery, zero-energy replacement and persistent match snapshot.":"33 legacy catalog cards, 48 extra copies, all levels/stats/bonuses, equipped IDs, wallet, season, unknown fields; separate original backup and idempotent v21 reload."),0);
            } catch(error:Error){finish("FAIL: "+mode+" / "+error.message+"\n"+error.getStackTrace(),1);}
        }
        private function seed():void {
            GameData.specialOwned={};GameData.specialMatch=null;GameData.specialSerial=0;GameData.specialEquipped=[];GameData.specialSlotsUnlocked=5;
            var all:Array=GameData.specialCardCatalog();
            for(var i:int=0;i<all.length;i++) {
                var id:String=all[i].id;
                GameData.specialOwned[id]={level:1+i%3,copies:i%4,atBats:50+i,hits:20+i,rbi:11+i,custom:"preserved"};
                if(i<5)GameData.specialEquipped.push(id);
            }
            GameData.coins=34567;GameData.cash=42;GameData.energy=12;
            GameData.teamName="PERSISTENCE 062";GameData.seasonGame=17;GameData.seasonWins=10;GameData.seasonLosses=6;
            GameData.onboardingStep=99;GameData.seasonGoalSet=true;GameData.save();
            var so:SharedObject=SharedObject.getLocal("baseballHeroesRemakeSave");so.data.version=20;so.data.unknownField="keep";so.flush();
            SharedObject.getLocal("baseballHeroesRemakeSave_before_v21").clear();
        }
        private function migration():void {
            check(GameData.ownedSpecialCards().length==81,"Duplicate count changed");
            var all:Array=GameData.specialCardCatalog();
            for(var i:int=0;i<all.length;i++) {
                var id:String=all[i].id,s:Object=GameData.specialCardState(id),c:Object=GameData.specialCardById(id);
                check(s.enhancement==i%3&&s.atBats==50+i&&s.hits==20+i&&s.rbi==11+i&&s.custom=="preserved","Legacy state changed "+id);
                check(c.combo>=Number(all[i].combo)*(1+(i%3)*.18),"Legacy combo reduced");
                check(c.power>=Math.min(99,int(all[i].power)+(i%3)*3),"Legacy stat reduced");
                check(GameData.specialCardCopies(id)==i%4,"Extra copies lost");
                if(i<5)check(GameData.specialEquipped[i]==id,"Equipped ID changed");
            }
            check(GameData.coins==34567&&GameData.cash==42&&GameData.energy==12,"Wallet changed");
            check(GameData.seasonGame==17&&GameData.seasonWins==10&&GameData.seasonLosses==6&&GameData.teamName=="PERSISTENCE 062","Career changed");
            var so:SharedObject=SharedObject.getLocal("baseballHeroesRemakeSave");check(so.data.version==21&&so.data.unknownField=="keep","Schema / extra data changed");
            var backup:SharedObject=SharedObject.getLocal("baseballHeroesRemakeSave_before_v21");
            check(backup.data.snapshot.version==20&&backup.data.snapshot.specialOwned[all[3].id].copies==3,"Original backup changed");
        }
        private function put(id:String,cls:String="C",grade:String="HERO"):Object {
            var c:Object=SpecialCardCatalog.pick(cls,grade,0),s:Object=SpecialCardInventory.fresh(id,c.id);
            GameData.specialOwned[id]=s;return s;
        }
        private function rules():void {
            GameData.specialOwned={};GameData.specialEquipped=[null,null,null,null,null];GameData.specialSlotsUnlocked=5;GameData.specialMatch=null;
            GameData.coins=100000;GameData.cash=10000;GameData.energy=10;GameData.seasonGame=1;GameData.seasonComplete=false;
            var a:Object=put("copy1"),b:Object=put("copy2"),c:Object=put("copy3","C","A");put("other","B");put("top","S");
            var ids:Array=["copy1","copy2","copy3"],wallet:int=GameData.cash;
            check(GameData.specialTradeQuote(["copy1","copy1","copy3"],"CASH").status=="DUPLICATE","Can consume same copy twice");
            check(GameData.specialTradeQuote(["copy1","other","copy3"],"CASH").status=="CLASS","Mixed class trade allowed");
            check(GameData.tradeSpecialCards(["bad","copy2","copy3"],"CASH").status=="NOT_OWNED","Unknown card accepted");
            GameData.equipSpecialCard("copy1");
            check(GameData.tradeSpecialCards(ids,"CASH").status=="EQUIPPED","Equipped card sacrificed");GameData.unequipSpecialCard("copy1");
            GameData.cash=0;check(GameData.tradeSpecialCards(ids,"CASH").status=="CASH"&&GameData.ownsSpecialCard("copy1"),"Unfunded trade consumed card");GameData.cash=wallet;
            var r:Object=GameData.tradeSpecialCards(ids,"CASH");check(r.status=="OK"&&r.card.cardClass=="B"&&GameData.cash==wallet-13,"Guaranteed class upgrade / cost");
            check(!GameData.ownsSpecialCard("copy1")&&!GameData.ownsSpecialCard("copy2")&&!GameData.ownsSpecialCard("copy3"),"Trade didn't consume selected copies");
            wallet=GameData.cash;check(GameData.tradeSpecialCards(ids,"CASH").status=="NOT_OWNED"&&GameData.cash==wallet,"Repeated trade charged");
            a=put("hero1");b=put("hero2");put("normal","C","A");
            check(GameData.enhanceSpecialCard("normal","CASH").status=="GRADE","Normal card upgraded");
            wallet=GameData.cash;r=GameData.enhanceSpecialCard("hero1","CASH",true);
            check(r.status=="OK"&&a.enhancement==5&&b.enhancement==0&&GameData.cash==wallet-15,"Enhancement not independent / max cost");
            check(r.card.avg==SpecialCardInventory.catalog(a.cardId).avg+50,"AVG progression wrong");
            check(GameData.enhanceSpecialCard("hero1","CASH").status=="MAX","Exceeded +5");
            b.enhancement=4;check(GameData.specialEnhanceQuote("hero2","CASH",true).cash==3,"+4 MAX price");
            var failure:Boolean=false;
            for(var n:int=0;n<100&&!failure;n++) {
                b.enhancement=4;b.level=5;var coins:int=GameData.coins;
                r=GameData.enhanceSpecialCard("hero2","COINS");
                check(GameData.coins==coins-2500,"Coin attempt price");
                if(r.status=="FAILED"){failure=true;check(b.enhancement==4&&GameData.ownsSpecialCard("hero2"),"Failure damaged card");}
            }
            check(failure,"No failed coin attempt observed in 100 attempts");
            GameData.equipSpecialCard("hero1");GameData.equipSpecialCard("hero2");a.charges=b.charges=1;
            var combo:int=GameData.specialCombo(),energy:int=GameData.energy;
            check(GameData.startSeasonGame(),"Couldn't start game");
            check(a.charges==0&&b.charges==0&&GameData.energy==energy-1,"Game charge count");
            check(GameData.startSeasonGame()&&GameData.energy==energy-1&&a.charges==0,"Retry double charged");
            check(GameData.specialCombo(true)==combo&&GameData.specialCombo()==0,"Paid match lost combo");
            check(GameData.equipSpecialCard("normal")=="MATCH_ACTIVE"&&!GameData.unequipSpecialCard("hero1"),"Paid lineup can mutate");
            check(GameData.enhanceSpecialCard("hero2","CASH").status=="MATCH_ACTIVE","Paid enhancement can mutate");
            var resolver:SpecialAbilityResolver=new SpecialAbilityResolver(function():Number{return 0;});
            var first:Object=GameData.specialCardForMatch(0),second:Object=GameData.specialCardForMatch(1);
            check(first.id!=second.id&&first.catalogId==second.catalogId,"Duplicate batters collapsed");
            check(resolver.resolve(first,first.triggerInning)!=""&&resolver.resolve(second,second.triggerInning)!="","Abilities share a key");
            check(resolver.resolve(first,first.triggerInning)=="","Ability repeated");
            GameData.recordSpecialCardAtBat(first.id,true,2);check(a.atBats==1&&b.atBats==0,"Stats not independent");
            GameData.save();GameData.specialMatch=null;GameData.specialOwned={};GameData.load();
            check(GameData.pendingSpecialMatch()&&GameData.specialCardForMatch(0).id=="hero1","Saved match lost");
            check(GameData.startSeasonGame()&&GameData.energy==energy-1,"Reload double charged");
            GameData.completeSeasonGame(2,1,1,0,1,2,[0,0,0,0,0,0,0,0,2],[0,0,0,0,0,0,0,0,1]);
            check(!GameData.pendingSpecialMatch(),"Completed match not released");
            check(GameData.startSeasonGame()&&GameData.specialCardForMatch(0)==null&&GameData.specialCardForMatch(1)==null,"Exhausted cards still selected");
            GameData.specialMatch=null;a=GameData.specialCardState("hero1");
            var now:Number=new Date().time;a.charges=0;a.rechargeAt=now+1000;
            SpecialCardInventory.recover(a,now);check(a.charges==0,"Early recovery");
            SpecialCardInventory.recover(a,now+1000);check(a.charges==1&&a.rechargeAt==now+1000+SpecialCardInventory.RECOVERY_MS,"First recharge");
            SpecialCardInventory.recover(a,now+1000+SpecialCardInventory.RECOVERY_MS*10);check(a.charges==2&&a.rechargeAt==0,"Offline capped recovery");
            a.charges=0;a.rechargeAt=now+100000;wallet=GameData.cash;
            check(GameData.chargeSpecialCard("hero1").status=="OK"&&a.charges==2&&GameData.cash==wallet-2,"Charge price / result");
            check(GameData.chargeSpecialCard("hero1").status=="FULL"&&GameData.cash==wallet-2,"Repeated charge paid");
        }
        private function finish(value:String,code:int):void {
            var f:File=new File(File.applicationDirectory.nativePath).resolvePath("qa/smoke-cards062-"+mode+".txt");f.parent.createDirectory();
            var out:FileStream=new FileStream();out.open(f,FileMode.WRITE);out.writeUTFBytes(value);out.close();NativeApplication.nativeApplication.exit(code);
        }
    }
}
