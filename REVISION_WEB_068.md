# Versión web 0.6.8

La misma base de juego pasa al navegador con acceso por invitación, inicio de sesión, partida por cuenta e indicación de nuevas versiones. Se conserva el cliente Windows 0.6.7 y la API que ya usan los retos y las ligas. Ruffle 0.6.0 está incluido en el servidor; no requiere instalar Flash ni descargar recursos de terceros al jugar.

La entrega no reescribe la temporada ni supone paridad visual completa con Baseball Heroes. Mantiene las cartas, sistemas y recursos anteriores, con las adaptaciones de plataforma necesarias. Los dos rótulos que usaban rasterización de fuentes ahora animan texto directamente en la compilación web; esto resuelve un bloqueo real detectado en la simulación bajo Ruffle. La versión Windows conserva el comportamiento anterior.

## Evidencia local

- 19 pruebas de servidor aprobadas: autenticación, invitaciones, privacidad, revisión de turnos, resultados compartidos, ligas de seis participantes, migraciones, persistencia, copias, cookies y guardado web. Informe: `build/qa/smoke-web068-server.txt`.
- Partido completo en Chrome/Ruffle: nueve entradas y 15 lanzamientos manuales; los totales de los nueve bateadores coinciden; resultado recuperable; avance de temporada y recompensa una sola vez. Informe: `build/qa/smoke-web068-full-match.txt`.
- Dos cuentas de navegador publican su alineación desde el juego; lanzamiento, bateo, simulación y reanudación de reto; mismo resultado y clasificación para ambos; importación sintética con descarga del respaldo anterior y salida de sesión. Informe: `build/qa/smoke-web068-online.txt`.
- Recuperación de respuesta perdida, borrador sin conexión tras cerrar una pestaña, restauración en otro contexto, rechazo de sobrescritura desde pestaña atrasada y aviso de actualización sin interrumpir el juego. Informe: `build/qa/smoke-web068-recovery.txt`.
- Pantallas HOME, LINEUP, HERO, MODES y RIVAL, recursos de imágenes/audio y cookie HttpOnly. Informe: `build/qa/smoke-web068-initial.txt`.
- Arranque de la carpeta exacta preparada para despliegue: página, manifiesto, juego privado, tabla web_saves y API de salud. Informe: `build/qa/smoke-web068-staging.txt`.

## Datos y distribución

El empaquetado permite 126 archivos, aproximadamente 44.9 MB: servidor, página, SWF de producción, recursos y runtime. No incluye cuentas de prueba, claves, tokens, invitaciones, archivos de partidas personales ni los SWF de pruebas. `research/railway-web068-manifest.json` contiene las huellas de lo publicado.

La tabla `web_saves` guarda una partida por usuario, revisión, identificador de la última petición y una copia anterior. Se mantiene el esquema 2 de la base existente. Las partidas del juego siguen en esquema 21. La exportación `research/windows-export068/Partida_para_web.json` se obtuvo leyendo el guardado de Windows y comprobando que su archivo original no cambiara. Esa copia personal no se envía automáticamente al servidor.

Antes de publicar se descargó una copia consistente `external-v067-1790716338.sqlite3`; integridad SQLite verificada. Se mantiene el volumen `/data`, las cuentas y ligas existentes. El despliegue anterior es `cf04bb23-06de-40b3-949b-4e266e63ba77`; su carpeta `research/railway-source` se conserva como referencia de recuperación. No restaurar una base antigua sobre una reciente como parte de un rollback rutinario: perdería progreso posterior.

## Límites

Los retos siguen siendo asíncronos, con simulación del rival. La temporada local conserva sus puntos habituales de guardado, no cada lanzamiento. Windows y web no sincronizan automáticamente la partida personal: importar una vez y continuar en la web. La persistencia fuera del volumen todavía requiere descargar copias; las diarias dentro del volumen sí son automáticas.

Se verificó en Chrome de escritorio de esta computadora. Falta la primera prueba de uso con un amigo en otra computadora y comprobar otros navegadores. El arte y las animaciones pendientes permanecen como trabajo posterior a esta migración.

## Publicación

Publicado el 29 de septiembre de 2026 en https://baseball-heroes-api-production.up.railway.app. Railway confirmó SUCCESS para `23cb8cd5-3684-4dd7-ba0b-b21e3a9f5b62`; HTTPS /health y el manifiesto coinciden con la versión probada.

La prueba real por HTTPS pasó con dos cuentas independientes y el SWF de producción: inicio de sesión, recursos privados, cookie Secure/HttpOnly, guardado aislado, importación sintética con descarga previa, restauración al volver a entrar, lanzamiento manual y reto completo de nueve entradas con resultado compartido, calendario de liga compartido. Sin errores de página ni recursos del juego fallidos. Informe: `build/qa/smoke-cloud068-web.txt`.

Se retiraron las dos cuentas temporales, su reto y su liga, preservando las cuentas anteriores. La copia final `external-v068-1790717021.sqlite3` fue descargada y verificada: incluye web_saves, conserva los usuarios anteriores y no contiene cuentas QA de esta entrega. Informes: `build/qa/smoke-cloud068-cleanup.json`, `build/qa/smoke-web068-backup.txt`; estado resumido: `deployment_status.json`.
