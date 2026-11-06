package com.bh.game {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.filters.DropShadowFilter;

    import com.bh.visual.VisualProfile;
    import com.bh.model.GameData;

    public class Batter extends Sprite {
        private var bodyRoot:Sprite;
        private var torso:Sprite;
        private var head:Sprite;
        private var frontArm:Sprite;
        private var backArm:Sprite;
        private var frontLeg:Sprite;
        private var backLeg:Sprite;
        private var bat:Sprite;
        private var trail:Sprite;

        private var accentColor:uint;
        private var jerseyNumber:int;
        private var playerName:String;
        private var skinColor:uint;
        private var hairColor:uint;
        private var eyeColor:uint;
        private var batColor:uint = 0x9b5a26;
        private var helmetColor:uint;
        private var beltColor:uint = 0x25313e;
        private var shoesColor:uint = 0x1c252e;
        private var gogglesColor:uint = 0;

        private var swinging:Boolean = false;
        private var swingFrame:int = 0;
        private var idlePhase:Number = 0;

        private var reaction:String = "";
        private var reactionFrame:int = 0;
        private var pitchProgress:Number = 0;

        public function Batter(
            px:Number,
            py:Number,
            accent:uint = 0x17375f,
            number:int = 8,
            name:String = "Hero"
        ) {
            super();

            x = px;
            y = py;

            accentColor = accent;
            jerseyNumber = number;
            playerName = name;

            var playerData:Object =
                GameData.playerByName(
                    playerName
                );

            var appearance:Object =
                playerData &&
                playerData.appearance
                ? playerData.appearance
                : null;

            skinColor =
                VisualProfile.skin(
                    playerName,
                    appearance
                );

            hairColor =
                VisualProfile.hair(
                    playerName,
                    appearance
                );

            eyeColor =
                VisualProfile.eyeColor(
                    playerName,
                    appearance
                );

            helmetColor =
                VisualProfile.darker(
                    accentColor,
                    0.08
                );

            if (
                GameData.equipped &&
                GameData.equipped.bat
            ) {
                batColor =
                    uint(
                        GameData.equipped.bat.accent
                    );
            }

            if (
                GameData.equipped &&
                GameData.equipped.helmet
            ) {
                helmetColor =
                    uint(
                        GameData.equipped.helmet.accent
                    );
            }

            if (
                GameData.equipped &&
                GameData.equipped.belt
            ) {
                beltColor =
                    uint(
                        GameData.equipped.belt.accent
                    );
            }

            if (
                GameData.equipped &&
                GameData.equipped.shoes
            ) {
                shoesColor =
                    uint(
                        GameData.equipped.shoes.accent
                    );
            }

            if (
                GameData.equipped &&
                GameData.equipped.goggles
            ) {
                gogglesColor =
                    uint(
                        GameData.equipped.goggles.accent
                    );
            }

            mouseEnabled = false;
            mouseChildren = false;

            drawPlayer();
            addEventListener(Event.ENTER_FRAME, onFrame);
        }

        private function drawPlayer():void {
            graphics.beginFill(0x000000, 0.30);
            graphics.drawEllipse(-55, 48, 116, 22);
            graphics.endFill();

            bodyRoot = new Sprite();
            addChild(bodyRoot);

            backLeg = createLeg(false);
            backLeg.x = 14;
            backLeg.y = 2;
            backLeg.rotation = -4;
            bodyRoot.addChild(backLeg);

            frontLeg = createLeg(true);
            frontLeg.x = -18;
            frontLeg.y = 1;
            frontLeg.rotation = 5;
            bodyRoot.addChild(frontLeg);

            torso = new Sprite();
            torso.graphics.beginFill(0xf7f8f9);
            torso.graphics.drawRoundRect(-38, -48, 74, 65, 20, 20);
            torso.graphics.endFill();
            torso.graphics.lineStyle(2, 0xcfd7dd, 0.95);
            torso.graphics.drawRoundRect(-38, -48, 74, 65, 20, 20);
            torso.graphics.lineStyle();

            torso.graphics.beginFill(accentColor);
            torso.graphics.drawRoundRect(-39, -43, 17, 26, 8, 8);
            torso.graphics.drawRoundRect(20, -43, 17, 26, 8, 8);
            torso.graphics.drawRect(-4, -47, 8, 63);
            torso.graphics.endFill();

            torso.graphics.beginFill(beltColor);
            torso.graphics.drawRect(-32, 8, 63, 7);
            torso.graphics.endFill();

            torso.graphics.beginFill(0xcfa12e);
            torso.graphics.drawRoundRect(-5, 7, 10, 9, 2, 2);
            torso.graphics.endFill();

            torso.graphics.beginFill(VisualProfile.lighter(accentColor, 0.22), 0.92);
            torso.graphics.drawRoundRect(-20, -37, 40, 5, 3, 3);
            torso.graphics.endFill();

            var number:TextField = new TextField();
            var nf:TextFormat = new TextFormat("Arial", 18, accentColor, true);
            nf.align = TextFormatAlign.CENTER;
            number.defaultTextFormat = nf;
            number.text = String(jerseyNumber);
            number.width = 34;
            number.height = 24;
            number.x = -17;
            number.y = -27;
            number.mouseEnabled = false;
            torso.addChild(number);
            bodyRoot.addChild(torso);

            backArm = createArm(false);
            backArm.x = 22;
            backArm.y = -34;
            bodyRoot.addChild(backArm);

            head = createHead();
            head.x = -2;
            head.y = -81;
            bodyRoot.addChild(head);

            frontArm = createArm(true);
            frontArm.x = 19;
            frontArm.y = -39;
            bodyRoot.addChild(frontArm);

            trail = new Sprite();
            trail.visible = false;
            bodyRoot.addChild(trail);

            bat = new Sprite();
            bat.graphics.lineStyle(15, batColor, 1, true);
            bat.graphics.moveTo(0, 0);
            bat.graphics.lineTo(101, -3);
            bat.graphics.lineStyle(
                6,
                VisualProfile.lighter(
                    batColor,
                    0.28
                ),
                0.96,
                true
            );
            bat.graphics.moveTo(8, -1);
            bat.graphics.lineTo(88, -3);
            bat.graphics.lineStyle(3, 0xf3c98d, 0.72, true);
            bat.graphics.moveTo(18, -5);
            bat.graphics.lineTo(79, -7);
            bat.graphics.lineStyle();
            bat.x = 35;
            bat.y = -31;
            bat.filters = [new DropShadowFilter(2, 45, 0x000000, 0.35, 3, 3, 1)];
            bodyRoot.addChild(bat);

            resetPose();
        }

        private function createLeg(front:Boolean):Sprite {
            var leg:Sprite = new Sprite();
            leg.graphics.beginFill(0xf4f5f6);
            leg.graphics.drawRoundRect(-10, 0, 21, 55, 9, 9);
            leg.graphics.endFill();

            leg.graphics.beginFill(0xdce2e6);
            if (front) {
                leg.graphics.drawRoundRect(-9, 5, 7, 43, 4, 4);
            } else {
                leg.graphics.drawRoundRect(2, 5, 7, 43, 4, 4);
            }
            leg.graphics.endFill();

            leg.graphics.beginFill(accentColor);
            if (front) {
                leg.graphics.drawRect(-5, 8, 3, 39);
            } else {
                leg.graphics.drawRect(5, 8, 3, 39);
            }
            leg.graphics.endFill();

            leg.graphics.beginFill(shoesColor);
            if (front) {
                leg.graphics.drawRoundRect(-16, 47, 32, 14, 8, 8);
            } else {
                leg.graphics.drawRoundRect(-7, 47, 32, 14, 8, 8);
            }
            leg.graphics.endFill();
            return leg;
        }

        private function createArm(front:Boolean):Sprite {
            var arm:Sprite = new Sprite();
            arm.graphics.lineStyle(16, accentColor, 1);
            arm.graphics.moveTo(0, 0);
            arm.graphics.lineTo(14, 5);
            arm.graphics.lineStyle(13, skinColor, 1);
            arm.graphics.moveTo(13, 5);
            if (front) {
                arm.graphics.lineTo(39, 18);
            } else {
                arm.graphics.lineTo(35, 11);
            }
            arm.graphics.lineStyle();

            if (front) {
                arm.graphics.beginFill(0xf1f4f6);
                arm.graphics.drawCircle(42, 20, 7);
            } else {
                arm.graphics.beginFill(0x27333e);
                arm.graphics.drawCircle(38, 12, 7);
            }
            arm.graphics.endFill();
            return arm;
        }

        private function createHead():Sprite {
            var s:Sprite = new Sprite();

            s.graphics.beginFill(skinColor);
            s.graphics.drawRoundRect(-9, 20, 18, 23, 7, 7);
            s.graphics.endFill();
            s.graphics.beginFill(skinColor);
            s.graphics.drawCircle(-32, 2, 8);
            s.graphics.drawCircle(32, 2, 8);
            s.graphics.endFill();
            s.graphics.beginFill(skinColor);
            s.graphics.drawEllipse(-31, -30, 62, 67);
            s.graphics.endFill();

            s.graphics.beginFill(hairColor);
            s.graphics.drawRoundRect(-30, -3, 9, 28, 5, 5);
            s.graphics.drawRoundRect(21, -3, 9, 28, 5, 5);
            s.graphics.endFill();

            s.graphics.beginFill(helmetColor);
            s.graphics.drawEllipse(-34, -35, 68, 39);
            s.graphics.endFill();
            s.graphics.beginFill(helmetColor);
            s.graphics.drawRect(-33, -18, 64, 15);
            s.graphics.endFill();

            s.graphics.beginFill(VisualProfile.darker(accentColor, 0.17));
            s.graphics.drawRoundRect(-33, -6, 15, 28, 8, 8);
            s.graphics.endFill();

            s.graphics.beginFill(VisualProfile.lighter(accentColor, 0.42), 0.9);
            s.graphics.drawRoundRect(-22, -29, 31, 6, 4, 4);
            s.graphics.endFill();

            s.graphics.beginFill(accentColor);
            s.graphics.drawRoundRect(5, -16, 37, 8, 5, 5);
            s.graphics.endFill();

            if (gogglesColor != 0) {
                s.graphics.lineStyle(
                    3,
                    gogglesColor,
                    0.98
                );
                s.graphics.drawEllipse(
                    -20,
                    -1,
                    16,
                    13
                );
                s.graphics.drawEllipse(
                    4,
                    -1,
                    16,
                    13
                );
                s.graphics.moveTo(-4, 5);
                s.graphics.lineTo(4, 5);
                s.graphics.lineStyle();
            }

            s.graphics.beginFill(eyeColor);
            s.graphics.drawEllipse(-15, 2, 8, 10);
            s.graphics.drawEllipse(7, 2, 8, 10);
            s.graphics.endFill();

            s.graphics.beginFill(0xffffff, 0.92);
            s.graphics.drawCircle(-11, 4, 1.8);
            s.graphics.drawCircle(11, 4, 1.8);
            s.graphics.endFill();

            s.graphics.lineStyle(2, VisualProfile.darker(hairColor, 0.10));
            s.graphics.moveTo(-17, -2);
            s.graphics.lineTo(-7, -4);
            s.graphics.moveTo(7, -4);
            s.graphics.lineTo(17, -2);
            s.graphics.lineStyle();

            s.graphics.lineStyle(2, VisualProfile.darker(skinColor, 0.30), 0.75);
            s.graphics.moveTo(-7, 18);
            s.graphics.curveTo(0, 24, 9, 17);
            s.graphics.lineStyle();
            return s;
        }

        private function onFrame(e:Event):void {
            if (swinging) {
                animateSwingStep();
                return;
            }

            if (reaction != "") {
                animateReaction();
                return;
            }

            idlePhase += 0.055;

            var bob:Number =
                Math.sin(
                    idlePhase
                ) *
                1.6;

            var load:Number =
                Math.max(
                    0,
                    Math.min(
                        1,
                        (
                            pitchProgress -
                            0.28
                        ) /
                        0.55
                    )
                );

            // The Hero now visibly tracks and loads with the pitch instead
            // of holding a completely fixed bat until the click.
            bodyRoot.y =
                bob -
                load *
                1.8;

            bodyRoot.x =
                -load *
                2.5;

            torso.rotation =
                Math.sin(
                    idlePhase *
                    0.75
                ) *
                1.1 -
                load *
                4.5;

            head.rotation =
                Math.sin(
                    idlePhase *
                    0.65
                ) *
                1.4 +
                load *
                2.5;

            bat.rotation =
                -42 +
                Math.sin(
                    idlePhase *
                    0.72
                ) *
                2.5 -
                load *
                17;

            frontArm.rotation =
                6 +
                Math.sin(
                    idlePhase *
                    0.76
                ) *
                1.8 -
                load *
                7;

            backArm.rotation =
                -7 +
                Math.sin(
                    idlePhase *
                    0.70
                ) *
                1.5 -
                load *
                6;

            frontLeg.rotation =
                5 -
                load *
                9;

            backLeg.rotation =
                -4 +
                load *
                4;
        }

        public function setPitchProgress(
            value:Number
        ):void {
            pitchProgress = Math.max(
                0,
                Math.min(
                    1,
                    value
                )
            );
        }

        public function swing():void {
            if (swinging) return;
            swinging = true;
            swingFrame = 0;
            reaction = "";
            reactionFrame = 0;
            bodyRoot.y = 0;
        }

        private function animateSwingStep():void {
            swingFrame++;
            var total:int = 27;
            var p:Number = swingFrame / total;

            if (p < 0.22) {
                var load:Number = p / 0.22;
                bodyRoot.x = -load * 5;
                torso.rotation = -load * 8;
                head.rotation = load * 3;
                frontLeg.rotation = 5 - load * 8;
                backLeg.rotation = -4 + load * 5;
                bat.rotation = -42 - load * 24;
                frontArm.rotation = 6 - load * 11;
                backArm.rotation = -7 - load * 9;
                trail.visible = false;
            } else if (p < 0.50) {
                var hit:Number = (p - 0.22) / 0.28;
                var ease:Number = hit * hit * (3 - 2 * hit);
                bodyRoot.x = -5 + ease * 12;
                torso.rotation = -8 + ease * 28;
                head.rotation = 3 + ease * 7;
                frontLeg.rotation = -3 + ease * 8;
                backLeg.rotation = 1 - ease * 10;
                bat.rotation = -66 + ease * 205;
                frontArm.rotation = -5 + ease * 37;
                backArm.rotation = -16 + ease * 26;
                updateTrail(ease);
            } else if (p < 0.80) {
                var follow:Number = (p - 0.50) / 0.30;
                bodyRoot.x = 7 + follow * 3;
                torso.rotation = 20 - follow * 8;
                head.rotation = 10 - follow * 5;
                frontLeg.rotation = 5 + follow * 5;
                backLeg.rotation = -9 + follow * 4;
                bat.rotation = 139 + follow * 46;
                frontArm.rotation = 32 + follow * 18;
                backArm.rotation = 10 + follow * 13;
                trail.alpha = 0.65 * (1 - follow);
            } else {
                var recover:Number = (p - 0.80) / 0.20;
                bodyRoot.x = 10 * (1 - recover);
                torso.rotation = 12 * (1 - recover);
                head.rotation = 5 * (1 - recover);
                frontLeg.rotation = 10 - recover * 5;
                backLeg.rotation = -5 + recover;
                bat.rotation = 185 - recover * 227;
                frontArm.rotation = 50 - recover * 44;
                backArm.rotation = 23 - recover * 30;
                trail.alpha = 0;
            }

            if (swingFrame >= total) {
                swinging = false;
                resetPose();
            }
        }

        private function updateTrail(strength:Number):void {
            trail.graphics.clear();
            trail.graphics.lineStyle(14, 0xffdf78, 0.18);
            trail.graphics.moveTo(28, -34);
            trail.graphics.curveTo(72, -75, 115, -7);
            trail.graphics.lineStyle(5, 0xffffff, 0.55);
            trail.graphics.moveTo(37, -38);
            trail.graphics.curveTo(79, -61, 110, -5);
            trail.graphics.lineStyle();
            trail.visible = true;
            trail.alpha = Math.min(0.88, 0.35 + strength * 0.65);
        }

        public function queueReaction(result:String):void {
            reaction = result ? result : "";
            reactionFrame = 0;
        }

        private function animateReaction():void {
            reactionFrame++;
            var p:Number = reactionFrame / 30.0;

            if (reaction == "HOME RUN" || reaction == "TRIPLE" || reaction == "DOUBLE" || reaction == "SINGLE") {
                bodyRoot.y = -Math.abs(Math.sin(p * Math.PI * 2)) * 5;
                bodyRoot.rotation = Math.sin(p * Math.PI * 2) * 4;
                bat.rotation = -12 + Math.sin(p * Math.PI) * 18;
            } else if (reaction == "STRIKEOUT" || reaction == "OUT") {
                head.rotation = 12 * Math.sin(p * Math.PI);
                torso.rotation = -5 * Math.sin(p * Math.PI);
                bat.rotation = -42 + 18 * Math.sin(p * Math.PI);
            } else if (reaction == "WALK") {
                bodyRoot.x = Math.sin(p * Math.PI * 2) * 2;
                head.rotation = -4 * Math.sin(p * Math.PI);
            }

            if (reactionFrame >= 30) {
                reaction = "";
                reactionFrame = 0;
                resetPose();
            }
        }

        private function resetPose():void {
            bodyRoot.x = 0;
            bodyRoot.y = 0;
            bodyRoot.rotation = 0;
            torso.rotation = 0;
            head.rotation = 0;
            frontLeg.rotation = 5;
            backLeg.rotation = -4;
            frontArm.rotation = 6;
            backArm.rotation = -7;
            bat.rotation = -42;
            trail.visible = false;
            trail.alpha = 0;
            pitchProgress = 0;
        }

        public function dispose():void {
            removeEventListener(Event.ENTER_FRAME, onFrame);
            swinging = false;
            reaction = "";
        }
    }
}
