package com.bh.model {
    /** Local reconstruction: class and grade are independent axes.
     * Existing IDs/stats are preserved. New names, stats and pack weights are
     * remake content, not recovered Syntasia server tables.
     */
    public class SpecialCardCatalog {
        public static function cards():Array {return MLB2026Catalog.cards();}
        public static function classicCards():Array {return [];}
        private static function card(id:String,name:String,cardClass:String,grade:String,accent:uint,
            avg:int,combo:int,triggerInning:int,guaranteedHit:String,power:int,contact:int,speed:int,luck:int,description:String):Object {
            return {id:id,name:name,cardClass:cardClass,grade:grade,accent:accent,avg:avg,combo:combo,
                triggerInning:triggerInning,guaranteedHit:guaranteedHit,power:power,contact:contact,
                speed:speed,luck:luck,description:description};
        }
        public static function normalizeClass(value:String):String {
            return value=="B+"||value=="B++"?"B":value=="A+"||value=="A++"?"A":value;
        }
        public static function classColor(value:String):uint {
            return value=="S"?0xffcc50:value=="A"?0xc695eb:value=="B"?0x5fc9e8:0xa4df65;
        }
        public static function classPacks():Array {
            // facebook_play_20261012 at 03:40. Grade weights below remain local
            // balance; only the visible prices, grade ranges and locks are observed.
            return [
                pack("C",0x86bd35,5000,0,0,["A","RARE"]),
                pack("B++",0x3988bd,0,45,0,["RARE","ELITE"]),
                pack("B",0x3988bd,10000,0,2,["A","RARE"]),
                pack("B+",0x3988bd,15000,0,2,["A","RARE","ELITE"]),
                pack("A",0xdfa432,30000,0,3,["A","RARE","ELITE"]),
                pack("A+",0xdfa432,45000,0,3,["A","RARE","ELITE","HERO"]),
                pack("A++",0xdfa432,0,80,2,["ELITE","HERO"])
            ];
        }
        private static function pack(id:String,color:uint,coins:int,cash:int,league:int,grades:Array):Object {
            return {title:"Card Pack "+id,packClass:id,cardClass:normalizeClass(id),color:color,coins:coins,cash:cash,unlockLeague:league,grades:grades};
        }
        public static function packById(id:String):Object {
            for each(var p:Object in classPacks())if(p.packClass==id)return p;
            // The old S purchase stays callable; it is not an observed shop tile.
            return id=="S"?pack("S",0xd4a22f,0,72,0,["A","RARE","ELITE","HERO"]):null;
        }
        public static function gradeAllowed(cardClass:String,grade:String):Boolean {
            return ["C","B","A","S"].indexOf(cardClass)>=0&&["A","NORMAL","NORM","RARE","ELITE","HERO"].indexOf(grade)>=0;
        }
        public static function eligibleGrade(cardClass:String,grade:String):String {
            return gradeAllowed(cardClass,grade)?grade:"ELITE";
        }
        public static function classPackGrade(roll:Number,cardClass:String="S"):String {
            return eligibleGrade(cardClass,roll<.60?"A":roll<.85?"RARE":roll<.97?"ELITE":"HERO");
        }
        public static function packWeights(id:String):Array {
            var p:Object=packById(id);if(!p)return [];
            var base:Object={A:60,RARE:25,ELITE:12,HERO:3},total:Number=0,result:Array=[];
            for each(var g:String in p.grades)total+=Number(base[g]);
            for each(g in p.grades)result.push({grade:g,chance:Number(base[g])/total});
            return result;
        }
        public static function packGrade(id:String,roll:Number):String {
            var weights:Array=packWeights(id);if(!weights.length)return "";
            if(!isFinite(roll))roll=0;roll=Math.max(0,Math.min(.999999999,roll));
            var cumulative:Number=0;
            for each(var row:Object in weights){cumulative+=row.chance;if(roll<cumulative)return row.grade;}
            return weights[weights.length-1].grade;
        }
        public static function gradeLabel(grade:String):String {return grade=="A"?"NORMAL":grade;}
        public static function packLeagueName(index:int):String {return ["ROOKIE","SINGLE-A","DOUBLE-A","TRIPLE-A","MAJOR"][Math.max(0,Math.min(4,index))];}
        public static function packGradeLabel(id:String):String {
            var p:Object=packById(id),names:Array=[];if(!p)return "";
            for each(var g:String in p.grades)names.push(gradeLabel(g));return names.join(" / ");
        }
        public static function mixedClass(roll:Number,premium:Boolean):String {
            if(premium)return roll<.10?"C":roll<.50?"B":roll<.85?"A":"S";
            return roll<.54?"C":roll<.84?"B":roll<.97?"A":"S";
        }
        public static function pick(cardClass:String,grade:String,roll:Number):Object {
            var pool:Array=[];
            for each(var c:Object in cards())if(c.cardClass==cardClass&&c.grade==grade)pool.push(c);
            if(!pool.length)return null;
            return pool[Math.max(0,Math.min(pool.length-1,int(roll*pool.length)))];
        }
    }
}
