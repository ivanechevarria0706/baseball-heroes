# Análisis de jugabilidad 1.0.41

La revisión se centró en los dos problemas indicados: contacto difícil de leer en Rookie y especiales inmóviles. Se revisaron el motor real, sus entradas de teclado/ratón, los relojes, la geometría de la pelota, el orden de bateo, las reservas de energía y las rutas de LINEUP. No se atribuyen valores nuevos al juego histórico.

Problemas confirmados y corregidos:
- La pelota visual usaba smoothstep y terminaba frenándose; el contacto se evaluaba antes de llegar al endpoint. Ahora cruza el blanco al instante de scoring y continúa con profundidad monótona.
- Bola grande en el último tramo y estela larga. Escala y estela contenidas para dejar visible el aro.
- Rookie mantenía un vuelo rápido y una ventana corta para aprender. Nuevo rango1.10–1.60s, GOOD más tolerante y señal verde temprana, sin asegurar un hit.
- El teclado repetía KEY_DOWN al mantener ESPACIO, capaz de batear al salir de WINDUP. Se acepta una pulsación por liberación.
- El swing apuntaba a la última posición dibujada y evaluaba el reloj actual. Ambos se muestrean ahora juntos al pulsar.
- Las cartas cubrían las primeras filas no hero, sin posición propia; los controles prohibían arrastrarlas. Ahora la colocación se conserva y se usa en el partido.
- Los normales desplazados por una carta quedaban fuera del banco visible. Ahora se muestran como suplentes.
- El gráfico de equipo ignoraba a los especiales y no se renovaba al sustituir. Ahora usa la alineación visible y se actualiza.

Qué sigue necesitando evaluación humana: sensación de retraso de SPACE en distintas tasas de cuadros, visibilidad en lanzamientos exteriores y estadios distintos, duración de las transiciones de contacto/resultados y ritmo del autojuego. No se han alterado estos últimos tiempos ni se ha repetido una temporada completa en esta revisión. La frecuencia de turnos manuales se conserva, como pidió el usuario.
