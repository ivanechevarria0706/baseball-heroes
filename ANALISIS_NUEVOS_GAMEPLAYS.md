# Qué aportan los dos nuevos gameplays

> Actualización con el tercer video: [TRADE, ENHANCE +5 y energía por juego](ANALISIS_GAMEPLAY_EXPLICANDO.md). La recomendación de gastar cargas solo al completar el partido se corrige: el contador ya baja durante el juego.

Revisión local del 24 de septiembre de 2026, contrastada con el código de la versión 0.6.1 (guardado v20).

Los videos permiten corregir varias aproximaciones del remake: usos y recarga de cartas, ENHANCE, entrenamiento con Mastery, cofres con llaves y la transición a postemporada. También documentan animaciones completas que faltan.

## Alcance de la revisión

- **Cigüeña**: 21:10.70, 640 × 360, 30 fps.
- **Primer lugar**: 13:34.80, 1280 × 720, 30 fps.
- Se revisaron visualmente capturas cada diez segundos a lo largo de ambos archivos y secuencias seleccionadas cada uno a cuatro segundos. No fue una reproducción continua ni una medición exhaustiva cuadro a cuadro.
- Se conservaron los originales y se guardaron siete fragmentos locales para consultar las transiciones. No se hizo una transcripción del audio.
- Este trabajo documenta diferencias: no modifica el ejecutable, la partida guardada ni los sonidos activos. Las capturas anteriores del remake están rotuladas con su versión.

## Próxima mejora recomendada

**Completar el ciclo de las cartas especiales: usos, recarga y ENHANCE.** La estructura clase × grado ya existe; estos videos muestran las reglas que todavía la separan del original. Es una mejora delimitada que afectaría al inventario, la alineación y los partidos sin reescribir el motor.

1. Guardar cargas y estado de recuperación por carta, además de sus copias y mejora. Descontar una vez por partido completado y validar el momento exacto de recuperación; cualquier regla no visible debe quedar marcada como reconstrucción.
2. Mostrar disponibilidad y CHARGE en LINE UP; impedir que una carta agotada siga actuando como disponible. Conservar cartas, alineación y mejoras existentes al migrar.
3. Sustituir la mejora por tres duplicados por el flujo ENHANCE observado, usando los costes comprobados solo donde corresponden. No inventar una probabilidad y presentarla como original.
4. Validar guardado/recarga, reabrir el juego durante el descanso, sustitución de agotadas y cobro único de cada intento.

Después: salón de entrenamiento y Mastery; calendario SPECIAL/RIVAL y cofres; postemporada jugable; cinemáticas completas y puntuación por evento. El arte sigue siendo una distancia importante, pero ahora también tenemos reglas de juego comprobables.

## Hallazgos con evidencia

### 1. Cartas: usos por partido y recarga

**Falta la mecánica · Primer lugar · 01:40 → 04:10 → 08:10**

**Original:** Las mismas cartas pasan de 2/2 a 1/2 tras un partido. Después del siguiente aparecen grises, con un contador de 2:56:30 y el botón CHARGE. El contador inferior representa usos; no es un contador de duplicados.

**Remake actual:** El remake guarda nivel, copias y estadísticas de bateo. Las cartas equipadas siguen disponibles sin descontar usos ni entrar en recarga.

**Cambio propuesto:** Separar cantidad poseída, mejora y cargas de cada carta. Persistir el momento de recuperación y reflejarlo en LINE UP, inventario y simulación.

**Pendiente de confirmar:** El tiempo visible está cerca de tres horas; no determina por sí solo cuándo comienza la recarga, si se recupera un uso o todos, ni el precio de CHARGE.

Evidencia: [primer_lugar-0100](reference_visual/gameplays_20260924/primer_lugar-0100.jpg), [primer_lugar-0250](reference_visual/gameplays_20260924/primer_lugar-0250.jpg), [primer_lugar-0490](reference_visual/gameplays_20260924/primer_lugar-0490.jpg).

Código: `src/com/bh/model/GameData.as:1630`, `src/com/bh/model/GameData.as:2011`, `src/com/bh/ui/SpecialBatterCardView.as:60`.

### 2. ENHANCE: pagar por mejorar una carta

**Regla actual diferente · Primer lugar · 12:38–13:12**

