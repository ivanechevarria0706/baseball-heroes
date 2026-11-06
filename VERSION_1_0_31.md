# Baseball Heroes 1.0.31 · amigos, regalos y visitas

**Publicada y comprobada por HTTPS.** Las cuatro cuentas QA se retiraron conservando las cuentas anteriores.

## Cambios

Cinco clases: SocialScreen, FriendVisitScreen, SocialGiftArtwork, Main y OnlineLobbyScreen. REGISTER desde HOME y la franja social del partido abre SocialScreen directamente. Sus tres pestañas usan MatchResourceBar, ClassicChrome, retratos y sprites de InterfaceSprite/InventoryArtwork. No se cambia la solicitud o aceptación del servidor. Solo se muestran los perfiles que entrega la API a amistades aceptadas; el resto usa scouting.

GIFTS permite elegir un amigo y uno de tres regalos ilustrados, revisar el destinatario y confirmar. Cancelar, Esc o cambiar de pestaña no envían. SENT TODAY bloquea las tres opciones para ese amigo tras un envío. INBOX muestra por separado solicitudes y regalos pendientes. Los premios mantienen el ledger y las reglas existentes. Main delega Esc a la pantalla y OnlineLobbyScreen lo delega cuando aloja SocialScreen; cancelar una vista previa conserva su contexto y salir vuelve al padre correcto. Se liberan botones, retratos y el reloj de recursos al renovar o cerrar la pantalla.

FriendVisitScreen comparte proporciones de HOME, con cabecera propia, héroe y compañeros mayores, seis fichas por página y navegación entre estadios. El contador muestra objetos ya recogidos de cinco. HomeSceneArtwork proporciona bate, guante y pelota; InterfaceSprite proporciona el casco; SocialGiftArtwork reutiliza la lata de EnergyShopArtwork, el sprite de llave y dibuja un documento de recomendación con el emblema AA existente. Tras un cobro confirmado aparece un rótulo durante 750 ms, con un único listener temporal que se retira al terminar o cerrar. Los perfiles y equipos remotos siguen siendo entradas explícitas del render; no se asignan al guardado local. No se añaden PNG ni se modifica el arte anterior; el documento es una composición nativa nueva.

Referencia visual de visita: `reference_visual/facebook_play_20261012/frame-0018.0.png` (00:18). La presentación de REGISTER/GIFTS/INBOX es una reconstrucción funcional del remake; no se presenta como arte o pantallas originales recuperadas. La visita conserva la composición observada y usa los recursos ya incluidos, tanto recuperados como reconstruidos anteriormente. No se afirma paridad exacta ni mejora general de FPS.

## Integridad de acciones y pruebas

Una petición bloquea las acciones mientras se transmite. Si se pierde una respuesta de una mutación, RETRY vuelve a enviar su mismo requestId y otra mutación no la reemplaza. REFRESH en ese estado reintenta la operación pendiente. Una respuesta válida actualiza el snapshot y el guardado existentes. Cerrar o cancelar una vista previa no envía regalos.

Prueba local con WebMain público sin instrumentación: ocho cuentas nuevas y siete amistades. Registro sin código, nivel 1/Rookie/6,000 Coins/sin lentes. Solicitud desde REGISTER, perfil no aceptado privado, aceptación desde el INBOX de la otra cuenta. Siete fichas aceptadas y paginación. Previsualización de regalo y cancelación por Esc sin envío. Pérdida intencional de respuesta después de guardar el envío; reintento con el mismo requestId y un único regalo. Los tres tipos de regalo se recogen desde INBOX una sola vez. Conservación tras recargar.

Visita al estadio distinto de la otra cuenta, cuatro objetos a 20 Coins, energía compartida +1 para cada cuenta, cancelación sin gasto, doble clic, pérdida de respuesta tras cobrar un objeto y reintento con la misma operación. Refrescar y recargar no repiten premios. La cuenta del amigo recibe su energía al volver a abrir y la conserva tras otra recarga. Equipo, roster, apariencia, estadio y progreso propios se conservan. Se corrigió contraste insuficiente antes de cerrar la verificación visual. Las dos ventanas de prueba usan el mismo tamaño. Tras una respuesta rápida, un segundo clic puede recoger otro regalo que ocupe la misma fila; se comprueba que cada registro se acredita una sola vez. Sin errores JS/AVM2 en el recorrido final.

En HTTPS se repitió el recorrido con cuatro cuentas y tres amistades: solicitudes, regalos, visitas, reintentos y persistencia. Los 143 archivos instalados coinciden con el manifiesto. Las cuatro cuentas QA se retiraron con sus relaciones preservando las cuentas anteriores.

## Publicación y conservación

Build `959956fa5be9f938`; SWF SHA256 `1b4b128c7578f7389f8318c72d7ed1e0c671485198ae5fd3adac9a646bb1b484`; 39,209,190 bytes. Paquete de 147 archivos, biblioteca `4081d0567b8a132aa3b95d7a997a7c44d3cd911f95d9c6865529649555b6d8c3` con 114 archivos y 113 recursos reutilizados mediante enlaces duros. Sin cambios de archivos externos de arte/audio. La compilación se contrasta con el snapshot de fuentes generado para evitar publicar fuentes desactualizadas.

GameData, modelos, CoreGame, servidor y cliente web conservados por hash; la cabeza de bateo 0.8.6 tampoco cambia. Guardado v24, SQLite v4 y resetEpoch conservados. No se reinician cuentas ni datos. Copia SQLite previa con integrity_check y SHA256 comprobados.

Para disponer de espacio se archivó la biblioteca antigua 1.0.24: sus 114 hashes se comprobaron en la copia local, y su ejecutable y manifiesto se guardaron como `build/qa/release1031/archived1024-*` antes de retirar únicamente su carpeta remota. No se tocaron bases de datos ni respaldos. Las versiones 1.0.30 y 1.0.29 se mantienen en Railway. Evidencia: `build/qa/release1031/storage-maintenance.json`. `research/restore_archived_library1031.py 1024` reconstruye la biblioteca archivada sin activarla, previa comprobación de espacio; hay que restaurarla antes de reactivar esa versión antigua.

[Comparación visual](COMPARACION_MEJORAS_1031.html). Sigue pendiente la prueba de amigos desde dos computadoras físicas.
