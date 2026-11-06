package com.bh.model {
    /** Luck increases hit charge; MAX turns fair contact into a Home Run.
     * The 10-unit scale, Luck thresholds and partial buffs remain remake balance. */
    public class MatchMomentum {
        public static const MAX:int=10;
        public var charge:int=0,tier:int=0,gained:int=0,spent:int=0;
        public var comeback:Boolean=false;
        public function gain(result:String,luck:int=0):int {
            var hit:Boolean=/SINGLE|DOUBLE|TRIPLE|HOME RUN/.test(result);
            var n:int=hit?1+int(Math.max(0,Math.min(99,luck))/40)+(result.indexOf("HOME RUN")>=0?1:0):0;
            var before:int=charge;charge=Math.min(MAX,charge+n);gained+=charge-before;return charge-before;
        }
        public function boost(n:int):int {var before:int=charge;charge=Math.min(MAX,charge+Math.max(0,n));gained+=charge-before;return charge-before;}
        public function beginPlate(inning:int,ours:int,theirs:int,runners:Boolean):Object {
            tier=charge>=MAX?3:charge>=7?2:charge>=4?1:0;spent=0;
            comeback=inning>=5&&ours<theirs&&runners;return snapshot();
        }
        public function get maxReady():Boolean {return tier==3&&charge>=MAX;}
        public function resultOnContact(result:String):String {return maxReady?"HOME RUN":result;}
        public function strikeout():void {spent=charge;charge=0;tier=0;comeback=false;}
        public function consumeMax():Boolean {if(!maxReady)return false;spent=charge;charge=0;tier=0;return true;}
        public function get contactBonus():int{return tier*2+(comeback?2:0);}
        public function get powerBonus():int{return tier*3+(comeback?3:0);}
        public function snapshot():Object{return {charge:charge,max:MAX,tier:tier,spent:spent,comeback:comeback,contact:contactBonus,power:powerBonus,maxReady:maxReady};}
    }
}
