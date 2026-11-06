package com.bh.visual {
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import com.bh.platform.File;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;

    public class AssetImage extends Sprite {
        public static const CONTAIN:String = "contain";
        public static const COVER:String = "cover";
        public static const STRETCH:String = "stretch";

        private var loader:Loader;
        private var targetW:Number;
        private var targetH:Number;
        private var mode:String;
        private var relativePath:String;

        public function AssetImage(
            path:String,
            w:Number,
            h:Number,
            fitMode:String = "contain"
        ) {
            super();

            relativePath = path;
            name = "asset:" + path;
            targetW = w;
            targetH = h;
            mode = fitMode;

            mouseEnabled = false;
            mouseChildren = false;

            if (
                mode == COVER ||
                mode == STRETCH
            ) {
                scrollRect = new Rectangle(
                    0,
                    0,
                    targetW,
                    targetH
                );
            }

            loadAsset();
        }

        private function loadAsset():void {
            if (!relativePath || relativePath.length == 0) {
                return;
            }

            try {
                var file:File =
                    File.applicationDirectory.resolvePath(
                        relativePath
                    );

                loader = new Loader();
                loader.contentLoaderInfo.addEventListener(
                    Event.COMPLETE,
                    onLoaded
                );
                loader.contentLoaderInfo.addEventListener(
                    IOErrorEvent.IO_ERROR,
                    onLoadError
                );
                addChild(loader);
                loader.load(
                    new URLRequest(
                        file.url
                    )
                );
            }
            catch (error:Error) {
                // Optional visual assets must never prevent the game from running.
            }
        }

        private function onLoaded(e:Event):void {
            if (!loader || !loader.content) {
                return;
            }

            if (loader.content is Bitmap) {
                Bitmap(loader.content).smoothing = true;
            }

            var sourceW:Number = loader.content.width;
            var sourceH:Number = loader.content.height;

            if (
                sourceW <= 0 ||
                sourceH <= 0
            ) {
                return;
            }

            if (mode == STRETCH) {
                loader.width = targetW;
                loader.height = targetH;
                loader.x = 0;
                loader.y = 0;
                dispatchEvent(new Event(Event.COMPLETE));
                return;
            }

            var scale:Number;

            if (mode == COVER) {
                scale = Math.max(
                    targetW / sourceW,
                    targetH / sourceH
                );
            }
            else {
                scale = Math.min(
                    targetW / sourceW,
                    targetH / sourceH
                );
            }

            loader.scaleX = scale;
            loader.scaleY = scale;
            loader.x =
                (targetW - sourceW * scale) /
                2;
            loader.y =
                (targetH - sourceH * scale) /
                2;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function onLoadError(
            e:IOErrorEvent
        ):void {
            // Keep the vector fallback already drawn by the parent UI.
        }

        public function dispose():void {
            if (!loader) return;

            loader.contentLoaderInfo.removeEventListener(
                Event.COMPLETE,
                onLoaded
            );
            loader.contentLoaderInfo.removeEventListener(
                IOErrorEvent.IO_ERROR,
                onLoadError
            );

            try {
                loader.close();
            }
            catch (error:Error) {
            }

            try {
                loader.unloadAndStop(true);
            }
            catch (error2:Error) {
            }

            loader = null;
        }
    }
}
