package com.bh.visual {
    import flash.display.*;
    import flash.geom.*;
    import flash.events.Event;
    import flash.filesystem.File;
    import com.bh.model.GameData;
    import com.bh.ui.StadiumDecorationView;

    /** Batting camera reconstructed in a 960 x 720 reference frame. */
    public class MatchStadium extends Sprite {
        private var art:Sprite=new Sprite();
        private var image:AssetImage;
        private var field:Sprite,retainField:Boolean=false;
        private var visitorView:Object;
        private var upgrade:StadiumUpgradeOverlay,illustratedRookie:Boolean=false;
        private var atmosphere:StadiumAtmosphere;
        public function MatchStadium(w:Number,h:Number,view:Object=null,decorations:Boolean=true){
            visitorView=view;
            name='match-stadium';mouseEnabled=mouseChildren=false;
            scrollRect=new Rectangle(0,0,w,h);addChild(art);
            // The stadium is static; preserve its complete composition in one render cache.
            art.cacheAsBitmap=true;
            art.scaleX=w/960;art.scaleY=h/720;
            var active:Object=stadiumItem('background');
            retainField=active&&String(active.id).indexOf("095")>=0;
            var path:String=active?VisualAssetRegistry.stadiumPath(String(active.id)):'';
            illustratedRookie=!path;
            if(illustratedRookie){
                art.addChild(new RookieStadiumArtwork(960,720));
            }else{
                drawSky(art.graphics);
                field=new Sprite();field.name='native-stadium-field';art.addChild(field);drawField(field.graphics);
                if(File.applicationDirectory.resolvePath(path).exists){
                    image=new AssetImage(path,960,720,AssetImage.STRETCH);image.name='illustrated-stadium';
                    image.addEventListener(Event.COMPLETE,onIllustrationLoaded);art.addChild(image);
                }
            }
            upgrade=new StadiumUpgradeOverlay(960,720,true,view,illustratedRookie);upgrade.name="stadium-upgrades";art.addChild(upgrade);
            var entries:Array=view?(view.decorations as Array):GameData.stadiumDecorations;
            if(decorations&&entries)for(var i:int=0;i<entries.length;i++){
                var entry:Object=entries[i],item:Object=GameData.shopItemById(String(entry.id));if(!item)continue;
                var decoration:StadiumDecorationView=new StadiumDecorationView(item,i);
                decoration.name="stadium-decoration-"+i;StadiumPlacement.place(decoration,entry);art.addChild(decoration);
            }
        }
        private function enableAtmosphere():void {
            // Only live matches request this layer. HOME, shops and BUILD keep a static plate.
            // Keep motion outside the cached plate; never invalidate its 960x720 pixels.
            if(!atmosphere){
                var boardItem:Object=stadiumItem("scoreboard"),defaultBoard:Boolean=!boardItem||(int(boardItem.coinPrice)==0&&int(boardItem.cashPrice)==0);
                var background:Object=stadiumItem("background"),id:String=background?String(background.id):"stadium_background_mountain";
                var layout:Object=StadiumAtmosphereLayout.create(id,illustratedRookie,!defaultBoard,boardItem&&String(boardItem.id).indexOf("neon")>=0);
                atmosphere=new StadiumAtmosphere(illustratedRookie,true,layout);atmosphere.scaleX=art.scaleX;atmosphere.scaleY=art.scaleY;addChild(atmosphere);
            }
        }
        public function advance(now:int,active:Boolean=true):void {if(atmosphere)atmosphere.advance(now,active);}
        public function setMatch(home:int,away:int,inning:int,side:String,player:String):void {enableAtmosphere();if(atmosphere)atmosphere.setMatch(home,away,inning,side,player);}
        public function celebrate(result:String):void {if(atmosphere&&["SINGLE","DOUBLE","TRIPLE","HOME RUN","HIT"].indexOf(result)>=0)atmosphere.cheer(result=="HOME RUN"?3200:1600);}
        private function stadiumItem(slot:String):Object {
            return visitorView?(visitorView.equipped?GameData.shopItemById(String(visitorView.equipped[slot])):null):GameData.activeStadiumItem(slot);
        }
        private function stadiumAccent(slot:String,fallback:uint):uint {var item:Object=stadiumItem(slot);return item&&item.accent!==undefined?uint(item.accent):fallback;}
        private function poly(g:Graphics,c:uint,p:Array,a:Number=1):void {
            g.beginFill(c,a);g.moveTo(p[0],p[1]);for(var i:int=2;i<p.length;i+=2)g.lineTo(p[i],p[i+1]);g.lineTo(p[0],p[1]);g.endFill();
        }
        private function gradient(g:Graphics,x:Number,y:Number,w:Number,h:Number,colors:Array,radial:Boolean=false):void {
            var m:Matrix=new Matrix();m.createGradientBox(w,h,Math.PI/2,x,y);
            g.beginGradientFill(radial?'radial':'linear',colors,[1,1],[0,255],m);g.drawRect(x,y,w,h);g.endFill();
        }
        private function drawSky(g:Graphics):void {
            gradient(g,0,0,960,348,[0x119dde,0xc8fff3]);
            for(var i:int=0;i<9;i++){
                var cx:Number=(i*137+43)%1020-50,cy:Number=107+(i%3)*36;
                g.beginFill(0xe5fffc,.8);g.drawEllipse(cx,cy+10,132,10);g.endFill();
                g.beginFill(0xe5fffc,.8);g.drawEllipse(cx+19,cy,71,18);g.endFill();
                g.beginFill(0xe5fffc,.8);g.drawEllipse(cx+40,cy-9,35,24);g.endFill();
            }
            poly(g,0x91d9c9,[0,283,0,220,104,208,157,223,220,197,293,235,361,219,441,277,533,227,602,244,684,202,768,228,851,205,960,245,960,348,0,348]);
            poly(g,0xe1f4e7,[155,223,220,197,274,225,232,214,220,224,205,210]);
            poly(g,0xd1eee1,[620,233,684,202,733,224,692,214,681,226,666,215]);
            poly(g,0x53b68b,[0,314,0,282,89,247,174,272,238,243,316,278,356,247,443,307,529,264,593,284,652,252,731,276,825,249,960,284,960,348,0,348]);
            poly(g,0x279448,[0,333,0,302,96,291,202,310,277,283,342,312,403,295,467,325,523,298,607,321,661,291,742,310,824,282,960,309,960,350,0,350]);
            for(i=0;i<80;i++){
                g.beginFill(i%3==0?0x73be38:0x52ac32);g.drawCircle(i*13,322+(i%4)*4,9+i%5);g.endFill();
            }
            stands(g,false);stands(g,true);
            for(i=0;i<4;i++){
                var x:Number=[22,171,789,938][i],y:Number=i==0||i==3?211:176;
                g.lineStyle(3,0x99bfb9);g.moveTo(x,y+15);g.lineTo(x,312);g.lineStyle(1,0xe2eee0);g.moveTo(x-2,y+15);g.lineTo(x-2,312);g.lineStyle();
                g.beginFill(0x98b7a8);g.drawRoundRect(x-29,y,58,17,4);g.endFill();
                for(var j:int=0;j<10;j++){g.beginFill(stadiumAccent('lights',0xfff6ac));g.drawEllipse(x-25+j%5*11,y+3+int(j/5)*7,8,5);g.endFill();}
            }
            g.lineStyle(3,0x29691b);g.beginFill(stadiumAccent('scoreboard',0x308523));g.drawRect(416,254,129,77);g.endFill();g.lineStyle();
            g.beginFill(0x214c2a);g.drawRect(425,268,28,30);g.drawRect(510,268,26,30);g.drawRect(426,305,109,16);g.endFill();
            g.lineStyle(1,0x579052);for(i=0;i<10;i++){g.moveTo(428+i*11,306);g.lineTo(428+i*11,320);}g.moveTo(426,313);g.lineTo(535,313);g.lineStyle();
            g.beginFill(0xa9c899);g.drawCircle(481,266,13);g.endFill();g.lineStyle(1,0x397047);g.moveTo(481,257);g.lineTo(481,266);g.lineTo(487,270);g.lineStyle();
            g.beginFill(0x163f2d);g.drawRect(467,284,27,20);g.endFill();
            g.lineStyle(3,stadiumAccent('fence',0x316452));g.moveTo(0,331);g.lineTo(960,331);g.lineStyle();
            g.beginFill(stadiumAccent('wall',0x23623b));g.drawRect(0,333,960,22);g.endFill();
            for(i=0;i<12;i++){
                g.beginFill(i%2==0?0x268394:0x459b40);g.drawRect(i*80,335,79,14);g.endFill();
                for(j=0;j<5;j++){g.beginFill(0xc4e4c0,.35);g.drawRect(i*80+12+j*11,340,8,3);g.endFill();}
            }
        }
        private function stands(g:Graphics,mirror:Boolean):void {
            var stand:Sprite=new Sprite(),q:Graphics=stand.graphics;
            poly(q,0xe6e8dc,[0,207,94,207,125,244,319,245,361,328,0,328]);
            poly(q,stadiumAccent('stand',0x794935),[0,214,73,214,110,318,0,318]);
            poly(q,stadiumAccent('stand',0x794935),[134,251,309,251,343,319,155,319]);
            var palette:Array=[0xece7cb,0xf6c54b,0xa14842,0x398c91,0x7387ac,0xe09158];
            for(var row:int=0;row<15;row++){
                var yy:Number=218+row*7;
                for(var seat:int=0;seat<58;seat++){
                    var sx:Number=seat*6;
                    var inside:Boolean=sx<74+(yy-214)*.36 || yy>=255&&sx>135+(yy-251)*.31&&sx<309+(yy-251)*.50;
                    if(!inside)continue;
                    q.beginFill(uint(palette[(row*13+seat*7)%6]));q.drawRect(sx,yy,3.5,3);q.endFill();
                    q.beginFill(0xf2c496);q.drawCircle(sx+1.8,yy-1,1.3);q.endFill();
                }
                q.lineStyle(1,0xdfb88c,.42);q.moveTo(0,yy+4);q.lineTo(74+(yy-214)*.36,yy+4);q.lineStyle();
            }
            poly(q,0xbcc9c4,[78,208,96,208,145,328,113,328]);
            q.lineStyle(1,0xf4f5e5,.8);for(row=0;row<13;row++){var step:Number=row/13;q.moveTo(80+step*34,213+step*111);q.lineTo(96+step*46,213+step*111);}q.lineStyle();
            if(mirror){stand.scaleX=-1;stand.x=960;}art.addChild(stand);
        }
        private function drawField(g:Graphics):void {
            var green:uint=stadiumAccent('field',0x459749);
            gradient(g,0,352,960,368,[0x0e612e,green]);
            // Distant warning track and a broad, curved lawn give depth behind the mound.
            g.lineStyle(5,0x936b42);g.moveTo(0,402);g.curveTo(480,348,960,402);
            g.lineStyle(2,0xa9b457);g.moveTo(0,398);g.curveTo(480,346,960,398);g.lineStyle();
            for(var i:int=0;i<5;i++){
                g.beginFill(0x91ca57,.035);g.drawEllipse(-350+i*90,365+i*24,1660-i*180,70+i*27);g.endFill();
            }
            var m:Matrix=new Matrix();m.createGradientBox(960,245,0,0,475);
            g.beginGradientFill('linear',[0x9c793f,0xd9b77a,0x9c793f],[1,1,1],[0,128,255],m);
            g.moveTo(0,481);g.curveTo(480,611,960,481);g.lineTo(960,720);g.lineTo(0,720);g.lineTo(0,481);g.endFill();
            g.lineStyle(3,0xe8c994,.75);g.moveTo(0,481);g.curveTo(480,611,960,481);g.lineStyle();
            poly(g,green,[0,522,73,544,0,552]);poly(g,green,[960,522,887,544,960,552]);
            m.createGradientBox(186,32,0,387,420);g.beginGradientFill('radial',[0xe2c286,0x9a703e],[1,1],[0,255],m);
            g.moveTo(387,441);g.curveTo(479,403,573,441);g.curveTo(480,458,387,441);g.endFill();
            g.lineStyle(1,0x8e6c37,.45);g.moveTo(390,442);g.curveTo(480,458,570,442);g.lineStyle();
            g.beginFill(0xf8efcc);g.drawRect(464,431,33,4);g.endFill();
            g.lineStyle(4,0xfffce9,.98);g.moveTo(0,491);g.lineTo(480,600);g.lineTo(960,491);
            g.moveTo(385,564);g.lineTo(282,564);g.lineTo(137,707);g.lineTo(307,707);g.lineTo(385,564);
            g.moveTo(575,564);g.lineTo(678,564);g.lineTo(823,707);g.lineTo(653,707);g.lineTo(575,564);g.lineStyle();
            // Fine deterministic scuffs; no gameplay RNG is consumed by decoration.
            for(i=0;i<65;i++){var xx:Number=(i*137)%950,yy:Number=580+(i*37)%136;g.lineStyle(1,0x705332,.10);g.moveTo(xx,yy);g.lineTo(xx+4+i%5,yy-1);g.lineStyle();}
            poly(g,0x785e40,[426,582,534,582,551,637,480,657,409,637]);
            g.lineStyle(2,0x8b7a5f);g.beginFill(0xfffae9);g.moveTo(427,579);g.lineTo(533,579);g.lineTo(548,632);g.curveTo(480,657,412,632);g.lineTo(427,579);g.endFill();g.lineStyle();
            g.lineStyle(2,0xffffff,.8);g.moveTo(430,582);g.lineTo(530,582);g.lineStyle();
        }
        private function onIllustrationLoaded(e:Event):void {
            field.visible=retainField;
            // Keep the game's measured mound/plate geometry under the actors.
            if(retainField){art.removeChild(field);art.addChildAt(field,art.getChildIndex(image)+1);}
            var index:int=art.getChildIndex(upgrade);art.removeChild(upgrade);upgrade.cacheAsBitmap=false;
            upgrade=new StadiumUpgradeOverlay(960,720,true,visitorView,illustratedRookie);upgrade.name="stadium-upgrades";art.addChildAt(upgrade,index);
        }
        public function dispose():void {if(atmosphere){atmosphere.dispose();atmosphere=null;}for(var j:int=0;j<art.numChildren;j++)if(art.getChildAt(j) is StadiumDecorationView)StadiumDecorationView(art.getChildAt(j)).dispose();art.cacheAsBitmap=false;if(image){image.removeEventListener(Event.COMPLETE,onIllustrationLoaded);image.dispose();image=null;}}
    }
}
