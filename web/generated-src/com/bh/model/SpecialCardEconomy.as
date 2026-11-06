package com.bh.model {
    /** Visible quotes in facebook_play_20261012, 04:59 and 05:40.
     * Only C trade and B Elite enhancement were observed. Other rows retain
     * the existing local balance; these are not recovered server tables. */
    public class SpecialCardEconomy {
        public static function trade(cardClass:String,payment:String):Object {
            var observed:Boolean=cardClass=="C";
            return {coins:payment=="COINS"?1000:0,cash:payment=="CASH"?(observed?32:13):0,
                chance:payment=="CASH"?1:observed?.07:.50};
        }
        public static function enhance(cardClass:String,grade:String,enhancement:int,payment:String,max:Boolean):Object {
            var observed:Boolean=cardClass=="B"&&grade=="ELITE",steps:int=max?5-enhancement:1;
            return {coins:payment=="COINS"?(observed?500:2500):0,
                cash:payment=="CASH"?(observed?(max?12:5):3*steps):0,
                chance:payment=="CASH"?1:observed?.07:Math.max(.30,.80-enhancement*.10),steps:steps};
        }
    }
}