**Original:** El panel admite Elite y Hero. Para la carta B Hero mostrada ofrece +1 con monedas y probabilidad indicada como ?%, +1 garantizado con 3 de moneda premium y MAX garantizado con 12. El intento con monedas cuesta 2.500. Toby E. pasa de AVG .311 a .321 con +1 y más adelante aparece +2.

**Remake actual:** combineSpecialCard exige tres duplicados y aumenta el nivel, con máximo nivel 3. Esa regla no reproduce el panel del video.

**Cambio propuesto:** Rehacer ENHANCE alrededor de una carta seleccionada, intentos, nivel de mejora y coste; conservar las copias que el usuario ya tenga mediante una migración.

**Pendiente de confirmar:** Los valores observados corresponden a esa carta y ese estado. No conocemos la tabla completa de precios, el máximo de todas las clases ni la probabilidad real de éxito.

Evidencia: [primer_lugar-0760](reference_visual/gameplays_20260924/primer_lugar-0760.jpg), [primer_lugar-0780](reference_visual/gameplays_20260924/primer_lugar-0780.jpg).

Código: `src/com/bh/model/GameData.as:1776`.

### 3. Entrenadores, actividades y Mastery

**Sistema incompleto · Primer lugar · 00:25–01:04**

**Original:** RUNNING ofrece seis actividades de 1, 4, 8, 12, 24 y 48 horas. Se ve progreso Beginner → Expert → Pro y un premio de 2 SKILL POINT al superar un paso. Al elegir A correr mucho se muestran recompensas inmediatamente y luego el entrenador queda ON BREAK con 47:59:43.

**Remake actual:** Entrenar cuesta monedas y aumenta inmediatamente un atributo en 1, con +25 XP del jugador. No hay actividades por entrenador, Mastery ni descanso persistente.

**Cambio propuesto:** Crear el salón de entrenadores y reproducir el flujo observado: elegir actividad, animar/reconocer recompensas y progreso, mostrar premio de Mastery cuando proceda y dejar al entrenador en descanso.

**Pendiente de confirmar:** No debemos convertirlo sin más en una tarea que paga al terminar: el video muestra el premio antes del descanso. Solo RUNNING se abre; las reglas de las otras disciplinas y todos los umbrales siguen pendientes.

Evidencia: [primer_lugar-0030](reference_visual/gameplays_20260924/primer_lugar-0030.jpg), [primer_lugar-0050](reference_visual/gameplays_20260924/primer_lugar-0050.jpg), [primer_lugar-0061](reference_visual/gameplays_20260924/primer_lugar-0061.jpg).

Código: `src/com/bh/model/GameData.as:833`, `src/com/bh/model/GameData.as:845`, `src/com/bh/ui/TrainingScreen.as:177`.

### 4. Una postemporada jugable después del juego 30

**Falta el modo · Cigüeña · 20:00–20:30**

**Original:** Después del último partido de temporada se abre 6TH POST SEASON. Hay cuatro clasificados de N LEAGUE y cuatro de A LEAGUE. En ambos lados los cruces iniciales son 1.º contra 4.º y 2.º contra 3.º.

**Remake actual:** El juego marca playoffs si el equipo queda entre los cuatro primeros, pero termina la temporada. El botón POST SEASON está desactivado y el ascenso usa una regla aproximada de 18 victorias.

**Cambio propuesto:** Añadir un estado de postemporada guardable, cuadro de ocho equipos y navegación desde el cierre de temporada, reutilizando el motor de partido.

**Pendiente de confirmar:** Aquí solo se ve el cuadro inicial: no confirma si cada ronda es a un partido o una serie, ni los premios finales o la regla de ascenso.

Evidencia: [ciguena-1220](reference_visual/gameplays_20260924/ciguena-1220.jpg).

Código: `src/com/bh/ui/ModeSelectScreen.as:110`, `src/com/bh/model/GameData.as:4600`.

### 5. SPECIAL y RIVAL forman parte del calendario

**Falta la mecánica · Cigüeña · 04:00, 11:40 y 16:30**

**Original:** El juego 28 lleva SPECIAL: ganar entrega una Mystery Box y perder muestra 1.000 monedas. El juego 30 lleva RIVAL y se muestra un bono de 2.000 monedas por ganarlo. El partido SPECIAL también tiene presentación propia.

