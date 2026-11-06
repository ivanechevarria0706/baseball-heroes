package {
    import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;
    import flash.geom.Point;import flash.utils.getTimer;import flash.media.SoundChannel;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.game.*;import com.bh.visual.*;import com.bh.audio.*;
    /** Private QA target, excluded from deployment. */
    public class WebNotes1001 extends WebAppearance099 {
        private var view:Object,frames:Array=[],last:int=0,accepted:int=0,checks:int=0;
        public function WebNotes1001(){super();ExternalInterface.addCallback("bhNotes",run);last=getTimer();addEventListener(Event.ENTER_FRAME,tick);}
        private function tick(e:Event):void {var now:int=getTimer();if(frames.length<1000)frames.push(now-last);last=now;}
        private function closeView():void {if(view){view.dispose();if(view.parent)view.parent.removeChild(view as DisplayObject);view=null;}}
        private function check(ok:Boolean,label:String):void {checks++;if(!ok)throw new Error(label);}
        private function run(action:String="state",value:String=""):String {
            try{
                if(action=="close"){closeView();return "{}";}
                if(action=="model"){
                    checks=0;check(GameData.equipped.goggles==null,"new hero has no eyewear");
                    GameData.starterTutorial=StarterTutorial.create();GameData.specialMatch=null;GameData.specialEquipped=[null,null,null,null,null];GameData.specialSlotsUnlocked=1;GameData.coins=100000;GameData.cash=0;
                    var initial:int=GameData.coins,count:int=GameData.ownedSpecialCards().length;
                    var result:Object=GameData.drawSpecialClassPack("C"),id:String=result.card.id;
                    check(result.status=="OK"&&GameData.coins==initial-5000,"exact purchase debit");
                    check(GameData.ownedSpecialCards().length==count+1,"one delivered instance");
                    var bench:Array=GameData.lineupSubstitutes(),found:int=0;
                    for each(var p:Object in bench)if(p.specialCardId==id)found++;
                    check(found==1,"purchased instance on substitute bench");
                    var order:String=JSON.stringify(GameData.battingOrder),coins:int=GameData.coins;
                    check(GameData.equipSpecialCard(id)=="OK","activate owned bench card");
                    check(GameData.coins==coins&&JSON.stringify(GameData.battingOrder)==order,"activation has no charge or regular roster mutation");
                    for each(p in GameData.lineupSubstitutes())check(p.specialCardId!=id,"active card leaves substitute bench");
                    check(GameData.unequipSpecialCard(id),"unequip returns card");
                    GameData.save();GameData.load();found=0;for each(p in GameData.lineupSubstitutes())if(p.specialCardId==id)found++;
                    check(found==1&&GameData.coins==coins&&GameData.equipped.goggles==null,"purchase/bench/optional eyewear survive reload");
                    GameData.specialMatch={key:GameData.leagueIndex+":"+GameData.seasonNumber+":"+GameData.seasonGame,cards:[]};
                    check(GameData.equipSpecialCard(id)=="MATCH_ACTIVE","pending fixture cannot change cards");GameData.specialMatch=null;
                    check(GameData.equipSpecialCard(id)=="OK","card can activate after fixture");
                    result=GameData.drawSpecialClassPack("C");check(GameData.equipSpecialCard(result.card.id)=="FULL","full slots do not replace an active instance");
                    check(GameData.ownsSpecialCard(result.card.id),"full slots keep paid card on bench");GameData.unequipSpecialCard(id);
                    GameData.starterTutorial=StarterTutorial.create(true);GameData.starterTutorial.stage=StarterTutorial.SUBSTITUTE;GameData.starterTutorial.cardId=id;
                    check(GameData.equipSpecialCard(id)=="OK"&&GameData.starterTutorial.stage==StarterTutorial.ORDER,"bench activation advances starter lesson");
                    GameData.starterTutorial=StarterTutorial.create();GameData.unequipSpecialCard(id);
                    var at:int=0,clock:Function=function():int{return at;};var layer:Sprite=new Sprite();addChild(layer);
                    var batter:ClassicBatter=new ClassicBatter(320,550,0x246ba4,8,"Hero",clock,false);layer.addChild(batter);
                    batter.swing(450);batter.holdContact(130);var point:Point=batter.contactPosition();
                    var ball:Ball=new Ball(point.x,point.y,clock,function():Number{return .5;});layer.addChild(ball);ball.launchHit("PERFECT",75,130);
                    for each(at in [0,65,129]){batter.dispatchEvent(new Event(Event.ENTER_FRAME));ball.dispatchEvent(new Event(Event.ENTER_FRAME));check(batter.contactHeld&&ball.contactHeld&&ball.x==point.x&&ball.y==point.y&&batter.frameIndex==6,"contact held through "+at+"ms");}
                    at=200;batter.dispatchEvent(new Event(Event.ENTER_FRAME));ball.dispatchEvent(new Event(Event.ENTER_FRAME));check(!ball.contactHeld&&!batter.contactHeld&&ball.x!=point.x,"flight resumes after short hold");
                    batter.dispose();ball.dispose();removeChild(layer);
                    AudioManager.setSfxVolume(0);var channel:SoundChannel=GameplayAudio.play(GameplayAudio.VICTORY);check(channel!=null&&channel.soundTransform.volume==0,"new sound respects mute");AudioManager.stopSfx(channel);AudioManager.setSfxVolume(.88);
                    check(GameplayAudio.duration(GameplayAudio.HERO_HOME_RUN)>500&&GameplayAudio.duration(GameplayAudio.VICTORY)>2500&&GameplayAudio.duration(GameplayAudio.DEFEAT)>2500,"all new sounds embedded");
                    GameData.save();return JSON.stringify({status:"PASS",checks:checks,bench:GameData.lineupSubstitutes(),owned:GameData.ownedSpecialCards(),coins:GameData.coins});
                }
                if(action=="goals"){closeView();accepted=0;view=new SeasonGoalScreen(960,720,function():void{accepted++;closeView();});addChild(view as DisplayObject);}
                if(action=="lineup"){closeView();view=new LineupScreen(960,720,closeView);addChild(view as DisplayObject);}
                if(action=="intro"){closeView();view=new MatchIntroScreen(960,720,closeView,closeView);addChild(view as DisplayObject);}
                if(action=="actor"){closeView();frames=[];last=getTimer();view=new Actor1001();addChild(view as DisplayObject);}
                if(action=="result"){closeView();view=new GameResultPanel(960,720,{win:value!="loss",hits:3,homeRuns:1,atBats:4,rbi:3,homeScore:value=="loss"?2:6,awayScore:value=="loss"?4:2,rewardCoins:150,rewardXp:20,homeLine:[6,0,0,0,0,0,0,0,0],awayLine:[2,0,0,0,0,0,0,0,0]},closeView);addChild(view as DisplayObject);}
                var sorted:Array=frames.concat();sorted.sort(Array.NUMERIC);
                return JSON.stringify({goals:{hit:GameData.goalTarget(),rbi:GameData.seasonGoalRbi},accepted:accepted,coins:GameData.coins,owned:GameData.ownedSpecialCards(),bench:GameData.lineupSubstitutes(),equipped:GameData.specialEquipped,frames:frames.length,p95:sorted.length?sorted[int(sorted.length*.95)]:0});
            }catch(e:Error){return JSON.stringify({error:e.message,checks:checks});}
            return "{}";
        }
    }
}
import flash.display.*;import com.bh.game.ClassicBatter;import com.bh.ui.ClassicInventorySkin;
class Actor1001 extends Sprite {
    private var actor:ClassicBatter;
    public function Actor1001(){graphics.beginFill(0x1e6744);graphics.drawRect(0,0,960,720);graphics.endFill();actor=new ClassicBatter(480,530);actor.scaleX=actor.scaleY=1.8;addChild(actor);actor.setMomentum(3);ClassicInventorySkin.text(this,"MAX COMBO",0,30,960,50,34,0xffe166,"center");}
    public function dispose():void {actor.dispose();}
}
