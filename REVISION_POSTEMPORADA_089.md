# Web 0.8.9 · Cabeza elegida y postemporada

Publicado el 8 de octubre de 2026 en Railway: 934ccb47-2c2a-4f65-a303-5279534e87ba, build b5e52e36288f6aec. [Comparación visual](COMPARACION_POSTEMPORADA_089.html).

## La cabeza que eligió el usuario

El bateador usa el renderer exacto de 0.8.6, copiado desde la fuente guardada antes de 0.8.7. Solo se renombraron la clase y el constructor a BatterHead086. Una comparación normalizada comprueba su igualdad. Se conserva la cabeza frontal, casco posterior, expresiones y los ocho rasgos del personaje guardado. Se aplica al bateador común de temporada, postemporada, Derby y Rival. Creador, HOME y retratos mantienen su renderer actual; los cuerpos y ocho intermedios de 0.8.8 permanecen. [Preferencia fijada](VISUAL_PREFERENCES.md): no sustituir esta cabeza sin una nueva indicación del usuario.

No hay imágenes nuevas generadas en esta revisión. Los atlas, recortes y celebraciones existentes se conservan.

## POST SEASON

Al terminar los treinta juegos, un equipo entre los cuatro primeros clasifica. Se crea y guarda un cuadro de ocho clubes: N-League y A-League, con emparejamientos 1–4 y 2–3. El jugador participa en N-League. Hay semifinal, final de liga y World Championship; la serie termina al ganar tres partidos. Un empate se registra sin victoria ni monedas/XP, y se juega otro encuentro. Tres derrotas eliminan al jugador. Las otras series se simulan una vez y se guardan; al quedar eliminado se completa el cuadro CPU para mostrar al campeón.

La composición se referencia en el gameplay de la Cigüeña aportado, a 20:22 y 20:28. El texto original verifica «3 Wins Required» para la semifinal. Usar tres victorias también en las dos finales es una reconstrucción explícita, no una regla del servidor recuperada. Los siete rivales son clubes CPU del catálogo existente, no equipos de amigos de Facebook. Sus resultados y probabilidades son aproximaciones locales. No se ha añadido todavía ALL STAR, WORLD MATCH ni SPECIAL MATCH.

El modo usa el viaje, alineación, introducción, bateo, simulación, estadísticas y resultado del motor actual. La cabecera y dificultad usan la liga en que clasificó el equipo, aunque el ascenso regular ya se haya aplicado. La regla existente de ascenso tras la temporada no cambia; la postemporada no concede un segundo ascenso. El marcador de cada serie, los resultados y el campeón se guardan. El historial conserva hasta treinta temporadas terminadas.

No se mezclan estos partidos con los treinta juegos regulares: quedan intactos victorias, derrotas, temporada, resumen regular y calendario. Las victorias/derrotas de postemporada entregan la fórmula de recompensa local ya existente, usando la liga clasificada. La siguiente temporada se habilita cuando el jugador es campeón o fue eliminado. Las temporadas sin clasificación pueden continuar normalmente.

## Pago y guardado

Cada partido nuevo consume una unidad de energía y una carga de cada carta equipada disponible, mediante la misma reserva que un partido regular. Volver desde la introducción es gratis. El partido pagado bloquea el inicio de un encuentro regular y cambios a sus cartas. Volver tras una recarga reutiliza su reserva incluso con cero energía. La notificación repetida de resultado no avanza otra vez ni duplica premios.

Una recarga conserva la serie, rival, cartas reservadas y pago; reinicia ese partido desde el comienzo. Todavía no se guardan la entrada, lanzamiento o corredores de un encuentro en curso. La pantalla lo indica expresamente.

Se mantienen el guardado 21 y el servidor de cuentas. PostSeason y PostSeasonHistory son campos opcionales: las carreras existentes sin ellos se cargan sin reiniciarse. Una temporada ya terminada y clasificada crea su cuadro al entrar. Una cuenta nueva empieza en nivel 1 / ROOKIE y se registra sin invitación.

## Validación

Las pruebas locales ejecutaron el cierre real del juego regular 30 y recorrieron clasificación, cuadro, viaje, alineación, introducción, partido y resultado. Un SWF diagnóstico, excluido de producción, permite finalizar el actor Game real con marcadores controlados para probar empate, avance y campeonato. Se completaron las tres rondas con tres victorias, y otra carrera con tres derrotas; se comprobaron rival, grupo y resultados cuando el jugador es cuarto y ocupa el lado visitante del cuadro. Se verificaron cobro único de cartas/energía, no premio por empate, resultado duplicado inerte, recarga con cero energía, guardado de cuadro e historial y paso a la temporada siguiente sin borrar la carrera. La galería de identidad verifica rasgos, contacto y tiempos del swing sin cambiar los dibujos elegidos.

El ejecutable final se probó localmente y por HTTPS en Railway. En la nube se registró una cuenta QA propia sin código, se completó su creación y primer partido en nivel 1 / ROOKIE, y se comprobó reentrada. Luego se importó únicamente en esa cuenta una temporada sintética clasificada: cuadro de ocho, viaje/alineación/introducción/partido, liga anterior conservada, identidad guardada y reinicio del partido pagado sin otro cobro. No se forzaron resultados en producción ni se modificaron partidas de otros usuarios. Los SWF diagnósticos responden 404. Al terminar se eliminó solo esa cuenta QA; se verificó que todas las cuentas anteriores siguen presentes.

Muestra ENTER_FRAME en Chrome local de 45.192 segundos: 2709 cuadros, 59.94 FPS, p95 17 ms, máximo 113 ms y 1 intervalo por encima de 50 ms. 16 cambios de bateador, máximo 2 ms. Es una muestra local, no una garantía para todas las computadoras.

El paquete autorizado contiene 134 archivos. Cambian WebMain.swf y version.json; restore_runtime.py conserva exactamente su código y solo difiere en finales de línea de Windows. Los otros 131 archivos son idénticos por SHA256 al paquete 0.8.8. SHA256 del ejecutable: 99a696fb563c6d6550bb1bd3f23d09a856c76c26153b919d9b5aca557b5ca003. Catorce hashes publicados coinciden, incluidos los atlas y WASM de Ruffle 0.6.0. La restauración del motor en Docker usa el mismo paquete npm oficial y verificaciones SHA256 de 0.8.8. No se empaquetan cuentas, credenciales, videos privados ni ejecutables de diagnóstico. Respaldo previo en Railway: external-v089-1791494574.sqlite3, integridad OK. Los 60 recortes de 079, siete celebraciones de 080, atlas de 083/088 y Windows histórico 067 conservan sus hashes.

## Límites

La postemporada reconstruye composición y flujo visibles; no se afirma igualdad exacta de arte, premios ni probabilidades con el original. La conexión de amigos y liga privada siguen usando el sistema existente; este cuadro nuevo es una competición individual contra CPU. El guardado durante un partido y los demás modos siguen pendientes.
