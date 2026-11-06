package com.bh.model {
    /** Versioned lessons. Existing v1 progress resumes without replaying purchases. */
    public class StarterTutorial {
        public static const SHOP:int=0,PACK:int=1,CARD:int=2,SUBSTITUTE:int=3,ORDER:int=4,PLAY:int=5,MATCH:int=6,POINT:int=7,CLAIM:int=8,DONE:int=9;
        public static const REORDER:int=10,AUTOSORT:int=11,DRAFT:int=12,REWARD:int=13,NAME:int=14,TICKETS:int=15;
        public static function create(enabled:Boolean=false):Object {return {version:2,lesson:2,enabled:enabled,stage:enabled?SHOP:DONE,cardId:"",fixtureKey:"",claimed:false,skipped:false,hints:{}};}
        public static function normalize(raw:Object):Object {
            if(!raw||[1,2].indexOf(int(raw.version))<0||raw is Array)return create();
            var t:Object=create(Boolean(raw.enabled));t.lesson=int(raw.version)==1?1:int(raw.lesson)==1?1:2;
            t.stage=Math.max(0,Math.min(TICKETS,int(raw.stage)));t.cardId=String(raw.cardId||"");t.fixtureKey=String(raw.fixtureKey||"");
            t.claimed=raw.claimed===true;t.skipped=raw.skipped===true;t.hints=raw.hints&&!(raw.hints is Array)?raw.hints:{};
            if(t.skipped||!t.enabled||t.lesson==1&&t.claimed)t.stage=DONE;
            return t;
        }
        public static function active(t:Object):Boolean {return t&&t.enabled&&!t.skipped&&int(t.stage)!=DONE&&!(int(t.lesson)==1&&t.claimed);}
        public static function event(t:Object,action:String,value:String=""):Boolean {
            if(!active(t))return false;
            var before:int=int(t.stage),modern:Boolean=int(t.lesson)!=1;
            if(action=="purchase"&&before==SHOP){t.cardId=value;t.stage=PACK;}
            else if(action=="open"&&before==PACK)t.stage=CARD;
            else if(action=="card"&&before==CARD)t.stage=SUBSTITUTE;
            else if(action=="substitute"&&before==SUBSTITUTE&&(modern||value==t.cardId))t.stage=modern?REORDER:ORDER;
            else if(action=="order"&&before==REORDER)t.stage=AUTOSORT;
            else if(action=="order"&&before==ORDER)t.stage=PLAY;
            else if(action=="auto"&&before==AUTOSORT)t.stage=PLAY;
            else if(action=="start"&&before==PLAY){t.fixtureKey=value;t.stage=MATCH;}
            else if(action=="finish"&&before==MATCH&&value==t.fixtureKey)t.stage=POINT;
            else if(action=="point"&&before==POINT)t.stage=modern?DRAFT:CLAIM;
            else if(action=="draft"&&before==DRAFT)t.stage=REWARD;
            else if(action=="reward"&&before==REWARD)t.stage=NAME;
            else if(action=="name"&&before==NAME)t.stage=TICKETS;
            else if(action=="tickets"&&before==TICKETS)t.stage=DONE;
            return before!=int(t.stage);
        }
        public static function skip(t:Object):void {if(active(t)){t.skipped=true;t.stage=DONE;}}
        public static function claim(t:Object):int {
            if(!active(t)||t.claimed||t.stage!=CLAIM&&t.stage!=DRAFT)return 0;
            t.claimed=true;if(t.stage==CLAIM)t.stage=DONE;return 40000;
        }
    }
}
