# Multijugador privado — retos asíncronos y liga

Fecha: 26 de septiembre de 2026. Base revisada: 0.6.3, guardado local v21.

Actualización 0.6.5: están implementados y probados localmente los amistosos y la liga privada con inscripción, calendario de ida y vuelta, clasificación y campeón. El grupo previsto es de cinco amigos más el usuario, solo en computadora. Consulta `LIGA_PRIVADA.html`, `online/README.md` y `REVISION_LIGA_065.md` para el alcance comprobado. Faltan alojamiento en internet y distribución autónoma del cliente. Se conserva la revisión visual de todo el juego como objetivo. El usuario eligió **retos y liga privada, aunque los participantes jueguen a distintas horas**. El resto de este documento conserva el diseño inicial de 0.6.3; sus observaciones sobre el código describen esa versión anterior.

## Experiencia propuesta

Cada amigo instala el juego, crea un perfil y entra por invitación al grupo privado. HOME puede mostrar las tarjetas de los amigos con su equipo y estadísticas. Desde una tarjeta se visita su equipo o se propone un reto.

Hay dos experiencias diferentes:

| Opción | Qué hace cada persona | Trabajo necesario |
|---|---|---|
| Retos contra equipos guardados | Una persona batea contra la alineación publicada por su amigo; la simulación controla al equipo contrario. No exige coincidir en horario. | Cuentas, invitaciones, equipos publicados, servicio de partidos, historial y resultados validados. |
| Partido en vivo | Ambos entran a una sala y juegan sus turnos de bateo en el mismo partido; comparten marcador. | Todo lo anterior, más sincronización, reglas de turnos, tiempo de espera, reconexión y tratamiento de la latencia. |

La decisión es hacer primero los retos y después una liga privada. En estos retos, la simulación controla al equipo del amigo; no se presenta esa experiencia como control humano en vivo. Una futura sala simultánea sería una etapa distinta.

## Qué hay realmente en el proyecto

- `GameData.save/load` conserva el progreso en `SharedObject`, con esquema v21. El equipo, cartas, monedas y resultados se resuelven localmente.
- `GameData.currentOpponent/opponentForGame` construye el rival desde los datos de temporada, no desde una cuenta remota.
- El constructor de `Game` obtiene directamente el héroe, rival y alineación de `GameData`.
- `Game.finishGame` llama directamente a `GameData.completeSeasonGame`. Un amistoso online no debe pasar por esa ruta y avanzar la temporada local.
- La simulación y el bateo tienen llamadas a `Math.random`; dos clientes ejecutando el código actual no producirían necesariamente el mismo partido.
- `FriendCard` es una representación visual, no un servicio de amistad o cuentas.
- La búsqueda en `src` no encontró una capa de red para partidas o autenticación. Las peticiones existentes cargan recursos visuales y audio.

