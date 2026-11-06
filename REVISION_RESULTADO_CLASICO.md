# Resultado clásico y estadísticas del encuentro — 0.5.6

El cierre del partido se reconstruyó como un panel vertical centrado sobre el estadio, siguiendo el fotograma del primer gameplay alrededor de 6:20. La versión anterior colocaba los botones sobre las recompensas y dejaba el resultado en una composición panorámica.

## Qué cambia

- Panel 4:3 con escudos, insignia de liga, YOU WIN / YOU LOSE, marcador por entradas, nueve bateadores y rango de rendimiento.
- Estadísticas por puesto obtenidas durante el encuentro: hits, home runs, RBI, turnos oficiales y bases por bolas. La pantalla muestra HIT / HR / RBI, como en la referencia. Los turnos simulados, manuales y activaciones de cartas especiales alimentan el mismo registro.
- El resumen conserva una copia de los nombres, apariencia y cifras del encuentro, junto con el rival, temporada y liga. Las modificaciones posteriores del equipo no reescriben ese resumen.
- El marcador muestra también entradas extra. Una casilla sin entrada jugada se distingue de un cero.
- Monedas y XP en un bloque propio; HOME y NEXT MATCH debajo, sin superposiciones. Se conservan las fórmulas de recompensas existentes.
- Un clic repetido en HOME/NEXT no puede despachar dos transiciones. Una subida de nivel pendiente se confirma antes de salir del resultado.
- Subida de nivel centrada en la ventana. El HUD de bateo y las alineaciones de simulación dejan libre la escena final; se mantienen visibles los recursos superiores.
- Confeti breve en las victorias. Se retira del resultado la lista de rivales con puntuaciones ficticias y se muestran el récord y la posición de temporada ya calculados por el remake.

La entrega conserva las mejoras anteriores de HOME, LINEUP y bateo, así como los cuatro sonidos proporcionados. El identificador de la aplicación y la versión del formato de guardado permanecen iguales; los campos añadidos son opcionales. Un resumen antiguo sin estadísticas individuales muestra una explicación y los totales que sí existen.

## Pruebas

`ResultFlowSmoke` utiliza una identidad de aplicación aislada:

- Hits, outs, home runs, activación de carta y base por bolas con bases llenas.
- Copias independientes del registro y recarga del resumen desde el guardado.
- Cifras visibles, separación de recompensas/controles y callbacks de navegación únicos.
- Victoria, derrota, doce entradas, datos antiguos y marco de 960 × 540.
- Subida de nivel, bloqueo de controles mientras está abierta y salida posterior.
- Ninguna moneda ni XP se concede desde la presentación del panel.

`FullMatchResultSmoke` juega un encuentro completo con el motor real, incluidos los turnos manuales del héroe. Comprueba que las nueve filas sumen los hits, home runs, RBI y turnos oficiales del partido; que el resultado se guarde; que la temporada avance una sola vez y que NEXT MATCH no duplique la recompensa. Contempla que un local que ya gana tras la novena alta no necesite jugar la baja.

Informes: `build/qa/smoke-result-flow.txt`, `build/qa/smoke-full-match-result.txt` y `build/qa/smoke-user-audio-assets.txt`. Los demás informes incluidos son historial, no nuevas ejecuciones de todas las pruebas anteriores.

## Abrir

Ejecuta `JUGAR.bat`. La pantalla aparece al finalizar un partido. `COMPARACION_RESULTADO.html` permite revisar el cambio sin jugar un encuentro entero.

La imagen anterior se reprodujo con el código de GameResultPanel del ZIP 0.5.5 y datos de prueba. Las capturas de victoria, derrota y subida de nivel usan casos controlados; `v056-full-match.png` procede del partido completo automatizado. Todas las pruebas usan guardados separados del tuyo.

## Fidelidad pendiente

La composición se acerca al video, pero ilustraciones, tipografía, efectos y ritmo todavía difieren del original. El rango y las recompensas utilizan las reglas existentes del remake; no se presentan como fórmulas recuperadas de Syntasia. No se han inventado premios nuevos, funciones de compartir ni clasificaciones en línea. La pantalla de temporada y la presentación previa siguen pendientes de una revisión visual equivalente.
