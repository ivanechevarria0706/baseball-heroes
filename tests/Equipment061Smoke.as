package {
    import flash.display.*;import flash.events.*;import flash.filesystem.*;import flash.text.*;import flash.geom.*;import flash.utils.setTimeout;import flash.desktop.NativeApplication;
    import com.bh.model.GameData;import com.bh.ui.EquipmentScreen;import com.bh.game.HomeHero;
    public class Equipment061Smoke extends Sprite {
        private var screen:EquipmentScreen,original:String;
        private var slots:Array=['bat','glove','belt','helmet','shoes','goggles'];
        public function Equipment061Smoke(){stage.scaleMode='noScale';stage.align='TL';GameData.init();setTimeout(function():void{try{run();}catch(e:Error){finish('FAIL: '+e+'\n'+e.getStackTrace(),1);}},100);}
        private function check(v:Boolean,m:String):void{if(!v)throw new Error(m);}
        private function named(c:DisplayObjectContainer,id:String):DisplayObject{for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);if(d.name==id)return d;if(d is DisplayObjectContainer){var f:DisplayObject=named(d as DisplayObjectContainer,id);if(f)return f;}}return null;}
        private function click(id:String):void{var d:DisplayObject=named(screen,id);check(d!=null,'Missing '+id);d.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true));}
        private function text(id:String):String{return TextField(named(screen,id)).text;}
        private function open():void{if(screen){screen.dispose();screen.dispose();removeChild(screen);}screen=new EquipmentScreen(960,720,function():void{});addChild(screen);}
        private function run():void{
            var defaults:Array=['Rookie Bat','Field Glove','Rookie Belt','Rookie Helmet','Speed Cleats','Rookie Goggles'];
            for(var i:int=0;i<slots.length;i++){
                for each(var item:Object in GameData.inventory)if(item.name==defaults[i])GameData.equipped[slots[i]]=item;
                var found:Boolean=false;for each(item in GameData.inventory)if(item.name=='QA '+slots[i])found=true;
                if(!found)GameData.inventory.push(GameData.equipment('QA '+slots[i],slots[i],'HERO',0xd49b25+i*0x04070a,2,3,1,1));
            }
            GameData.save();original=JSON.stringify(GameData.equipped);var coins:int=GameData.coins;open();shot('v061-equipment-equipped.png');
            for each(var slot:String in slots){click(slot);click('equipment-item-QA '+slot);check(text('equipment-preview-status').indexOf('TRY ON')==0,'Preview label missing '+slot);check(JSON.stringify(GameData.equipped)==original,'Preview equipped '+slot);check(GameData.coins==coins,'Preview spent coins');}
            shot('v061-equipment-try-on.png');open();GameData.load();check(JSON.stringify(GameData.equipped)==original,'Closing preview changed saved equipment');
            check(text('equipment-preview-status')=='EQUIPPED LOOK','Return retains pending preview');
            for each(slot in slots){
                click(slot);click('equipment-item-QA '+slot);click('EQUIP_ITEM');check(GameData.equipped[slot].name=='QA '+slot,'Equip failed '+slot);
                check(text('equipment-preview-status')=='EQUIPPED LOOK','Applied label wrong');check(!Sprite(named(screen,'EQUIP_ITEM')).mouseEnabled,'Already equipped remains actionable');
                var snapshot:String=JSON.stringify(GameData.equipped);click('EQUIP_ITEM');check(JSON.stringify(GameData.equipped)==snapshot,'Repeated equip changed data');
            }
            var expected:String=JSON.stringify(GameData.equipped);GameData.load();check(JSON.stringify(GameData.equipped)==expected,'Applied equipment did not persist');check(GameData.coins==coins,'Equipping spent coins');
            var contact:int=GameData.mainPlayer().contact;GameData.mainPlayer().contact=99;open();click('helmet');click('equipment-item-Rookie Helmet');check(text('equipment-preview-delta').indexOf('CON +0')>=0,'Preview ignored the 99 cap');GameData.mainPlayer().contact=contact;
            open();shot('v061-equipment-all-applied.png');
            var hero:DisplayObject=named(screen,'home-hero'),bounds:Rectangle=hero.getBounds(screen);check(bounds.left>437&&bounds.right<666&&bounds.top>210&&bounds.bottom<470,'Preview escapes panel '+bounds);
            screen.dispose();removeChild(screen);
            finish('PASS: all six categories preview without changing equipment, save or coins; closing discards preview; EQUIP applies each category and reload preserves all six; repeated equip is disabled and harmless; preview bounds fit 4:3 panel; reopening selects equipped item; predicted stat change respects the 99 cap.\n',0);
        }
        private function shot(name:String):void{var b:BitmapData=new BitmapData(960,720,false,0x183642);b.draw(screen);var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/'+name);var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeBytes(b.encode(b.rect,new PNGEncoderOptions()));s.close();b.dispose();}
        private function finish(message:String,code:int):void{var f:File=new File(File.applicationDirectory.nativePath).resolvePath('qa/smoke-equipment061.txt');var s:FileStream=new FileStream();s.open(f,FileMode.WRITE);s.writeUTFBytes(message);s.close();NativeApplication.nativeApplication.exit(code);}
    }
}
