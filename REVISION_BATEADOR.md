# Baseball Heroes — bateador 0.4.9

Esta revisión reconstruye la postura y el swing del héroe en la cámara de bateo, tomando como referencia el gameplay F.A.F. aportado: 382.20 s (postura), 383.00 s (preparación), 383.60 s (contacto) y 384.20 s (remate). Son dibujos vectoriales nuevos basados en esos fotogramas; no son los sprites ni el código originales.

## Cambios

- Casco más redondeado, visera, protección de oreja y cuello. Camiseta corta con número legible al girar, manos enguantadas y mango del bate envuelto.
- Elevación de la pierna delantera durante la preparación, apoyo al golpear, desplazamiento del torso y giro del pie posterior.
- Brazos articulados que acompañan las manos durante el contacto. El bate pasa detrás del casco durante el remate.
- Movimiento calculado por tiempo transcurrido. El contacto de la animación llega a los 120 ms, el remate a los 360 ms y se sostiene antes de volver a la postura inicial a los 1340 ms. Estos tiempos son un ajuste de esta recreación, no medidas exactas del motor original.
- Reacción con la cabeza baja para OUT y STRIKEOUT y recuperación de la postura al preparar el siguiente lanzamiento.
- Se mantienen los colores del equipamiento y uniforme, la pausa de contacto de 1.2 s de la versión anterior y únicamente «Out de simulación» del nuevo banco F.A.F.

## Comprobación

Compilación principal y tres pruebas AIR con identidades de aplicación independientes de la partida personal:

- `BatterPoseSmoke`: ocho poses con reloj controlado; comprueba que la preparación cambia la pose y que repetir swing durante la animación no la reinicia; genera `build/qa/v049-batter-poses.png`.
- `ContactSmoke`: realiza un contacto mediante SPACE, verifica que ENTER/SPACE repetidos respetan la pausa, que NICE genera píxeles visibles y que se puede continuar después del resultado. Capturas `build/qa/v049-contact-*.png`.
- `VisualSmoke`: construye HOME, LINEUP y partido y verifica preparación, salida de la pelota y swing en los estadios Rookie y Major.

Los resultados quedan en `build/qa/smoke-batter.txt`, `smoke-contact.txt` y `smoke-classic.txt`. El empaquetado verifica por hash el sonido elegido y comprueba que no se hayan activado otros clips F.A.F.

## Abrir

Ejecutar `JUGAR.bat`. El SWF compilado está incluido; se utiliza el SDK AIR ya instalado o `FLEX_HOME`. Se conserva el identificador `com.personal.baseballheroesremake` y el formato de guardado.

## Fidelidad pendiente

El bateador sigue siendo una aproximación vectorial: faltan volúmenes, poses de giro completas y celebraciones específicas. El lanzador y los defensores aún usan su arte anterior. La siguiente mejora visual debería centrarse en el lanzador y sincronizar sus poses con la salida y trayectoria de la pelota. Esta entrega no reproduce todas las animaciones ni todas las pantallas del juego original.
