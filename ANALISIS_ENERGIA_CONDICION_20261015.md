# Energía de cartas y condición de jugadores

Revisión del 15 de octubre de 2026 sobre la versión 1.0.9, build `4b22b9f99946a738`. Es un análisis con una prueba aislada del modelo; no modifica el juego publicado ni las cuentas.

## 1. Las cartas especiales sí tienen dos usos

El gameplay **Seguimos En Primer Lugar (Casi Me Ganan)** muestra las mismas cartas Freddy y Will con **2/2 a 01:40**, **1/2 a 04:10** y, después de otro partido, grises con **CHARGE y 2:56:30 a 08:10**.

El gameplay **Vamos En Primer Lugar Y Explicando Algunas Cositas** aporta una prueba más directa: a **15:18**, el tooltip dice «Especial energía de bateo. 1 energía por cada juego». A **17:10**, Freddy conecta un hit mientras su carta ya indica **0/2**. Por tanto, agotar la última unidad no lo retira del partido que ya pagó.

- Cada ejemplar tiene su propia reserva, independiente de sus duplicados.
- La unidad se gasta por partido, no por turno al bate.
- Las referencias confirman el paso 2 → 1 → agotada y la existencia de CHARGE.
- No muestran una recarga natural completa ni una compra de CHARGE con su precio.
- Tampoco permiten precisar si el consumo original ocurre al entrar o en el primer uso de la carta.

**Lo que hace ahora el remake:** descuenta una unidad de cada carta activa al reservar un partido nuevo, conserva su participación durante ese partido y evita cobrar otra vez al reabrirlo. Una carta agotada deja de cubrir al compañero regular en el siguiente partido. Las cartas de banca no consumen energía.

La prueba aislada de este análisis comprobó esos casos, incluido guardar/cargar. No fue una partida completa ni una prueba nueva del sitio publicado.

**Reglas que siguen siendo aproximaciones:** el remake recupera **una unidad cada tres horas**, contando desde el primer gasto, hasta dos. Partiendo de cero y con un reloj recién iniciado, son tres horas para 1/2 y seis para 2/2. CHARGE llena hasta 2/2 por una Hero Coin por unidad faltante. El video respalda un contador cercano a tres horas, pero no demuestra esa política de recuperación ni ese precio.

## 2. La flecha es condición, separada de la energía especial

En la referencia se ven cinco combinaciones de color y dirección:

| Aspecto observado | Interpretación de condición |
|---|---|
| Roja ↑ | Mejor |
| Amarilla ↗ | Buena |
| Verde → | Normal |
| Azul ↘ | Baja |
| Gris ↓ | Peor |

