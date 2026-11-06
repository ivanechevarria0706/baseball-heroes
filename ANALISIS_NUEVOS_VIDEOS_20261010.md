# Nuevos gameplays · revisión frente a Web 0.9.5

[Comparación con videos y capturas](COMPARACION_NUEVOS_VIDEOS_20261010.html)

Revisión visual del 10 de octubre de 2026. Se recorrieron ambos clips con láminas cada cinco segundos y se inspeccionaron cuadros adicionales de los momentos relevantes. Los tiempos son aproximados; el segundo archivo tiene cadencia media de 29.953 fps. No se validó el audio para incorporarlo al juego. Este análisis no modifica ni publica una nueva versión.

## Material

| Alias | Archivo del usuario | Duración | Resolución |
|---|---|---:|---:|
| video1 | videoplayback.mp4 | 3:07.33 | 656×480 |
| video2 | 30).mp4 | 2:48.87 | 488×360 |

Los originales se conservaron sin modificación en `reference_visual/nuevos_20261010/video1.mp4` y `video2.mp4`, con SHA256 y metadatos en `metadata.json`. Sus fotogramas son referencias de análisis; no se añadieron al paquete del juego.

## Hallazgos comprobados

“Ausente” significa que falta ese sistema. “Parcial” significa que existe una base o una interfaz, pero no reproduce el comportamiento observado. No son doce modos nuevos: la mayoría son diferencias de sistemas ya existentes.

### 1. Combo que se acumula durante el partido · Parcial · prioridad alta

**En el original:** El indicador inferior cambia de estado durante la simulación, junto a avisos +1 y +2. En el tramo final se ve un medidor naranja/rojo y brillo bajo los pies del héroe. No es solo una cifra de la alineación.

**En 0.9.5:** Los +1/+2 ya se dibujan, pero no alimentan un estado del partido: specialCombo(true) devuelve la suma de combo de las cartas reservadas. El aro se calcula con esa suma fija. Falta la acumulación y la transición entre estados observada.

**Trabajo pendiente:** Separar el bonus de las cartas del medidor de partido y registrar ganancias/cambios por jugada. Medir después los umbrales antes de fijar una tabla histórica.

**Lo que aún no sabemos:** No se conoce el umbral de cada color, la regla completa de gasto ni qué efectos garantiza. La proximidad del brillo y el home run no demuestra un home run automático.

**Evidencia:** video1 00:50 (Simulación: +2 y medidor azul), video1 02:27 (Medidor naranja/rojo durante la simulación), video1 02:33 (Brillo en el turno del héroe).

**Código contrastado:** `src/com/bh/model/GameData.as:2096`, `src/com/bh/ui/Hud.as:163`, `src/com/bh/ui/TeamSimulationPanel.as:170`.

### 2. COMEBACK CHANCE y efectos del golpe · Parcial · prioridad alta

**En el original:** Con Texas perdiendo 0–4 en la quinta, aparece COMEBACK CHANCE! antes del lanzamiento. Después se ve LUCKY HIT con destellos y un trébol junto al bate.

**En 0.9.5:** CLUTCH ofrece un bonus local en situaciones finales y LUCKY HIT ya existe. No hay una secuencia COMEBACK CHANCE. Lucky Hit se anuncia después de resolver el hit, con una condición local de suerte; falta reproducir el efecto y determinar su relación real con la situación del partido.

**Trabajo pendiente:** Añadir el estado y anuncio de oportunidad sin atribuirle una garantía no observada; completar destellos y trébol conservando la cabeza aprobada.

**Lo que aún no sabemos:** Un ejemplo no prueba que todo 0–4 active la oportunidad ni que esta garantice hit. SUPER HITTER es texto visible del bate; no se cuenta como otra habilidad confirmada.

**Evidencia:** video2 01:40 (0–4, quinta entrada: COMEBACK CHANCE!), video2 01:42 (LUCKY HIT durante el swing).

**Código contrastado:** `src/com/bh/model/GameData.as:2224`, `src/com/bh/core/Game.as:2995`.

### 3. SPECIAL MATCH dentro de la temporada · Parcial · prioridad alta

