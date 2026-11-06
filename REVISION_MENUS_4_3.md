# Versión 0.5.8 — marco común de 960 × 720

Esta revisión completa el primer paso del orden propuesto: todos los destinos de `Main` usan un marco 4:3. HOME, LINEUP y el partido ya lo utilizaban; se revisaron las otras 22 pantallas, incluida la vista previa heredada que no forma parte del recorrido normal.

## Cambios

- Menús, selección de equipo, creación del personaje, llegada, metas, calendario, viaje, presentación del partido, misiones, entrenamiento, habilidades, cartas, comercio y scouting redistribuidos en 960 × 720.
- Tienda: nueve artículos por página, frente a seis. TEAM: capacidad para dieciocho jugadores por página, frente a doce; se muestran los jugadores que realmente tengas.
- Equipamiento: las seis piezas y el resumen de bonificaciones quedan completos dentro del panel. El catálogo y las reglas de compra/equipado se conservan.
- Diálogos de nombre y metas centrados. La tienda de sobres tiene una capa de oscurecimiento que cubre toda la pantalla.
- BUILD ya utilizaba una composición interna 640 × 480. Ahora ocupa todo el marco 960 × 720 mediante escala uniforme.
- Derby: actores y trayectoria ajustados a la altura; marcador y resultado en capas encima del estadio. Pulsar MODES no inicia un lanzamiento. La finalización tiene una protección adicional para evitar recompensas repetidas.
- Scouting: cifras del candidato y saldo ajustados para evitar recortes y solapamientos.
- Presentación del partido: carga, VS, estadio y transición centrados. Los retratos y recursos de sus fases se liberan al cerrar la pantalla.

La ventana conserva su tamaño inicial de 1024 × 800. Al reducirla, el juego mantiene la proporción con una única escala horizontal y vertical. Puede haber márgenes negros si la ventana no es 4:3.

## Validación

- Compilación AIR del juego y de las pruebas.
- `MenuPresentationSmoke`: las 22 pantallas a 960 × 720; límites visibles de textos, botones, logos y retratos; 27 celdas de clubes; navegación de calendario y roadmap; nueve artículos de tienda y cambio de categorías; seis categorías de equipamiento; pestañas de personaje y misiones; modos activos; revelado de prospecto; apertura/cierre de sobres; capturas de las cuatro fases de presentación.
- `HomeLineupSmoke`: doce rutas reales desde HOME en una ventana reducida, con escala uniforme y centrado 4:3; regreso con ESC; consulta de ficha, sustitución explícita, arrastre con escala, persistencia de la alineación y entrada al partido con los nueve jugadores elegidos.
- `DerbySmoke`: diez lanzamientos reales mediante SPACE; diez home runs; recompensa de 3.000 monedas una sola vez, incluso al repetir la entrada tras terminar.
- Verificación de hashes de los cuatro WAV originales y ambas copias de sus MP3; identidad de la aplicación conservada.

Las pruebas usan identificadores de aplicación separados y sus propias partidas. No leen ni modifican tu guardado. Los informes actuales se enumeran en `revision_manifest.json`; los restantes informes incluidos son históricos.

## Revisar y jugar

Abre `COMPARACION_MENUS.html` para comparar las 22 pantallas con 0.5.7. Las capturas «antes» se obtuvieron ejecutando el código anterior a la conversión. Las actuales provienen de la prueba AIR; no son maquetas HTML.

Ejecuta `JUGAR.bat` como siempre. El identificador sigue siendo `com.personal.baseballheroesremake`, y el formato de guardado sigue siendo v20. Esta revisión no cambia `GameData`, las fórmulas de bateo, los catálogos o la economía.

## Siguiente prioridad

Héroe y lanzador con hojas de sprites ilustradas y animaciones coherentes entre carga, lanzamiento, contacto y reacción, usando los videos como referencia de poses y ritmo. El arte actual, las fuentes y varias composiciones siguen siendo aproximaciones. La conversión de formato no equivale a paridad visual.

Después: estructura de cartas clase × grado y catálogo ampliado; POST SEASON y RIVAL; medición del timing; funciones sociales CPU y restantes modos. La clasificación concreta de cartas necesita contrastarse con las referencias antes de migrar datos. La página de Wwgdb compartida devolvió 429 durante esta revisión; no se trató su contenido como verificado. La reseña de Gamezebo sí describe temporadas de 30 partidos, habilidades y reclutamiento de amigos, pero no proporciona las fórmulas del servidor ni un catálogo completo.

Fuentes facilitadas: https://www.wwgdb.com/games/baseball_heroes y https://www.gamezebo.com/reviews/baseball-heroes-review/. Esta revisión conserva las reglas existentes y no añade modos o estadísticas inventadas como si fueran datos confirmados del original.
