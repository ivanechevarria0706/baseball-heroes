package com.bh.platform {
    import flash.external.ExternalInterface;
    public class WebSave {
        public var data:Object = {};
        private var primary:Boolean;
        private static var saves:Object = {};
        public static function getLocal(name:String):WebSave {
            if (!saves[name]) {
                var value:WebSave = new WebSave();
                value.primary = name.indexOf("_before_") < 0;
                if (value.primary) {
                    var text:String = ExternalInterface.call("BHWeb.initialSave");
                    if (text && text != "null") value.data = JSON.parse(text);
                }
                saves[name] = value;
            }
            return saves[name];
        }
        public function flush():String {
            if (primary) ExternalInterface.call("BHWeb.save", JSON.stringify(data));
            return "flushed";
        }
        public function clear():void { data = {}; }
    }
}
