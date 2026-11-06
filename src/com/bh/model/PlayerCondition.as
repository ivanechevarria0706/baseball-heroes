package com.bh.model {
    /** Five-state form, independent of card energy. Transitions are a local reconstruction. */
    public class PlayerCondition {
        public static const MAX:int=6;
        public static const RECOVERY:Number=1800000;
        public static function ensure(p:Object):void {
            if(!p)return;
            if(!p.condition||typeof p.condition!="object"||p.condition is Array)p.condition={};
            if(p.condition.form===undefined){var old:Number=Number(p.condition.energy);p.condition.form=p.condition.energy===undefined||!isFinite(old)?0:old>=5?2:old>=3?1:old==2?0:old==1?-1:-2;}
            var form:Number=Number(p.condition.form);p.condition.form=isFinite(form)?Math.max(-2,Math.min(2,int(form))):0;
            if(p.condition.lastFixture===undefined)p.condition.lastFixture="";p.condition.version=1;
        }
        public static function energy(p:Object,now:Number=-1):int {
            return p?MAX:0; // Compatibility only: poor form never prevents batting.
        }
        public static function consume(p:Object,now:Number=-1):Boolean {
            return p!=null;
        }
        public static function modifier(p:Object):int {if(!p)return 0;ensure(p);return int(p.condition.form);}
        public static function label(p:Object):String {return labelFor(modifier(p));}
        public static function labelFor(form:int):String {return ["POOR","LOW","NORMAL","GOOD","BEST"][Math.max(0,Math.min(4,form+2))];}
        /** Commit once after a completed fixture; opening/reordering/reloading never rerolls. */
        public static function advance(p:Object,key:String):Boolean {
            if(!p||!key)return false;ensure(p);if(p.condition.lastFixture==key)return false;
            var seed:String=key+"|"+String(p.name),hash:uint=0;
            for(var i:int=0;i<seed.length;i++)hash=uint((hash<<5)-hash+seed.charCodeAt(i));
            p.condition.form=Math.max(-2,Math.min(2,int(p.condition.form)+int(hash%3)-1));p.condition.lastFixture=key;return true;
        }
    }
}
