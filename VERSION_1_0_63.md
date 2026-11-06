# Baseball Heroes 1.0.63

PUBLICADA

Corrige el bloqueo de LINEUP por un encuentro pagado sin terminar. Entrar al menú prepara de nuevo la alineación; el mismo fixture conserva su pago de cuenta y bat. Las cartas de su reserva se liberan una sola vez y al reiniciar se reserva la selección final. `specialMatch.preparing` persiste para evitar devoluciones repetidas al recargar. El encuentro se reinicia con la selección actual, sin cobrar energía otra vez. Funciona en temporada y postemporada.

Los amigos aceptados seleccionados en drafts anteriores se incorporan al banco al actualizar la lista social; reclutar al banco ya no está bloqueado por un encuentro pendiente. La ventana refresca las filas al recibir el estado social.

26 comprobaciones privadas y dos cuentas en el WebMain de producción: pendientes, draft antiguo, sustituciones normales y especiales, recarga y dos reinicios pagados. Heroe y partida del otro usuario conservados. Save 24, SQLite 4 y reset38 sin cambios.

Build 2639c5421f603f5e; SWF 615a8fc42184b60669682b4ca2f6562451029c6e96b166a7206eb8810704c172.
