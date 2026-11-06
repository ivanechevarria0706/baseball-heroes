package com.bh.ui {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class FriendCard extends Sprite {
        public function FriendCard(
            personName:String,
            level:int,
            avg:String,
            hr:int,
            rbi:int,
            accent:uint
        ) {
            super();

            mouseChildren = false;

            graphics.beginFill(0xe9eef2);
            graphics.drawRoundRect(0, 0, 88, 64, 8, 8);
            graphics.endFill();

            graphics.lineStyle(2, 0x73879a);
            graphics.drawRoundRect(0, 0, 88, 64, 8, 8);
            graphics.lineStyle();

            // Portrait frame
            graphics.beginFill(0xffffff);
            graphics.drawRoundRect(5, 5, 39, 39, 5, 5);
            graphics.endFill();

            graphics.beginFill(accent);
            graphics.drawCircle(24, 21, 13);
            graphics.endFill();

            graphics.beginFill(0xe8b58b);
            graphics.drawCircle(24, 25, 8);
            graphics.endFill();

            var n:TextField = makeText(
                personName,
                9,
                0x172536,
                41,
                16,
                TextFormatAlign.CENTER
            );
            n.x = 3;
            n.y = 43;
            addChild(n);

            var lvl:TextField = makeText(
                String(level),
                18,
                0x172536,
                34,
                23,
                TextFormatAlign.CENTER
            );
            lvl.x = 48;
            lvl.y = 5;
            addChild(lvl);

            var stats:TextField = makeText(
                "AVG " + avg + "\nHR " + hr + "  RBI " + rbi,
                8,
                0x314357,
                40,
                29,
                TextFormatAlign.LEFT
            );
            stats.x = 46;
            stats.y = 31;
            stats.multiline = true;
            addChild(stats);

            // Energy +
            graphics.beginFill(0x6dcc45);
            graphics.drawCircle(78, 10, 7);
            graphics.endFill();

            var plus:TextField = makeText(
                "+",
                10,
                0xffffff,
                14,
                14,
                TextFormatAlign.CENTER
            );
            plus.x = 71;
            plus.y = 2;
            addChild(plus);
        }

        private function makeText(
            text:String,
            size:int,
            color:uint,
            w:Number,
            h:Number,
            align:String
        ):TextField {
            var t:TextField = new TextField();
            var f:TextFormat = new TextFormat(
                "Arial",
                size,
                color,
                true
            );
            f.align = align;

            t.defaultTextFormat = f;
            t.text = text;
            t.width = w;
            t.height = h;
            t.selectable = false;
            t.mouseEnabled = false;
            t.wordWrap = false;

            return t;
        }
    }
}
