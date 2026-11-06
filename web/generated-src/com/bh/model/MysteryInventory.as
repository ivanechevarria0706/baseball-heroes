package com.bh.model {
    /** Five documented key costs; prize odds, higher coin pools and award schedule are remake balance.
     * A pending prize is saved before reveal and never rerolled on reload. */
    public class MysteryInventory {
        public static function create():Object {return {version:2,boxes:{rookie:0,single_a:0,double_a:0,triple_a:0,majors:0},keys:0,packs:{C:0,B:0,A:0,S:0},pending:null,serial:0,matches:[]};}
        private static function amount(v:*,cap:int):int {var n:Number=Number(v);return isFinite(n)?int(Math.max(0,Math.min(cap,Math.floor(n)))):0;}
        public static function keyCost(kind:String):int {var b:Object=MysteryCatalog.box(kind);return b?int(b.keys):0;}
        public static function normalize(v:Object):Object {
            var s:Object=create();if(!v||v is Array)return s;
            for each(var kind:String in MysteryCatalog.KINDS)if(v.boxes)s.boxes[kind]=amount(v.boxes[kind],50);
            for each(var cls:String in MysteryCatalog.CLASSES)if(v.packs)s.packs[cls]=amount(v.packs[cls],50);
            s.keys=amount(v.keys,40);s.serial=amount(v.serial,100000000);
            if(v.matches is Array)for each(var key:* in v.matches.slice(-256))if(key is String&&key.length<100&&s.matches.indexOf(key)<0)s.matches.push(key);
            var p:Object=v.pending;
            if(p&&!(p is Array)&&String(p.id)=="mystery-"+s.serial&&s.serial>0){
                var n:int=amount(p.amount,100000),type:String=String(p.type),source:String=String(p.source);
                if(keyCost(source)&&n>0&&["COINS","CASH","ENERGY","KEY","PACK"].indexOf(type)>=0){
                    s.pending={id:String(p.id),source:source,type:type,amount:type=="PACK"?1:n};
                    if(type=="PACK")s.pending.packClass=MysteryCatalog.CLASSES.indexOf(p.packClass)>=0?String(p.packClass):"C";
                }
                else if((keyCost(source)||MysteryCatalog.packClass(source)!="")&&type=="CARD"&&SpecialCardInventory.catalog(String(p.cardId)))
                    s.pending={id:String(p.id),source:source,type:type,amount:1,cardId:String(p.cardId)};
                else if(keyCost(source)&&type=="GEAR"&&MysteryCatalog.gearById(String(p.itemId)))
                    s.pending={id:String(p.id),source:source,type:type,amount:1,itemId:String(p.itemId),duplicateCoins:amount(p.duplicateCoins,100000)||int(MysteryCatalog.box(source).coins[0])};
            }
            return s;
        }
        public static function addKeys(s:Object,n:int):int {var old:int=s.keys;s.keys=Math.min(40,old+Math.max(0,n));return int(s.keys)-old;}
        public static function addBox(s:Object,kind:String):Boolean {if(!keyCost(kind)||int(s.boxes[kind])>=50)return false;s.boxes[kind]=int(s.boxes[kind])+1;return true;}
        public static function open(s:Object,kind:String,roll:Number=-1,choice:Number=-1):Object {
            var b:Object=MysteryCatalog.box(kind);if(!b)return {status:"INVALID"};if(s.pending)return {status:"PENDING"};
            var cost:int=b.keys;if(int(s.boxes[kind])<=0)return {status:"EMPTY"};if(int(s.keys)<cost)return {status:"KEYS"};
            if(roll<0||!isFinite(roll))roll=Math.random();roll=Math.max(0,Math.min(.999999,roll));
            if(choice<0||!isFinite(choice))choice=Math.random();choice=Math.max(0,Math.min(.999999,choice));
            var type:String=roll<.40?"COINS":roll<.58?"PACK":roll<.64?"CARD":roll<.70?"GEAR":roll<.82?"KEY":roll<.94?"ENERGY":"CASH";
            var cls:String=String(b.packClass),prize:Object={source:kind,type:type,amount:1};
            if(type=="PACK"&&int(s.packs[cls])>=50)type=prize.type="COINS";
            if(type=="COINS")prize.amount=int(b.coins[Math.min(2,int(choice*3))]);
            else if(type=="PACK")prize.packClass=cls;
            else if(type=="CARD"){
                var grade:String=SpecialCardCatalog.classPackGrade(choice,cls),card:Object=SpecialCardCatalog.pick(cls,grade,Math.random());
                if(!card)card=SpecialCardCatalog.pick(cls,"A",choice);
                if(!card)return {status:"INVALID"};prize.cardId=card.id;
            }
            else if(type=="GEAR"){
                var pool:Array=MysteryCatalog.gear(kind),item:Object=pool[int(choice*pool.length)];
                if(!item)return {status:"INVALID"};prize.itemId=item.id;prize.duplicateCoins=int(b.coins[0]);
            }
            else if(type=="KEY")prize.amount=cost;
            else if(type=="ENERGY")prize.amount=b.energy;
            else if(type=="CASH")prize.amount=Math.max(1,MysteryCatalog.KINDS.indexOf(kind));
            s.boxes[kind]--;s.keys-=cost;s.serial++;prize.id="mystery-"+s.serial;s.pending=prize;return {status:"OK",reward:s.pending};
        }
        public static function recordGame(s:Object,key:String,won:Boolean,game:int,league:int):Object {
            var r:Object={keys:0,boxes:0,coins:0};if(s.matches.indexOf(key)>=0)return r;
            s.matches.push(key);while(s.matches.length>256)s.matches.shift();if(!won){if(game==12||game==28){r.coins=500;r.special=true;}return r;}
            r.keys=addKeys(s,1);
            if(game==12||game==28){r.special=true;r.kind=MysteryCatalog.forLeague(league);r.boxes=addBox(s,r.kind)?1:0;}
            if(game==30)r.coins=2000;return r;
        }
    }
}
