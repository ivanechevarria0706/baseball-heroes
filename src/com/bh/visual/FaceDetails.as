package com.bh.visual {
    import flash.display.Sprite;
    /** Optional ETC overlays. Never changes the saved head geometry. */
    public class FaceDetails extends Sprite {
        public function FaceDetails(index:int){
            mouseEnabled=mouseChildren=false;var g:*=graphics;
            if(index==1){g.beginFill(0x9e5940,.7);for(var i:int=0;i<3;i++){g.drawCircle(-31+i*5,9+(i%2)*4,1.6);g.drawCircle(21+i*5,9+(i%2)*4,1.6);}g.endFill();}
            if(index==2){g.beginFill(0xec7984,.36);g.drawEllipse(-36,4,19,9);g.drawEllipse(17,4,19,9);g.endFill();}
            if(index==3){g.beginFill(0x30221c);g.moveTo(-11,30);g.lineTo(0,41);g.lineTo(11,30);g.endFill();}
            if(index==4||index==5){g.beginFill(0x30221c);g.drawEllipse(-19,15,20,6);g.drawEllipse(-1,15,20,6);g.endFill();if(index==5){g.beginFill(0x30221c);g.drawEllipse(-11,31,22,7);g.endFill();}}
            if(index==6){g.lineStyle(5,0x334a73,.85);g.moveTo(-37,7);g.lineTo(-22,10);g.moveTo(22,10);g.lineTo(37,7);}
            if(index==7){g.lineStyle(2,0xa05548);g.moveTo(28,-9);g.lineTo(32,16);g.moveTo(25,-3);g.lineTo(32,-5);g.moveTo(26,4);g.lineTo(34,2);g.moveTo(27,11);g.lineTo(35,9);}
        }
    }
}
