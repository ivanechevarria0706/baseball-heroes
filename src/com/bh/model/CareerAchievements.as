package com.bh.model {
    /** Verified milestone targets; rewards without video evidence are local reconstructions. */
    public class CareerAchievements {
        public static const TIERS:Array=["BRONZE","SILVER","GOLD","DIAMOND"];
        public static const STATS:Array=["hits","homeRuns","grandSlams","rbi","triples","mvp","cardsBought","trades","wins","closeWins","multiHitGames","singles","doubles","walks","extraWins","friends","giftsSent","giftsReceived","pitchBreaking","pitchFourSeam","pitchTwoSeam","heroAttempts","luckyHits"];
        public static function catalog():Array {return [
            {id:"heroAttempts",title:"HARDWORKING HITTER",label:"Hero plate appearances completed",targets:[500,1000,2000,5000],reconstructed:true},
            {id:"luckyHits",title:"LUCKY HITTER",label:"Lucky Hit effects earned",targets:[25,50,100,250],reconstructed:true},
            {id:"friends",title:"GIANT TEAM",label:"Registered friends",targets:[10,20,30,50]},
            {id:"homeRuns",title:"HOME RUN KING",label:"Total home runs",targets:[100,200,450,900]},
            {id:"grandSlams",title:"POWER HITTER",label:"Total grand slams",targets:[10,30,60,100]},
            {id:"rbi",title:"CLUTCH HITTER",label:"Runs batted in",targets:[150,500,1000,1500]},
            {id:"hits",title:"HIT MAKER",label:"Total hits",targets:[200,800,1800,3000]},
            {id:"mvp",title:"MOST VALUABLE PLAYER",label:"Hero MVP awards",targets:[50,100,200,400]},
            {id:"wins",title:"INVINCIBLE TEAM",label:"Games won",targets:[100,300,500,1000]},
            {id:"extraWins",title:"CLOSER",label:"Extra-inning wins",targets:[20,50,100,150]},
            {id:"singles",title:"SINGLE HITTER",label:"Total singles",targets:[150,300,700,1500]},
            {id:"doubles",title:"DOUBLE HITTER",label:"Total doubles",targets:[100,200,500,1000]},
            {id:"walks",title:"EAGLE EYE",label:"Total walks",targets:[5,10,20,50]},
            {id:"triples",title:"TRIPLE HITTER",label:"Total triples",targets:[50,150,300,500]},
            {id:"cardsBought",title:"BEST SCOUT",label:"Cards purchased",targets:[20,40,80,150]},
            {id:"trades",title:"TRADE MASTER",label:"Trades completed",targets:[5,15,30,70]},
            {id:"giftsSent",title:"SANTA CLAUS",label:"Gifts sent",targets:[30,80,150,300]},
            {id:"giftsReceived",title:"POPULAR PLAYER",label:"Gifts received",targets:[30,80,150,300]}
        ];}
        public static function create():Object {
            var s:Object={version:1,stats:{},claims:{},lastMatches:[]};for each(var id:String in STATS)s.stats[id]=0;return s;
        }
        public static function count(value:*):int {var n:Number=Number(value);return isFinite(n)?int(Math.max(0,Math.min(100000000,Math.floor(n)))):0;}
        public static function normalize(value:Object):Object {
            var s:Object=create();if(!value||value is Array)return s;
            if(value.stats&&!(value.stats is Array))for each(var id:String in STATS)s.stats[id]=count(value.stats[id]);
            if(value.claims&&!(value.claims is Array))for each(var item:Object in catalog())for(var tier:int=0;tier<4;tier++)if(value.claims[item.id+":"+tier]===true)s.claims[item.id+":"+tier]=true;
            if(value.lastMatches is Array)for each(var key:* in value.lastMatches.slice(-256))if(key is String&&key.length<100&&s.lastMatches.indexOf(key)<0)s.lastMatches.push(key);
            return s;
        }
        public static function legacy(hero:Object,wins:int,bought:int):Object {
            var s:Object=create();s.stats.hits=count(hero.careerHits);s.stats.homeRuns=count(hero.hr);s.stats.rbi=count(hero.rbi);s.stats.triples=count(hero.triples);
            s.stats.wins=count(wins);s.stats.cardsBought=count(bought);return s;
        }
        public static function byId(id:String):Object {for each(var item:Object in catalog())if(item.id==id)return item;return null;}
        public static function reward(tier:int):int {return tier>=0&&tier<4?int([2000,4000,8000,16000][tier]):0;}
        public static function claim(s:Object,id:String,tier:int):Object {
            var item:Object=byId(id);if(!item||tier<0||tier>3)return {status:"INVALID"};
            var key:String=id+":"+tier;if(s.claims[key]===true)return {status:"CLAIMED"};
            if(count(s.stats[id])<int(item.targets[tier]))return {status:"INCOMPLETE"};
            s.claims[key]=true;return {status:"OK",coins:reward(tier),id:id,tier:tier,title:item.title};
        }
        public static function available(s:Object):int {var total:int=0;for each(var item:Object in catalog())for(var i:int=0;i<4;i++)if(count(s.stats[item.id])>=int(item.targets[i])&&s.claims[item.id+":"+i]!==true)total++;return total;}
        public static function trophies(s:Object,tier:int):int {var total:int=0;for each(var item:Object in catalog())if(count(s.stats[item.id])>=int(item.targets[tier]))total++;return total;}
        public static function add(s:Object,id:String,amount:int=1):void {if(STATS.indexOf(id)>=0)s.stats[id]=count(Number(s.stats[id])+Math.max(0,amount));}
        /** Commit only completed career fixtures; abandoned/restarted innings do not add medals. */
        public static function match(s:Object,key:String,heroName:String,home:int,away:int,rows:Array,extra:Boolean=false):Boolean {
            if(!key||s.lastMatches.indexOf(key)>=0)return false;
            s.lastMatches.push(key);while(s.lastMatches.length>256)s.lastMatches.shift();
            var hero:Object=null,mvpSlot:int=MatchScoring.mvpIndex(rows);
            for each(var row:Object in rows||[]) {
                if(row.isHero===true||(row.isHero===undefined&&row.name==heroName))hero=row;
            }
            if(hero){
                add(s,"hits",count(hero.hits));add(s,"homeRuns",count(hero.homeRuns));add(s,"rbi",count(hero.rbi));add(s,"triples",count(hero.triples));add(s,"grandSlams",count(hero.grandSlams));
                add(s,"singles",count(hero.singles));add(s,"doubles",count(hero.doubles));add(s,"walks",count(hero.walks));
                if(hero.pitchHits){add(s,"pitchBreaking",count(hero.pitchHits.breaking));add(s,"pitchFourSeam",count(hero.pitchHits.fourSeam));add(s,"pitchTwoSeam",count(hero.pitchHits.twoSeam));}
                if(count(hero.singles)>=3)add(s,"multiHitGames");
                // Keep the career's winning-game requirement, but use the same
                // player as the result card. A teammate MVP is not a hero medal.
                if(home>away&&mvpSlot>=0&&hero===rows[mvpSlot])add(s,"mvp");
            }
            if(home>away){add(s,"wins");if(extra)add(s,"extraWins");if(home-away==1)add(s,"closeWins");}
            return true;
        }
    }
}
