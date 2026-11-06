# Baseball Heroes 1.0.50

GameplayCallout usa PitchCalloutArtwork: tipografía Impact embebida como sustituta, contorno duro, extrusión, rampa de color enmascarada, inclinación y estela de entrada retenida. Reloj inyectable, demora opcional, ocultación/cancelación y eliminación de eventos. Game bombea impactCues y el rótulo antes de actualizar su cuadro, sin depender únicamente del Timer separado. No reconstruye el arte en cada frame. Se retira el antiguo workaround de fuentes del camino de compilación cuando ya no hay fuente de dispositivo que rasterizar.

Game sincroniza NICE y habilidades con el contacto, llamadas cantadas a 470 ms y Ball a 270 ms. En el fallo de swing Catch va a 250 ms y Strike a 720 ms. El plazo de regreso permite terminar el audio, evitando que el antiguo retorno a 650 ms cancelara Strike. Enter cancela los eventos pendientes y oculta el rótulo. Cuarta bola: sólo Base on Balls, sin voz de Ball superpuesta. Las jugadas no cambian en sus conteos o recompensas.

Tres suites locales: rótulos y escenarios reales de Game, recorrido público, nueve entradas. Comprobados los conteos, audio único, cancelación, conservación de identidad y estadísticas conciliadas. El diagnóstico de voz compara el cuadro visible con la llamada real; no confunde un trabajo programado con un cuadro ya presentado. Las consultas de prueba se redujeron para no bloquear el propio cuadro que se mide. Capturas detenidas sólo mediante funciones privadas que el SWF público excluye.

Servidor, esquema, reinicio, audio y arte previo sin cambios. PitchCadence, BattingSystem, probabilidades, progresión y recompensas conservados. 238 hashes remotos comprobados y cuentas/guardados comparados con el respaldo. Se retira únicamente la cuenta sintética. Se conserva 1.0.49 para rollback; 1.0.48 inactiva archivada con hashes verificados.

Build 73dab8ddf5778223; SWF 09ff907bd5ff79e72e1fd25d3eebbb575fc1db9cc22bafe90bad872943782efd.
