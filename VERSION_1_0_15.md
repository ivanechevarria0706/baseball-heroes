# Baseball Heroes 1.0.15 — carga visible y recuperación segura

La web separa la descarga del juego de la preparación del equipo. El ejecutable del juego es exactamente el de la 1.0.14: no se recompilan el personaje, el partido ni las reglas. Las cuentas y su progreso se conservan.

- **Carga visible:** marco azul con relieve, ilustración existente, etapas DOWNLOAD / PREPARE / PLAY y MB realmente recibidos. La banda avanza según los bytes descargados; la preparación posterior se muestra como una etapa distinta, sin inventar un porcentaje de ejecución.
- **Descargas interrumpidas:** hasta tres intentos para fallos de red, archivos incompletos y respuestas temporales. El límite de descarga detecta 45 segundos sin recibir datos, en vez de cortar una descarga que sigue avanzando. No se repite el registro ni se ejecuta el juego antes de tener el archivo completo.
- **Errores concretos:** sesión vencida, archivo ausente, descarga detenida e inicio del motor quedan diferenciados. Los códigos, etapa, versión y contadores se conservan en la sesión de ese navegador, sin usuario, contraseña, token ni guardado.
- **RETRY LOAD:** recupera una descarga fallida con el mismo guardado y la misma cuenta. Conserva los cambios locales y su identificador pendiente de guardado. Los errores de sesión no reintentan indefinidamente.
- **Inicio del motor:** el archivo completo se entrega mediante la API de datos de Ruffle 0.6.0. Si falla después de iniciar la ejecución, se conserva la recuperación por recarga de página; no se lanza automáticamente otra partida. Los controles de carrera/importación/pantalla completa esperan al inicio real. SIGN OUT sigue disponible si el inicio falló y no hay cambios pendientes.
- **Ruta del cargador:** se añade únicamente `/startup.js` al enrutador de archivos públicos. El juego y los guardados continúan autenticados. Se retira del acceso el aviso antiguo que anunciaba el reinicio de cuentas de la primera 1.0.

Los mensajes de ayuda de carga están en español. No cambian monedas, energía, compras, calendario, pichadas, sonido, sprites ni la cabeza aprobada 0.8.6. Guardado v24 y SQLite v4; sin cambio del identificador de reinicio.

## Evidencia y límites

En la 1.0.14 un intento de arranque mostró un aviso genérico y después funcionó al iniciar sesión de nuevo. No se registraron sus errores de red/consola, así que su causa histórica sigue sin determinar. Esta entrega corrige la debilidad comprobable del límite compartido y de los errores ocultos; las pruebas provocan cortes controlados para verificar la nueva recuperación. No se afirma haber identificado la causa de aquel primer fallo.

La API de carga de datos y la señal `loadedmetadata` se contrastan con el código incluido en los mapas de fuentes de la distribución local Ruffle 0.6.0. Los cambios no sustituyen el motor ni descargan otra versión. La carga inicial aún requiere transferir el ejecutable y los archivos del motor; esta entrega no promete menos MB ni un número fijo de segundos.

## Verificación

Informes y capturas en `build/qa/release1015`: doce casos de descarga, pruebas del servidor y dos recorridos de Chrome locales. Se comprueban descarga real por bloques, progreso durante más tiempo que el umbral de inactividad, corte de flujo, límite de intentos, 404/401, recuperación de cambios locales, ausencia de reinicio automático del motor y compra/recarga de un sobre. La publicación y los recorridos HTTPS se completan en el informe final.

Publicada y comprobada en HTTPS: build `ab62be72ee957607`. Los doce casos, las 45 pruebas del servidor y los dos recorridos locales pasaron. Dos recorridos HTTPS verifican inicio real, cortes controlados, recuperación sin doble registro, compra, recarga y entrega en banca. 139 archivos publicados coinciden con el paquete probado. Copia SQLite íntegra dentro del volumen; solo se retiraron las dos identidades QA usadas. El ejecutable conserva el SHA-256 de la 1.0.14.
