package com.bh.visual {
 import flash.display.*;import flash.geom.*;import com.bh.model.*;
 /** The supplied ten-pose batter body, also used for MLB teammates in autoplay. */
 public class MatchBatterSprite extends Sprite {
  private var body:ReferenceBatterArtwork,head:MatchActorHead,clip:Shape=new Shape(),frame:int=-1,dead:Boolean=false;
  public function MatchBatterSprite(player:Object,accent:uint,city:String){
   mouseEnabled=mouseChildren=false;name="approved-match-batter";
   var p:Object=MatchActorHead.paletteFor(player,accent,player===GameData.mainPlayer()?GameData.equipped:{});p.uniform=p.helmet=accent;
   body=new ReferenceBatterArtwork(p,150,city,accent);addChild(body);
   head=new MatchActorHead(player,p,false);head.scaleX=head.scaleY=.78;addChild(head);
   clip.graphics.beginFill(0);clip.graphics.drawRect(-220,-100,440,140);clip.graphics.endFill();addChild(clip);head.mask=clip;
   addChild(body.helmetLayer);setFrame(0);
  }
  public function setFrame(n:int):void {
   if(dead||n==frame)return;frame=n;body.setFrame(n);var mount:Point=body.anchor();head.x=mount.x;head.y=mount.y+2;head.rotation=body.tilt;head.setFacing(30);
   clip.x=head.x;clip.y=head.y;clip.rotation=head.rotation;clip.scaleX=head.scaleX;clip.scaleY=head.scaleY;
  }
  public function contact():Point {return body.anchor("tip",6);}
  public function dispose():void {if(dead)return;dead=true;head.mask=null;head.dispose();body.dispose();}
 }
}
