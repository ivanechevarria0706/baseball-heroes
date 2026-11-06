package com.bh.model {
    /** Local event ledger. Play XP is provisional until the fixture commits.
     * 2 XP/hit, 5/HR and 1/walk are local balance, not recovered formulas.
     * End objective rewards follow the historical guide; rank/play points remain local. */
    public class MatchScoring {
        public var points:int=0,hitStreak:int=0,hrStreak:int=0,bestStreak:int=0;
        public var events:Array=[];
        public var playCoins:int=0,playXP:int=0,luckyHits:int=0,heroAttempts:int=0;
        public function record(result:String,rbi:int,hero:Boolean):Object {
            var hit:Boolean=result.indexOf("SINGLE")>=0||result.indexOf("DOUBLE")>=0||result.indexOf("TRIPLE")>=0||result.indexOf("HOME RUN")>=0;
            var hr:Boolean=result.indexOf("HOME RUN")>=0,base:int=0;
            if(hr)base=10000;else if(result.indexOf("TRIPLE")>=0)base=5000;else if(result.indexOf("DOUBLE")>=0)base=2500;else if(hit)base=1000;else if(result.indexOf("WALK")>=0)base=500;
            if(hero){hitStreak=hit?hitStreak+1:0;hrStreak=hr?hrStreak+1:0;bestStreak=Math.max(bestStreak,hitStreak);}
            var multiplier:int=hero&&hit?Math.min(5,Math.max(1+(hitStreak-1)*2,hrStreak)):1;
            var earned:int=(base+Math.max(0,rbi)*2000)*multiplier;
            points+=earned;
            var coins:int=(hr?8:hit?3:result.indexOf("WALK")>=0?2:0)*multiplier,xp:int=hr?5:hit?2:result.indexOf("WALK")>=0?1:0;playCoins+=coins;playXP+=xp;if(hero)heroAttempts++;
            var event:Object={result:result,rbi:rbi,hero:hero,points:earned,total:points,multiplier:multiplier,hitStreak:hitStreak,hrStreak:hrStreak,coins:coins,xp:xp};
            events.push(event);return event;
        }
        public function snapshot():Object {return {version:4,points:points,bestStreak:bestStreak,playCoins:playCoins,playXP:playXP,luckyHits:luckyHits,heroAttempts:heroAttempts,events:events.concat()};}
        // Observed: 17 H / 9 R = S; 17 / 6 = A; 15 / 3 = B; 9 / 2 = C.
        // Compatible interpolation between observations, not a recovered rank table.
        public static function grade(hits:int,runs:int):String {return hits>=16&&runs>=8?"S":hits>=16&&runs>=6||hits>=10&&runs>=8?"A":hits>=10&&runs>=3?"B":hits>=6&&runs>=2||runs>=5?"C":"D";}
        public static function mvpIndex(rows:Array):int {
            var best:Object=null,index:int=-1;
            // Highest RBI, then HR, then hits; exact ties keep batting order.
            // This tie-break is a reconstruction shared with career medals.
            for(var i:int=0;rows&&i<rows.length;i++){
                var row:Object=rows[i];
                if(best==null||int(row.rbi)>int(best.rbi)||int(row.rbi)==int(best.rbi)&&(int(row.homeRuns)>int(best.homeRuns)||int(row.homeRuns)==int(best.homeRuns)&&int(row.hits)>int(best.hits))){best=row;index=i;}
            }
            return best!=null&&(int(best.rbi)>0||int(best.hits)>0||int(best.homeRuns)>0)?index:-1;
        }
        public static function settle(raw:Object,win:Boolean,draw:Boolean,rows:Array,hero:String,hits:int,hr:int,rbi:int,teamRuns:int,eventCoins:int=0):Object {
            var base:int=raw?Math.max(0,int(raw.points)):Math.max(0,hits-hr)*1000+Math.max(0,hr)*10000+Math.max(0,rbi)*2000;
            var heroRbi:int=0,teamHits:int=0,bestIndex:int=mvpIndex(rows),best:Object=bestIndex>=0?rows[bestIndex]:null;
            for(var rowIndex:int=0;rowIndex<rows.length;rowIndex++){
                var row:Object=rows[rowIndex];teamHits+=Math.max(0,int(row.hits));
                if(row.isHero===true||(row.isHero===undefined&&String(row.name)==hero))heroRbi=Math.max(0,int(row.rbi));
            }
            if(rows.length==0)teamHits=Math.max(0,hits);
            // The initial reference awards MVP with one RBI in a 1-0 game.
            // Selection and rank interpolation remain local rules, checked against observed cases.
            var rank:String=grade(teamHits,Math.max(0,teamRuns)),mvp:Boolean=!draw&&best!=null;
            var perfect:Boolean=!draw&&win&&mvp&&rank=="S";
            var active:Array=[!draw,!draw&&win,mvp,!draw&&rank=="S",perfect];
            var labels:Array=["GAME","WINNER","MVP","RANK","BONUS"],coinValues:Array=[100,50,100,150,500],xpValues:Array=[20,10,15,25,30];
            var rules:Array=["Finish the match.","Win the match.","Lead your team in RBI, then home runs and hits.","Finish with RANK S.","Earn GAME, WINNER, MVP and RANK S in the same match."];
            var pointValues:Array=[base,active[1]?25000:0,mvp?15000:0,active[3]?10000:0,perfect&&raw?int(raw.bestStreak)*500:0];
            var parts:Array=[],coins:int=0,xp:int=0,total:int=0;
            for(var i:int=0;i<5;i++){var c:int=active[i]?coinValues[i]:0,x:int=active[i]?xpValues[i]:0;coins+=c;xp+=x;total+=int(pointValues[i]);
                parts.push({id:labels[i],points:pointValues[i],coins:c,xp:x,active:active[i],condition:rules[i],potentialCoins:coinValues[i],potentialXp:xpValues[i]});}
            var earnedXP:int=draw?0:Math.min(2000,Math.max(0,raw&&int(raw.version)>=4?int(raw.playXP):0));
            var play:int=draw?0:Math.min(10000,Math.max(0,raw?int(raw.playCoins):0)),extra:int=draw?0:Math.max(0,eventCoins);
            return {version:5,heroAttempts:raw?int(raw.heroAttempts):0,luckyHits:raw?int(raw.luckyHits):0,playCoins:play,playXP:earnedXP,objectiveXP:xp,eventCoins:extra,rewardCoins:coins+play+extra,rewardXp:xp+earnedXP,points:base,total:total,rank:rank,mvp:mvp,mvpName:mvp?best.name:"—",mvpSlot:mvp?bestIndex:-1,heroMvp:mvp&&(best.isHero===true||best.isHero===undefined&&String(best.name)==hero),heroRbi:heroRbi,teamHits:teamHits,teamRuns:teamRuns,perfect:perfect,breakdown:parts,bestStreak:raw?raw.bestStreak:0,events:raw?raw.events:[]};
        }
    }
}
