# Web 0.8.6 · Rostro y expresiones del héroe

Publicado en Railway: 82b88772-e80e-4711-96b7-4ce2cb5eea9d, build cd1a6f3c26421022. [Comparación visual](COMPARACION_ROSTRO_086.html).

La cara anterior usaba una pequeña elipse de color sin pupila negra, una línea de ceja casi idéntica para todas las opciones, narices que alargaban el mismo trazo y sonrisas con dientes demasiado rectos. Se contrastó con el retrato oficial, las poses de animación recuperadas y los personajes de la hoja 11_09 aportada.

HeroHead dibuja ahora iris de color alrededor de pupilas negras, dos brillos pequeños, contorno oscuro y párpado superior. Una zona del mismo color de piel cubre la parte del iris que queda bajo el párpado; no se añaden máscaras raster ni texturas por ojo. Las ocho opciones varían altura, anchura e inclinación del párpado y cejas. El color elegido se aplica al iris; la pupila mantiene su color oscuro. Las cejas usan un tono derivado del cabello, con límite para no desaparecer en cabello blanco.

Las ocho narices tienen ahora trazos o sombras diferenciados: pequeña, recta, redonda, puntiaguda, plana, larga, ancha y de botón. Las ocho bocas distinguen gesto confiado, sonrisa cerrada, calma, dientes, seriedad, risa, gesto relajado y alegría. Se dibujan dientes e interior de la boca en formas curvas, con lengua en las sonrisas abiertas y manteniendo el dibujo dentro de la mandíbula.

Los cuatro estados coordinan ojos, cejas y boca: neutral conserva todos los rasgos seleccionados; parpadeo cierra los ojos sin sustituir la boca elegida; frustración eleva las cejas hacia el centro y dibuja una boca triste; celebración muestra arcos de ojos alegres y risa. Son estados temporales y nunca se escriben como nueva identidad al guardado. Solo se redibujan al cambiar de expresión, como antes; no hay procesamiento de píxeles por cuadro ni nuevos bancos de caché.

Se conservan el contorno de cabeza de 085, el cuello de 084, las escalas y anclajes del cuerpo y cabello, el casco posterior, los ocho índices guardados de cada rasgo, las paletas de piel/cabello/ojos, la curva de progreso y las reglas de partido. No se modifican GameData ni los sistemas de timing, resultados o recompensas. No se generan ni editan PNG de sprites.

## Pruebas

Identidad deliberada de los ocho campos tras SELECT y recarga; HOME y retrato contienen la misma identidad. Ocho ojos, ocho narices, ocho bocas, ocho peinados, ocho contornos desnudos y dieciséis poses; cuatro expresiones temporales sin modificar la apariencia del guardado. El diagnóstico libera sus cabezas al cambiar de galería. Las galerías no modifican nivel ni liga. Sus SWF no se publican.

Chrome local y publicado: registro sin invitación, nivel 1 ROOKIE, equipo, borrador/cancelación y selección del personaje, llegada, HOME, nombre/dorsal, metas, calendario, viaje, alineación, introducción, primer partido, salida y reentrada. La energía se cobra una sola vez y la apariencia se conserva. Sin errores del navegador.

Medición de ENTER_FRAME de 45.145 segundos: 2708 cuadros, 59.98 FPS, p95 25 ms, máximo 107 ms, 1 intervalo por encima de 50 ms. 16 cambios de bateador, máximo 3 ms en esta muestra. La pausa de 107 ms sigue presente; no se afirma ausencia total de tirones ni ese rendimiento en otras computadoras.

Paquete permitido de 131 archivos, nueve hashes publicados coincidentes y respaldo previo dentro del volumen Railway external-v086-1791321450.sqlite3 con integridad OK. Se eliminó solo la cuenta QA propia, manteniendo las preexistentes. Guardado 21, inicio nivel 1 / ROOKIE y registro sin invitación sin cambios. Las referencias oficiales, los atlas de 083, los 60 recortes de 079, las siete celebraciones de 080 y el paquete Windows histórico 067 conservan sus hashes.

## Límites

Es una reconstrucción del lenguaje visual observado, no recuperación de los ocho catálogos exactos de ojos/narices/bocas originales. La cara y el casco siguen siendo trazados nativos; los cuerpos y cabellos son las reconstrucciones de 083. Quedan perfiles, giros del rostro/cabello, expresiones específicas, transiciones y cuadros intermedios para una similitud mayor. El retrato oficial tiene una orientación de tres cuartos que no se traslada literalmente a la vista frontal del creador.
