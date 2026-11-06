# Sprites ilustrados — versión 0.6.0

El bateador y el lanzador del partido ahora se dibujan con hojas de imágenes de 16 poses. Los defensores usan la pose de campo del lanzador. Las 32 figuras de `11_09.png` sustituyen los retratos genéricos de las cartas especiales; Lenard conserva la ilustración que ya tenía. Se mantienen los sistemas existentes, las 33 cartas y el guardado v20.

## Qué se incorporó

- Bateador: espera, carga, paso, contacto, seguimiento, recuperación, fallo y celebración. Las transiciones dependen del tiempo transcurrido; un segundo clic no reinicia el swing.
- Lanzador: preparación, elevación de rodilla, separación de manos, lanzamiento, seguimiento y recuperación. La pelota se dibuja por separado y sale de la mano; el origen se conserva incluso si un cuadro llega tarde.
- Uniforme, casco, bate, piel y zapatos del bateador adaptan su color a los datos existentes. El dorsal aparece cuando la espalda queda despejada. El lanzador adapta el uniforme al rival.
- Los recortes usan los límites medidos de cada figura y un anclaje en los pies. Los PNG originales conservan el canal alfa, incluidos contornos y ropa negra.
- Las texturas se preparan al crear los actores, antes del lanzamiento. Se comparten por paleta y se liberan con un límite de seis paletas inactivas; nunca se libera una textura mientras otro actor la utiliza.
- El Derby usa el nuevo bateador. La pelota llega junto al bate sobre el plato; antes aparecía muy lejos a su derecha. Se conservan el objetivo de timing de 0,84, las ventanas de acierto, los diez lanzamientos y las recompensas.

## Procedencia y límites

Las seis láminas recibidas están archivadas sin cambios en `reference_visual/user_sheets_20260922/`. Logos, sobres e insignias ya estaban representados en los assets anteriores. En esta entrega se aprovechan los 32 personajes de `11_09.png`, copiados íntegramente como `assets/sprites/v060/characters-atlas.png`; el recorte ocurre al dibujarlos. La asignación a nombres de cartas pertenece al remake, no identifica personajes históricos del original.

Las hojas `batter-atlas.png` y `pitcher-atlas.png` son **reconstrucciones nuevas generadas con la herramienta integrada image_gen** a partir de descripciones apoyadas en las referencias revisadas. No son sprites recuperados de Syntasia. Cada hoja recibida mide 1254 × 1254 píxeles con alfa; se conservó esa resolución. Los prompts exactos están en `assets/sprites/v060/PROMPTS.md`.

Son 16 poses por personaje, no 16 cuadros nuevos para cada acción. Las poses intermedias aún pueden mejorarse para suavizar el movimiento. El ajuste de altura del golpe gira moderadamente la ilustración completa. Las formas de casco, bate y cuerpo siguen siendo comunes: el nuevo actor adapta colores, pero no reproduce todavía todas las formas de equipo, peinados, gafas y variantes del personaje. HOME conserva su ilustración frontal anterior. Las prendas de `11_11.png` y los personajes de `11_08.png` quedan como material para próximas integraciones; no se anuncian como animados.

## Comprobaciones

Las pruebas se ejecutan con identificadores AIR diferentes al del juego. No utilizan la partida del usuario.

- Recortes de 16 + 16 poses, 32 asociaciones distintas de cartas y conservación de texturas compartidas después de destruir actores.
- Recuperación del swing a 15 y 60 fps, alturas de contacto, doble pulsación y destrucción repetida.
- Origen de pelota bajo transformaciones, retraso de cuadros y ausencia de una segunda pelota en la mano. Las siete escenas de resultado siguen funcionando.
- Partidos en Rookie y Major; transición de bateo a resultado y simulación.
- Partido completo de nueve entradas: estadísticas individuales y totales consistentes, avance de temporada una vez, resultado guardado y recargado.
- Derby completo con diez home runs y pago de 3000 monedas una sola vez; comprobación espacial de pelota y bate.
- Colección, filtros, compra y revelado de cartas con las nuevas ilustraciones.

Los informes de esta entrega se enumeran en `revision_manifest.json`. Los demás informes y comparaciones incluidos son historial. Las capturas proceden de partidas de prueba y pueden tener inventarios o colores diferentes.

## Archivos

- `COMPARACION_SPRITES.html`: antes/después, todas las poses y secuencia animada renderizada por AIR.
- `assets/sprites/v060/`: tres hojas PNG, prompts, rectángulos/anclajes y asociaciones de cartas. Los archivos `*-bounds.json` son diagnósticos de la cuadrícula inicial; el juego usa `SpriteFrameLayout.as`, generado a partir de `frame-layout.json`.
- `JUGAR.bat`: ejecuta la compilación incluida sin recompilar. Requiere el SDK AIR local indicado en el LEEME.

Todo se conserva localmente. El audio y las fórmulas de temporada, cartas, simulación y timing del partido no se modificaron en esta entrega.