**Remake actual:** El calendario genera rivales y resultados. Muestra un icono RIVAL de forma genérica después del primer juego, pero no modela estos tipos de partido ni sus recompensas. SPECIAL MATCH está desactivado en el selector.

**Cambio propuesto:** Definir el tipo y recompensa en cada partido del calendario; usar la misma información en la tarjeta, la introducción y el resultado.

**Pendiente de confirmar:** Los juegos 28 y 30 son ejemplos de esta temporada grabada, no una prueba de que todas las temporadas usen exactamente esas posiciones.

Evidencia: [ciguena-0240](reference_visual/gameplays_20260924/ciguena-0240.jpg), [ciguena-0700](reference_visual/gameplays_20260924/ciguena-0700.jpg), [ciguena-0990](reference_visual/gameplays_20260924/ciguena-0990.jpg).

Código: `src/com/bh/ui/SeasonRoadmapScreen.as:160`, `src/com/bh/model/GameData.as:2625`, `src/com/bh/model/GameData.as:4485`.

### 6. Mystery Boxes guardadas y llaves

**Sistema incompleto · Primer lugar · 11:40–12:00; Cigüeña · 10:10–10:20**

**Original:** El inventario separa cofres y llaves. El cofre Rookie pide 2 llaves y el verde pide 3. Se ven cantidades almacenadas, apertura, selección visual del premio y COLLECT. Una apertura entrega C Pack.

**Remake actual:** Ya existe una recompensa llamada Mystery Box en el Roadmap, pero se entrega directamente al reclamar el objetivo. No hay inventario de cofres y llaves ni esta apertura.

**Cambio propuesto:** Guardar cofres y llaves, consumirlos una sola vez al abrir y ofrecer premios del catálogo mediante una pantalla de apertura.

**Pendiente de confirmar:** Los iconos muestran categorías de posibles premios; no revelan sus probabilidades. REQUEST FRIENDS es parte de la capa social original y necesitaría una alternativa local.

Evidencia: [primer_lugar-0700](reference_visual/gameplays_20260924/primer_lugar-0700.jpg), [primer_lugar-0710](reference_visual/gameplays_20260924/primer_lugar-0710.jpg), [primer_lugar-0720](reference_visual/gameplays_20260924/primer_lugar-0720.jpg).

Código: `src/com/bh/model/GameData.as:3895`, `src/com/bh/model/GameData.as:4140`, `src/com/bh/ui/RoadmapToMajorScreen.as:937`.

### 7. Bates consumibles y aviso de agotamiento

**Falta la mecánica · Primer lugar · 07:50**

**Original:** Aparece YOUR BAT HAS EXPIRED! y el mensaje This bat is a consumable item. Las ofertas visibles muestran Contact 400, Power 400 y Luck 400, con x5 y precio 12 de moneda premium.

**Remake actual:** Los bates son equipamiento permanente con bonificaciones pequeñas y sin campo de usos o caducidad. Hay consumibles de energía, pero eso no cubre el bate.

**Cambio propuesto:** Separar el bate base de los bates consumibles; mostrar existencias y agotamiento, y volver a un bate disponible sin bloquear el partido.

**Pendiente de confirmar:** La captura no demuestra qué consume una unidad ni la duración exacta. El valor 400 tampoco se puede copiar directamente al sistema actual, que limita atributos a 99.

Evidencia: [primer_lugar-0470](reference_visual/gameplays_20260924/primer_lugar-0470.jpg).

Código: `src/com/bh/model/GameData.as:254`, `src/com/bh/model/GameData.as:344`, `src/com/bh/model/GameData.as:3518`.

### 8. Jonrones con pequeñas historias animadas

**Fidelidad visual pendiente · Cigüeña · 02:54–03:05, 09:06–09:16 y 12:17–12:26**

**Original:** La pelota llega a una escena con dos extraterrestres y un panel; otra secuencia golpea un ave y deja plumas; una tercera muestra un extraterrestre morado. Luego aparecen HOME RUN, efectos, puntos y el regreso al campo. Los paneles azules pertenecen a la nave: no hay evidencia de un minijuego de elegir cartas.

**Remake actual:** HitCinematic sigue la pelota, presenta resultados y anima láminas de celebración, pero no tiene estas secuencias completas de personajes y cámara.

