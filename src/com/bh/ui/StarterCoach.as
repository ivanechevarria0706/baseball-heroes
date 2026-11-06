package com.bh.ui {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.geom.Rectangle;
    import com.bh.visual.TrainingArtwork;
    /** A small coach bubble; its empty surroundings never intercept game controls. */
    public class StarterCoach extends Sprite {
        private var portrait:Bitmap;
        private var buttons:Array=[];
        public function StarterCoach(message:String,action:String="",callback:Function=null,skip:Function=null) {
            name="starter-coach";mouseEnabled=false;
            graphics.lineStyle(3,0x56baf0);graphics.beginFill(0xfffef5);graphics.drawRoundRect(0,0,360,132,12,12);graphics.endFill();graphics.lineStyle();
            graphics.beginFill(0xfffef5);graphics.moveTo(360,31);graphics.lineTo(379,48);graphics.lineTo(360,60);graphics.endFill();
            label("ENTRENADOR",12,8,330,20,14,0x1268a1);
            var text:TextField=label(message,12,31,335,68,14,0x243f50);text.multiline=text.wordWrap=true;HelpText.fit(text,14,12);
            portrait=TrainingArtwork.seasonCoach();portrait.scaleX=portrait.scaleY=Math.min(85/portrait.width,124/portrait.height);portrait.x=378;portrait.y=0;addChild(portrait);
            if(callback!=null)button(action,"tutorial-action",12,100,224,callback,0x64a92d);
            if(skip!=null)button("OMITIR","tutorial-skip",251,100,95,skip,0x47788e);
        }
        public function pointTo(target:Rectangle,bubbleX:Number=260,bubbleY:Number=420):void {
            var content:Sprite=new Sprite();content.mouseEnabled=false;
            while(numChildren)content.addChild(getChildAt(0));
            content.graphics.copyFrom(graphics);graphics.clear();
            graphics.beginFill(0x031626,.38);
            graphics.drawRect(0,75,960,Math.max(0,target.y-75));
            graphics.drawRect(0,target.y,Math.max(0,target.x),target.height);
            graphics.drawRect(target.right,target.y,Math.max(0,960-target.right),target.height);
            graphics.drawRect(0,target.bottom,960,Math.max(0,720-target.bottom));graphics.endFill();
            graphics.lineStyle(3,0xffdf49);graphics.drawRoundRect(target.x-3,target.y-3,target.width+6,target.height+6,7);graphics.lineStyle();
            var cx:Number=target.x+target.width/2,cy:Number=Math.max(87,target.y-5);
            graphics.lineStyle(3,0x183348);graphics.beginFill(0xffdb35);graphics.moveTo(cx-10,cy-40);graphics.lineTo(cx+10,cy-40);graphics.lineTo(cx+10,cy-18);graphics.lineTo(cx+24,cy-18);graphics.lineTo(cx,cy);graphics.lineTo(cx-24,cy-18);graphics.lineTo(cx-10,cy-18);graphics.lineTo(cx-10,cy-40);graphics.endFill();graphics.lineStyle();
            content.x=bubbleX;content.y=bubbleY;addChild(content);x=y=0;
        }
        private function label(value:String,x:Number,y:Number,w:Number,h:Number,size:int,color:uint):TextField {
            var t:TextField=new TextField();t.defaultTextFormat=new TextFormat("Arial",size,color,true);t.text=value;t.x=x;t.y=y;t.width=w;t.height=h;t.mouseEnabled=t.selectable=false;addChild(t);return t;
        }
        private function button(title:String,id:String,x:Number,y:Number,w:Number,callback:Function,color:uint):void {
            var b:UIButton=new UIButton(title,w,26,color,0x82bb5e,0xdcece6);b.x=x;b.y=y;b.name=id;
            var handler:Function=function(e:MouseEvent):void{e.stopImmediatePropagation();callback();};
            b.addEventListener(MouseEvent.CLICK,handler);addChild(b);buttons.push({view:b,handler:handler});
        }
        public function dispose():void {for each(var entry:Object in buttons){entry.view.removeEventListener(MouseEvent.CLICK,entry.handler);entry.view.dispose();}buttons=[];if(portrait){portrait.bitmapData.dispose();portrait=null;}}
    }
}
