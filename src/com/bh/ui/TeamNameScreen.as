package com.bh.ui {
    import flash.display.Sprite;
    import com.bh.visual.MatchStadium;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.text.TextFieldType;

    import com.bh.model.GameData;
    import com.bh.visual.TeamLogoView;

    public class TeamNameScreen extends Sprite {
        private var stadium:MatchStadium;
        private var logo:TeamLogoView;
        private var completed:Boolean=false;
        private var screenW:Number;
        private var screenH:Number;
        private var onDone:Function;

        private var nameInput:TextField;
        private var numberInput:TextField;
        private var confirmButton:UIButton;
        private var cancelButton:UIButton;
        private var messageText:TextField;

        public function TeamNameScreen(w:Number, h:Number, doneCallback:Function) {
            super();
            name="team-name";screenW = w;
            screenH = h;
            onDone = doneCallback;
            GameData.init();
            draw();
        }

        private function draw():void {
            stadium=new MatchStadium(screenW,screenH);addChild(stadium);
            var frame:Sprite=new Sprite();addChild(frame);
            frame.graphics.beginFill(0x061d2a, .45);
            frame.graphics.drawRect(0, 0, screenW, screenH);
            frame.graphics.endFill();

            var px:Number = screenW / 2 - 190;
            var py:Number = (screenH - 405) / 2;

            ClassicChrome.well(frame.graphics,px,py,380,405);
            // Quiet paper stars visible in the supplied naming dialog.
            for(var star:int=0;star<12;star++){var sx:Number=px+27+(star%6)*64,sy:Number=py+24+int(star/6)*63;frame.graphics.beginFill(0xffffff,.32);for(var j:int=0;j<10;j++){var angle:Number=-Math.PI/2+j*Math.PI/5,radius:Number=j%2?5:12;if(j==0)frame.graphics.moveTo(sx+Math.cos(angle)*radius,sy+Math.sin(angle)*radius);else frame.graphics.lineTo(sx+Math.cos(angle)*radius,sy+Math.sin(angle)*radius);}frame.graphics.endFill();}

            logo=new TeamLogoView(GameData.teamCity,GameData.teamAccent,"",106);logo.x=px+137;logo.y=py+12;addChild(logo);

            addText(GameData.teamCity, px + 95, py + 122, 190, 24, 15, 0xb27b21, TextFormatAlign.CENTER);
            ClassicChrome.title(addText("NAME YOUR TEAM!", px + 35, py + 160, 310, 36, 26, 0x44484c, TextFormatAlign.CENTER),29,0x44484c);
            addText("My Team Name", px + 55, py + 205, 150, 16, 10, 0x69757c, TextFormatAlign.LEFT);

            nameInput = makeInput(GameData.teamName, px + 55, py + 224, 270, 34);
            nameInput.name="team-name-input";nameInput.maxChars = 18;
            addChild(nameInput);
            addText("Solo letras, números y espacios.", px + 55, py + 260, 210, 16, 9, 0x3a84bb, TextFormatAlign.LEFT);

            addText("My Uniform Number", px + 55, py + 289, 160, 16, 10, 0x69757c, TextFormatAlign.LEFT);
            numberInput = makeInput(String(GameData.uniformNumber), px + 55, py + 308, 270, 34);
            numberInput.name="team-number-input";numberInput.maxChars = 2;
            nameInput.restrict = "A-Za-z0-9 ";
            numberInput.restrict = "0-9";
            addChild(numberInput);

            messageText = addText("", px + 55, py + 347, 270, 18, 10, 0xcc4f4f, TextFormatAlign.CENTER);

            confirmButton = new UIButton("CONFIRM", 165, 38, 0x66ab2d, 0x83d23c, 0xdaf593,18,true);
            confirmButton.x = px + 110;
            confirmButton.name="team-name-confirm";
            confirmButton.y = py + 361;
            confirmButton.addEventListener(MouseEvent.CLICK, onConfirm);
            addChild(confirmButton);

            cancelButton = new UIButton("X", 42, 36, 0xb84d43, 0xdf6558, 0xffffff);
            cancelButton.x = px + 325;
            cancelButton.name="team-name-cancel";
            cancelButton.y = py + 12;
            cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
            addChild(cancelButton);
        }

        private function makeInput(text:String, x:Number, y:Number, w:Number, h:Number):TextField {
            var field:TextField = new TextField();
            var format:TextFormat = new TextFormat("Arial", 17, 0xffffff, true);
            field.defaultTextFormat = format;
            field.type = TextFieldType.INPUT;
            field.text = text;
            LineupTypography.apply(field,17,0xffffff,TextFormatAlign.LEFT);
            field.x = x;
            field.y = y;
            field.width = w;
            field.height = h;
            var box:Sprite=new Sprite();ClassicChrome.well(box.graphics,x-3,y-2,w+6,h+4,false,false);box.mouseEnabled=false;addChild(box);
            field.background = false;field.border = false;
            field.selectable = true;
            return field;
        }

        private function onConfirm(e:MouseEvent):void {
            if(completed)return;
            var name:String = nameInput.text.replace(/^\s+|\s+$/g, "");
            var number:int = int(numberInput.text);

            if (!name || name.length < 2) {
                messageText.text = "Escribe al menos dos caracteres.";
                return;
            }

            if (!numberInput.text.length || number < 0 || number > 99) {messageText.text="Usa un número del 0 al 99.";return;}
            completed=true;

            GameData.setTeamIdentity(name, GameData.teamCity, GameData.teamAccent, number);
            if (onDone != null) onDone();
        }

        private function onCancel(e:MouseEvent):void {
            if(completed)return;completed=true;
            if (onDone != null) onDone();
        }

        private function addText(text:String, x:Number, y:Number, w:Number, h:Number, size:int, color:uint, align:String):TextField {
            var field:TextField = new TextField();
            var format:TextFormat = new TextFormat("Arial", size, color, true);
            format.align = align;
            field.defaultTextFormat = format;
            field.text = text;
            LineupTypography.apply(field,size,color,align,size>=24);
            field.x = x;
            field.y = y;
            field.width = w;
            field.height = h;
            LineupTypography.fit(field,size,color,align,size>=24);
            field.selectable = false;
            field.mouseEnabled = false;
            addChild(field);
            return field;
        }

        public function dispose():void {
            if(logo)logo.dispose();
            if(stadium){stadium.dispose();stadium=null;}
            if (confirmButton) {
                confirmButton.removeEventListener(MouseEvent.CLICK, onConfirm);
                confirmButton.dispose();
            }
            if (cancelButton) {
                cancelButton.removeEventListener(MouseEvent.CLICK, onCancel);
                cancelButton.dispose();
            }
        }
    }
}
