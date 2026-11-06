# Tercer gameplay: reglas aclaradas y nuevas diferencias

Archivo: Gameplay ![Baseball Heroes---D Vamos En Primer Lugar Y Explicando Algunas Cositas _D.mp4. Duración 19:32.17; 640 × 360; 30 fps. Revisión local contra el código de la versión 0.6.1.

Se inspeccionaron capturas cada diez segundos de todo el archivo, además de secuencias seleccionadas cada uno o dos segundos. Se completó una transcripción automática local en español con faster-whisper-base. Contiene errores evidentes de reconocimiento: sirve para ubicar explicaciones, no como transcripción literal verificada. Los valores y reglas de este informe se apoyan en los textos visibles y las transiciones; no se derivaron probabilidades de la narración. No se revisó cada cuadro ni se reprodujo el video completo de forma continua.

## Qué cambia respecto al análisis anterior

1. **TRADE y ENHANCE son operaciones diferentes.** TRADE usa tres ejemplares de la misma clase; no exige personajes idénticos y puede entregar una clase superior en los casos observados. ENHANCE mejora un ejemplar.
2. **Hay ejemplares independientes**, como dos Nicky C. Hero con mejoras diferentes. Un contador de duplicados con un único nivel por nombre no basta.
3. **El máximo +5 está confirmado para las cartas Hero mostradas.** MAX no tiene siempre precio 12: en +4 cuesta 3 en el caso de Malcolm.
4. **El consumo es una energía por carta y juego**, según tooltip. El 0/2 aparece dentro del partido, por lo que se corrige la recomendación anterior de descontar únicamente al completarlo. Queda por fijar el instante exacto de cargo al entrar o empezar a usarla.
5. **WALK-OFF revela una revisión necesaria del motor**, además de una animación faltante: el cierre debe resolverse después de la jugada ganadora, sin esperar otros outs.

La siguiente entrega recomendada sigue siendo el ciclo de cartas, ahora con alcance más preciso: ejemplares independientes → energía por partido → TRADE → ENHANCE +5, preservando la partida y los duplicados existentes. El cierre WALK-OFF merece una corrección pequeña y separada dentro de las siguientes mejoras del partido. Este análisis no implementa todavía esos cambios.

## Evidencia

### 1. TRADE combina tres cartas de la misma clase

**Momento: 10:23–10:35 y 11:17–11:30.**

**Visible:** El texto exige tres Special Batter Cards de la misma clase y excluye las que están en la alineación titular. Se seleccionan Nicky C., Duke S. y Justin J., todos clase C y de distintos grados/personajes. Con 1.000 monedas se obtiene Yunesco E., B Rare. Un segundo intercambio de tres C produce Malcolm A., B Hero.

**Implicación para el remake:** Falta un intercambio de cartas especiales con tres ejemplares seleccionables. La función releasePlayer vende jugadores por monedas, y combineSpecialCard consume tres duplicados para mejorar un nivel: ninguna reproduce esta operación.

**Límite:** Se ven rutas de 1.000 monedas con ?% y 13 de moneda premium con 100%; la garantía exacta de esta última no se demuestra porque no se usa. Las cartas A y S que pasan durante la animación no son los premios finales. No deducir probabilidades de dos resultados.

Evidencia: [10:23](reference_visual/explicando_20260924/frame-0623.jpg), [10:27](reference_visual/explicando_20260924/frame-0627.jpg), [10:34](reference_visual/explicando_20260924/frame-0634.jpg), [11:29](reference_visual/explicando_20260924/frame-0689.jpg).

Código: `src/com/bh/model/GameData.as:1289`, `src/com/bh/model/GameData.as:1776`.

### 2. Dos copias pueden tener mejoras diferentes

**Momento: 10:23–10:25.**

**Visible:** Aparecen simultáneamente dos Nicky C. Hero: uno AVG .270 sin mejora y otro AVG .320 con +5. Se selecciona el primero para TRADE y se conserva el mejorado. También aparecen dos Will como cartas individuales.

**Implicación para el remake:** El inventario necesita identificar cada ejemplar por separado. Hoy specialOwned[id] agrupa la propiedad, un único nivel y un contador de copias; equipSpecialCard también impide equipar dos ejemplares del mismo id. Esa estructura no representa lo que se ve.

**Límite:** El servidor original es desconocido, pero la interfaz sí demuestra que las copias son distinguibles. Una futura migración debe conservar tanto la carta principal como sus duplicados, sin perder mejoras o estadísticas.

Evidencia: [10:23](reference_visual/explicando_20260924/frame-0623.jpg), [10:25](reference_visual/explicando_20260924/frame-0625.jpg).

Código: `src/com/bh/model/GameData.as:1630`, `src/com/bh/model/GameData.as:1640`, `src/com/bh/model/GameData.as:1818`.

### 3. ENHANCE llega a +5 y MAX cambia de precio

**Momento: 11:40–13:40.**

**Visible:** Malcolm A., B Hero, parte de AVG .316 y acaba en .366 con +5; el combo mostrado pasa de +2 a +3. Al alcanzar el máximo deja de estar disponible para mejorar. Para el estado +4, el panel ofrece +1 garantizado por 3 y MAX por 3 de moneda premium. En una pantalla anterior del proceso MAX mostraba 12.

**Implicación para el remake:** La mejora debe separarse de clase, grado y cargas. El límite actual de nivel 3 y la fórmula del remake requieren sustitución. El precio de MAX debe depender del estado: el valor 12 del análisis anterior no es universal.

**Límite:** En estas cartas Hero se confirma +5 y un aumento total de .050 de AVG. No se ha demostrado la misma tabla para todas las clases y grados. Se mantiene la restricción visible a Elite y Hero. La tasa de éxito con monedas sigue oculta.

Evidencia: [11:29](reference_visual/explicando_20260924/frame-0689.jpg), [13:06](reference_visual/explicando_20260924/frame-0786.jpg), [13:18](reference_visual/explicando_20260924/frame-0798.jpg), [13:40](reference_visual/explicando_20260924/frame-0820.jpg).

Código: `src/com/bh/model/GameData.as:1776`, `src/com/bh/model/GameData.as:1562`.

### 4. Una energía de carta por juego

**Momento: 15:17–15:18 y 17:10.**

**Visible:** El tooltip indica: «Especial energía de bateo. 1 energía por cada juego». Freddy aparece con 1/2 antes de jugar y con 0/2 durante el partido, antes del resultado final. Las agotadas muestran un contador y CHARGE.

**Implicación para el remake:** Ahora conocemos la unidad de consumo. No debe modelarse como energía por turno al bate, ni posponerse necesariamente hasta terminar el partido. Hace falta registrar el gasto una sola vez por carta y partido, conservándolo al guardar o reabrir.

**Límite:** El frame no distingue si el cargo exacto sucede al entrar al partido o al comenzar a usar la carta. Tampoco se muestra una recarga completa. El 0/2 durante el partido no debe desactivar retroactivamente la participación ya pagada de ese juego.

Evidencia: [15:18](reference_visual/explicando_20260924/frame-0918.jpg), [17:10](reference_visual/explicando_20260924/frame-1030.jpg).

Código: `src/com/bh/model/GameData.as:2011`, `src/com/bh/model/GameData.as:4336`.

### 5. WALK-OFF: cierre inmediato y celebración propia

**Momento: 07:57–08:20.**

**Visible:** Con el equipo local perdiendo 3–4 en la novena, un jonrón con bases llenas cambia el marcador a 7–4. Aparece WALK-OFF WIN con el héroe corriendo hacia sus compañeros y se pasa al resultado sin esperar otros outs.

**Implicación para el remake:** El código actual comprueba el final al cerrar medias entradas. Los flujos de bateo manual y simulación pueden avanzar al siguiente bateador después de la carrera ganadora. Hay que resolver el cierre tras la jugada, guardar el resultado una sola vez y reproducir una celebración específica.

**Límite:** La observación es de un jonrón decisivo. Al implementar también habrá que cubrir hit, base por bolas con bases llenas y compañero simulado, para que el cierre sea consistente. Es un hallazgo de revisión del código; no se ejecutó una prueba nueva del juego en esta tarea.

Evidencia: [08:10](reference_visual/explicando_20260924/frame-0490.jpg), [08:12](reference_visual/explicando_20260924/frame-0492.jpg).

Código: `src/com/bh/core/Game.as:1032`, `src/com/bh/core/Game.as:2598`, `src/com/bh/core/Game.as:3418`, `src/com/bh/game/HitCinematic.as:319`.

### 6. Roadmap con requisito y objetivos opcionales

**Momento: 14:14.**

**Visible:** GET TO DOUBLE-A! muestra el paso 4 OF 4. El requisito visible es completar una temporada de Clase A, con Mystery Box. Bajo Optional figuran siete cartas de recomendación de Double-A y Campeón del mundo, junto a una recompensa de 4.000 monedas.

**Implicación para el remake:** El Roadmap actual utiliza metas locales aproximadas de partidos, victorias y cartas. Esta captura permite reconstruir el paso mostrado con secciones de requisito y opcionales, además de referencias sociales.

**Límite:** Es el cuarto paso de cuatro, no todos los requisitos de ascenso. No demuestra que completar una temporada baste por sí solo ni que ganar un campeonato sea obligatorio. No sustituir toda la progresión a partir de una sola pantalla.

Evidencia: [14:14](reference_visual/explicando_20260924/frame-0854.jpg).

Código: `src/com/bh/model/GameData.as:3889`, `src/com/bh/model/GameData.as:4600`.

### 7. Hall of Fame abarca carrera, colección y actividades

**Momento: 10:43, 11:23–11:28 y 14:32–14:52.**

**Visible:** Se ven cuatro colores de trofeo con contadores sobre 35. Hay logros de amigos, jonrones, grand slams, RBI, hits, MVP, victorias, entradas extra, tipos de hit, bases por bola, compra/intercambio de cartas y actividad social. Mejor buscador y Maestro de intercambio entregan 4.000 monedas al alcanzar su hito de plata.

**Implicación para el remake:** Hace falta un catálogo de logros de carrera, contadores independientes de la temporada y recompensas reclamables una sola vez por nivel. Ya tenemos más objetivos y umbrales legibles para ese catálogo.

**Límite:** No se muestran los 35 objetivos ni todos sus premios. Los logros ligados a amigos, regalos y publicaciones necesitan una adaptación local explícita. El contador de intercambio avanza de 14 a 15 tras una operación: no asumir que sube tres por consumir tres cartas.

Evidencia: [10:43](reference_visual/explicando_20260924/frame-0643.jpg), [11:24](reference_visual/explicando_20260924/frame-0684.jpg), [14:34](reference_visual/explicando_20260924/frame-0874.jpg), [14:40](reference_visual/explicando_20260924/frame-0880.jpg).

Código: `src/com/bh/model/GameData.as:650`, `src/com/bh/ui/MissionsScreen.as`.

### 8. Misiones por margen y tipo de lanzamiento

**Momento: 14:10 y 18:50–19:00.**

**Visible:** Juego muy cerrado pide ganar dos juegos por una carrera y ofrece 750 monedas. Máximo bateador pide tres hits a cada una de tres familias de lanzamiento: bola quebrada, recta de cuatro costuras y rápida de dos costuras. Al completarlo, entrega 800 monedas por la misión.

**Implicación para el remake:** Los objetivos deben consultar resultados de partido y registrar el tipo de lanzamiento de cada hit. Las estadísticas actuales de hits/HR/RBI y las tres misiones iniciales no cubren esta información.

**Límite:** El botón premium para completar la primera misión muestra 39, pero no se utiliza. No se infiere una regla de precios para saltar todas las misiones. La traducción del video usa «cuerdas» para las costuras.

Evidencia: [14:10](reference_visual/explicando_20260924/frame-0850.jpg), [18:50](reference_visual/explicando_20260924/frame-1130.jpg).

Código: `src/com/bh/model/GameData.as:650`, `src/com/bh/model/MatchBoxScore.as`, `src/com/bh/core/Game.as:3006`.

### 9. Más evidencia del equipamiento y su vista previa

**Momento: 00:50 y 09:14–09:40.**

**Visible:** El bate equipado muestra 5 LEFT. En la tienda, PREVIEW cambia el bate del héroe y las barras de atributos. Hay equipo bloqueado por niveles 30, 50 y 70. El panel SKILL POINT muestra 473 mientras Contact/Power/Luck son 7, 60 y 406: ese total coincide con la suma de atributos.

**Implicación para el remake:** La vista previa de la versión 0.6.1 va en la dirección correcta. Falta el contador de bates consumibles, más siluetas y contenido, y acercar la presentación de los atributos. No se debe interpretar automáticamente 473 como puntos sin gastar.

**Límite:** No se ve el agotamiento completo de ese bate en este archivo; se mantiene pendiente qué acción consume cada unidad. La vista previa cambia estadísticas sin demostrar asignación manual de puntos. Tampoco hay un árbol completo de habilidades ni entrenamiento nuevo aquí.

Evidencia: [00:50](reference_visual/explicando_20260924/frame-0050.jpg), [09:22](reference_visual/explicando_20260924/frame-0562.jpg), [09:34](reference_visual/explicando_20260924/frame-0574.jpg).

Código: `src/com/bh/ui/EquipmentScreen.as`, `src/com/bh/model/GameData.as:344`.

### 10. El reclutamiento de amigos tenía beneficios definidos

**Momento: 10:39 y 11:11–11:14.**

**Visible:** La pantalla REGISTER vincula un amigo con un jugador. El texto describe tres beneficios: añadir el 5% del promedio de bateo del amigo, aumentar el límite de teamwork y acelerar el crecimiento del bateador.

**Implicación para el remake:** FriendCard solo dibuja la tarjeta. Un sistema local de compañeros CPU podría representar esos tres vínculos, además de sus fotos y estadísticas, sin depender de Facebook.

**Límite:** El texto no da el valor del aumento del límite ni la velocidad de crecimiento. Tampoco demuestra la fórmula final de AVG o sus topes. No copiar información de amigos reales ni simular que están conectados.

Evidencia: [10:39](reference_visual/explicando_20260924/frame-0639.jpg), [11:11](reference_visual/explicando_20260924/frame-0671.jpg).

Código: `src/com/bh/ui/FriendCard.as`, `src/com/bh/model/GameData.as:999`.

### 11. La promoción de slots no es el precio permanente

**Momento: 15:26–15:30.**

**Visible:** SPECIAL BATTER SLOT muestra tres espacios abiertos. El cuarto está en oferta de 56 a 36 con el cartel 10 MILLION USER SALES EVENT. También se ven iconos de clase bajo Special Batter Type.

**Implicación para el remake:** El precio base 56 que ya usa el remake coincide con el tachado. El descuento de este video pertenece a un evento; no debe reemplazar el precio permanente. Conviene reproducir el aviso de cupo al intentar añadir una cuarta carta.

**Límite:** La captura no demuestra una restricción de clase por slot ni sus costes de cambio. La narración automática de ese momento es ambigua. Tampoco se compra el cuarto espacio.

Evidencia: [15:30](reference_visual/explicando_20260924/frame-0930.jpg).

Código: `src/com/bh/model/GameData.as:1909`, `src/com/bh/ui/LineupScreen.as`.

## Algunos hitos legibles de Hall of Fame

| Logro | Contador | Hitos visibles | Momento |
|---|---|---|---|
| Equipo gigante | Amigos | 10 / 20 / 30 / 50 | 14:32 |
| Rey de jonrón | Jonrones | 100 / 200 / 450 / 900 | 14:34 |
| Bateador de gran poder | Grand slams | 10 / 30 / 60 / 100 | 14:34 |
| Bateador de oportunidad | RBI | 150 / 500 / 1000 / 1500 | 14:34 |
| Bateador de jit | Hits | 200 / 800 / 1800 / 3000 | 14:34 |
| El jugador más valioso | MVP | 50 / 100 / 200 / 400 | 14:34 |
| Mejor buscador | Cartas compradas | 20 / 40 / 80 / 150 | 14:40 |
| Maestro de intercambio | Intercambios; contador avanza una vez en la operación observada | 5 / 15 / 30 / 70 | 11:23 y 14:40 |
| Centro de noticia | Publicaciones | 10 / 20 / 50 / 100 | 14:40 |

Estos valores pertenecen a las pantallas observadas. No constituyen el catálogo completo ni una tabla completa de recompensas. Los logros sociales son referencias del original y requieren adaptación para uso local.

## Material local y verificaciones

- [Comparación visual](COMPARACION_EXPLICANDO.html), con siete fragmentos y capturas enlazadas.
- [Metadatos y hash del video](reference_visual/explicando_20260924/metadata.json).
- [Tiempos de los fragmentos](reference_visual/explicando_20260924/sequences.json).
- [Transcripción automática, sin corrección manual](reference_visual/explicando_20260924/transcript.auto.txt).
- [Hallazgos estructurados](reference_visual/explicando_20260924/findings.json).
- [Comparación anterior](COMPARACION_NUEVOS_GAMEPLAYS.html).

Se verifican las rutas de capturas y fragmentos y el hash del ejecutable contra revision_manifest.json. No se ejecutan nuevos tests del juego porque la entrega modifica documentación y referencias, no el motor. Los originales, la partida guardada y los cuatro sonidos activos se conservan.
