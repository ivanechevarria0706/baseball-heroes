package com.bh.ui {
    import flash.geom.Rectangle;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import com.bh.model.GameData;
    import com.bh.model.StarterTutorial;
    import com.bh.visual.HomeSprite;
    /** Compact hero-anchored point panel. Investments and engine stats use separate units. */
    public class HeroStatPanel extends Sprite {
        private var closeCallback:Function,equipmentCallback:Function,buttons:Array=[],guide:StarterCoach;
        public function HeroStatPanel(close:Function,equipment:Function=null){name="hero-stat-panel";closeCallback=close;equipmentCallback=equipment;draw();}
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int=17,color:uint=0xffffff):void {
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("Arial",size,color,true);t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.multiline=t.wordWrap=true;t.mouseEnabled=t.selectable=false;addChild(t);
        }
        private function button(value:String,id:String,x:Number,y:Number,w:Number,callback:Function):void {
            var b:UIButton=new UIButton(value,w,25,0xd6d9d7,0xf9fbfa,0x8a989e,16);b.name=id;b.x=x;b.y=y;if(value=="")b.alpha=0;
            var handler:Function=function(e:MouseEvent):void{e.stopImmediatePropagation();callback();};b.addEventListener(MouseEvent.CLICK,handler);addChild(b);buttons.push({view:b,handler:handler});
        }
        private function draw():void {
            clear();graphics.beginFill(0x031626,.24);graphics.drawRect(0,75,960,435);graphics.endFill();
            ClassicChrome.well(graphics,592,132,330,143);button("X","hero-stat-close",890,137,25,closeCallback);
            var hero:Object=GameData.mainPlayer(),investment:Object=hero.skillInvestment;
            label("SKILL POINT",607,140,125,23,17,0x197ab3);label(int(hero.skillPoints)+" Points Left",739,142,147,22,14,0xa77e1f);
            var stats:Array=["contact","power","luck"],colors:Array=[0x3d9ac4,0xd15f61,0x73b63f],total:int=0;
            for(var i:int=0;i<3;i++){
                var stat:String=stats[i],value:int=investment?int(investment[stat]):int(hero[stat]);total+=value;
                ClassicChrome.fill(graphics,681,175+i*28,175,15,[0xd9dcda,0xf5f5f1],[0,255],7);
                label(["C","P","L"][i],662,168+i*28,22,24,17,colors[i]);label(String(value),859,168+i*28,27,24,15,colors[i]);
                var plus:UIButton=new UIButton("+",22,23,0xbfc8c9,0xf5fbfa,0x7b8c92,17);plus.name="stat-"+stat;plus.x=892;plus.y=170+i*28;plus.mouseEnabled=int(hero.skillPoints)>0&&int(hero[stat])<99;plus.alpha=plus.mouseEnabled?1:.45;
                var handler:Function=statHandler(stat);plus.addEventListener(MouseEvent.CLICK,handler);addChild(plus);buttons.push({view:plus,handler:handler});
            }
            graphics.lineStyle(2,0xd5e0df);graphics.beginFill(0xf7faf7);graphics.drawCircle(629,206,27);graphics.endFill();graphics.lineStyle();
            label(String(total),603,187,52,42,27,0x3a96bf);
            var slots:Array=["helmet","goggles","belt","glove","bat","shoes"],palette:Object=HomeSprite.paletteFor(hero.name,hero.accent,hero.appearance);
            for(i=0;i<slots.length;i++){
                var sx:Number=i<3?562:759,sy:Number=316+(i%3)*64;
                ClassicChrome.well(graphics,sx,sy,56,56,false);
                var item:Object=GameData.equipped[slots[i]],icon:Sprite=EquipmentScreen.createEquipmentIcon(slots[i],uint(palette[slots[i]=="shoes"?"shoe":slots[i]]),22);icon.x=sx+28;icon.y=sy+28;icon.alpha=item?1:.20;addChild(icon);
                if(equipmentCallback!=null)button("", "hero-gear-"+slots[i],sx,sy,56,equipmentCallback);
            }
            if(GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.POINT){
                var hasPoints:Boolean=int(hero.skillPoints)>0;
                guide=new StarterCoach(hasPoints?"¡Aumenta la habilidad que prefieras haciendo clic en +!":"Los puntos se ganan al subir de nivel. Cierra el panel para continuar; podrás invertirlos cuando los consigas.");addChild(guide);
                guide.pointTo(hasPoints?new Rectangle(889,168,27,82):new Rectangle(890,137,25,25),190,370);
            }else if(GameData.tutorialActive()&&GameData.starterTutorial.stage==StarterTutorial.DRAFT){guide=new StarterCoach("¡Bien hecho! Cierra el panel con X para continuar al draft.");addChild(guide);guide.pointTo(new Rectangle(890,137,25,25),190,370);}
        }
        private function statHandler(stat:String):Function {return function(e:MouseEvent):void{e.stopImmediatePropagation();if(GameData.allocateHeroStat(stat))draw();};}
        private function clear():void {for each(var entry:Object in buttons){entry.view.removeEventListener(MouseEvent.CLICK,entry.handler);entry.view.dispose();}buttons=[];if(guide){guide.dispose();guide=null;}while(numChildren)removeChildAt(0);graphics.clear();}
        public function dispose():void {clear();}
    }
}
