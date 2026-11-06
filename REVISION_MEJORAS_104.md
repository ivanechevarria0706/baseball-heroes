# Mejoras 0.10.4 — presentación y continuidad del partido

Puntos autorizados: 1 (interfaz), 2 (lanzador y defensores), 3 (transiciones). 11 de octubre de 2026.

## Referencias y alcance

Comparación con reference_visual/v054/faf-ready.png y la secuencia de lanzamiento reference_visual/calibration097/pitch-73.5.jpg. Se conservan el estadio ilustrado de 0.10.3, la geometría del campo y la cabeza y cabello aprobados de 0.8.6. Los cuadros actuales son reconstrucciones, no sprites originales recuperados. Las fuentes siguen siendo sustitutas; no se declara paridad total con el original.

## Interfaz

- Marcadores con cifras gruesas y contorno oscuro. La flecha de entrada corresponde a la mitad que se juega.
- C/P/L con indicadores azul, rojo y verde, valores independientes y ajuste de texto.
- Nombre del bateador por encima de la franja inferior, sin cubrirlo con el retrato. El retrato del héroe emplea la cabeza de 0.8.6, con la apariencia guardada, sin fondo rectangular.
- Historial sobre franjas oscuras para mantener legibilidad. Se elimina el aviso duplicado de entrenadora para logros; se conserva el progreso del logro.
- Minimap con bases, posiciones defensivas, pelota durante la pichada y trayectoria de contacto. Los corredores recorren el diamante; sus destinos se toman del estado resuelto por Game. No calcula nuevos hits, outs ni carreras. Al terminar o interrumpir la animación se reconcilia con las bases reales y se retiran los marcadores temporales.

## Lanzador y defensa

- Se reduce solo la proporción de cabeza del lanzador y defensores; no se cambia el bateador.
- Respiración y elevación leves durante preparación; el punto de salida sigue saliendo de la mano de la pose 15, incluso cuando un cuadro llega tarde.
- Los defensores antes recibían reactHit pero su rama de campo no procesaba la reacción. Ahora cambian entre poses de desplazamiento y recepción y se mueven durante la vista de contacto. Regresan a sus coordenadas originales antes de la siguiente pichada.
- Las escenas dirigidas por HitCinematic conservan control de sus propias poses, evitando que el idle del actor sobrescriba la recepción o devolución.

## Continuidad

- DOUBLE/TRIPLE ya muestran seguimiento desde su primer cuadro. Se elimina un tramo vacío de 24 cuadros de referencia (800 ms), conservando la duración del seguimiento y de las ilustraciones posteriores.
- La cámara recibe posición, escala y rotación de la pelota de la vista anterior. Los primeros 180 ms interpolan su posición y escala hasta la trayectoria de seguimiento.
- SINGLE y outs usan el mismo traspaso. Las recepciones y devoluciones usan las anclas del guante y mano del actor.
- STRIKE OUT muestra el resultado y reacción del bateador, sin simular un batazo, persecución ni llegada a una base.
- Continúa el avance automático y ENTER para adelantar el resultado. El ledger y el pago de recompensas no se modifican.

## Preservación y pruebas

Preservación por SHA-256 de cabeza, cabello, HeroSprite, ClassicBatter, RunnerSprite, PitchCadence, BattingSystem y MatchScoring. Carrera v21 y SQLite v3; sin migraciones de inventario o balance.

Pruebas de reloj controlado: preparación y ancla de lanzamiento, reacción y reinicio defensivo, siete tipos de cinemática, ausencia de intervalo vacío, coordenadas finitas y reconciliación del minimapa. Pruebas reales de Chrome: contacto → seguimiento → resultado → continuación con cinco desenlaces; vuelos ROOKIE x1/x2/x4; registro, creador, primer partido y vuelta a iniciar sesión con el guardado conservado.

Entrada al partido: 6385 ms. Muestra de 45.2 s: 59.92 FPS; p95 25 ms; cuadro más largo 130 ms. Medición local en Chrome, no garantía para otros equipos.

Publicado y verificado por HTTPS en Railway: fb53063f-71ee-449a-a644-5e0cab82b45b. Versión 0.10.4, build f34cfb85f53c293b.

Pendientes fuera de este bloque: nuevos estadios, personaje femenino, ALL STAR/WORLD MATCH y prueba física con un amigo desde otra computadora. La copia del servidor, cuando se realiza, permanece en su volumen; no es una copia externa.
