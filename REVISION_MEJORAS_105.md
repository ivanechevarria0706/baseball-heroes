# Mejoras 0.10.5 — primera carrera y tutorial persistente

12 de octubre de 2026. Bloque autorizado: inicio ROOKIE, tutorial completo, misión única de 40.000 Coins y metas HIT + RBI.

## Evidencia y límites

Referencia: `reference_visual/nuevos_20261011/video3.mp4`. Cuadros 110 s (70 HIT / 55 RBI), 126 s (C Pack), 135 s (carta), 141 s (sustitución), 162 s (explicación del bateo), 365–373 s (punto de estadística), 391 s (FOLLOW THE BASICS / 40.000 Coins).

Se reconstruye el recorrido visible con el motor existente. No se declara una reproducción exacta de todas las pantallas, sprites o fórmulas. El ejemplo de Walker no demuestra que esa carta fuera obligatoria para todas las cuentas; se conserva el catálogo y la regla de primer C Pack del remake. Los rangos aleatorios de metas son aproximaciones. Los 20 de energía observados son energía disponible: el máximo sigue en 25 porque el video no establece ese límite.

## Cambios

- Solo las carreras nuevas comienzan en nivel 1, ROOKIE, 6.000 Coins y 20 de energía disponible.
- Tras el recorrido de equipo, creador, llegada, HOME, metas y viaje, el entrenador guía la compra de un C Pack, apertura, confirmación de la carta, uso en Special slot 1, orden y primer partido.
- Cada acción queda guardada. Recargar en el sobre o la carta muestra la misma instancia sin volver a cobrar. Reanudar un partido pendiente reinicia ese encuentro sin cobrar otros cinco de energía; no se añade un guardado de entradas a mitad del partido.
- La sustitución utiliza el mecanismo existente de cartas: Special slot 1 reemplaza al primer bateador que no sea el héroe. AUTO SORT o un movimiento válido completan la lección de orden.
- Antes de la primera pichada hay dos mensajes de entrenador. Sus botones y SPACE no disparan accidentalmente el lanzamiento; la guía se recuerda tras recargar.
- Al terminar el partido, HOME señala al héroe. El panel C/P/L permite gastar un punto real en Contact, Power o Luck, actualiza el rating y respeta el máximo de 99. Usa los puntos disponibles del sistema existente; no inventa una concesión adicional por el primer partido.
- FOLLOW THE BASICS entrega 40.000 Coins una sola vez. Se puede reclamar desde HOME o MISSIONS, con el mismo estado y registro de pago. La repetición de la presentación no recrea la misión. Omitir las lecciones antes de completarlas no paga ese premio.
- Las carreras nuevas muestran HIT + RBI del héroe en metas, HOME y marcador. Los compañeros no aumentan esos contadores. Al finalizar el partido se añaden una vez y se retira el avance temporal del HUD.

## Compatibilidad y comprobación

Guardado v22, SQLite v3. Las carreras v21 conservan nivel, liga, recursos, apariencia, alineación, inventario, cartas y misiones. Conservan sus metas HR de la temporada activa; la siguiente temporada usa HIT + RBI. No reciben automáticamente 6.000 ni 40.000 Coins y no se les impone el tutorial. El servidor acepta v21 para migrar y rechaza que una pestaña antigua rebaje un guardado v22.

Chrome local: registro real sin invitación, todo el onboarding, recargas durante sobre y carta, misma instancia y saldo, sustitución, orden, cinco de energía una sola vez, guía de pichada, reinicio de fixture pagado, liquidación con filas distintas de héroe y compañero, punto C/P/L, premio y recarga sin pago repetido. La finalización del encuentro utiliza un hook exclusivo de diagnóstico; el ejecutable publicado no incluye ese hook.

Migración en navegador con carrera sintética v21 avanzada: se comparan los campos de recursos, liga, jugadores e inventario antes/después y se prueba el rechazo de downgrade. Diez pruebas del servidor cubren además conflictos, reintentos y separación de cuentas. Los resultados locales y publicados se guardan por separado en `build/qa`.

Cabeza y cabello aprobados, ClassicBatter, PitchCadence, BattingSystem, MatchScoring, HeroSprite y RunnerSprite conservados por SHA-256. No hay cambios de audio ni de velocidad de lanzamiento en este bloque.

Publicada y verificada por HTTPS en Railway. Versión 0.10.5, build c2f23e4c7a7a26c0. Las copias SQLite creadas para publicar permanecen en `/data/backups`; no son copias externas.

Pendientes fuera de este bloque: presentación de transición entre ligas/eliminatorias, otros modos y la prueba física con un amigo desde otra computadora.
