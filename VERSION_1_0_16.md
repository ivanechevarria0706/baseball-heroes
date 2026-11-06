# Baseball Heroes 1.0.16 · Recuperación de carreras

Fecha: 18 de octubre de 2026.

IMPORT SAVE admite las copias v24 que descarga el juego actual. Antes solo aceptaba v21–v23 y la conversión antigua terminaba en v23, por lo que una cuenta ya actualizada a v24 podía rechazarla.

Las copias v21–v23 pasan a v24 conservando sus datos. Si falta el tutorial inicial, se marca como terminado y desactivado; no se reproduce la recompensa de bienvenida. El cargador existente del juego sigue normalizando los campos de la carrera.

La ventana RESTORE CAREER compara héroe, equipo, nivel, liga, temporada, monedas, XP y número de cartas. Muestra el archivo y la cuenta de destino. Antes de activar IMPORT BACKUP, permite solicitar la descarga de la carrera actual. Guarda ese archivo: el navegador decide dónde y si conservar la descarga. CANCEL o Escape cierran la ventana y reanudan la carrera actual.

Antes de reemplazar la carrera se comprueba otra vez la revisión en la nube. Si cambió durante la vista previa, la importación se detiene. Si el servidor guardó pero se perdió la respuesta, se conserva el borrador local con el mismo identificador para reintentar sin duplicar la operación.

Las nuevas peticiones autenticadas de la web incluyen la cuenta esperada. Si se inició otra cuenta en una pestaña del mismo navegador, el servidor rechaza la petición de la pestaña anterior. El encabezado es opcional para mantener la compatibilidad con clientes antiguos; las pestañas antiguas deben recargarse para recibir esta protección.

Los controles permanecen en inglés y las instrucciones de recuperación están en español. Se conserva byte por byte el ejecutable de la 1.0.15, el código AS3, el arte, la cabeza aprobada 0.8.6, los sonidos y las reglas de juego. Guardado v24 y SQLite v4; no se reinician cuentas ni carreras. Los datos sociales del servidor se mantienen al importar una carrera.

La restauración reemplaza la carrera; no fusiona dos partidas. Se admiten únicamente copias JSON v21–v24 de hasta 512 KB con plantilla válida. No se añade un historial ilimitado de versiones en el servidor ni se sustituye la copia descargada por el usuario.

El despliegue conserva en `/data/game-library/` una biblioteca inmutable de los 114 archivos de juego que ya estaban publicados. Cada archivo y el manifiesto están identificados por SHA-256. El arranque verifica todos los archivos antes de restaurarlos en la imagen y abrir el servidor. Esta biblioteca no contiene cuentas, sesiones ni partidas. Si falta un archivo o su hash difiere, la nueva versión no inicia. La base de datos permanece en su ruta existente.

Esto reduce la transferencia de código de unos 52 MB a menos de 1 MB sin cambiar los bytes del juego. Antes hubo tres cortes en la creación de la instantánea del paquete grande; no se atribuye una causa definitiva al proveedor. Las futuras versiones que cambien el ejecutable o los recursos deben preparar y verificar su nueva biblioteca antes de desplegar. No se deben eliminar las bibliotecas de versiones necesarias para volver atrás.

La web conserva además una copia del ejecutable en Cache Storage, identificada y verificada por SHA-256. Cada reutilización requiere una petición autenticada al servidor; una sesión vencida no abre la copia local. Un cambio de hash descarga el archivo nuevo y retira la copia anterior. Si el almacenamiento está bloqueado o lleno, continúa la descarga habitual. Esta caché contiene únicamente el ejecutable, nunca cuentas ni guardados. La primera descarga sigue dependiendo de la conexión.

El primer recorrido HTTPS de esta actualización llegó a restaurar v24 y v21 y a recuperar una respuesta perdida, pero agotó el plazo de 150 segundos durante una recarga: la captura muestra la descarga en su segundo intento. Se conserva ese registro en `build/qa/release1016/uncached-first-cloud-recovery-test.txt`. Ese resultado motivó la caché; las pruebas finales se repiten con el paquete corregido.

Publicada y comprobada en HTTPS: build `3ee546f4f24e51a0`. Dieciocho casos del lector, nueve casos de caché, siete comprobaciones de restauración de la biblioteca, 48 pruebas del servidor y dos recorridos locales aprobados. Dos recorridos HTTPS verifican restauración, conservación de energía y recursos, respuesta perdida, conflicto, cambio de cuenta y compra con entrega en banca. Los 143 archivos publicados coinciden con el paquete. Se retiraron únicamente las tres cuentas QA utilizadas; las cuentas existentes se conservaron y la copia SQLite previa pasó la comprobación de integridad.
