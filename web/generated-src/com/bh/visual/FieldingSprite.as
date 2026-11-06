package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.getTimer;import com.bh.model.MatchRosterIdentity;
 /** Sixteen fielding poses use the same illustrated material and fixed body scale. */
 public class FieldingSprite extends Sprite {
  private var closeup:Boolean=false,headWindow:Shape;
  private var body:MatchBodyArtwork,head:MatchActorHead,index:int=-1,dead:Boolean=false;
  public function FieldingSprite(color:uint,playerName:String="Defender",identity:Object=null,closeup:Boolean=false){this.closeup=closeup;
   mouseEnabled=mouseChildren=false;identity=MatchRosterIdentity.resolve(identity||{name:playerName},"SS");var p:Object=MatchActorHead.paletteFor(identity,color,{});p.uniform=p.helmet=color;
   body=new MatchBodyArtwork("fielding",p,95);addChild(body);head=new MatchActorHead(identity,p,false);head.scaleX=head.scaleY=.52;addChild(head);if(closeup){headWindow=new Shape();var g:Graphics=headWindow.graphics;g.beginFill(0xffffff);g.moveTo(-84,-164);g.lineTo(84,-164);g.lineTo(84,-40);g.curveTo(66,-21,36,-14);g.curveTo(20,-5,0,-5);g.curveTo(-20,-5,-36,-14);g.curveTo(-66,-21,-84,-40);g.endFill();addChild(headWindow);head.mask=headWindow;}setFrame(0);
  }
  public function get frameIndex():int{return index;}
  public function warmAll():void{var saved:int=index;body.warmDeferred();setFrame(saved);}
  public function setFrame(n:int):void{if(dead)return;head.advance(getTimer());n=Math.max(0,Math.min(body.frameCount-1,n));if(n==index)return;index=n;body.setFrame(n);var mount:Point=body.anchor();head.x=mount.x;head.y=mount.y+1;head.rotation=n==2?14:n==6?-8:n==7?18:n==21?8:0;head.setFacing(n>=16?body.facing:n==5?20:n==6?35:n==7?45:n==12?20:n==13?30:0);head.setExpression(n==11?3:n==2||n==3||n>=17&&n<=22?2:0);if(headWindow)headWindow.transform.matrix=head.transform.matrix;}
  public function anchor(throwingHand:Boolean=false,frame:int=-1):Point{return body.anchor(throwingHand?"hand":"glove",frame);}
  public function dispose():void{if(dead)return;dead=true;head.mask=null;if(headWindow)headWindow.graphics.clear();body.dispose();head.dispose();}
 }
}
