package com.bh.ui {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    import com.bh.model.GameData;
    import com.bh.visual.AssetImage;
    import com.bh.visual.VisualAssetRegistry;

    public class ShopItemCard extends Sprite {
        public var data:Object;

        private var cardW:Number;
        private var cardH:Number;
        private var selected:Boolean = false;
        private var art:AssetImage;

        public function ShopItemCard(
            item:Object,
            w:Number = 190,
            h:Number = 142
        ) {
            super();

            data = item;
            cardW = w;
            cardH = h;

            buttonMode = true;
            useHandCursor = true;
            mouseChildren = false;

            draw();
        }

        public function setSelected(
            value:Boolean
        ):void {
            selected = value;
            draw();
        }

        public function refresh():void {
            draw();
        }

        private function draw():void {
            if (art) {
                art.dispose();
                if (art.parent) {
                    art.parent.removeChild(art);
                }
                art = null;
            }

            graphics.clear();

            var unlocked:Boolean =
                GameData.shopItemUnlocked(data);

            var owned:Boolean =
                GameData.ownsShopItem(data);

            var accent:uint =
                uint(data.accent);

            var border:uint =
                selected
                ? 0xffd84c
                : (
                    unlocked
                    ? accent
                    : 0x7b858b
                );

            if (cardH < 80) {
                drawCompact(
                    unlocked,
                    accent,
                    border
                );
                return;
            }

            while (numChildren > 0) {
                removeChildAt(0);
            }

            graphics.beginFill(0x000000, 0.20);
            graphics.drawRoundRect(4, 5, cardW, cardH, 12, 12);
            graphics.endFill();

            graphics.beginFill(
                unlocked
                ? 0xf7f5ef
                : 0xb5bdc1
            );
            graphics.drawRoundRect(0, 0, cardW, cardH, 12, 12);
            graphics.endFill();

            graphics.lineStyle(
                selected ? 4 : 2,
                border,
                1
            );
            graphics.drawRoundRect(0, 0, cardW, cardH, 12, 12);
            graphics.lineStyle();

            // Colored title strip.
            graphics.beginFill(
                accent,
                unlocked ? 1 : 0.45
            );
            graphics.drawRoundRect(7, 7, cardW - 14, 31, 8, 8);
            graphics.endFill();

            graphics.beginFill(0xffffff, 0.18);
            graphics.drawRoundRect(11, 10, cardW - 22, 9, 5, 5);
            graphics.endFill();

            var stadiumArtPath:String = "";
            if (
                String(data.category) == "STADIUM" &&
                String(data.slot) == "background"
            ) {
                stadiumArtPath =
                    VisualAssetRegistry.stadiumPath(
                        String(data.id)
                    );
            }

            if (
                stadiumArtPath &&
                stadiumArtPath.length > 0
            ) {
                graphics.beginFill(0x233c4b);
                graphics.drawRoundRect(13, 45, cardW - 26, 58, 8, 8);
                graphics.endFill();

                art = new AssetImage(
                    stadiumArtPath,
                    cardW - 30,
                    54,
                    AssetImage.COVER
                );
                art.x = 15;
                art.y = 47;
                addChild(art);
            }
            else {
                // Product medallion.
                graphics.beginFill(0xe6edf0);
                graphics.drawCircle(cardW * 0.5, 76, 31);
                graphics.endFill();
                graphics.lineStyle(2, 0xb7c3c9);
                graphics.drawCircle(cardW * 0.5, 76, 31);
                graphics.lineStyle();

                drawIcon(
                    cardW * 0.5,
                    76,
                    accent,
                    String(data.category),
                    String(data.slot)
                );
            }

            addText(
                String(data.name),
                10,
                12,
                cardW - 20,
                18,
                11,
                0xffffff,
                TextFormatAlign.CENTER
            );

            var lower:String;

            if (!unlocked) {
                lower =
                    "LOCKED • " +
                    GameData.requiredLeagueName(data);
            }
            else if (owned) {
                lower = "✓ OWNED";
            }
            else {
                lower =
                    GameData.shopPriceLabel(data);
            }

            graphics.beginFill(
                owned
                ? 0xdff0df
                : 0xe7ecef
            );
            graphics.drawRoundRect(10, 108, cardW - 20, 20, 8, 8);
            graphics.endFill();

            addText(
                lower,
                10,
                111,
                cardW - 20,
                15,
                9,
                !unlocked
                ? 0x555e63
                : (
                    owned
                    ? 0x2c7a3e
                    : 0x6c4b10
                ),
                TextFormatAlign.CENTER
            );

            addText(
                String(data.grade) +
                "  •  " +
                String(data.slot).toUpperCase(),
                8,
                130,
                cardW - 16,
                12,
                8,
                accent,
                TextFormatAlign.CENTER
            );
        }


        private function drawCompact(
            unlocked:Boolean,
            accent:uint,
            border:uint
        ):void {
            graphics.beginFill(
                unlocked
                    ? 0xe7edf1
                    : 0x9ca7ad
            );
            graphics.drawRoundRect(
                0,
                0,
                cardW,
                cardH,
                7,
                7
            );
            graphics.endFill();

            graphics.lineStyle(
                selected ? 3 : 2,
                border,
                1
            );
            graphics.drawRoundRect(
                0,
                0,
                cardW,
                cardH,
                7,
                7
            );
            graphics.lineStyle();

            graphics.beginFill(accent);
            graphics.drawRect(
                0,
                0,
                7,
                cardH
            );
            graphics.endFill();

            while (numChildren > 0) {
                removeChildAt(0);
            }

            addText(
                String(data.name),
                11,
                3,
                cardW - 16,
                14,
                8,
                unlocked
                    ? 0x172536
                    : 0x4d565c,
                TextFormatAlign.LEFT
            );

            addText(
                String(data.slot).toUpperCase(),
                11,
                16,
                cardW - 16,
                11,
                7,
                accent,
                TextFormatAlign.LEFT
            );
        }

        private function drawIcon(
            cx:Number,
            cy:Number,
            accent:uint,
            category:String,
            slot:String
        ):void {
            graphics.lineStyle(
                7,
                accent,
                1
            );

            if (category == "EQUIPMENT") {
                if (slot == "bat") {
                    graphics.moveTo(
                        cx - 18,
                        cy + 15
                    );
                    graphics.lineTo(
                        cx + 18,
                        cy - 16
                    );
                }
                else if (slot == "glove") {
                    graphics.moveTo(
                        cx - 17,
                        cy + 13
                    );
                    graphics.curveTo(
                        cx - 6,
                        cy - 20,
                        cx + 18,
                        cy - 4
                    );
                    graphics.curveTo(
                        cx + 9,
                        cy + 19,
                        cx - 17,
                        cy + 13
                    );
                }
                else {
                    graphics.moveTo(
                        cx - 18,
                        cy + 8
                    );
                    graphics.lineTo(
                        cx + 5,
                        cy + 8
                    );
                    graphics.lineTo(
                        cx + 18,
                        cy + 18
                    );
                }
            }
            else if (category == "STADIUM") {
                if (slot == "scoreboard") {
                    graphics.drawRect(
                        cx - 22,
                        cy - 15,
                        44,
                        30
                    );
                }
                else if (slot == "banner") {
                    graphics.moveTo(
                        cx - 22,
                        cy - 13
                    );
                    graphics.lineTo(
                        cx + 22,
                        cy - 13
                    );
                    graphics.lineTo(
                        cx + 13,
                        cy + 15
                    );
                    graphics.lineTo(
                        cx - 13,
                        cy + 15
                    );
                    graphics.lineTo(
                        cx - 22,
                        cy - 13
                    );
                }
                else if (slot == "lights") {
                    graphics.moveTo(
                        cx,
                        cy + 20
                    );
                    graphics.lineTo(
                        cx,
                        cy - 14
                    );
                    graphics.lineTo(
                        cx + 18,
                        cy - 14
                    );
                }
                else {
                    graphics.moveTo(
                        cx - 24,
                        cy + 10
                    );
                    graphics.lineTo(
                        cx + 24,
                        cy + 10
                    );
                    graphics.moveTo(
                        cx - 19,
                        cy - 7
                    );
                    graphics.lineTo(
                        cx + 19,
                        cy - 7
                    );
                }
            }
            else {
                graphics.drawCircle(
                    cx,
                    cy,
                    19
                );
                graphics.moveTo(
                    cx - 7,
                    cy
                );
                graphics.lineTo(
                    cx + 7,
                    cy
                );
                graphics.moveTo(
                    cx,
                    cy - 7
                );
                graphics.lineTo(
                    cx,
                    cy + 7
                );
            }

            graphics.lineStyle();
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
            var t:TextField =
                new TextField();

            var f:TextFormat =
                new TextFormat(
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
        public function dispose():void {
            if (art) {
                art.dispose();
                art = null;
            }
        }

    }
}
