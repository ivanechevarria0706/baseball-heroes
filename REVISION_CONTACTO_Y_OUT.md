# Versión 0.4.8 — contacto y out de simulación

Del nuevo banco F.A.F. se integra **únicamente Out de simulación**, según la selección del usuario. El recorte es el mismo de la página de escucha: 418,69–418,89 segundos del video aportado. Sustituye al sonido anterior de out en la simulación, sin reproducir ambos a la vez. Se precarga al construir el panel y se reutiliza; la ausencia del archivo no bloquea el juego.

Los recortes de lanzamiento, swing y contacto activados en 0.4.7 se retiran de la reproducción y de las dos carpetas de recursos activos. Sus originales se conservan en el banco de referencia. Las pistas que ya tenía el proyecto antes de ese banco permanecen como estaban. `ESCUCHAR.html` y su manifiesto reflejan que solo Out de simulación está integrado.

## Presentación del contacto

En el gameplay F.A.F., NICE se ve en el campo alrededor de 06:23,6; el seguimiento de la pelota empieza alrededor de 06:24,8. El remake antes ocultaba el campo inmediatamente al decidir un hit o un out con contacto.

Ahora mantiene la cámara de bateo durante 1,2 segundos tras un contacto GOOD/PERFECT. El swing y la pelota siguen animándose; NICE usa un tono blanco azulado y una inclinación más cercana al rótulo del video. Después entra la secuencia de resultado. La duración se mide con reloj, no contando fotogramas.

Se corrigió además un problema de AIR: el texto con una fuente del sistema desaparecía al girarlo. Ahora el rótulo se dibuja primero en una imagen transparente y se anima esa imagen. Su aparición real se verificó en `build/qa/v048-contact-verified.png`, además de comprobar los píxeles en la prueba.

ENTER y SPACE repetidos durante esta pausa no saltan el turno ni disparan otro swing. El resultado y sus estadísticas se calculan una sola vez. El avance automático espera a que termine la presentación. ENTER sigue permitiendo adelantar la cinemática hasta la tarjeta de resultado y continuar cuando termina su breve exposición. La pausa pendiente se cancela al limpiar o cerrar la escena.

Los strikes, balls, fouls y ponches no reciben esta nueva pausa de contacto. Las fórmulas de bateo no se modifican. Las habilidades especiales pueden mostrar su propio rótulo en lugar de NICE, como antes.

## Comprobaciones

- Compilación de Main, AudioSmoke, ContactSmoke y VisualSmoke.
- `AudioSmoke`: seis reproducciones del out seleccionado, reutilización del mismo sonido, volumen en silencio y eventos de fin de reproducción.
- `ContactSmoke`: entra a un partido con guardado aislado, observa la pelota y pulsa SPACE; verifica campo/NICE a los 700 ms, color e inclinación, protección frente a teclas repetidas, transición después de 1.200 ms y continuación desde el resultado. Capturas `build/qa/v048-contact-*.png`.
- `VisualSmoke`: HOME, alineación, lanzamiento y swing en dos estadios.
- Integridad del MP3 seleccionado, igualdad de las dos copias activas y ausencia de los tres recortes desactivados en esas carpetas.

El identificador de aplicación y el formato de guardado se conservan. Las versiones anteriores siguen en sus ZIP separados. El arte de los personajes, los estadios nativos y las cinemáticas todavía requieren más trabajo de fidelidad; esta revisión no convierte todo el remake en una copia exacta del original.
