# Web 0.7.2 · LINE UP contrastado con el gameplay

La alineación se reconstruyó tomando como referencia el fotograma `reference_visual/gameplays_20260924/primer_lugar-0100.jpg`, de «Seguimos En Primer Lugar». Los dos paneles, las nueve filas, la altura de los encabezados, el fondo del estadio atenuado, la fila amarilla, los indicadores rosados, los retratos, los logos, el gráfico inferior y los tres botones de pie siguen esa composición. Las posiciones horizontales del video de 1280 × 720 se normalizan al lienzo de 960 × 720 del remake.

Las fuentes Arial Bold y Arial Black se incorporan al SWF para conservar el grosor en Ruffle. **Son sustitutos de las fuentes originales**, que aún no se han recuperado. La construcción local requiere `C:/Windows/Fonts/arialbd.ttf` y `ariblk.ttf`; los jugadores no necesitan instalarlas. Los nombres fuera del alfabeto latino conservan la fuente de sistema como respaldo.

Las filas y botones son controles reales. Se conserva el motor de temporada, la selección, los perfiles, las sustituciones, el arrastre, AUTO SORT, el inventario de cartas y PLAY. Las partidas anteriores y el esquema 21 no cambian; las nuevas siguen en nivel 1, ROOKIE.

## Dos errores corregidos

- Un clic normal sobre un suplente se perdía porque MOUSE_UP reconstruía las filas antes de que Flash enviara CLICK. Ahora una pulsación conserva el control hasta que se procesa el clic; un arrastre sigue aplicando el cambio al soltar.
- SPECIAL incluía a los jugadores de grado PITCHER. El filtro y su contador ahora incluyen solo HERO, ELITE y RARE. ALL muestra el total real y los controles de página se desactivan en los extremos.

## Diferencias que siguen pendientes

El original muestra avatares de Facebook, energía individual y flechas de estado. No se recuperaron sus tablas. Las placas del remake muestran la posición y el grado real; el indicador rosado se rotula **LV** y muestra el nivel del jugador. La flecha gris abre su ficha y no pretende indicar una bonificación inexistente. Las cartas especiales conservan sus cargas reales en el sistema existente, con su clase en la cabecera y candados en los slots bloqueados.

El gráfico muestra los atributos reales del equipo local (CON, SPE, POW y AVG); no se fabrican una clasificación ni victorias para el rival. El estadio utiliza los recursos y la personalización ya disponibles. El campo ROOKIE sigue siendo una reconstrucción; no se ha sustituido por el estadio de una liga superior. Falta todavía recuperar el arte completo del estadio inicial y las animaciones originales.

## Verificación

`build/qa/smoke-lineup072.txt` registra pruebas en Chrome aislado con una cuenta local: selección física, ficha, sustitución, arrastre entre filas, AUTO SORT, filtros, varias páginas, tienda, slots especiales, HOME, PLAY y recarga del orden guardado. Los recursos no cambian al reorganizar; PLAY utiliza el cobro existente de una energía. El paquete de producción excluye `WebLineupSmoke.swf` y todos los otros targets de prueba.

La comparación con el original, la versión anterior y la nueva está en `COMPARACION_ALINEACION.html`. No se declara una copia exacta: se documentan por separado la composición reconstruida y los recursos que aún faltan.
