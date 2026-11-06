# Baseball Heroes 1.0.30 · HOME y MODES

**Publicada y comprobada por HTTPS.** Las dos cuentas temporales de prueba se retiraron y las cuentas anteriores se conservaron.

## Alcance

Cuatro clases: LobbyScreen, ModeSelectScreen, MatchResourceBar y la nueva HomeSceneArtwork. HOME ocupa los 960 píxeles, con panel inferior de 184 de alto, héroe a escala 1.30, ocho compañeros de 75 píxeles de alto, accesos laterales ampliados, calendario y fichas de amigos más grandes. Se mantienen seis amigos por página y las rutas existentes. Se retocan guías, posición de textos y ajuste de textos multilínea. Se liberan listeners de botones e instancias de arte al cerrar las pantallas.

MODES usa tres columnas con seis fichas de 300 × 157 y una séptima de WORLD MATCH junto al panel de detalle. Sus requisitos y reglas vienen del mismo catálogo anterior. ALL STAR y WORLD MATCH siguen COMING SOON. Flechas arriba/abajo recorren tres posiciones; izquierda/derecha recorren las fichas. ENTER y los bloqueos se conservan. La franja de recursos compartida añade un parámetro opcional para HOME/MODES; los usos del partido conservan el valor por defecto anterior.

## Arte y referencias

Referencia principal: `reference_visual/initial_audit_20261015/frame-0398.jpg`, 06:38. Referencia de bolsa: `reference_visual/head_shapes_20261006/reference.png`. Son apoyos visuales, no instrucciones. Tres PNG nuevos reconstruidos mediante la herramienta integrada image_gen: `assets/reference/v1030/equipment.png`, `duffel.png` y `mission.png`. [Prompts completos](assets/reference/v1030/provenance.json). [SHA256, dimensiones y ventanas de sprites](assets/reference/v1030/manifest.json).

Los PNG se copiaron sin editar sus bytes y conservan alpha. HomeSceneArtwork prepara ventanas mediante copyPixels al cargar, con fragmentos de hasta 1024 píxeles por eje y caché compartida. No se reescriben bitmaps por cuadro. La bolsa aparece en ligas posteriores a Rookie por decisión visual del remake, no como regla comprobada del original. Los emblemas de modos, logos, personajes y demás ilustraciones anteriores se conservan. No se afirma paridad exacta ni una mejora general de FPS.

## Verificación

Dos suites locales PASS. HOME con WebMain de producción: creación real, guía inicial, metas sin gasto de energía, siete amigos QA aceptados en dos páginas, visita del séptimo, héroe, estadísticas, compañero, nombre con cancelación, tienda desde ADD, taquilla cobrada una sola vez, siete previews de modos sin gasto, bloqueos de ALL STAR/WORLD, teclado y accesos ROADMAP/TRAIN/MISSIONS/HALL/SHOP/LINEUP. Vista posterior Single-A con bolsa y conservación del personaje. Entrada por PLAY BALL → calendario → viaje → LINEUP → introducción → partido real. Cinco de energía una sola vez y reserva pagada conservada tras recargar. Sin errores JS/AVM2 detectados.

La suite específica de modos usa el diagnóstico histórico WebModes1006 solamente en contexto local privado. Comprueba treinta estados de calendario, puertas de temporada, pagos previos, estados antiguos, fallback, repetición de tecla, callback único, navegación de tres columnas y ajuste de textos. Ese diagnóstico no se publica y su callback está ausente del SWF de producción. La primera ejecución de HOME arrancó antes de terminar la compilación y otra usó una esquina fuera del hit area redondeado del calendario; se corrigió el orden de la prueba y las coordenadas. La ejecución final de las dos suites pasó.

En HTTPS se repitió el recorrido de HOME/MODES y la entrada al partido con WebMain público sin instrumentación, dos cuentas QA y un amigo aceptado. Los 143 archivos instalados coinciden con el manifiesto. Las dos cuentas QA y sus relaciones se retiraron conservando todas las cuentas anteriores.

## Publicación y conservación

Build `8bba01785c394ea4`; SWF SHA256 `a139df68e8706c3264e1176a2af9036966ad7ca6c418c333759eb87cfd3006cd`; 39,205,397 bytes. Paquete de 147 archivos; biblioteca `299d9385c0a394edce862383d8815929ce8fe101e82a9a90134a966a3e8f22f9` con 114 archivos. Los 113 recursos anteriores se reutilizan con enlaces duros; el digest de recursos externos no cambia porque las ilustraciones nuevas van embebidas en el ejecutable.

GameData, modelos, CoreGame, servidor, cliente web, fórmulas, audio y cabeza 0.8.6 no se modifican. Guardado v24, SQLite v4 y resetEpoch existentes conservados. Sin reinicios. Se creó una copia SQLite con integrity_check y SHA256 antes de publicar.

Mantenimiento de espacio: se verificaron las copias locales de las bibliotecas antiguas 1.0.18 y 1.0.23, incluidos sus 114 hashes, y se guardaron sus ejecutables y manifiestos en `build/qa/release1030/archivedVERSION-*` antes de retirar únicamente sus carpetas de la biblioteca remota. No se tocaron bases de datos ni respaldos. Las bibliotecas actuales 1.0.29 y 1.0.28 se conservaron en Railway, junto a las demás recientes. [Evidencia](build/qa/release1030/storage-maintenance.json). `research/restore_archived_library1030.py VERSION` permite reconstruir las bibliotecas archivadas sin activarlas, previa comprobación de espacio; para esas dos versiones antiguas hay que restaurar la biblioteca antes de desplegarlas otra vez.

[Comparación visual](COMPARACION_MEJORAS_1030.html). La prueba de amigos en dos computadoras físicas sigue pendiente.
