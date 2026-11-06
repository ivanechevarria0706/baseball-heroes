# HOME, alineación y ficha del jugador — 0.5.5

HOME y LINEUP usan ahora el mismo marco clásico de 960 × 720 que el partido. La ventana escala las escenas sin deformarlas. Se reconstruyeron las dos pantallas a partir de la composición visible en los videos proporcionados, conservando el juego existente.

## Cambios

- HOME: estadio, nueve tarjetas accesibles, héroe separado de la fila, estadísticas de temporada, acceso directo LINEUP y navegación inferior. Las tarjetas siguen el orden de bateo guardado.
- LINEUP: nueve titulares a la izquierda, suplentes a la derecha, próximo rival debajo, ranuras especiales, filtros, tienda, orden automático y botones HOME/PLAY. Se mantienen los cambios por clic y arrastre.
- Ficha del jugador: retrato, posición, grado, nivel, rating, AVG, HR, RBI, habilidad y atributos con base, bonificación de equipo y total efectivo. Se abre desde HOME o desde el botón «i» de una fila.
- Consultar una ficha no altera el equipo. La ficha de un suplente permite confirmar su entrada al puesto seleccionado mediante USE IN SLOT. Cerrar conserva la selección.
- Los cambios se guardan y HOME los refleja al regresar. PLAY desde LINEUP abre la presentación del encuentro y lleva los nueve puestos elegidos al partido.
- La tienda queda centrada y su fondo cubre todo el nuevo marco.

## Cómo probarlo

1. Abre `JUGAR.bat`.
2. En HOME, pulsa una tarjeta para consultar su ficha; LINEUP lleva a la alineación.
3. Selecciona un titular y pulsa «i» en un suplente. USE IN SLOT confirma el cambio. También puedes usar los clics o arrastres ya existentes.
4. Arrastra un titular a otra fila para intercambiar posiciones. Regresa a HOME para ver el orden actualizado.
5. En LINEUP, pulsa PLAY para entrar al encuentro.

`COMPARACION_HOME_LINEUP.html` muestra capturas reales del ejecutable y fotogramas de referencia. Los nombres y cifras de las capturas corresponden a la partida de prueba.

## Verificación

Compilación Flex/AIR y prueba `HomeLineupSmoke`, ejecutada con un identificador de aplicación independiente de tu partida:

- Los 13 destinos de HOME conservan sus callbacks.
- Recorrido real de `Main`: HOME → ficha → LINEUP → presentación → partido.
- Consultas sin cambios de alineación; estadísticas efectivas del suplente correcto.
- Sustitución explícita, arrastre con ventana escalada y rechazo de una suelta fuera de la lista.
- Recarga del orden desde el guardado, reflejo en HOME y coincidencia de los nueve puestos en el partido.
- Filtros y límites de página, apertura/cierre de tienda sin alterar la alineación, orden automático y cobro sin duplicados.
- Revisión visual de HOME, LINEUP, fichas y tienda con los retratos cargados.
- Huellas de los cuatro WAV originales y de las dos copias instaladas de cada MP3 comprobadas; no se reactiva audio F.A.F.

Resultados actuales: `build/qa/smoke-home-lineup.txt` y `build/qa/smoke-user-audio-assets.txt`. Los demás informes incluidos son historial de revisiones anteriores, no una nueva ejecución de todas las pruebas. La recarga comprueba la persistencia con la API del juego; no simula un cierre forzado del sistema.

## Límites de fidelidad

El arte del héroe y del estadio sigue siendo una reconstrucción. Esta entrega aproxima la composición; no recupera los sprites ni el código originales. La ficha presenta los datos y reglas actuales del remake, sin atribuir sus fórmulas al juego de Syntasia. El equipamiento utiliza el modelo compartido que ya existía. Otros menús, incluida la presentación previa, siguen en 960 × 540.

Se conserva el identificador `com.personal.baseballheroesremake` y el formato de guardado. Tus cuatro sonidos continúan activos. La versión anterior queda en `Baseball_Heroes_partido_clasico_v054.zip`, fuera de la carpeta del proyecto.
