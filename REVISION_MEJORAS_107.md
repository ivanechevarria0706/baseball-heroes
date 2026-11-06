# Cartas, nivel 12 y resultados · 0.10.7

Primera entrega de los puntos 4, 5, 10, 11 y 12 de la lista del 12 de octubre. Fuente directa: `[FACEBOOK GAME]BASEBALL HEROES play video.mp4`, preservado con SHA-256 `6374fef7fd8c81beed07bd838c7ccdb68ed34afcbf0081ca9b437623abb1c7f1`.

## Cambios

- TRADE clase C (04:59–05:14): tres copias de la misma clase, 1,000 monedas / 7% de ascenso; 32 créditos / 100%. Cuando no asciende devuelve otra C. Pantalla clásica, confirmación y cobro usan la misma cotización. Las otras clases conservan la tabla anterior hasta tener evidencia.
- ENHANCE B Elite (05:40–06:12): 500 monedas / 7%, +1 por 5 créditos / 100% y MAX por 12 / 100%. El fallo consume el costo, conserva la copia y su mejora. +1 mantiene AVG +.010; MAX llega a +5 sin volver a cobrar tras alcanzarlo. Las otras clases y grados conservan sus tablas. Aplicar esta fila a todas las B Elite es una reconstrucción desde la carta observada; la tabla original completa sigue desconocida.
- LEVEL UP 12 (00:00): 3,000 monedas y un punto. Otras recompensas de nivel, curva de XP y capacidad de energía se conservan. Se incorporan los ocho guantes visibles a 04:04, por 10,000 monedas y con sus dos bonos. Se asocia el bloque al desbloqueo de nivel 12; el banner solo confirma directamente los nombres Panda, Pink Love y Camo y el total ocho. Los iconos son dibujos nativos reconstruidos.
- RANK: 17 hits / 6 carreras = A; 15 / 3 = B. Se mantienen los ejemplos previos 17 / 9 = S, 9 / 2 = C y 5 / 4 = D. Los umbrales entre muestras siguen siendo interpolación, no una tabla oficial recuperada.
- MVP (03:16–03:20): un compañero puede ganar el premio. Se elige el máximo RBI, con HR, hits y orden de bateo para desempatar; esa regla de desempate sigue siendo aproximada. El criterio de tres RBI se aplica al candidato del equipo. La corona identifica su fila, incluso con nombres duplicados, y la explicación del premio sigue en español.
- HALL OF FAME: comparte la selección del jugador MVP con el resultado; un premio del compañero no suma una medalla al héroe. Se mantiene el requisito previo de victoria para esa medalla.

## Conservación

Guardado v22 y SQLite v3. Ningún reinicio de cuentas ni premios retroactivos. El nivel 12 ya superado no vuelve a pagarse. Los resultados guardados mantienen sus valores y premios anteriores; abrirlos no recalcula ni cobra recompensas. Los guantes son compras opcionales y no sustituyen el equipo poseído.

La cabeza aprobada 0.8.6, cabello, ClassicBatter, PitchCadence, BattingSystem, StarterTutorial, SkillCatalog y puente de guardado web conservan sus hashes. Tutoriales y consejos en español; menús en inglés. No se ha añadido audio.

## Verificación

39 comprobaciones de modelo: límites del 7%, éxito y fallo, monedas insuficientes, copias duplicadas / equipadas / de clase distinta, bloqueo durante partido, MAX, premio único y multilevel, ocho desbloqueos, ejemplos de RANK y MVP / medallas.

Chrome: pantalla clásica real de cartas, confirmaciones, fallos, persistencia tras recarga, premio de nivel 12, resultado A/B, corona en compañero, resultados antiguos y explicación en español. Ejecutable público sin funciones de diagnóstico: TRADE garantizado y ENHANCE +1 / MAX, con revisión de saldos y doble clic. Tutorial completo con primer partido y 40,000 monedas una sola vez. Carrera v21 → v22: recursos, equipo, cartas, metas HR e importación de copia conservados. Los relojes de la copia de prueba se actualizan para separar recuperación normal de energía de una migración.

Los resultados locales y publicados se registran por separado en `build/qa`. El servidor no cambia sus reglas y los ejecutables de diagnóstico quedan fuera del paquete público.

## Pendientes posteriores

Visitas a amigos y objetos recogibles (1–3), sobres / grados / catálogo (6–9), animación (13), otras disciplinas / Mastery / precios de RUNNING (14–16), personaje femenino (17), mediciones (18–21) y modos restantes (22). Esta entrega cubre únicamente las filas observadas de las tablas de cartas y el nivel 12; no declara completados todos los precios originales.

Publicada y verificada en Railway. Build e2b10cade27cb6c0.
