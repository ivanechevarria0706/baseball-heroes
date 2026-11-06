package com.bh.model {
    /** New usable catalog entries based on the supplied logos; prices are local. */
    public class StadiumCatalog {
        public static function items():Array {
            var a:Array=[],cities:Array=["COLORADO","BALTIMORE","SEATTLE","OAKLAND","DETROIT","HOUSTON","TORONTO","ARIZONA","LOS ANGELES","NEW YORK","PITTSBURGH","CINCINNATI","CLEVELAND","SAINT LOUIS","MINNESOTA","TAMPA BAY","BOSTON","KANSAS CITY","TEXAS","MILWAUKEE","MIAMI","SAN FRANCISCO","SAN DIEGO","WASHINGTON","CHICAGO","ATLANTA","PHILADELPHIA"];
            for(var i:int=0;i<cities.length;i++)a.push({id:"stadium_deco_mascot_"+i,name:cities[i]+" MASCOT",category:"STADIUM",slot:"decoration",grade:"RARE",accent:0x2b94c5,coinPrice:800+i*100,cashPrice:0,unlockLeague:0,power:0,contact:0,speed:0,luck:0,energy:0,city:cities[i],description:"Decorative figure based on the emblem of "+cities[i]+"."});
            var slots:Array=["field","stand","scoreboard","lights"],names:Array=["EMERALD","SUNSET","OCEAN","VIOLET"],colors:Array=[0x64ad56,0xd2844a,0x319cba,0x8273a5];
            for each(var slot:String in slots)for(i=0;i<4;i++)a.push({id:"stadium093_"+slot+"_"+i,name:names[i]+" "+slot.toUpperCase(),category:"STADIUM",slot:slot,grade:i<2?"RARE":"ELITE",accent:colors[i],coinPrice:1200+i*650,cashPrice:0,unlockLeague:i<2?0:1,power:0,contact:0,speed:0,luck:0,energy:0,description:"Customize this part of your stadium."});
            a.push({id:"stadium_background_mountain095",name:"ROOKIE MOUNTAIN PARK",category:"STADIUM",slot:"background",grade:"NORMAL",accent:0x348e4a,coinPrice:1800,cashPrice:0,unlockLeague:0,power:0,contact:0,speed:0,luck:0,energy:0,description:"Illustrated mountain ballpark · full background."});
            a.push({id:"stadium_background_civic095",name:"CIVIC SINGLE-A PARK",category:"STADIUM",slot:"background",grade:"RARE",accent:0x2585bc,coinPrice:6500,cashPrice:0,unlockLeague:1,power:0,contact:0,speed:0,luck:0,energy:0,description:"Illustrated civic ballpark · full background."});
            return a;
        }
    }
}