**En el original:** El juego 12 de la primera temporada ROOKIE tiene insignia SPECIAL. Tras perder 2–4, se abre SPECIAL MATCH BONUS: Mystery Box bajo WIN y 500 COINS bajo LOSE; la recompensa recibida es 500 monedas.

**En 0.9.5:** Hay etiquetas de calendario y Mystery Boxes, pero el evento local está fijo en el juego 28, solo entrega caja al ganar y no implementa este panel/bono por derrota. SPECIAL MATCH sigue desactivado en el selector. La variable specialMatch del código reserva cartas y bate: no es un modo SPECIAL jugable.

**Trabajo pendiente:** Modelar el evento por fixture, su introducción y liquidación única por victoria/derrota, reutilizando el motor y el inventario de cajas.

**Lo que aún no sabemos:** No se gana en este ejemplo: la caja de victoria se confirma como oferta de la interfaz, no como entrega realizada. El juego 12 no demuestra una periodicidad universal de eventos.

**Evidencia:** video2 00:05 (Calendario: juego 12 marcado SPECIAL), video2 00:21 (Introducción del partido especial), video2 02:30 (Derrota: bono de 500 monedas).

**Código contrastado:** `src/com/bh/model/GameData.as:695`, `src/com/bh/model/MysteryInventory.as:35`, `src/com/bh/ui/ModeSelectScreen.as:127`.

### 4. Energía general: coste y recarga por tiempo · Parcial · prioridad alta

**En el original:** En video1 se pasa de 12 a 7 al entrar. En video2 se pasa de 5 a 0 y LINEUP dice “You need 5 Energy to start the ball game”. La barra muestra un contador hasta la siguiente unidad y “Full in”. Video1 muestra 12/17, siguiente unidad 3:11 y llenado 23:11: la diferencia implica intervalos de cinco minutos.

**En 0.9.5:** El inicio admite energía >0 y reserveMatchCards hace energy--. No hay reloj de recuperación de la energía general del usuario; los relojes de compañeros y cartas son sistemas separados. La cuenta nueva empieza con capacidad local 25.

**Trabajo pendiente:** Centralizar coste de 5 y recuperación persistente, con comprobación antes de pagar y reentrada sin doble cargo. La capacidad inicial requiere referencia adicional; no cambiarla por extrapolar dos niveles.

**Lo que aún no sabemos:** El intervalo de cinco minutos se deduce de las dos cifras de la interfaz, no de esperar una recarga completa sin cortes. No se conoce todavía la curva de capacidad desde nivel 1 ni la política original al cerrar el juego.

**Evidencia:** video1 00:00 (12 de energía, próxima unidad 3:11, Full in 23:11), video1 00:05 (Tooltip: 12/17), video1 00:24 (Inicio: 7 de energía), video2 00:14 (LINEUP: se requieren 5 de energía).

**Código contrastado:** `src/com/bh/model/GameData.as:4373`, `src/com/bh/model/GameData.as:4404`, `src/com/bh/model/GameData.as:18`.

### 5. Subida de nivel: desbloqueos concretos y llenado · Parcial · prioridad alta

**En el original:** El paso de nivel 3 a 4 muestra “6 NEW GEARS UNLOCKED”, tres cinturones Basic 1/2/3 como vista, 1 SKILL POINT, 2000 COINS y 1 MAX ENERGY. La barra pasa de 0 durante el partido a 13 al terminar.

**En 0.9.5:** Ya se entregan 2,000 monedas, un punto y +1 de capacidad por nivel. El resumen siempre devuelve unlocked:[] y la energía solo aumenta en el incremento de capacidad; falta la lista real de desbloqueos y reproducir el llenado mostrado. Parte del catálogo sí tiene puertas por nivel 5/15/25 y 30/50/70.

**Trabajo pendiente:** Conectar el resumen con las puertas reales del catálogo, usar miniaturas de los objetos y revisar el llenado por nivel con esta evidencia.

**Lo que aún no sabemos:** Los seis artículos no se ven completos: se enseñan tres cinturones, no seis identidades comprobadas. El llenado coincide con subir de nivel en esta secuencia; no confirma una regla general para todos los niveles ni todos los eventos.

**Evidencia:** video2 02:21 (Final del partido: energía 0), video2 02:34 (Nivel 4: desbloqueos y premios; energía 13).

