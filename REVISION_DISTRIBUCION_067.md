# Baseball Heroes 0.6.7 — Windows portátil y conexión verificada

El grupo puede extraer `Baseball_Heroes_para_amigos_Windows_v067.zip` y abrir `BaseballHeroesRemake.exe` sin instalar AIR, Java, Python ni un SDK. El servidor continúa en `https://baseball-heroes-api-production.up.railway.app`. La guía `CONEXION_AMIGOS.html` reúne descarga, registro por invitación y liga.

## Entrega

- ZIP portátil para Windows x64, con runtime AIR 51.3.4.1 incluido y LEEME.txt. No es un instalador ni una versión para macOS, teléfono o navegador.
- Se conserva `com.personal.baseballheroesremake`, el esquema de guardado v21 y el SWF de 0.6.6. El descriptor pasa a 0.6.7 y se elimina un elemento fullscreen no admitido por el empaquetador ADT. No cambian el balance, arte, audio ni reglas del juego.
- Firma interna AIR con certificado del proyecto guardado de forma privada. No se dispone de un certificado comercial de editor Windows.
- La distribución excluye código de pruebas, SDK, servidor, base de datos, invitación inicial, claves y contraseñas. El servidor desplegado no necesitó cambios de código en esta entrega.

## Verificación del 27 de septiembre de 2026

`tests/Cloud067Smoke.as`, compilado y empaquetado como ejecutable con runtime incluido e identidad de aplicación independiente, se conectó al servidor real por HTTPS con dos cuentas temporales.

1. Inicio de sesión, publicación de equipos y lanzamiento/bateo por controles del cliente.
2. Recuperación de sesión cifrada y del mismo lanzamiento pendiente después de un reinicio real del proceso en Railway.
3. Amistoso completo de nueve entradas; resultado y estadísticas idénticos desde ambas cuentas.
4. Liga de dos equipos, ida y vuelta, finalizada mediante dos abandonos administrativos; clasificación final compartida comprobada desde ambas cuentas y mostrada en la interfaz.
5. Ruta RIVAL y guardado individual conservados en la identidad aislada de prueba.

Se eliminaron las dos cuentas temporales y sus tres partidos comprobando que ninguna cuenta ajena participara en ellos y que las cuentas existentes permanecieran. La invitación inicial no se consumió en estas pruebas.

Se descargó por SSH autenticado una copia consistente creada mediante SQLite.backup. La copia local, en `research/railway-private/backups`, pasó `PRAGMA integrity_check` y conserva el esquema 2. Es una copia externa puntual; las copias diarias automáticas siguen en el volumen de Railway.

El ejecutable de producción es PE x64. Su SWF y todos sus assets coinciden con la compilación; el runtime coincide con el del ejecutable de prueba por internet. Los 120 archivos del ZIP se verificaron por CRC y SHA-256. Detalles, tamaño y hash del paquete: `build/qa/bundle067.json`.

Informes actuales: `smoke-cloud067.txt`, `smoke-bundle067.txt` y `smoke-backup067.txt` en `build/qa`. Las 14 pruebas locales del servidor y la compilación de 0.6.6 se conservan como evidencia previa; esos componentes no cambiaron. Las capturas `cloud067-*.png` muestran únicamente cuentas temporales.

## Pendientes concretos

La primera prueba en una segunda PC Windows aún no se ha realizado. El servicio depende del crédito y del plan de Railway; no se contrató un plan de pago. No hay descarga externa automática de copias, recuperación de cuenta autoservicio ni partidas humanas simultáneas. Las reglas y limitaciones de confianza del cliente continúan siendo las del prototipo de exhibición privada; esta entrega no modifica la fidelidad visual.
