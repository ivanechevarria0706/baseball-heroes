# Versión 0.5.9 — clases y grados de cartas

El catálogo pasa de 9 a 33 cartas. Cada una tiene dos campos distintos: clase **S, A, B o C**, y grado **HERO, ELITE, RARE o A**. Están disponibles las 16 combinaciones; cada combinación tiene dos bateadores, salvo C/A que conserva los tres iniciales.

## Qué cambia al jugar

- La colección permite filtrar clase y grado por separado y alternar entre cartas obtenidas y catálogo completo. Las cartas pendientes se pueden consultar, pero no equipar ni combinar.
- La carta muestra su clase y una etiqueta separada de grado. El panel explica la habilidad, las estadísticas, las copias y el siguiente incremento del combo. La colección completa tiene siete páginas.
- La tienda tiene sobres C, B, A y S. Un sobre de clase siempre entrega un bateador de esa clase; su grado puede ser cualquiera de los cuatro. La tienda muestra las probabilidades de grado y la excepción del primer sobre C, que sigue entregando a Lenard J.
- Los sobres mixtos de monedas y cash también pueden entregar las cartas nuevas. Las animaciones de apertura y la protección contra cobros duplicados se conservan.
- Combinar sigue consumiendo tres duplicados de la misma carta, hasta nivel 3. Mejora su aportación al combo, sin convertirla en otra clase o grado.
- Corregido un caso por el cual un identificador de sobre desconocido podía otorgar una carta sin coste. Ahora se rechaza sin alterar saldo ni inventario.

## Partidas existentes

Los nueve identificadores anteriores y sus valores de AVG, combo, habilidad, entrada de activación, POWER, CONTACT, SPEED y LUCK permanecen iguales. La etiqueta de grado NORMAL pasa a A solo para estas cartas especiales; el equipo y los jugadores regulares conservan sus grados.

La clase de las cartas anteriores queda así: Rookie Ace, Lenard J. y Tomo Wall son C/A; Mio Flash y Rex Slugger son B/RARE; Hana Clutch y Lucky Leo son A/ELITE; Golden Ken y Sora Comet son S/HERO. Se conserva el progreso asociado al identificador, sin volver a conceder ni retirar copias.

La aplicación mantiene `com.personal.baseballheroesremake` y el guardado v20. No se necesita añadir clase/grado a cada registro de propiedad: se consultan en el catálogo. Los niveles, copias, estadísticas y espacios equipados siguen guardándose como antes. No se modificaron el motor de bateo, los actores, el audio, las temporadas ni sus recompensas.

## Balance local y límites de fidelidad

La estructura de dos ejes sigue la propuesta del usuario. La referencia Wwgdb proporcionada volvió a responder 429; no se presenta su contenido como verificado. Las 24 cartas añadidas son contenido del remake, con nombres y valores nuevos; no se afirma que existieran en el catálogo original. Reutilizan los retratos actuales, no aportan 24 ilustraciones originales diferentes.

Los precios C/B/A conservan los anteriores de C/B+/A+: 6.000 monedas, 25 cash y 56 cash. B+ y A+ siguen aceptándose como alias internos de sobres. El sobre S cuesta 72 cash. Sus precios y las probabilidades de obtención son balance local, no tablas recuperadas del servidor. Cash es la moneda offline del juego.

En cada sobre de clase, las probabilidades de grado son A 60%, Rare 25%, Elite 12% y Hero 3%, salvo el primer C. Los sobres mixtos conservan sus precios y probabilidades anteriores de grado; además sortean la clase. En el de monedas: C 54%, B 30%, A 13%, S 3%; en el premium: C 10%, B 40%, A 35%, S 15%.

Las habilidades conservan las probabilidades existentes: A/antiguo NORMAL 50%, Rare 65%, Elite 80%, Hero 100%. Cada carta mantiene su entrada y tipo de hit. No se cambiaron las ventanas de timing.

Se intentó iniciar el arte de sprites con la herramienta integrada de generación de imágenes, pero respondió `usage_limit_reached`. No se generó ni integró una hoja de sprites, y no se utilizó la alternativa de API. Héroe, lanzador y retratos siguen pendientes de esa revisión visual.

## Comprobaciones de esta entrega

- Compilación del juego y pruebas en AIR con identidades distintas de tu partida.
- 33 IDs únicos, las 16 combinaciones y 1.600 ensayos de habilidades: probabilidades según grado, sin activaciones repetidas.
- 64 compras por clase, sobres mixtos, insuficiencia de fondos y solicitudes inválidas; un cobro y una carta por compra.
- Apertura por SPACE, confirmación por ENTER y repetición de entrada sin duplicar compra ni callback.
- Filtros, catálogo pendiente, estado vacío, siete páginas, límites de las cartas, equipar desde la última página y combinar desde la interfaz.
- Guardado v20 leído por un segundo proceso AIR: las nueve cartas anteriores conservan niveles/copias/AB/H/RBI y orden equipado; también una carta nueva, saldo, energía, temporada, nombre del equipo, dorsal y onboarding.
- Partido completo con Aria Nova, Mika Meteor y Yuna Breeze equipadas: nueve entradas, 21 lanzamientos manuales, estadísticas individuales reconciliadas, avance de temporada y recompensa una sola vez.
- Hashes de tus cuatro WAV y de las dos copias de cada MP3 instaladas; comparación de las nueve cartas anteriores con el ZIP 0.5.8.

Los informes vigentes aparecen en `revision_manifest.json`. Otros informes y capturas incluidos son históricos.

## Abrir

Ejecuta `JUGAR.bat`. Entra a la colección de SPECIAL BATTERS desde LINEUP o abre BATTER SHOP. `COMPARACION_CARTAS.html` muestra capturas reales de AIR antes y después, obtenidas con inventarios de prueba.

La próxima prioridad visual sigue siendo el héroe y el lanzador con sprites ilustrados. Después quedan POST SEASON/RIVAL y la calibración del partido contra los videos.
