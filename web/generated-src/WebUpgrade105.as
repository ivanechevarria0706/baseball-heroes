package {
    import flash.display.*;
    import flash.external.ExternalInterface;
    import com.bh.core.Game;
    import com.bh.model.*;
    public class WebUpgrade105 extends WebUpgrade104 {
        public function WebUpgrade105(){super();ExternalInterface.addCallback("bh105",run105);}
        private function check105(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
        private function game105(c:DisplayObjectContainer):Game {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d as Game;if(d is DisplayObjectContainer){var g:Game=game105(d as DisplayObjectContainer);if(g)return g;}}return null;}
        private function run105(action:String="state"):String {
            try {
                if(action=="finish"||action=="pitch")return game105(this).qaStarter105(action=="pitch"?"state":action);
                if(action=="model"){
                    var t:Object=StarterTutorial.create(true);check105(!StarterTutorial.event(t,"finish","fake"),"out-of-order event rejected");check105(StarterTutorial.claim(t)==0,"early reward rejected");
                    check105(StarterTutorial.event(t,"purchase","card_1"),"purchase");t=StarterTutorial.normalize(JSON.parse(JSON.stringify(t)));check105(t.stage==1&&t.cardId=="card_1","pack persists");
                    check105(!StarterTutorial.event(t,"purchase","card_2"),"purchase cannot overwrite pending card");
                    StarterTutorial.event(t,"open");StarterTutorial.event(t,"card");check105(!StarterTutorial.event(t,"substitute","wrong"),"wrong card rejected");
                    StarterTutorial.event(t,"substitute","card_1");StarterTutorial.event(t,"order");StarterTutorial.event(t,"start","0:1:1");
                    check105(!StarterTutorial.event(t,"finish","0:1:2"),"wrong fixture rejected");StarterTutorial.event(t,"finish","0:1:1");
                    check105(StarterTutorial.claim(t)==0,"point required");StarterTutorial.event(t,"point");check105(StarterTutorial.claim(t)==40000&&StarterTutorial.claim(t)==0,"single payment");
                    t=StarterTutorial.normalize(JSON.parse(JSON.stringify(t)));check105(t.claimed&&!StarterTutorial.active(t)&&StarterTutorial.claim(t)==0,"claim survives reload");
                    t=StarterTutorial.create(true);StarterTutorial.skip(t);check105(StarterTutorial.claim(t)==0&&!StarterTutorial.active(t),"skipped tutorial grants nothing");
                    check105(!StarterTutorial.active(StarterTutorial.normalize(null)),"legacy saves exempt");
                    return JSON.stringify({status:"PASS",idempotent:true,pendingCardPreserved:true,wrongFixtureRejected:true,legacyExempt:true});
                }
                return JSON.stringify({stage:GameData.starterTutorial.stage,coins:GameData.coins,goals:GameData.seasonGoalProgress()});
            }catch(e:Error){return JSON.stringify({error:e.message});}
            return "";
        }
    }
}
