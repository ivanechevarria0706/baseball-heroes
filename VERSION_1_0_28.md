# Baseball Heroes 1.0.28 · THE ROADMAP TO MAJOR

**Publicada y comprobada por HTTPS.** El recorrido público pasó con una cuenta QA. Se retiró únicamente esa cuenta y se conservaron las anteriores.

## Cambios

RoadmapToMajorScreen sigue la organización de `reference_visual/explicando_20260924/frame-0854.jpg` (14:14): título, emblemas, camino, Requirement, Optional y franjas de premio. Cabecera ClassicChrome, paneles con relieve, marcas verdes por objetivo completado, aro de selección y YOU ARE HERE para el primer requisito pendiente de la liga actual. Seleccionar otro paso no cambia ese indicador.

InventoryArtwork muestra la caja correspondiente a la liga. InterfaceSprite aporta la moneda y AchievementArtwork el trofeo ya existente. No se generan imágenes nuevas ni se redibujan personajes. El marco es nativo; las proporciones conservan la ventana del remake y no constituyen una copia exacta del video. No se añade la compra de recomendaciones del original porque su regla no está verificada.

Los botones de premios dejan de recibir clics si están bloqueados o cobrados. Las flechas se desactivan en los extremos. Los contadores de una liga ya superada muestran COMPLETED, respetando que el modelo ya la considera completada; no se inventan ni reescriben cifras históricas ausentes. Se ajusta el texto de estado después de reclamar y se liberan los listeners de los botones al repintar.

Solo cambia RoadmapToMajorScreen.as. GameData, RoadmapJourney, MysteryInventory, modelos, servidor, web, audio, cabeza aprobada y guardado v24 se conservan. No cambia ningún coste, premio, llave, requisito o regla de ascenso.

## Pruebas

Chrome con WebMain real, sin hooks de diagnóstico. Registro sin código: nivel 1, Rookie, 6,000 Coins y sin lentes. Recorrido de cinco ligas, todos los pasos Rookie y límites de navegación con recursos conservados. Caja Rookie: tres clics rápidos y recarga entregan solo una caja y dos llaves. Inventario de 50 cajas no consume premio; con 49 permite recibir una sola caja. Opcionales SINGLE-A bloqueadas con seis recomendaciones, y también con siete sin campeonato. Con ambas metas listas, tres clics y recarga pagan exactamente 4,000 Coins una vez. Se comprueba una liga anterior con contadores ausentes y la ruta ASK FRIENDS/GIFTS. Sin errores JS/AVM2 detectados.

Los estados de premios y ligas se preparan únicamente en la cuenta QA mediante su guardado normal; no se simula haber jugado toda una temporada ni se modifican cuentas humanas.

El mismo recorrido pasó por HTTPS con una cuenta QA pública. Los 143 archivos instalados coinciden, SQLite conserva su esquema e integridad, y se retiró únicamente la cuenta QA, conservando las anteriores.

## Paquete y conservación

Build `964270c4203f8f98`, SWF SHA256 `3fa0e1e97f72aefdeca1b69dd6fb21049446cbad2427b24fd5d00664739179fb`, 36,487,132 bytes. Paquete de 147 archivos, biblioteca `b8ce8bc4124cab55c4ace79cf1cb37f2ea01de848a900fd099c6ed6ae98f830b` con 114 archivos comprobados; los 113 recursos existentes se enlazan sin duplicar sus datos. Sin afirmaciones de mejora general de FPS.

Para disponer de espacio se archivó el candidato 1.0.21 nunca activado (`fabccabf4fc37d885c299be27dee72b0f0bac206e1c543e434b6e09b9abc2a70`). Antes de retirar solo esa carpeta se comprobaron sus 114 hashes y recursos locales. Su SWF y manifiesto quedan en `build/qa/release1028/unactivated1021-*`. Los 114 archivos activos se cotejaron antes y después. Las bibliotecas publicadas y la base de datos se conservaron; copia SQLite previa con integridad comprobada.

[Comparación](COMPARACION_MEJORAS_1028.html). Sigue pendiente la prueba física de amigos en dos computadoras.
