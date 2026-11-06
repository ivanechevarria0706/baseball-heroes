package {
    import flash.display.*;import flash.events.Event;import flash.external.ExternalInterface;import flash.geom.Point;
    import com.bh.core.Game;import com.bh.game.*;import com.bh.ui.MatchMiniDiamond;
    public class WebUpgrade104 extends WebUpgrade103 {
        public function WebUpgrade104(){super();ExternalInterface.addCallback("bh104",run104);}
        private function check104(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
        private function find104(c:DisplayObjectContainer):Game {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is Game)return d as Game;if(d is DisplayObjectContainer){var g:Game=find104(d as DisplayObjectContainer);if(g)return g;}}return null;}
        private function run104(action:String="model",kind:String="SINGLE"):String {
            try {
                if(action!="model")return find104(this)["qaMatch104"](action,kind);
                var at:int=0,clock:Function=function():int{return at;},p:Pitcher=new Pitcher(200,200,0xc74e43,"QA pitcher",clock),rows:Array=[];
                addChild(p);p.throwPitch(.96);
                for each(var age:int in [0,120,240,500,750,959]){at=age;p.dispatchEvent(new Event(Event.ENTER_FRAME));rows.push({ms:age,frame:p.frameIndex});}
                at=960;var release:Point=p.releasePosition();check104(p.frameIndex==15,"release uses empty-hand pose 15");
                at=1000;p.dispatchEvent(new Event(Event.ENTER_FRAME));var again:Point=p.releasePosition();check104(release.equals(again),"release anchor consumed once");
                at=1490;p.dispatchEvent(new Event(Event.ENTER_FRAME));p.resetReady();check104(p.x==200&&p.y==200&&p.frameIndex==0,"pitcher reset");p.dispose();removeChild(p);
                at=0;var d:Pitcher=new Pitcher(200,200,0xc74e43,"QA fielder",clock,true);addChild(d);d.reactHit(1,true);var defense:Array=[];
                for each(age in [0,120,300,650,900]){at=age;d.dispatchEvent(new Event(Event.ENTER_FRAME));defense.push({ms:age,frame:d.frameIndex,x:d.x,y:d.y});}
                check104(defense[1].frame!=defense[3].frame&&defense[4].x>200,"fielders animate and chase");d.resetReady();check104(d.x==200&&d.y==200&&d.frameIndex==0,"defender returns to original position");
                d.fieldThrow(.5);var hand:Point=d.fieldAnchor(true);check104(isFinite(hand.x)&&isFinite(hand.y),"finite throw anchor");d.dispose();removeChild(d);
                var cinema:HitCinematic=new HitCinematic(960,720,clock),types:Array=["SINGLE","DOUBLE","TRIPLE","HOME RUN","GROUND OUT","FLY OUT","STRIKE OUT"],shots:Array=[];addChild(cinema);
                for each(var type:String in types){at=0;cinema.play(type,1,330,{x:590,y:240,scale:1.7,rotation:90});var ball:DisplayObject=cinema.getChildByName("cinematic-ball");check104(ball.x==590&&ball.y==240,"handoff starts at outgoing ball");
                    for each(age in [1,33,100,179,300,800,1800,4000,9000]){at=age;cinema.dispatchEvent(new Event(Event.ENTER_FRAME));check104(isFinite(ball.x)&&isFinite(ball.y),"finite cinematic ball");if(type=="DOUBLE"||type=="TRIPLE")if(age<=800)check104(cinema.getChildByName("cinematic-scene").visible&&ball.visible,"no blank camera interval");if(type=="STRIKE OUT")check104(!cinema.getChildByName("out-diagonal-scene").visible&&!ball.visible,"strike out has no fielding or batted ball");}
                    check104(cinema.canContinue(),"auto continuation "+type);shots.push(type);cinema.clear();check104(!cinema.visible,"cinematic cleanup");
                }cinema.dispose();removeChild(cinema);
                at=0;var map:MatchMiniDiamond=new MatchMiniDiamond(0x2388c0,clock),a:Object={},b:Object={},hero:Object={};addChild(map);map.setBases([true,true,false]);map.play([a,b,null],[hero,null,a],hero,1);map.setBases([true,false,true]);map.ballInPlay("SINGLE");
                at=800;map.advance();check104(map.getChildByName("advancing-runner")!=null,"runner path visible");at=2500;map.advance();check104(map.getChildByName("advancing-runner")==null,"runner paths reclaimed");check104(map.getChildByName("runner-first").visible&&!map.getChildByName("runner-second").visible&&map.getChildByName("runner-third").visible,"final base state reconciled");
                map.reset();check104(!map.getChildByName("minimap-ball").visible,"minimap reset");map.dispose();removeChild(map);
                return JSON.stringify({status:"PASS",pitcher:rows,defense:defense,cinematics:shots,runnerFinalBases:[true,false,true],releaseAnchorStable:true,blankIntervalRemoved:true});
            }catch(e:Error){return JSON.stringify({error:e.message});}
            return "";
        }
    }
}
