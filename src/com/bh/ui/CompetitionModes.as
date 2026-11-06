package com.bh.ui {
    import com.bh.model.GameData;
    import com.bh.model.PostSeason;
    /** Read-only descriptions of existing competitions. Never creates a bracket,
     * advances a season, reserves a match or spends an account resource. */
    public class CompetitionModes {
        public static function nextSpecial():Object {
            if(!GameData.seasonComplete)for(var n:int=Math.max(1,GameData.seasonGame);n<=30;n++)if(GameData.seasonEventType(n)=="SPECIAL")return {season:GameData.seasonNumber,game:n};
            return {season:GameData.seasonNumber+1,game:12};
        }
        private static function mode(id:String,title:String,status:String,enabled:Boolean,action:String,hint:String,detail:String):Object {
            return {id:id,title:title,status:status,enabled:enabled,action:action,hint:hint,detail:detail};
        }
        public static function catalog():Array {
            var post:Object=GameData.postSeason,samePost:Boolean=post&&int(post.season)==GameData.seasonNumber;
            var postActive:Boolean=GameData.postSeasonInProgress(),postPaid:Boolean=GameData.pendingPostSeasonPayment();
            var regularPaid:Boolean=GameData.pendingSpecialMatch()&&!postPaid;
            var specialNow:Boolean=!GameData.seasonComplete&&GameData.seasonEventType(GameData.seasonGame)=="SPECIAL"&&!postPaid;
            var upcoming:Object=nextSpecial(),season:String="SEASON "+GameData.seasonNumber+"  ·  GAME "+Math.min(30,GameData.seasonGame)+" / 30";
            var fee:String=regularPaid?"PAID MATCH · NO EXTRA ENERGY":"MATCH COST: 5 ENERGY";
            var regular:Object=mode("opening","REGULAR SEASON",postActive||postPaid?"POST SEASON":regularPaid?"RESUME":GameData.seasonComplete?"SEASON COMPLETE":"GAME "+GameData.seasonGame+" / 30",!postActive&&!postPaid,GameData.seasonComplete?"NEXT SEASON":regularPaid?"RESUME SEASON":"OPEN SEASON",
                postActive||postPaid?"Tienes una postemporada pendiente. Entra a POST SEASON para continuar antes de comenzar otra temporada.":GameData.seasonComplete?"La temporada terminó. Puedes revisar su cierre y preparar la siguiente sin perder tu carrera.":regularPaid?"Ya pagaste este partido. Volver a entrar conserva la reserva de energía, cartas y bate; el encuentro empieza de nuevo.":"Revisa el calendario, viaja al rival y prepara la alineación. La energía se cobra al iniciar el partido, no al abrir este menú.",season+"\nRECORD "+GameData.seasonRecord()+"   ·   "+fee);
            var postReady:Boolean=(samePost||postActive)&&!regularPaid;
            var postStatus:String=regularPaid?"MATCH IN PROGRESS":samePost?(post.status=="active"?"IN PROGRESS":post.status=="champion"?"CHAMPION":"COMPLETE"):postActive?"QUALIFIED":"QUALIFY FIRST";
            var postDetail:String="TOP FOUR AFTER 30 GAMES";
            if(samePost){var series:Object=PostSeason.activeSeries(post);postDetail=PostSeason.label(post);if(series)postDetail+="\nSERIES "+(series.home==post.hero?series.homeWins:series.awayWins)+" - "+(series.home==post.hero?series.awayWins:series.homeWins)+"   ·   FIRST TO 3";else postDetail+="\n"+(post.status=="champion"?"WORLD CHAMPION":"POST SEASON COMPLETE");}
            else if(postActive)postDetail="SEED "+GameData.lastSeasonSummary.rank+"   ·   8 TEAMS";
            var postseason:Object=mode("postseason","POST SEASON",postStatus,postReady,samePost&&post.status!="active"?"VIEW BRACKET":"OPEN BRACKET",
                regularPaid?"Termina el partido de temporada que tienes reservado antes de abrir otra competición.":postReady?(postPaid?"Tienes un partido de postemporada pagado. Puedes reabrirlo sin gastar más energía ni cartas.":samePost&&post.status!="active"?"Revisa el cuadro y los resultados de esta postemporada. Tu título o eliminación ya quedaron guardados.":"Continúa tu cuadro de eliminatorias. Abrir esta ficha no crea rivales ni cambia los resultados; el cuadro se abre al pulsar el botón."):"Termina los 30 partidos entre los cuatro primeros para clasificar. La ficha muestra el requisito y no inicia otro modo.",postDetail);
            var special:Object=mode("special","SPECIAL MATCH",specialNow?(regularPaid?"RESUME SPECIAL":"READY"):"NEXT: S"+upcoming.season+" GAME "+upcoming.game,specialNow,regularPaid?"RESUME SPECIAL":"OPEN SPECIAL",
                specialNow?(regularPaid?"Este SPECIAL ya está pagado. Reabrirlo no vuelve a gastar energía ni cartas.":"El siguiente encuentro del calendario es SPECIAL. Revisa la alineación antes de jugar por su premio de victoria o derrota."):"SPECIAL forma parte del calendario. No puedes saltar partidos para entrar: continúa la temporada hasta el próximo evento indicado.",specialNow?season+"\nWIN: MYSTERY BOX  ·  LOSE: +500 COINS":"NEXT: SEASON "+upcoming.season+"  ·  GAME "+upcoming.game+"\nCONTINUE REGULAR SEASON");
            return [regular,mode("home_run_derby","HOME RUN DERBY","10 PITCHES",true,"PLAY DERBY","Juega diez pichadas con tu héroe y tu estadio. No consume energía. Puedes pausar con P; el premio se aplica una vez al terminar la ronda.","10 PITCHES  ·  NO ENERGY COST\n300 COINS PER HOME RUN"),postseason,special,
                mode("rival","RIVAL / FRIENDS","PRIVATE LEAGUE",true,"OPEN FRIENDS","Reta al equipo publicado por un amigo o entra a vuestra liga privada. El rival se controla por simulación y podéis jugar a distintas horas.","FRIEND CHALLENGES\nASYNCHRONOUS PRIVATE LEAGUE"),
                mode("allstar","ALL STAR","COMING SOON",false,"UNAVAILABLE","Este modo todavía no está reconstruido. La ficha no consume energía ni abre un partido de otro tipo.","NOT AVAILABLE YET"),
                mode("world_match","WORLD MATCH","COMING SOON",false,"UNAVAILABLE","Falta confirmar sus reglas con una referencia suficiente. La ficha permite reconocer el modo, pero no simula que ya esté disponible.","NOT AVAILABLE YET")];
        }
        public static function byId(id:String):Object {for each(var entry:Object in catalog())if(entry.id==id)return entry;return null;}
    }
}
