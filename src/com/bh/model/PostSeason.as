package com.bh.model {
    /** Local reconstruction: eight clubs, two league brackets, first to three wins.
     * The video verifies the bracket and semifinal requirement, not CPU formulas. */
    public class PostSeason {
        public static const ROUND_NAMES:Array=["N-League Semi Final","N-League Final","World Championship"];
        public static function create(season:int,league:int,rank:int,hero:Object,candidates:Array):Object {
            var state:Object={version:1,season:season,leagueIndex:league,rank:rank,status:"active",round:0,hero:-1,teams:[],series:[],champion:-1,lastResult:null};
            var seeds:Array=[1,4,2,3,1,4,2,3],cursor:int=0;
            for(var i:int=0;i<8;i++) {
                var isHero:Boolean=i<4&&int(seeds[i])==rank;
                var club:Object=JSON.parse(JSON.stringify(isHero?hero:candidates[cursor++]));
                club.seed=seeds[i];club.isHero=isHero;club.group=i<4?"N":"A";
                state.teams.push(club);if(isHero)state.hero=i;
            }
            for(i=0;i<4;i++)state.series.push(series(i,0,i*2,i*2+1));
            advance(state);return state;
        }
        private static function series(id:int,round:int,home:int,away:int):Object {
            return {id:id,round:round,home:home,away:away,homeWins:0,awayWins:0,winner:-1,games:[]};
        }
        public static function valid(s:Object):Boolean {
            if(!s||s.version!=1||!(s.teams is Array)||s.teams.length!=8||!(s.series is Array)||s.series.length<4||s.series.length>7||int(s.hero)<0||int(s.hero)>3||int(s.round)<0||int(s.round)>2)return false;
            if(["active","eliminated","champion"].indexOf(String(s.status))<0)return false;
            for each(var t:Object in s.teams)if(!t||!t.city||!t.teamName||!t.repertoire)return false;
            for each(var x:Object in s.series)if(!x||!(x.games is Array)||int(x.home)<0||int(x.home)>7||int(x.away)<0||int(x.away)>7||int(x.winner)<-1||int(x.winner)>7||int(x.homeWins)<0||int(x.homeWins)>3||int(x.awayWins)<0||int(x.awayWins)>3)return false;
            return true;
        }
        public static function activeSeries(s:Object):Object {
            if(!s||s.status!="active")return null;
            for each(var x:Object in s.series)if(x.round==s.round&&int(x.winner)<0&&(x.home==s.hero||x.away==s.hero))return x;
            return null;
        }
        public static function opponent(s:Object):Object {
            var x:Object=activeSeries(s);return x?s.teams[x.home==s.hero?x.away:x.home]:null;
        }
        public static function key(s:Object):String {
            var x:Object=activeSeries(s);return x?"post:"+s.leagueIndex+":"+s.season+":"+x.id+":"+x.games.length:"";
        }
        public static function label(s:Object):String {return s?String(ROUND_NAMES[Math.max(0,Math.min(2,int(s.round)))]):"POST SEASON";}
        public static function record(s:Object,heroScore:int,rivalScore:int):Object {
            var x:Object=activeSeries(s);if(!x)return null;
            var homeHero:Boolean=x.home==s.hero,draw:Boolean=heroScore==rivalScore,win:Boolean=heroScore>rivalScore;
            x.games.push({homeScore:homeHero?heroScore:rivalScore,awayScore:homeHero?rivalScore:heroScore,draw:draw,simulated:false});
            if(!draw){if(homeHero==win)x.homeWins++;else x.awayWins++;}
            if(x.homeWins==3)x.winner=x.home;else if(x.awayWins==3)x.winner=x.away;
            var progress:Object={round:x.round,seriesId:x.id,game:x.games.length,draw:draw,heroWins:homeHero?x.homeWins:x.awayWins,rivalWins:homeHero?x.awayWins:x.homeWins,seriesComplete:int(x.winner)>=0};
            if(int(x.winner)>=0&&x.winner!=s.hero)s.status="eliminated";
            advance(s);progress.status=s.status;return progress;
        }
        private static function simulate(s:Object,x:Object):void {
            // Stable local opponents: results are generated once and persisted.
            var seed:int=int(s.season)*31+int(s.leagueIndex)*17+int(x.id)*11;
            var favorite:int=int(s.teams[x.home].seed)<=int(s.teams[x.away].seed)?x.home:x.away;
            var winner:int=seed%7==0?(favorite==x.home?x.away:x.home):favorite;
            var losses:int=seed%3;
            for(var i:int=0;i<3+losses;i++) {
                var homeWin:Boolean=(i<losses)?winner!=x.home:winner==x.home;
                var low:int=1+(seed+i)%4,high:int=low+1+(seed+i*3)%5;
                x.games.push({homeScore:homeWin?high:low,awayScore:homeWin?low:high,draw:false,simulated:true});
                if(homeWin)x.homeWins++;else x.awayWins++;
            }
            x.winner=winner;
        }
        private static function advance(s:Object):void {
            while(true) {
                var rounds:Array=[];
                for each(var x:Object in s.series)if(x.round==s.round){
                    if(int(x.winner)<0&&x.home!=s.hero&&x.away!=s.hero)simulate(s,x);
                    rounds.push(x);
                }
                for each(x in rounds)if(int(x.winner)<0)return;
                if(s.round==2){s.champion=rounds[0].winner;s.status=s.champion==s.hero?"champion":"eliminated";return;}
                s.round++;
                for(var i:int=0;i<rounds.length;i+=2)s.series.push(series(s.series.length,s.round,rounds[i].winner,rounds[i+1].winner));
            }
        }
    }
}
