# Franja de amigos durante el partido · 0.10.9

Entrega del punto 3 de la revisión del video y documento. Referencia: `[FACEBOOK GAME]BASEBALL HEROES play video.mp4`, 01:35, 02:47 y 08:20. La franja permanece debajo del bateo, la simulación y el resultado. SHA-256 del video: `6374fef7fd8c81beed07bd838c7ccdb68ed34afcbf0081ca9b437623abb1c7f1`.

## Cambios

- Zona de partido de 960×590 y franja social de 960×130, dentro del marco completo 960×720. Se aplica a temporada regular y postemporada. El estadio, personajes, HUD y cinemáticas reciben la altura disponible; la franja queda fuera de sus capas y máscaras.
- Hasta siete tarjetas por página con los amigos aceptados, retrato guardado, nombre, nivel, AVG, HR y RBI. Flechas para pasar páginas. Los espacios vacíos se muestran como SCOUT FRIENDS y no inventan cuentas CPU.
- Pulsar una tarjeta muestra el perfil dentro de la misma franja. El partido sigue; el clic no se propaga al bateador ni reinicia la pichada. CLOSE o Escape cierran la consulta; Escape después conserva el regreso habitual a HOME.
- SHOP, LINEUP, BUILD, RIVAL, HALL OF FAME y HOME permanecen visibles. Se habilitan al mostrar el resultado, para evitar abandonar un partido por un clic accidental. Desde el perfil también se habilita VISIT STADIUM después del encuentro.
- Caché social en memoria a partir de la última respuesta de HOME / REGISTER / visita. Si todavía no hay caché, se hace una sola petición al abrir la franja; los fallos permiten seguir jugando y reintentar manualmente. No hay peticiones sociales por fotograma ni temporizadores de actualización de amigos. Abrir el perfil no concede monedas ni modifica la alineación.
- Se corrigió la posición del LEADERBOARD en resultados de menor altura: comparte el desplazamiento horizontal del panel para que no tape RANK, BONUS ni las estadísticas del equipo.

## Conservación y validación

Guardado v23 y SQLite v4, sin cambio de esquema. El caché de amigos no se escribe en el guardado. El puente web, el código del servidor y las reglas de progreso permanecen iguales a 0.10.8. Los cambios de GameData se limitan a copiar el perfil social en memoria; los de Game, a avisar cuando se muestra el resultado. Cabeza 0.8.6, cabello, ClassicBatter, PitchCadence, BattingSystem, StarterTutorial, SkillCatalog, MatchScoring y SpecialCardEconomy conservan sus hashes. No se incorporó audio.

Pruebas locales en Chrome con dos cuentas: tarjeta real de amigo, franja durante simulación, bateo, vuelo, cinemática y resultado; clic en vuelo sin swing ni cambio de hora de lanzamiento; accesos bloqueados antes del final; visita desde el resultado; ausencia de consultas sociales durante el encuentro; regreso con apariencia, equipo y estadio propios. La medición de ocho segundos del bateo se registra en smoke-match-social109-local.json; es una prueba local, no una garantía de rendimiento en todas las computadoras.

Postemporada: marco visible y reanudación de un encuentro pagado sin otra reducción de energía. Tutorial completo: nivel 1, ROOKIE, sobre inicial y premio de 40,000 monedas una sola vez. El ejecutable público se comprueba por separado sin funciones de diagnóstico. Las cuentas temporales se eliminan al terminar; no se declara una prueba física en dos computadoras.

## Límites y siguientes pendientes

La consulta de perfil sin detener el partido y el bloqueo de accesos hasta el resultado son decisiones del remake para proteger el bateo; el video no revela todas las reglas de interacción de esa franja. Los iconos y retratos usan el arte disponible y no replican fotografías de Facebook.

Quedan las variantes de sobres y grados, tablas completas de cartas, más disciplinas y Mastery, personaje femenino, ilustración del aviso de energía, más animaciones, calibración con más muestras y modos restantes. Los precios y probabilidades sin evidencia continúan identificados como reconstrucciones.

Publicada y verificada en Railway. Build 1480f125c0b57b37.
