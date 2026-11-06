package com.bh.model {
    /** Observed: STEP 5 = 1350, STEP 10 = 3600, MASTER cycle = 1125.
     * Other thresholds retain early remake balance or interpolate between
     * observations. They are not a recovered server table. */
    public class TrainingMastery {
        private static const TARGETS:Array=[1350,1350,1350,1350,1350,1800,2250,2700,3150,3600,4050,4500];
        public static function target(stars:int):int {return stars>=12?1125:int(TARGETS[Math.max(0,stars)]);}
        private static function count(value:*,limit:int):int {
            var n:Number=Number(value);return isFinite(n)?int(Math.max(0,Math.min(limit,Math.floor(n)))):0;
        }
        public static function normalize(state:Object):Object {
            var raw:int=count(state.mastery,10000000),p:Object=state.progression;
            if(!p||typeof p!="object"||p is Array||p.version!=1||Number(p.sourceMastery)!=raw) {
                // Preserve already earned legacy stars and fractional progress.
                // Migration grants no points or energy and creates no receipt.
                var stars:int=Math.min(12,int(raw/1350));
                p={version:1,stars:stars,progress:int((raw%1350)*target(stars)/1350),cycles:0,sourceMastery:raw};
            }
            p.stars=count(p.stars,12);p.progress=count(p.progress,target(p.stars)-1);
            p.cycles=count(p.cycles,10000000);p.sourceMastery=raw;
            state.mastery=raw;state.progression=p;return p;
        }
        public static function info(state:Object):Object {
            var p:Object=normalize(state),master:Boolean=p.stars==12;
            return {stars:p.stars,progress:p.progress,target:target(p.stars),cycles:p.cycles,
                master:master,step:master?13:int(p.stars)+1,rank:master?"MASTER":p.stars<4?"Beginner":p.stars<8?"Expert":"Pro"};
        }
        public static function advance(state:Object,amount:int):Object {
            var p:Object=normalize(state),before:int=p.stars;
            var progress:Number=Number(p.progress)+Math.max(0,amount);
            while(p.stars<12&&progress>=target(p.stars)) {progress-=target(p.stars);p.stars++;}
            var cycles:int=p.stars==12?int(progress/1125):0;
            if(cycles>0)progress-=cycles*1125;
            p.progress=int(progress);p.cycles+=cycles;
            state.mastery=Math.min(10000000,Number(state.mastery)+Math.max(0,amount));p.sourceMastery=state.mastery;
            var result:Object=info(state);result.skillPoints=(int(p.stars)-before)*2;result.energy=cycles*5;
            result.earnedStars=int(p.stars)-before;result.earnedCycles=cycles;return result;
        }
    }
}
