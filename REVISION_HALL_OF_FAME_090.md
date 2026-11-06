# Web 0.9.0 · Hall of Fame y misiones de rendimiento

Publicado el 9 de octubre de 2026 en Railway: 352da386-394e-4e04-87af-8e363899a0cc, build 7b3c60eeea5e2bf9. [Comparación visual](COMPARACION_HALL_OF_FAME_090.html).

## Lo que cambia

HOME tiene un botón HALL con el número de premios disponibles. El salón muestra dos páginas de tarjetas en dos columnas y contadores de bronce, plata, oro y diamante. Cada trofeo abre su progreso y recompensa; solo un premio alcanzado y no reclamado habilita CLAIM REWARD. Los trofeos ya recibidos siguen marcados después de cerrar sesión, recargar o cambiar de temporada. El resultado de partido avisa si hay premios disponibles en HOME.

Se añaden dos misiones: Juego muy cerrado (dos victorias por una carrera, 750 monedas) e Hit múltiple (tres partidos completos con al menos tres sencillos del héroe en cada uno, 820 monedas). Las tres misiones anteriores conservan sus ids y reclamos. Las cinco pestañas caben en el panel; el entrenador provisional se sustituye por TrainingArtwork.seasonCoach, ilustración original recuperada previamente. Se libera su bitmap al cambiar de misión o cerrar el menú. Esta revisión no genera ni modifica PNGs.

## Hitos comprobados en los videos

| Logro | Bronce | Plata | Oro | Diamante |
|---|---:|---:|---:|---:|
| Rey de jonrón | 100 | 200 | 450 | 900 |
| Bateador de gran poder (grand slams) | 10 | 30 | 60 | 100 |
| Bateador de oportunidad (RBI) | 150 | 500 | 1000 | 1500 |
| Bateador de hit | 200 | 800 | 1800 | 3000 |
| El jugador más valioso | 50 | 100 | 200 | 400 |
| Bateador del triple | 50 | 150 | 300 | 500 |
| Mejor buscador (cartas compradas) | 20 | 40 | 80 | 150 |
| Maestro de intercambio | 5 | 15 | 30 | 70 |

Referencias: Explicando 14:34 y 14:40; Cigüeña 13:40; Primer lugar 11:00. Son ocho logros, con treinta y dos trofeos en total; no se presenta como recuperado el catálogo original completo de treinta y cinco objetivos. Quedan fuera amigos, regalos y publicaciones de Facebook.

El video verifica 2.000 monedas para el primer trofeo de triples y 4.000 para plata en compras/intercambios. Los demás premios no están confirmados: se usa una escala local de 2.000 / 4.000 / 8.000 / 16.000 monedas por nivel. El criterio local de MVP es el mejor HIT + 2×HR + RBI del equipo en una victoria; si hay empate decide el orden de bateo. No se afirma que ese criterio ni todos los premios sean los del servidor original.

## Estadísticas y guardado

MatchBoxScore ahora distingue sencillos, dobles, triples, grand slams y al héroe, sin alterar los totales anteriores del marcador. Un HR con cuatro RBI cuenta como grand slam. CareerAchievements confirma los contadores del héroe al terminar cada partido regular o de postemporada; los hits de compañeros no se suman a sus logros. La misión de margen consulta el marcador final del equipo. Se guarda una ventana de 256 claves de encuentros confirmados para evitar repetir un conteo. No se suman los nuevos contadores de partido al abandonar o reiniciar una entrada.

Las compras exitosas de sobres y SCOUT cuentan una carta. TRADE cuenta una operación, aunque consuma tres ejemplares; su carta recibida no se cuenta como compra. Operaciones rechazadas por fondos, selección o partido activo no avanzan esos contadores. No se otorgan premios desde la vista ni por dibujar el salón: el modelo valida id, nivel, objetivo y reclamo previo, marca el premio y guarda monedas/estado juntos.

El guardado sigue siendo 21 y añade un campo opcional hallOfFame. Una carrera anterior sin ese campo conserva los totales explícitos del héroe (hits, HR, RBI, triples), las victorias de roadmap y las compras conocidas del contador SCOUT. No se adivinan grand slams, MVP, compras históricas de sobres ni intercambios que no estaban registrados. Estos detalles empiezan en cero. Las antiguas estadísticas del héroe conservan su semántica previa por aparición; los contadores nuevos posteriores a la migración se confirman por partido terminado.

La postemporada conserva su cuadro, historial y reglas. Los logros sobreviven al paso a la siguiente temporada. El bateador conserva exactamente BatterHead086 y los cuerpos de 0.8.8; no se cambian rostro, casco, bateo por timing, probabilidades ni servidor de cuentas. Las cuentas nuevas siguen en nivel 1 / ROOKIE y se registran sin invitación.

## Pruebas

Prueba local del salón: cuenta nueva sin trofeos, ambas páginas y diálogos, hitos bloqueados/alcanzados/reclamados, estadísticas individuales del MatchBoxScore real, compañeros excluidos, claves duplicadas inertes, tres partidos completos, premios de 2.000/4.000 y misiones de 750/820 entregados una vez. Compras, SCOUT, intercambio y errores de fondos comprobados. Guardado y recarga conservan el estado. Sin errores del navegador.

Regresión de postemporada: cierre del juego 30, clasificación, viaje/alineación/introducción/partido/resultado, empate, campeonato y eliminación, pago único, recarga con cero energía, tabla de ocho clubes e historial. Los nuevos contadores no se pierden al cambiar de temporada ni agregan una victoria por un empate.

Ejecutable final local y publicado: registro y creación completos, primer partido en nivel 1 / ROOKIE, reentrada, y migración de una carrera sintética perteneciente únicamente a nuestra cuenta QA. Se conserva identidad, liga, nivel, monedas y totales conocidos. El salón publicado permite reclamar un premio y, tras recargar, no pagarlo de nuevo. Ambas misiones se reclaman una sola vez. No se importaron ni modificaron partidas de otras cuentas. Los diagnósticos no se publican; responden 404. La cuenta QA se retiró y se confirmó que todas las cuentas previas siguen presentes.

Muestra de Chrome local: 45.099 s, 2706 cuadros, 60.00 FPS, p95 25 ms, máximo 47 ms y 0 intervalos superiores a 50 ms. 17 cambios de bateador, máximo 1 ms. Es una muestra de esta computadora.

Paquete de 134 archivos autorizado y catorce hashes publicados verificados. SHA256 del ejecutable: 6f64e1f0caa8886facf7d2d461e16cac12568ac911b712355f469d027f711b24. Servidor, assets y Ruffle conservan sus hashes de 0.8.9; solo cambian el ejecutable y version.json. La restauración del WASM conserva el mismo código y paquete oficial fijado. Respaldo previo external-v090-1791527664.sqlite3, integridad OK. Los atlas de 083/088, 60 recortes de 079, siete celebraciones de 080 y Windows histórico 067 permanecen intactos. No se empaquetan credenciales, videos privados ni ejecutables de QA.

## Pendiente

Más logros y misiones cuando exista evidencia legible, completar el catálogo social mediante el sistema de amigos real y los modos ALL STAR / WORLD MATCH / SPECIAL MATCH. Las ilustraciones de trofeos son reconstrucciones vectoriales; no sprites originales recuperados. No se cambia el límite existente de recargar un partido: conserva pago y serie, pero reinicia el encuentro.
