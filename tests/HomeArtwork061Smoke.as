package {
    import flash.display.*;import flash.events.*;import flash.geom.*;import flash.filesystem.*;import flash.text.*;import flash.utils.setTimeout;import flash.desktop.NativeApplication;
    import com.bh.game.HomeHero;import com.bh.visual.*;import com.bh.model.GameData;
    public class HomeArtwork061Smoke extends Sprite {
        private var time:int=0;
        public function HomeArtwork061Smoke(){stage.scaleMode='noScale';stage.align='TL';GameData.init();setTimeout(function():void{try{run();}catch(e:Error){finish('FAIL: '+e+'\n'+e.getStackTrace(),1);}},100);}
        private function check(ok:Boolean,message:String):void{if(!ok)throw new Error(message);}
        private function now():int{return time;}
        private function make(gear:Object=null):HomeHero{return new HomeHero(0,0,0x287fac,32,String(GameData.mainPlayer().name),now,gear);}
        private function pixels(a:DisplayObject):BitmapData{var b:BitmapData=new BitmapData(260,280,true,0);b.draw(a,new Matrix(a.scaleX,0,0,a.scaleY,110,255));return b;}
        private function equal(a:BitmapData,b:BitmapData):Boolean{var diff:Object=a.compare(b);if(diff is BitmapData){BitmapData(diff).dispose();return false;}return diff===0;}
        private function run():void {
            var sheet:BitmapData=new BitmapData(1040,560,false,0x183642),labels:Array=['READY','BLINK','GREETING','PLEASED'];
            for(var i:int=0;i<4;i++){
                time=0;var a:HomeHero=make();time=i==1?3950:i==2?900:0;if(i==3)a.celebrate();a.dispatchEvent(new Event(Event.ENTER_FRAME));check(a.frameIndex==i,'Wrong pose '+i);
                var p:BitmapData=pixels(a);sheet.copyPixels(p,p.rect,new Point(i*260,0));p.dispose();title(sheet,labels[i],i*260+8,8);a.dispose();a.dispose();
            }
            var slow:BitmapData=sample(1000/15),fast:BitmapData=sample(1000/60);check(equal(slow,fast),'Time-dependent blinking differs by fps');slow.dispose();fast.dispose();
            time=0;a=make();var base:BitmapData=pixels(a),gear:Object={},slots:Array=['bat','glove','belt','helmet','shoes','goggles'];
            for each(var slot:String in slots){
                for each(var s:String in slots)gear[s]=GameData.equipped[s];gear[slot]={accent:0xeade42,grade:'HERO'};
                var changed:HomeHero=make(gear),view:BitmapData=pixels(changed);check(!equal(base,view),'No visible change for '+slot);view.dispose();changed.dispose();
            }
            for(i=0;i<4;i++){
                var appearance:Object={skinColor:i,hairColor:i+5,eyeColor:i+2};
                var art:HomeSprite=new HomeSprite(HomeSprite.paletteFor('QA',i%2?0xb74047:0x248a79,appearance));art.scaleX=art.scaleY=.365;
                view=pixels(art);sheet.copyPixels(view,view.rect,new Point(i*260,280));view.dispose();title(sheet,'PALETTE '+(i+1),i*260+8,288);art.dispose();
            }
            var peer:HomeHero=make();a.dispose();for(i=0;i<7;i++){changed=new HomeHero(0,0,0x661100+i,32,'QA',now);changed.dispose();}
            var retained:BitmapData=pixels(peer);check(equal(base,retained),'Disposing another hero damaged shared texture');base.dispose();retained.dispose();peer.dispose();
            save(sheet,'v061-front-poses.png');sheet.dispose();
            var portraits:BitmapData=new BitmapData(720,200,false,0x183642);
            for(i=0;i<3;i++){var portrait:CharacterPortrait=new CharacterPortrait(GameData.mainPlayer(),[53,86,156][i],[61,78,156][i],true);portraits.draw(portrait,new Matrix(1,0,0,1,30+i*210,20));portrait.dispose();portrait.dispose();}
            save(portraits,'v061-portraits.png');portraits.dispose();
            finish('PASS: four frontal poses, consistent animation at 15/60 fps, six equipment categories each change visible pixels, appearance palette variants, shared texture survives disposal/cache eviction, three portrait sizes and repeated disposal.\n',0);
        }
        private function sample(step:Number):BitmapData{time=0;var a:HomeHero=make();for(var t:Number=step;t<3950;t+=step){time=int(t);a.dispatchEvent(new Event(Event.ENTER_FRAME));}time=3950;a.dispatchEvent(new Event(Event.ENTER_FRAME));var b:BitmapData=pixels(a);a.dispose();return b;}
        private function title(b:BitmapData,value:String,x:int,y:int):void{var f:TextField=new TextField();f.defaultTextFormat=new TextFormat('Arial',14,0xffffff,true);f.text=value;f.width=250;f.height=24;b.draw(f,new Matrix(1,0,0,1,x,y));}
        private function save(b:BitmapData,name:String):void{var file:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);file.parent.createDirectory();var s:FileStream=new FileStream();s.open(file,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();}
        private function finish(message:String,code:int):void{var file:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-home-artwork061.txt');var s:FileStream=new FileStream();s.open(file,FileMode.WRITE);s.writeUTFBytes(message);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