**Código contrastado:** `src/com/bh/model/GameData.as:2724`, `src/com/bh/model/GameData.as:2793`, `src/com/bh/ui/LevelUpOverlay.as:98`.

### 6. LEADERBOARD semanal e histórico con marcas · Ausente · prioridad alta

**En el original:** Al lado del resultado se despliega un panel WEEKLY / ALL TIME, cuenta atrás semanal, marcas de puntuación con premios, nombres de amigos, MY BEST SCORE y SCORE. Video1 termina con 520,710 puntos, mejor marca 608,589; video2 con 105,217, mejor marca 583,264.

**En 0.9.5:** El HUD tiene la palabra LEADERBOARD y el marcador vivo. GameResultPanel no contiene este panel, ni una marca personal persistente, ni ranking semanal/histórico por puntos. Las posiciones de una liga privada no sustituyen esta clasificación de puntuaciones.

**Trabajo pendiente:** Guardar mejor puntuación y resultados por período; construir el panel y después la clasificación privada entre cuentas aceptadas.

**Lo que aún no sabemos:** No se ve cobrar una recompensa del ranking ni cambiar de pestaña. Las escalas de ambos videos difieren: no fijar una tabla universal a partir de una sola vista. Para amigos reales debe ser un resultado persistente del servidor con envíos idempotentes.

**Evidencia:** video1 03:06 (WEEKLY / ALL TIME y marcas de puntuación), video2 02:36 (Otro tablero y otra escala de marcas).

**Código contrastado:** `src/com/bh/ui/Hud.as:140`, `src/com/bh/ui/GameResultPanel.as:99`.

### 7. Rachas y multiplicador observado ×3 · Parcial · prioridad media

**En el original:** Tras el sencillo anterior, el doble del héroe muestra “2 Consecutive Base Hits!” y ×3 sobre la pelota, con monedas animadas.

**En 0.9.5:** MatchScoring ya guarda rachas y HitCinematic las anuncia. Para el segundo hit que no es home run, la fórmula local devuelve multiplicador 1. No reproduce el ×3 mostrado para dos hits consecutivos.

**Trabajo pendiente:** Separar el multiplicador mostrado de las recompensas hasta medir a qué cantidades se aplica; conservar registro de cada jugada y liquidación única.

**Lo que aún no sabemos:** La escena no prueba si ×3 multiplica monedas, puntuación o ambos. Tampoco revela toda la tabla de rachas ni los umbrales de RANK S/A/B/C. No convertir una observación en una fórmula completa.

**Evidencia:** video2 01:25 (Primer sencillo de esta racha), video2 01:46 (Segundo hit: TWO BASE HIT, ×3 y aviso de racha).

**Código contrastado:** `src/com/bh/model/MatchScoring.as:11`, `src/com/bh/game/HitCinematic.as:146`.

### 8. Monedas y XP visibles durante las jugadas · Parcial · prioridad media

**En el original:** Antes de terminar video1, XP/monedas cambian de 3,376/14,479 a 3,379/14,486 y más adelante a 3,400/14,540. Los puntos azules de la jugada aparecen cerca del marcador. Al final se animan GAME, WINNER, MVP, RANK y BONUS.

**En 0.9.5:** Los puntos por jugada y las cinco categorías finales ya existen. Monedas y XP de temporada se abonan al completar el partido; la barra no presenta las ganancias intermedias como el original.

**Trabajo pendiente:** Mantener un libro de jugadas y reflejar provisionalmente monedas/XP, conciliándolos una vez al finalizar o reanudar.

**Lo que aún no sabemos:** No basta para reconstruir el premio de cada out/hit o la fórmula del resultado. No sumar un premio nuevo encima del actual sin separar ganancias provisionales y finales.

**Evidencia:** video1 00:00 (Antes: XP 3,376 y monedas 14,479), video1 00:50 (Durante: XP 3,379 y monedas 14,486), video1 02:33 (Durante: XP 3,400 y monedas 14,540), video1 03:04 (Cinco categorías del resultado).

**Código contrastado:** `src/com/bh/core/Game.as:3524`, `src/com/bh/model/GameData.as:4539`, `src/com/bh/model/MatchScoring.as:19`.

