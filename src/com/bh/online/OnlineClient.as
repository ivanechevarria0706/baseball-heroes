package com.bh.online {
    import flash.net.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.data.EncryptedLocalStore;
    import flash.crypto.generateRandomBytes;

    /** HTTPS for remote services; plain HTTP is restricted to loopback development. */
    public class OnlineClient {
        public var baseURL:String="https://baseball-heroes-api-production.up.railway.app";
        public var token:String="";
        public var user:Object;
        private var loader:URLLoader;
        private var timer:Timer;
        private var status:int;
        private var done:Function;
        private var failed:Function;
        public static const SESSION_KEY:String="bh.private.exhibition.session.v1";

        public function OnlineClient(restore:Boolean=true) {
            if(!restore)return;
            try {
                var bytes:ByteArray=EncryptedLocalStore.getItem(SESSION_KEY);
                if(bytes){var saved:Object=JSON.parse(bytes.readUTFBytes(bytes.length));
                    if(validURL(saved.url)){baseURL=saved.url;token=saved.token;user=saved.user;}}
            } catch(e:Error) {token="";user=null;}
        }
        public static function validURL(url:String):Boolean {
            return url!=null&&(/^https:\/\/[a-zA-Z0-9.-]+(?::[0-9]{1,5})?$/).test(url)||
                url!=null&&(/^http:\/\/(127\.0\.0\.1|localhost)(?::[0-9]{1,5})?$/).test(url);
        }
        public function setServer(url:String):void {
            url=url.replace(/\/+$/, "");
            if(!validURL(url))throw new Error("Use HTTPS, or http://127.0.0.1:8765 for a local test.");
            if(url!=baseURL){forget();baseURL=url;}
        }
        public static function requestId():String {
            var bytes:ByteArray=generateRandomBytes(18),out:String="";
            for(var i:int=0;i<bytes.length;i++)out+=("0"+bytes[i].toString(16)).substr(-2);
            return out;
        }
        public function remember(result:Object):void {
            token=String(result.token);user=result.user;
            try {var b:ByteArray=new ByteArray();b.writeUTFBytes(JSON.stringify({url:baseURL,token:token,user:user}));EncryptedLocalStore.setItem(SESSION_KEY,b);}
            catch(e:Error) {/* Login remains usable for this session if storage is unavailable. */}
        }
        public function forget():void {
            token="";user=null;
            try{EncryptedLocalStore.removeItem(SESSION_KEY);}catch(e:Error){}
        }
        public function get busy():Boolean {return loader!=null;}
        public function request(method:String,path:String,body:Object,onDone:Function,onError:Function):void {
            if(busy){onError("An operation is already in progress.",0);return;}
            if(!validURL(baseURL)||path.charAt(0)!="/"){onError("Invalid address.",0);return;}
            done=onDone;failed=onError;status=0;
            var req:URLRequest=new URLRequest(baseURL+path);req.method=method;req.contentType="application/json";
            req.followRedirects=false;req.authenticate=false;req.manageCookies=false;req.cacheResponse=false;req.useCache=false;
            if(token.length)req.requestHeaders=[new URLRequestHeader("Authorization","Bearer "+token)];
            if(body!=null)req.data=JSON.stringify(body);
            loader=new URLLoader();loader.dataFormat=URLLoaderDataFormat.TEXT;
            loader.addEventListener(Event.COMPLETE,complete);
            loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpStatus);
            loader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,ioError);
            timer=new Timer(12000,1);timer.addEventListener(TimerEvent.TIMER_COMPLETE,timeout);timer.start();
            try {loader.load(req);}catch(e:Error){reject("Could not connect to the server.",0);}
        }
        private function httpStatus(e:HTTPStatusEvent):void {status=e.status;}
        private function decode():Object {try{return JSON.parse(String(loader.data));}catch(e:Error){}return null;}
        private function complete(e:Event):void {
            var result:Object=decode();
            if(status>=200&&status<300&&!result){reject("Incomplete response. Retry the same action.",0);return;}
            if(status<200||status>=300||!result||result.error){reject(result&&result.error?String(result.error):"Invalid server response.",status);return;}
            var callback:Function=done;cleanup();callback(result);
        }
        private function ioError(e:Event):void {
            var result:Object=decode();reject(result&&result.error?String(result.error):status==401?"Sign in again.":status==409?"The challenge changed. Refresh or resume it.":"Could not connect. Check the server and try again.",status>=200&&status<300?0:status);
        }
        private function timeout(e:TimerEvent):void {reject("The server took too long. You can retry the same action.",0);}
        private function reject(message:String,code:int):void {var callback:Function=failed;cleanup();if(callback!=null)callback(message,code);}
        private function cleanup():void {
            if(timer){timer.stop();timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timeout);timer=null;}
            if(loader){loader.removeEventListener(Event.COMPLETE,complete);loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpStatus);loader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,ioError);try{loader.close();}catch(e:Error){}loader=null;}
            done=null;failed=null;
        }
        public function dispose():void {cleanup();}
    }
}
