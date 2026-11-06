# 0.6.5 — liga privada para el grupo de amigos

El usuario confirmó un grupo de aproximadamente cinco amigos más él y juego solo en computadora. RIVAL incorpora una liga de dos a ocho equipos sobre el servidor local de 0.6.4.

## Funciona en esta entrega

- Crear una liga, unirse con el equipo publicado y salir antes del inicio. El organizador puede cancelar una inscripción abierta.
- Confirmar el inicio, cerrar inscripciones y fijar las alineaciones para todo el calendario.
- Calendario de ida y vuelta sin duplicar parejas. Seis equipos producen 30 encuentros en 10 jornadas, con cinco partidos de local por persona. Los grupos impares tienen descansos.
- Jugar o reanudar encuentros desde el calendario, ver los resultados de los otros miembros y buscar el próximo partido propio.
- Clasificación compartida por porcentaje de victorias, diferencia de carreras y carreras a favor. Empates exactos comparten posición.
- Abandono confirmado con derrota 0–9, conservando la cancelación sin resultado para los amistosos.
- Cierre automático al terminar el calendario, campeón o campeonato compartido e historial persistente.
- Migración de la base del servidor del esquema 1 al 2 con copia previa; se conservan cuentas, sesiones, equipos y retos. El guardado individual sigue siendo v21.

## Verificación

Las pruebas del servidor cubren calendarios de 2–8 integrantes, concurrencia, permisos, participantes no inscritos, alineaciones fijas, clasificación, empate, abandonos y migración. La prueba AIR usa seis cuentas aisladas: crea y se une a la liga por los controles, recorre jornadas, termina un encuentro desde la interfaz y confirma un abandono. Después completa el resto de los 30 encuentros en el servidor y comprueba que cada equipo suma diez partidos y que otro participante recibe la misma clasificación final.

Se comparan los archivos del motor individual, los modelos y los recursos con 0.6.4. La prueba AIR comprueba también que su guardado de temporada no cambia. Capturas e informes están en `build/qa`, identificados en `revision_manifest.json`.

## Pendiente

El servidor continúa limitado a esta computadora. Para que el grupo juegue desde casas distintas faltan alojamiento con HTTPS y distribución del cliente. El lanzador actual necesita el SDK AIR instalado; no es aún un instalador autónomo. No se contrató alojamiento ni se enviaron invitaciones a personas externas.

No hay playoffs, fechas límite automáticas, salas simultáneas ni premios de monedas. Se mantienen las reglas reconstruidas de exhibición y sus límites respecto a efectos de cartas y confianza en los atributos/timing enviados por el cliente. La fidelidad visual del juego original sigue siendo una línea de trabajo pendiente.

Abre `LIGA_PRIVADA.html` para el recorrido visual o `online/README.md` para instrucciones completas.
