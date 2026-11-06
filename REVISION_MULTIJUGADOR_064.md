# 0.6.4 — primera prueba de retos privados

Se añadió un servidor local persistente y un cliente RIVAL integrado en MODES. Dos cuentas pueden publicar sus equipos, jugar un amistoso contra la alineación guardada del otro y consultar el mismo resultado desde su historial.

La primera entrega cumple el hito de dos cuentas y un reto compartido. La liga privada con calendario y clasificación sigue pendiente, igual que el alojamiento para jugar desde distintas casas.

## Cambios

- Acceso MODES → RIVAL · AMIGOS, con registro por invitación, inicio/cierre de sesión y recuperación de sesión cifrada.
- Vista previa de los nueve jugadores antes de publicar, atributos acotados y versiones de alineación independientes de la temporada.
- Invitaciones de un uso, equipos del grupo, retos propios/recibidos e historial paginado.
- Amistosos de nueve entradas con bateo por timing, cinco lanzamientos, simulación de compañeros y rival, bases, conteo, box score, empate y cancelación.
- Estado y resultado calculados en el servidor; reanudación después de cerrar el cliente; acciones repetidas sin efectos duplicados.
- SQLite persistente y servidor Python sin dependencias externas; lanzador local `SERVIDOR_PRIVADO.bat`.

Los archivos del motor individual y sus modelos conservan el contenido de 0.6.3. La ruta online tiene sus propias reglas de exhibición: no consume energía ni añade premios, y aún no reproduce todos los efectos especiales de cartas o habilidades. Los cuatro sonidos aportados se reutilizan sin cambiar sus archivos.

## Evidencia

Las pruebas HTTP comprueban permisos, pérdida/reintento lógico, concurrencia, reinicio, publicación versionada, marcador y estadísticas. La prueba AIR crea dos cuentas por los controles reales, pierde la respuesta de una publicación, reintenta sin duplicarla, batea, cierra durante otro lanzamiento, reanuda, termina el partido y compara el resultado desde ambas cuentas. También compara el guardado offline antes y después.

Se repitieron las rutas de HOME, equipo, LINEUP, tienda y entrada al partido individual. Las identidades de las pruebas y su base son distintas de la partida personal.

## Alcance real

Es una prueba local funcional. No se contrató ni desplegó alojamiento, no se invitó a personas externas y no se subió la partida personal. Para conexión desde otras casas falta preparar el servicio HTTPS y la distribución del cliente. Los tiempos de swing y los atributos importados del cliente aún requieren una política de confianza más estricta antes de una liga competitiva.

Consulta `MULTIJUGADOR_LOCAL.html` para las capturas y el arranque, y `online/README.md` para instrucciones, limitaciones y pruebas reproducibles.
