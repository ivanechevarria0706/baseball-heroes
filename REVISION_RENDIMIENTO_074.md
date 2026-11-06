# Web 0.7.4 · Pausas durante el juego en Chrome

Se reprodujo una pausa de unos 2,5 segundos durante los cambios de bateador. `advanceBatter()` reconstruía un `ClassicBatter` para cada compañero simulado y ejecutaba `warmAll()` sobre sus dieciséis poses. Cada paleta analizaba y recoloreaba los píxeles en ActionScript. Los nueve jugadores también superaban las seis paletas inactivas permitidas en la caché, por lo que el trabajo se repetía en las entradas siguientes. Esos actores estaban ocultos y los compañeros solo participaban mediante la simulación.

El partido ahora prepara y conserva únicamente el actor del héroe, independientemente de su lugar en la alineación. El orden, los jugadores del modelo, el bateo por timing, los resultados y las probabilidades siguen funcionando con sus datos anteriores. Se evita preparar los retratos del HUD mientras está oculto; el panel de simulación sigue actualizando sus propias estadísticas. Los defensores no recalculan una pose quieta cada cuadro.

El estadio completo utiliza una caché de renderizado estática. Se elimina además la construcción del antiguo campo que quedaba cubierto por MatchStadium. Se conservan las ilustraciones, las decoraciones y el campo de respaldo ante errores de carga. No se reduce la calidad de los personajes ni la frecuencia de 60 cuadros del partido; HOME conserva sus 30 cuadros.

## Medición local

Chrome aislado, mismo equipo y escenario ROOKIE, al menos 60 segundos por muestra, con lanzamientos manuales y simulación a x4. La medición incluye diferentes resultados de la simulación; no pretende ser una repetición determinista de cada jugada.

| Medida | Antes | Después |
|---|---:|---:|
| FPS medio del partido | 37,47 | 59,98 |
| Cuadro más largo | 2.527 ms | 112 ms |
| Cambio de bateador más largo | 2.512 ms | 1 ms |
| Cuadros de más de 50 ms | 10 | 1 |

Son resultados de esta prueba, no una garantía para todos los equipos. La preparación inicial del partido aún puede tardar; esta revisión elimina principalmente las pausas repetidas durante las jugadas.

## Pruebas y conservación del progreso

- `smoke-performance074.txt`: comparación validada de cuadros y cambios de bateador. Los JSON y perfiles de CPU conservan las muestras completas.
- `smoke-full-match074.txt` y `smoke-full-match074-fourth.txt`: partidos completos con el héroe primero y cuarto; reconciliación de hits/HR/RBI/turnos, resultado recargado, avance de temporada y premio una sola vez.
- `smoke-home074.txt`: navegación, fichas, entrenamiento, paginación, cobro, seis fondos y respaldo ante fallo; estadio dentro de un partido.
- `smoke-production-match074-local.txt` y `smoke-cloud-match074.txt`: ejecutable real, héroe cuarto en la alineación, PLAY y teclado, muestra de renderizado de 20 segundos, consumo de una energía, recarga de recursos/orden y registro sin invitación.
- `smoke-web074-staging.txt`: paquete exacto, base vacía y exclusión de los ejecutables de diagnóstico.
- `smoke-web074-compact.txt`: arranque desde el paquete reducido, los 112 recursos compartidos con SHA-256 verificado, igualdad de todos los archivos web con el paquete completo y rechazo de recursos alterados.

Se mantiene el esquema 21. No se reinician partidas ni cuentas; las nuevas siguen en nivel 1 de ROOKIE. Las pruebas usan cuentas temporales y no abren la partida personal. Los respaldos permanecen dentro del volumen de Railway. El ejecutable Windows 0.6.7 conserva su compilación anterior.

La actualización web debe cargarse desde el aviso de nueva versión o recargando la página después de que indique Guardado en la nube. Un partido ya abierto sigue usando la compilación anterior hasta recargar.

## Publicación

Los primeros envíos fallaron en Railway antes de crear una compilación. El nuevo envío del 5 de octubre aceptó el paquete completo `research/railway-web074-source` (46,3 MB). Su imagen incluye todos los gráficos, sonidos y Ruffle 0.6.0, y arranca mediante `production.py`, como la versión anterior.

También se preparó y probó una alternativa compacta de 5,9 MB. Los 112 recursos compartidos se conservaron con SHA-256 verificado en `/data/web-static/common-92739d8ad4f9c464`. `restore_web_assets.py` puede reconstruirlos antes de arrancar y rechaza recursos alterados. Esa alternativa no se activó; el paquete completo no depende de dicho bundle. No se cambió el comando de inicio ni se activó el lanzamiento experimental desde el volumen.
