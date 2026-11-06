package com.bh.model {
    /** Five energy per new fixture; five-minute cadence inferred from reference HUD.
     * Old capacity is preserved. UTC milliseconds serialize as strings in Ruffle. */
    public class AccountEnergy {
        public static const COST:int=5;
        public static const INTERVAL:Number=300000;
        public static function settle(value:int,cap:int,at:String,now:Number):Object {
            cap=Math.max(1,cap);value=Math.max(0,value);
            var next:Number=Number(at);
            if(value>=cap)return {energy:value,at:"0"};
            if(!isFinite(next)||next<=0)next=now+INTERVAL;
            if(now>=next){var steps:int=Math.min(cap-value,1+Math.floor((now-next)/INTERVAL));value+=steps;next+=steps*INTERVAL;}
            return {energy:value,at:value>=cap?"0":String(next)};
        }
        public static function clock(seconds:Number):String {var n:int=Math.max(0,Math.ceil(seconds));return int(n/60)+":"+(n%60<10?"0":"")+(n%60);}
    }
}
