package com.bh.ui {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;

    import com.bh.visual.CharacterPortrait;

    public class PlayerCard extends Sprite {
        public var data:Object;

        private var cardW:Number;
        private var cardH:Number;
        private var selected:Boolean = false;
        private var portrait:CharacterPortrait;

        public function PlayerCard(
            playerData:Object,
            w:Number = 102,
            h:Number = 76
        ) {
            super();

            data = playerData;
            cardW = w;
            cardH = h;

            buttonMode = true;
            useHandCursor = true;
            mouseChildren = false;

            draw();
        }

        public function setSelected(value:Boolean):void {
            selected = value;
            draw();
        }

        private function draw():void {
            graphics.clear();

            var accent:uint =
                uint(data.accent);

            var grade:String =
                String(data.grade);

            var frame:uint =
                rarityFrameColor(
                    grade,
                    accent
                );

            var inner:uint =
                rarityInnerColor(
                    grade
                );

            graphics.beginFill(
                0x000000,
                0.28
            );
            graphics.drawRoundRect(
                3,
                4,
                cardW,
                cardH,
                9,
                9
            );
            graphics.endFill();

            graphics.beginFill(inner);
            graphics.drawRoundRect(
                0,
                0,
                cardW,
                cardH,
                9,
                9
            );
            graphics.endFill();

            graphics.lineStyle(
                selected ? 4 : 2,
                selected
                    ? 0xffe36d
                    : frame,
                1
            );
            graphics.drawRoundRect(
                0,
                0,
                cardW,
                cardH,
                9,
                9
            );
            graphics.lineStyle();

            // Rarity header.
            graphics.beginFill(frame);
            graphics.drawRoundRect(
                5,
                4,
                cardW - 10,
                15,
                5,
                5
            );
            graphics.endFill();

            // Reusable chibi portrait.
            if (!portrait) {
                portrait = new CharacterPortrait(
                    data,
                    42,
                    35,
                    true
                );
                portrait.x = 7;
                portrait.y = 21;
                addChildAt(portrait, 0);
            }

            // Grade stripe.
            graphics.beginFill(
                frame
            );
            graphics.drawRoundRect(
                5,
                cardH - 19,
                cardW - 10,
                15,
                5,
                5
            );
            graphics.endFill();

            clearTextChildren();

            addLabel(
                grade,
                8,
                4,
                cardW - 16,
                14,
                8,
                0xffffff,
                TextFormatAlign.CENTER
            );

            addLabel(
                String(data.name),
                53,
                22,
                45,
                14,
                8,
                0x18293a,
                TextFormatAlign.LEFT
            );

            addLabel(
                String(data.pos),
                53,
                36,
                18,
                13,
                8,
                frame,
                TextFormatAlign.LEFT
            );

            addLabel(
                "LV " + data.level,
                70,
                36,
                28,
                13,
                8,
                0x30465b,
                TextFormatAlign.RIGHT
            );

            addLabel(
                "OVR " + data.rating,
                53,
                49,
                45,
                13,
                9,
                0x18293a,
                TextFormatAlign.LEFT
            );

            addLabel(
                rarityStars(grade),
                8,
                cardH - 19,
                cardW - 16,
                14,
                9,
                0xffffff,
                TextFormatAlign.CENTER
            );

            filters = [
                new DropShadowFilter(
                    2,
                    45,
                    0x000000,
                    0.35,
                    3,
                    3,
                    1
                ),
                new GlowFilter(
                    frame,
                    selected ? 0.65 : 0.18,
                    selected ? 6 : 3,
                    selected ? 6 : 3,
                    1.2,
                    1
                )
            ];
        }

        private function rarityFrameColor(
            grade:String,
            fallback:uint
        ):uint {
            if (grade == "HERO") {
                return 0xe0b43b;
            }

            if (grade == "ELITE") {
                return 0xc45a91;
            }

            if (grade == "RARE") {
                return 0x4f86bf;
            }

            if (grade == "PITCHER") {
                return 0x8455a6;
            }

            return fallback;
        }

        private function rarityInnerColor(
            grade:String
        ):uint {
            if (grade == "HERO") {
                return 0xfff6d9;
            }

            if (grade == "ELITE") {
                return 0xf5e5ef;
            }

            if (grade == "RARE") {
                return 0xe7f0f8;
            }

            if (grade == "PITCHER") {
                return 0xeee6f4;
            }

            return 0xe9eef1;
        }

        private function rarityStars(
            grade:String
        ):String {
            if (grade == "HERO") {
                return "★★★★";
            }

            if (grade == "ELITE") {
                return "★★★";
            }

            if (
                grade == "RARE" ||
                grade == "PITCHER"
            ) {
                return "★★";
            }

            return "★";
        }

        private function clearTextChildren():void {
            var i:int = numChildren - 1;

            while (i >= 0) {
                if (getChildAt(i) is TextField) {
                    removeChildAt(i);
                }
                i--;
            }
        }

        private function addLabel(
            text:String,
            x:Number,
            y:Number,
            w:Number,
            h:Number,
            size:int,
            color:uint,
            align:String
        ):void {
            var t:TextField = new TextField();
            var f:TextFormat = new TextFormat("Arial", size, color, true);
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
        }
    }
}