### 9. Repertorio de ROOKIE y nombres de lanzamiento · Parcial · prioridad media

**En el original:** Los dos videos están en ROOKIE. Se leen 2-Seam FB y 4-Seam FB, con velocidades visibles de 76–86 mph en las capturas seleccionadas. Video1 también aporta un hit contado para una misión de bolas quebradas.

**En 0.9.5:** Hay seis familias y calibración de vuelo; el repertorio de ROOKIE se limita a FASTBALL/CHANGEUP. SINKER se añade recién desde liga 3. Los rótulos usan identificadores internos como FASTBALL; falta ajustar repertorio y denominaciones al original.

**Trabajo pendiente:** Separar nombres originales, familia estadística y trayectoria; permitir los lanzamientos documentados en ROOKIE y ampliar la muestra de tiempos.

**Lo que aún no sabemos:** No equiparar automáticamente todo 2-Seam FB con el SINKER local ni toda bola quebrada con una única curva. Estos videos no demuestran slider/cutter ni todas las velocidades. Hace falta medir cuadros antes de cambiar trayectorias o probabilidades.

**Evidencia:** video2 00:30 (2-Seam FB y EARLY SWING), video2 00:36 (4-Seam FB y LATE SWING), video1 01:36 (2-Seam FB a 76 mph), video1 01:51 (Progreso de misión para bolas quebradas).

**Código contrastado:** `src/com/bh/model/GameData.as:2600`, `src/com/bh/core/Game.as:2222`, `src/com/bh/core/Game.as:2681`.

### 10. Defensa y carrera en viñetas de OUT · Parcial · prioridad alta visual

**En el original:** Se encadenan pelota, recogida/tiro del defensor y una viñeta diagonal: defensor arriba, piernas y base abajo, con sello OUT. El fly out tiene una captura en salto. Minimap y distancia siguen visibles durante la escena.

**En 0.9.5:** HitCinematic ya mueve pelota, defensor y corredor. Aún emplea el actor Pitcher para la defensa y una escena continua; falta la composición diagonal y los sprites específicos de recepción, llegada a base y resolución OUT.

**Trabajo pendiente:** Completar las escenas y poses con el resultado existente, manteniendo sincronizados minimapa y actor. Conservar BatterHead086.

**Lo que aún no sabemos:** La escena presenta un resultado ya decidido: no demuestra un minijuego de carrera ni control manual del corredor. Las distancias no permiten deducir una regla física de hit/out.

**Evidencia:** video1 01:15 (Preparación del tiro), video1 01:17 (Defensor y llegada a la base en viñeta), video1 02:19 (Sello OUT), video2 02:10 (Fly out: captura en salto).

**Código contrastado:** `src/com/bh/game/HitCinematic.as:69`, `src/com/bh/game/HitCinematic.as:148`.

### 11. Logros en vivo y consejos de la asistente · Parcial · prioridad media

**En el original:** Aparecen barras de progreso sobre el pie del partido: Mr. Single 15/150, Hardworking Hitter 50/500 y Lucky Hitter 2/25. La asistente informa “2 Consecutive Base Hits!” y aconseja aumentar puntos de habilidad para mejorar el combo.

**En 0.9.5:** Hay Hall of Fame, misiones por tipo de lanzamiento y rachas. El catálogo no tiene Hardworking Hitter ni Lucky Hitter y el HUD no muestra estas barras ni la asistente contextual durante la jugada; los objetivos se concilian al cerrar el partido.

**Trabajo pendiente:** Añadir avisos no bloqueantes usando progreso provisional; completar los dos logros solo cuando se defina su criterio con evidencia, y conectar consejos a eventos ya conocidos.

**Lo que aún no sabemos:** No se ve la descripción de esos dos logros: 50/500 y 2/25 son progreso/objetivo mostrado, no una demostración del evento que los cuenta ni del premio. Mr. Single parece corresponder al sencillo ya registrado, pero no prueba igualdad de toda su tabla.

**Evidencia:** video2 01:30 (Mr. Single: 15/150), video2 01:44 (Hardworking Hitter: 50/500), video2 01:46 (Lucky Hitter: 2/25 y asistente), video1 01:20 (Consejo en español sobre habilidad y combo).