**Cambio propuesto:** Construir secuencias con varias poses y planos: vuelo, encuentro, impacto/reacción, explosión gráfica y regreso al estadio. Estos fragmentos sirven para medir el ritmo y las transiciones.

**Pendiente de confirmar:** No sabemos el criterio que elige cada escena. Las distancias de 1.370–1.763 ft que aparecen aquí son parte de la presentación fantástica y no deben tratarse como física real.

Evidencia: [ciguena-0176](reference_visual/gameplays_20260924/ciguena-0176.jpg), [ciguena-0549](reference_visual/gameplays_20260924/ciguena-0549.jpg), [ciguena-0740](reference_visual/gameplays_20260924/ciguena-0740.jpg).

Código: `src/com/bh/game/HitCinematic.as:140`, `src/com/bh/game/HitCinematic.as:319`.

### 9. Puntos por jugada, rachas y recompensas de resultado

**Sistema incompleto · Cigüeña · 03:50 y 09:12–09:15; Primer lugar · 04:50**

**Original:** Durante el partido aumentan puntos y combo, aparecen avisos de hits/jonrones consecutivos y multiplicadores. El resultado separa GAME, WINNER, MVP, RANK y BONUS, junto a una clasificación WEEKLY / ALL TIME.

**Remake actual:** Hay combo, avisos, rango de resultado y un recuadro SCORE. Sin embargo, SCORE se calcula con hits y RBI de temporada; el resultado solo desglosa monedas y XP. No es todavía el sistema de puntuación y bonificaciones del video.

**Cambio propuesto:** Usar un registro de puntos por evento y racha durante el partido, coherente entre HUD, simulación y resultado. Desglosar los premios y guardar récords locales.

**Pendiente de confirmar:** No podemos deducir una fórmula completa de estos ejemplos, ni reproducir los rankings reales de Facebook sin sus datos.

Evidencia: [ciguena-0230](reference_visual/gameplays_20260924/ciguena-0230.jpg), [ciguena-0552](reference_visual/gameplays_20260924/ciguena-0552.jpg), [primer_lugar-0290](reference_visual/gameplays_20260924/primer_lugar-0290.jpg).

Código: `src/com/bh/ui/Hud.as:179`, `src/com/bh/ui/TeamSimulationPanel.as:141`, `src/com/bh/ui/GameResultPanel.as:96`, `src/com/bh/ui/GameResultPanel.as:122`.

### 10. Hall of Fame y misiones de rendimiento

**Falta ampliar el sistema · Cigüeña · 13:40; Primer lugar · 11:00**

**Original:** Hall of Fame muestra Bateador del triple, con hitos 50, 150, 300 y 500; el primer premio visible es 2.000 monedas. También se completa Hit múltiple: más de dos hits sencillos en un juego, repetido tres veces, con premio visible de 820 monedas.

**Remake actual:** Ya hay misiones y metas de temporada, pero el catálogo de misiones se centra en estadio, entrenamiento y reclutamiento. No existe este Hall of Fame de hitos de carrera.

**Cambio propuesto:** Añadir contadores persistentes de carrera y objetivos de partido, avisos durante la jugada y reclamación única de premios por hito.

**Pendiente de confirmar:** Solo se conocen las metas y premios que aparecen en pantalla, no el catálogo completo.

Evidencia: [ciguena-0820](reference_visual/gameplays_20260924/ciguena-0820.jpg), [primer_lugar-0660](reference_visual/gameplays_20260924/primer_lugar-0660.jpg).

Código: `src/com/bh/model/GameData.as:650`, `src/com/bh/ui/MissionsScreen.as`, `src/com/bh/ui/MissionCompleteOverlay.as`.

### 11. HOME, inventario y el equipo sobre el campo

**Fidelidad visual pendiente · Primer lugar · 11:30–13:32; Cigüeña · 10:30**

**Original:** Los jugadores de la alineación están colocados en el campo. SHOP e INVENTORY abren paneles sobre HOME dejando al héroe visible. La franja inferior contiene amigos con foto y estadísticas. FACE se divide en Shape, Hair, Eyes, Nose, Mouth y Etc.

**Remake actual:** La versión 0.6.1 ya usa un héroe frontal ilustrado y vista previa de equipamiento. Los menús y la composición de HOME todavía son distintos; tampoco hay un sistema social equivalente.

