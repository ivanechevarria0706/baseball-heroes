package com.bh.visual {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class TeamLogoView extends Sprite {
        private var image:AssetImage;

        public function TeamLogoView(
            city:String,
            fallbackColor:uint,
            fallbackLetter:String,
            size:Number
        ) {
            super();

            mouseEnabled = false;
            mouseChildren = false;

            var path:String =
                VisualAssetRegistry.teamLogoPath(
                    city
                );

            if (
                path &&
                path.length > 0
            ) {
                // A tiny neutral plate keeps detailed transparent logos readable
                // without the old generic colored-circle look.
                graphics.beginFill(
                    0xffffff,
                    0.16
                );
                graphics.drawCircle(
                    size / 2,
                    size / 2,
                    size * 0.43
                );
                graphics.endFill();

                image = new AssetImage(
                    path,
                    size,
                    size,
                    AssetImage.CONTAIN
                );
                addChild(image);
                return;
            }

            // Fallback for custom cities that do not exist in the supplied
            // historical logo sheet.
            graphics.beginFill(
                0x000000,
                0.18
            );
            graphics.drawCircle(
                size / 2 + 3,
                size / 2 + 4,
                size * 0.45
            );
            graphics.endFill();

            graphics.beginFill(
                fallbackColor
            );
            graphics.drawCircle(
                size / 2,
                size / 2,
                size * 0.43
            );
            graphics.endFill();

            graphics.beginFill(
                0xffffff,
                0.94
            );
            graphics.drawCircle(
                size / 2,
                size / 2,
                size * 0.28
            );
            graphics.endFill();

            var label:TextField =
                new TextField();

            var format:TextFormat =
                new TextFormat(
                    "Arial",
                    Math.max(
                        12,
                        int(size * 0.30)
                    ),
                    fallbackColor,
                    true
                );

            format.align =
                TextFormatAlign.CENTER;
            label.defaultTextFormat =
                format;
            label.text = fallbackLetter;
            label.width = size;
            label.height = size * 0.44;
            label.y = size * 0.28;
            label.selectable = false;
            label.mouseEnabled = false;
            addChild(label);
        }

        public function dispose():void {
            if (image) {
                image.dispose();
                image = null;
            }
        }
    }
}
