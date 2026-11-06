package com.bh.game {
    import flash.display.Sprite;
    import flash.filters.GlowFilter;

    public class BattingCursor extends Sprite {
        private var targetRadius:Number;
        private var active:Boolean = false;
        private var pitchProgress:Number = 0;

        private var showAt:Number = 0.54;
        private var idealAt:Number = BattingSystem.IDEAL_CONTACT;
        private var startRadius:Number = 104;
        private var revealAlpha:Number = 1;
        private var rookie:Boolean=false,guideWindow:Number=.07;

        public function BattingCursor(
            px:Number,
            py:Number,
            r:Number = 24
        ) {
            super();

            x = px;
            y = py;
            targetRadius = r;

            mouseEnabled = false;
            mouseChildren = false;
            visible = false;

        }

        public function setTarget(
            px:Number,
            py:Number
        ):void {
            x = px;
            y = py;
        }

        public function setRadius(
            value:Number
        ):void {
            targetRadius = Math.max(
                17,
                Math.min(
                    31,
                    value
                )
            );
        }

        public function configureForPitch(
            contact:int,
            pitcherRating:int,
            leagueIndex:int,
            pitchType:String,
            pitchSeconds:Number=1
        ):void {
            contact = Math.max(
                40,
                Math.min(
                    99,
                    contact
                )
            );

            pitcherRating = Math.max(
                55,
                Math.min(
                    99,
                    pitcherRating
                )
            );

            leagueIndex = Math.max(
                0,
                Math.min(
                    4,
                    leagueIndex
                )
            );

            var pitcherFactor:Number =
                Math.max(
                    0,
                    pitcherRating - 65
                ) /
                34.0;

            // The uploaded gameplay shows the reticle becoming useful in
            // the second half of flight rather than revealing the endpoint
            // immediately at release.
            showAt =
                0.50 +
                pitcherFactor *
                0.075 +
                leagueIndex *
                0.012;

            if (
                pitchType == "SLIDER" ||
                pitchType == "CURVEBALL"
            ) {
                showAt += 0.018;
            }
            else if (
                pitchType == "CHANGEUP"
            ) {
                showAt += 0.010;
            }

            // Strong Contact makes recognition slightly easier.
            showAt -=
                Math.max(
                    0,
                    contact - 70
                ) *
                0.00055;

            showAt = Math.max(
                0.49,
                Math.min(
                    0.66,
                    showAt
                )
            );

            rookie=leagueIndex==0;
            if(rookie)showAt=.30;
            guideWindow=new BattingSystem().goodWindowSeconds(contact,pitcherRating,leagueIndex)/Math.max(.1,pitchSeconds);

            startRadius =
                110 +
                pitcherFactor *
                18;
        }

        public function setTimingProgress(
            value:Number
        ):void {
            pitchProgress = Math.max(
                0,
                Math.min(
                    1,
                    value
                )
            );

            drawCursor();
        }

        private function drawCursor():void {
            graphics.clear();

            if (
                !active ||
                pitchProgress <
                showAt
            ) {
                visible = false;
                return;
            }

            visible = true;
            alpha=.97+Math.sin(pitchProgress*Math.PI*10)*.03;

            var p:Number =
                (
                    pitchProgress -
                    showAt
                ) /
                (
                    idealAt -
                    showAt
                );

            p = Math.max(
                0,
                Math.min(
                    1,
                    p
                )
            );

            var eased:Number = p;
            var ready:Boolean=rookie&&Math.abs(pitchProgress-idealAt)<=guideWindow;
            var cue:uint=ready?0x91f55d:0x48ddea;

            var outerRadius:Number =
                startRadius +
                (
                    targetRadius -
                    startRadius
                ) *
                eased;

            revealAlpha = Math.min(
                1,
                (
                    pitchProgress -
                    showAt
                ) /
                0.07
            );

            graphics.beginFill(
                cue,
                0.025 *
                revealAlpha
            );
            graphics.drawCircle(
                0,
                0,
                outerRadius
            );
            graphics.endFill();

            graphics.lineStyle(
                3,
                cue,
                0.66 *
                revealAlpha
            );
            graphics.drawCircle(
                0,
                0,
                outerRadius
            );

            graphics.beginFill(
                0xf5e934,
                0.085 *
                revealAlpha
            );
            graphics.drawCircle(
                0,
                0,
                targetRadius
            );
            graphics.endFill();

            graphics.lineStyle(
                3,
                ready?0x91f55d:0xe9e034,
                0.92 *
                revealAlpha
            );
            graphics.drawCircle(
                0,
                0,
                targetRadius
            );

            // The reference has a soft yellow target, without a game-drawn crosshair.
            graphics.lineStyle(1,0xd8fff4,.50*revealAlpha);
            graphics.drawCircle(0,0,outerRadius+2);
            graphics.lineStyle();

            graphics.beginFill(
                0xffffff,
                0.92 *
                revealAlpha
            );
            graphics.drawCircle(
                0,
                0,
                2.2
            );
            graphics.endFill();

            // Brief bright convergence cue at the ideal instant.
            if (
                Math.abs(
                    pitchProgress -
                    idealAt
                ) <
                0.018
            ) {
                graphics.lineStyle(
                    4,
                    0xffffff,
                    0.90
                );
                graphics.drawCircle(
                    0,
                    0,
                    targetRadius +
                    4
                );
            }

            filters = [
                new GlowFilter(
                    0x59e8f2,
                    0.34,
                    8,
                    8,
                    1.3,
                    1
                )
            ];
        }

        public function setActive(
            value:Boolean
        ):void {
            active = value;

            if (!active) {
                visible = false;
            }
            else {
                drawCursor();
            }
        }

        public function dispose():void {
            active=false;visible=false;graphics.clear();filters=[];
        }
    }
}
