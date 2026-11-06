# Visitas a amigos · 0.10.8

Entrega de los puntos 1 y 2 de la lista del video y documento. Fuente directa: `[FACEBOOK GAME]BASEBALL HEROES play video.mp4`, 00:18–00:24. SHA-256 del video: `6374fef7fd8c81beed07bd838c7ccdb68ed34afcbf0081ca9b437623abb1c7f1`.

## Cambios

- El retrato de un amigo aceptado en HOME abre su estadio: personaje guardado, uniforme, número, liga, equipo publicado, fondo y decoración. El visitante conserva sus recursos en la cabecera. GO HOME regresa al estadio propio.
- Cuatro objetos del campo entregan 20 monedas cada uno. Después de cobrarlos desaparecen y siguen cobrados al recargar o volver a entrar.
- El rayo abre SHARING IS CARING. SHARE ENERGY entrega un punto al visitante y deja otro al dueño. El dueño recibe el crédito al actualizar HOME, aunque estuviera desconectado. SKIP y Escape cierran sin cobrar.
- Un diario de cobros en el servidor y los contadores del guardado impiden cobrar dos veces con doble clic, otra solicitud o una recarga. RETRY conserva el identificador original cuando se pierde la respuesta; se probó una respuesta perdida después de que el servidor ya había confirmado el premio.
- Solo se puede visitar a un amigo aceptado con equipo publicado. La respuesta contiene campos cosméticos acotados, no el guardado completo de otra cuenta.
- La guía /amigos.html incluye los pasos de registro, visita y energía compartida, en español. Los menús siguen en inglés y los consejos en español.

## Qué confirma la referencia y qué se reconstruye

El video muestra visitas a otros estadios, objetos recogibles, aumentos de 20 monedas y el aviso SHARING IS CARING / SHARE ENERGY con aumento de una energía. No confirma el calendario completo ni el límite de visitas. Para esta versión privada se adoptan cuatro objetos de monedas por amigo, reinicio diario a las 00:00 UTC, premios en hasta diez estadios distintos por día y una energía para cada cuenta al compartir. Esas son reglas del remake, no fórmulas originales recuperadas. Los objetos usan iconos disponibles; el aviso conserva una ilustración pendiente de reproducir. Las apariencias y estadios se leen del último guardado, la alineación del último equipo publicado; el equipamiento antiguo sin ID usa el aspecto básico disponible.

## Conservación y comprobaciones

Guardado v23 y SQLite v4. Migración de la base con copia automática antes de modificar el esquema. Las carreras v21 y v22 conservan nivel, XP, liga, monedas, energía, alineación, inventario, cargas de cartas y metas anteriores. Se comprueba también la importación explícita de una copia antigua. Las cuentas nuevas siguen en nivel 1 y ROOKIE, con el tutorial completo.

42 pruebas del servidor, incluidas amistad, aislamiento de perfil, cobro único tras reinicio, energía para ambas cuentas, cambio de día, límite de diez estadios y migración de SQLite. Chrome con dos sesiones: visita, monedas, SKIP, compartir, dueño desconectado, respuesta perdida y RETRY, regreso a HOME y recargas. El personaje, equipamiento y estadio del visitante permanecen iguales. Las verificaciones local y publicada se registran por separado en build/qa; no se afirma una prueba con dos computadoras físicas.

Cabeza 0.8.6 aprobada, cabello, ClassicBatter, PitchCadence, BattingSystem, StarterTutorial, SkillCatalog, MatchScoring y SpecialCardEconomy conservan sus hashes. No se añadió audio. Los ejecutables de diagnóstico quedan fuera de producción.

## Pendiente

El punto 3, franja social persistente durante todo el partido, sigue pendiente. También quedan por completar las tablas y catálogos no observados, disciplinas de entrenamiento / Mastery, personaje femenino, más animaciones y modos restantes. Esta entrega no declara paridad total con el original.

Publicada y verificada en Railway. Build 86c9f0ed6b676994.
