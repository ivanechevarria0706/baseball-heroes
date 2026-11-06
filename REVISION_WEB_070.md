# Web 0.7.0 · Registro sin invitación

Una cuenta se crea desde la página con usuario, contraseña y nombre visible. Se quitaron el campo y el requisito de código tanto del formulario como de `/web/register`. Al registrarse se inicia sesión y se carga una carrera nueva en nivel 1, liga ROOKIE, XP 0 y equipamiento básico.

RIVAL → ENLACE permite compartir la página con los amigos; esa acción no crea ni consume invitaciones. La sesión expirada dirige de nuevo al acceso web. Se conservan las cuentas existentes, los retos, las ligas y las partidas de esquema 21.

La validación de nombres, el rechazo de usuarios duplicados, los límites de peticiones, HTTPS, el control de origen y las cookies HttpOnly siguen activos. El registro libre se habilita desde código del servidor, no mediante un campo enviado por el cliente. La API de la edición Windows 0.6.7 conserva su compatibilidad. El arranque de la edición web no requiere una invitación inicial aunque la base esté vacía.

## Verificaciones

- 21 pruebas del servidor: identidad, permisos, invitaciones de la API anterior, sesiones, retos, ligas, persistencia, guardado y registro web.
- Fábrica del paquete de producción: arranque con base vacía sin código inicial, registro, recursos autenticados y exclusión de los SWF de pruebas.
- Navegador local: dos cuentas creadas desde el formulario sin código, carrera ROOKIE, rechazo de duplicados, cierre de sesión, recuperación del progreso y enlace de RIVAL.
- Navegador de producción: informe `build/qa/smoke-registration070-cloud.txt`, generado después del despliegue y la comprobación por HTTPS.

La construcción utiliza `research/build_web068.py`; el nombre histórico del script permanece. `research/prepare_railway_web070.py` incluye solo el servidor, la página, WebMain, los recursos y Ruffle 0.6.0. Las cuentas sintéticas de pruebas se retiran mediante `research/cloud070_admin.py cleanup`, que comprueba su identidad y preserva las cuentas anteriores.

El respaldo previo a esta publicación se verifica dentro del volumen del servidor. No se descarga una nueva copia completa de las cuentas a la computadora. Las copias locales anteriores permanecen disponibles.
