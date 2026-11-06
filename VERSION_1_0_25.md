# Baseball Heroes 1.0.25 · entrada ilustrada al partido

**Publicada y comprobada por HTTPS.** La entrada y el recorrido completo del calendario pasaron también en la web pública. Se retiraron las dos cuentas QA y se conservaron las cuentas anteriores.

## Cambios

Entrada reconstruida a partir de `reference_visual/initial_audit_20261015/frame-0153.jpg` (02:33): emblema central con pelota, llamas y letras azules, tres aros que giran sobre el estadio y cierre con PLAY BALL. MatchIntroScreen usa ahora MatchStadium, con el fondo activo, mejoras y decoraciones que usa el partido. Su duración programada es 2,300 ms; antes sumaba 5,290 ms. El ritmo es una reconstrucción, no una medición exacta del original.

Solo cambian MatchIntroScreen y la nueva IntroEmblemArtwork respecto a 1.0.24. Se conservan GameData, las reservas y cobros de partidos, servidor, web, audio, guardado v24, calendario y cabeza 0.8.6. La entrada conserva BACK, SKIP, Space y Enter. Las instrucciones y tips están en español. El sprite se prepara mediante copyPixels en dos fragmentos compartidos; no se redibuja el emblema por cuadro. La animación actualiza transformaciones y alfa, sin un porcentaje de descarga simulado. La descarga web inicial con MB reales no cambia.

## Arte, herramienta y prompt

Se utilizó **image_gen integrado**, sin CLI de imágenes. Es un emblema reconstruido, no un original recuperado. El PNG generado se copió sin cambios y conserva alfa 0–255; Python solo comprobó los datos de la imagen. Los aros se construyen mediante código nativo y la vista del estadio reutiliza sus sprites existentes.

- [PNG final](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1025/intro-emblem.png>)
- [Herramienta, prompt completo y referencia](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1025/provenance.json>)

6,291,736 bytes de píxeles compartidos, 2 fragmentos. El ejecutable aumenta aproximadamente 1,14 MB; no se afirma una mejora general de rendimiento.

## Pruebas

Dos recorridos locales con WebMain real en Chrome. Entrada Rookie con dos decoraciones; BACK sin cobros; dos clics rápidos en SKIP producen un solo inicio; Enter reabre el partido pagado sin gastar más energía; fondo Civic configurado en QA y decoraciones compartidas; cierre automático; recarga antes de acabar sin reservar ni cobrar. Mismo personaje confirmado, nivel 1/Rookie/6,000 Coins iniciales/sin lentes. La configuración Civic se concedió solo a la cuenta QA para revisar ese fondo.

El segundo recorrido comprueba los treinta partidos del calendario, los eventos 12/28/30, historial WIN/LOSS con marcador conocido y desconocido, ascenso, HOME y RECORD, viaje a LINEUP y comienzo del encuentro que corresponde. Las situaciones históricas se fijaron solo en QA. No se detectaron errores JavaScript o AVM2.

Los dos recorridos también pasaron por HTTPS. Una comprobación adicional con Kyle equipado verificó BACK sin gasto y SKIP con una sola carga consumida (2 → 1); tras recargar, Enter conservó la misma reserva, la energía y esa carga. Se cotejaron los 143 archivos instalados y SQLite. Las dos cuentas QA se retiraron y las cuentas anteriores se conservaron. Evidencia adicional: build/qa/release1025/intro-card-cloud.json.

## Almacenamiento y publicación

Se archivó localmente el ejecutable y manifiesto del candidato intermedio de 1.0.24 `27493590330bbdc685346ad0756a1701a0c2091c18df57c51ff14c20b9da1cbb`, que nunca estuvo activado. Tras comprobar sus 114 hashes se retiró solo esa carpeta del volumen. El archivo local conserva SHA256 `253a1d5d2b36be48f9493b1057db0bb5741008cd4d5ba8e31f49098d6250ec54`. Se verificaron de nuevo los 114 archivos instalados. No se tocaron las versiones publicadas ni las bases de datos. Evidencia: `build/qa/release1025/storage-maintenance.json`.

Build `c864c0a6dee67768`, SWF SHA256 `d4948ef025623957050b7b5a311e673ac380bf91695cead3e44479034d437d5f`, 34,486,578 bytes. Biblioteca `f4cf26f1a04ff31232a77a999dc49c972cdebbdeb596d52eb565b6c166be9170` con 114 archivos verificados y 113 recursos idénticos enlazados. Paquete de 147 archivos. Copia SQLite previa comprobada. Se renovó automáticamente la sesión oficial de Railway tras un primer HTTP 401; no se imprimieron credenciales. La publicación se verifica por versión y hash, además del estado del despliegue.

[Comparación](COMPARACION_MEJORAS_1025.html). Sigue pendiente la prueba física de amigos en dos computadoras.
