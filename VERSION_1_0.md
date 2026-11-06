# Baseball Heroes · versión 1.0.0

Publicada en Railway el 14 de octubre de 2026. Se mantiene la base del juego y se realiza el reinicio global solicitado para comenzar desde cero.

## Correcciones para el lanzamiento

El servidor vuelve a autenticar cada guardado dentro de la transacción SQLite. Una sesión revocada entre la comprobación de ruta y la escritura recibe 401 y no puede restaurar progreso. Una prueba reproduce esa carrera.

La edición 1.0 elimina una sola vez los borradores locales del juego de la etapa anterior. Conserva el almacenamiento de otras páginas y los borradores nuevos de 1.0; funciona también con localStorage bloqueado. Las sesiones anteriores quedan revocadas y los nombres de usuario antiguos vuelven a estar disponibles.

## Verificación

43 pruebas del servidor y 24 suites de Chrome aprobadas con el código final. Los diagnósticos se recompilaron antes de probar y se excluyeron de la publicación. Cinco suites adicionales en Railway verificaron autojuego, tienda, migraciones y tres partidos completos entre dos sesiones HTTPS: un reto y dos encuentros de liga, con resultados y clasificación idénticos. Los errores encontrados en comprobaciones antiguas se ajustaron a los textos españoles, el catálogo ampliado, las animaciones y la paginación actual; no se alteraron esas reglas para hacerlas pasar. El Derby se prueba con un clic inicial para enfocar el campo y después ESPACIO.

- **Inicio y personaje:** Registro sin invitación, nivel 1/Rookie, equipo, personaje, llegada, nombre y uniforme; recorrido guiado, mensajes en español y guardado.
- **Temporada y partido:** Bateo, simulación, pausa, x1/x2/x4, marcador y estadísticas; partido completo; pago único de energía y recompensas.
- **Postemporada:** Clasificación, tres rondas, victorias/derrotas/empates, eliminación, título, siguiente temporada y recarga del cuadro.
- **Cartas y economía:** Sobres, clases/grados, restricciones, revelación persistente, trade/enhance, cartas equipadas, Mystery, habilidades, misiones y Hall of Fame.
- **Equipo y entrenamiento:** Compras con ambas monedas, seis categorías, equipar/recargar, puntos de atributo, tres disciplinas, animaciones, Mastery y descansos.
- **Estadio y Derby:** Compra y activación de fondo; colocar, escalar y retirar decoración; cobro único de taquilla; diez pichadas reales y premio de Derby.
- **Multijugador:** Dos sesiones independientes publican equipos, juegan un reto, comparten resultado final y clasificación de liga; visitas y recompensas sin duplicación.
- **Persistencia y reinicio:** Respuesta perdida, desconexión, borrador recuperado, conflicto entre pestañas, migraciones v21/v22, sesiones revocadas y cuenta nueva tras reinicio.

## Reinicio

Se vacían en una transacción las quince tablas activas: cuentas, sesiones, invitaciones, guardados y su copia anterior, equipos publicados, partidos, recibos, ligas y miembros/calendario, amistades, regalos, visitas, resultados y premios de ranking. Se comprueban las claves foráneas y la integridad SQLite. Se conserva el esquema 4 y guardado 23.

Tras el reinicio, se comprueba en producción que las cookies y credenciales antiguas fallan; una petición vieja no puede guardar; una cuenta nueva empieza en nivel 1/Rookie, XP 0, 6,000 Coins y 20 de energía, sin temporada ni cartas anteriores. Conserva únicamente la carta básica Rookie Ace que entrega el inicio, sin estadísticas ni mejora. La cuenta temporal usada para esta última prueba también se retira. La base activa termina con las quince tablas vacías.

Se conserva una copia SQLite de recuperación en /data/backups del servidor, fuera de la base activa. La revisión automática rechazó descargar el contenido privado a la computadora; no se descargó. Los archivos del proyecto, arte, vídeos de referencia y respaldos del código se conservan.

## Límites conocidos

La 1.0 es el lanzamiento de este remake, no una afirmación de paridad total con el original. ALL STAR y WORLD MATCH continúan deshabilitados. Hay arte y fórmulas reconstruidos, y siguen pendientes variantes visuales completas. Recargar un partido pagado reinicia el encuentro sin cobrar energía otra vez; no restaura la jugada exacta. Las pruebas multijugador usan dos sesiones aisladas; aún falta la prueba física entre dos computadoras de amigos.

Los 158 archivos de código del juego conservan sus hashes de 0.10.17: cabeza 0.8.6, cabello, timing Rookie, simulación, economía y audio no cambian en este lanzamiento.

Build: 3b0da0c025217cca

SWF SHA256: 94be9966d808ac6666ffe292c8cab28bd91973c4b742fd0a72302495b7652cdd
