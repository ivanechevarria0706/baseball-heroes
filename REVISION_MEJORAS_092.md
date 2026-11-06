> Corrección 0.9.3: el usuario confirmó que SINGLE y DOUBLE contienen al narrador del gameplay. Esos cortes se retiraron, junto con los demás efectos sin verificar. La revisión automática de habla documentada abajo no demostraba limpieza. Solo permanecen activos los cuatro efectos aislados por el usuario. Véase REVISION_MEJORAS_093.md.

# Web 0.9.2 · Partido, condición y presentación

Publicada en Railway: 24e0b383-72c8-44a6-b1b2-39af2c0b53df, build 8e70b0577153b866. [Comparación de 14 vistas y cuatro sonidos](COMPARACION_MEJORAS_092.html).

## Alcance de los puntos elegidos

| Punto | Implementado | Límites de fidelidad |
|---|---|---|
| 2 | Cierre WALK-OFF en novena/extra por HR, hit, walk o compañero; llegada del equipo antes del resultado. | Se usan las poses disponibles; falta la ilustración panorámica exacta. |
| 3 | Libro de jugadas por partido, SCORE, rachas de hits/HR y multiplicadores del héroe. | Las tablas históricas no se conocen. |
| 4 | GAME, WINNER, MVP, RANK y BONUS con entrega visual escalonada. | El desglose distribuye las monedas ya concedidas; no cambia el presupuesto existente. |
| 16 | Energía y condición individual de regulares, flechas, AUTO SORT y UNSTARTABLE / SKIP. | Recarga y modificadores son locales. |
| 18 | 27 objetos permanentes adicionales, niveles 30/50/70, atributos visibles de +400. | Precios/variantes locales. No incluye bates consumibles del punto 1. |
| 21 | Ave/plumas, dos alienígenas y alienígena morado: vuelo de pelota, impacto, reacción y HOME RUN. | Atlas nuevo de seis poses; faltan cuadros intermedios originales. |
| 22 | Seguimiento de pelota, persecución/recepción del defensor, fly/ground con trayectorias distintas, blancos/flecha y multiplicador. | Se interpolan las poses existentes. Corredores, cámaras y reparto de animaciones aún son parciales. |
| 24 | FACE ETC opcional, dibujos de bate de la hoja aportada, iconos de equipo, entrenador ilustrado y fuentes embebidas en varios paneles. | BUILD, DRAFT, escenarios y el catálogo completo requieren más trabajo. Las fuentes son sustitutas. |
| 25 | Cuatro cortes F.A.F. adicionales y sincronización/cierre de canales. | Banco incompleto; no se declara escucha humana ni recuperación de todo el audio. |

La cabeza preferida de 0.8.6 conserva su archivo y hash. ETC se dibuja como capa frontal opcional: no sustituye el contorno. Las cuatro grabaciones Audacity permanecen idénticas. La edición Windows histórica no se modifica.

## Reglas locales explícitas

Puntos base: SINGLE 1.000, DOUBLE 2.500, TRIPLE 5.000, HOME RUN 10.000, WALK 500, OUT 0; cada RBI añade 2.000. Un hit del héroe aplica el mayor entre su racha de HR y 1 + floor((racha de hits - 1)/2), con tope x4. Los outs de compañeros no reinician su racha. Rango S desde 75.000, A desde 45.000, B desde 20.000, C desde 7.000 y D por debajo. WINNER añade 25.000 puntos, MVP 15.000, RANK S/A/B 10.000/5.000/2.000 y BONUS 500 por mejor racha. MVP usa hits + 2 HR + RBI entre las filas del equipo. Son reglas reconstruidas, no fórmulas recuperadas del servidor.

Los cinco bloques atribuyen el presupuesto existente de monedas con pesos GAME 100, WINNER 35, MVP 15, RANK S/A/B 20/10/5 y BONUS 10 cuando corresponden; el resto del redondeo queda en GAME. XP se atribuye a GAME. La interfaz solo anima valores ya guardados. Repetir el cierre del mismo fixture con su clave no entrega monedas/XP otra vez. WALK-OFF conserva todas las carreras de un HR; en los demás hits solo las necesarias para ganar.

Cada regular tiene seis unidades de energía y recupera una cada treinta minutos. Condición: energía 5–6 da +2, 3–4 +1, 2 neutro, 1 -1, 0 -2. El modificador se congela al reservar el encuentro; se gasta una unidad una vez y el jugador participa con el estado reservado. Una carta especial participante cubre su puesto y conserva su propia energía. El héroe sigue usando la energía general. AUTO SORT busca suplentes disponibles; SKIP convierte el turno de un regular agotado en OUT. La reserva guardada evita un segundo cargo al reabrir el mismo encuentro.