El cliente AIR puede comunicarse con un servidor por HTTPS. Esto permite aprovechar el juego actual; no implica que ya esté conectado ni que el motor esté preparado para multijugador. [Documentación de AIR](https://airsdk.dev/docs/development/networking-and-communication/http-communications/loading-external-data).

## Arquitectura propuesta

Clientes AIR de los jugadores → servicio privado de cuentas y partidas → base de datos.

El servidor conserva los perfiles online, pertenencia al grupo, invitaciones, versiones de equipos, partidos e historial. Decide los resultados oficiales a partir de acciones permitidas y reglas versionadas; no acepta como autoridad una cifra final enviada por una computadora. Para partidas en vivo distribuye además el estado compartido y sus eventos. Este patrón de autoridad del servidor está documentado, por ejemplo, en [Heroic Labs](https://heroiclabs.com/docs/nakama/concepts/multiplayer/authoritative/). La elección de proveedor o framework sigue abierta; no se ha añadido ninguna dependencia.

El cliente mantiene el dibujo y la respuesta inmediata del bateo. Verificar acciones en el servidor reduce inconsistencias y manipulación de resultados, pero no demuestra por sí solo que un tiempo de golpe enviado por el cliente proceda de una pulsación humana. La política de timing y latencia requiere una prueba específica.

## Primera entrega comprobable

1. Dos cuentas de prueba independientes entran por invitación al mismo grupo.
2. Cada una publica un equipo con identificadores estables de jugadores y una versión de alineación. Se envían solo los datos necesarios, no todo el archivo de guardado.
3. Un reto fija las dos alineaciones y la versión de reglas al crearse. Un cambio posterior en el equipo no modifica el partido pendiente.
4. El jugador completa un amistoso contra ese equipo. El servidor calcula o valida los eventos y almacena el resultado una sola vez.
5. Ambos perfiles muestran el mismo resultado. La temporada offline, monedas y cartas locales no se alteran con ese amistoso.

El primer prototipo usaría equipos de prueba y carecería de premios que afecten a la economía. Publicar el equipo de la partida personal sería una acción explícita posterior. Si se conserva la colección existente online, habrá que definir una importación validada de una sola vez, no sobrescribirla continuamente con archivos locales.

Para una liga, se deben fijar calendario, versión de plantilla por partido, reglas de local/visitante, quién juega cada encuentro y cómo se resuelven los abandonos. Una revancha será un partido distinto; nunca reescribirá el resultado anterior.

## Puntos de adaptación en el código

- Introducir una configuración de partido que permita recibir alineaciones y rival sin depender de la temporada global.
- Separar la aplicación del resultado: temporada local, amistoso de prueba y partido online tendrán destinos diferentes.
- Extraer las reglas necesarias del motor visual para verificarlas en el servidor. Versionar el protocolo y las reglas; la versión de red no tiene por qué coincidir con el esquema de guardado v21.
- Separar azar de juego y efectos cosméticos. Una semilla reproducible ayuda a probar las reglas, pero no reemplaza la validación del servidor ni debe revelar lanzamientos futuros al cliente.
- Añadir una capa de conexión con errores, cancelación, tiempos de espera y respuestas comprobadas.
- Usar identificadores únicos de partido y acción, revisiones ordenadas y transacciones para que reintentar una petición no duplique premios ni resultados.
- Mantener el guardado offline y el perfil online en espacios distintos, con una política explícita de importación.

## Pruebas antes de invitar amigos

- Dos cuentas reales ven los equipos y el mismo resultado; una tercera no autorizada no puede entrar al grupo ni modificar esos datos.
- Doble clic, pérdida de respuesta y reintento no duplican partidas ni recompensas.
- Una alineación no puede cambiar a mitad del encuentro; datos o acciones fuera de turno se rechazan.
- Cerrar el cliente y reiniciar el servicio permiten recuperar el estado persistido del reto.
- Un amistoso no avanza ni sobrescribe la temporada offline.
- Si el modo es en vivo: desconexión y reconexión, timeout de turno, estado consistente para ambos y timing probado con latencia artificial.

## Distribución y alojamiento

La ruta más directa es preparar una distribución instalable para computadora. El lanzador actual depende de un SDK en una ruta local del desarrollador y no basta para entregarlo a los amigos tal cual. El sistema operativo de los amigos debe confirmarse antes de elegir el empaquetado.

Jugar mediante un enlace de navegador o desde teléfonos requiere evaluar y adaptar el cliente; subir el SWF y este HTML de comparación no realiza esa conversión.

Primero se prueba con clientes y servidor locales. Para conectarse desde distintas casas se necesita un servicio accesible por internet, con HTTPS, almacenamiento persistente y copias de seguridad. Puede alojarse en infraestructura contratada o propia; disponibilidad, mantenimiento y coste dependen de la alternativa. No se ha contratado alojamiento, publicado el juego, enviado invitaciones ni subido partidas.

El primer modo ya está decidido: retos asíncronos y liga privada. El amistoso persistente entre dos cuentas se completó localmente en 0.6.4; la liga de seis cuentas, 30 partidos y clasificación compartida se verificó en 0.6.5. Ambos conservan aislada la temporada offline. El siguiente hito es preparar la distribución para computadoras y el alojamiento para conectar casas distintas. La implementación actual está probada en Windows; aún no se ha confirmado el sistema operativo de todas las computadoras de los amigos.
