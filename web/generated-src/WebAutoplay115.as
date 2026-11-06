package {
    import flash.display.*;import flash.events.*;import flash.text.*;import flash.external.ExternalInterface;
    import com.bh.model.*;import com.bh.ui.*;import com.bh.visual.*;
    public class WebAutoplay115 extends WebAutoplay114 {
        private var sheet:Sprite,faces:Array=[],checks:int=0;
        public function WebAutoplay115(){super();ExternalInterface.addCallback('bh115',run);}
        private function check(ok:Boolean,label:String):void {checks++;if(!ok)throw new Error(label);}
        private function find(c:DisplayObjectContainer,id:String):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function closeSheet():void {if(sheet){for each(var f:LineupPortrait in faces)f.dispose();faces=[];removeChild(sheet);sheet=null;}}
        private function run(action:String='state'):String {
            try {
                if(action=='model')return JSON.stringify(model());
                if(action=='sheet'){
                    closeSheet();sheet=new Sprite();sheet.name='portrait-sheet';sheet.graphics.beginFill(0xe9eee5);sheet.graphics.drawRect(0,0,960,720);sheet.graphics.endFill();addChild(sheet);
                    for(var i:int=0;i<32;i++){var face:LineupPortrait=new LineupPortrait(i,78,108);face.x=39+(i%8)*115;face.y=30+int(i/8)*170;sheet.addChild(face);faces.push(face);ClassicInventorySkin.text(sheet,String(i),face.x,face.y+112,78,25,15,0x294a39,'center');}
                }
                if(action=='close-sheet')closeSheet();
                var panel:TeamSimulationPanel=find(this,'simulation-panel') as TeamSimulationPanel;
                if(action=='owned-instance') {
                    var uid:String='special_qa115',state:Object=SpecialCardInventory.fresh(uid,'card_ken_golden');state.enhancement=2;state.level=3;state.charges=1;
                    var owned:Object={};for(var key:String in GameData.specialOwned)owned[key]=GameData.specialOwned[key];owned[uid]=state;GameData.specialOwned=owned;GameData.specialEquipped[0]=uid;
                    panel.configure(GameData.battingOrderPlayers(),GameData.currentOpponent(),GameData.mainPlayer());panel.beginSimulation(3,'HOME');
                }
                if(action=='activation'){panel.showSpecialCardActivation(GameData.specialCardForMatch(0),'DOUBLE ACTIVATED!');}
                if(action=='legacy-activation'){var oldCard:Object=GameData.specialCardForMatch(0);panel.showSpecialCard(String(oldCard.name),String(oldCard.grade),'DOUBLE ACTIVATED!');}
                var popup:SpecialBatterCardView=find(this,'simulation-special-card') as SpecialBatterCardView;
                return JSON.stringify({paused:panel?panel.isPaused:false,time:panel?panel.simulationNow():0,pausedDuration:panel?panel.pausedDuration():0,
                    popup:popup?{id:popup.data.id,catalogId:popup.data.catalogId,owned:GameData.ownsSpecialCard(String(popup.data.id)),level:GameData.specialCardLevel(String(popup.data.id)),scale:popup.scaleX}:null});
            }catch(e:Error){return JSON.stringify({error:e.message,checks:checks});}
            return '{}';
        }
        private function model():Object {
            closeSheet();checks=0;
            for(var i:int=0;i<32;i++){
                var head:Array=LineupPortrait.HEADS[i],frame:Array=SpriteFrameLayout.CHARACTERS[i];
                check(head[0]>=frame[0]&&head[1]>=frame[1]&&head[0]+head[2]<=frame[0]+frame[2]&&head[1]+head[3]<=frame[1]+frame[3],'portrait stays in supplied frame '+i);
                var f:LineupPortrait=new LineupPortrait(i,32,28);addChild(f);var viewport:Sprite=f.getChildAt(0) as Sprite;
                check(viewport.scrollRect.width*viewport.scaleX<=32.1&&viewport.scrollRect.height*viewport.scaleY<=28.1,'bounded portrait viewport '+i);f.dispose();removeChild(f);
            }
            var at:int=0,coins:int=GameData.coins,energy:int=GameData.energy,xp:int=GameData.xp;
            var p:TeamSimulationPanel=new TeamSimulationPanel(960,588,function():int{return at;});addChild(p);p.configure(GameData.battingOrderPlayers(),GameData.currentOpponent(),GameData.mainPlayer());p.beginSimulation(1,'HOME');at=400;
            var batter:Object={},runner:Object={};p.addResultFor('HOME',1,'QA','SINGLE',1);p.showResolvedPlay([runner,null,null],[batter,null,runner],batter,'SINGLE');
            at=450;p.dispatchEvent(new Event(Event.ENTER_FRAME));var stamp:Sprite=find(p,'simulation-result') as Sprite;
            find(p,'simulation-pause').dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));var frozen:int=p.simulationNow(),alpha:Number=stamp.alpha;
            at=10450;p.dispatchEvent(new Event(Event.ENTER_FRAME));check(p.isPaused&&p.simulationNow()==frozen&&p.pausedDuration()==10000,'freeze presentation clock');
            check(stamp.alpha==alpha&&find(p,'simulation-pause-tip').visible,'result retained while paused');
            find(p,'speed-1').dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));check(p.simulationDelay()==1650&&p.isPaused,'speed changes next plays without unpausing');
            find(p,'simulation-pause').dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));check(!p.isPaused&&p.simulationNow()==frozen,'resume same visual instant');
            at+=50;check(p.simulationNow()==frozen+50,'clock continues after pause');
            find(p,'simulation-pause').dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));at+=3000;find(p,'simulation-pause').dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));check(p.pausedDuration()==13000,'cumulative pause time');
            p.showHeroTurn(String(GameData.mainPlayer().name),1,'0-0');find(p,'simulation-pause').dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));check(!p.isPaused,'no pause toggle in manual handoff');
            p.hidePanel();check(!p.isPaused&&!find(p,'simulation-pause-tip').visible,'hide clears pause notice');
            check(GameData.coins==coins&&GameData.energy==energy&&GameData.xp==xp,'presentation has no economy effects');p.dispose();removeChild(p);
            return {status:'PASS',checks:checks,portraits:32,pauseClockVerified:true};
        }
    }
}
