# Baseball Heroes 1.0.39
Publicado en Railway y comprobado en Chrome.

60 poses corporales propias (16 bateo, 16 lanzador, 16 defensa, 12 runner) y tres vistas de cabeza trasera, generadas con la herramienta integrada image_gen. PNG originales conservados, ventanas y puntos medidos en assets/sprites/v1039/motion.json; prompts completos incluidos allí. Los cuerpos se reutilizan con materiales de equipo/piel/equipamiento y con el retrato de cada jugador; no se anuncian 1,512 secuencias individuales.

Nuevo cuerpo de bateo para los héroes artVersion1, sin cambiar la cabeza frontal elegida en el creador. Cuerpo, cabeza y calzado siguen un tamaño constante entre poses; cuello, mano de salida y contacto del bat tienen anclajes medidos. Lanzador, defensores y runners usan las nuevas poses. Nombres de lanzadores de la temporada tomados del catálogo normal existente. Se conservan los estilos aprobados y las ilustraciones MLB anteriores.

Vista de campo animada en el autojuego: solo presenta resultados ya resueltos, sin RNG ni escritura de progreso. Swing, trayectoria, defensa y avance del bateador; WALK sin swing, out sin corredor ficticio. Bases reales conservadas en el diamante del panel. Reloj compartido con pausa y velocidades; las vistas liberan recursos al salir. Materiales comunes separados una vez y cambios de color mediante operaciones nativas; caché acotada y precarga de defensores repartida para evitar bloqueos al entrar.

Contacto visual de45ms en el bat para bolas puestas en juego; Home Run conserva130ms y audio exclusivo. Salida de la pelota desde mano vacía, fija entre cuadros retrasados. Sin cambios en BattingSystem, PitchCadence, MatchMomentum, MatchScoring, economía ni servidor.

50 pruebas de servidor y tres suites locales: revisión de poses/anclajes/identidad/pausa, producto real con compras/equipamiento/persistencia/entrada al partido, partido completo con nueve bateadores y totales conciliados. Verificación pública del SWF final y limpieza exclusiva de la cuenta QA. No equivale a probar todas las combinaciones de equipamiento ni equipos físicos distintos.

Sin reinicio de perfiles, guardados o temporada; epoch38 y lógica idempotente sin cambios. Copia SQLite consistente privada antes de publicar; comprobación dentro del servidor devuelve solo conteos y booleanos. Paquete de despliegue excluye diagnósticos y documentos de investigación.

Build 47181df1b91fc7aa; SWF 408899458b147c66fd2953007ea9c85a254aed3c3a5de323aadf1f9f05305247.
