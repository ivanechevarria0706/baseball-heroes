package com.bh.model {
    /** Instance storage and offline recovery. Catalog data is never serialized over a card. */
    public class SpecialCardInventory {
        public static const RECOVERY_MS:Number = 3 * 60 * 60 * 1000;
        public static function catalog(id:String):Object {
            if(MLB2026Catalog.supports(id))return MLB2026Catalog.byId(id);
            for each(var c:Object in SpecialCardCatalog.classicCards()) if(c.id==id)return c;
            return null;
        }
        public static function fresh(id:String,cardId:String):Object {
            return {instanceId:id,cardId:cardId,enhancement:0,level:1,copies:0,
                legacyComboMultiplier:1,charges:2,rechargeAt:"0",atBats:0,hits:0,rbi:0,walks:0};
        }
        public static function normalize(owned:Object,now:Number):void {
            var keys:Array=[];
            for(var id:String in owned)keys.push(id);
            for each(id in keys) {
                var s:Object=owned[id];if(!s)continue;
                // A marker on every instance makes migration idempotent, also after an interrupted load.
                if(s.instanceId===undefined) {
                    var extras:int=Math.max(0,int(s.copies));
                    s.instanceId=id;s.cardId=id;
                    s.enhancement=Math.max(0,Math.min(5,int(s.level)-1));
                    s.legacyComboMultiplier=1+Math.max(0,int(s.level)-1)*.18;
                    s.charges=2;s.rechargeAt=0;s.copies=0;
                    for(var i:int=1;i<=extras;i++) {
                        var duplicate:String=id+"#legacy"+i;
                        if(!owned[duplicate])owned[duplicate]=fresh(duplicate,id);
                    }
                }
                s.enhancement=Math.max(0,Math.min(5,int(s.enhancement)));
                s.level=1+int(s.enhancement);
                if(s.legacyComboMultiplier===undefined)s.legacyComboMultiplier=1;
                if(s.charges===undefined)s.charges=2;
                if(s.rechargeAt===undefined)s.rechargeAt="0";
                if(s.atBats===undefined)s.atBats=0;
                if(s.hits===undefined)s.hits=0;
                if(s.rbi===undefined)s.rbi=0;
                if(s.walks===undefined)s.walks=0;
                recover(s,now);
            }
        }
        public static function recover(s:Object,now:Number):void {
            s.charges=Math.max(0,Math.min(2,int(s.charges)));
            if(s.charges>=2){s.rechargeAt="0";return;}
            if(!isFinite(Number(s.rechargeAt))||Number(s.rechargeAt)<=0)s.rechargeAt=String(now+RECOVERY_MS);
            if(now>=Number(s.rechargeAt)) {
                var gained:int=Math.min(2-int(s.charges),1+Math.floor((now-Number(s.rechargeAt))/RECOVERY_MS));
                s.charges+=gained;
                s.rechargeAt=s.charges>=2?"0":String(Number(s.rechargeAt)+gained*RECOVERY_MS);
            }
            // Decimal strings retain millisecond precision through browser JSON.
            s.rechargeAt=String(Number(s.rechargeAt));
        }
        public static function describe(id:String,s:Object):Object {
            var c:Object=catalog(s?String(s.cardId):id);if(!c)return null;
            c.catalogId=c.id;c.id=id;
            if(s) {
                c.instanceId=id;c.enhancement=int(s.enhancement);
                c.avg=int(c.avg)+10*int(s.enhancement);
                // Retain paid legacy bonuses; new enhancement grants +1 combo at +5.
                c.combo=Math.max(Number(c.combo)*Number(s.legacyComboMultiplier),Number(c.combo)+(s.enhancement==5?1:0));
                for each(var stat:String in ["power","contact","speed","luck"])c[stat]=Math.min(99,int(c[stat])+3*int(s.enhancement));
            }
            return c;
        }
        public static function energyLabel(s:Object,now:Number):String {
            if(!s)return "";recover(s,now);
            if(s.charges==2)return "ENERGY 2/2";
            var seconds:int=Math.max(0,Math.ceil((Number(s.rechargeAt)-now)/1000));
            var h:int=seconds/3600,m:int=(seconds%3600)/60,sec:int=seconds%60;
            return "ENERGY "+s.charges+"/2  +1 "+h+":"+(m<10?"0":"")+m+":"+(sec<10?"0":"")+sec;
        }
    }
}
