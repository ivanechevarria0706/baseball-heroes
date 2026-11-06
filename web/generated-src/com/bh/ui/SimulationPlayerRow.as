package com.bh.ui {
    import flash.display.*;
    import flash.text.*;
    import flash.geom.Rectangle;
    import flash.filters.GlowFilter;
    import com.bh.visual.*;
    import com.bh.model.GameData;
    /** A retained lineup row; changing the active batter never recreates art. */
    public class SimulationPlayerRow extends Sprite {
        public var data:Object,rowIndex:int,isHome:Boolean;
        private var rowW:Number,rowH:Number,active:Boolean=false,conditionValue:int=0,isHero:Boolean=false;
        private var statusBox:Sprite=new Sprite(),statusText:TextField,avgText:TextField,playerText:TextField,numberText:TextField;
        private var portrait:CharacterPortrait,special:SpecialCardIllustration,friendFace:HeroHead;
        private var illustrated:LineupPortrait;
        private var card:Object;
        private var highlight:Shape=new Shape();
        public function SimulationPlayerRow(playerData:Object,index:int,home:Boolean,w:Number=276,h:Number=29,specialCard:Object=null,friend:Object=null,mood:int=0) {
            data=playerData;card=specialCard;rowIndex=index;isHome=home;rowW=w;rowH=h;conditionValue=mood;mouseEnabled=mouseChildren=false;name=(home?'home':'away')+'-row-'+index;
            highlight.name="active-row-highlight";addChild(highlight);
            highlight.graphics.lineStyle(1.5,0xe1b84f);highlight.graphics.drawRoundRect(1,1,rowW-2,rowH-2,4);highlight.visible=false;
            isHero=isHome&&String(data.name)==String(GameData.mainPlayer().name);drawBase();
            numberText=label(String(index+1),-5,3,23,25,17,0x2c4239);
            var slot:Sprite=new Sprite();slot.name='support-slot';slot.x=14;slot.y=2;addChild(slot);
            slot.graphics.lineStyle(1,0x7e8a86);ClassicInventorySkin.gradient(slot.graphics,0,0,26,24,0xffffff,0xd5dcda,2);slot.graphics.lineStyle();
            if(card) {
                ClassicInventorySkin.gradient(slot.graphics,1,1,24,22,0xf6df91,card.cardClass=='C'?0x7bbd34:card.cardClass=='B'?0x45a8ce:0xd6a132,1);
                var inningLabel:String=String(card.triggerInning)+(int(card.triggerInning)==1?'st':int(card.triggerInning)==2?'nd':int(card.triggerInning)==3?'rd':'th');
                ClassicInventorySkin.text(slot,inningLabel,1,-1,24,12,8,0xffffff,'center',true);
                ClassicInventorySkin.text(slot,card.guaranteedHit=='TRIPLE'?'3B':card.guaranteedHit=='DOUBLE'?'2B':'1B',1,10,24,12,9,0xffffff,'center',true);
                illustrated=new LineupPortrait(SpecialCardArtRegistry.frameFor(card.catalogId?String(card.catalogId):String(card.id)),34,28,card);illustrated.x=42;addChild(illustrated);
                var gradeBadge:Sprite=new Sprite();gradeBadge.name='special-class-badge';gradeBadge.x=69;gradeBadge.y=4;gradeBadge.graphics.lineStyle(1,0x31532e);gradeBadge.graphics.beginFill(card.cardClass=='C'?0x8fc63a:card.cardClass=='B'?0x5eacdf:0xeac847);gradeBadge.graphics.drawCircle(0,0,7);gradeBadge.graphics.endFill();addChild(gradeBadge);ClassicInventorySkin.text(gradeBadge,String(card.cardClass),-7,-8,14,16,10,0xffffff,'center',true);
            }else {
                if(friend) {
                    var p:Object=friend.profile||{},clip:Sprite=new Sprite();clip.scrollRect=new Rectangle(0,0,26,24);slot.addChild(clip);
                    friendFace=new HeroHead(p.appearance||{},HomeSprite.paletteFor(friend.name,uint(p.accent||0x247ab2),p.appearance||{},{}));
                    friendFace.x=13;friendFace.y=26;friendFace.scaleX=friendFace.scaleY=.17;clip.addChild(friendFace);
                }else {slot.graphics.beginFill(0xa6b2b1);slot.graphics.drawCircle(13,8,5);slot.graphics.drawRoundRect(5,14,16,9,4);slot.graphics.endFill();}
                if((isHome&&String(data.name)==String(GameData.mainPlayer().name))||data.appearance) {
                    portrait=new CharacterPortrait(data,32,28,false);portrait.x=43;portrait.y=0;addChild(portrait);
                }else {illustrated=new LineupPortrait(VisualAssetRegistry.playerSpriteFrame(String(data.name)),32,28,data);illustrated.x=43;addChild(illustrated);}
            }
            playerText=label(card?String(card.name):data&&data.name?String(data.name):'PLAYER',77,5,rowW-141,20,11,isHero?0xffd54b:0xffffff);playerText.name='simulation-player-name';
            var full:String=playerText.text;while(playerText.textWidth>playerText.width-4&&full.length>1){full=full.substr(0,full.length-1);playerText.text=full+'...';}
            avgText=label('',rowW-61,6,39,19,10,0x283c39);avgText.name='simulation-player-avg';refreshAverage();
            condition(mood);
            statusBox.x=14;statusBox.y=3;addChild(statusBox);statusText=label('',14,5,26,19,9,0xffffff);statusText.name='last-result';setResult('');
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):TextField {
            var t:TextField=new TextField();t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=false;t.mouseEnabled=false;
            LineupTypography.apply(t,size,color,'center');addChild(t);return t;
        }
        private function drawBase():void {
            graphics.clear();MatchChrome.row(graphics,0,0,rowW,rowH,active,rowIndex%2==1);
            MatchChrome.nameplate(graphics,77,5,rowW-140,19,active&&isHome);
        }
        private function condition(mood:int):void {ConditionArrow.paint(graphics,rowW-15,14,mood,13,13);}
        public function setActive(value:Boolean):void {
            if(value!=active){active=value;highlight.visible=value;highlight.alpha=1;drawBase();condition(conditionValue);playerText.textColor=isHero?0xffd54b:0xffffff;numberText.textColor=active?0xc27b0b:0x2c4239;}
            refreshAverage();
        }
        public function animateEmphasis(time:int):void {if(active)highlight.alpha=.55+.45*(.5+.5*Math.sin(time/170));}
        public function get isActive():Boolean{return active;}
        public function refreshAverage():void {
            var value:String=card?'.'+card.avg:data&&data.avg!==undefined?String(data.avg):'.200',n:Number=Number(value);
            if(value.charAt(0)!='.'&&!isNaN(n))value=n.toFixed(3).replace(/^0\./,'.');avgText.text=value;
        }
        public function setResult(result:String):void {
            var out:Boolean=result.indexOf('OUT')>=0,walk:Boolean=result.indexOf('WALK')>=0;
            var value:String=out?'OUT':walk?'BB':result.indexOf('HOME RUN')>=0?'HR':result.indexOf('TRIPLE')>=0?'3B':result.indexOf('DOUBLE')>=0?'2B':result.indexOf('SINGLE')>=0?'1B':'';
            statusBox.graphics.clear();if(value!=''){statusBox.graphics.lineStyle(1,0x507757);ClassicInventorySkin.gradient(statusBox.graphics,0,0,26,23,out?0xef8b87:walk?0x88d9f2:0xa6e866,out?0xb73d43:walk?0x3b9ebc:0x469e24,2);statusBox.graphics.lineStyle();}
            statusText.text=value;if(card&&value==''){statusBox.visible=statusText.visible=false;}else{statusBox.visible=statusText.visible=true;}refreshAverage();
        }
        public function dispose():void {if(portrait){portrait.dispose();portrait=null;}if(special){special.dispose();special=null;}if(illustrated){illustrated.dispose();illustrated=null;}if(friendFace){friendFace.dispose();friendFace=null;}}
    }
}
