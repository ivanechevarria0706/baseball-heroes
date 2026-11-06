# Carrera inicial y progresión · 0.6.9

Se retiraron los valores de demostración que empezaban la cuenta en nivel 8 con 34,432 XP, 336,450 monedas y compañeros de nivel 11–36. Una nueva partida comienza en **nivel 1, ROOKIE, temporada 1 y partido 1**, con XP y resultados en cero.

La plantilla inicial tiene doce jugadores de nivel 1 y nueve puestos de bateo. Sus promedios, HR, RBI y estadísticas de carrera empiezan en cero. Se entregan seis piezas básicas y una carta Rookie Ace C/A, con un slot especial. El fondo inicial es 5,000 monedas, cero Cash y energía completa 25/25. Es un balance inicial de esta reconstrucción; no se presenta como la tabla económica recuperada del original.

## Errores corregidos

- La carga del inventario añadía las doce piezas de demostración en cada inicio. Ahora solo completa las seis piezas básicas que falten y conserva los objetos obtenidos por el jugador.
- Los compañeros arrancaban con estadísticas históricas inventadas y atributos de un equipo avanzado. Ahora la carrera se construye desde una plantilla principiante.
- Cada subida de nivel anunciaba LIGHTNING, BOMBER y BUFF aunque no se entregaban ni se desbloqueaban. El aviso ahora muestra el cambio de nivel y los premios reales: monedas, puntos de habilidad y capacidad de energía. El acceso de la tienda sigue dependiendo de la liga.

## Partidas existentes

El campo adicional `careerStartVersion` mantiene la compatibilidad del esquema de partida 21. Una demostración intacta se reconoce por sus antiguos valores de cuenta, niveles y atributos de la plantilla, sin resultados, entrenamiento, scouting ni misiones reclamadas. Solo ese caso se corrige automáticamente a nivel 1, conservando identidad, aspecto del héroe y avance del tutorial. La corrección no vuelve a ejecutarse después de ganar progreso.

Las carreras jugadas o modificadas se conservan. La barra web incorpora **NUEVA CARRERA**: explica el reinicio, pide confirmarlo, guarda los cambios anteriores y descarga un JSON de respaldo antes de comenzar desde nivel 1 y ROOKIE. Se mantienen la cuenta, el nombre y aspecto del héroe y los retos y ligas del servidor. La nueva carrera vuelve a la selección del equipo/tutorial. Para actualizar el equipo que ven los amigos, hay que volver a publicarlo desde RIVAL.

## Verificaciones

`build/qa/smoke-web069-career.txt`: inicio real en Chrome/Ruffle, carga del guardado, XP hasta nivel 2 sin ascenso de liga, persistencia de un objeto obtenido, cancelación sin pérdida, reinicio con descarga previa, corrección de la demo una sola vez y conservación de una carrera antigua con nivel 11 y DOUBLE-A.

`build/qa/smoke-web069-full-match.txt`: partido completo con la plantilla de nivel 1; nueve entradas y doce lanzamientos manuales, estadísticas de los nueve bateadores consistentes, resultado recuperado, avance de temporada y premios una sola vez.

El empaquetado de producción excluye los SWF de pruebas y los archivos privados. Las huellas están en `research/railway-web069-manifest.json`. La versión web anterior permanece en `research/railway-web068-stable`; la edición Windows 0.6.7 se conserva. El estado final de la publicación y de las pruebas por HTTPS se registra en `deployment_status.json`.

Publicado el 2 de octubre de 2026: Railway confirmó SUCCESS para `4c455c9f-e9bf-4f9e-988c-336f337b1232`; HTTPS /health y el manifiesto publicado coinciden con lo probado. Dos cuentas temporales del servidor real empezaron en nivel 1, ROOKIE, cero XP y seis piezas básicas. El reinicio descargó el respaldo y mantuvo el reto y la liga compartidos; importación, nuevo inicio de sesión y partido online de nueve entradas también pasaron. Informe: `build/qa/smoke-cloud069-web.txt`.

Se retiraron las dos cuentas QA y su partido/liga conservando las cuentas reales. Las copias externas antes y después del despliegue, `external-v069-1790929038.sqlite3` y `external-v069-1790929414.sqlite3`, tienen integridad verificada. Informes: `build/qa/smoke-cloud069-cleanup.json` y `build/qa/smoke-web069-backup.txt`.
