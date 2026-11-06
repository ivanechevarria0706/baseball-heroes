package com.bh.model {
    /** Key costs are documented by Gamelytic. Prize pools and weights remain remake balance. */
    public class MysteryCatalog {
        public static const KINDS:Array=["rookie","single_a","double_a","triple_a","majors"];
        public static const CLASSES:Array=["C","B","A","S"];
        public static function boxes():Array {
            return [
                {id:"rookie",title:"Rookie",keys:2,color:0xde9a31,light:0xffe469,dark:0xa26418,packClass:"C",coins:[1000,2000,6000],energy:3},
                {id:"single_a",title:"A",keys:3,color:0x83bc28,light:0xc9ed60,dark:0x427a13,packClass:"C",coins:[6000,12000,30000],energy:5},
                {id:"double_a",title:"AA",keys:4,color:0x318acb,light:0xa0e4ff,dark:0x19508e,packClass:"B",coins:[12000,24000,40000],energy:7},
                {id:"triple_a",title:"AAA",keys:5,color:0xd6a62d,light:0xffe783,dark:0x9a701e,packClass:"A",coins:[20000,35000,60000],energy:10},
                {id:"majors",title:"MAJOR",keys:7,color:0xce3f43,light:0xff9b79,dark:0x8a242c,packClass:"S",coins:[30000,60000,90000],energy:15}
            ];
        }
        public static function box(id:String):Object {for each(var b:Object in boxes())if(b.id==id)return b;return null;}
        public static function forLeague(league:int):String {return String(KINDS[Math.max(0,Math.min(4,league))]);}
        public static function packClass(kind:String):String {return kind=="pack"?"C":kind.indexOf("pack_")==0&&CLASSES.indexOf(kind.substr(5))>=0?kind.substr(5):"";}
        public static function packKind(value:String):String {return value=="C"?"pack":"pack_"+value;}
        public static function gear(kind:String):Array {
            var tier:int=KINDS.indexOf(kind),result:Array=[];
            if(tier<0)return result;
            var limit:int=int([4,5,15,25,70][tier]);
            for each(var item:Object in EquipmentCatalog.items())
                if(["bat","glove","goggles"].indexOf(item.slot)>=0&&item.unlockLevel<=limit)result.push(item);
            return result;
        }
        public static function gearById(id:String):Object {for each(var item:Object in EquipmentCatalog.items())if(item.id==id&&["bat","glove","goggles"].indexOf(item.slot)>=0)return item;return null;}
    }
}
