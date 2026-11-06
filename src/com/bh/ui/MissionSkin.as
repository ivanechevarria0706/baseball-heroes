package com.bh.ui {
    import flash.display.*;
    import flash.text.TextField;
    import com.bh.model.GameData;
    import com.bh.visual.AchievementArtwork;
    import com.bh.visual.InterfaceSprite;
    import com.bh.visual.BuildArtwork;
    /** Shared presentation only. The existing model owns objectives and rewards. */
    public class MissionSkin {
        public static function find(id:String):Object {for each(var m:Object in GameData.missionCatalog())if(m.id==id)return m;return null;}
        public static function category(id:String):String {return id=="stadium_growth"?"STADIUM":id=="draft_growth"?"TEAM":id=="hero_growth"||id=="tutorial_basics"?"HERO":"RECORDS";}
        private static function objectiveLabel(value:String):String {
            var labels:Object={"Improve a batting ability":"Mejora una habilidad de bateo","Reach Hero Level 9":"Alcanza el nivel 9 del héroe","Hits against breaking balls":"Hits contra lanzamientos rompientes","Hits against four-seam fastballs":"Hits contra rectas de cuatro costuras","Hits against two-seam fastballs":"Hits contra rectas de dos costuras","One-run wins":"Victorias por una carrera","Games with three hero singles":"Partidos con tres singles del héroe"};
            return labels.hasOwnProperty(value)?String(labels[value]):value;
        }
        public static function check(g:Graphics,x:Number,y:Number,scale:Number=1):void {g.lineStyle(2,0x614033);g.beginFill(0xd94739);g.moveTo(x,y+7*scale);g.lineTo(x+5*scale,y+12*scale);g.lineTo(x+17*scale,y);g.lineTo(x+21*scale,y+4*scale);g.lineTo(x+5*scale,y+20*scale);g.lineTo(x-4*scale,y+11*scale);g.lineTo(x,y+7*scale);g.endFill();g.lineStyle();}
        public static function objectives(parent:Sprite,mission:Object,x:Number,y:Number,w:Number,h:Number,size:int):void {
            var index:int=0;for each(var o:Object in mission.objectives){var at:Number=y+index*(h+5),done:Boolean=int(o.current)>=int(o.target),ratio:Number=Math.max(0,Math.min(1,int(o.current)/Math.max(1,int(o.target))));
                var g:Graphics=parent.graphics;g.lineStyle(1,0xb3bbc0);ClassicInventorySkin.gradient(g,x,at,w,h,0xffffff,0xe7e9e6,5);g.lineStyle();
                var label:TextField=ClassicInventorySkin.text(parent,objectiveLabel(String(o.label)),x+10,at+4,w-146,h-12,size,0x38464e);label.name="mission-objective-"+index;
                var count:TextField=ClassicInventorySkin.text(parent,Math.min(int(o.current),int(o.target))+" / "+o.target,x+w-101,at+6,92,h-14,size+1,done?0x397c30:0x9b4b42,"right");count.name="mission-count-"+index;
                if(done)check(g,x+w-120,at+8,.55);
                g.beginFill(0xb8c5cc);g.drawRoundRect(x+10,at+h-9,w-65,4,3);g.endFill();if(ratio>0){g.beginFill(done?0x76b72c:0x338cbc);g.drawRoundRect(x+10,at+h-9,(w-65)*ratio,4,3);g.endFill();}index++;
            }
        }
        public static function rewardIcon(parent:Sprite,kind:String,x:Number,y:Number,scale:Number=1):void {
            if(kind!="SKILL"){ClassicInventorySkin.icon(parent,"coin",x,y,scale);return;}
            var s:Sprite=new AchievementArtwork("skill",34,34);s.x=x;s.y=y;s.scaleX=s.scaleY=scale;parent.addChild(s);
        }
        public static function icon(parent:Sprite,kind:String,x:Number,y:Number):void {
            var s:Sprite=kind=="RECORDS"?new BuildArtwork("category_scoreboard",50,43):new InterfaceSprite(kind=="HERO"?"helmet":kind=="TEAM"?"scout":"build",50,43);
            s.x=x;s.y=y;parent.addChild(s);
        }
    }
}
