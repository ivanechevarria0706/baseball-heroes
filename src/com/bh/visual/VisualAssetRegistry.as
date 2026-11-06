package com.bh.visual {
    public class VisualAssetRegistry {
        /** The supplied portraits are crops of these same 11_09 characters. */
        public static function playerSpriteFrame(playerName:String):int {
            var frames:Object={andrew:4,benjamin:5,julia:6,kevin:7,michelle:8,michael:9,carlos:10,ryan:11,sam:12,noah:13,leo:14};
            var key:String=playerName.toLowerCase();if(frames[key]!==undefined)return int(frames[key]);
            var hash:int=0;for(var i:int=0;i<key.length;i++)hash+=key.charCodeAt(i);return hash%32;
        }
        private static const ROOT:String =
            "assets/reference/";

        public static function teamLogoPath(
            city:String
        ):String {
            var key:String = normalizeCity(city);

            var map:Object = {
                "COLORADO":"colorado.png",
                "BALTIMORE":"baltimore.png",
                "LOS ANGELES":"los_angeles_a.png",
                "NEW YORK":"new_york.png",
                "SEATTLE":"seattle.png",
                "OAKLAND":"oakland.png",
                "PITTSBURGH":"pittsburgh.png",
                "ARIZONA":"arizona.png",
                "CINCINNATI":"cincinnati.png",
                "CLEVELAND":"cleveland.png",
                "DETROIT":"detroit.png",
                "SAINT LOUIS":"saint_louis.png",
                "ST LOUIS":"saint_louis.png",
                "MINNESOTA":"minnesota.png",
                "TAMPA BAY":"tampa_bay.png",
                "BOSTON":"boston.png",
                "KANSAS CITY":"kansas_city.png",
                "TEXAS":"texas.png",
                "MILWAUKEE":"milwaukee.png",
                "MIAMI":"miami.png",
                "SAN FRANCISCO":"san_francisco.png",
                "SAN DIEGO":"san_diego.png",
                "WASHINGTON":"washington.png",
                "CHICAGO":"chicago.png",
                "ATLANTA":"atlanta.png",
                "TORONTO":"toronto.png",
                "HOUSTON":"houston.png",
                "PHILADELPHIA":"philadelphia.png"
            };

            if (map[key] === undefined) {
                return "";
            }

            return ROOT +
                   "team_logos/" +
                   String(map[key]);
        }

        public static function leagueBadgePath(
            leagueIndex:int
        ):String {
            var names:Array = [
                "rookie.png",
                "single_a.png",
                "double_a.png",
                "triple_a.png",
                "major.png"
            ];

            leagueIndex = Math.max(
                0,
                Math.min(
                    names.length - 1,
                    leagueIndex
                )
            );

            return ROOT +
                   "league_badges/" +
                   names[leagueIndex];
        }

        public static function stadiumPath(
            backgroundId:String
        ):String {
            var map:Object = {
                "stadium_background_mountain095":"rookie_mountain095.png",
                "stadium_background_civic095":"civic_park095.png",
                "stadium_background_ocean":"treasure_island.png",
                "stadium_background_city":"major_city.png",
                "stadium_background_triplea":"triplea_liberty.png",
                "stadium_background_holiday":"holiday_park.png",
                "stadium_background_devil":"devil_castle.png",
                "stadium_background_major_night":"major_night.png"
            };

            if (
                !backgroundId ||
                map[backgroundId] === undefined
            ) {
                return "";
            }

            return ROOT +
                   "stadiums/" +
                   String(map[backgroundId]);
        }


        public static function playerPortraitPath(
            playerName:String
        ):String {
            if (!playerName) return "";

            var key:String =
                playerName.toLowerCase();

            var map:Object = {
                "andrew":"andrew.png",
                "benjamin":"benjamin.png",
                "julia":"julia.png",
                "kevin":"kevin.png",
                "michelle":"michelle.png",
                "michael":"michael.png",
                "carlos":"carlos.png",
                "ryan":"ryan.png",
                "sam":"sam.png",
                "noah":"noah.png",
                "leo":"leo.png"
            };

            if (map[key] === undefined) {
                return "";
            }

            return ROOT +
                   "player_portraits/" +
                   String(map[key]);
        }

        public static function cardPackPath(
            packId:String
        ):String {
            if (!packId) return "";

            var map:Object = {
                "single_a":"single_a.png",
                "double_a":"double_a.png",
                "triple_a":"triple_a.png",
                "major":"major.png",
                "special_match":"special_match.png",
                "national_league":"national_league.png",
                "american_league":"american_league.png",
                "heroes":"heroes.png"
            };

            if (map[packId] === undefined) {
                return "";
            }

            return ROOT +
                   "card_packs/" +
                   String(map[packId]);
        }

        public static function leagueCardPackPath(
            leagueIndex:int
        ):String {
            var ids:Array = [
                "single_a",
                "single_a",
                "double_a",
                "triple_a",
                "major"
            ];

            leagueIndex = Math.max(
                0,
                Math.min(
                    ids.length - 1,
                    leagueIndex
                )
            );

            return cardPackPath(
                String(ids[leagueIndex])
            );
        }

        public static function modeIconPath(
            modeId:String
        ):String {
            if (!modeId) return "";

            var map:Object = {
                "rookie":"rookie.png",
                "single_a":"single_a.png",
                "double_a":"double_a.png",
                "triple_a":"triple_a.png",
                "major":"major.png",
                "opening":"opening.png",
                "rival":"rival.png",
                "postseason":"postseason.png",
                "allstar":"allstar.png",
                "special":"special.png",
                "world_match":"world_match.png",
                "home_run_derby":"home_run_derby.png"
            };

            if (map[modeId] === undefined) {
                return "";
            }

            return ROOT +
                   "mode_icons/" +
                   String(map[modeId]);
        }

        public static function transportPath(
            leagueIndex:int
        ):String {
            var names:Array = [
                "rookie_bus.png",
                "single_a_bus.png",
                "double_a_bus.png",
                "triple_a_plane.png",
                "major_plane.png"
            ];

            leagueIndex = Math.max(
                0,
                Math.min(
                    names.length - 1,
                    leagueIndex
                )
            );

            return ROOT +
                   "transports/" +
                   names[leagueIndex];
        }

        public static function celebrationPath(
            index:int
        ):String {
            index = Math.max(
                1,
                Math.min(
                    7,
                    index
                )
            );

            var suffix:String =
                index < 10
                ? "0" + index
                : String(index);

            return ROOT +
                   "celebrations/celebration_" +
                   suffix +
                   ".png";
        }

        private static function normalizeCity(
            city:String
        ):String {
            if (!city) return "";

            var value:String =
                city.toUpperCase();

            value = value.split(".").join("");
            value = value.split("  ").join(" ");

            return value;
        }
    }
}
