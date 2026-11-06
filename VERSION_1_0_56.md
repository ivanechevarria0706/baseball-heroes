# Baseball Heroes 1.0.56

La amistad deja de depender de publicar equipos y elegir un bateador. account_friends guarda una solicitud por pareja canónica, con remitente y aceptación del destinatario; /social/add reintenta sin duplicar y dos solicitudes mutuas representan consentimiento. Las solicitudes antiguas no se duplican y friend_links sigue dando sus bonos. Las rutas de aceptar, rechazar y cancelar validan el participante y estado. Los perfiles conservan la aceptación como condición de acceso.

SocialScreen abre FRIENDS por defecto, busca por nombre o enlace y acepta solicitudes en la lista. SHARE LINK muestra un enlace seleccionable y llama a la copia del navegador con alternativa Ctrl+C. Las peticiones nuevas también aparecen en INBOX. BATTER LINKS queda opcional. Se consulta cada10s cuando el usuario no está escribiendo ni en una ventana de compartir; el temporizador se retira en dispose. HOME, el draft y el consejo del partido usan ADD FRIENDS.

FriendInvite/BHWeb retienen un identificador público por query; WebMain lo captura y Main lo abre al llegar a HOME, después de la creación. Se consume y limpia para no reabrirlo en bucle. No envía mensajes ni solicitudes sólo por abrir el enlace. El alta de cuenta sigue abierta.

Las visitas pueden leer una vista acotada de la carrera guardada de un amigo aceptado sin crear/reemplazar su equipo de exhibición. GameData sólo añade los nuevos amigos aceptados al contador social; el resto del modelo, pitch, swing y arte siguen iguales. SQLite4/save24 y reset38 conservados; account_friends se añade sin borrar tablas.

55 pruebas de servidor; navegadores locales de amistad entre dos sesiones, compras/alineación y limpieza/RECORD/puntos; recorrido público entre dos cuentas con enlace, aceptación, visita y regalo persistente.238 archivos publicados cotejados. Dos perfiles sintéticos retirados y progreso real comparado con respaldo. Biblioteca55 retenida para rollback;54 archivada con hashes verificados.

Build b5e46a4594b8ec6e; SWF 2042b36733bf81e914a8dc3787f5e700d54a87d66f128e21465d99925ae28d2a.
