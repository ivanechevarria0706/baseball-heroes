package com.bh.game {
    import flash.display.Sprite;

    public class StrikeZone extends Sprite {
        private var zoneW:Number;
        private var zoneH:Number;

        public function StrikeZone(px:Number, py:Number, w:Number = 84, h:Number = 100) {
            super();
            x = px;
            y = py;
            zoneW = w;
            zoneH = h;
            mouseEnabled = false;
            mouseChildren = false;
            draw();
        }

        private function draw():void {
            graphics.clear();
            graphics.beginFill(0xffffff, 0.030);
            graphics.drawRect(-zoneW / 2, -zoneH / 2, zoneW, zoneH);
            graphics.endFill();
            graphics.lineStyle(2.5, 0xf3ffe4, 0.88);
            graphics.drawRect(-zoneW / 2, -zoneH / 2, zoneW, zoneH);
            graphics.lineStyle(1, 0xffffff, 0.08);
            graphics.moveTo(-zoneW / 6, -zoneH / 2); graphics.lineTo(-zoneW / 6, zoneH / 2);
            graphics.moveTo(zoneW / 6, -zoneH / 2); graphics.lineTo(zoneW / 6, zoneH / 2);
            graphics.moveTo(-zoneW / 2, -zoneH / 6); graphics.lineTo(zoneW / 2, -zoneH / 6);
            graphics.moveTo(-zoneW / 2, zoneH / 6); graphics.lineTo(zoneW / 2, zoneH / 6);
            graphics.lineStyle();
        }

        public function containsWorldPoint(px:Number, py:Number, margin:Number = 0):Boolean {
            return px >= x - zoneW / 2 - margin && px <= x + zoneW / 2 + margin &&
                   py >= y - zoneH / 2 - margin && py <= y + zoneH / 2 + margin;
        }

        public function randomStrikeX(command:Number):Number {
            var spread:Number = 0.86 - command * 0.18;
            return x + (Math.random() - 0.5) * zoneW * spread;
        }

        public function randomStrikeY(command:Number):Number {
            var spread:Number = 0.88 - command * 0.14;
            return y + (Math.random() - 0.5) * zoneH * spread;
        }

        public function randomBallPoint():Object {
            var side:int = int(Math.random() * 4);
            var px:Number = x + (Math.random() - 0.5) * zoneW * 0.95;
            var py:Number = y + (Math.random() - 0.5) * zoneH * 0.95;
            var extraX:Number = 12 + Math.random() * 25;
            var extraY:Number = 12 + Math.random() * 28;

            if (side == 0) px = x - zoneW / 2 - extraX;
            else if (side == 1) px = x + zoneW / 2 + extraX;
            else if (side == 2) py = y - zoneH / 2 - extraY;
            else py = y + zoneH / 2 + extraY;

            return {x:px, y:py};
        }
    }
}
