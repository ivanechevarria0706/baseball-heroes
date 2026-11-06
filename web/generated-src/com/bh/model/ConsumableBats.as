package com.bh.model {
    /** x5 / +400 / 12 cash are visible in primer_lugar-0470.
     * One unit per paid career fixture is a local rule, not a recovered server formula.
     * Stock excludes the unit reserved by specialMatch; its snapshot lasts all game. */
    public class ConsumableBats {
        public static const CAP:int=9999;
        public static function catalog():Array {
            var result:Array=[],stats:Array=["contact","power","luck"],colors:Array=[0x36aee4,0xe94b42,0x89c43a];
            for(var i:int=0;i<stats.length;i++){
                var stat:String=stats[i],id:String="bat094_"+stat+"400";
                var item:Object={id:id,consumableId:id,name:["Contact 400","Power 400","Luck 400"][i],category:"EQUIPMENT",slot:"bat",grade:"HERO",accent:colors[i],coinPrice:0,cashPrice:12,unlockLeague:0,unlockLevel:1,bundle:5,power:0,contact:0,speed:0,luck:0,description:"5 bats. One bat per regular season or postseason game."};
                item[stat]=400;result.push(item);
            }
            return result;
        }
        public static function byId(id:String):Object {for each(var item:Object in catalog())if(item.id==id)return item;return null;}
        public static function isBat(item:Object):Boolean {return item!=null&&item.consumableId!=null&&byId(String(item.consumableId))!=null;}
        public static function create():Object {return {stock:{},returnName:"Rookie Bat",expired:null};}
        public static function normalize(value:Object):Object {
            var state:Object=create();
            if(!value)return state;
            for each(var item:Object in catalog()){
                var n:Number=value.stock?Number(value.stock[item.id]):0;
                state.stock[item.id]=isFinite(n)?int(Math.max(0,Math.min(CAP,n))):0;
            }
            if(value.returnName is String)state.returnName=value.returnName;
            if(value.expired&&byId(String(value.expired.id))&&value.expired.fixture is String)
                state.expired={id:String(value.expired.id),fixture:String(value.expired.fixture)};
            return state;
        }
        public static function count(state:Object,item:Object):int {return isBat(item)&&state&&state.stock?Math.max(0,int(state.stock[item.consumableId])):0;}
        public static function add(state:Object,item:Object):Boolean {
            var amount:int=int(item.bundle);
            if(!isBat(item)||amount<=0||count(state,item)>CAP-amount)return false;
            state.stock[item.consumableId]=count(state,item)+amount;return true;
        }
    }
}
