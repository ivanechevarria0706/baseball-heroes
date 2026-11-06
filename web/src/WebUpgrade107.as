package {
    import flash.display.*;
    import flash.external.ExternalInterface;
    import flash.events.KeyboardEvent;
    import com.bh.model.*;
    import com.bh.ui.*;
    public class WebUpgrade107 extends WebUpgrade105 {
        private var checks:int=0,view107:Sprite;
        public function WebUpgrade107(){super();ExternalInterface.addCallback("bh107",run107);}
        private function check(ok:Boolean,message:String):void {checks++;if(!ok)throw new Error(message);}
        private function grant(id:String):String {return String(GameData.qa107Grant(id).instanceId);}
        private function cards():Array {return [grant("card_rookie_ace"),grant("card_tomo_wall"),grant("card_nico_line")];}
        private function clean():void {GameData.specialMatch=null;GameData.specialEquipped=[null,null,null,null,null];GameData.specialOwned={};GameData.coins=50000;GameData.cash=1000;GameData.qa107Roll=NaN;}
        private function rows107(second:Boolean=false):Array {
            var rows:Array=[];
            for(var i:int=0;i<9;i++)rows.push({slot:i,name:i==2?GameData.mainPlayer().name:i==8?"Nats":"Batter "+(i+1),accent:0x2388b1,appearance:GameData.heroAppearance(),hits:2,homeRuns:0,rbi:0,isHero:i==2});
            rows[0].hits=1;rows[2].rbi=1;
            if(second){rows[1].hits=1;rows[3].hits=1;rows[8].rbi=2;}
            else {rows[0].rbi=2;rows[8].homeRuns=1;rows[8].rbi=3;}
            return rows;
        }
        private function summary107(second:Boolean=false):Object {
            var rows:Array=rows107(second),score:int=second?3:6;
            var scoring:Object=MatchScoring.settle({version:4,points:20000,playCoins:0,playXP:0},true,false,rows,String(GameData.mainPlayer().name),second?15:17,1,score,score);
            return {win:true,draw:false,leagueIndex:1,league:"A",season:3,game:18,teamName:GameData.teamName,teamCity:GameData.teamCity,teamAccent:GameData.teamAccent,heroName:GameData.mainPlayer().name,opponent:GameData.opponentForGame(18),boxScore:rows,homeScore:score,awayScore:0,hits:second?15:17,homeRuns:1,rbi:score,scoring:scoring,rewardCoins:scoring.rewardCoins,rewardXp:scoring.rewardXp,wins:12,losses:4,rank:5,homeLine:[0,second?0:4,second?2:0,0,0,0,1,0,second?0:1],awayLine:[0,0,0,0,0,0,0,0,0]};
        }
        private function clearView():void {if(view107){Object(view107).dispose();removeChild(view107);view107=null;}}
        private function workshop(tab:String,kind:String):void {
            clearView();clean();var selected:String;
            if(kind=="B"){selected=grant("card_diego_clutch");grant("card_nina_rocket");}
            else {var ids:Array=cards();selected=ids[0];}
            GameData.save();view107=new SpecialCardsScreen(960,720,clearView);addChild(view107);
        }
        private function run107(action:String="model",kind:String="C"):String {
            try {
                if(action=="state")return JSON.stringify({coins:GameData.coins,cash:GameData.cash,level:GameData.level,owned:GameData.ownedSpecialCards(),last:GameData.lastLevelUpSummary});
                if(action=="trade"||action=="enhance"){workshop(action=="trade"?"TRADE":"ENHANCE",kind);return JSON.stringify({ok:true});}
                if(action=="roll"){GameData.qa107Roll=Number(kind);return JSON.stringify({ok:true});}
                if(action=="close"){clearView();return JSON.stringify({ok:true});}
                if(action=="level"){
                    clearView();GameData.level=11;GameData.levelProgress=GameData.levelXpTarget()-1;GameData.coins=50000;
                    var level:Object=GameData.qa107Level(1);GameData.save();stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,27));view107=new LevelUpOverlay(960,720,level,clearView);addChild(view107);return JSON.stringify(level);
                }
                if(action=="result"||action=="legacy"){
                    clearView();var summary:Object=summary107(kind=="B");
                    if(action=="legacy"){summary.scoring.version=4;delete summary.scoring.mvpSlot;delete summary.scoring.heroMvp;summary.scoring.mvpName=GameData.mainPlayer().name;}
                    var stored:String=JSON.stringify(summary),wallet:int=GameData.coins;view107=new GameResultPanel(960,720,summary,clearView);addChild(view107);
                    check(JSON.stringify(summary)==stored&&GameData.coins==wallet,"render is read-only");return JSON.stringify(summary.scoring);
                }
                checks=0;clean();
                var ids:Array=cards(),q:Object=GameData.specialTradeQuote(ids,"COINS");
                check(q.chance==.07&&q.coins==1000,"C trade quote");q=GameData.specialTradeQuote(ids,"CASH");check(q.cash==32&&q.chance==1,"C guaranteed quote");
                check(GameData.specialTradeQuote([ids[0],ids[0],ids[2]],"COINS").status=="DUPLICATE","duplicate copy rejected");
                GameData.specialEquipped[0]=ids[0];check(GameData.specialTradeQuote(ids,"COINS").status=="EQUIPPED","equipped copy protected");GameData.specialEquipped[0]=null;
                var b:String=grant("card_diego_clutch");check(GameData.specialTradeQuote([ids[0],ids[1],b],"COINS").status=="CLASS","mixed classes rejected");
                GameData.qa107Roll=.07;var result:Object=GameData.tradeSpecialCards(ids,"COINS");check(result.status=="OK"&&!result.promoted&&result.card.cardClass=="C"&&GameData.coins==49000,"trade failure returns C, pays once");
                check(!GameData.ownsSpecialCard(ids[0])&&!GameData.ownsSpecialCard(ids[1])&&!GameData.ownsSpecialCard(ids[2]),"three copies consumed");
                check(GameData.tradeSpecialCards(ids,"COINS").status=="NOT_OWNED"&&GameData.coins==49000,"repeated consumed trade cannot pay again");
                ids=cards();GameData.qa107Roll=.069;result=GameData.tradeSpecialCards(ids,"COINS");check(result.promoted&&result.card.cardClass=="B","7 percent boundary");
                ids=cards();GameData.coins=0;check(GameData.tradeSpecialCards(ids,"COINS").status=="COINS"&&GameData.ownsSpecialCard(ids[0]),"unaffordable trade preserves cards");
                GameData.cash=32;GameData.qa107Roll=.999;result=GameData.tradeSpecialCards(ids,"CASH");check(result.promoted&&GameData.cash==0,"guaranteed trade exact wallet");
                GameData.coins=5000;GameData.cash=100;q=GameData.specialEnhanceQuote(b,"COINS");check(q.coins==500&&q.chance==.07,"B Elite coin quote");
                check(GameData.specialEnhanceQuote(b,"CASH").cash==5&&GameData.specialEnhanceQuote(b,"CASH",true).cash==12,"B Elite paid quotes");
                var beforeAVG:int=GameData.specialCardById(b).avg;GameData.qa107Roll=.07;result=GameData.enhanceSpecialCard(b,"COINS");check(result.status=="FAILED"&&GameData.coins==4500&&GameData.specialCardById(b).avg==beforeAVG,"failed enhance keeps copy and grade");
                GameData.qa107Roll=.069;result=GameData.enhanceSpecialCard(b,"COINS");check(result.status=="OK"&&GameData.coins==4000&&result.card.enhancement==1&&result.card.avg==beforeAVG+10,"enhance +1 AVG");
                GameData.qa107Roll=.999;result=GameData.enhanceSpecialCard(b,"CASH");check(result.status=="OK"&&GameData.cash==95&&result.card.enhancement==2,"paid +1");
                result=GameData.enhanceSpecialCard(b,"CASH",true);check(result.status=="OK"&&GameData.cash==83&&result.card.enhancement==5&&result.card.avg==beforeAVG+50,"MAX jumps remaining levels once");
                check(GameData.enhanceSpecialCard(b,"CASH",true).status=="MAX"&&GameData.cash==83,"MAX replay cannot charge");
                var other:String=grant("card_hana_clutch");q=GameData.specialEnhanceQuote(other,"COINS");check(q.coins==2500&&q.chance==.8,"unobserved A balance preserved");
                check(GameData.specialEnhanceQuote(grant("card_rookie_ace"),"COINS").status=="GRADE","normal grade rejected");
                GameData.specialMatch={key:GameData.leagueIndex+":"+GameData.seasonNumber+":"+GameData.seasonGame};check(GameData.specialEnhanceQuote(other,"CASH").status=="MATCH_ACTIVE","paid fixture locks cards");GameData.specialMatch=null;
                GameData.level=11;GameData.levelProgress=GameData.levelXpTarget()-1;GameData.coins=50000;var points:int=GameData.mainPlayer().skillPoints,cap:int=GameData.maxEnergy;
                level=GameData.qa107Level(1);check(GameData.level==12&&GameData.coins==53000&&GameData.mainPlayer().skillPoints==points+1&&GameData.maxEnergy==cap+1,"level12 exact reward preserves SP and cap rules");
                check(level.unlocked.length==8&&level.unlocked[0].name=="Panda"&&level.unlocked[1].name=="Pink Love"&&level.unlocked[2].name=="Camo","8 unlocks and three observed previews");
                check(GameData.qa107Level(0)==null&&GameData.coins==53000,"level reward not replayed");
                level=GameData.qa107Level(GameData.levelXpTarget()+GameData.levelXpTarget()+20);check(GameData.level==14&&level.coins==4000&&level.skillPoints==2,"multi level awards kept");
                var examples:Array=[[17,9,"S"],[17,6,"A"],[15,3,"B"],[9,2,"C"],[5,4,"D"],[10,8,"A"]];
                for each(var example:Array in examples)check(MatchScoring.grade(example[0],example[1])==example[2],"observed rank "+example);
                summary=summary107();check(summary.scoring.mvp&&summary.scoring.mvpName=="Nats"&&summary.scoring.mvpSlot==8&&!summary.scoring.heroMvp&&summary.scoring.heroRbi==1,"teammate MVP");
                check(summary.scoring.breakdown[2].active&&summary.scoring.breakdown[2].coins==100&&summary.scoring.breakdown[2].xp==15,"team MVP reward");
                var career:Object=CareerAchievements.create(),awardRows:Array=rows107();awardRows[2].hits=10;
                CareerAchievements.match(career,"qa:mate",String(GameData.mainPlayer().name),6,0,awardRows);
                check(career.stats.mvp==0,"teammate MVP cannot grant hero career medal");
                awardRows[2].rbi=4;CareerAchievements.match(career,"qa:hero",String(GameData.mainPlayer().name),6,0,awardRows);
                check(career.stats.mvp==1,"hero MVP grants hero medal");
                check(!CareerAchievements.match(career,"qa:hero",String(GameData.mainPlayer().name),6,0,awardRows)&&career.stats.mvp==1,"career medal commits once");
                summary=summary107(true);check(!summary.scoring.mvp&&summary.scoring.mvpSlot==-1&&summary.scoring.rank=="B","no three RBI, no MVP");
                q=MatchScoring.settle(null,true,false,[],"unknown",17,0,6,6);check(!q.mvp&&q.mvpSlot==-1,"missing box score cannot grant MVP");
                q=MatchScoring.settle(null,false,true,rows107(),String(GameData.mainPlayer().name),17,1,6,6);check(!q.mvp&&q.rewardCoins==0&&q.rewardXp==0,"draw has no objective rewards");
                GameData.qa107Roll=NaN;GameData.save();return JSON.stringify({status:"PASS",checks:checks,rankExamples:examples,tradeC:{coins:1000,chance:.07,cash:32},enhanceBElite:{coins:500,chance:.07,cash:5,max:12},level12:{coins:3000,unlocks:8},teammateMvp:true});
            }catch(e:Error){GameData.qa107Roll=NaN;return JSON.stringify({error:e.message,checks:checks});}
            return "";
        }
    }
}
