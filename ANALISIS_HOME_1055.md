# HOME · Revisión 1.0.55



La comparación usa la grabación completa disponible para medir movimiento; donde sólo queda una captura archivada, se valida composición/estado y no la secuencia de animación. No se afirma paridad total ni fórmulas recuperadas.



Fuentes completas: Baseball Heroes Gameplay Part 1.mp4 (HOME al principio); [FACEBOOK GAME]BASEBALL HEROES play video.mp4 (00:08, 00:12 y08:40, banners de misiones y progreso; 00:16–00:28, visitas y monedas); videoplayback (4).mp4, copia en reference_visual/nuevos_20261011/video3.mp4 (01:20 y06:32–06:40); 30).mp4, copia nuevos_20261010/video2.mp4 (00:00–00:02); baseball heroes eliminatorias final de la liga.mp4, copia nuevos_20261011/final.mp4 (00:00–00:06 y00:45); Baseball Heroes.mp4 (00:05–00:12, HOME y cambio a pantalla completa).



También se revisaron los contactos archivados: research/video1-overview.jpg (No doy una, HOME/tutorial y misiones entre07:10–09:00); research/video2-overview.jpg (Kediri, principalmente partido; no evidencia adicional de HOME en las capturas); reference_visual/v055/original-home.jpg; F.A.F. (v054/faf-ready.png) sirve de contexto del HUD del partido, no demuestra animación de HOME; gameplays_20260924/ciguena-overview-00.jpg yprimer_lugar-overview-00.jpg (00:20 y01:10); explicando_20260924/overview-00.jpg (00:10–01:10). videoplayback.mp4 (nuevos_20261010/video1) se centra en calendario y partido; sus dos contactos no añaden HOME. Las tiras del material nuevo están en build/qa/release1055/*-motion.jpg; los hashes y rutas de los seis archivos completos están en video-inventory.json.



Observado: iconos compactos sobre el campo, cintas naranjas NEW MISSION que aparecen por eventos, cintas azules 1/2 COMPLETE, señal de puntos, taquilla con contador, monedas que suben y jugadores con gestos discretos. No se observa que todos los emblemas roten de forma continua. Las pausas de carga y el cursor amarillo de la grabadora no son animaciones del juego.



Implementado: catorce accesos conservan su hitbox y etiqueta mientras el arte responde al cursor/pulsación. Efectos de atención únicamente por puntos, misiones cobrables, premios de HALL o taquilla lista; quedan ocultos bajo los paneles. SKILL usa el sprite de habilidad existente. Recogida/taquilla muestran monedas retenidas que llegan al contador después de confirmar el premio. Sin nuevos PNG, voces ni recompensas. Se conserva el mismo héroe.



Pendiente observado: cintas de misiones nuevas y progreso por categoría; fichas de amigos con+ sobre la cerca; contratos temporales y sus relojes; significado exacto de las dos copas. Se conserva el sistema social, entrenamiento y HALL actuales; no se inventaron contratos ni se presentaron los trofeos de HALL como los contadores de otra categoría.



Rookie: escala3.10→2.35; rango nominal1.10–1.60→0.82–1.26s. Caso recta/rating65/random0.5:1.10→0.8225s; cruce del objetivo en0.925 de la duración,1.0175→0.7608125s. Contact65/rating65: PERFECT±41.25→30.55ms, GOOD±91.5→68.9ms. El aro usa la función de GOOD; se mantiene el aviso temprano. Las otras cuatro ligas conservan velocidad, grados y calidad. Son ajustes de jugabilidad del remake, no fórmulas del juego cerrado.

