package {
 import flash.display.*;import flash.text.*;import flash.external.ExternalInterface;import com.bh.visual.*;import com.bh.ui.ClassicInventorySkin;
 /** Isolated visual QA. This target is never included in the public package. */
 public class WebAppearance098 extends WebSmoke {
  private var gallery:Sprite,heads:Array=[];
  public function WebAppearance098(){super();ExternalInterface.addCallback("bhAppearance",show);}
  private function show(mode:String="front",color:int=5):String {
   for each(var old:HeroHead in heads)old.dispose();heads=[];
   if(gallery){removeChild(gallery);gallery=null;}
   if(mode=="close")return "{}";
   gallery=new Sprite();gallery.graphics.beginFill(0xd3ebf5);gallery.graphics.drawRect(0,0,960,720);gallery.graphics.endFill();addChild(gallery);
   ClassicInventorySkin.text(gallery,"HEAD SHAPE × HAIR STYLE · "+mode.toUpperCase(),20,3,920,28,19,0x173349);
   var fits:Array=[];
   for(var shape:int=0;shape<8;shape++)for(var hair:int=0;hair<8;hair++){
    var a:Object={shape:shape,hair:hair,eyes:0,nose:0,mouth:3,etc:0,skinColor:0,hairColor:color,eyeColor:0};
    var p:Object={skin:VisualProfile.skin("QA",a),hair:VisualProfile.hair("QA",a),eye:VisualProfile.eyeColor("QA",a),helmet:0x246ba4,goggles:0};
    var head:HeroHead=new HeroHead(a,p);head.x=59+hair*120;head.y=105+shape*83;head.scaleX=head.scaleY=.47;
    if(mode=="side")head.setFacing(60);gallery.addChild(head);heads.push(head);
    ClassicInventorySkin.text(gallery,HeroHead.SHAPE_NAMES[shape]+" · "+(hair+1),hair*120,107+shape*83,120,17,10,0x173349,"center");
    fits.push(head.hairPlacement(mode=="side"?60:0));
   }
   return JSON.stringify({count:fits.length,fits:fits});
  }
 }
}
