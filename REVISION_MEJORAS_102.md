# Mejoras 0.10.2 — resultados, HOME y carga

11 de octubre de 2026. Puntos solicitados 1, 5 y 6.

## Resultados y premios

Las cinco casillas muestran puntos, Coins y XP por separado, con condiciones al pasar el cursor. GAME termina el encuentro; WINNER exige victoria; MVP exige al menos 3 RBI del héroe, usando su fila individual y no las carreras de todo el equipo; RANK exige S; BONUS requiere los cuatro objetivos anteriores juntos. Ganar por sí solo ya no concede BONUS. Un empate de postemporada se repite sin Coins ni XP.

| Objetivo | XP | Coins |
|---|---:|---:|
| GAME | 20 | 100 |
| WINNER | 10 | 50 |
| MVP | 15 | 100 |
| RANK S | 25 | 150 |
| BONUS | 30 | 500 |
| Todos los objetivos | 100 | 900 |

La tabla procede de la [guía histórica de Gamelytic](https://gamelytic.com/baseball-heroes-scoring-and-ranking-guide/). El gameplay aportado confirma directamente BONUS: 30 XP / 500 Coins y los cuatro objetivos requeridos (video1, 03:04). Su XP total pasa de 3.415 a 3.515. La tabla histórica no permite asegurar que todos los premios fueran idénticos en cada año del juego.

Los Coins de las jugadas y de SPECIAL/RIVAL se muestran aparte y se incluyen una sola vez en el total. Se elimina el reparto proporcional del presupuesto anterior entre casillas y el XP provisional por cada jugada. Esta corrección cambia los premios de encuentros futuros: desaparecen los anteriores 2.800/1.100 Coins y 180/80 XP base. El modelo liquida y guarda una vez antes de abrir la animación. Reabrir, recargar o volver a presentar una partida antigua no concede premios nuevos.

Los resúmenes antiguos conservan su tabla y sus cantidades, aunque procedan de la versión anterior. Carrera v21, saldos, XP acumulado, progresión de nivel e inventario existentes se conservan. Las cuentas nuevas siguen en nivel 1, ROOKIE, sin código de invitación.

## Qué se sabe del rango y qué no

En el video1, 17 hits y 9 carreras dan S; en el video2, 9 hits y 2 carreras dan C. La guía antigua exige 20 hits / 10 carreras para S, lo cual contradice el video posterior. Se usa una calibración local: S desde 16 H / 8 R, A desde 10 H / 8 R, B desde 10 H / 4 R, C desde 6 H o 5 R, y D en el resto. Solo las dos observaciones S/C están demostradas por los videos. Estos umbrales intermedios y el requisito mínimo de S no se presentan como la tabla original recuperada.

Los puntos por jugada, multiplicadores y puntos extra siguen siendo reconstrucción. La prueba de 270 Coins de jugadas más 900 de objetivos reproduce el total observado de 1.170, pero no prueba que la fórmula local de jugadas sea la del servidor original. El SCORE final del remake todavía puede diferir del gameplay.

## HOME y presentación

- Barra superior azul, estrella del nivel, progreso de XP y barras de recursos con brillo.
- Accesos +ADD al catálogo existente, ilustraciones de SHOP/LINEUP/BUILD/MODES, casillas de amigos y taquilla con feedback al cobrar.
- MY BEST usa el récord real de la carrera, coherente con la clasificación.
- Estadio con tonos de césped, anuncios y soportes de iluminación; el fondo estático se almacena para dibujarlo sin repetir su composición.
- Tarjeta de resultado más grande, columnas R/H del equipo, corona de MVP y títulos/rango con contorno nativo que se conserva en Chrome.
- Cabeza aprobada de 0.8.6 y atlas de cabello intactos, verificados mediante SHA-256.

## Rendimiento y carga

Se sustituye la lectura/escritura individual de cada píxel por bloques de píxeles en las poses cacheadas. Se mantienen la selección de color y las sombras anteriores. Los defensores construyen directamente su arte de defensa, sin crear y precargar antes un lanzador oculto. Se elimina la precarga de un lanzador antiguo que el partido ya no utiliza. Las poses siguen preparadas antes de jugar; no se desplaza su coste al lanzamiento.

La comparación de cuatro recortes, 166.359 píxeles, detectó cinco diferencias de hasta seis unidades RGB en bordes con alpha casi transparente. La cabeza no forma parte del recoloreado y no se cambia. Un intento previo con filtros cambió demasiados colores y fue descartado; sus mediciones no se usan como resultado final.

Los archivos del juego y Ruffle ahora usan ETag y caché privada con revalidación. Una recarga vuelve a comprobarlos, pero recibe 304 si no cambiaron. El servidor autentica los archivos protegidos antes de responder. HTML, versión, sesiones y partidas guardadas mantienen no-store. Una actualización con contenido diferente entrega el archivo nuevo.

### Medición local

- Entrada al partido: 7688 ms → 7021 ms.
- Muestra de partido de unos 45 segundos: 59.91 → 60.01 FPS; p95 17 → 25 ms; peor cuadro 133 → 97 ms.
- Perfil temporal de Chrome con caché en disco: 33.7 MB menos descargados al recargar los archivos WASM/SWF. La primera carga sigue descargando los archivos.

Son muestras de esta computadora en Chrome, no una garantía para todos los equipos. Se adjuntan los informes completos, incluidos los picos, y se conserva la medición anterior. La caché en disco se midió con un perfil temporal separado; un perfil incógnito con caché solo en memoria no retuvo estos archivos grandes.

## Verificación y publicación

32 pruebas de servidor aprobadas, incluidas revalidación, cambio de archivo, cierre de sesión, aislamiento de cuentas y conservación de no-store en datos privados. Escenarios de premios perfectos, derrota, empate, RBI individuales, resultados antiguos y repetición del mismo fixture. Regresión de 35 ramas de premios Mystery, sobres, equipamiento, duplicados, cartas persistidas y MAX ante miss/foul/walk/contacto.

Se recorrieron el registro, creador, llegada, HOME, objetivos, ROADMAP, viaje, alineación, primer partido y regreso a la cuenta en el SWF final; Mystery también se probó con el SWF final. Pruebas locales y en Railway, copia SQLite íntegra antes de publicar, paquete verificado por hashes y eliminación de las dos cuentas de prueba conservando las cuentas anteriores. La prueba física con dos computadoras y el amigo sigue pendiente.

Railway: 0.10.2, build 583a7bf056907894, despliegue 24c3e927-19f5-4d1e-91a9-8673025de41f, SUCCESS.
