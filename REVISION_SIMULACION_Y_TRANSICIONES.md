# Baseball Heroes — simulación y transiciones 0.5.2

Esta revisión reconstruye la presentación de las alineaciones y el paso entre simulación y bateo. La referencia principal es el video local «Baseball Heroes - Facebook - Juegos F.A.F.», especialmente la salida de los paneles alrededor de 406 s, el corte alrededor de 407 s y el retorno alrededor de 417 s. Se examinaron fotogramas de esas secuencias; los tiempos y el dibujo del remake siguen siendo aproximaciones.

## Cambios

- Dos alineaciones con nueve retratos, posición, promedio y estado de la última aparición. El equipo al bate aparece más grande y el jugador activo queda resaltado.
- Los resultados se presentan sobre la fila que produjo la jugada. El siguiente bateador y el cambio de media entrada esperan a que termine esa presentación, de modo que el tercer out no desaparece de inmediato.
- Marcador de carreras por entrada, con guiones para medias entradas futuras y una ventana de nueve columnas que se desplaza en entradas adicionales. Repetir una actualización del marcador no vuelve a sumar las carreras.
- Diamante central con ocupación de bases, entrada y outs. Cambiar entre x1, x2 y x4 conserva las filas, su selección, las bases y los resultados.
- Las cartas especiales muestran la carta correspondiente del catálogo existente y su resultado, con tiempo para leerla.
- Al llegar el turno del héroe, las alineaciones salen, queda el campo despejado, aparece un corte oscuro y se revela la escena de bateo. La barra de recursos permanece durante el corte.
- Al terminar la aparición manual, el resultado queda registrado en la fila y las alineaciones regresan automáticamente. Se conserva la presentación del contacto y la cámara de la revisión anterior.

La cadencia normal conserva 470/880/1650 ms por jugada para x4/x2/x1. Dentro de ella, el resultado ocupa 300/520/960 ms. Las cartas especiales tienen una pausa de 1250 ms; la entrada del héroe dura 1600 ms y el regreso de paneles, 360 ms. Cambiar la velocidad se aplica a las siguientes programaciones, sin cortar la pausa ya iniciada. Estas duraciones son decisiones de esta reconstrucción, no valores recuperados del código original.

## Verificación

- `SimulationPanelSmoke`: cambios de velocidad sin reconstruir filas ni perder estado; resultado visible con texto girado; marcador sin duplicar carreras; entradas adicionales; carta real del catálogo; fases de campo vacío, corte, revelado y retorno con reloj controlado; conservación del resultado manual y liberación repetida de vistas.
- `InningFlowSmoke`: dos apariciones manuales, regreso automático a simulación, terceros outs en ambos lados y nueva entrada del héroe. Comprueba que los resultados simulados mantienen activo a su bateador y que los dos HUD no se superponen. No pulsa Enter para continuar.
- `ContactSmoke`: contacto con SPACE, NICE visible, pausa de 1.2 s protegida contra pulsaciones repetidas y continuación de la cámara de resultado.
- `VisualSmoke`: HOME, LINEUP, navegación, cobro de entradas y lanzamiento/bateo en los estadios Rookie y Major.
- Comprobación de que únicamente `faf_sim_out.mp3` del banco F.A.F. está instalado, con ambas copias iguales al archivo seleccionado.

Registros en `build/qa/smoke-simulation-panel.txt`, `smoke-inning-flow.txt`, `smoke-contact.txt`, `smoke-classic.txt` y `smoke-selected-audio.txt`. Capturas de esta revisión: `build/qa/v052-*.png`. Las pruebas utilizan identidades de aplicación separadas de tu partida.

## Alcance

Se conservan el identificador de la aplicación y el formato de guardado. No se cambian las fórmulas de contacto, las probabilidades de simulación ni los efectos de las cartas. Del nuevo banco permanece activo solo «Out de simulación»; los demás clips siguen como referencia. El audio anterior del proyecto se conserva.

Los retratos y fondos siguen siendo una reconstrucción con los recursos disponibles. Los rivales y algunos valores proceden del modelo previo del remake. LEADERBOARD presenta puntuación local; no es una clasificación en línea. Falta seguir trabajando el arte y las demás pantallas, y estas pruebas no equivalen a recorrer una temporada completa.

Abre `JUGAR.bat` para ejecutar la compilación incluida. La entrega completa también está en `Baseball_Heroes_simulacion_v052.zip`, en la carpeta superior.
