# Baseball Heroes 1.0.29 · presentación del partido y BOX SCORE

**Publicada y comprobada por HTTPS.** Se completó un partido real en la web. La cuenta QA se retiró y las cuentas anteriores se conservaron.

## Alcance

Ocho clases: Main, Game, TeamSimulationPanel, SimulationPlayerRow, Hud, MatchSocialBar y las nuevas MatchChrome/LiveMatchScorecard. Autojuego, HUD de bateo y franja social comparten paneles y placas con relieve, marcos, reflejos y separación de filas. Los controles de velocidad y pausa también se ajustan. El resaltado de la entrada actual se mueve por encima del fondo del marcador para que sea visible. El total H se refresca después de cada jugada de ambos equipos; antes podía quedar atrasado durante el autojuego.

Las siete casillas de amigos vacías reutilizan InterfaceSprite/scout. Las seis acciones inferiores usan InterfaceSprite, el icono RIVAL existente y el trofeo existente de AchievementArtwork. El aviso de una casilla vacía se puede cerrar pulsándolo. Se liberan los listeners propios de ClassicActionButton y las cargas de AssetImage al renovar la franja. Sin imágenes nuevas, generación de arte ni cargas por cuadro.

Referencia: `reference_visual/autoplay_20261013/full-406.1.png`, 06:46. Se conserva la composición de dos alineaciones sobre el estadio. Los marcos son nativos; los recursos ilustrados ya estaban incluidos, algunos recuperados y otros reconstruidos. No se afirma paridad exacta.

## BOX SCORE

Panel en vivo con 18 jugadores, AB, H, HR, RBI, BB, totales y marcador por entradas. Abre con B o el botón BOX SCORE en SIMULATION o READY. Game conserva un segundo MatchBoxScore del rival y registra sus resultados existentes; las reglas y el resultado de las jugadas no se modifican. Las tablas son un snapshot de lectura y no llaman a GameData.save ni conceden premios.

La consulta reutiliza el reloj de pausa del autojuego y conserva una pausa manual previa. Desde READY no comienza un lanzamiento hasta recibir entrada. Espacio queda bloqueado mientras se consulta; RESUME, B o Esc cierran. Main intercepta Esc cuando la consulta está abierta para no abandonar el partido. El panel no se abre en vuelo, windup, transición o cinemática. Esta consulta es una ampliación del remake, no una pantalla original confirmada por los videos. Las estadísticas nuevas del rival son locales al encuentro y no se inventan para partidas históricas.

## Verificación

Registro sin código: nivel 1, Rookie, 6,000 Coins y sin lentes. Cuenta QA con tutorial completado y 49 XP de progreso para comprobar el premio real de nivel al finalizar. Solo se prepara esa cuenta. Partido programado a través de los controles normales: cinco de energía una sola vez. Se verifican pausa, Espacio bloqueado, cierre con Esc, conservación de pausa manual, READY sin avance, RESUME físico y consulta bloqueada durante FLIGHT. Los 18 registros terminan con H igual al total de hits de cada equipo, HR <= H <= AB y RBI no superior a carreras; el marcador coincide con el resultado guardado. Nivel 2 y punto de habilidad una sola vez, HOME y recarga conservan Coins, resultado y personaje. Sin errores JS/AVM2 detectados.

El recorrido local usa una copia del punto de entrada WebMain que añade únicamente `bhInspect1029`, una lectura de liveMatchSnapshot, para verificar la congelación y los totales. Las clases de juego son las mismas del build final. El SWF diagnóstico queda en `build/qa/release1029/` y está excluido de publicación. Se comprueba que ese callback está ausente del SWF público. Una primera preparación QA detectó un borrador pendiente y se corrigió esperando el guardado y limpiando solo el borrador de su contexto aislado; no se modificó la política de recuperación del juego.

El partido HTTPS también terminó con WebMain público sin instrumentación, después de abrir BOX SCORE, pulsar Espacio, cerrarlo con Esc y consultar la franja social. Los 143 archivos instalados y SQLite se comprobaron. La cuenta QA se retiró conservando las cuentas anteriores.

## Conservación y publicación

GameData, MatchBoxScore, modelos, servidor, cliente web, fórmulas, audio, cabeza 0.8.6, velocidad de pichadas y guardado v24 se conservan. Sin reinicios. La presentación nueva no añade animaciones por cuadro a cada icono; no se afirma una mejora general de FPS.

Build `88aacffa8f8759b5`; SWF SHA256 `cee98ee279253c98a76fe4af8afaf4b0dc5cbc5b96dc98b03dbae77f83d34643`, 36,489,312 bytes. 147 archivos de paquete, biblioteca `420c2634b3a4419e0087fd9d2f61d06b469ebc813446de8c947f685a15026124` con 114 archivos verificados. Los 113 recursos se reutilizan mediante enlaces duros. Para disponer de espacio se archivó el candidato 1.0.20 nunca activado (`31b5fedab7f3792b9e821942a0a5b783a95654140a4f16b4bfdb219763ddfe7b`), verificando sus 114 hashes, su copia local y los 114 archivos activos antes y después. Solo se retiró esa carpeta; sus SWF y manifiesto quedan en `build/qa/release1029/unactivated1020-*`. Las bibliotecas publicadas y las bases de datos se conservaron, con copia SQLite comprobada antes de publicar. Además se comprimieron sin pérdida respaldos manuales antiguos verificados por SHA256 e integridad SQLite, comprobando su descompresión antes de retirar únicamente el archivo sin comprimir. Los respaldos recientes y las copias de migración se conservan intactos. Detalles en `build/qa/release1029/backup-archive.json`.

[Comparación](COMPARACION_MEJORAS_1029.html). La prueba física de amigos en dos computadoras sigue pendiente.
