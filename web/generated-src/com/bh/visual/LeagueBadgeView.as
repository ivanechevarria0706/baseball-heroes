package com.bh.visual {
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import com.bh.platform.File;

    public class LeagueBadgeView extends Sprite {
        private var image:AssetImage;

        public function LeagueBadgeView(
            leagueIndex:int,
            fallbackLabel:String,
            size:Number
        ) {
            super();

            mouseEnabled = false;
            mouseChildren = false;

            var path:String = VisualAssetRegistry.leagueBadgePath(leagueIndex);
            if (File.applicationDirectory.resolvePath(path).exists) {
                image = new AssetImage(path, size, size, AssetImage.CONTAIN);
                addChild(image);
                return;
            }

            graphics.beginFill(0xf7f0dc);
            graphics.drawCircle(
                size / 2,
                size / 2,
                size * 0.46
            );
            graphics.endFill();
            graphics.lineStyle(
                2,
                0x2f6f9d
            );
            graphics.drawCircle(
                size / 2,
                size / 2,
                size * 0.46
            );
            graphics.lineStyle();

            var field:TextField =
                new TextField();
            var format:TextFormat =
                new TextFormat(
                    "Arial",
                    Math.max(
                        9,
                        int(size * 0.20)
                    ),
                    0xd65433,
                    true
                );
            format.align =
                TextFormatAlign.CENTER;
            field.defaultTextFormat =
                format;
            field.text = fallbackLabel;
            field.width = size;
            field.height = size * 0.35;
            field.y = size * 0.36;
            field.selectable = false;
            field.mouseEnabled = false;
            addChild(field);

            image = new AssetImage(
                VisualAssetRegistry.leagueBadgePath(
                    leagueIndex
                ),
                size,
                size,
                AssetImage.CONTAIN
            );
            addChild(image);
        }

        public function dispose():void {
            if (image) {
                image.dispose();
                image = null;
            }
        }
    }
}
