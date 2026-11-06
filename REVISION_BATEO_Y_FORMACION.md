# Baseball Heroes — bateo y formación, v0.4.4

Abre **JUGAR.bat** para ejecutar la compilación incluida. Requiere el SDK AIR que ya está instalado en este equipo. La aplicación sigue usando el identificador y el guardado de la versión anterior.

## Qué cambió

- Bateador reconstruido para la cámara del partido: vista de espaldas, casco grande con volumen y brillo, cuerpo pequeño, rodillas flexionadas, bate al hombro y seguimiento del swing. Respeta los colores del equipamiento actual. El personaje frontal de HOME sigue siendo un dibujo distinto.
- Lanzador con proporciones más cercanas a los personajes de referencia. La preparación dura 0,8 segundos y la pelota nace en la mano animada. El lanzamiento, el swing y los avisos usan tiempo transcurrido para evitar que su duración dependa del número de fotogramas.
- Avisos de jugada compactos, coloreados y con contorno. Se eliminan las franjas anchas que tapaban al bateador y el texto duplicado entre el HUD y los avisos; la explicación EARLY/LATE SWING conserva su propia línea.
- Marcador sobre el cielo, casillas oscuras para las carreras y contadores con degradado. Defensores visibles durante el bateo; gradas Rookie con público y home plate visible sobre el borde del HUD.
- LINE UP: fondo azul, recursos compactos, título de temporada a la izquierda, filas plateadas, nivel del jugador y panel oscuro de suplentes. Las cinco ranuras especiales caben en su panel. Ahora pueden mostrarse nueve suplentes por página. Se liberan las imágenes de las filas al reconstruirlas o terminar un arrastre.

## Referencias usadas en esta revisión

Se analizaron fotogramas consecutivos del segundo video entre **00:28,60 y 00:31,00**, especialmente la postura de espera, preparación, contacto y seguimiento. También se extrajeron ocho fotogramas del primer video entre **02:50 y 03:24** para comparar LINE UP, SUBSTITUTE y las cartas especiales.

El dibujo nuevo es una reconstrucción vectorial; no es un conjunto recuperado de sprites originales. La duración de vuelo y las probabilidades de bateo siguen siendo aproximaciones de la base existente. El fondo Major incluido tampoco coincide exactamente con el estadio del campeonato del video.

## Verificación

Prueba AIR con identidad independiente de la partida personal:

- HOME, LINE UP y partidos Rookie/Major construidos y renderizados.
- Los doce destinos de HOME ejecutan sus callbacks.
- Cobro de entradas actualiza el saldo y no se duplica.
- Sustitución por clic y reordenamiento por arrastre actualizan los puestos correctos; el orden de prueba se restaura.
- Simulación llega al turno READY, la pelota permanece oculta durante la preparación y aparece después de la salida; SPACE activa el swing.

Registro: `build/qa/smoke-classic.txt`. Capturas de esta revisión: `build/qa/classic-*.png`. Las capturas `before-*` y `after-*` pertenecen a la revisión anterior y se conservan para comparar.

## Trabajo pendiente para acercarse al original completo

1. Unificar el estilo y la escala de personajes de HOME, creación, cartas y partido; rehacer brazos, guantes, calzado y equipo especial con referencias específicas.
2. Revisar cartas y sobres individualmente: ilustración, marco, categoría, duración, habilidades y transición de apertura. Los grados y algunas reglas del remake aún no representan fielmente el juego histórico.
3. Reconstruir la cámara de vuelo de la pelota, defensas, anuncios de hit, entrada de corredores, resultado y entrega de premios con secuencias completas de los videos.
4. Reconciliar las proporciones de las dos referencias: el primer video es 4:3; el segundo es panorámico. Esta entrega conserva el lienzo 960×540 existente.
5. Documentar diferencias entre las referencias de 2013/2014 y la versión recordada de 2016. Las fórmulas de servidor que no se puedan comprobar deben seguir identificadas como aproximaciones.

La meta sigue siendo la fidelidad al original. Esta versión mejora dos escenas; todavía no es una réplica exacta del juego completo.
