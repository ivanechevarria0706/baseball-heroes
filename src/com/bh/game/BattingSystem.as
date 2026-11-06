package com.bh.game {
    public class BattingSystem {
        public static const IDEAL_CONTACT:Number = 0.925;

        public function BattingSystem() {}

        public function targetRadiusForContact(
            contact:int
        ):Number {
            contact = Math.max(
                40,
                Math.min(
                    99,
                    contact
                )
            );

            // Contact enlarges the yellow sweet-spot slightly, but never
            // turns the mechanic into an automatic hit.
            return 18 +
                   (contact - 40) *
                   0.12;
        }

        public function timingDifficulty(
            pitcherRating:int = 70,
            leagueIndex:int = 0
        ):Number {
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

            var ratingPenalty:Number =
                Math.max(
                    0,
                    pitcherRating - 65
                ) *
                0.0042;

            var leaguePenalty:Number =
                leagueIndex *
                0.055;

            return Math.max(
                0.64,
                (leagueIndex==0?1.30:leagueIndex==1?1.22:1.0) -
                ratingPenalty -
                leaguePenalty
            );
        }

        public function evaluateTiming(
            t:Number,
            contact:int = 75,
            pitcherRating:int = 70,
            leagueIndex:int = 0,
            pitchSeconds:Number = 1,
            foulTolerance:Number = 0
        ):String {
            if (t < 0) {
                return "MISS";
            }

            contact = Math.max(
                40,
                Math.min(
                    99,
                    contact
                )
            );

            var difficulty:Number =
                timingDifficulty(
                    pitcherRating,
                    leagueIndex
                );

            var error:Number =
                Math.abs(
                    t -
                    IDEAL_CONTACT
                ) * Math.max(.1,pitchSeconds);

            // Windows are seconds, independent of flight duration. The exact
            // historical acceptance windows remain unconfirmed. Good contact depends on
            // reading speed/movement and clicking in a noticeably small
            // timing window. Higher Contact helps without trivializing it.
            var perfectWindow:Number =
                (
                    (leagueIndex==0?0.021:0.014) +
                    (contact - 40) *
                    0.00010
                ) *
                difficulty;

            var goodWindow:Number = goodWindowSeconds(contact,pitcherRating,leagueIndex);

            var foulWindow:Number =
                (
                    (leagueIndex==0?0.087:0.071) +
                    (contact - 40) *
                    0.00023
                ) *
                difficulty;

            if (
                error <=
                perfectWindow
            ) {
                return "PERFECT";
            }

            if (
                error <=
                goodWindow
            ) {
                return "GOOD";
            }

            if (
                error <=
                foulWindow*(1+Math.max(0,Math.min(.36,foulTolerance)))
            ) {
                return "FOUL";
            }

            return "MISS";
        }

        public function timingQuality(
            t:Number,
            contact:int = 75,
            pitcherRating:int = 70,
            leagueIndex:int = 0,
            pitchSeconds:Number = 1
        ):Number {
            contact = Math.max(
                40,
                Math.min(
                    99,
                    contact
                )
            );

            var difficulty:Number =
                timingDifficulty(
                    pitcherRating,
                    leagueIndex
                );

            var usableWindow:Number =
                (
                    (leagueIndex==0?0.118:0.095) +
                    (contact - 40) *
                    0.00018
                ) *
                difficulty;

            var error:Number =
                Math.abs(
                    t -
                    IDEAL_CONTACT
                ) * Math.max(.1,pitchSeconds);

            return Math.max(
                0,
                Math.min(
                    1,
                    1 -
                    error /
                    usableWindow
                )
            );
        }

        /** Shared by scoring and the Rookie ring, so green always means valid contact. */
        public function goodWindowSeconds(contact:int=75,pitcherRating:int=70,leagueIndex:int=0):Number {
            contact=Math.max(40,Math.min(99,contact));
            return ((leagueIndex==0?.049:.037)+(contact-40)*.00016)*timingDifficulty(pitcherRating,leagueIndex);
        }

        public static function flightDeadline(seconds:Number,league:int):Number {
            // Rookie keeps the short late-contact allowance visible after the plate.
            return league==0?Math.max(1,IDEAL_CONTACT+.18/Math.max(.1,seconds)):1;
        }

        public function timingLabel(
            t:Number, pitchSeconds:Number = 1
        ):String {
            if (
                Math.abs(
                    t -
                    IDEAL_CONTACT
                ) * Math.max(.1,pitchSeconds) <=
                0.034
            ) {
                return "NICE!";
            }

            return t <
                   IDEAL_CONTACT
                   ? "EARLY SWING"
                   : "LATE SWING";
        }
    }
}
