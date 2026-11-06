# Revisión de sonidos de la grabación aportada

Fuente: `Baseball Heroes.mp4`, duración aproximada 4:16. Se revisaron un mosaico de 32 cuadros generales, 48 cuadros de eventos y dos secuencias más detalladas. Los tiempos de los WAV se localizaron por correlación del audio contra el video; el índice y los hashes están en `build/qa/release1045/source-audit.json`.

Eventos observados: calendario cerca de 00:24, viaje aéreo 00:30, estadio y LINE UP 00:34, selección 00:35, confirmación 00:39, introducción 00:41, equipos 00:47, Double con contacto cerca de 00:57, Strike cerca de 01:32, Ball cerca de 01:40, Out con contacto cerca de 01:54, bases llenas cerca de 02:11, Grand Slam con contacto cerca de 02:19 y victoria cerca de 04:06. El bateo de 03:03 también acaba en TWO BASE HIT; no se utiliza como muestra de Single.

Los 21 WAV originales se guardan sin cambios en `reference_audio/v1045/original-wav`; el ZIP también se conserva. Varios WAV contenían más de 10–12 segundos anteriores al efecto. Las versiones activas usan recortes con ganancia controlada y fades cortos. Hay 28 fragmentos activos: 26 procedentes de los WAV y dos aislados directamente del video (pop de atrapada cerca de 01:39,9 y Base on Balls del autojuego cerca de 01:16,8). Los metadatos exactos de recorte están en `assets/audio/v1045/manifest.json`.

La revisión automática de habla no detectó segmentos en los 21 WAV. Es evidencia auxiliar: no sustituye la clasificación por evento ni demuestra por sí sola que un sonido sea limpio. Se mantuvieron bloqueados los recortes históricos con narrador. No se etiquetan como recuperados los efectos de Single, Triple o derrota: el material no ofrece muestras aisladas claras para esos casos. Hit y Out del autojuego conservan las grabaciones previas aprobadas.

La integración mantiene separados el crack del bat, el vuelo de pelota, el rótulo de resultado y la celebración. Las escenas poseen sus canales y cancelan sonidos pendientes al saltar o salir. Las pruebas de Chrome verifican decodificación de los 28 MP3, picos, RMS, silencio inicial, mute, ganancia y eventos de escena. La fuente original se conserva para volver a medir o recortar en futuras revisiones.
