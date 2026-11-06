# Baseball Heroes 1.0.32 · viaje y llegada

**Publicada y comprobada por HTTPS.** Se retiró la cuenta temporal QA y se conservaron las cuentas anteriores.

## Cambios

TravelMapScreen y ArrivalMapScreen comparten las nuevas clases JourneyRouteView y JourneyChrome. El mapa, coordenadas de ciudades y sprites de los cinco vehículos existentes se conservan. El marco usa MatchResourceBar, ClassicChrome, ClassicActionButton y la tipografía condensada ya incluida. El panel inferior ocupa el ancho completo y muestra origen/destino, estado y barra de progreso. Los emblemas y rótulos se separan del vehículo y los rótulos cercanos se desplazan para evitar superposición.

El vehículo se crea una vez, con orientación según el destino. El recorrido dorado se actualiza al cambiar el porcentaje entero y no en todos los fotogramas. Los partidos locales mantienen el vehículo estacionario. La llegada usa el HeroHead real del personaje guardado, ajustado por sus límites, y añade SKIP / GO TO CLUB.

Se mantienen 2,800 ms de movimiento y 4,300 ms de transición automática para el viaje, y 2,600 / 4,400 ms para la llegada. Con el reloj real, el tiempo comienza en el primer ENTER_FRAME de la animación; la preparación del juego no reduce su duración visible. Un reloj inyectable permite comprobar los límites en el diagnóstico privado.

Cada salida admite un solo callback. HOME cancela sin pagar; SKIP continúa sin iniciar un partido. Tras una salida manual, un guard de captura de clics de 350 ms impide que un doble clic alcance un control de la pantalla siguiente. No retiene la pantalla cerrada; su timer y listener se liberan. La disposición también retira sus imágenes, botones y ENTER_FRAME al cerrarse.

## Referencia y límites

Se usa la referencia de viaje `reference_visual/travel_20261005/frame-0960.jpg` del gameplay aportado (16:00). Mapa y sprites existentes; ningún nuevo PNG. El marco y la colocación de marcadores son reconstrucciones nuevas del remake, no pantallas originales recuperadas. No se afirma paridad exacta ni una mejora general de FPS. La cabeza aprobada de bateo 0.8.6 conserva su fuente.

## Pruebas

Dos suites locales en Chrome. Una usa WebMain de producción sin instrumentar: registro, personaje, llegada inicial, repetición controlada de llegada, HOME, doble SKIP, transición automática, partido real y recarga. Compara la identidad confirmada y todos sus jugadores/equipamiento, preserva Coins/cartas/cargas/temporada y comprueba que el partido cobra cinco de energía una sola vez. La prueba desactiva el tutorial únicamente en su cuenta QA para aislar los recursos de la navegación; el primer onboarding normal se recorre antes de preparar esa condición.

La otra suite compila un ejecutable diagnóstico fuera de web/src, verifica a 30/60 FPS los puntos medios y límites 2,800/4,300 y 2,600/4,400 ms, cinco vehículos hacia el oeste, mismo origen/destino, Chicago/St. Louis, seis ciudades de llegada y un personaje de cabello alto. Comprueba texto dentro de sus cajas, una sola continuación, HOME, disposición y eventos obsoletos. Su SWF no está en staging y bhJourney32 está ausente del ejecutable público. Sin errores JS/AVM2 en los recorridos finales.

El recorrido de producción pasó también en HTTPS con una cuenta nueva. Sus 143 archivos instalados coinciden con el manifiesto. Se retiró la cuenta temporal preservando todas las cuentas anteriores.

## Publicación y conservación

Build `189db7cb5b4ebd6b`; SHA256 `fe1a69315d52c389084ff071643c4c043e4671b9119e36e839c3cc4268a78a44`; 39,210,253 bytes. Paquete de 147 archivos y biblioteca `3fc0e2fa5f56fa0ea94c16c3f297a269b9620260936e95ac002db4744266e336` de 114 archivos; 113 recursos reutilizados mediante enlaces duros. Solo cambian cuatro clases AS. GameData, modelos, servidor, cliente web, arte y audio anterior están conservados por hash. Guardado v24, SQLite v4 y resetEpoch conservados. No se reinician cuentas ni progresos. Copia SQLite previa con integrity_check y SHA256 comprobados.

Se archivó únicamente la biblioteca antigua 1.0.25 después de verificar sus 114 archivos locales y remotos. Ejecutable y manifiesto en `build/qa/release1032/archived1025-*`. Las bibliotecas 1.0.31 y 1.0.30 siguen en Railway. `research/restore_archived_library1032.py 1025` permite restaurar la biblioteca antigua sin activarla, comprobando espacio y hashes antes. Hay que restaurarla antes de reactivar una versión archivada. Bases de datos y respaldos no se eliminan.

[Comparación visual](COMPARACION_MEJORAS_1032.html). La prueba de amigos desde dos computadoras físicas sigue pendiente.
