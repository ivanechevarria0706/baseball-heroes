package com.bh.visual {
 import flash.display.*;import flash.utils.ByteArray;import com.bh.model.*;
 /** Use the real MLB portrait for a roster player, or the exact saved custom hero. */
 public class MatchActorHead extends Sprite {
  [Embed(source="C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v1039/player-materials.json",mimeType="application/octet-stream")] private static const Materials:Class;
  private static var materials:Object;private var costume:CostumeArtwork,mlb:MLBPlayerArtwork,hero:HeroHead,rear:RearHeroArtwork;
  private var angle:Number=0,expression:int=0,blink:Boolean=false,palette:Object,helmet:Boolean,phase:int=0;
  public static function paletteFor(data:Object,accent:uint,gear:Object=null):Object{
   var p:Object=HomeSprite.paletteFor(data&&data.name?String(data.name):"Pitcher",accent,data?data.appearance:null,gear||{});
   if(data&&!(data.appearance&&int(data.appearance.artVersion)>=1)){
    var identity:Object=int(data.mlbId)>0?data:MLB2026Catalog.named(String(data.name));
    if(identity){if(!materials){var bytes:ByteArray=new Materials() as ByteArray;materials=JSON.parse(bytes.readUTFBytes(bytes.length));}if(materials[String(identity.mlbId)]!==undefined)p.skin=uint(materials[String(identity.mlbId)]);}
   }return p;
  }
  public function MatchActorHead(data:Object,palette:Object,helmet:Boolean=true){
   this.palette=palette;this.helmet=helmet;phase=Math.abs(VisualProfile.seed(data&&data.name?String(data.name):"Player"))%4300;
   mouseEnabled=mouseChildren=false;var identity:Object=data;
   if(data&&data.appearance&&int(data.appearance.artVersion)>=1)identity=null;
   if(identity&&MLBPlayerArtwork.indexFor(identity)<0&&identity.name)identity=MLB2026Catalog.named(String(identity.name));
   if(MLBPlayerArtwork.indexFor(identity)>=0){mlb=new MLBPlayerArtwork(identity,156,156,true,0,true);mlb.x=-78;mlb.y=-156;addChild(mlb);}
   else {var a:Object=data&&data.appearance?data.appearance:{artVersion:1,avatarStyle:Math.abs(VisualProfile.seed(data&&data.name?String(data.name):"Pitcher"))%8,gender:"M",skinColor:0,hairColor:0,eyeColor:0};hero=new HeroHead(a,palette,"",helmet);addChild(hero);costume=new CostumeArtwork(palette);costume.attach(hero);}
  }
  public function setFacing(value:Number):void {angle=value;if(hero)hero.setFacing(value);if(costume)costume.setRear(value>90);if(mlb){var back:Boolean=helmet&&value>105;mlb.visible=!back;if(back){if(!rear){rear=new RearHeroArtwork(palette);addChild(rear);}rear.visible=true;rear.setFacing(value);}else if(rear)rear.visible=false;mlb.setMatchPose(Math.min(75,value),expression,blink);}}
  public function setExpression(value:int):void {expression=value;if(hero)hero.setExpression(value);if(mlb)mlb.setMatchPose(Math.min(75,angle),expression,blink);}
  public function advance(now:int):void {var next:Boolean=(now+phase)%5100<110;if(next==blink)return;blink=next;if(mlb&&mlb.visible)mlb.setMatchPose(Math.min(75,angle),expression,blink);}
  public function dispose():void {if(costume)costume.dispose();if(mlb)mlb.dispose();if(hero)hero.dispose();if(rear)rear.dispose();}
 }
}
