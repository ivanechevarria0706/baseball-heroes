# Baseball Heroes 1.0.41
Publicado y comprobado en Railway.

Posición independiente de cartas especiales (specialPositions, campo opcional compatible con save24). Arrastre entre puestos, intercambio de especiales/hero/normales, regreso al banco, colocación desde el banco por clic o arrastre. Los normales cubiertos quedan disponibles entre suplentes. Reemplazo de una carta activa sin exigir otra ranura vacía. Comparación de equipo calculada desde los jugadores visibles.

Snapshot de orden y posiciones al reservar el partido. Simulación y autojuego leen la misma asignación. No se consume energía por movimientos; el inicio reserva una participación y una reapertura no la duplica. Partidos pendientes conservan su formación; los anteriores a esta versión mantienen la colocación histórica. El héroe puede reordenarse, pero no retirarse de los nueve, para conservar los turnos manuales.

Rookie: vuelos1.10–1.60s, ventanas de contacto ampliadas, aro desde30% y verde durante GOOD. Las cuatro ligas superiores conservan sus velocidades y fórmulas de timing. Trayectoria que pasa por el blanco en IDEAL_CONTACT, profundidad continua, escala reducida, estela más corta, muestreo de la pelota al pulsar. Se elimina el swing por repetición de ESPACIO mantenido; KEY_UP y DEACTIVATE liberan el estado. Se mantiene la animación ilustrada existente y su pausa de contacto; no se anuncian sprites nuevos en esta entrega.

Tres suites locales y un recorrido público con SWF final: matriz de cinco ranuras y posiciones, reemplazo/banquillo/persistencia/energía, geometría del vuelo y tolerancias de Rookie, ratón/teclado, compras/EQUIP/LINEUP, partido completo de nueve entradas con carta en puesto8 y estadísticas conciliadas. Las pruebas usan entradas automatizadas y una máquina; no sustituyen la sensación de juego humano en distintas computadoras.

Sin reinicio de perfiles. Servidor, precios, audio, catálogo y arte aprobados sin cambios. Copia SQLite consistente dentro del servidor; verificación de preservación sin exportar perfiles. Cuenta pública QA retirada. Paquete242archivos auditado; diagnósticos privados excluidos. Se conserva biblioteca1.0.40 para rollback;1.0.39 archivada con hashes verificados.

Build 8df797cfac81dae2; SWF 6c6d71bd3022cd2f10acaf1678c669e1f2ed567dc7557c44bf5a44ee12678c86.
