package com.bh.model {
    /** Match-local totals, independent of career stats and mutable roster order. */
    public class MatchBoxScore {
        private var rows:Array=[];
        public function MatchBoxScore(lineup:Array){
            for(var i:int=0;i<lineup.length;i++){
                var p:Object=lineup[i];
                rows.push({slot:i,mlbId:p.mlbId||0,normalPlayer:p.normalPlayer===true,name:String(p.name),accent:uint(p.accent),appearance:p.appearance||null,pos:p.pos||'',hits:0,homeRuns:0,rbi:0,atBats:0,walks:0,singles:0,doubles:0,triples:0,grandSlams:0,pitchHits:{breaking:0,fourSeam:0,twoSeam:0},isHero:String(p.name)==String(GameData.mainPlayer().name),specialCardId:''});
            }
        }
        public function record(slot:int,player:Object,result:String,rbi:int,pitch:String=""):void {
            if(slot<0||slot>=rows.length)return;
            var row:Object=rows[slot];
            row.mlbId=player.mlbId||0;row.normalPlayer=player.normalPlayer===true;row.name=String(player.name);row.accent=uint(player.accent);row.appearance=player.appearance||null;
            if(player.specialCardId)row.specialCardId=String(player.specialCardId);
            var walk:Boolean=result.indexOf('WALK')==0;
            var homer:Boolean=result.indexOf('HOME RUN')==0;
            var hit:Boolean=homer||result.indexOf('SINGLE')==0||result.indexOf('DOUBLE')==0||result.indexOf('TRIPLE')==0;
            if(walk)row.walks++;else row.atBats++;
            if(hit){row.hits++;if(pitch=="FASTBALL")row.pitchHits.fourSeam++;else if(pitch=="SINKER")row.pitchHits.twoSeam++;else if(pitch=="CURVEBALL"||pitch=="SLIDER")row.pitchHits.breaking++;}
            if(homer){row.homeRuns++;if(rbi==4)row.grandSlams++;}
            if(result.indexOf('SINGLE')==0)row.singles++;
            if(result.indexOf('DOUBLE')==0)row.doubles++;
            if(result.indexOf('TRIPLE')==0)row.triples++;
            row.rbi+=Math.max(0,rbi);
        }
        public function heroValue(field:String):int {for each(var row:Object in rows)if(row.isHero)return Math.max(0,int(row[field]));return 0;}
        public function snapshot():Array {
            return JSON.parse(JSON.stringify(rows)) as Array;
        }
    }
}
