package {
 import flash.display.*;import flash.text.*;import flash.external.ExternalInterface;import com.bh.visual.*;import com.bh.ui.ClassicInventorySkin;import com.bh.ui.CharacterMakerScreen;
 /** Isolated visual QA. This target is never included in the public package. */
 public class WebAppearance099 extends WebSmoke {
  private var gallery:Sprite,heads:Array=[],maker:CharacterMakerScreen;
  public function WebAppearance099(){super();ExternalInterface.addCallback("bhAppearance",show);}
  private function show(mode:String="front",color:int=5):String {
   for each(var old:HeroHead in heads)old.dispose();heads=[];
   if(gallery){removeChild(gallery);gallery=null;}
   if(maker){maker.dispose();removeChild(maker);maker=null;}
   if(mode=="close")return "{}";
   if(mode=="creator"){maker=new CharacterMakerScreen(960,720,function():void{show("close");},function():void{show("close");});addChild(maker);return "{}";}
   gallery=new Sprite();gallery.graphics.beginFill(0xd3ebf5);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();addChild(gallery);
   ClassicInventorySkin.text(gallery,"HEAD SHAPE × HAIR STYLE · "+mode.toUpperCase(),20,3,920,28,19,0x173349);
   var fits:Array=[];
   for(var shape:int=0;shape<8;shape++)for(var hair:int=0;hair<8;hair++){
    var a:Object={shape:shape,hair:hair,eyes:0,nose:0,mouth:3,etc:0,skinColor:0,hairColor:color,eyeColor:0};
    var p:Object={skin:VisualProfile.skin("QA",a),hair:VisualProfile.hair("QA",a),eye:VisualProfile.eyeColor("QA",a),helmet:0x246ba4,goggles:0};
    var head:HeroHead=new HeroHead(a,p);head.x=59+hair*120;head.y=105+shape*83;head.scaleX=head.scaleY=.47;
    if(mode=="side")head.setFacing(60);gallery.addChild(head);heads.push(head);
    ClassicInventorySkin.text(gallery,HeroHead.SHAPE_NAMES[shape]+" · "+(hair+1),hair*120,107+shape*83,120,17,10,0x173349,"center");
    var fit:Object=head.hairPlacement(mode=="side"?60:0),f:DisplayObjectContainer=head.getChildAt(0) as DisplayObjectContainer;
    for(var n:int=0;n<f.numChildren;n++)if(f.getChildAt(n) is Bitmap){
     var bitmap:Bitmap=Bitmap(f.getChildAt(n)),pixels:BitmapData=bitmap.bitmapData,opaque:int=0;
     for(var yy:int=0;yy<pixels.height;yy+=8)for(var xx:int=0;xx<pixels.width;xx+=8)if((pixels.getPixel32(xx,yy)>>>24)>128)opaque++;
     fit.opaqueSamples=opaque;
     fit.fringeCoversLeftEye=(pixels.getPixel32(int((-23-bitmap.x)/bitmap.scaleX),int((-10-bitmap.y)/bitmap.scaleY))>>>24)>128;
    }
    fits.push(fit);
   }
   return JSON.stringify({count:fits.length,fits:fits});
  }
 }
}
