# Web 0.9.1 · Mystery Boxes, llaves y sobres ganados

Publicado en Railway: 16334792-289a-4fbf-a0b0-4ff45d4691ac, build 2397f867ff1e2f07. [Comparación visual](COMPARACION_MYSTERY_091.html).

## Flujo jugable

HOME → SHOP → INVENTORY → MYSTERY. Se almacenan cofres Rookie y verdes, llaves y sobres C Pack. Abrir un cofre requiere confirmar dos o tres llaves respectivamente. Los contadores admiten cincuenta cofres de cada tipo y cuarenta llaves, como muestran los videos. Los C Pack cerrados tienen un límite local de cincuenta.

La apertura consume un cofre y sus llaves una vez, fija el premio y guarda ambos cambios juntos antes de mostrar la animación. Solo se permite un premio pendiente. Cerrar el diálogo, pulsar Escape, volver al inventario o recargar muestra el mismo premio, sin sortear ni consumir otra vez. COLLECT exige el identificador exacto de esa apertura; después de cobrarlo, un clic repetido o un identificador anterior no entrega nada.

Un premio C Pack se guarda cerrado. Abrirlo consume un sobre y fija una carta C del catálogo actual. Recogerla crea un ejemplar independiente con la mecánica existente. No cobra monedas ni suma compras al Hall of Fame. El sorteo de grado usa los pesos locales actuales de los sobres, no tablas recuperadas del servidor original.

Las nuevas recompensas de ROADMAP entregan un cofre y llaves para abrirlo. Las reclamaciones anteriores conservan sus monedas, recompensas y marca de reclamado; no se vuelven a pagar ni se convierten retroactivamente. Una bolsa llena de cofres bloquea la reclamación nueva sin marcarla como recibida. Rookie entrega el cofre naranja; los demás pasos usan el verde recuperado. No se inventan ilustraciones de cofres de ligas que no aparecen en estas referencias.

## Temporada y reglas locales

El juego 28 muestra SPECIAL en el calendario y la introducción; ganarlo añade un cofre. El juego 30 muestra RIVAL y añade dos mil monedas al premio de una victoria. El resultado informa las llaves/cofre/bono. Son las posiciones observadas en la temporada del video Cigüeña; su repetición en cada temporada es una regla local, no una regla histórica demostrada. RIVAL en el calendario sigue siendo un encuentro CPU y no sustituye los retos reales contra amigos. Los modos independientes SPECIAL MATCH, ALL STAR y WORLD MATCH siguen pendientes.

Cada victoria regular entrega una llave, hasta el límite de cuarenta, para poder abrir cofres sin Facebook. Esta fuente es una adaptación local. La postemporada no entrega estas nuevas llaves. Los premios de calendario se deduplican por liga/temporada/juego en una ventana guardada de 256 encuentros. Una derrota no entrega los bonos de victoria. Si la bolsa está llena no se añade otro cofre ni llave, y no se bloquea el avance normal de temporada. Los premios ordinarios, XP y reglas de clasificación se conservan.

Tabla local de premios: 40% monedas (1.000 Rookie / 2.000 verde), 30% C Pack, 12% llaves (2 / 3), 12% energía (3 / 5) y 6% moneda premium (1 / 2). Si ya hay cincuenta sobres, ese resultado se cambia por monedas. Las llaves y la energía respetan sus topes. Esta tabla no se conoce del original y está separada de la evidencia visual.

## Evidencia y presentación

Primer lugar 11:40, 11:50 y 12:00 muestra la pestaña MYSTERY, cantidades 3/50, 7/50 y 2/40, los requisitos de dos y tres llaves, confirmación, apertura y COLLECT con C Pack. Cigüeña 04:00 y 16:30 muestra el cofre de SPECIAL y el bono RIVAL de dos mil monedas. Los iconos sugieren más categorías de premio, incluido equipo; la categoría de equipo aún no se implementa en estos cofres. No se presentan las probabilidades ni los premios no observados como recuperados.

El panel sigue la composición sobre HOME, con SHOP/INVENTORY, tarjetas claras, contadores legibles, cuadro azul de confirmación y botón verde COLLECT. Cofres, llave y tarjeta del premio son reconstrucciones vectoriales; no imágenes extraídas nuevas. La animación de apertura dura 1,05 s y retira su listener al terminar, cerrar o salir. Se libera también HOME al abandonar el inventario. No se cambian sprites ni la cabeza preferida de 0.8.6.

## Guardado y comprobaciones

El esquema permanece en 21 con un campo opcional mysteryInventory. Una carrera vieja obtiene una bolsa vacía; conserva equipo, identidad, liga, nivel, monedas, Hall of Fame y roadmap ya reclamado. No se deducen cofres ni llaves históricos. Las cuentas nuevas siguen en nivel 1 / ROOKIE, sin invitación. Los estados pendientes válidos se normalizan y conservan al cargar.

Prueba local del modelo y la interfaz: bolsa vacía, ids inválidos, falta de cofres/llaves, requisitos de dos/tres llaves, límites 50/40, cinco ramas de premio con importes comprobados, estado pendiente, ids anteriores, reclamación única, roadmap sin pago instantáneo y recompensas de temporada. SHOP/INVENTORY/MYSTERY se recorre con clics reales; se abandona y recarga una apertura y se comprueba el premio conservado. Un sobre ganado crea una sola carta sin cobrar ni aumentar el contador de compras. La regresión de postemporada verifica clasificación, empates, campeonato, eliminación, pago único y cambio de temporada.

Ejecutable final local y publicado: registro y creación desde cero, primer partido, recarga y reentrada; migración de una carrera sintética únicamente en nuestra cuenta temporal de QA, sin modificar otras partidas. Apertura y cobro, premio pendiente y carta específica del sobre conservados al recargar. Sin errores del navegador. Se retiró la cuenta temporal y todas las cuentas anteriores siguen presentes.

Paquete autorizado de 134 archivos; catorce hashes publicados verificados. Solo cambian WebMain.swf y version.json respecto a 0.9.0: servidor, recursos y Ruffle mantienen sus hashes. No se publican ejecutables de diagnóstico, videos, contraseñas ni archivos privados. Respaldo previo external-v091-1791569224.sqlite3, integridad OK. SHA256 del ejecutable: b8c6d947c05b3bef6dce5578f5e65064b770c19be813cad7c8ab120289cc6747.

La cabeza BatterHead086 conserva el SHA256 c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f. La edición Windows histórica no se modifica. Esta revisión no introduce trabajo por cuadro en el partido; no se presenta una nueva medición de FPS ni se altera el bateo por timing.
