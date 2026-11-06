package com.bh.ui {
    import flash.text.TextField;
    import flash.text.TextFormat;
    /** Spanish help only. Model descriptions and saved reward rules keep their original values. */
    public class HelpText {
        private static var entries:Object={
  "Widens the good contact window.": "Amplía el margen para lograr un buen contacto.",
  "Increases power and the chance to score on solid contact.": "Mejora la potencia y la posibilidad de anotar al conectar bien.",
  "Boosts contact and power from the third inning when you are not ahead.": "Mejora contacto y potencia desde la 3.ª entrada si no vas ganando.",
  "Reduces the opposing team's scoring pressure.": "Reduce la capacidad de anotar del rival.",
  "Turns more near misses into fouls; does not widen PERFECT.": "Convierte más fallos cercanos en foul. El margen PERFECT no cambia.",
  "Favors doubles after a successful hit.": "Favorece los doubles después de conectar un hit.",
  "Hero hits charge more team combo.": "Los hits del héroe aportan más COMBO al equipo.",
  "Enables Lucky Hit after a successful hit. Does not turn an out into a hit.": "Activa Lucky Hit tras un hit. No convierte un out en hit.",
  "Contact specialization with a larger bonus per rank.": "Especialidad de contacto con más bono por nivel.",
  "Power specialization for longer hits.": "Especialidad de potencia para hits más largos.",
  "Favors triples after a successful hit.": "Favorece los triples después de conectar un hit.",
  "Defense specialization to reduce the opponent's scoring.": "Especialidad defensiva para reducir las carreras del rival.",
  "FOUL WINDOW +12% / +24% / +36%": "MARGEN DE FOUL +12% / +24% / +36%",
  "DOUBLE CHANCE +3% / +6% / +9%": "POSIBILIDAD DE DOUBLE +3% / +6% / +9%",
  "COMBO +1 / +2 / +3 per hit": "COMBO +1 / +2 / +3 por hit",
  "LUCKY EFFECT 8% / 16% / 24%": "EFECTO LUCKY 8% / 16% / 24%",
  "TRIPLE CHANCE +2% / +4% / +6%": "POSIBILIDAD DE TRIPLE +2% / +4% / +6%",
  "Finish the match.": "Termina el partido.",
  "Win the match.": "Gana el partido.",
  "Your hero drives in at least 3 runs.": "Tu héroe debe conseguir al menos 3 RBI.",
  "Lead your team in RBI, then home runs and hits.": "Lidera tu equipo en RBI; en empate cuentan home runs y hits.",
  "A batter on your team drives in at least 3 runs.": "Un bateador de tu equipo debe conseguir al menos 3 RBI.",
  "Finish with RANK S.": "Termina con RANK S.",
  "Earn GAME, WINNER, MVP and RANK S in the same match.": "Consigue GAME, WINNER, MVP y RANK S en el mismo partido."
};
        public static function es(value:String):String {
            if(value==null)return "";
            if(entries[value]!==undefined)return String(entries[value]);
            if(value.indexOf("Requires level ")==0)return "Requiere nivel "+value.substr(15);
            return value;
        }
        public static function fit(field:TextField,normal:int,minimum:int):void {
            var format:TextFormat=field.defaultTextFormat;
            for(var size:int=normal;size>=minimum;size--){format.size=size;field.defaultTextFormat=format;field.setTextFormat(format);if(field.textHeight<=field.height-3&&field.textWidth<=field.width-3)break;}
        }
    }
}