**Cambio propuesto:** Acercar la distribución de HOME, mantener el héroe visible al abrir inventario y ampliar variantes reales de rostro, pelo y equipo. Para amigos, utilizar perfiles CPU identificados como locales.

**Pendiente de confirmar:** Los videos no permiten recuperar personajes como capas transparentes ni los datos de los amigos originales. Las capturas de la versión 0.6.1 sirven como comparación, no como nuevas pruebas de ejecución.

Evidencia: [primer_lugar-0690](reference_visual/gameplays_20260924/primer_lugar-0690.jpg), [primer_lugar-0700](reference_visual/gameplays_20260924/primer_lugar-0700.jpg), [ciguena-0630](reference_visual/gameplays_20260924/ciguena-0630.jpg).

Código: `src/com/bh/game/HomeHero.as`, `src/com/bh/visual/HomeSprite.as`, `src/com/bh/ui/EquipmentScreen.as`, `src/com/bh/ui/FriendCard.as`.

## Datos que sí se pueden transcribir del entrenamiento

Pantalla RUNNING en Primer lugar 00:30. Conservamos los nombres de los iconos para no confundir maestría, XP y atributos. La estrella azul de +160 coincide con el incremento visible de XP de 13.590 a 13.750 al seleccionar la actividad de 48 horas.

| Actividad | Tiempo mostrado | Monedas | Icono Running | Estrella azul |
|---|---:|---:|---:|---:|
| 30 yardas | 1 h | 90 | 60 | 16 |
| 100 metros | 4 h | 250 | 150 | 40 |
| Carrera de 1 milla | 8 h | 400 | 225 | 60 |
| Sliding | 12 h | 550 | 300 | 80 |
| Máquina de correr | 24 h | 1000 | 480 | 128 |
| A correr mucho | 48 h | 1250 | 600 | 160 |

Se ve 1245/1350 antes de la actividad, premio de 2 SKILL POINT al superar el paso y STEP 6 después. Esto no revela todos los umbrales. La secuencia muestra el premio antes de ON BREAK: reproducir ese orden, en lugar de asumir que las 48 horas se esperan antes de recibirlo.

## Otras diferencias y límites de la evidencia

- LINE UP muestra flechas de estado de distintos colores y barras con nivel para jugadores normales (Primer lugar 01:40 y 04:10). El remake dibuja una barra de rating. Se debe investigar cómo cambia ese estado y qué efecto tiene; no equipararlo automáticamente a stamina.
- La misma carta Will aparece dos veces en la alineación original. Antes de impedir duplicados o agruparlos por id, hay que distinguir copias individuales, cargas y slots; el video no revela el modelo interno del servidor.
- Se ve REVERSAL CHANCE! en Cigüeña 18:20. Confirma un aviso contextual, pero no prueba por sí solo que modifique probabilidades.
- Los dos archivos están codificados en 16:9 y muestran una composición ancha. No prueban que todas las versiones originales fueran exclusivamente 4:3 ni que esta grabación conserve las proporciones originales. No cambiar otra vez el tamaño del remake basándose solo en la resolución del video.
- Las escenas del ave y los extraterrestres son variantes de jonrón, no evidencia de un nuevo modo o minijuego. Las distancias exageradas pertenecen al estilo arcade.
- No aparecen partidas completas de POST SEASON, ALL STAR o WORLD MATCH. Tampoco un árbol completo de habilidades ni todos los entrenadores. Esos apartados no quedan documentados por estos dos videos.
- Las fuentes y siluetas originales siguen sin recuperarse como archivos editables. El video de 720p permite estudiar poses, proporciones y transiciones, pero no es una hoja de sprites con transparencia.

## Material guardado

- [Comparación visual con fragmentos](COMPARACION_NUEVOS_GAMEPLAYS.html).
- [Metadatos y hashes de los videos](reference_visual/gameplays_20260924/metadata.json).
- [Índice de fragmentos y tiempos de origen](reference_visual/gameplays_20260924/sequences.json).
- [Hallazgos estructurados](reference_visual/gameplays_20260924/findings.json).
- Hojas de contacto `ciguena-overview-00.jpg` a `06.jpg` y `primer_lugar-overview-00.jpg` a `04.jpg`, más secuencias `detail-*.jpg` en la misma carpeta.

Los fragmentos se usan como referencias locales; no se han integrado como animaciones ni audio del juego.
