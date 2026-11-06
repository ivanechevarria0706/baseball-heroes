package com.bh.model {
    /** Bounded client history; shared leaderboard is stored separately by server. */
    public class ScoreHistory {
        public static function normalize(raw:Object):Object {
            var s:Object={best:0,matches:[]};if(!raw)return s;
            s.best=Math.max(0,Math.min(10000000,int(raw.best)));
            if(raw.matches is Array)for each(var r:Object in raw.matches.slice(-120))if(r&&r.key&&r.points>=0&&r.points<=10000000)s.matches.push(r);
            return s;
        }
        public static function record(s:Object,summary:Object):void {
            if(!summary||!summary.fixtureKey||!summary.scoring)return;
            for each(var r:Object in s.matches)if(r.key==summary.fixtureKey)return;
            var points:int=int(summary.scoring.total);s.best=Math.max(int(s.best),points);
            s.matches.push({key:summary.fixtureKey,points:points,at:String(new Date().time),league:summary.leagueIndex});
            while(s.matches.length>120)s.matches.shift();
        }
    }
}
