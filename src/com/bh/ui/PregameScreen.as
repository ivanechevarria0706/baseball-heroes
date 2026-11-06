package com.bh.ui {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    import com.bh.model.GameData;

    public class PregameScreen extends Sprite {
        private var screenW:Number;
        private var screenH:Number;

        private var onStart:Function;
        private var onHome:Function;
        private var onLineup:Function;

        private var startButton:UIButton;
        private var homeButton:UIButton;
        private var lineupButton:UIButton;

        public function PregameScreen(
            w:Number,
            h:Number,
            startCallback:Function,
            homeCallback:Function,
            lineupCallback:Function
        ) {
            super();

            screenW = w;
            screenH = h;
            onStart = startCallback;
            onHome = homeCallback;
            onLineup = lineupCallback;

            GameData.init();

            drawBackground();
            drawTopBar();
            drawMatchup();
            drawBattingOrder();
            drawFooter();
        }

        private function drawBackground():void {
            graphics.beginFill(0x071322);
            graphics.drawRect(0, 0, screenW, screenH);
            graphics.endFill();

            graphics.beginFill(0x173c67);
            graphics.drawRect(0, 64, screenW, 180);
            graphics.endFill();

            graphics.beginFill(0x20384d);
            graphics.drawRect(0, 226, screenW, 126);
            graphics.endFill();

            for (var r:int = 0; r < 5; r++) {
                for (var c:int = 0; c < 50; c++) {
                    var color:uint;
                    var m:int = (r * 5 + c) % 5;

                    if (m == 0) color = 0xefc950;
                    else if (m == 1) color = 0xd85b4e;
                    else if (m == 2) color = 0x6ba1d3;
                    else if (m == 3) color = 0x84c36c;
                    else color = 0xe7edf1;

                    graphics.beginFill(color, 0.78);
                    graphics.drawCircle(8 + c * 20, 253 + r * 16, 2.5);
                    graphics.endFill();
                }
            }

            graphics.beginFill(
                GameData.stadiumAccent(
                    "wall",
                    0x1c6540
                )
            );
            graphics.drawRect(0, 347, screenW, 48);
            graphics.endFill();

            graphics.beginFill(0x2a854b);
            graphics.drawRect(0, 395, screenW, screenH - 395);
            graphics.endFill();
        }

        private function drawTopBar():void {
            graphics.beginFill(0x07111e, 0.99);
            graphics.drawRect(0, 0, screenW, 64);
            graphics.endFill();

            graphics.beginFill(0x284d6e);
            graphics.drawRect(0, 62, screenW, 2);
            graphics.endFill();

            addText(
                "GAME PREVIEW",
                24,
                15,
                180,
                29,
                22,
                0xffffff,
                TextFormatAlign.LEFT
            );

            addText(
                GameData.seasonLabel() +
                "   " +
                GameData.seasonRecord(),
                214,
                22,
                330,
                20,
                11,
                0x9cb6c7,
                TextFormatAlign.LEFT
            );

            addText(
                "E " +
                GameData.energy +
                "   C " +
                formatNumber(GameData.coins),
                590,
                20,
                205,
                23,
                15,
                0xffdc73,
                TextFormatAlign.RIGHT
            );

            homeButton = new UIButton(
                "HOME",
                132,
                38,
                0x355976,
                0x4b789e,
                0x8eb0c7
            );
            homeButton.x = 816;
            homeButton.y = 13;
            homeButton.addEventListener(
                MouseEvent.CLICK,
                onHomeClick
            );
            addChild(homeButton);
        }

        private function drawMatchup():void {
            var opponent:Object =
                GameData.currentOpponent();

            graphics.beginFill(0x0b1b2a, 0.94);
            graphics.drawRoundRect(75, (91) + (45), 810, 179, 15, 15);
            graphics.endFill();

            graphics.lineStyle(2, 0x58758b);
            graphics.drawRoundRect(75, (91) + (45), 810, 179, 15, 15);
            graphics.lineStyle();

            // Heroes badge
            graphics.beginFill(0x28664a);
            graphics.drawCircle(198, (171) + (45), 54);
            graphics.endFill();

            addText("H", 165, (142) + (45), 66, 52, 35, 0xffffff, TextFormatAlign.CENTER);

            addText("IVAN HEROES", 111, (225) + (45), 174, 23, 15, 0xa9efb5, TextFormatAlign.CENTER);

            // VS
            addText("VS", 430, (134) + (45), 100, 47, 34, 0xffd15b, TextFormatAlign.CENTER);

            addText(GameData.leagueName() +
                " LEAGUE", 399, (190) + (45), 162, 19, 11, 0x9bb5c6, TextFormatAlign.CENTER);

            addText("GAME " +
                GameData.seasonGame +
                " / 30", 410, (215) + (45), 140, 18, 10, 0xffffff, TextFormatAlign.CENTER);

            // Rival badge
            graphics.beginFill(uint(opponent.accent));
            graphics.drawCircle(760, (171) + (45), 54);
            graphics.endFill();

            addText("R", 727, (142) + (45), 66, 52, 35, 0xffffff, TextFormatAlign.CENTER);

            addText(String(opponent.teamName), 673, (225) + (45), 174, 23, 15, 0xaed7ff, TextFormatAlign.CENTER);

            addText(String(opponent.pitcherName) +
                "   OVR " +
                opponent.rating, 654, (105) + (45), 211, 19, 11, 0xffffff, TextFormatAlign.CENTER);

            var pitches:Array =
                opponent.repertoire as Array;

            addText("PITCHES  " +
                pitches.join(" / "), 583, (248) + (45), 302, 17, 9, 0x9cb6c7, TextFormatAlign.RIGHT);
        }

        private function drawBattingOrder():void {
            graphics.beginFill(0x0b1b2a, 0.96);
            graphics.drawRoundRect(75, (286) + (125), 810, 174, 13, 13);
            graphics.endFill();

            graphics.lineStyle(2, 0x55758d);
            graphics.drawRoundRect(75, (286) + (125), 810, 174, 13, 13);
            graphics.lineStyle();

            addText("BATTING ORDER", 94, (299) + (125), 170, 22, 16, 0xffffff, TextFormatAlign.LEFT);

            addText("SPECIAL " +
                GameData.equippedSpecialCards().length +
                "/5   COMBO " +
                GameData.specialCombo() +
                "   " +
                GameData.specialComboTier(), 438, (301) + (125), 424, 18, 9, 0xffd867, TextFormatAlign.RIGHT);

            var order:Array =
                GameData.battingOrderPlayers();

            for (
                var i:int = 0;
                i < order.length;
                i++
            ) {
                var p:Object =
                    order[i];

                var col:int =
                    i % 3;

                var row:int =
                    int(i / 3);

                var x:Number =
                    96 + col * 260;

                var y:Number =
                    455 + row * 39;

                graphics.beginFill(
                    0x142c40
                );
                graphics.drawRoundRect(
                    x,
                    y,
                    242,
                    31,
                    7,
                    7
                );
                graphics.endFill();

                graphics.beginFill(
                    uint(p.accent)
                );
                graphics.drawCircle(
                    x + 17,
                    y + 15,
                    10
                );
                graphics.endFill();

                addText(
                    String(i + 1),
                    x + 3,
                    y + 5,
                    28,
                    18,
                    10,
                    0xffffff,
                    TextFormatAlign.CENTER
                );

                addText(
                    String(p.name),
                    x + 35,
                    y + 5,
                    104,
                    18,
                    10,
                    0xffffff,
                    TextFormatAlign.LEFT
                );

                addText(
                    String(p.pos) +
                    "  OVR " +
                    p.rating,
                    x + 139,
                    y + 5,
                    93,
                    18,
                    9,
                    0x9bb4c5,
                    TextFormatAlign.RIGHT
                );
            }
        }

        private function drawFooter():void {
            lineupButton = new UIButton(
                "EDIT LINEUP",
                158,
                46,
                0x4b6385,
                0x647fab,
                0x9ab8d5
            );
            lineupButton.x = 230;
            lineupButton.y = (478) + (screenH - 540);
            lineupButton.addEventListener(
                MouseEvent.CLICK,
                onLineupClick
            );
            addChild(lineupButton);

            startButton = new UIButton(
                "PLAY BALL!  -1 E",
                250,
                46,
                0x177fc0,
                0x25a5ed,
                0xffffff
            );
            startButton.x = 410;
            startButton.y = (478) + (screenH - 540);
            startButton.addEventListener(
                MouseEvent.CLICK,
                onStartClick
            );
            addChild(startButton);

            addText(GameData.activeSkillName(
                    GameData.mainPlayer()
                ), 676, (486) + (screenH - 540), 190, 21, 10, 0xffd866, TextFormatAlign.CENTER);
        }

        private function onStartClick(
            e:MouseEvent
        ):void {
            if (onStart != null) {
                onStart();
            }
        }

        private function onHomeClick(
            e:MouseEvent
        ):void {
            if (onHome != null) {
                onHome();
            }
        }

        private function onLineupClick(
            e:MouseEvent
        ):void {
            if (onLineup != null) {
                onLineup();
            }
        }

        private function addText(
            text:String,
            x:Number,
            y:Number,
            w:Number,
            h:Number,
            size:int,
            color:uint,
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
            t.x = x;
            t.y = y;
            t.width = w;
            t.height = h;
            t.selectable = false;
            t.mouseEnabled = false;

            addChild(t);
            return t;
        }

        private function formatNumber(
            value:int
        ):String {
            var s:String = String(value);
            var result:String = "";

            while (s.length > 3) {
                result =
                    "," +
                    s.substr(s.length - 3) +
                    result;

                s =
                    s.substr(
                        0,
                        s.length - 3
                    );
            }

            return s + result;
        }

        public function dispose():void {
            if (startButton) {
                startButton.removeEventListener(
                    MouseEvent.CLICK,
                    onStartClick
                );
                startButton.dispose();
            }

            if (homeButton) {
                homeButton.removeEventListener(
                    MouseEvent.CLICK,
                    onHomeClick
                );
                homeButton.dispose();
            }

            if (lineupButton) {
                lineupButton.removeEventListener(
                    MouseEvent.CLICK,
                    onLineupClick
                );
                lineupButton.dispose();
            }
        }
    }
}
