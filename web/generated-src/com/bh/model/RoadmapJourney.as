package com.bh.model {
    /** The documented fourth Class-A step; optional rewards never gate promotion. */
    public class RoadmapJourney {
        public static function create():Object {return {seasons:{},letters:{},champions:{},claims:{},fixtures:[]};}
        public static function normalize(value:Object,league:int,last:Object,history:Array):Object {
            var out:Object=create();
            if(value&&!(value is Array)){
                for each(var kind:String in ["seasons","letters","champions","claims"])for(var i:int=0;i<5;i++)if(value[kind]&&value[kind][String(i)]!==undefined)out[kind][String(i)]=kind=="letters"?CareerAchievements.count(value[kind][String(i)]):value[kind][String(i)]===true;
                if(value.fixtures is Array)for each(var key:* in value.fixtures.slice(-256))if(key is String&&key.length<80&&out.fixtures.indexOf(key)<0)out.fixtures.push(key);
            }
            for(i=0;i<league;i++)out.seasons[String(i)]=true;
            if(last&&last.leagueIndex!==undefined)out.seasons[String(int(last.leagueIndex))]=true;
            for each(var entry:Object in history||[])if(entry.status=="champion")out.champions[String(int(entry.leagueIndex))]=true;
            return out;
        }
        public static function completed(s:Object,league:int):Boolean {return s&&s.seasons[String(league)]===true;}
        public static function record(s:Object,key:String,league:int,win:Boolean,seasonEnd:Boolean):void {
            if(!key||s.fixtures.indexOf(key)>=0)return;s.fixtures.push(key);while(s.fixtures.length>256)s.fixtures.shift();if(seasonEnd)s.seasons[String(league)]=true;
        }
        public static function optionalReady(s:Object,league:int):Boolean {return CareerAchievements.count(s.letters[String(league)])>=7&&s.champions[String(league)]===true;}
        public static function claimOptional(s:Object,league:int):Object {
            if(league!=1)return {status:"UNCONFIRMED"};if(s.claims[String(league)]===true)return {status:"CLAIMED"};if(!optionalReady(s,league))return {status:"LOCKED"};
            s.claims[String(league)]=true;return {status:"OK",coins:4000};
        }
    }
}
