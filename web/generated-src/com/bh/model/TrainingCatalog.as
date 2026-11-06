package com.bh.model {
    /** Session names, costs and rewards transcribed from supplied recordings.
     * Running uses its older, independently visible price table.
     * TrainingMastery documents the observed and reconstructed thresholds. */
    public class TrainingCatalog {
        public static function disciplines():Array {return [
            {id:"running",name:"RUNNING",color:0x299dd0,coach:0},
            {id:"stretching",name:"STRETCHING",color:0xe7a22b,coach:1},
            {id:"lifting",name:"LIFTING",color:0x28b6a4,coach:2}
        ];}
        public static function discipline(id:String):Object {
            for each(var row:Object in disciplines())if(row.id==id)return row;
            return null;
        }
        public static function activities(id:String):Array {
            var ids:Array,names:Array,costs:Array;
            if(id=="running") {
                ids=["yards30","meters100","mile","sliding","treadmill","longrun"];
                names=["30 YARDS","100 METERS","1 MILE RUN","SLIDING","RUNNING MACHINE","LONG RUN"];
                costs=[90,250,400,550,1000,1250];
            } else if(id=="stretching") {
                ids=["trunkTwist","kneeHug","legStretch","kneeBend","sideLunge","walkingLunge"];
                names=["TRUNK TWIST","KNEE HUG","LEG STRETCH","KNEE BEND","SIDE LUNGE","WALKING LUNGE"];
                costs=[120,350,600,800,1500,1800];
            } else if(id=="lifting") {
                ids=["pushUp","pullUp","barbellLunge","benchPress","legPress","butterfly"];
                names=["PUSH-UP","PULL-UP","BARBELL LUNGE","BENCH PRESS","LEG PRESS","BUTTERFLY MACHINE"];
                costs=[120,350,600,800,1500,1800];
            } else return [];
            var hours:Array=[1,4,8,12,24,48],mastery:Array=[60,150,225,300,480,600],xp:Array=[16,40,60,80,128,160],result:Array=[];
            for(var i:int=0;i<6;i++) {
                var a:Object={id:ids[i],name:names[i],hours:hours[i],cost:costs[i],mastery:mastery[i],xp:xp[i]};
                if(id=="running")a.mark=["30 YD","100 M","1 MI","SLIDE","24 H","48 H"][i];
                result.push(a);
            }
            return result;
        }
        public static function normalize(state:Object):Object {
            if(!state||typeof state!="object"||state is Array)state={};
            var m:Number=Number(state.mastery),at:Number=Number(state.availableAt);
            state.mastery=isFinite(m)?Math.max(0,Math.min(10000000,Math.floor(m))):0;
            // Milliseconds must remain strings: Ruffle truncates JSON integers.
            state.availableAt=String(isFinite(at)?Math.max(0,at):0);
            if(!(state.activity is String))state.activity="";
            if(!state.lastReward)state.lastReward=null;
            return state;
        }
    }
}
