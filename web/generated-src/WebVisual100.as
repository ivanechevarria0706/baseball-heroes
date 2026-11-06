package {
 import flash.display.*;import flash.external.ExternalInterface;import com.bh.visual.*;import com.bh.ui.*;import com.bh.game.*;import com.bh.model.*;
 /** Isolated visual/timeline QA, excluded from the published allowlist. */
 public class WebVisual100 extends WebAppearance099 {
  private var layer:Sprite,actors:Array=[],scene:HitCinematic,mode:ModeSelectScreen,build:BuildScreen,derby:HomeRunDerbyScreen,now:Number=0;
  public function WebVisual100(){super();ExternalInterface.addCallback("bhVisual100",show);}
  private function clear():void {
   if(scene){scene.dispose();scene=null;}if(mode){mode.dispose();mode=null;}if(build){build.dispose();build=null;}if(derby){derby.dispose();derby=null;}
   for each(var actor:* in actors)actor.dispose();actors=[];if(layer){removeChild(layer);layer=null;}
  }
  private function show(action:String="state",value:String="",time:Number=0):String {
   if(action=="tick"){now=time;return JSON.stringify({playing:scene?scene.isPlaying():false,ready:scene?scene.canContinue():false});}
   if(action=="skip"){if(scene)scene.forceResultVisible();return "{}";}
   if(action=="catalog"){
    var items:Array=[],known:Object={};for each(var item:Object in StadiumCatalog.items()){if(known[item.id])throw new Error("Duplicate item");known[item.id]=true;if(item.city)items.push({id:item.id,city:item.city,path:VisualAssetRegistry.teamLogoPath(item.city)});}
    return JSON.stringify({mascots:items,hairColors:VisualProfile.palette("hair"),skinColors:VisualProfile.palette("skin"),frozenPalette:VisualProfile.palette("hair").slice(0,10)});
   }
   clear();if(action=="close")return "{}";layer=new Sprite();addChild(layer);
   if(action=="pitcher"){
    layer.graphics.beginFill(0xd3ebf5);layer.graphics.drawRect(0,0,960,720);layer.graphics.endFill();ClassicInventorySkin.text(layer,"PITCHER · 24 BODY POSES",18,5,920,29,23,0x173349);
    for(var i:int=0;i<24;i++){var a:PitcherBodySprite=new PitcherBodySprite(0x2b75b2);a.setFrame(i);a.scaleX=a.scaleY=.85;a.x=79+(i%6)*160;a.y=185+int(i/6)*171;layer.addChild(a);actors.push(a);ClassicInventorySkin.text(layer,String(i),i%6*160,186+int(i/6)*171,160,19,11,0x173349,"center");}
   }
   if(action=="cinematic"){now=0;scene=new HitCinematic(960,720,function():Number{return now;});layer.addChild(scene);scene.play(value,value=="HOME RUN"?1:0,value=="HOME RUN"?410:0);}
   if(action=="modes"){mode=new ModeSelectScreen(960,720,function():void{},function():void{},function():void{},function():void{},function():void{},function():void{});layer.addChild(mode);}
   if(action=="build"){build=new BuildScreen(960,720,function():void{},function():void{});layer.addChild(build);}
   if(action=="derby"){derby=new HomeRunDerbyScreen(960,720,function():void{});layer.addChild(derby);}
   return "{}";
  }
 }
}
