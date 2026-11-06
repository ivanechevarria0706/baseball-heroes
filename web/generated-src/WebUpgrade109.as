package {
    import flash.display.*;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import flash.utils.getTimer;
    import com.bh.core.Game;
    import com.bh.ui.MatchSocialBar;
    public class WebUpgrade109 extends WebUpgrade108 {
        private var samples:Array=[],last:int=0,start:int=0;
        public function WebUpgrade109(){super();ExternalInterface.addCallback("bh109",run109);last=start=getTimer();addEventListener(Event.ENTER_FRAME,tick109);}
        private function tick109(e:Event):void {var now:int=getTimer();if(samples.length<1800)samples.push(now-last);last=now;}
        private function locate(c:DisplayObjectContainer,kind:String):DisplayObject {
            for(var i:int=0;i<c.numChildren;i++){
                var d:DisplayObject=c.getChildAt(i);if(kind=="game"&&d is Game||kind=="bar"&&d is MatchSocialBar)return d;
                if(d is DisplayObjectContainer){var found:DisplayObject=locate(d as DisplayObjectContainer,kind);if(found)return found;}
            }return null;
        }
        private function bounds(d:DisplayObject):Object {if(!d)return null;var r:Rectangle=d.getBounds(stage);return {x:r.x,y:r.y,w:r.width,h:r.height};}
        private function run109(action:String="state"):String {
            if(action=="reset"){samples=[];last=start=getTimer();}
            var game:Game=locate(this,"game") as Game,bar:MatchSocialBar=locate(this,"bar") as MatchSocialBar;
            var sorted:Array=samples.concat();sorted.sort(Array.NUMERIC);var slow:int=0;for each(var t:int in sorted)if(t>50)slow++;
            return JSON.stringify({game:game?game.qaSocial109():null,bar:bounds(bar),barY:bar?bar.y:null,fps:stage.frameRate,performance:{frames:samples.length,elapsed:getTimer()-start,p95:sorted.length?sorted[int(sorted.length*.95)]:0,max:sorted.length?sorted[sorted.length-1]:0,over50:slow}});
        }
    }
}
