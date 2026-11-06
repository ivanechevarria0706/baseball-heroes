package {
    import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.utils.getTimer;
    import com.bh.core.Game;import com.bh.game.Ball;
    public class WebPerformance extends WebHomeSmoke {
        private var samples:Array=[],start:int=0,last:int=0,automatic:Boolean=false,swung:Boolean=false,pitches:int=0;
        public function WebPerformance(){super();start=last=getTimer();addEventListener(Event.ENTER_FRAME,tick);
            ExternalInterface.addCallback('bhPerf',measure);
        }
        private function measure(action:String=''):String {
                if(action=='reset'){samples=[];start=last=getTimer();}
                if(action=='auto')automatic=true;
                var sorted:Array=samples.concat();sorted.sort(Array.NUMERIC);
                var g:Game=findType(this,Game) as Game,slow:int=0;for each(var d:int in sorted)if(d>50)slow++;
                return JSON.stringify({frames:samples.length,elapsed:getTimer()-start,fps:samples.length*1000/Math.max(1,getTimer()-start),
                    p95:sorted.length?sorted[int(sorted.length*.95)]:0,max:sorted.length?sorted[sorted.length-1]:0,over50:slow,
                    target:stage.frameRate,pitches:pitches,game:g?g.performanceState():null});
            return '';
        }
        private function findType(c:DisplayObjectContainer,t:Class):DisplayObject {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d is t)return d;if(d is DisplayObjectContainer){var f:DisplayObject=findType(d as DisplayObjectContainer,t);if(f)return f;}}return null;}
        private function key():void {stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,32));}
        private function tick(e:Event):void {
            var now:int=getTimer();if(samples.length<18000)samples.push(now-last);last=now;
            if(!automatic)return;var g:Game=findType(this,Game) as Game;if(!g)return;
            var state:Object=g.performanceState();
            if(state.phase=='READY'){swung=false;pitches++;key();}
            if(state.phase=='FLIGHT'&&!swung){var b:Ball=findType(g,Ball) as Ball;var progress:Number=Math.sqrt(Math.max(0,(b.scaleX-.27)/2.55));
                if(pitches%3==0?progress>=.905&&progress<=.95:progress<.25){swung=true;key();}}
        }
    }
}
