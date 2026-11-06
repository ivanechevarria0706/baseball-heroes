# Web 0.7.5 · Inventario de equipamiento

La pantalla EQUIP deja la distribución de tres paneles y recupera la composición observada en el gameplay «Vamos En Primer Lugar Y Explicando Algunas Cositas», 00:50, 09:22 y 09:34: inventario azul a la izquierda, cuatro columnas y dos filas, héroe sobre el campo a la derecha y panel claro de atributos encima. Se reutilizan el estadio, el héroe ilustrado y las fuentes incorporadas del juego. No hay una captura pegada como interfaz.

Las pestañas GLOVE/BELT/HELMET/SHOES/BAT/GOGGLES usan controles reales. Las flechas muestran ocho objetos por página, mantienen accesibles las colecciones grandes y reabren la categoría en la página del objeto equipado. SHOP abre la tienda existente; X vuelve al equipo.

Seleccionar un objeto cambia el héroe y las barras de Contact/Power/Speed/Luck sin guardar ni gastar. CANCEL PREVIEW restaura el equipo aplicado. EQUIP utiliza la operación anterior de GameData; pulsarlo otra vez no modifica recursos. Los indicadores laterales muestran el equipo aplicado, mientras el héroe muestra lo que se está probando. El cálculo de la vista previa respeta el límite de 99 incluso cuando el valor sin limitar ya lo supera.

Se conserva el actor de vista previa cuando la selección no cambia. El estadio usa la caché estática introducida en 0.7.4. No se cambiaron el motor del partido, el timing, la simulación, las recompensas, el catálogo, los precios ni el esquema 21. Las cuentas nuevas siguen en nivel 1 y ROOKIE. No se agregan objetos QA a las partidas reales.

## Evidencia y límites

Referencias locales: `reference_visual/explicando_20260924/frame-0050.jpg`, `frame-0562.jpg` y `frame-0574.jpg`. Comparación en `COMPARACION_EQUIPAMIENTO_075.html`.

Es una mejora de composición y funcionamiento, no una copia visual exacta. El héroe sigue siendo una reconstrucción; las siluetas de objetos son símbolos dibujados, las fuentes son sustitutas y la tienda conserva su pantalla anterior. El original muestra tres atributos en esta vista; se conservan los cuatro del modelo existente para no ocultar Speed. No se inventaron consumos para los bates a partir del rótulo 5 LEFT, porque los videos aún no prueban qué acción los agotaba. La franja social del original no forma parte de esta pantalla.

## Validación

- `smoke-equipment075.txt`: Chrome, botones reales, las seis categorías, 126 objetos en una identidad local aislada, tres páginas por categoría sin desbordamiento; prueba, cancelación, cierre, aplicación repetida y recarga; monedas, inventario, nivel, liga y orden conservados.
- `smoke-home075.txt`: las trece rutas de HOME más TRAIN, regreso, paginación del equipo, cobro una sola vez, seis fondos ilustrados y respaldo ante fallo de carga, entrada al partido.
- `smoke-production-match075-local.txt`: SWF final con controles reales del inventario y partido; objeto en segunda página, aplicación/cancelación y recarga, inicio nivel 1 ROOKIE y muestra del renderizado.
- `smoke-web075-staging.txt`: paquete completo permitido, registro sobre una base vacía, rutas protegidas y ausencia de SWFs de diagnóstico.
- `smoke-cloud-match075.txt`: mismas verificaciones sobre Railway, con una cuenta temporal propia; limpieza comprobada y respaldo dentro del volumen.

Los informes publicados se incorporan al manifiesto solo después de terminar la comprobación en Railway. Para actualizar una pestaña abierta, esperar a «Guardado en la nube» y recargar. Windows 0.6.7 conserva su compilación anterior.