Los colores y direcciones son visibles. Los nombres de esta tabla son una interpretación, no textos recuperados de un tooltip original. La [guía de estrategia de Gamelytic](https://gamelytic.com/baseball-heroes-winning-games-strategy-guide/) recomienda rotar jugadores según su condición; no aporta porcentajes ni una fórmula.

Hay una observación que descarta usar exclusivamente un contador decreciente de partidos: **Fernando tiene flecha amarilla a 01:40, roja a 04:10 y amarilla a 08:10**, mientras participa en esos encuentros. La condición puede mejorar entre partidos. Esto no demuestra por sí solo que el cambio sea aleatorio, dependa del rendimiento o se rija por tiempo.

Las cartas especiales de Freddy y Will mantienen flecha roja al pasar de 2/2 a 1/2. Por tanto, no corresponde convertir la mitad de energía especial en una flecha de peor condición. El héroe también tiene flecha; no es un indicador exclusivo de los compañeros.

## 3. Diferencias concretas en el código actual

| Área | Estado en 1.0.9 | Diferencia o límite |
|---|---|---|
| Dos usos de carta | Implementado y comprobado en el modelo | Falta mostrar el ciclo con claridad en las filas de LINEUP. |
| Titulares especiales | LINEUP dibuja las nueve filas regulares; las cartas activas aparecen como pequeñas casillas arriba | El original muestra al especial, su grado y su energía dentro de la fila sustituida. |
| Carta agotada | Se excluye del siguiente partido; la casilla superior muestra 0 | Falta la fila gris con reloj y acceso directo a CHARGE, como la referencia. |
| Jugadores normales | Tienen una reserva local de 6 usos, +1 cada 30 minutos | No se encontró evidencia de ese límite o intervalo en el original. |
| Condición normal | Se deduce totalmente de esa reserva: 6/5 = +2, 4/3 = +1, 2 = 0, 1 = −1, 0 = −2 | Mezcla fatiga y condición; no reproduce el aumento observado entre encuentros. |
| Efecto actual | En compañeros normales modifica atributos de partido entre −4 y +4; el héroe queda fuera | Son valores locales, no una fórmula recuperada. |
| Sin reserva normal | Aparece aviso; SKIP permite jugar y produce OUT para esos compañeros | No se ha demostrado que una flecha gris original impidiera batear. |
| Flechas de LINEUP | Una misma orientación; mejor estado azul y peor rojo | Colores invertidos respecto a la referencia; faltan las cinco direcciones. |
| Flechas de autojuego | Mejor rojo, buena amarilla, normal verde, baja azul | Difiere de LINEUP; el peor estado no tiene su gris y dirección vertical propios. |
| Barra rosa | Actualmente dice E n/6 y LV | En el original el número corresponde al nivel y la barra es consistente con progreso de XP. Milcíades pasa de nivel 16 con barra casi llena a 17 con barra baja entre 04:10 y 08:10. No debe confundirse con la reserva verde 2/2 de las especiales. |

Código revisado: `SpecialCardInventory.as`, `PlayerCondition.as`, `GameData.as`, `LineupScreen.as`, `CardWorkshopOverlay.as`, `SimulationPlayerRow.as`, `TeamSimulationPanel.as` y la simulación de compañeros en `Game.as`.

## 4. Corrección que se desprende del análisis

1. Conservar el consumo confirmado de una energía por partido y la reserva de dos por carta.
2. Presentar al especial activo en la fila correcta: ilustración, clase/grado, 2/2 o 1/2; agotada en gris, reloj y CHARGE. Mantener visible que un partido ya reservado conserva su carta aunque quede a cero.
3. Separar tres conceptos: **nivel/XP**, **condición** y **energía de carta**. Usar una misma escala visual de cinco flechas en LINEUP y autojuego, con explicación en español.
4. Revisar la reserva artificial de seis usos de los normales y su OUT automático antes de trasladarla a una nueva implementación de condición.
5. Una condición nueva debe guardarse y fijarse por partido: reordenar, recargar o abrir una ficha no debería permitir buscar una flecha mejor. Su fórmula y sus efectos deberán seguir documentados como reconstrucción mientras no aparezca más evidencia.
6. Mantener claramente documentados los supuestos de recarga y precio. No cambiar a «2/2 cada tres horas» presentándolo como regla confirmada.

No se aplicó todavía esta revisión al juego. La publicación sigue en 1.0.9 y no se borró ningún progreso.

## Evidencia y comprobación

- [Vista con los fotogramas](ANALISIS_ENERGIA_CONDICION_20261015.html).
- Referencias conservadas: `reference_visual/gameplays_20260924/primer_lugar-0100.jpg`, `primer_lugar-0250.jpg`, `primer_lugar-0490.jpg`; `reference_visual/explicando_20260924/frame-0918.jpg`, `frame-1030.jpg`.
- [Resultado del diagnóstico](../research/energy-condition20261015/model-audit.json): **16 comprobaciones aprobadas**, sobre el código actual, con identidad AIR de prueba independiente. El avance entre partidos fue sintético y no otorgó resultados ni premios.
- Fuente secundaria consultada: [Gamelytic, Winning Games Strategy Guide](https://gamelytic.com/baseball-heroes-winning-games-strategy-guide/). Corrobora la importancia de la condición; no establece su algoritmo.
