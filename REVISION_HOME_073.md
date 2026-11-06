# Web 0.7.3 · HOME contrastado con el gameplay

Se reconstruye HOME tomando como referencia «Seguimos En Primer Lugar», 00:20, en `reference_visual/gameplays_20260924/primer_lugar-0020.jpg`. Las coordenadas horizontales del video se normalizan al lienzo de 960 × 720. Se mantienen el motor, el esquema 21 y las partidas: una carrera nueva sigue comenzando en nivel 1, ROOKIE, con XP cero.

La navegación lateral usa los logos y emblemas disponibles. PLAY BALL incorpora letras gruesas y una pelota; TRAIN abre directamente el entrenamiento del héroe y VOLVER regresa a HOME. Los accesos SHOP, LINEUP, BUILD y MODES usan iconos. Las trece rutas existentes siguen accesibles; ESC cierra las fichas superpuestas. Las fuentes incorporadas Arial Bold/Black son sustitutos, no las fuentes recuperadas del original.

El campo muestra ocho compañeros y el héroe separado. Los nombres de los compañeros iniciales se corresponden ahora con las mismas ilustraciones utilizadas en sus retratos. Los jugadores personalizados sin correspondencia conocida conservan la asignación aproximada. La barra inferior muestra seis tarjetas por página, con controles para alcanzar los nueve titulares. Sus fichas y las estadísticas del héroe usan los datos reales de la carrera; no se añaden resultados ficticios ni avatares de Facebook.

## Correcciones

- El campo nativo se dibujaba encima de los fondos ilustrados. Ahora sirve de respaldo y se oculta después de cargar correctamente una ilustración, tanto en HOME como en LINEUP y el partido. Si la imagen falla, el campo permanece visible. Los seis fondos existentes se conservan; ROOKIE no se sustituye por un estadio de una liga superior.
- El aviso de COACH durante el primer HOME podía cubrir PLAY BALL. Se coloca sobre el campo sin interceptar el botón; un clic real en el centro inicia la elección de meta de temporada.
- Ruffle truncaba las marcas UTC numéricas largas del último cobro de entradas al interpretar el JSON. Se guardan como texto y los guardados numéricos anteriores se normalizan antes de cargarlos. El modelo conserva su fecha, su intervalo de seis horas y su recompensa existente. Pulsar varias veces o recargar no permite cobrar otra vez durante el descanso.

## Fidelidad pendiente

El héroe de HOME y las animaciones no son los sprites completos originales. Falta el arte exacto del estadio ROOKIE, además de fuentes y algunos iconos. Los iconos nativos de SCOUT, tienda, alineación, construcción y modos son aproximaciones. SCOUT abre el sistema disponible; no simula reclutamiento de amigos de Facebook. Los accesos del original a RANKING y HALL OF FAME no se presentan como modos implementados. La comparación no declara una copia visual exacta.

## Verificación

`research/test_home073.cjs` comprueba con clics físicos los nueve jugadores, las trece rutas y TRAIN, las fichas y ESC, el cobro único y su recarga, la migración del timestamp numérico, los seis fondos ilustrados, su respaldo ante un fallo y el estadio dentro de un partido real. `research/test_cloud_home073.cjs` prueba el ejecutable de producción local y publicado: registro sin invitación, navegación HOME/entrenamiento/alineación y persistencia del cobro, nivel, XP y orden. `research/test_web_staging073.py` verifica el paquete exacto y una base vacía.

Solo se publica WebMain: los SWF de prueba y las cuentas temporales quedan fuera de la entrega. Los respaldos de SQLite permanecen en el volumen del servidor y se verifica su integridad. El ejecutable Windows 0.6.7 mantiene su SHA anterior. Los informes vigentes se registran en `revision_manifest.json` después de verificar Railway.

Comparación: `COMPARACION_HOME_073.html`.
