# Web 0.8.8 · Swing y ocho cuerpos intermedios

Publicado el 8 de octubre de 2026 en Railway: 79761ed2-26b2-4134-bef3-bad0bba98786, build 3b8883c8aaf9da71. [Comparación visual](COMPARACION_SWING_088.html).

La animación anterior saltaba de preparación a contacto y usaba un bate inclinado hacia arriba durante el seguimiento. El gameplay original muestra el remate con los brazos recogidos hacia el hombro izquierdo y el bate cruzado horizontalmente detrás de los hombros. Se reconstruye esa composición en la animación real del partido.

## Arte y origen

Se generó una hoja suplementaria de ocho cuerpos sin cabeza, con la herramienta integrada imagegen, usando como referencias el atlas de 083 y las poses del gameplay F.A.F. La cabeza personalizada de 087 se monta encima; no se genera un héroe independiente que sustituya sus rasgos.

Archivo final: [swing-atlas.png](assets/sprites/v088/swing-atlas.png), 1774×887, RGBA con transparencia, SHA256 c1de648b73447d7b7f7bf69d82817823526a8bd9dd35b4f9e223812a0053b7b7. [Prompt completo](assets/sprites/v088/GENERATION_PROMPT.txt) y [manifiesto de origen y mediciones](assets/sprites/v088/SOURCE_MANIFEST.json). El PNG se copia íntegro desde la salida de la herramienta; no se altera ni se recorta en disco. Los ocho componentes conectados se miden completos. El bate del quinto cuerpo cruza el límite de una celda regular, por lo que se usan límites medidos, no cortes por cuadrícula. Los anclajes de piel del cuello y la base de los zapatos se verifican sobre el alfa de la imagen. El atlas de 083 permanece intacto.

HeroSprite incorpora ocho cuadros adicionales (16–23), con bancos de texturas y paletas ya existentes. Se recorta, separa el componente conectado y recolorea cada cuadro una vez al prepararlo. ClassicBatter utiliza esos cuadros para avance, seguimiento horizontal y regreso. El remate muestra la suela del pie posterior levantado, como en la referencia. La cabeza conserva sus orientaciones y rasgos guardados.

El dorsal queda a la altura de la camiseta de los nuevos cuerpos. Su posición y rotación se transforman alrededor de los pies junto al torso, evitando que la inclinación lo desplace hacia los pantalones o fuera de la espalda.

## Contacto y tiempos

Preparación: postura inicial hasta 15 ms, primer intermedio entre 15 y 30 ms, segundo entre 30 y 45 ms. El cuadro de contacto anterior sigue activo de 45 a 110 ms, con el mismo punto y límite de inclinación de ±18°. Seguimiento: primer intermedio hasta 155 ms, cruce hasta 200 ms, remate horizontal hasta 1040 ms. Regreso: cuadros a 1040, 1130 y 1220 ms. El swing termina a 1340 ms, como antes. Las reacciones de frustración y celebración conservan sus tiempos.

No se cambia GameData, BattingSystem, probabilidades, recompensas, progreso inicial ni servidor de cuentas. Guardado 21, registro sin invitación, nivel inicial 1 / ROOKIE y carreras existentes se conservan. Las escenas del creador y HOME mantienen sus cuerpos anteriores.

## Pruebas

La galería anterior ejecuta los HeroSprite/ClassicBatter reales de 087 en un SWF diagnóstico. La nueva ejecuta las fuentes actuales. Doce instantes, misma identidad y reacción HIT con reloj controlado, sin escribir estado de carrera. Se liberan los actores al cambiar de galería; ambos SWF diagnósticos se excluyen de producción.

Pruebas de identidad: los ocho campos elegidos se conservan tras selección y recarga, HOME/retrato, dieciséis poses previas, ocho cuerpos nuevos, trece orientaciones y doce instantáneas del movimiento. Se verifican las fronteras de 44/45 y 109/110 ms, los nuevos cuadros de seguimiento/regreso, retorno a espera a 1340 ms y reacción hasta 2600 ms. Contacto real del bate a menos de 1.5 píxeles de tres alturas (-100, -80 y -48) dentro del límite existente. Galerías sin cambios en apariencia, nivel ni liga.

Chrome local y publicado: registro sin código, selección del equipo y personaje, cancelación y confirmación del borrador, llegada tras recargar, HOME, nombre/dorsal, metas, viaje, alineación, introducción, primer partido y reentrada. Energía cobrada una vez, identidad y carrera conservadas. Sin errores del navegador.

Muestra ENTER_FRAME de 45.160 s: 2710 cuadros, 60.01 FPS, p95 23 ms, máximo 106 ms, 2 intervalos por encima de 50 ms. 15 cambios de bateador, máximo 2 ms en esta muestra. No se garantiza ese rendimiento en otras computadoras ni ausencia total de pausas.

Paquete permitido de 134 archivos y catorce hashes publicados coincidentes. Dos archivos WASM de Ruffle se omiten del archivo subido y se restauran durante la construcción desde el paquete oficial npm fijado en 0.6.0. El archivo comprimido y cada WASM se verifican por SHA256; cualquier diferencia cancela la construcción. El motor final es idéntico al probado y sigue alojado con el juego. Respaldo previo Railway external-v088-1791483448.sqlite3 con integridad OK. Se eliminó solo la cuenta QA de esta revisión, preservando las anteriores. Los atlas de 083, 60 recortes de 079, siete celebraciones de 080 y paquete Windows histórico 067 conservan sus hashes.

La subida se realiza al endpoint oficial de Railway con USTAR/gzip estándar, 25638335 bytes y 132 archivos incluidos; los dos WASM se restauran y verifican en la imagen. Script reproducible: research/upload_web088_standard.py. Utiliza la sesión de la herramienta oficial solo en memoria, sin copiar credenciales al paquete ni escribirlas en los informes.

## Límites

Los cuerpos nuevos son reconstrucción generada, no sprites originales recuperados. Aún hay poses discretas y diferencias de anatomía e ilustración; no se afirma igualdad exacta ni interpolación continua del cuerpo. La oclusión del bate por el casco durante parte de la preparación es visible en la secuencia. Quedan más cuadros, accesorios y detalles del casco/lanzador para avanzar hacia el original.
