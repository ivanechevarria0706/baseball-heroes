# Baseball Heroes 1.0.46

Publicado y verificado en Railway. El autojuego utiliza el cuerpo aprobado de diez poses mediante MatchBatterSprite, con la cara del bateador y emblema del equipo que ataca. La vista pasa a 224×248 con un campo ilustrado propio, generado mediante la herramienta integrada; PNG y prompt exacto en assets/sprites/v1046. Se miden las bases del fondo para alinear trayectos y posiciones. Se reubican tarjetas y diamante para dejar espacio.

AutoplayFieldScene representa los before/after del motor: corredores existentes y bateador avanzan a las bases resueltas, sin modificar estado de carrera. Preparación y swing se separan; la pelota parte del barrel aprobado. Recoger, preparar tiro, lanzar y recibir tienen poses y señales de audio por fase, sin duplicación. La pausa usa el mismo reloj del panel y reset restaura cada posición. Los corredores ajustan la cabeza a escala .78.

MatchRosterIdentity centraliza el algoritmo rival existente sin cambiar sus resultados. Game, panel y estadísticas comparten la misma alineación; pitcher, fielders y HitCinematic reciben identidad real. ReferenceBatterArtwork admite equipo visitante conservando sus valores predeterminados para el héroe.

Ball mejora tamaño inicial, borde y estela. Se comparan 605 muestras entre las cinco trayectorias con la clase anterior: x/y idénticos. GameData, PitchCadence, BattingSystem, SwingMotion, HeroSprite, HeroHead, retrato Ohtani/Judge, hoja nativa del bateador, sonidos y servidor no cambian.

Tres suites locales: jugadas/actores/pausa/cues y coordenadas; recorrido con WebMain final; nueve entradas con estadísticas conciliadas y avance único. Recorrido de WebMain final en Railway y hashes del paquete publicados. Respaldo consistente y comparación de perfiles, guardados y resets dentro del servidor. Se retira sólo QA. No hay reinicio de datos. La compilación inicial de 1.0.46 queda como rollback en el volumen; las versiones 1.0.44 y 1.0.45 se archivan localmente tras verificar todos sus archivos.

Build 190028edd64b61d0; SWF 6e10da95ac54388a5076c8dd4f53a31bf768cf973a60d0cdec3ff0577cfdaa89; p95 42 ms en esta computadora.
