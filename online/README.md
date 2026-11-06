# Servidor privado — retos y ligas por internet

Versión de cliente: 0.6.7. Protocolo: 1, con capacidad `private-leagues-v1`. Base del servidor: esquema 2. Reglas de partido: `private-exhibition-1`.

**Servidor alojado:** `https://baseball-heroes-api-production.up.railway.app`. El cliente portátil completó nueve entradas por HTTPS, recuperó un lanzamiento tras reiniciar Railway y ambas cuentas recibieron el mismo resultado y clasificación de liga. Abre `CONEXION_AMIGOS.html` para crear tu primera cuenta; no hace falta iniciar el servidor local para usar el alojado. Los pasos siguientes describen también el modo local, que se conserva.

El grupo previsto es de unos cinco amigos más el usuario, jugando solo en computadora. La liga admite entre dos y ocho equipos. Comparte `Baseball_Heroes_para_amigos_Windows_v067.zip`: al extraerlo completo, abre `BaseballHeroesRemake.exe`. Incluye el runtime para Windows x64 y no requiere instalar AIR, Java, Python ni el SDK. Se verificó en esta computadora; falta probarlo en una segunda PC.

## Probar en esta computadora

1. Abre `SERVIDOR_PRIVADO.bat` desde la carpeta principal. Conserva la ventana abierta. Muestra la dirección `http://127.0.0.1:8765` y, si aún no hay cuentas, una invitación inicial de un uso.
2. Abre `JUGAR.bat`. En HOME, entra a **MODES → RIVAL · AMIGOS**.
3. Escribe un usuario (3–24 letras, números o guion bajo), contraseña de al menos ocho caracteres, nombre visible e invitación. Pulsa **CREAR CUENTA**.
4. Pulsa **PUBLICAR MI EQUIPO**, revisa los nueve jugadores y confirma. Se comparten nombre, color, orden, héroe y atributos básicos. No se sube el archivo de guardado.
5. Pulsa **INVITAR** y copia el código. Cierra la sesión, crea una segunda cuenta con él y publica su equipo. También se puede usar otra instancia del cliente para una prueba local; cada pantalla mantiene su sesión actual, mientras la sesión recordada al reiniciar será la última guardada.
6. Vuelve a la primera cuenta y pulsa **RETAR** junto al equipo de la segunda.
7. Pulsa **LANZAR** o ESPACIO. Durante el vuelo, ESPACIO o **BATEAR** ejecutan el swing; **DEJAR PASAR** toma el lanzamiento. **AUTO TURNO** simula la aparición de tu héroe. Sus compañeros y el equipo rival se simulan en el servidor.
8. Al terminar, ambas cuentas encontrarán el partido en su historial y podrán abrir el resultado y sus estadísticas.

Los amistosos duran nueve entradas. Si terminan igualados, se registra empate. No hay prórroga, premios ni cambios de temporada. Puede haber un reto propio pendiente por cuenta; se puede reanudar o cancelar desde el historial. Cancelar requiere confirmación y no equivale a una derrota.

Para parar el servicio, pulsa Ctrl+C en su ventana. Reiniciarlo conserva cuentas, equipos, invitaciones utilizadas, sesiones y partidos en `online/data/private.sqlite3`. Si el puerto está ocupado, comprueba si ya hay otro servidor abierto.

El lanzador busca primero `BH_PYTHON`, después el Python que está disponible en esta computadora y finalmente `python` en PATH. Requiere Python 3.12 o superior y no instala paquetes. Desde una terminal también se puede ejecutar `python online/server.py --port 8765`. Si el administrador necesita una nueva invitación: `python online/server.py --new-invite` con el servicio anterior detenido.

## Crear y jugar una liga

1. Si estaba abierto el servidor de 0.6.4, ciérralo antes de abrir `SERVIDOR_PRIVADO.bat` de esta versión. La primera actualización desde el esquema 1 crea una copia `online/data/private.before-leagues-v2.sqlite3` y conserva usuarios, sesiones, equipos y retos. La partida individual mantiene su guardado v21.
2. En **RIVAL**, publica tu equipo y entra a **LIGA PRIVADA**. Escribe un nombre y pulsa **CREAR**.
3. Tus amigos entran con sus cuentas, publican su equipo y eligen **UNIRME** en esa liga. En esta prueba local puedes cambiar de cuenta para representar a cada participante.
4. Cuando todos estén inscritos, el organizador pulsa **INICIAR LIGA** y confirma. A partir de ese momento se conservan las alineaciones publicadas de todos durante el calendario completo. Mejorar o volver a publicar un equipo no cambia esa liga ya iniciada.
5. Cada persona juega los encuentros donde aparece como local. **MI PRÓXIMO** lleva a la jornada de su siguiente partido pendiente. Se pueden jugar jornadas distintas sin esperar a los demás; la visita se simula con el equipo guardado de su amigo.
6. **ACTUALIZAR** obtiene la clasificación y los resultados compartidos. Los integrantes pueden consultar también los partidos de los demás, pero solo el local controla sus turnos.

Se programa una ida y una vuelta por cada pareja. Con seis participantes: **30 partidos, 10 jornadas, 10 encuentros por equipo, cinco de ellos como local**. Los grupos impares reciben descansos. Se admite una liga organizada por cuenta que esté abierta o en curso; una cuenta puede participar en ligas de otros integrantes.

