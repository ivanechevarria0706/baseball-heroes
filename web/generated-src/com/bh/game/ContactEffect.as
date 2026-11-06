package com.bh.game {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.GlowFilter;
    import flash.utils.getTimer;

    public class ContactEffect extends Sprite {
        private var started:int = 0;
        private var clock:Function;

        public function ContactEffect(timeSource:Function=null) {
            clock=timeSource!=null?timeSource:getTimer;
            mouseEnabled = false;
            mouseChildren = false;
            visible = false;
        }

        public function burst(px:Number, py:Number, result:String,delayMs:int=0):void {
            graphics.clear();
            x = px;
            y = py;

            var color:uint = 0xffffff;
            var secondary:uint = 0x92e9ff;

            if (result == "PERFECT") {
                color = 0xffd63f;
                secondary = 0xff7b3d;
            } else if (result == "GOOD") {
                color = 0x67f2d0;
                secondary = 0x66bfff;
            } else if (result == "FOUL") {
                color = 0xffa64d;
                secondary = 0xffe2a5;
            }

            graphics.beginFill(0xffffff, 0.98);
            graphics.drawCircle(0, 0, 9);
            graphics.endFill();

            graphics.beginFill(color, 0.70);
            graphics.drawCircle(0, 0, 18);
            graphics.endFill();

            graphics.lineStyle(6, color, 0.95);
            graphics.drawCircle(0, 0, 26);
            graphics.lineStyle(2, 0xffffff, 0.78);
            graphics.drawCircle(0, 0, 39);

            for (var i:int = 0; i < 20; i++) {
                var a:Number = Math.PI * 2 * i / 20;
                var r1:Number = i % 2 == 0 ? 31 : 25;
                var r2:Number = i % 3 == 0 ? 67 : 50;
                graphics.lineStyle(i % 2 == 0 ? 5 : 3, i % 2 == 0 ? color : secondary, 0.88);
                graphics.moveTo(Math.cos(a) * r1, Math.sin(a) * r1);
                graphics.lineTo(Math.cos(a) * r2, Math.sin(a) * r2);
            }

            graphics.lineStyle();
            for (var s:int = 0; s < 4; s++) {
                var sa:Number = Math.PI * 0.5 * s + Math.PI * 0.25;
                var sx:Number = Math.cos(sa) * 50;
                var sy:Number = Math.sin(sa) * 50;
                graphics.beginFill(secondary, 0.88);
                graphics.moveTo(sx, sy - 6);
                graphics.lineTo(sx + 5, sy);
                graphics.lineTo(sx, sy + 6);
                graphics.lineTo(sx - 5, sy);
                graphics.lineTo(sx, sy - 6);
                graphics.endFill();
            }

            filters = [new GlowFilter(color, 0.72, 12, 12, 2, 1)];
            visible = delayMs<=0;
            alpha = 1;
            scaleX = scaleY = 0.42;
            rotation = 0;
            started = int(clock())+Math.max(0,delayMs);

            removeEventListener(Event.ENTER_FRAME, animate);
            addEventListener(Event.ENTER_FRAME, animate);
        }

        private function animate(e:Event):void {
            if(int(clock())<started){visible=false;return;}visible=true;
            var life:Number=Math.max(0,(int(clock())-started)*30/1000);
            scaleX = scaleY = .42 + life*.095;
            alpha = Math.max(0,1-Math.min(6,life)*.025-Math.max(0,life-6)*.075);
            rotation = life*3.4;

            if (life >= 19 || alpha <= 0) {
                visible = false;
                removeEventListener(Event.ENTER_FRAME, animate);
            }
        }

        public function clear():void {removeEventListener(Event.ENTER_FRAME,animate);visible=false;graphics.clear();}
        public function dispose():void {
            removeEventListener(Event.ENTER_FRAME, animate);
            visible = false;
        }
    }
}
