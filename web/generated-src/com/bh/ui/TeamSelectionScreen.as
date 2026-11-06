package com.bh.ui {
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    import com.bh.model.GameData;
    import com.bh.visual.TeamLogoView;
    import com.bh.visual.TravelMapArtwork;
    import com.bh.visual.CreationArtwork;
    import flash.geom.Point;

    public class TeamSelectionScreen extends Sprite {
        private var screenW:Number;
        private var screenH:Number;
        private var onSelectDone:Function;
        private var onBack:Function;

        private var completed:Boolean=false;
        private var mapLayer:Sprite;
        private var actorLayer:Sprite;
        private var teams:Array;
        private var cards:Array = [];
        private var logoViews:Array = [];
        private var selected:Object;

        private var pin:Sprite;
        private var cityText:TextField;
        private var previewTitle:TextField;
        private var previewLogoLayer:Sprite;
        private var selectButton:UIButton;
        private var backButton:UIButton;

        public function TeamSelectionScreen(
            w:Number,
            h:Number,
            selectCallback:Function,
            backCallback:Function = null
        ) {
            super();

            name="team-selection";
            screenW = w;
            screenH = h;
            onSelectDone = selectCallback;
            onBack = backCallback != null ? backCallback : selectCallback;

            GameData.init();
            teams = createTeams();

            drawBackground();
            drawMap();
            drawTeamGrid();
            drawPreview();
            selectExistingTeam();
        }

        private function createTeams():Array {
            // Unique city choices from the historical logo sheet supplied by
            // the user. Coordinates are reconstructed for the stylized USA map.
            return [
                {city:"SEATTLE", name:"SEATTLE", x:105, y:112, accent:0x3f82b4},
                {city:"OAKLAND", name:"OAKLAND", x:108, y:199, accent:0x74a83b},
                {city:"SAN FRANCISCO", name:"SAN FRANCISCO", x:102, y:215, accent:0x526d83},
                {city:"LOS ANGELES", name:"LOS ANGELES", x:124, y:255, accent:0xd85a3d},
                {city:"SAN DIEGO", name:"SAN DIEGO", x:135, y:286, accent:0x8d5b3f},
                {city:"ARIZONA", name:"ARIZONA", x:222, y:274, accent:0x4d9ab0},
                {city:"COLORADO", name:"COLORADO", x:305, y:201, accent:0x66758e},
                {city:"TEXAS", name:"TEXAS", x:369, y:312, accent:0x9b533f},
                {city:"KANSAS CITY", name:"KANSAS CITY", x:423, y:220, accent:0xc1813b},
                {city:"MINNESOTA", name:"MINNESOTA", x:421, y:120, accent:0x8a694a},
                {city:"MILWAUKEE", name:"MILWAUKEE", x:470, y:139, accent:0x6f6f4a},
                {city:"CHICAGO", name:"CHICAGO", x:495, y:150, accent:0x3a74ad},
                {city:"ST. LOUIS", name:"SAINT LOUIS", x:473, y:215, accent:0xd24b38},
                {city:"CINCINNATI", name:"CINCINNATI", x:535, y:205, accent:0xe35c2c},
                {city:"DETROIT", name:"DETROIT", x:548, y:150, accent:0xd7a92f},
                {city:"CLEVELAND", name:"CLEVELAND", x:574, y:157, accent:0x7f8742},
                {city:"PITTSBURGH", name:"PITTSBURGH", x:610, y:183, accent:0xc7a632},
                {city:"ATLANTA", name:"ATLANTA", x:569, y:300, accent:0xbd7437},
                {city:"TAMPA BAY", name:"TAMPA BAY", x:628, y:340, accent:0x7b65a5},
                {city:"MIAMI", name:"MIAMI", x:655, y:365, accent:0x3f9fb0},
                {city:"WASHINGTON", name:"WASHINGTON", x:657, y:202, accent:0x8b4b78},
                {city:"BALTIMORE", name:"BALTIMORE", x:673, y:191, accent:0xd59a32},
                {city:"PHILADELPHIA", name:"PHILADELPHIA", x:687, y:174, accent:0xb86c42},
                {city:"NEW YORK", name:"NEW YORK", x:704, y:150, accent:0x4c6f9b},
                {city:"BOSTON", name:"BOSTON", x:735, y:118, accent:0x4c86ba},
                {city:"TORONTO", name:"TORONTO", x:613, y:112, accent:0x4e8eb1},
                {city:"HOUSTON", name:"HOUSTON", x:418, y:330, accent:0x8450a0}
            ];
        }

        private function drawBackground():void {
            TravelMapArtwork.drawBackdrop(graphics,screenW,screenH);
            backButton=new UIButton("SKIP",72,28,0x355976,0x4b789e,0x9ac3df);
            backButton.name="team-skip";backButton.x=868;backButton.y=14;
            backButton.addEventListener(MouseEvent.CLICK,onBackClick);addChild(backButton);
        }
        private function drawMap():void {
            mapLayer=new Sprite();mapLayer.scaleX=mapLayer.scaleY=.94;mapLayer.x=20;mapLayer.y=-112;addChild(mapLayer);
            mapLayer.addChild(new TravelMapArtwork());
            for each(var team:Object in teams){var p:Point=TravelMapArtwork.cityPoint(team.city);
                var dot:Sprite=new Sprite();dot.graphics.beginFill(0xffffff,.5);dot.graphics.drawCircle(0,0,8);dot.graphics.endFill();dot.x=p.x;dot.y=p.y;mapLayer.addChild(dot);
                var label:TextField=makeText(String(team.city),9,0xf4f9d5,90,16,TextFormatAlign.CENTER);label.x=p.x-44;label.y=p.y-21;mapLayer.addChild(label);
            }
            pin=new Sprite();pin.graphics.lineStyle(3,0xe5fcff);pin.graphics.beginFill(0x159ade);pin.graphics.drawCircle(0,-17,17);pin.graphics.moveTo(-12,-7);pin.graphics.lineTo(0,17);pin.graphics.lineTo(12,-7);pin.graphics.endFill();mapLayer.addChild(pin);
            cityText=addText("",650,400,290,30,18,0xffffff,TextFormatAlign.CENTER);
        }
        private function drawTeamGrid():void {
            // Draw above the map; parent graphics otherwise sit behind its sprite.
            var paper:Sprite=new Sprite();paper.mouseEnabled=false;ClassicChrome.well(paper.graphics,20,468,618,232);ClassicChrome.well(paper.graphics,645,468,295,232);addChild(paper);
            addText("A-LEAGUE",30,477,140,24,16,0xbf4e52,TextFormatAlign.LEFT);
            ClassicChrome.title(addText("TEAM SELECTION",177,474,306,34,23,0x444a4d,TextFormatAlign.CENTER),26,0x444a4d);
            addText("N-LEAGUE",493,477,134,24,16,0x327fa8,TextFormatAlign.RIGHT);
            for(var i:int=0;i<teams.length;i++){
                var cell:Sprite=new Sprite();cell.name="team-option-"+i;cell.x=31+(i%9)*66;cell.y=510+int(i/9)*61;
                var logo:TeamLogoView=new TeamLogoView(String(teams[i].city),uint(teams[i].accent),"",55);logo.x=3;logo.y=2;cell.addChild(logo);logoViews.push(logo);
                cell.buttonMode=true;cell.mouseChildren=false;cell.addEventListener(MouseEvent.CLICK,onTeamCell);addChild(cell);cards.push({view:cell,data:teams[i]});
            }
        }
        private function drawPreview():void {
            actorLayer=new Sprite();addChild(actorLayer);
            previewLogoLayer=new Sprite();previewLogoLayer.x=805;previewLogoLayer.y=492;addChild(previewLogoLayer);
            previewTitle=addText("",797,606,133,24,12,0x31434f,TextFormatAlign.CENTER);
            selectButton=new UIButton("SELECT",151,38,0x67ad2d,0x82d13d,0xdaf591,18,true);selectButton.name="team-select";selectButton.x=778;selectButton.y=649;selectButton.addEventListener(MouseEvent.CLICK,onSelect);addChild(selectButton);
            ClassicChrome.title(addText("¡CLIC!",657,650,110,37,24,0x4b4e35,TextFormatAlign.CENTER),27,0x4b4e35);
            var arrow:Sprite=new Sprite();arrow.mouseEnabled=false;arrow.graphics.lineStyle(2,0x594a1f);arrow.graphics.beginFill(0xf1cb4b);arrow.graphics.moveTo(745,665);arrow.graphics.lineTo(758,665);arrow.graphics.lineTo(758,657);arrow.graphics.lineTo(772,670);arrow.graphics.lineTo(758,683);arrow.graphics.lineTo(758,675);arrow.graphics.lineTo(745,675);arrow.graphics.lineTo(745,665);arrow.graphics.endFill();addChild(arrow);
        }

        private function selectExistingTeam():void {
            var best:Object = teams[0];
            for each (var team:Object in teams) {
                if (String(team.city) == GameData.teamCity) {
                    best = team;
                    break;
                }
            }
            chooseTeam(best);
        }

        private function onTeamCell(e:MouseEvent):void {
            for each (var item:Object in cards) {
                if (item.view == e.currentTarget) {
                    chooseTeam(item.data);
                    break;
                }
            }
        }

        private function chooseTeam(team:Object):void {
            selected = team;
            var point:Point=TravelMapArtwork.cityPoint(team.city);pin.x=point.x;pin.y=point.y-19;
            for each(var item:Object in cards){var cell:Sprite=item.view;cell.graphics.clear();ClassicChrome.well(cell.graphics,0,0,62,58,item.data==team);}
            while(actorLayer.numChildren){var removed:*=actorLayer.removeChildAt(0);if(removed is CreationArtwork)CreationArtwork(removed).dispose();}
            var actor:CreationArtwork=new CreationArtwork(GameData.heroAppearance(),uint(team.accent));actor.scaleX=actor.scaleY=.52;actor.x=712;actor.y=548;actorLayer.addChild(actor);
            cityText.text = String(team.city);
            previewTitle.text = String(team.name);
            LineupTypography.fit(previewTitle,12,0x31434f,TextFormatAlign.CENTER);

            while (previewLogoLayer.numChildren > 0) {
                var old:* = previewLogoLayer.removeChildAt(0);
                if (old is TeamLogoView) {
                    TeamLogoView(old).dispose();
                }
            }

            var logo:TeamLogoView = new TeamLogoView(
                String(team.city), uint(team.accent), String(team.city).substr(0,1), 114
            );
            logo.x = 0;
            logo.y = 0;
            previewLogoLayer.addChild(logo);
        }

        private function onSelect(e:MouseEvent):void {
            if (!selected || completed || !GameData.teamSelectionOpen()) return;
            completed=true;

            GameData.setTeamIdentity(
                GameData.teamName,
                String(selected.city),
                uint(selected.accent),
                GameData.uniformNumber
            );

            if (onSelectDone != null) onSelectDone();
        }

        private function onBackClick(e:MouseEvent):void {
            if(completed)return;completed=true;
            if (onBack != null) onBack();
        }

        private function shortCity(city:String):String {
            if (city == "SAN FRANCISCO") return "SF";
            if (city == "LOS ANGELES") return "LA";
            if (city == "SAN DIEGO") return "SD";
            if (city == "KANSAS CITY") return "KC";
            if (city == "TAMPA BAY") return "TB";
            if (city == "ST. LOUIS") return "STL";
            if (city == "NEW YORK") return "NY";
            if (city == "WASHINGTON") return "WAS";
            if (city == "PHILADELPHIA") return "PHI";
            return city.substr(0, Math.min(3, city.length));
        }

        private function makeText(text:String, size:int, color:uint, w:Number, h:Number, align:String):TextField {
            var field:TextField = new TextField();
            var format:TextFormat = new TextFormat("Arial", size, color, true);
            format.align = align;
            field.defaultTextFormat = format;
            field.text = text;
            LineupTypography.apply(field,size,color,align,size>=20);
            field.width = w;
            field.height = h;
            LineupTypography.fit(field,size,color,align,size>=20,7);
            field.selectable = false;
            field.mouseEnabled = false;
            return field;
        }

        private function addText(text:String, x:Number, y:Number, w:Number, h:Number, size:int, color:uint, align:String):TextField {
            var field:TextField = makeText(text, size, color, w, h, align);
            field.x = x;
            field.y = y;
            addChild(field);
            return field;
        }

        public function dispose():void {
            while(actorLayer.numChildren){var removed:*=actorLayer.removeChildAt(0);if(removed is CreationArtwork)CreationArtwork(removed).dispose();}
            for each (var item:Object in cards) {
                Sprite(item.view).removeEventListener(MouseEvent.CLICK, onTeamCell);
            }
            for each (var logo:TeamLogoView in logoViews) {
                logo.dispose();
            }
            if (previewLogoLayer) {
                while (previewLogoLayer.numChildren > 0) {
                    var child:* = previewLogoLayer.removeChildAt(0);
                    if (child is TeamLogoView) TeamLogoView(child).dispose();
                }
            }
            if (selectButton) {
                selectButton.removeEventListener(MouseEvent.CLICK, onSelect);
                selectButton.dispose();
            }
            if (backButton) {
                backButton.removeEventListener(MouseEvent.CLICK, onBackClick);
                backButton.dispose();
            }
        }
    }
}
