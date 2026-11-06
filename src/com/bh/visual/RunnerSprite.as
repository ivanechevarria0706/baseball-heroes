package com.bh.visual {
 import flash.display.*;import flash.geom.*;import flash.utils.getTimer;import com.bh.model.GameData;
 /** Fixed-scale running and sliding poses share each player's saved illustrated identity. */
 public class RunnerSprite extends Sprite {
  private var body:MatchBodyArtwork,head:MatchActorHead,index:int=-1,dead:Boolean=false,headBaseY:Number=0;
  private var motion:Sprite=new Sprite(),dust:Array=[],ground:Shape=new Shape();
  public function RunnerSprite(player:Object,initialFrame:int=0){
   mouseEnabled=mouseChildren=false;var p:Object=MatchActorHead.paletteFor(player,uint(player.accent),player===GameData.mainPlayer()?GameData.equipped:{});
   ground.graphics.beginFill(0x102a22,.18);ground.graphics.drawEllipse(-42,-5,84,12);ground.graphics.endFill();addChild(ground);addChild(motion);
   body=new MatchBodyArtwork("runner",p,140);motion.addChild(body);head=new MatchActorHead(player,p);head.scaleX=head.scaleY=.78;motion.addChild(head);
   for(var i:int=0;i<7;i++){var puff:Shape=new Shape();puff.graphics.beginFill(0xe8cf9d,.55);puff.graphics.drawEllipse(-8,-4,16,8);puff.graphics.endFill();puff.visible=false;addChild(puff);dust.push(puff);}setFrame(initialFrame);
  }
  public function warmAll():void{var saved:int=index;body.warmAll();setFrame(saved);}
  public static function warmVictory(order:Array):void{if(!order||!order.length)return;for(var i:int=0;i<6;i++){var a:RunnerSprite=new RunnerSprite(order[(i+1)%order.length],i%2==0?11:10);a.dispose();}}
  public function get frameIndex():int{return index;}
  public function setFrame(n:int):void{if(dead)return;head.advance(getTimer());n=Math.max(0,Math.min(11,n));if(n==index)return;index=n;body.setFrame(n);body.y=0;var mount:Point=body.anchor();head.x=mount.x;head.y=headBaseY=mount.y+1;head.rotation=n==8?-22:0;head.setFacing(body.facing);head.setExpression(n>=10?3:0);}
  public function runAt(ms:Number):void{
   if(dead)return;ms=Math.max(0,ms);setFrame(int(ms/75)%6);var stride:Number=ms/225*Math.PI,bob:Number=-Math.abs(Math.sin(stride))*1.6;
   body.y=0;head.y=headBaseY;motion.y=bob;motion.rotation=1.2*Math.sin(stride);ground.scaleX=1+Math.abs(bob)*.025;
   for each(var puff:Shape in dust)puff.visible=false;
  }
  public function arrive(ms:Number,slide:Boolean=false):void{
   if(dead)return;ms=Math.max(0,ms);setFrame(slide?(ms<160?8:9):(ms<150?6:7));var settle:Number=Math.max(0,1-ms/320);
   body.y=0;head.y=headBaseY;motion.y=slide?0:Math.sin(ms/320*Math.PI)*2*settle;motion.rotation=slide?0:-2*settle;ground.scaleX=1;
   for(var i:int=0;i<dust.length;i++){var p:Number=(ms-i*24)/420,puff:Shape=dust[i];puff.visible=p>=0&&p<1;if(!puff.visible)continue;puff.x=-22-i*5-p*(20+i*4);puff.y=-2-Math.sin(p*Math.PI/2)*(7+i%3*4);puff.scaleX=1+p*1.5;puff.scaleY=.7+p;puff.alpha=(slide?.8:.45)*(1-p);}
  }
  public function cheer(front:Boolean=false):void{motion.y=motion.rotation=0;for each(var puff:Shape in dust)puff.visible=false;setFrame(front?11:10);}
  public function dispose():void{if(dead)return;dead=true;body.dispose();head.dispose();dust=[];}
 }
}
