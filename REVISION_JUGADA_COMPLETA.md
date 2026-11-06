# Baseball Heroes — jugada clásica 0.5.0

Esta entrega amplía la revisión del bateador a la secuencia de lanzamiento, contacto, vuelo y resultado. Se usaron fotogramas del video F.A.F. aportado: 382.20–383.20 s para el lanzador y 384.80–385.80 s para el seguimiento de la pelota. El arte y las animaciones son reconstrucciones nuevas, no recursos recuperados del motor original.

## Cambios visibles

- **Lanzador reconstruido:** gorra con visera, rostro bajo la visera, camiseta de color del rival, guante con costuras y piernas y brazos articulados. Se distinguen preparación, elevación de rodilla, zancada, aceleración del brazo, salida y recuperación.
- **Salida coordinada:** la pelota en la mano desaparece cuando empieza el vuelo. Su centro se transforma a las coordenadas del campo para evitar saltos de posición. Si un fotograma llega tarde, se conserva la postura de salida hasta que el partido toma la pelota.
- **Defensores:** usan el mismo estilo del lanzador, postura de fildeo y una reacción breve al contacto. El defensor de la escena de resultado también usa este personaje y el color del rival.
- **Pelota:** dibujo compartido entre partido y cámara de seguimiento, sombreado, dos costuras curvas y pequeñas puntadas. Estela turquesa en la parte final del lanzamiento y al salir bateada.
- **Cámara tras el contacto:** sigue una pelota que se aleja sobre el césped, con sombra y contador de distancia. Sustituye el vuelo anterior sobre un cielo con líneas radiales. Se mantienen la pausa inicial de 1.2 segundos y las ilustraciones de celebración existentes.
- **Derby:** respeta su preparación de 560 ms y toma la salida desde la mano del lanzador; antes usaba una posición fija y una animación de lanzamiento de duración diferente.

## Movimiento y continuidad

El vuelo bateado, el destello de contacto, las reacciones del lanzador y las fases de la cámara de resultado usan tiempo transcurrido. La trayectoria del lanzamiento conserva su objetivo, perspectiva y fórmulas de bateo existentes. La conversión del vuelo bateado toma como referencia el movimiento anterior a 30 fps; es un ajuste del remake, no una afirmación sobre la física original.

Las transiciones del resultado detectan el cruce de cada instante, en lugar de depender de que se dibuje un fotograma exacto. Adelantar con ENTER no reinicia el tiempo del resultado cuando este ya está visible ni bloquea una escena que ya terminó.

## Pruebas

- Compilación principal y de las pruebas AIR con el SDK instalado.
- `PitchSceneSmoke`: salida desde la mano con escalado y rotación; salida después de un fotograma tardío; origen estable ante llamadas repetidas; trayectorias rectas y curvas que llegan a su objetivo; equivalencia del vuelo bateado y del destello a 15, 30 y 60 fps; limpieza al reiniciar; siete tipos de resultado y adelanto repetido sin bloqueo.
- `ContactSmoke`: contacto real mediante SPACE, pausa de 1.2 s, NICE visible, bloqueo de entradas durante la pausa y continuación después del resultado.
- `VisualSmoke`: HOME, LINEUP y partido en Rookie y Major; preparación, salida de pelota y swing.
- `DerbySmoke`: diez lanzamientos mediante SPACE, diez contactos exitosos y recompensa única de 3000 monedas dentro de la partida de prueba.
- Empaquetado: verificación del identificador de la partida personal, hash del SWF, integridad del ZIP y selección de audio F.A.F.

Registros en `build/qa/smoke-pitch-scene.txt`, `smoke-contact.txt`, `smoke-classic.txt` y `smoke-derby.txt`. Capturas de esta revisión: `build/qa/v050-*.png`; las capturas de los dos estadios también quedan en `build/qa/classic-*.png`.

Las pruebas usan identificadores de aplicación separados. Se conserva `com.personal.baseballheroesremake` para el juego y su formato de guardado. Del banco F.A.F. únicamente está activo `faf_sim_out.mp3`, por elección del usuario.

## Abrir y alcance

Ejecutar `JUGAR.bat`; se incluye el SWF compilado. El proyecto sigue siendo local y utiliza el SDK AIR instalado o la ruta `FLEX_HOME`.

El parecido mejora en esta jugada, pero todavía faltan dibujos con el acabado original, giros completos del cuerpo, fildeo que siga cada trayectoria y la composición de otras pantallas. Las reacciones de los defensores son presentación visual, no un nuevo motor de IA o de simulación. La distancia de la cámara representa el resultado calculado por el remake. No se han reconstruido los algoritmos internos de Syntasia ni se ha comprobado una temporada completa en esta entrega.
