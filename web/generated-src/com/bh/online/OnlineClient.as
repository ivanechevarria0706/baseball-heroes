package com.bh.online {
    import flash.external.ExternalInterface;
    import flash.utils.*;
    public class OnlineClient {
        public var baseURL:String;
        public var token:String = "";
        public var user:Object;
        private var pending:String = "";
        private var done:Function, failed:Function;
        private var timeout:uint;
        private static var clients:Object = {};
        private static var installed:Boolean;
        public function OnlineClient(restore:Boolean=true) {
            var session:Object = JSON.parse(ExternalInterface.call("BHWeb.session"));
            baseURL = session.url;
            if (restore) { user = session.user; token = user ? "browser-session" : ""; }
            if (!installed) { ExternalInterface.addCallback("bhResponse", response); installed=true; }
        }
        public static function validURL(url:String):Boolean { return url == ExternalInterface.call("BHWeb.origin"); }
        public function setServer(url:String):void { if (!validURL(url)) throw new Error("This page uses your group's private server."); }
        public static function requestId():String { return ExternalInterface.call("BHWeb.requestId"); }
        public function remember(result:Object):void { user=result.user; token="browser-session"; }
        public function forget():void { token="";user=null;ExternalInterface.call("BHWeb.expired"); }
        public function get busy():Boolean { return pending.length>0; }
        public function request(method:String,path:String,body:Object,onDone:Function,onError:Function):void {
            if (busy) { onError("An operation is already in progress.",0); return; }
            pending=requestId();done=onDone;failed=onError;clients[pending]=this;
            timeout=setTimeout(function():void { finish(false,"{\"error\":\"The server took too long. Retry the same action.\"}",0); },40000);
            ExternalInterface.call("BHWeb.request",pending,method,path,JSON.stringify(body));
        }
        private static function response(id:String,success:Boolean,text:String,status:int):void {
            var client:OnlineClient=clients[id];if(client)client.finish(success,text,status);
        }
        private function finish(success:Boolean,text:String,status:int):void {
            var ok:Function=done,bad:Function=failed;dispose();var result:Object;
            try { result=JSON.parse(text); } catch(e:Error) { result={error:"Invalid response."};success=false; }
            if(success)ok(result);else bad(result.error||"Could not connect.",status);
        }
        public function dispose():void { clearTimeout(timeout);delete clients[pending];pending="";done=null;failed=null; }
    }
}
