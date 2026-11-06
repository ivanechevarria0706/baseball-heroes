# Alojamiento en Railway

Servidor adaptado en 0.6.6 y verificado con el cliente portátil Windows 0.6.7. Conserva el protocolo 1 y el guardado offline v21. Railway confirmó el despliegue SUCCESS y respondió por HTTPS en `https://baseball-heroes-api-production.up.railway.app`. Se completó un amistoso de nueve entradas desde el ejecutable con runtime incluido, se recuperó el mismo lanzamiento pendiente tras reiniciar el proceso remoto y se compararon resultados y clasificación de liga desde dos cuentas. `deployment_status.json` registra el estado comprobado.

## Configuración

- Un servicio Python/Waitress, una réplica y un volumen persistente montado en `/data`.
- Dominio HTTPS generado por Railway, dirigido al puerto 8080; variable `PORT=8080`.
- `RAILWAY_PUBLIC_DOMAIN` y `RAILWAY_VOLUME_MOUNT_PATH` los aporta Railway. Fuera de Railway se pueden usar `BH_PUBLIC_HOST` y `BH_DATA_DIR`.
- `BH_BOOTSTRAP_INVITE`: invitación inicial secreta, de 24 a 80 caracteres URL-safe. Solo se guarda su hash. Se utiliza una vez y vence a las 72 horas; reiniciar no renueva su vencimiento ni la vuelve a habilitar.
- Se despliegan únicamente los diez archivos de backend enumerados en `research/prepare_railway_source.py`, desde su carpeta de preparación. No se suben sprites, videos, música, bases locales, contraseñas ni partidas individuales.
- El contenedor necesita la entrada HTTP privada de la plataforma detrás de su terminación TLS. No configurar un proxy TCP público al puerto de Waitress. Solo se confía en `X-Forwarded-Proto` del gateway; no se usa `X-Forwarded-For` para conceder permisos.

Railway compila el `Dockerfile`. Los ajustes del servicio se guardan mediante su API: comprobación `/health`, una réplica y reinicio limitado tras error. `deployment-settings.json` documenta esos valores para reproducirlos; no es un archivo que Railway aplique automáticamente. No se depende del antiguo `railway.json`, cuyo soporte termina en diciembre de 2026. La aplicación se niega a iniciar sin directorio de datos y dominio configurados. El servidor local anterior sigue disponible mediante `SERVIDOR_PRIVADO.bat`.

## Datos y recuperación

La base del servidor vive en `/data/private.sqlite3`. Las cuentas online del servidor local y las del servicio alojado son independientes; no se importa automáticamente información personal.

`production.py` realiza una copia SQLite consistente al arrancar y revisa cada hora si falta la copia del día UTC. Conserva siete copias diarias en `/data/backups`, con comprobación de integridad. Estas copias comparten el volumen. El 27 de septiembre de 2026 se creó otra copia consistente mediante SQLite.backup y se descargó por SSH autenticado a `research/railway-private/backups`, fuera del volumen. La copia descargada pasó `integrity_check` y conserva el esquema 2; no se incluye en el juego. Esta descarga fue puntual: todavía no hay descarga externa automática. Para repetirla desde la carpeta de trabajo se puede usar `research/cloud067_admin.py backup` con el entorno de Python y la clave SSH configurados.

Cada liga conserva los equipos fijados, calendario y resultados al reiniciar. Para restaurar una copia, detener el servicio, conservar primero la base actual, restaurar la copia verificada y volver a iniciar. No reemplazar una base SQLite mientras se está utilizando ni copiar solo su archivo principal durante escrituras WAL.

## Límites

El servicio admite cuentas por invitación y aplica límites de solicitudes y de tamaño. Las reglas siguen siendo la reconstrucción de exhibición: los atributos publicados y el timing enviado por el cliente no acreditan juego legítimo. No hay salas en tiempo real.

Se seleccionó la prueba gratuita de Railway. La duración, créditos y restricciones efectivas dependen de la cuenta; no se contrata ni se activa un plan de pago desde estos archivos. Referencias verificadas: [precios](https://railway.com/pricing), [volúmenes](https://docs.railway.com/volumes), [HTTPS](https://docs.railway.com/networking/public-networking), [comprobaciones de disponibilidad](https://docs.railway.com/deployments/healthchecks).

## Verificación local

La verificación remota de 0.6.7 usó dos cuentas temporales con identidad de aplicación independiente; se eliminaron esas cuentas y sus tres partidos al terminar, preservando las cuentas existentes y la invitación inicial. Informes: `build/qa/smoke-cloud067.txt`, `smoke-backup067.txt` y `smoke-bundle067.txt`. El cierre de la liga de prueba usó dos abandonos administrativos; el amistoso sí completó sus nueve entradas desde el cliente.

Instalar `requirements.txt` en un entorno aislado y ejecutar `python -m unittest discover -s online -p "test_*.py" -v` desde la raíz del juego. Las pruebas comprueban el gateway, invitaciones, persistencia, copia y restauración, límites, calendario y partidos. La prueba HTTP de Waitress simula las cabeceras del gateway en loopback; la validez real del certificado HTTPS se comprueba después del despliegue.
