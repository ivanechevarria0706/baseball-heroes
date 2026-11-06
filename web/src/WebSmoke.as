package {
    import flash.display.*;
    import flash.events.*;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.getQualifiedClassName;
    import com.bh.model.GameData;
    import com.bh.audio.AudioManager;
    public class WebSmoke extends WebMain {
        public function WebSmoke() {
            super();
            ExternalInterface.addCallback("bhInspect",inspect);
            ExternalInterface.addCallback("bhClick",click);
            ExternalInterface.addCallback("bhQA",qa);
        }
        private function inspect():String {
            var rows:Array=[];walk(this,rows,true);return JSON.stringify(rows);
        }
        private function walk(c:DisplayObjectContainer,rows:Array,parentVisible:Boolean):void {
            for(var i:int=0;i<c.numChildren;i++) {
                var d:DisplayObject=c.getChildAt(i),visible:Boolean=parentVisible&&d.visible&&d.alpha>0;
                if(!visible)continue;
                var r:Rectangle=d.getBounds(stage),type:String=getQualifiedClassName(d);
                if(d.name.indexOf("instance")!=0 || type.indexOf("com.bh")>=0 || d is TextField)
                    rows.push({name:d.name,type:type,x:r.x,y:r.y,w:r.width,h:r.height,alpha:d.alpha,text:d is TextField?TextField(d).text:"",owner:c.name,textHeight:d is TextField?TextField(d).textHeight:0,fieldHeight:d is TextField?TextField(d).height:0,textWidth:d is TextField?TextField(d).textWidth:0,fieldWidth:d is TextField?TextField(d).width:0});
                if(d is DisplayObjectContainer)walk(d as DisplayObjectContainer,rows,visible);
            }
        }
        private function find(c:DisplayObjectContainer,name:String):DisplayObject {
            for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==name)return d;
                if(d is DisplayObjectContainer){var f:DisplayObject=find(d as DisplayObjectContainer,name);if(f)return f;}}
            return null;
        }
        private function click(name:String):Boolean {var d:DisplayObject=find(this,name);if(!d)return false;d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));return true;}
        private function qa(action:String):String {
            if(action=="back")stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,27));
            if(action=="home"){GameData.onboardingStep=GameData.ONBOARDING_COMPLETE;GameData.seasonGoalSet=true;GameData.energy=GameData.maxEnergy;GameData.save();stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,true,false,0,27));}
            if(action=="save")GameData.save();
            if(action=="audio"){AudioManager.playSfx("user_strike.mp3");}
            return JSON.stringify({team:GameData.teamName,coins:GameData.coins,onboarding:GameData.onboardingStep,order:GameData.battingOrder});
        }
    }
}
