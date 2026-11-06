package com.bh.ui {
    import flash.display.*;import flash.events.*;import flash.text.*;
    import com.bh.model.GameData;import com.bh.model.CareerAchievements;
    import com.bh.visual.MatchStadium;
    import com.bh.visual.AchievementArtwork;
    /** Two-column trophy book, reconstructed from the supplied 14:34/14:40 gameplay. */
    public class HallOfFameScreen extends Sprite {
        private var back:Function,missions:Function,page:int=0,background:MatchStadium;
        private var chrome:Sprite=new Sprite(),controls:Array=[],header:TravelHeader,modal:Sprite;
        private static const COLORS:Array=[0xbc7e5c,0xb9d0dc,0xffc536,0x48e5df];
        public function HallOfFameScreen(w:Number,h:Number,onBack:Function,onMissions:Function) {
            name="hall-of-fame";back=onBack;missions=onMissions;
            background=new MatchStadium(w,h);addChild(background);graphics.beginFill(0x0b2633);graphics.drawRect(0,0,w,h);graphics.endFill();
            var shade:Shape=new Shape();shade.graphics.beginFill(0x071b2b,.55);shade.graphics.drawRect(0,0,w,h);shade.graphics.endFill();addChild(shade);addChild(chrome);render();
        }
        private function label(parent:Sprite,id:String,text:String,x:Number,y:Number,w:Number,h:Number,size:int=14,color:uint=0x344650,align:String="left"):TextField {
            var t:TextField=ClassicInventorySkin.text(parent,text,x,y,w,h,size,color,align);t.name=id;LineupTypography.apply(t,size,color,align,true);t.text=text;return t;
        }
        private function button(parent:Sprite,id:String,text:String,x:Number,y:Number,w:Number,fn:Function,color:uint=0x4b8bb4):Sprite {
            var b:Sprite=ClassicInventorySkin.button(text,w,34,color);b.name=id;b.x=x;b.y=y;parent.addChild(b);var handler:Function=function(e:MouseEvent):void {fn();};b.addEventListener(MouseEvent.CLICK,handler);controls.push({b:b,fn:handler});return b;
        }
        private function clear():void {
            for each(var c:Object in controls)c.b.removeEventListener(MouseEvent.CLICK,c.fn);controls=[];
            while(chrome.numChildren)chrome.removeChildAt(0);chrome.graphics.clear();modal=null;
            if(header){header.dispose();if(header.parent)header.parent.removeChild(header);header=null;}
        }
        private function render():void {
            clear();header=new TravelHeader(false," ");addChildAt(header,2);
            var g:Graphics=chrome.graphics;g.lineStyle(3,0x95c6dc);ClassicInventorySkin.gradient(g,108,80,744,580,0x2088bf,0x095387,12);g.lineStyle();
            label(chrome,"hall-title","HALL OF FAME",240,91,480,35,27,0xffffff,"center");
            button(chrome,"hall-close","X",795,91,42,back,0xb43d38);
            var state:Object=GameData.hallOfFame,catalog:Array=CareerAchievements.catalog();
            for(var i:int=0;i<4;i++){
                trophy(chrome,174+i*164,137,i,true,.58);
                label(chrome,"hall-total-"+i,CareerAchievements.trophies(state,i)+" / "+catalog.length,204+i*164,148,100,22,16,0xf5f4e9,"center");
                label(chrome,"hall-tier-"+i,CareerAchievements.TIERS[i],187+i*164,173,125,16,9,0xb9ddf0,"center");
            }
            var start:int=page*6,end:int=Math.min(start+6,catalog.length);
            for(i=start;i<end;i++)tile(catalog[i],126+((i-start)%2)*360,205+int((i-start)/2)*139);
            label(chrome,"hall-page",(page+1)+" / "+Math.ceil(catalog.length/6),431,625,98,23,14,0xe9f6fd,"center");
            if(page>0)button(chrome,"hall-prev","<",123,619,46,function():void {page--;render();});
            if(end<catalog.length)button(chrome,"hall-next",">",790,619,46,function():void {page++;render();});
            button(chrome,"hall-missions","MISSIONS",177,619,149,missions);
            label(chrome,"hall-ready",GameData.hallAvailable()+" rewards available",550,625,228,22,13,0xffe680,"right");
        }
        private function tile(item:Object,x:Number,y:Number):void {
            var p:Sprite=new Sprite();p.x=x;p.y=y;p.name="hall-card-"+item.id;chrome.addChild(p);
            var g:Graphics=p.graphics;g.lineStyle(2,0xe9f4f7);ClassicInventorySkin.gradient(g,0,0,348,129,0xf8f8f3,0xd7dddd,7);g.lineStyle();
            label(p,"hall-name-"+item.id,item.title,8,5,332,20,13,0x39434a,"center");
            label(p,"hall-label-"+item.id,item.label,12,29,235,18,11,0x6a7277);
            ClassicInventorySkin.gradient(g,259,30,76,18,0x6a7071,0x414747,16);
            var count:int=CareerAchievements.count(GameData.hallOfFame.stats[item.id]);
            label(p,"hall-count-"+item.id,String(count),261,29,73,20,12,0xffffff,"center");
            ClassicInventorySkin.gradient(g,9,52,330,70,0x5d6364,0x303638,5);
            for(var tier:int=0;tier<4;tier++){
                var reached:Boolean=count>=int(item.targets[tier]),claimed:Boolean=GameData.hallOfFame.claims[item.id+":"+tier]===true;
                label(p,"hall-target-"+item.id+"-"+tier,String(item.targets[tier]),12+tier*82,54,78,17,10,reached?uint(COLORS[tier]):0x8c9292,"center");
                trophy(p,39+tier*82,72,tier,reached,.60);
                label(p,"hall-state-"+item.id+"-"+tier,claimed?"✓":reached?"CLAIM":"",12+tier*82,104,78,17,9,reached?0xffedac:0x8c9292,"center");
                var b:Sprite=new Sprite();b.name="hall-trophy-"+item.id+"-"+tier;b.x=10+tier*82;b.y=51;b.graphics.beginFill(0xffffff,0);b.graphics.drawRect(0,0,82,73);b.graphics.endFill();b.buttonMode=true;b.mouseChildren=false;p.addChild(b);
                var fn:Function=choose(item,tier);b.addEventListener(MouseEvent.CLICK,fn);controls.push({b:b,fn:fn});
            }
        }
        private function choose(item:Object,tier:int):Function {return function(e:MouseEvent):void {detail(item,tier);};}
        private function detail(item:Object,tier:int):void {
            if(modal)return;modal=new Sprite();modal.name="hall-detail";modal.graphics.beginFill(0x061624,.76);modal.graphics.drawRect(0,0,960,720);modal.graphics.endFill();chrome.addChild(modal);
            var g:Graphics=modal.graphics;g.lineStyle(3,0xb5d7e8);ClassicInventorySkin.gradient(g,218,155,524,397,0xffffff,0xe3e7e5,12);g.lineStyle();
            label(modal,"hall-detail-title","HALL OF FAME!",280,174,400,41,31,0xa3671c,"center");trophy(modal,248,172,tier,true,.95);
            label(modal,"hall-detail-name",item.title,239,237,482,31,19,0x414c51,"center");
            var current:int=CareerAchievements.count(GameData.hallOfFame.stats[item.id]),claimed:Boolean=GameData.hallOfFame.claims[item.id+":"+tier]===true,reached:Boolean=current>=int(item.targets[tier]);
            label(modal,"hall-detail-progress",CareerAchievements.TIERS[tier]+"  ·  "+current+" / "+item.targets[tier],247,282,466,32,20,0x62777f,"center");
            ClassicInventorySkin.gradient(g,245,335,470,88,0x2695ca,0x07518b,6);ClassicInventorySkin.icon(modal,"coin",324,353,1.4);
            label(modal,"hall-detail-reward",CareerAchievements.reward(tier)+" COINS",366,359,280,45,28,0xffdf6b,"center");
            label(modal,"hall-detail-state",claimed?"Premio recibido y guardado.":reached?"¡Meta alcanzada!":"Sigue jugando para alcanzar esta meta.",247,444,466,27,16,0x456270,"center");
            button(modal,"hall-detail-back","CLOSE",246,492,150,function():void {render();});
            if(reached&&!claimed)button(modal,"hall-claim","CLAIM REWARD",416,492,299,function():void {GameData.claimHallTrophy(item.id,tier);render();},0x64ad2c);
        }
        private function trophy(parent:Sprite,x:Number,y:Number,tier:int,unlocked:Boolean,scale:Number):void {
            var s:Sprite=new Sprite();s.x=x;s.y=y;s.scaleX=s.scaleY=scale;s.mouseEnabled=false;parent.addChild(s);
            var key:String=unlocked?String(["bronze","silver","gold","diamond"][tier]):"locked";
            var art:AchievementArtwork=new AchievementArtwork(key,64,47);art.x=-11;s.addChild(art);
        }
        public function dispose():void {clear();background.dispose();}
    }
}
