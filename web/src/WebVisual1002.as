package {
    import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.geom.Point;
    import com.bh.model.*;import com.bh.visual.*;import com.bh.ui.*;import com.bh.game.*;
    /** Isolated visual/anchor QA. Never part of the published package. */
    public class WebVisual1002 extends WebNotes1001 {
        private var layer:Sprite,views:Array=[];
        public function WebVisual1002(){super();ExternalInterface.addCallback("bhVisual",show);}
        private function close():void {for each(var v:Object in views)v.dispose();views=[];if(layer){removeChild(layer);layer=null;}}
        private function show(action:String="gear",value:int=0):String {
            try{
                if(action=="close"){close();return "{}";}
                if(action=="model")return JSON.stringify(model());
                close();layer=new Sprite();layer.graphics.beginFill(0xd7e7e8);layer.graphics.drawRect(0,0,960,720);layer.graphics.endFill();addChild(layer);
                if(action=="gear"){
                    for(var i:int=0;i<8;i++){
                        var gear:Object={helmet:GameData.shopItemById("classic117_helmet_"+i),goggles:GameData.shopItemById("classic116_goggles_"+i),shoes:GameData.shopItemById("classic116_shoes_"+i),glove:GameData.shopItemById("classic107_glove_"+i),bat:GameData.shopItemById("classic116_bat_"+i),belt:GameData.shopItemById("classic116_belt_"+i)};
                        var xx:Number=(i%2)*480,yy:Number=int(i/2)*180;
                        ClassicInventorySkin.text(layer,gear.helmet.name,xx+7,yy+3,466,21,14,0x1d4358,"center",true);
                        for(var n:int=0;n<3;n++){
                            var a:HeroSprite=new HeroSprite(String(GameData.mainPlayer().name),0x286da2,GameData.mainPlayer().appearance,n==0?"home":"batter",.49,gear,true);
                            a.x=xx+72+n*140;a.y=yy+169;if(n==2)a.setFrame(value==0?6:value);layer.addChild(a);views.push(a);
                        }
                    }
                }
                if(action=="defense"){
                    for(i=0;i<12;i++){
                        var pitcher:Pitcher=new Pitcher(80+(i%6)*160,310+int(i/6)*350,0x1d78af,"QA",null,true);pitcher.scaleX=pitcher.scaleY=.78;layer.addChild(pitcher);views.push(pitcher);pitcher.fieldMotion((i%6)/5,i>=6);
                        ClassicInventorySkin.text(layer,(i>=6?"FLY CATCH ":"GROUND BALL ")+Math.round((i%6)/5*100)+"%",(i%6)*160,30+int(i/6)*350,160,34,12,0x1c4356,"center");
                    }
                }
                if(action=="autoplay"){
                    var stadium:MatchStadium=new MatchStadium(960,580);layer.addChild(stadium);views.push(stadium);
                    GameData.starterTutorial=StarterTutorial.create();GameData.specialMatch=null;
                    var panel:TeamSimulationPanel=new TeamSimulationPanel(960,580);panel.y=0;layer.addChild(panel);views.push(panel);
                    var roster:Array=GameData.battingOrderPlayers();panel.configure(roster,GameData.currentOpponent(),GameData.mainPlayer());panel.beginSimulation(7,value==0?"HOME":"AWAY");panel.setScore(6,0,7,1);panel.setActiveBatter(value==0?"HOME":"AWAY",5);panel.setBases(true,false,true);panel.setHits(13,3);
                }
                return JSON.stringify({status:"OK",actors:views.length});
            }catch(e:Error){return JSON.stringify({error:e.message});}return "{}";
        }
        private function model():Object {
            var items:Array=EquipmentCatalog.items(),counts:Object={helmets:0,goggles:0,bats:0,shoes:0,gloves:0};
            for each(var item:Object in items){
                if(item.slot=="helmet"&&ClassicWearables.family(item.name,ClassicWearables.HELMETS)>=0)counts.helmets++;
                if(item.slot=="goggles"&&ClassicWearables.family(item.name,ClassicWearables.GOGGLES)>=0)counts.goggles++;
                if(item.slot=="bat"&&ClassicWearables.hasBat(item.name))counts.bats++;
                if(item.slot=="shoes"&&ClassicWearables.hasShoes(item.name))counts.shoes++;
                if(item.slot=="glove"&&ClassicWearables.hasGlove(item.name))counts.gloves++;
            }
            for(var kind:String in counts)if(counts[kind]!=8)throw new Error(kind+" coverage "+counts[kind]);
            var at:int=0,clock:Function=function():int{return at;},p:Pitcher=new Pitcher(200,300,0xc63e3b,"QA",clock,true);addChild(p);var anchors:Array=[];
            for(var i:int=0;i<=20;i++)for each(var fly:Boolean in [false,true]){
                p.fieldMotion(i/20,fly);var anchor:Point=p.fieldAnchor();if(!isFinite(anchor.x)||!isFinite(anchor.y))throw new Error("Invalid glove anchor");anchors.push({p:i/20,fly:fly,x:anchor.x,y:anchor.y,frame:p.frameIndex});
            }p.resetReady();p.dispose();removeChild(p);
            var batter:ClassicBatter=new ClassicBatter(200,500,0x2573a1,32,"Hero",clock,false);addChild(batter);at=0;batter.swing(400);
            var swing:Array=[];for each(at in [0,15,30,45,65,109,155,200,390,660,980,1340]){batter.dispatchEvent(new Event(Event.ENTER_FRAME));var cp:Point=batter.contactPosition();if(!isFinite(cp.x)||!isFinite(cp.y))throw new Error("Invalid bat anchor");swing.push({ms:at,x:cp.x,y:cp.y,frame:batter.frameIndex});}batter.dispose();removeChild(batter);
            return {status:"PASS",coverage:counts,anchors:anchors,swing:swing};
        }
    }
}
