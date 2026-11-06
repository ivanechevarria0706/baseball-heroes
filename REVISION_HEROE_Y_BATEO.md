# Héroe y bateo — 0.5.7

Se revisó el personaje usando las poses de F.A.F. alrededor de 382–384 s y la secuencia de Kediri alrededor de 28.6–31 s. El dibujo sigue siendo vectorial nativo; no se recuperaron sprites originales.

- Casco con contorno, protección de oreja y reflejo revisados; bate con el mismo material y forma en HOME y bateo.
- Nuevo héroe frontal en HOME, con cabeza, rostro, uniforme, guantes, zapatos y postura con el bate sobre el hombro. Conserva la paleta y el equipo actual.
- Los retratos del héroe con casco utilizan el mismo dibujo frontal, incluyendo las tarjetas, la ficha y el HUD.
- Preparación con rodilla elevada, contacto rápido, giro de cabeza y torso, talón trasero elevado y continuación del swing sostenida durante la pausa de contacto.
- Reacciones de fallo y celebración: ahora se reconocen SINGLE, DOUBLE, TRIPLE y HOME RUN además de HIT. La reacción se desarrolla después del swing y luego vuelve al reposo.
- La camiseta del héroe usa el número de uniforme elegido, tanto en el partido como en la escena de resultado. Antes el partido usaba la posición en el orden de bateo.

El sonido de contacto sigue disparándose al resolver el batazo. La pose alcanza el contacto visual a los 65 ms del swing, frente a los 120 ms anteriores. No cambian la ventana de timing, la física ni las probabilidades del encuentro. Se mantienen los cuatro sonidos proporcionados.

## Comparación en movimiento

Abre `COMPARACION_HEROE.html`. Incluye un fragmento local de F.A.F. y una secuencia de 96 cuadros renderizados por el actor real del remake a 25 fps. La preparación y el contacto se sitúan aproximadamente en el mismo momento para comparar las poses. La secuencia del remake es una demostración controlada del actor, no una grabación de una jugada completa; incluye tu sonido de batazo en el momento de la orden de swing. Los videos pueden reproducirse juntos, pausarse y verse a velocidad reducida.

También hay capturas del juego real en HOME y durante el bateo. Las imágenes de entregas anteriores se conservan con sus versiones originales.

## Comprobaciones

- `HeroMotionSmoke`: misma pose de recuperación a 15/60 fps, contacto alto/bajo, pulsaciones repetidas, ocho poses/reacciones, renderizado de 96 cuadros y liberación repetida de recursos.
- `ClassicMatchSmoke`: contacto real por SPACE en Rookie y Major, resultado y regreso a la simulación, sin deformaciones ni solapamiento de HUDs.
- `HomeLineupSmoke`: navegación, fichas, cambios y guardado de alineación, nuevo retrato y llegada de los nueve puestos al partido.
- Verificación por huellas de los cuatro WAV originales y las copias instaladas de sus MP3; identidad de guardado conservada.
- Los dos MP4 se decodifican correctamente. Los informes vigentes se enumeran en `revision_manifest.json`; el resto es historial.

## Límites

El parecido aún necesita trabajo en las siluetas y expresiones, poses intermedias, uniformes y detalles de ilustración. Los peinados y rasgos editables no cuentan todavía con todas las variantes animadas del original. El Derby conserva su actor anterior. La comparación permite valorar el avance sin presentarlo como una copia exacta del gameplay.

Ejecuta `JUGAR.bat` para usar la compilación incluida. La versión anterior permanece en el ZIP 0.5.6 de la carpeta superior.