El nuevo equipo tiene grupos APEX/EXTREME/ALL STAR: bates con requisitos 30/50/70, bonus 72/180/400 y precios 20.000/45.000/80.000; otros slots con bonus 35/65/100 y precios 12.000/30.000/60.000. No se afirma que cada variante o precio existiera así. Los atributos visibles admiten hasta 9.999; el motor conserva una escala 1–99 y normaliza bonus grandes como 30 + 2*sqrt(bonus - 30). Derby y equipos enviados a retos usan también esa escala para no desbordar probabilidades. Los consumibles x5 y BAT EXPIRED siguen pendientes.

## Arte y sonido

La hoja de equipo 11_11.png aportada por el usuario se conserva transparente; siete regiones de bate se copian una vez a texturas compartidas. Las familias comparten siluetas, no son veintisiete ilustraciones nuevas. Guante, casco, cinturón, gafas y zapatos son dibujos nativos reconstruidos. El atlas de historias se generó con image_gen usando las referencias de ave, pareja de alienígenas y alienígena morado; tiene dos poses por escena. La cámara, plumas, consola e impacto se animan por tiempo. La selección de historias alterna localmente, porque el video no demuestra la regla histórica.

Se añaden faf_pitch (382,89–383,16), faf_swing (376,27–376,62), faf_single (413,39–414,74) y faf_double (385,51–388,41) del gameplay F.A.F. Los hashes coinciden con los cortes de referencia. Se comprobó decodificación y la revisión automática previa de habla, sin afirmar escucha humana. El lanzamiento suena al salir la pelota; el swing solo en un fallo y el strike del usuario 250 ms después. Un strike cantado no reproduce swing. TRIPLE deja de usar el aviso incorrecto de DOUBLE. Los canales de resultado se detienen al cerrar la escena; el gestor limita los canales activos. Se mantienen las cuatro grabaciones del usuario.

## Guardado, comprobaciones y publicación

Esquema 21 con campos opcionales de condición y resumen; se conservan carreras anteriores. Una nueva cuenta empieza en nivel 1 / ROOKIE y se registra sin invitación. Las pruebas ejecutan el motor real con bases llenas en HR, SINGLE, WALK, compañero y extra innings; validan cierre sin tercer out, límite de carreras, octava sin cierre prematuro, desglose exacto, pago único y resumen conservado. La celebración se comprobó visible antes del resultado: su reloj empieza tras preparar actores y evita precargar todas sus poses. Las tres historias admiten adelantar al resultado sin dejar restos. Regresión de postemporada: clasificación, empates, gasto único, campeonato, eliminación y siguiente temporada.

El ejecutable de producción se probó localmente y por HTTPS con cuentas de QA: compra bloqueada por nivel, prueba gratuita, compra/equipo +400 y recarga, regular agotado/AUTO SORT, ETC persistente, DRAFT/BUILD, creación desde cero, primer partido, logout/reentrada y Mystery pendiente/carta única. La corrección final de celebración recibió una prueba específica antes de la compilación final; registro local y comprobación publicada se repitieron con ese ejecutable. No se restablecieron partidas de usuarios reales. La única cuenta temporal publicada fue retirada y se comprobó que todas las cuentas anteriores siguen presentes.

Muestra Chrome/Ruffle: 45,099 s de partido, 2.705 cuadros, 59,979 FPS, p95 32 ms, máximo 59 ms y un cuadro por encima de 50 ms; avance de bateador máximo 1 ms. Es una muestra local, no una garantía para todos los equipos. La ruta normal de precarga del partido se conserva; la celebración usa preparación reducida.

Paquete permitido de 140 archivos, veinte hashes publicados verificados. Se publican seis recursos adicionales, WebMain.swf, version.json y la nota de audio actualizada; servidor y Ruffle conservan sus hashes respecto a 0.9.1. Los ejecutables de diagnóstico, videos, cuentas de QA y secretos quedan fuera del paquete. Respaldo previo external-v092-1791591242.sqlite3, integridad OK. SHA256 WebMain: 98ec29b4982ca4da074d5235e3a0ab26fda8f7757213f4670560a940cec98f1a. SHA256 BatterHead086: c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f.
