package com.bh.visual {
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    import flash.geom.Point;
    /** Native reconstruction traced against the supplied 16:00 gameplay frame.
     * It is not a recovered source asset or a geographic survey. */
    public class TravelMapArtwork extends Sprite {
        private static const OUTLINE:Array=[75,135,84,143,89,136,109,141,136,145,153,148,175,152,213,158,263,161,328,163,330,155,338,167,349,163,357,170,369,165,390,171,377,178,365,191,369,200,391,214,400,230,411,230,414,216,404,207,409,190,428,186,443,190,453,208,451,229,467,233,496,220,495,211,507,211,509,195,528,195,547,186,562,182,577,174,584,153,595,157,611,174,607,193,602,202,605,214,590,218,588,230,573,240,563,244,566,259,557,266,563,279,552,292,541,304,534,321,521,336,519,359,526,379,527,405,516,407,505,392,495,377,485,364,478,361,467,365,455,361,439,355,429,357,414,354,402,359,389,348,379,351,372,350,365,360,360,373,351,383,349,398,334,396,325,383,318,377,309,377,302,368,294,357,280,347,268,334,245,326,219,325,206,319,197,316,181,319,162,316,150,307,136,305,123,309,116,300,102,298,98,292,89,287,82,278,77,269,67,263,57,259,52,248,51,230,42,228,38,213,42,204,45,188,48,185,58,168,67,156,73,148];
        private static const BORDERS:Array=[
            [75,160,133,174,144,146],[55,207,111,219,133,174],[48,212,68,239,90,262,107,297],
            [76,216,126,227,108,265,99,286],[143,146,144,163,151,178,147,195,165,197,174,154],
            [126,227,180,234,174,274,119,269,108,265],[119,269,174,274,166,315,150,307],
            [165,197,217,203,224,159],[217,203,212,239,180,234],[180,234,236,240,228,280,174,274],
            [174,274,228,280,217,325],[263,161,258,194,327,196,328,163],
            [258,194,253,224,310,228,310,211,327,211,327,196],
            [253,224,247,254,289,259,303,259,304,245,315,246,310,228],
            [236,240,247,240,247,254,304,259,319,276,316,283,228,280],
            [228,280,282,286,289,315,319,318,321,285,316,283],
            [217,325,223,318,238,319,242,302,280,306,289,315,319,318,326,343,318,377],
            [328,163,327,196,327,211,346,211,353,226,375,233,400,230],
            [310,228,346,226,353,244,342,261,304,259],[304,259,342,261,358,278,365,292,356,300,321,298],
            [321,298,356,300,354,333,325,333,326,343],[325,333,354,333,351,356,365,360],
            [391,214,384,223,390,244,365,248,353,226],[365,248,382,246,382,272,373,294,358,278],
            [382,246,398,242,401,267,385,275,382,272],[416,219,416,237,438,235,451,229],
            [398,242,415,242,423,235,441,231,449,255,431,264,401,267],
            [385,275,400,269,431,264,457,256,451,269,426,282,365,292],
            [365,292,426,282,464,274,470,283,452,302,357,308],
            [357,308,378,305,379,351],[378,305,403,303,414,354],
            [403,303,436,298,470,325,467,365],[414,354,439,355,456,360,478,361],
            [436,298,471,291,487,311,470,325],[452,302,470,283,510,279,563,279],
            [464,274,485,262,492,266,549,255],[431,264,442,258,449,255,452,245,466,242,474,257,457,270],
            [441,231,490,225,499,239,491,252,467,255],
            [490,225,495,211,507,211,509,195,530,197,555,223,569,220],
            [548,186,555,210,565,208,562,182],[565,208,577,209,577,174],[530,214,563,212,583,216]
        ];
        private static const CITIES:Object={
            "SEATTLE":[98,153],"OAKLAND":[60,225],"SAN FRANCISCO":[59,236],"LOS ANGELES":[84,269],"SAN DIEGO":[102,288],
            "ARIZONA":[145,290],"COLORADO":[204,251],"TEXAS":[286,323],"HOUSTON":[331,352],
            "KANSAS CITY":[320,264],"MINNESOTA":[348,211],"MILWAUKEE":[378,236],"CHICAGO":[384,251],
            "ST. LOUIS":[358,279],"CINCINNATI":[414,269],"DETROIT":[434,232],"CLEVELAND":[438,251],"PITTSBURGH":[473,249],
            "ATLANTA":[432,320],"TAMPA BAY":[484,365],"MIAMI":[520,388],"WASHINGTON":[508,267],"BALTIMORE":[514,260],
            "PHILADELPHIA":[536,250],"NEW YORK":[546,239],"BOSTON":[579,211],"TORONTO":[477,219]
        };
        public function TravelMapArtwork(w:Number=960,h:Number=720) {
            name="travel-map-artwork";mouseEnabled=mouseChildren=false;
            var land:Sprite=new Sprite(),s:Number=(w-100)/585;
            land.scaleX=land.scaleY=s;land.x=-35*s;land.y=-130*s;addChild(land);
            x=50;y=150+(h-720)*.5;
            var g:Graphics=land.graphics;
            g.beginFill(0x042e42,.28);path(g,OUTLINE,8,29);g.endFill();
            // Extruded side faces reproduce the raised green slab in the video.
            for(var i:int=0;i<OUTLINE.length;i+=2){var j:int=(i+2)%OUTLINE.length;
                g.beginFill(OUTLINE[j]>OUTLINE[i]?0x315d08:0x194606);
                path(g,[OUTLINE[i],OUTLINE[i+1],OUTLINE[j],OUTLINE[j+1],OUTLINE[j],OUTLINE[j+1]+17,OUTLINE[i],OUTLINE[i+1]+17]);g.endFill();}
            var m:Matrix=new Matrix();m.createGradientBox(600,290,Math.PI*.5,35,130);
            g.lineStyle(1.5,0x366f08);g.beginGradientFill(GradientType.LINEAR,[0x83cb00,0xa8df09],[1,1],[0,255],m);path(g,OUTLINE);g.endFill();
            g.lineStyle(1.5,0x3f7b0b,.95);
            for each(var border:Array in BORDERS){g.moveTo(border[0],border[1]);for(i=2;i<border.length;i+=2)g.lineTo(border[i],border[i+1]);}
            g.lineStyle();g.beginFill(0x194c06);path(g,[420,197,425,188,434,188,429,197,434,207,430,219,423,227,421,215]);g.endFill();
        }
        private function path(g:Graphics,p:Array,dx:Number=0,dy:Number=0):void{g.moveTo(p[0]+dx,p[1]+dy);for(var i:int=2;i<p.length;i+=2)g.lineTo(p[i]+dx,p[i+1]+dy);g.lineTo(p[0]+dx,p[1]+dy);}
        public static function cityPoint(city:String,w:Number=960,h:Number=720):Point {
            var p:Array=CITIES[city.toUpperCase()];if(!p)p=CITIES["ST. LOUIS"];
            var s:Number=(w-100)/585;return new Point(50+(p[0]-35)*s,150+(p[1]-130)*s+(h-720)*.5);
        }
        public static function drawBackdrop(g:Graphics,w:Number,h:Number):void {
            var m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI*.5);
            g.beginGradientFill(GradientType.LINEAR,[0x086fa9,0x08558d],[1,1],[0,255],m);g.drawRect(0,0,w,h);g.endFill();
            g.lineStyle(1,0x54b2dd,.09);for(var x:int=24;x<w;x+=88){g.moveTo(x,82);g.curveTo(x-40,h*.5,x+55,h);}g.lineStyle();
            for(var i:int=0;i<12;i++){g.beginFill(0x59a8d1,i%3==0?.15:.07);g.drawRect(i%2==0?0:w*.48,75+i*48,i%2==0?w*(.42+(i%4)*.1):w*.52,7+(i%3)*3);g.endFill();}
        }
    }
}

