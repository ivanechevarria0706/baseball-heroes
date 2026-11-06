package com.bh.ui {
    import flash.display.*;
    import flash.geom.Rectangle;
    import flash.text.*;
    import flash.filters.GlowFilter;
    import com.bh.model.GameData;
    import com.bh.visual.LeagueBadgeView;

    /** One retained resource strip for batting and autoplay. No frame listener. */
    public class MatchResourceBar extends Sprite {
        private var badge:LeagueBadgeView,clock:EnergyClock;
        private var level:TextField,xp:TextField,energy:TextField,coins:TextField,cash:TextField;
        private var xpFill:Shape=new Shape(),energyFill:Shape=new Shape();
        private var disposed:Boolean=false;
        public function MatchResourceBar(w:Number=960,home:Boolean=false) {
            name="match-resource-bar";mouseEnabled=mouseChildren=false;
            badge=new LeagueBadgeView(home?GameData.leagueIndex:GameData.matchLeagueIndex(),home?GameData.leagueShortName():GameData.matchLeagueShortName(),67);badge.x=8;badge.y=-2;addChild(badge);
            capsule(116,200,0x16426a);capsule(336,173,0x27470c);capsule(540,188,0x243e4c);capsule(777,w-786,0x243e4c);
            meter(xpFill,121,190,0x72d5fb,0x1685c1);meter(energyFill,341,163,0xb9fa53,0x56b312);
            var symbols:Shape=new Shape();addChild(symbols);var g:Graphics=symbols.graphics;
            g.lineStyle(2.5,0x123851);g.beginFill(0x9ed9f5);
            for(var i:int=0;i<=10;i++){var a:Number=-Math.PI/2+i*Math.PI/5,r:Number=i%2==0?24:13,x:Number=117+Math.cos(a)*r,y:Number=20+Math.sin(a)*r;if(i==0)g.moveTo(x,y);else g.lineTo(x,y);}g.endFill();
            g.lineStyle(1,0xf0ffff);g.moveTo(117,0);g.lineTo(123,13);g.lineTo(138,16);g.lineStyle();
            field("LV.",78,12,25,14,8,0x173b50,"level-label");
            level=field("",96,3,42,34,23,0xffffff,"level");level.filters=[new GlowFilter(0x163b58,1,2,2,8)];
            xp=field("",145,8,158,23,13,0xffffff,"xp");
            g.lineStyle(2,0x214c19);g.beginFill(0xc4fb54);g.moveTo(337,2);g.lineTo(324,22);g.lineTo(336,22);g.lineTo(330,38);g.lineTo(352,14);g.lineTo(340,14);g.lineTo(348,2);g.lineTo(337,2);g.endFill();g.lineStyle();
            energy=field("",353,7,144,25,14,0xffffff,"energy");
            g.lineStyle(2,0x79551c);ClassicChrome.fill(g,521,2,34,34,[0xfff2a0,0xf9ce52,0xc68a24],[0,100,255],34);g.lineStyle(1.5,0xffe9a0);g.drawCircle(538,19,11);g.lineStyle();
            field("C",525,6,27,27,18,0x98620c,"coin-symbol");coins=field("",558,8,home?121:147,23,13,0xffe884,"coins");
            g.lineStyle(2,0x284a43);g.beginFill(0xd8e2ad);g.moveTo(760,9);g.lineTo(779,3);g.lineTo(796,9);g.lineTo(777,18);g.lineTo(760,13);g.lineTo(760,9);g.endFill();
            g.beginFill(0x8da88c);g.moveTo(760,13);g.lineTo(777,18);g.lineTo(796,9);g.lineTo(796,16);g.lineTo(777,25);g.lineTo(760,20);g.lineTo(760,13);g.endFill();g.lineStyle();
            cash=field("",801,8,home?103:w-817,23,13,0xffffff,"cash");
            clock=new EnergyClock(energy,175,paintEnergy);clock.x=332;clock.y=31;addChild(clock);refresh();
        }
        private function field(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,id:String):TextField {
            var t:TextField=new TextField();t.name=id;t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=t.mouseEnabled=false;LineupTypography.apply(t,size,color,"center",id=="level");addChild(t);return t;
        }
        private function capsule(x:Number,w:Number,bottom:uint):void {var g:Graphics=graphics;g.lineStyle(2,0xa9d4df);ClassicChrome.fill(g,x,7,w,25,[0x86b6c5,bottom,0x152e40],[0,100,255],25);g.lineStyle(1,0xe5fbff,.65);g.moveTo(x+12,9);g.lineTo(x+w-12,9);g.lineStyle();}
        private function meter(shape:Shape,x:Number,w:Number,top:uint,bottom:uint):void {shape.x=x;shape.y=10;ClassicChrome.fill(shape.graphics,0,0,w,19,[top,bottom],[0,255],19);addChild(shape);}
        private function number(n:int):String {return String(n).replace(/\B(?=(\d{3})+(?!\d))/g,",");}
        private function paintEnergy():void {if(disposed)return;energyFill.scrollRect=new Rectangle(0,0,163*Math.max(0,Math.min(1,GameData.energy/Math.max(1,GameData.maxEnergy))),19);}
        public function refresh(liveCoins:int=0,liveXP:int=0):void {
            if(disposed)return;level.text=String(GameData.level);xp.text=number(GameData.xp+liveXP);energy.text=GameData.energy+" / "+GameData.maxEnergy;coins.text=number(GameData.coins+liveCoins);cash.text=number(GameData.cash);
            LineupTypography.fit(xp,13,0xffffff,"center");LineupTypography.fit(coins,13,0xffe884,"center");LineupTypography.fit(cash,13,0xffffff,"center");
            xpFill.scrollRect=new Rectangle(0,0,190*Math.max(0,Math.min(1,(GameData.levelProgress+liveXP)/Math.max(1,GameData.levelXpTarget()))),19);paintEnergy();
        }
        public function dispose():void {if(disposed)return;disposed=true;clock.dispose();badge.dispose();}
    }
}
