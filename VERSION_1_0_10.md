# Baseball Heroes 1.0.10 — LINEUP, energía y condición

La alineación vuelve a mostrar los bateadores especiales dentro de las filas que cubren. Cada fila incluye retrato, clase, estrellas, grado, entrada/habilidad, energía verde y AVG del catálogo. El héroe mantiene su fila amarilla. La banca distingue cada ejemplar independiente.

1. **Energía de cartas:** 2/2 y 1/2 visibles. Al agotarse, la fila y el retrato quedan grises, aparece el reloj y se ofrece CHARGE. El reloj cambia cada segundo; una recuperación natural vuelve a mostrar la barra sin salir de la pantalla. La recuperación no fuerza a reconstruir retratos cada cuadro.
2. **CHARGE directo:** panel con precio, estado de la copia y confirmación. CANCEL conserva recursos. Fondos insuficientes, energía llena, recuperación natural durante la revisión y clics repetidos se comprueban antes del cobro. Un partido pendiente bloquea cambios de sus cartas.
3. **Nivel y XP:** los normales muestran una barra rosa con número de nivel y progreso dentro del nivel. Ya no se presenta como E n/6. El héroe conserva la composición sin esa barra.
4. **Condición:** una sola escala en LINEUP y autojuego: roja ↑, amarilla ↗, verde →, azul ↘ y gris ↓. La ficha muestra CONDITION. La condición se conserva al consultar, ordenar, recargar o reabrir un partido; solo avanza al liquidar un encuentro nuevo, una vez. AUTO SORT considera los atributos de partido con condición.
5. **Fatiga antigua:** la reserva local de seis usos deja de bloquear a los normales y de forzar OUT. Sus campos antiguos se conservan, pero la condición tiene su propio campo versionado. Se migra su estado anterior una vez, sin tocar nivel, XP, monedas, equipamiento o cartas.

## Reglas confirmadas y reconstrucción

Los videos confirman dos usos, una energía por partido, el reloj/CHARGE, las cinco flechas y la participación de la carta durante su último partido aunque ya indique 0/2. Las capturas y tiempos están en `ANALISIS_ENERGIA_CONDICION_20261015.html`.

Se conserva la recuperación local de una unidad cada tres horas y una Hero Coin por unidad faltante. El video no demuestra si la recarga original devuelve uno o ambos usos ni su precio.

La transición de condición es una reconstrucción: al completar un partido cada jugador normal y el héroe pueden subir, conservar o bajar un estado, dentro de −2…+2. Se calcula de forma estable a partir del partido y del jugador y se registra su clave; consultar o recargar no permite repetirla. Los compañeros conservan el efecto previo de hasta ±4 sobre sus atributos simulados. Se preservan el bateo manual y las estadísticas propias de las cartas; sus flechas se muestran en el mejor estado, como en las referencias observadas. No se presenta esta regla como una fórmula recuperada de Syntasia.

## Conservación y límites

Guardado v23 y SQLite v4, sin reinicio de cuentas. Cabeza aprobada 0.8.6, cabello, equipamiento, sonidos, reglas de pichadas, energía general y catálogo de cartas intactos. Las cartas siguen cubriendo los primeros puestos que no pertenecen al héroe; su gestión se realiza desde BATTER SHOP. La fila especial no arrastra un compañero invisible.

La nueva composición sigue los videos; los retratos existentes y los precios/reglas no recuperados siguen siendo reconstrucciones. ALL STAR/WORLD MATCH y la prueba física entre dos computadoras no forman parte de esta entrega.

## Verificación local

Tres suites en Chrome: controles/filas/recargas con datos aislados; WebMain público con clics reales, guardado y reentrada al partido; partido completo con dos cartas en su último uso, todos los compañeros con el antiguo contador en cero, pausa, resultado y liquidación. Los informes y las capturas se conservan en `build/qa/release1010`.

Publicación verificada: build `0d7c8f757f0a6fb8`. Tres suites locales y una en HTTPS aprobadas, con reserva de cartas, recarga, condiciones persistentes, partido completo y cobro único. Copia SQLite íntegra dentro del volumen; únicamente se retiraron las identidades sintéticas reservadas. No se reiniciaron las cuentas.
