package com.bh.ui {
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import com.bh.model.GameData;
    import com.bh.visual.CharacterPortrait;

    /** Read-only player data, with an explicit optional lineup action. */
    public class PlayerDossier extends Sprite {
        private var card:Sprite=new Sprite(),portrait:CharacterPortrait;
        private var controls:Array=[],closed:Boolean=false;
        private var closeAction:Function;
        public function PlayerDossier(p:Object,w:Number,h:Number,onClose:Function,onUse:Function=null,useLabel:String='LINEUP'){
            name='player-dossier';closeAction=onClose;
            graphics.beginFill(0x031827,.78);graphics.drawRect(0,0,w,h);graphics.endFill();
            addChild(card);var scale:Number=Math.min(1,(w-32)/820,(h-32)/620);card.scaleX=card.scaleY=scale;card.x=(w-820*scale)/2;card.y=(h-620*scale)/2;
            box(0,0,820,620,0x0a5686);box(8,8,804,63,0x073d66);
            label('PLAYER PROFILE',24,15,490,20,12,0x95d1e9);
            var title:TextField=label(String(p.name),24,33,670,34,25,0xffffff);fit(title,25,14);
            portrait=new CharacterPortrait(p,176,196,true);portrait.x=28;portrait.y=91;card.addChild(portrait);
            label((p.specialCardId?'CLASS '+p.cardClass:String(p.pos))+'  /  '+String(p.grade),25,296,182,25,14,0xffdc72,'center');
            label('LEVEL '+p.level+'    RATING '+p.rating,22,326,189,24,13,0xe4f1f1,'center');
            var order:Array=GameData.battingOrderPlayers(),spot:int=-1;
            for(var i:int=0;i<order.length;i++)if(String(order[i].name)==String(p.name))spot=i;
            label(spot>=0?'BATTING ORDER  #'+(spot+1):'SUBSTITUTE',22,360,189,24,12,spot>=0?0xaee969:0xc9d8df,'center');
            box(230,91,563,244,0x173c52);label('BATTING ATTRIBUTES',246,103,510,22,14,0xbce2ef);
            var stats:Array=[['CONTACT','contact',GameData.effectiveContact(p)],['POWER','power',GameData.effectivePower(p)],['SPEED','speed',GameData.effectiveSpeed(p)],['LUCK','luck',GameData.effectiveLuck(p)]];
            label('BASE     EQUIPMENT     TOTAL',469,130,300,19,11,0x9bb9c7);
            for(i=0;i<stats.length;i++){
                var st:Array=stats[i],yy:Number=158+i*41;
                label(st[0],247,yy,129,22,13,0xe7edf0);
                card.graphics.beginFill(0x294e5c);card.graphics.drawRoundRect(368,yy+6,109,12,8);card.graphics.endFill();
                card.graphics.beginFill([0x55becc,0xe7ae4a,0x93ce54,0xaf8bd1][i]);card.graphics.drawRoundRect(368,yy+6,Math.max(3,109*Math.min(1,Number(st[2])/500)),12,8);card.graphics.endFill();
                label(String(p[st[1]]),487,yy,54,23,16,0xe5edf1,'center');label('+'+(p===GameData.mainPlayer()?GameData.equipmentBonus(st[1]):0),550,yy,92,23,15,0x91cadb,'center');
                var total:TextField=label(String(st[2]),672,yy,86,26,20,0xffdc72,'center');total.name='profile-'+st[1];
            }
            box(230,346,563,66,0x164665);
            var career:Array=[['AVG',p.avg],['HR',p.hr],['RBI',p.rbi]];
            for(i=0;i<3;i++){label(career[i][0],246+i*179,350,165,20,11,0xa9cddd,'center');label(String(career[i][1]),246+i*179,372,165,30,22,0xffffff,'center');}
            box(24,428,769,117,0x123f59);
            label('EQUIPMENT',38,436,170,21,12,0xb1d7e6);
            var slots:Array=['bat','glove','belt','helmet','shoes','goggles'];
            for(i=0;i<slots.length;i++){
                var item:Object=p===GameData.mainPlayer()&&GameData.equipped?GameData.equipped[slots[i]]:null;
                var cell:TextField=label(String(slots[i]).toUpperCase()+': '+(item?String(item.name):'—'),39+(i%3)*247,462+int(i/3)*34,232,29,12,0xffffff);fit(cell,12,9);
            }
            var skill:TextField=label('SKILL  ·  '+GameData.activeSkillName(p),25,391,183,30,11,0xd2eafa,'center');skill.multiline=skill.wordWrap=true;fit(skill,11,9);
            button('PROFILE_CLOSE','CLOSE',638,560,155,onClose);
            if(onUse!=null)button('PROFILE_USE',useLabel,395,560,229,onUse,0x64a62a);
            label(p.specialCardId?'ENERGY '+GameData.specialCardEnergy(p.specialCardId)+' / 2  |  COMBO +'+p.combo:'CONDITION '+com.bh.model.PlayerCondition.labelFor(GameData.matchCondition(p))+'  |  XP '+int(p.xp)+' / 100',26,562,354,43,10,0xb0ccd6).wordWrap=true;
            addEventListener(MouseEvent.CLICK,block);addEventListener(MouseEvent.MOUSE_DOWN,block);
        }
        private function box(x:Number,y:Number,w:Number,h:Number,color:uint):void{card.graphics.lineStyle(2,0x78b1cd);card.graphics.beginFill(color);card.graphics.drawRoundRect(x,y,w,h,10);card.graphics.endFill();card.graphics.lineStyle();}
        private function label(s:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint,align:String='left'):TextField{var t:TextField=new TextField();t.defaultTextFormat=new TextFormat('Arial',size,color,true,null,null,null,null,align);t.text=s;t.x=x;t.y=y;t.width=w;t.height=h;t.selectable=t.mouseEnabled=false;card.addChild(t);return t;}
        private function fit(t:TextField,start:int,min:int):void{var f:TextFormat=t.defaultTextFormat;for(var size:int=start;t.textWidth>t.width-5&&size>=min;size--){f.size=size;t.setTextFormat(f);}}
        private function button(id:String,title:String,x:Number,y:Number,w:Number,action:Function,color:uint=0x246b94):void{var b:UIButton=new UIButton(title,w,39,color,0x4d97b7,0xc7e5ef);b.name=id;b.x=x;b.y=y;var cb:Function=function(e:MouseEvent):void{e.stopPropagation();if(action!=null)action();};b.addEventListener(MouseEvent.CLICK,cb);card.addChild(b);controls.push({b:b,cb:cb});}
        private function block(e:MouseEvent):void{e.stopPropagation();}
        public function dispose():void{if(closed)return;closed=true;removeEventListener(MouseEvent.CLICK,block);removeEventListener(MouseEvent.MOUSE_DOWN,block);portrait.dispose();for each(var c:Object in controls){c.b.removeEventListener(MouseEvent.CLICK,c.cb);c.b.dispose();}controls=[];}
    }
}
