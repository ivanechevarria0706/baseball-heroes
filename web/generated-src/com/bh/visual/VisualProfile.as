package com.bh.visual {
    public class VisualProfile {
        private static const SKINS:Array = [
            0xf0bd94, 0xe6ad82, 0xd99a70, 0xc98660, 0xf3c8a5, 0xa86d4b, 0x875034, 0x633c2b
        ];

        private static const HAIRS:Array = [
            0x211a18, 0x3a281e, 0x5a3924, 0x1b2027, 0x6a4a2f,
            0xe0b53e, 0xb13d34, 0x244f8c, 0xf3f3f0, 0x6b3a87,
            0xffe780, 0xffc04a, 0xef7f24, 0x942c23, 0x82521f,
            0x207cb2, 0x309443, 0x8445b7, 0xd95d9b, 0xa0a6ac
        ];

        private static const EYES:Array = [
            0x17202a, 0x304f66, 0x5a3c2a, 0x2d6d44, 0x7b4f92,
            0x668aa6, 0x34241b, 0x111111
        ];

        public static function palette(kind:String):Array {
            return (kind=="skin"?SKINS:kind=="hair"?HAIRS:EYES).concat();
        }

        public static function seed(name:String):int {
            if (!name) return 7;

            var value:int = 17;
            for (var i:int = 0; i < name.length; i++) {
                value = (value * 31 + name.charCodeAt(i)) & 0x7fffffff;
            }
            return value;
        }

        public static function skin(
            name:String,
            appearance:Object = null
        ):uint {
            if (
                appearance &&
                appearance.skinColor !== undefined
            ) {
                return uint(
                    SKINS[
                        Math.abs(
                            int(appearance.skinColor)
                        ) %
                        SKINS.length
                    ]
                );
            }

            var s:int = seed(name);
            return uint(SKINS[s % SKINS.length]);
        }

        public static function hair(
            name:String,
            appearance:Object = null
        ):uint {
            if (
                appearance &&
                appearance.hairColor !== undefined
            ) {
                return uint(
                    HAIRS[
                        Math.abs(
                            int(appearance.hairColor)
                        ) %
                        HAIRS.length
                    ]
                );
            }

            var s:int = seed(name);
            // Legacy players without a saved appearance retain their original color.
            return uint(HAIRS[(int(s / 7) + s) % 10]);
        }

        public static function eyeColor(
            name:String,
            appearance:Object = null
        ):uint {
            if (
                appearance &&
                appearance.eyeColor !== undefined
            ) {
                return uint(
                    EYES[
                        Math.abs(
                            int(appearance.eyeColor)
                        ) %
                        EYES.length
                    ]
                );
            }

            var s:int = seed(name);
            if (s % 5 == 0) return 0x304f66;
            if (s % 4 == 0) return 0x5a3c2a;
            return 0x17202a;
        }

        public static function darker(color:uint, amount:Number = 0.22):uint {
            amount = Math.max(0, Math.min(0.85, amount));

            var r:int = int(((color >> 16) & 0xff) * (1 - amount));
            var g:int = int(((color >> 8) & 0xff) * (1 - amount));
            var b:int = int((color & 0xff) * (1 - amount));

            return uint((r << 16) | (g << 8) | b);
        }

        public static function lighter(color:uint, amount:Number = 0.22):uint {
            amount = Math.max(0, Math.min(0.85, amount));

            var cr:int = (color >> 16) & 0xff;
            var cg:int = (color >> 8) & 0xff;
            var cb:int = color & 0xff;

            var r:int = int(cr + (255 - cr) * amount);
            var g:int = int(cg + (255 - cg) * amount);
            var b:int = int(cb + (255 - cb) * amount);

            return uint((r << 16) | (g << 8) | b);
        }
    }
}
