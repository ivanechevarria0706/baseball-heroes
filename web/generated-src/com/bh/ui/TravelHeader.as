package com.bh.ui {
    import flash.display.Sprite;
    import flash.text.TextField;
    import com.bh.model.GameData;
    import com.bh.visual.LeagueBadgeView;
    /** Read-only resources shared by both travel screens. */
    public class TravelHeader extends Sprite {
        private var badge:LeagueBadgeView;
        public function TravelHeader(arrival:Boolean=false,title:String="") {
            mouseEnabled=mouseChildren=false;
            badge=new LeagueBadgeView(GameData.matchLeagueIndex(),GameData.matchLeagueShortName(),82);badge.x=8;badge.y=9;addChild(badge);
            pill(135,179,0x289bd3,0x075780);pill(341,166,0xa6e23e,0x426b0a);pill(550,179,0x203c32,0x102820);pill(775,170,0x203c32,0x102820);
            label("LV.",109,25,29,19,10);label(String(GameData.level),139,8,47,38,27,0xffffff,true);label(number(GameData.xp),182,22,120,23,16);
            ClassicInventorySkin.icon(this,"energy",320,9,1.05);var ef:TextField=label(GameData.energy+" / "+GameData.maxEnergy,367,22,128,23,16);var ec:EnergyClock=new EnergyClock(ef,175);ec.x=339;ec.y=43;addChild(ec);
            ClassicInventorySkin.icon(this,"coin",519,13,1.1);label(number(GameData.coins),561,22,155,23,16,0xffdf78);
            ClassicInventorySkin.icon(this,"cash",741,13,1.1);label(String(GameData.cash),790,22,138,23,16);
            var n:int=GameData.seasonNumber,mod:int=n%100,suffix:String=mod>=11&&mod<=13?"TH":n%10==1?"ST":n%10==2?"ND":n%10==3?"RD":"TH";
            label(title?title:arrival?"WELCOME TO BASEBALL HEROES":GameData.postSeasonMode?GameData.competitionTitle():n+suffix+" REGULAR SEASON",129,58,790,40,28,0xffffff,true,"left");
        }
        private function pill(x:Number,w:Number,a:uint,b:uint):void{graphics.lineStyle(1.5,0xacd8d9);ClassicInventorySkin.gradient(graphics,x,20,w,27,a,b,27);graphics.lineStyle();}
        private function label(text:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint=0xffffff,heavy:Boolean=false,align:String="center"):TextField{var t:TextField=new TextField();LineupTypography.apply(t,size,color,align,heavy);t.text=text;t.x=x;t.y=y;t.width=w;t.height=h;t.mouseEnabled=t.selectable=false;addChild(t);return t;}
        private function number(value:int):String{return String(value).replace(/\B(?=(\d{3})+(?!\d))/g,",");}
        public function dispose():void{if(badge){badge.dispose();badge=null;}}
    }
}
