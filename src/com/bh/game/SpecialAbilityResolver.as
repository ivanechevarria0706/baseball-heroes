package com.bh.game {
    import com.bh.model.GameData;

    /** One ability attempt per card's specified inning, scoped to one match.
     * Grade probabilities are visible at 13:10 in the supplied first video.
     * The once-per-inning attempt policy is retained from the local prototype.
     */
    public class SpecialAbilityResolver {
        private var attempts:Object={};
        private var randomValue:Function;
        public function SpecialAbilityResolver(randomSource:Function=null) {
            randomValue=randomSource!=null?randomSource:Math.random;
        }
        public function resolve(card:Object,inning:int):String {
            if(!card || !card.id || inning<1 || inning!=int(card.triggerInning)) return "";
            var hit:String=String(card.guaranteedHit);
            if(["SINGLE","DOUBLE","TRIPLE"].indexOf(hit)<0) return "";
            var key:String=String(card.id)+"_"+inning;
            if(attempts[key])return "";
            // A failed ability roll is still an attempt; ordinary batting follows.
            attempts[key]=true;
            var roll:Number=Number(randomValue());
            return roll>=0 && roll<1 && roll<GameData.specialAbilityChance(card) ? hit : "";
        }
    }
}