Antes del inicio se puede salir de la inscripción; el organizador puede cancelarla. Una liga en curso conserva su calendario. Cerrar el juego no abandona un partido: queda disponible para reanudar. **ABANDONAR** dentro de un encuentro de liga pide confirmación y registra derrota administrativa del local por 0–9. No añade estadísticas individuales ficticias. En amistosos sigue existiendo la cancelación sin resultado.

La tabla muestra PJ, G, P, E, PCT y diferencia de carreras. PCT es `(victorias + empates / 2) / partidos jugados`. Los desempates usan diferencia de carreras y después carreras a favor. Un empate completo comparte posición; al terminar todo el calendario, puede haber campeonato compartido. No hay puntos, premios de monedas, playoffs, plazos automáticos ni eliminación de resultados finalizados.

## Conexión desde otras casas

**El servicio de internet está publicado en Railway.** Usa la dirección HTTPS indicada al principio. `127.0.0.1` sigue significando la computadora donde se abre el juego y se reserva para la prueba local.

`server.py` mantiene el lanzador local restringido a loopback. `production.py` aloja la misma API detrás del gateway HTTPS de Railway, con volumen persistente, límites y copias diarias. Hay una copia externa descargada y verificada; todavía no se descarga automáticamente. Consulta `RAILWAY.md` y `deployment_status.json` para el alcance verificado. El antiguo `JUGAR.bat` sigue disponible para desarrollo; tus amigos usan el ejecutable del ZIP portátil.

El cliente acepta HTTPS para el servicio remoto y HTTP únicamente para localhost/127.0.0.1. No sigue redirecciones cuando envía la sesión. La sesión se recuerda mediante EncryptedLocalStore; la contraseña no se guarda en el cliente. En SQLite se almacenan hashes de contraseñas con scrypt y hashes de tokens e invitaciones, no sus valores en texto plano.

## Qué se valida y qué falta

- Registro por invitación de un uso, con vencimiento a las 72 horas. Todos los miembros del servicio pertenecen a un único grupo privado en esta prueba.
- Las alineaciones publicadas se validan y versionan. Cada reto guarda una copia independiente de ambas.
- Solo quien crea el reto controla sus turnos. El otro participante consulta el estado. Otras cuentas no pueden leer ese partido individual.
- El servidor genera lanzamientos, simula jugadores y calcula bases, entradas, estadísticas y resultado. No hay una operación que acepte el marcador final propuesto por el cliente.
- Transacciones SQLite y recibos de acciones evitan duplicados al reintentar. Cerrar el cliente durante un lanzamiento permite recuperarlo; ese lanzamiento se representa de nuevo al reanudar.
- Las reglas online son una primera reconstrucción independiente. No incluyen todavía todos los efectos de cartas, combos y habilidades del motor individual. Los atributos publicados sí provienen de los cálculos efectivos del cliente, acotados para el prototipo.
- La publicación de una alineación local no acredita que sus atributos se hayan ganado legítimamente. El tiempo de swing sigue siendo un dato del cliente: comprobar su rango no demuestra una pulsación humana. Esta entrega no es una competición resistente a trampas.
- Calendario, inscripción, clasificación y cierre de liga están implementados. Playoffs, múltiples grupos y partidos simultáneos siguen pendientes.

La presentación reutiliza los actores, estadio y sonidos existentes. No es una nueva recuperación de sprites originales ni termina la revisión de fidelidad visual.

## Verificación

`python -m unittest discover -s online -p "test_*.py" -v` ejecuta pruebas HTTP con bases temporales y puertos libres: autorizaciones, invitaciones, esquema, alineaciones fijadas, resultados compartidos, reinicio del servicio, peticiones concurrentes y repetidas, cancelación y cierre de sesión. Incluye calendarios de dos a ocho equipos, seis participantes, permisos de liga, clasificación, empate, abandono, finalización y migración desde una base del esquema 1.

`online/qa_fixture.py` levanta exclusivamente un servidor de prueba en el puerto 8766. Genera una configuración temporal en `build/qa/online064-config.json`, que contiene credenciales de prueba y debe excluirse de cualquier distribución. Además, pierde intencionadamente la respuesta de la primera publicación para comprobar el botón REINTENTAR y su idempotencia.

Con ese fixture activo, `tests/Online065Smoke.as` compilado y ejecutado con `build/Online065Smoke-app.xml` verifica los controles AIR reales, incluidos reintentos y reconexión del amistoso. Tiene una identidad de aplicación distinta a la partida personal. La prueba histórica `HomeRoutes064Smoke` verificó las rutas individuales en 0.6.4; esos archivos se comparan con la versión anterior y no cambiaron en 0.6.5. Informes y capturas están en `build/qa`; `revision_manifest.json` enumera únicamente los informes vigentes.

`online/qa_fixture_league.py` prepara seis cuentas temporales en 8767 para `tests/League065Smoke.as`, ejecutado mediante `build/League065Smoke-app.xml`. La prueba crea la liga y una inscripción por los controles reales, incorpora seis participantes, verifica jornadas, termina un partido desde AIR, prueba abandono, completa el calendario en el servidor y compara la clasificación final desde otra cuenta. Su configuración `build/qa/league065-config.json` contiene tokens de prueba y se excluye de los paquetes, igual que todas las bases de datos.

No publiques `online/data`, bases SQLite, credenciales de pruebas o archivos de configuración de sesiones dentro de un paquete del juego. Conserva una copia de seguridad de la base real antes de actualizar el servicio.
