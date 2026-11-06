# Baseball Heroes 1.0.57

HOME incorpora HomeFriendFence con ocho tarjetas de amigos aceptados sobre la cerca, retrato mediante FriendDraftPortrait, espacios vacíos con +, tooltip y paginación. Las tarjetas visitan la cuenta seleccionada; los espacios vacíos abren FRIENDS. REQUESTS abre FRIENDS y GIFTS abre INBOX mediante el parámetro opcional de Main.showHomeFriends. No crea amigos CPU ni asigna bonos de bateador automáticamente.

LobbyScreen reutiliza su reloj y OnlineClient para consultar novedades cada veinte segundos sin ventanas superpuestas. Conserva las tarjetas ante un error y reintenta; sólo reconstruye los retratos al cambiar la respuesta y libera sus controles al salir. Las entradas se bloquean bajo ventanas. No agrega temporizadores por tarjeta.

HomeIconMotion muestra un banderín azul para objetivos completos dentro de una misión pendiente; las recompensas listas tienen prioridad naranja. HALL coloca su aviso bajo la copa para no cubrir al héroe. No se cambian las ilustraciones ni la cabeza aprobada.

Tres recorridos locales con WebMain final: amigos en dos sesiones, compras y sustituciones hasta entrada al partido, limpieza/RECORD/habilidad/taquilla. Una prueba privada de componentes comprueba doce amigos, paginación, tooltips, bloqueo y estados de banderines; sus métodos de diagnóstico no están en producción. Recorrido público entre dos cuentas: solicitud, aceptación, actualización de HOME sin recargar, visita y regalo cobrado una vez. Los dos perfiles QA se retiran. Paquete y progreso real comparados tras publicar.

Servidor, GameData, pitching, swing, audio y assets sin cambios. Save24, SQLite4 y reset38 conservados. No se reinicia ninguna cuenta. Biblioteca56 retenida para recuperación;55 archivada con copia y hashes verificados.

Build bb3e603c137e28b5; SWF 545fa83d66bf7b0fa6dec5752a91d9848c5dae3aaba78cda8dda45f1a7cf399d.
