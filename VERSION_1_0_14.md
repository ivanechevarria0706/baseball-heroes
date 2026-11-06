# Baseball Heroes 1.0.14 — resultado y LEVEL UP

El final del partido vuelve a una tarjeta central de papel, con el campo visible alrededor. Se reconstruyen composición, relieves y jerarquía de los cuadros de resultado y subida de nivel. Las cuentas y las temporadas existentes se conservan.

- **Resumen compacto:** papel con borde, sombra corta y grano estático; emblema de liga sobre el borde; dos logos y tanteador numérico central. La victoria, derrota y empate conservan su texto y audio actuales.
- **Entradas y bateadores:** visitante rojo arriba y local azul abajo; casillas grises para las entradas y nueve columnas visibles. En entradas extra se empieza por las últimas nueve; los controles permiten consultar las anteriores. Se conservan los nueve bateadores, sus HIT/HR/RBI, el héroe y la corona del MVP. Los nombres largos se ajustan a su fila y el detalle al pasar el cursor permite leerlos completos.
- **Premios:** cinco placas con aro, bisel, trama clara y estado dorado/gris, contadores de Coins/XP y RANK inclinado con contorno. Las condiciones y premios de cada placa siguen disponibles en consejos en español. Se muestran los valores guardados del modelo existente; el dibujo no concede premios.
- **Ranking opcional:** una ficha lateral muestra SCORE y abre LEADERBOARD. Conserva semanas, todos los tiempos y cobro de premios; BACK vuelve al resultado. El ranking sigue utilizando el mismo servicio y su liquidación existente.
- **LEVEL UP:** estrella azul con número, rótulo inclinado, papel claro, vista previa del equipo desbloqueado y banda azul de premios con iconos. Solo aparecen recompensas positivas; un nivel sin aumento de capacidad no muestra `0 MAX ENERGY`. CONTINUE responde una sola vez.

## Referencias y límites

`videoplayback (4).mp4`, 05:48–05:52: resultado 1–0 en once entradas y ventana Lv2. `[FACEBOOK GAME]BASEBALL HEROES play video.mp4`, 00:00: Lv12, tres guantes y dos tipos de recompensa. Las capturas se encuentran en `reference_visual/initial_audit_20261015/frame-0348.jpg`, `frame-0352.jpg` y `reference_visual/facebook_play_20261012/frame-0000.0.png`.

El papel, las placas y los rótulos son gráficos nativos reconstruidos; la fuente y los retratos siguen siendo sustitutos. Se conservan HOME/NEXT MATCH/CONTINUE y el ranking del remake. No se añade una acción de compartir en Facebook. Las reglas de RANK, XP, monedas y equipo desbloqueado siguen siendo las actuales; esta entrega cambia su presentación. Si un resumen antiguo no guardó hits del rival, se muestra un guion, sin inventar un total.

Los escenarios de empate, postemporada, niveles 2/12/100, importes grandes y datos antiguos se crean en una herramienta local de prueba. No se fuerzan esos resultados en el juego publicado. Las pantallas de diagnóstico no forman parte del paquete público.

## Verificación

Los informes se registran en `build/qa/release1014`: presentación de resultados y LEVEL UP, partida completa con pausa y liquidación única, compra/recarga de un sobre desde WebMain y registro/creador en HTTPS. El informe de publicación y la conservación de datos se completan tras las comprobaciones finales.

Guardado v24, SQLite v4, cabeza aprobada 0.8.6, modelo, motor del partido, pichadas y audio conservados. No se cambia el identificador de reinicio. El grano y los relieves se dibujan una vez; la animación de contadores/confeti deja de actualizarse al terminar.

Incidencia de verificación HTTPS: un primer arranque de la segunda cuenta QA mostró «Could not start the game», después de registrar correctamente la cuenta. Al iniciar sesión de nuevo con esa misma cuenta, la compra y las recargas sucesivas pasaron. El primer intento no capturaba consola/red, por lo que su causa queda sin determinar; no se afirma haber corregido ese fallo. Se conserva el registro en `build/qa/release1014/cloud-initial-failure.json`.

Publicada y comprobada en HTTPS: build `0c1c67bdf7add317`. Tres suites locales y dos HTTPS aprobadas. La partida completa verifica pausa, sus nueve filas, guardado y premios únicos. Las dos cuentas sintéticas en la web comprueban registro/creador/HOME y compra/recarga/entrega en banca. Los 138 archivos publicados coinciden con el paquete probado. Copia SQLite íntegra en el volumen; solo se retiraron las dos identidades QA utilizadas.
