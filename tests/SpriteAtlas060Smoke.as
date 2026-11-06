package {
    import flash.display.*;import flash.geom.*;import flash.filesystem.*;import flash.events.*;import flash.text.*;import flash.desktop.NativeApplication;import flash.utils.setTimeout;
    import com.bh.visual.*;import com.bh.model.GameData;
    public class SpriteAtlas060Smoke extends Sprite {
        public function SpriteAtlas060Smoke(){stage.scaleMode='noScale';stage.align='TL';loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{e.preventDefault();finish('FAIL: '+e.error,1);});GameData.init();setTimeout(function():void{try{run();}catch(error:Error){finish('FAIL: '+error+'\n'+error.getStackTrace(),1);}},100);}
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function run():void {
            var palette:Object={uniform:0xcc3344,helmet:0x155899,bat:0xc49a58,skin:0xd79a61,shoe:0x263748};
            for each(var kind:String in ['batter','pitcher']) {
                var a:IllustratedSprite=new IllustratedSprite(kind,1,palette),sheet:BitmapData=new BitmapData(1600,1400,false,0x183641);a.warmAll();
                for(var i:int=0;i<16;i++) {
                    a.setFrame(i);var frame:Bitmap=Bitmap(a.getChildAt(0)),r:Rectangle=frame.bitmapData.getColorBoundsRect(0xe0000000,0,false);
                    check(r.width>60&&r.height>100,kind+' empty frame '+i);check(r.left>=1&&r.top>=1&&r.right<frame.bitmapData.width&&r.bottom<frame.bitmapData.height,kind+' visible crop touches edge '+i);
                    sheet.draw(a,new Matrix(1,0,0,1,i%4*400+155,int(i/4)*350+330));title(sheet,kind+' '+i,i%4*400+10,int(i/4)*350+5);
                }
                save(sheet,'v060-'+kind+'-frames.png');sheet.dispose();
                var peer:IllustratedSprite=new IllustratedSprite(kind,1,palette);peer.setFrame(6);var retained:BitmapData=Bitmap(peer.getChildAt(0)).bitmapData;a.dispose();a.dispose();
                // Force cache eviction while the peer still displays a shared texture.
                for(i=0;i<10;i++){var other:IllustratedSprite=new IllustratedSprite(kind,1,{uniform:0x114477+i,helmet:0x335588+i,bat:0xbb9933,skin:0xe0ad80,shoe:0x334455});other.dispose();}
                check(retained.getColorBoundsRect(0xff000000,0,false).height>100,'Live texture freed');peer.dispose();peer.dispose();
            }
            var cards:Array=GameData.specialCardCatalog(),mapped:int=0,used:Object={};sheet=new BitmapData(1120,680,false,0x193643);
            for each(var card:Object in cards) {
                var id:int=SpecialCardArtRegistry.frameFor(card.id);if(id<0){check(card.id=='card_lenard_j','Missing art '+card.id);continue;}
                check(!used[id],'Duplicate illustration');used[id]=true;
                var portrait:SpecialCardIllustration=new SpecialCardIllustration(card),thumb:BitmapData=new BitmapData(124,113,true,0);thumb.draw(portrait);
                check(thumb.getColorBoundsRect(0xff000000,0,false).height>70,'Empty portrait '+card.id);
                sheet.copyPixels(thumb,thumb.rect,new Point(mapped%8*140+8,int(mapped/8)*170+8));title(sheet,String(id+1)+'. '+card.name,mapped%8*140+4,int(mapped/8)*170+126,10);
                thumb.dispose();portrait.dispose();portrait.dispose();mapped++;
            }
            check(mapped==32,'Expected all 32 supplied characters');save(sheet,'v060-card-art.png');sheet.dispose();
            finish('PASS: all 16 batter and 16 pitcher frames retain transparent crop margins; 32 unique card mappings render; Lenard preserved; shared textures survive disposal and cache eviction while another actor uses them; repeated disposal safe.\n',0);
        }
        private function title(sheet:BitmapData,value:String,x:int,y:int,size:int=15):void{var t:TextField=new TextField();t.defaultTextFormat=new TextFormat('Arial',size,0xffffff,true);t.text=value;t.width=320;t.height=28;sheet.draw(t,new Matrix(1,0,0,1,x,y));}
        private function save(b:BitmapData,name:String):void{var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();}
        private function finish(value:String,code:int):void{var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-sprite-atlas.txt');f.parent.createDirectory();var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(value);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
