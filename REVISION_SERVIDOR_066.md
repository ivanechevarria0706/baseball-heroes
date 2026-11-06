# 0.6.6 — servidor privado en Railway

Se publicó el backend de retos y liga privada en la cuenta de Railway del usuario. El proveedor informó despliegue SUCCESS y la dirección HTTPS respondió correctamente. El cliente usa esa dirección por defecto para sesiones nuevas y conserva las sesiones anteriores.

- Dirección: https://baseball-heroes-api-production.up.railway.app
- Proyecto: Baseball Heroes Privado.
- Backend Python 3.12 y Waitress 3.0.2. Una réplica, volumen de 500 MB en `/data` y dominio HTTPS del proveedor.
- Cuentas por invitación, primera invitación de un uso, 72 horas. Su valor no se registra en logs ni se incluye en el paquete.
- Límites de cuerpos, cabeceras, conexiones e intentos. Host público exacto y HTTPS requeridos; el healthcheck interno de Railway recibe únicamente información básica del servicio.
- Copias SQLite consistentes, diarias, hasta siete copias en el mismo volumen. Falta verificar una copia externa al volumen.
- Cliente: dirección inicial y texto de ayuda de RIVAL actualizados. Se conserva el identificador de aplicación y el guardado v21.

## Evidencia

14 pruebas locales pasaron en 13.047 segundos: las ocho existentes de retos y ligas más seis del adaptador HTTP y entorno de producción. Se verificaron peticiones reales a Waitress en loopback, reinicio del servicio local, sesión persistente y restauración de una copia SQLite. El gateway HTTPS se simula solo en esas pruebas locales.

En Railway se verificaron: volumen montado, arranque, despliegue `cf04bb23-06de-40b3-949b-4e266e63ba77` con estado SUCCESS y respuesta HTTPS a `/health`. Después se guardaron controles de arranque directamente en los ajustes del servicio. No se depende del antiguo formato `railway.json`.

La prueba completa del cliente AIR contra internet, el reinicio remoto y la descarga de una copia siguen pendientes. La revisión automática impidió ejecutar una comprobación remota adicional al alcanzarse el límite de uso de Codex; no fue una determinación de inseguridad. No se afirma haber validado esos pasos pendientes.

La cuenta confirmó prueba activa, 30 días restantes y US$5 de crédito en el momento del despliegue. No se contrató un plan de pago ni se enviaron invitaciones a amigos. El cliente continúa dependiendo del AIR SDK local; su instalador autónomo sigue pendiente.

Abre `CONEXION_AMIGOS.html` para registrar la primera cuenta y conectar el juego al servidor.
