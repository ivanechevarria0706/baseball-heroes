package com.bh.ui {
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import com.bh.visual.CharacterPortrait;
    import com.bh.visual.TrainingArtwork;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    import com.bh.model.GameData;

    public class AttributeTrainingScreen extends Sprite {
        private var screenW:Number;
        private var screenH:Number;
        private var player:Object;
        private var onBack:Function;

        private var coinsText:TextField;
        private var ratingText:TextField;
        private var xpText:TextField;
        private var playerInfoText:TextField;

        private var powerText:TextField;
        private var contactText:TextField;
        private var luckText:TextField;

        private var powerCost:TextField;
        private var contactCost:TextField;
        private var luckCost:TextField;

        private var powerButton:UIButton;
        private var contactButton:UIButton;
        private var luckButton:UIButton;
        private var backButton:UIButton;

        private var portrait:CharacterPortrait;
        private var coachArt:Bitmap;
        private var toast:Sprite;
        private var toastText:TextField;
        private var toastLife:int = 0;

        public function AttributeTrainingScreen(
            w:Number,
            h:Number,
            playerData:Object,
            backCallback:Function
        ) {
            super();

            screenW = w;
            screenH = h;
            player = playerData;
            onBack = backCallback;

            GameData.init();

            drawBackground();
            drawTopBar();
            drawPlayerPanel();
            drawTrainingArea();
            drawCoachPanel();
            createToast();

            refresh();

            addEventListener(Event.ENTER_FRAME, onFrame);
        }

        private function drawBackground():void {
            graphics.beginFill(0x101a25);
            graphics.drawRect(0, 0, screenW, screenH);
            graphics.endFill();

            // Training room wall
            graphics.beginFill(0x273847);
            graphics.drawRect(0, 64, screenW, 286);
            graphics.endFill();

            // Wall panels
            for (var i:int = 0; i < 9; i++) {
                graphics.beginFill(i % 2 == 0 ? 0x2d4150 : 0x293b49);
                graphics.drawRect(i * 108, 64, 108, 286);
                graphics.endFill();
            }

            // Floor
            graphics.beginFill(0x78634b);
            graphics.drawRect(0, 350, screenW, screenH - 350);
            graphics.endFill();

            // Floor stripes
            graphics.lineStyle(2, 0x907b61, 0.65);
            for (var y:int = 378; y < screenH; y += 28) {
                graphics.moveTo(0, y);
                graphics.lineTo(screenW, y);
            }
            graphics.lineStyle();
        }

        private function drawTopBar():void {
            graphics.beginFill(0x07111e, 0.99);
            graphics.drawRect(0, 0, screenW, 64);
            graphics.endFill();

            graphics.beginFill(0x284d6e);
            graphics.drawRect(0, 62, screenW, 2);
            graphics.endFill();

            addText("TRAINING", 24, 15, 150, 30, 22, 0xffffff, TextFormatAlign.LEFT);
            addText("PLAYER DEVELOPMENT", 166, 22, 180, 20, 11, 0x8fa9bc, TextFormatAlign.LEFT);

            drawPill(663, 13, 174, 38, 0x6a511b, 0xddb23c);
            coinsText = addText("", 681, 21, 138, 22, 15, 0xffdf83, TextFormatAlign.CENTER);

            backButton = new UIButton(
                "BACK",
                98,
                38,
                0x365a77,
                0x4e7ca1,
                0x92b9d3
            );
            backButton.name="attributes-back";
            backButton.x = 850;
            backButton.y = 13;
            backButton.addEventListener(MouseEvent.CLICK, onBackClick);
            addChild(backButton);
        }

        private function drawPlayerPanel():void {
            graphics.beginFill(0x0b1c2a, 0.95);
            graphics.drawRoundRect(24, 86, 258, screenH - 115, 12, 12);
            graphics.endFill();

            graphics.lineStyle(2, 0x557287);
            graphics.drawRoundRect(24, 86, 258, screenH - 115, 12, 12);
            graphics.lineStyle();

            addText("SELECTED PLAYER", 42, 101, 180, 20, 13, 0x9ab3c4, TextFormatAlign.LEFT);

            // Large card
            graphics.beginFill(0xdbe5eb);
            graphics.drawRoundRect(50, (135) + ((screenH - 540) / 2), 206, 224, 12, 12);
            graphics.endFill();

            graphics.beginFill(uint(player.accent));
            graphics.drawRoundRect(60, (145) + ((screenH - 540) / 2), 186, 42, 9, 9);
            graphics.endFill();

            addText(String(player.grade), 64, (154) + ((screenH - 540) / 2), 178, 22, 16, 0xffffff, TextFormatAlign.CENTER);

            portrait=new CharacterPortrait(player,172,105,true);portrait.x=67;portrait.y=192+(screenH-540)/2;addChild(portrait);

            addText(String(player.name), 54, (302) + ((screenH - 540) / 2), 198, 28, 21, 0x172536, TextFormatAlign.CENTER);
            playerInfoText = addText(String(player.pos) + "   LEVEL " + player.level, 54, (330) + ((screenH - 540) / 2), 198, 20, 12, 0x45627a, TextFormatAlign.CENTER);

            ratingText = addText("", 57, (378) + ((screenH - 540) * 0.78), 192, 33, 25, 0x7edc57, TextFormatAlign.CENTER);
            addText("OVERALL", 57, (412) + ((screenH - 540) * 0.78), 192, 16, 10, 0x8ca8bb, TextFormatAlign.CENTER);

            xpText = addText("", 57, (431) + ((screenH - 540) * 0.78), 192, 17, 10, 0x77bfe7, TextFormatAlign.CENTER);

            addText("El entrenamiento mejora\nlos atributos del jugador.", 47, (453) + ((screenH - 540) * 0.78), 210, 38, 10, 0xb6c7d3, TextFormatAlign.CENTER);
        }

        private function drawTrainingArea():void {
            graphics.beginFill(0x0b1c2a, 0.95);
            graphics.drawRoundRect(300, 86, 426, screenH - 115, 12, 12);
            graphics.endFill();

            graphics.lineStyle(2, 0x557287);
            graphics.drawRoundRect(300, 86, 426, screenH - 115, 12, 12);
            graphics.lineStyle();

            addText("TRAIN ATTRIBUTES", 322, 101, 200, 24, 17, 0xffffff, TextFormatAlign.LEFT);

            drawTrainingRow("POWER", "Aumenta la distancia del hit y la posibilidad de HR.", 322, 188, 0xf06f52, "power");

            drawTrainingRow("CONTACT", "Da más margen al timing y mejora el contacto.", 322, 335, 0x5bb9de, "contact");

            drawTrainingRow("LUCK", "Favorece los buenos resultados y efectos especiales.", 322, 482, 0xd39a4f, "luck");
        }

        private function drawTrainingRow(
            label:String,
            desc:String,
            x:Number,
            y:Number,
            color:uint,
            stat:String
        ):void {
            graphics.beginFill(0x14283a);
            graphics.drawRoundRect(x, y, 382, 91, 10, 10);
            graphics.endFill();

            addText(label, x + 16, y + 12, 95, 20, 15, color, TextFormatAlign.LEFT);
            var descriptionField:TextField = addText(
                desc,
                x + 16,
                y + 36,
                223,
                36,
                9,
                0xaabfcd,
                TextFormatAlign.LEFT
            );
            descriptionField.wordWrap = true;
            descriptionField.multiline = true;

            var valueField:TextField = addText(
                "",
                x + 245,
                y + 12,
                48,
                27,
                21,
                0xffffff,
                TextFormatAlign.CENTER
            );

            var costField:TextField = addText(
                "",
                x + 237,
                y + 48,
                67,
                18,
                9,
                0xffd763,
                TextFormatAlign.CENTER
            );

            var btn:UIButton = new UIButton(
                "+1",
                62,
                45,
                0x355f81,
                0x4b82ad,
                0x8ab8d7
            );
            btn.name="attribute-"+stat;
            btn.x = x + 307;
            btn.y = y + 23;
            addChild(btn);

            if (stat == "power") {
                powerText = valueField;
                powerCost = costField;
                powerButton = btn;
                powerButton.addEventListener(MouseEvent.CLICK, onPowerClick);
            }
            else if (stat == "contact") {
                contactText = valueField;
                contactCost = costField;
                contactButton = btn;
                contactButton.addEventListener(MouseEvent.CLICK, onContactClick);
            }
            else {
                luckText = valueField;
                luckCost = costField;
                luckButton = btn;
                luckButton.addEventListener(
                    MouseEvent.CLICK,
                    onLuckClick
                );
            }
        }

        private function drawCoachPanel():void {
            graphics.beginFill(0x0b1c2a, 0.95);
            graphics.drawRoundRect(744, 86, 192, screenH - 115, 12, 12);
            graphics.endFill();

            graphics.lineStyle(2, 0x557287);
            graphics.drawRoundRect(744, 86, 192, screenH - 115, 12, 12);
            graphics.lineStyle();

            addText("ENTRENADOR", 762, 101, 120, 22, 14, 0xffffff, TextFormatAlign.LEFT);

            coachArt=TrainingArtwork.image(true);coachArt.width=80;coachArt.height=95;coachArt.x=800;coachArt.y=155+(screenH-540)/2;addChild(coachArt);

            addText("\"¡Mejora tu punto fuerte\ny refuerza lo demás!\"", 767, (275) + ((screenH - 540) * 0.78), 146, 52, 12, 0xffe287, TextFormatAlign.CENTER);

            addText("Training Tips", 771, (353) + ((screenH - 540) * 0.78), 138, 20, 13, 0xffffff, TextFormatAlign.CENTER);

            addText("POWER -> potencia\nCONTACT -> contacto\nSPEED -> velocidad", 779, (382) + ((screenH - 540) * 0.78), 124, 65, 10, 0xaec1ce, TextFormatAlign.LEFT);

            addText("ESC returns HOME", 773, (475) + ((screenH - 540) * 0.78), 134, 18, 9, 0x7896aa, TextFormatAlign.CENTER);
        }

        private function tryTrain(stat:String):void {
            var cost:int = GameData.trainingCost(player, stat);

            if (int(player[stat]) >= 99) {
                showToast(stat.toUpperCase() + " is already MAX");
                return;
            }

            if (!GameData.train(player, stat)) {
                showToast("Not enough coins. Need C " + formatNumber(cost));
                return;
            }

            showToast(
                stat.toUpperCase() +
                " increased to " +
                player[stat]
            );

            refresh();
        }

        private function refresh():void {
            coinsText.text = "C " + formatNumber(GameData.coins);

            ratingText.text = "OVR " + player.rating;
            xpText.text = "PLAYER XP " + player.xp + " / 100";

            if (playerInfoText) {
                playerInfoText.text =
                    String(player.pos) +
                    "   LEVEL " +
                    player.level;
            }

            powerText.text = String(player.power);
            contactText.text = String(player.contact);
            luckText.text = String(player.luck);

            powerCost.text = "C " + formatNumber(GameData.trainingCost(player, "power"));
            contactCost.text = "C " + formatNumber(GameData.trainingCost(player, "contact"));
            luckCost.text = "C " + formatNumber(GameData.trainingCost(player, "luck"));
        }

        private function createToast():void {
            toast = new Sprite();
            toast.visible = false;

            toastText = makeText("", 12, 0xffffff, 360, 22, TextFormatAlign.CENTER);
            toastText.x = 0;
            toastText.y = 8;
            toast.addChild(toastText);

            toast.x = 300;
            toast.y = screenH - 47;

            addChild(toast);
        }

        private function showToast(message:String):void {
            toast.graphics.clear();
            toast.graphics.beginFill(0x07111e, 0.96);
            toast.graphics.drawRoundRect(0, 0, 360, 36, 10, 10);
            toast.graphics.endFill();

            toast.graphics.lineStyle(2, 0x6caed7);
            toast.graphics.drawRoundRect(0, 0, 360, 36, 10, 10);
            toast.graphics.lineStyle();

            toastText.text = message;
            toast.visible = true;
            toast.alpha = 1;
            toastLife = 100;
        }

        private function onPowerClick(e:MouseEvent):void {
            tryTrain("power");
        }

        private function onContactClick(e:MouseEvent):void {
            tryTrain("contact");
        }

        private function onLuckClick(
            e:MouseEvent
        ):void {
            tryTrain("luck");
        }

        private function onBackClick(e:MouseEvent):void {
            if (onBack != null) onBack();
        }

        private function onFrame(e:Event):void {
            if (toastLife > 0) {
                toastLife--;

                if (toastLife < 18) {
                    toast.alpha = toastLife / 18;
                }

                if (toastLife <= 0) {
                    toast.visible = false;
                    toast.alpha = 1;
                }
            }
        }

        private function drawPill(
            x:Number,
            y:Number,
            w:Number,
            h:Number,
            fill:uint,
            border:uint
        ):void {
            graphics.beginFill(fill);
            graphics.drawRoundRect(x, y, w, h, h, h);
            graphics.endFill();

            graphics.lineStyle(2, border);
            graphics.drawRoundRect(x, y, w, h, h, h);
            graphics.lineStyle();
        }

        private function addText(
            text:String,
            x:Number,
            y:Number,
            w:Number,
            h:Number,
            size:int,
            color:uint,
            align:String
        ):TextField {
            var t:TextField = makeText(text, size, color, w, h, align);
            t.x = x;
            t.y = y;
            addChild(t);
            return t;
        }

        private function makeText(
            text:String,
            size:int,
            color:uint,
            w:Number,
            h:Number,
            align:String
        ):TextField {
            var t:TextField = new TextField();
            var f:TextFormat = new TextFormat("Arial", size, color, true);
            f.align = align;

            t.defaultTextFormat = f;
            t.text = text;
            t.width = w;
            t.height = h;
            t.selectable = false;
            t.mouseEnabled = false;
            t.wordWrap = false;
            t.multiline = true;

            return t;
        }

        private function formatNumber(value:int):String {
            var s:String = String(value);
            var result:String = "";

            while (s.length > 3) {
                result = "," + s.substr(s.length - 3) + result;
                s = s.substr(0, s.length - 3);
            }

            return s + result;
        }

        public function dispose():void {
            removeEventListener(Event.ENTER_FRAME, onFrame);
            if(portrait)portrait.dispose();
            if(coachArt)coachArt.bitmapData.dispose();

            if (powerButton) {
                powerButton.removeEventListener(MouseEvent.CLICK, onPowerClick);
                powerButton.dispose();
            }

            if (contactButton) {
                contactButton.removeEventListener(MouseEvent.CLICK, onContactClick);
                contactButton.dispose();
            }

            if (luckButton) {
                luckButton.removeEventListener(
                    MouseEvent.CLICK,
                    onLuckClick
                );
                luckButton.dispose();
            }

            if (backButton) {
                backButton.removeEventListener(MouseEvent.CLICK, onBackClick);
                backButton.dispose();
            }
        }
    }
}