**Código contrastado:** `src/com/bh/model/CareerAchievements.as:5`, `src/com/bh/ui/Hud.as:184`, `src/com/bh/game/HitCinematic.as:146`.

### 12. Proporciones, cámara, traje y home run · Parcial · prioridad alta visual

**En el original:** El bate ocupa una parte grande de la silueta, el casco y cuerpo mantienen contornos coherentes, los defensores conservan sus poses propias y la cámara cambia al seguir la pelota. Video1 incluye un home run con personaje morado y consola; video2 enseña HOME, viaje y LINEUP con el mismo estilo.

**En 0.9.5:** Existen cuerpo animado, equipamiento, estadios, viaje, LINEUP y tres historias de home run, incluida la variante de fantasma. La cámara, perspectiva, contornos, ropa de espalda, poses y acabado de paneles aún difieren. Las historias HR tienen solo cuatro poses por variante y cámara interpolada.

**Trabajo pendiente:** Usar estas escenas para ajustar escala/ángulo del bate, articulación del cuerpo, ropa trasera y cámaras antes de añadir más variantes.

**Lo que aún no sabemos:** No falta inventar el fantasma: ya está reconstruido. Estas referencias son de baja resolución y no proporcionan una hoja de animación completa. El trabajo visual debe conservar la cabeza 0.8.6 aprobada y centrarse en cuerpo, atuendo y composición.

**Evidencia:** video1 00:30 (Silueta del bateador y perspectiva del partido), video1 02:20 (Home run: personaje morado y consola), video2 00:00 (HOME), video2 00:14 (LINEUP).

**Código contrastado:** `src/com/bh/visual/HomeRunStory.as:4`, `src/com/bh/visual/CostumeArtwork.as:4`, `src/com/bh/visual/BatterHead086.as:5`.

## Ya existe y no debe rehacerse

- Temporada, mapa/viaje, alineación con suplentes, simulación y velocidades, historial de bateo, marcador por entradas y estadísticas individuales.
- Puntos durante el partido, rachas y categorías GAME / WINNER / MVP / RANK / BONUS; faltan correspondencias con las reglas y la clasificación observadas.
- LUCKY HIT, CLUTCH, Mystery Boxes, postemporada, bates consumibles y equipo visible; las diferencias concretas están arriba.
- Recompensas de 2,000 monedas, un punto de habilidad y +1 capacidad por nivel.
- Misiones de familias de lanzamiento, Hall of Fame y vínculos con amigos; no todo lo que aparece es un sistema ausente.
- Historias de home run con variantes de ave/personaje/consola: la escena morada aporta referencia para pulirlas.

## Orden de implementación propuesto

1. Combo dinámico y oportunidad de remontada: cambian la sensación y el desarrollo del partido.
2. Energía general y resumen de nivel: reglas observables, recarga persistente y desbloqueos reales.
3. SPECIAL MATCH en la temporada: introducción y premio de victoria/derrota sin duplicación.
4. Mejor puntuación y LEADERBOARD semanal/histórico entre amigos.
5. Viñetas de OUT, cuerpos/ropa/cámara, avisos de progreso, rachas y recompensas provisionales.

La cabeza aprobada 0.8.6, el inicio en nivel 1 / ROOKIE y el registro sin invitación siguen siendo restricciones del proyecto. No se reactivaron audios con narración. Las probabilidades, precios o requisitos que estos clips no muestran permanecen sin validar.

## Qué no documentan estos archivos

No abren ALL STAR, WORLD MATCH, tienda completa, entrenamiento, un árbol de habilidades completo ni la creación de cuenta/personaje. No permiten concluir que esos apartados ya coincidan con el original. Tampoco revelan fórmulas del servidor o toda la tabla de recompensas.

## Reproducibilidad

Base auditada: Web 0.9.5, build `fde4ccdb2fbc3f76`, guardado 21.
Metadatos, hashes, hallazgos, timecodes, capturas y referencias de código se guardan en `reference_visual/nuevos_20261010/audit.json`. Scripts de extracción/documentación: `research/analyze_new_videos1010.py`, `research/detail_new_videos1010.py` y `research/document_new_videos1010.py`.
