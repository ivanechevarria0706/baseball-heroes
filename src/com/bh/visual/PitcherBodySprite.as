package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.getTimer;import com.bh.model.MatchRosterIdentity;
 /** Measured native poses keep release geometry independent of render cadence. */
 public class PitcherBodySprite extends Sprite {
  private var body:MatchBodyArtwork,head:MatchActorHead,index:int=-1,dead:Boolean=false;
  private static const POSES:Array=[0,1,2,3,4,5,5,6,7,8,8,9,9,10,10,11,12,12,13,13,14,14,15,15];
  public function PitcherBodySprite(color:uint,playerName:String="Pitcher",identity:Object=null){
   mouseEnabled=mouseChildren=false;identity=MatchRosterIdentity.resolve(identity||{name:playerName},"P");var p:Object=MatchActorHead.paletteFor(identity,color,{});p.uniform=p.helmet=color;
   body=new MatchBodyArtwork("pitcher",p,96);addChild(body);head=new MatchActorHead(identity,p,false);head.scaleX=head.scaleY=.52;addChild(head);setFrame(0);
  }
  public function get frameIndex():int{return index;}
  public function warmAll():void{var saved:int=index;body.warmDeferred();setFrame(saved);}
  public static function windupFrame(progress:Number):int{var p:Number=Math.max(0,Math.min(1,progress)),starts:Array=[0,.12,.24,.34,.43,.50,.56,.61,.66,.72,.77,.81,.85,.90,.95,1];for(var i:int=15;i>0;i--)if(p>=starts[i])return i;return 0;}
  public function setFrame(n:int):void{if(dead)return;head.advance(getTimer());n=Math.max(0,Math.min(23,n));if(n==index)return;index=n;body.setFrame(POSES[n]);var mount:Point=body.anchor();head.x=mount.x;head.y=mount.y+1;head.rotation=n>=16&&n<=19?8:0;head.setFacing(n>=16&&n<=19?30:n>=8&&n<=12?15:0);head.setExpression(n>=6&&n<=19?2:0);}
  public function releaseAnchor():Point{return body.anchor("hand",11);}
  public function dispose():void{if(dead)return;dead=true;body.dispose();head.dispose();}
 }
}
