# Nuevos gameplays: inicio y eliminatorias

Revisado el 12 de octubre de 2026 contra el código de **0.10.4**. Referencias entregadas el 11 de octubre. Solo análisis: no se cambia el juego ni se publica una versión.

## Fuentes y método

Muestreo completo cada 5 s, inspección de diez planchas generales y doce planchas de detalle con 92 capturas seleccionadas. Se preservaron copias de los dos MP4 con SHA-256 idéntico. Análisis visual; no se transcribió ni integró audio.

| Archivo | Duración | Resolución | FPS | SHA-256 |
| --- | --- | --- | --- | --- |
| videoplayback (4).mp4 | 6:41 | 638×480 | 11.011 | 5e68f67bc3683da1f09dee2b13e3767fa44e25b33b2b1d6ef6143aa2adae3a20 |
| baseball heroes eliminatorias final de la liga.mp4 | 7:39 | 1280×720 | 10.0 | 4c591604e39579a9701581afba268b985a8dc2aedc70f7a286d02226667544ff |

La capacidad máxima inicial no se deduce del número 20 mostrado. Los rótulos y premios observados no se convierten automáticamente en fórmulas universales. El narrador y la marca de grabación no son recursos del juego.

## Diferencias comprobadas

### 1. Metas de temporada: HIT + RBI

**Corrección confirmada · Prioridad Alta.**

**Se ve:** El sorteo de ROOKIE termina en 70 HIT y 55 RBI. En TRIPLE-A se ven 120/120 HIT y 100/100 RBI, ambos completados.

**En 0.10.4:** SeasonGoalScreen muestra HR y RBI. LobbyScreen y Hud cuentan seasonHomeRuns para la primera meta. La diferencia afecta al objetivo y al progreso, además de su rótulo.

**Siguiente cambio:** Introducir una meta de hits con su propio contador y migración explícita; conservar las metas y premios que ya tengan las carreras existentes.

**Límite de la evidencia:** 70/55 es un resultado del sorteo observado, no un objetivo fijo para todas las cuentas. No se observa la distribución completa del sorteo.

**Capturas:** [video3 01:50](reference_visual/nuevos_20261011/video3/game-0110.jpg), [final 00:43](reference_visual/nuevos_20261011/final/game-0043.jpg)

**Código contrastado:** [src/com/bh/ui/SeasonGoalScreen.as:175](src/com/bh/ui/SeasonGoalScreen.as), [src/com/bh/ui/LobbyScreen.as:340](src/com/bh/ui/LobbyScreen.as), [src/com/bh/ui/Hud.as:196](src/com/bh/ui/Hud.as)

### 2. Entrenamiento con varios entrenadores

**Sistema incompleto · Prioridad Alta.**

**Se ve:** La sala muestra cinco puestos: RUNNING, STRETCHING, LIFTING, un cuarto de icono rosa y un quinto en silueta. Se abren STRETCHING y LIFTING, cada uno con seis actividades. Los descansos de los dos primeros entrenadores se muestran a la vez.

**En 0.10.4:** RunningTrainingRoom solo permite abrir RUNNING y un panel ATTRIBUTES. Los demás personajes del fondo no tienen sus propios catálogos ni relojes de entrenador.

**Siguiente cambio:** Añadir STRETCHING y LIFTING como disciplinas persistentes independientes, con sus actividades, animaciones y descanso. Mantener el cuarto y quinto pendientes de identificación.

**Límite de la evidencia:** El nombre del cuarto puesto y las condiciones de desbloqueo del quinto no se leen en este video. No atribuirles una disciplina inventada.

**Capturas:** [final 00:12](reference_visual/nuevos_20261011/final/game-0012.jpg), [final 00:33](reference_visual/nuevos_20261011/final/game-0033.jpg), [final 00:39](reference_visual/nuevos_20261011/final/game-0039.jpg)

**Código contrastado:** [src/com/bh/ui/RunningTrainingRoom.as:27](src/com/bh/ui/RunningTrainingRoom.as), [src/com/bh/model/GameData.as:933](src/com/bh/model/GameData.as)

### 3. MASTER y premio de 5 ENERGY

**Falta completar · Prioridad Alta.**

**Se ve:** STRETCHING MASTERY y RUNNING MASTERY muestran Beginner, Expert y Pro con cuatro estrellas por tramo. Cada panel ofrece 5 ENERGY. La barra cambia 17 → 22 → 27. Tras entrenar sigue ON BREAK cerca de 48 horas, incluso con MASTER.

**En 0.10.4:** RUNNING usa pasos sin límite por bloques de 1350, concede dos SKILL POINTS por paso y muestra Beginner hasta el paso 5, Expert hasta el 10. No hay tope MASTER ni recompensa final de energía.

**Siguiente cambio:** Separar experiencia de disciplina, escalones y recompensa final cobrada una sola vez. MASTER debe seguir permitiendo entrenar y respetar el descanso observado.

**Límite de la evidencia:** Se ven 615/1125 en STRETCHING y 3090/3600 en LIFTING. No son una curva completa. Las dos selecciones de 48 h cuestan 1800 aquí; no se demuestra que RUNNING cueste igual en todos los niveles.

**Capturas:** [final 00:19](reference_visual/nuevos_20261011/final/game-0019.jpg), [final 00:30](reference_visual/nuevos_20261011/final/game-0030.jpg), [final 00:21](reference_visual/nuevos_20261011/final/game-0021.jpg)

**Código contrastado:** [src/com/bh/model/GameData.as:962](src/com/bh/model/GameData.as), [src/com/bh/model/GameData.as:979](src/com/bh/model/GameData.as), [src/com/bh/ui/RunningTrainingRoom.as:105](src/com/bh/ui/RunningTrainingRoom.as)

### 4. Tutorial guiado de cartas y primer partido

**Flujo parcial · Prioridad Alta.**

**Se ve:** El entrenador guía BATTER SHOP → C PACK → abrir sobre → carta → cerrar → arrastrar sustituto y ordenar → PLAY. Luego pausa para explicar strikes, Combo y MAX. Al volver a HOME enseña el punto de estadística y cómo cerrar el panel.

**En 0.10.4:** Existe el recorrido equipo/personaje/HOME/metas/viaje/alineación y existen las operaciones de cartas. drawFirstGameLineupTutorial solo coloca una frase; Main completa el onboarding antes del primer partido. No existe esta cadena guiada posterior.

**Siguiente cambio:** Crear etapas persistentes vinculadas a las acciones reales del usuario, con reanudación, opción de omitir y recompensa única. No obligar a carreras antiguas a repetirlo.

**Límite de la evidencia:** Walker P., Class C HERO, AVG .277, 8th 100% 1B, Combo +1 y 2/2 aparece en esta cuenta. El primer C Pack actual fuerza Lenard J.; este video no demuestra que Walker sea siempre el primer premio.

**Capturas:** [video3 02:06](reference_visual/nuevos_20261011/video3/game-0126.jpg), [video3 02:15](reference_visual/nuevos_20261011/video3/game-0135.jpg), [video3 02:21](reference_visual/nuevos_20261011/video3/game-0141.jpg), [video3 06:09](reference_visual/nuevos_20261011/video3/game-0369.jpg)

**Código contrastado:** [src/com/bh/ui/LineupScreen.as:118](src/com/bh/ui/LineupScreen.as), [src/com/bh/Main.as:588](src/com/bh/Main.as), [src/com/bh/model/GameData.as:1946](src/com/bh/model/GameData.as)

### 5. Inicio y misión de 40.000 Coins

**Datos nuevos · Prioridad Alta.**

**Se ve:** Tras crear al personaje: nivel 1, XP 0, ROOKIE, 6000 Coins y energía visible 20. Comprar C PACK deja las monedas en 0. Al completar el tutorial, FOLLOW THE BASICS ofrece 40000 COINS; la barra pasa de 2479 a 42479.

**En 0.10.4:** La carrera nueva está en nivel 1 y ROOKIE, pero GameData comienza con 5000 Coins y energía 25. missionCatalog no incluye la misión de tutorial ni su premio de 40000.

**Siguiente cambio:** Ajustar la dotación de nuevas carreras al flujo elegido y añadir la misión tutorial con cobro idempotente. Conservar los saldos de cuentas existentes.

**Límite de la evidencia:** 20 es energía disponible, no una capacidad máxima demostrada: no se abre su tooltip. El video no muestra registro web ni códigos de invitación. No trasladar su integración Facebook al inicio de sesión actual.

**Capturas:** [video3 01:47](reference_visual/nuevos_20261011/video3/game-0107.jpg), [video3 06:31](reference_visual/nuevos_20261011/video3/game-0391.jpg), [video3 06:23](reference_visual/nuevos_20261011/video3/game-0383.jpg)

**Código contrastado:** [src/com/bh/model/GameData.as:189](src/com/bh/model/GameData.as), [src/com/bh/model/GameData.as:187](src/com/bh/model/GameData.as), [src/com/bh/model/GameData.as:735](src/com/bh/model/GameData.as)

### 6. Draft social después del tutorial

**Existe, con diferencias · Prioridad Media.**

**Se ve:** THE NEW DRAFT BEGINS aparece al acabar el tutorial. Tiene 25 casillas, potencial WEAK / GOOD / STRONG, AUTO PICK, Search y una tira de amigos abajo. La ayuda dice que reclutar más amigos permite formar alineaciones más poderosas.

**En 0.10.4:** ScoutScreen ya tiene 25 casillas, potencial y AUTO PICK. Su mecánica es revelar candidatos aleatorios de pago (5000 Coins por pick), con panel de candidato y selección. No está enlazada al final del tutorial ni a la lista de amigos como en la captura.

**Siguiente cambio:** Reproducir la composición del draft social y su acceso después del tutorial. Conectar solo amigos aceptados o CPU claramente identificados; conservar el scouting de pago como mecánica aparte si se mantiene.

**Límite de la evidencia:** La lista de amigos no termina de cargar en este video. No se ve una selección completa ni se recupera la fórmula de potencial por amigo.

**Capturas:** [video3 06:26](reference_visual/nuevos_20261011/video3/game-0386.jpg)

**Código contrastado:** [src/com/bh/ui/ScoutScreen.as:175](src/com/bh/ui/ScoutScreen.as), [src/com/bh/ui/ScoutScreen.as:173](src/com/bh/ui/ScoutScreen.as)

### 7. MVP y RANK: la guía antigua no basta

**Reglas por revisar · Prioridad Alta.**

**Se ve:** En ROOKIE gana Chicago 1–0, con 16 hits del equipo. El héroe tiene 5 hits, 0 HR y 1 RBI, recibe MVP y el resultado es RANK D. En TRIPLE-A, 20 H / 12 R es S y 11 H / 7 R es C.

**En 0.10.4:** MatchScoring exige heroRbi >= 3 para MVP. grade(16,1) devuelve C y grade(11,7) devuelve B, distintos de estas dos capturas. El caso 20/12 sí devuelve S.

**Siguiente cambio:** Cambiar primero la selección de MVP y reunir casos de cada rango con liga/versión. Mantener una tabla de evidencias; no inferir toda la escala de tres resultados.

**Límite de la evidencia:** El MVP con 1 RBI refuta el requisito universal de 3 RBI para esta versión; no revela por sí solo la fórmula exacta (hits, HR, RBI o valor compuesto). El primer partido podría tener reglas de tutorial.

**Capturas:** [video3 05:48](reference_visual/nuevos_20261011/video3/game-0348.jpg), [final 04:51](reference_visual/nuevos_20261011/final/game-0291.jpg), [final 07:38](reference_visual/nuevos_20261011/final/game-0458.jpg)

**Código contrastado:** [src/com/bh/model/MatchScoring.as:24](src/com/bh/model/MatchScoring.as), [src/com/bh/model/MatchScoring.as:32](src/com/bh/model/MatchScoring.as)

### 8. Recompensas observadas por partido

**Balance por contrastar · Prioridad Alta.**

**Se ve:** En el primer partido: XP 34 → 79 (+45); Coins 109 → 2479 (+2370), con rótulo +370 y subida a nivel 2. En la victoria TRIPLE-A: XP 145093 → 145293 (+200), Coins 529 → 2869 (+2340). En la derrota: XP 145375 → 145445 (+70), Coins 3151 → 3651 (+500).

**En 0.10.4:** MatchScoring usa los cinco importes de la guía histórica (máximo 100 XP y 900 Coins de objetivos), más ganancias provisionales por jugada. Los importes finales de estas capturas no se reproducen con esa tabla.

**Siguiente cambio:** Guardar muestras por liga, resultado, MVP y rango; separar XP/Coins de jugadas, premios finales y level up. Ajustar un solo ledger, sin sumar ambos sistemas ni recalcular premios antiguos.

**Límite de la evidencia:** La separación 370 de partido + 2000 de level up es consistente con el rótulo y el cambio total de 2370, pero la tabla de cada categoría no se recupera. Los +2340 y +500 son totales finales observados, no premios base universales.

**Capturas:** [video3 05:48](reference_visual/nuevos_20261011/video3/game-0348.jpg), [final 04:51](reference_visual/nuevos_20261011/final/game-0291.jpg), [final 07:37](reference_visual/nuevos_20261011/final/game-0457.jpg)

**Código contrastado:** [src/com/bh/model/MatchScoring.as:35](src/com/bh/model/MatchScoring.as), [src/com/bh/model/GameData.as:2729](src/com/bh/model/GameData.as)

### 9. Post Season: composición, grupo y premio

**Sistema presente; falta fidelidad · Prioridad Alta visual.**

**Se ve:** Cuadro morado, A-LEAGUE a la izquierda y N-LEAGUE a la derecha, VS con héroes/fotos, eliminados atenuados, tres trofeos con monedas y contador de victorias restantes. Toronto entra 1–0, gana 12–1, pasa 2–0 y necesita una victoria más. El tooltip de la copa de liga dice Triple-A League Champion, Reward: 60000 Coins.

**En 0.10.4:** Las series a tres victorias y ocho equipos ya existen. PostSeason asigna siempre al héroe al grupo N y no guarda su asociación real. La pantalla es verde, muestra “3 Wins Required” fijo y solo una copa vectorial WORLD. No liquida un premio de copa de liga de 60000.

**Siguiente cambio:** Mantener el motor de series; corregir asociación por equipo, contador 3−victorias y composición morada. Añadir premio de título por liga cuando se confirme su cobro, con marcador persistente para evitar duplicados.

**Límite de la evidencia:** El video termina tras perder 7–11 estando 2–0: no se ve la pantalla posterior, ni una eliminación, ni ganar la copa, ni el Mundial. 60000 es la oferta visible de TRIPLE-A, no una entrega observada ni una tabla de todas las ligas.

**Capturas:** [final 01:26](reference_visual/nuevos_20261011/final/game-0086.jpg), [final 04:57](reference_visual/nuevos_20261011/final/game-0297.jpg)

**Código contrastado:** [src/com/bh/model/PostSeason.as:12](src/com/bh/model/PostSeason.as), [src/com/bh/ui/PostSeasonScreen.as:36](src/com/bh/ui/PostSeasonScreen.as), [src/com/bh/model/GameData.as:4335](src/com/bh/model/GameData.as)

### 10. Estadios urbanos nocturnos y local/visitante

**Arte pendiente · Prioridad Alta visual.**

**Se ve:** El primer partido de TRIPLE-A transcurre en un estadio urbano nocturno con gradas rojas. El siguiente usa gradas azules y otro edificio central. El recorrido por HOME, viaje y partido conserva ese escenario y el equipo equipado.

**En 0.10.4:** La 0.10.4 conserva el nuevo estadio ilustrado de ROOKIE y otras variantes reconstruidas; no reproduce estas dos composiciones urbanas. La cabeza aprobada de 0.8.6 debe seguir conservándose.

**Siguiente cambio:** Preparar fondos específicos por estadio, con edificios, gradas, iluminación y capas para las cámaras de contacto/seguimiento. Reutilizar las escenas actuales y sus límites de rendimiento.

**Límite de la evidencia:** Son capturas comprimidas, no fondos completos sin personajes/HUD. No se recupera la geometría oculta. Las barras negras y la marca del grabador pertenecen al video.

**Capturas:** [final 01:50](reference_visual/nuevos_20261011/final/game-0110.jpg), [final 05:42](reference_visual/nuevos_20261011/final/game-0342.jpg), [final 00:03](reference_visual/nuevos_20261011/final/game-0003.jpg)

**Código contrastado:** [src/com/bh/visual/MatchStadium.as:10](src/com/bh/visual/MatchStadium.as)

### 11. Ocho cascos con precios y bonos exactos

**Contenido recuperable · Prioridad Media.**

**Se ve:** En HELMET: Star 1, Star 2, Star 3 y Star 4 cuestan 270000 Coins; sus bonos son C55, P55, L55 y P55. Love 1, Love 2, Shooting-Star 1 y Shooting-Star 2 cuestan 120000; bonos C40, P40, L40 y C40.

**En 0.10.4:** EquipmentCatalog y el catálogo de GameData no contienen estos ocho nombres/precios concretos. Existen equipamiento, categorías, compra, requisitos e inventario; falta el contenido específico.

**Siguiente cambio:** Agregar artículos identificados con sus bonos y costes visibles, conservando el equipamiento ya comprado. Dibujar las variantes usando las capturas como referencia.

**Límite de la evidencia:** 55 y 40 son bonos C/P/L junto a sus iconos, no niveles mínimos. La captura no informa requisito de liga, nivel ni disponibilidad temporal. No se ha extraído arte limpio de esos cascos.

**Capturas:** [final 00:45](reference_visual/nuevos_20261011/final/frame-0045.jpg)

**Código contrastado:** [src/com/bh/model/EquipmentCatalog.as:3](src/com/bh/model/EquipmentCatalog.as), [src/com/bh/model/GameData.as:2800](src/com/bh/model/GameData.as)

### 12. Catálogo facial y movimiento del creador

**Referencia más completa · Prioridad Media.**

**Se ve:** El video recorre SHAPE, HAIR, EYES, NOSE y MOUTH. Cabellos: Shaggy, Devilock, Volume, Slicked-Back, Crew Cut, Cornrows, Messy, Slick. Los ojos incluyen Round, Strong, Small, Sharp, Scary, Normal, Bright, Handsome; se ven las ocho narices y bocas. El personaje alterna poses y conserva casco, uniforme y bate al llegar a HOME.

**En 0.10.4:** Los ocho cabellos ya tienen esos nombres. EYES, NOSE y MOUTH usan nombres y diseños locales diferentes. Ya se conserva la apariencia entre pantallas. El botón Female no demuestra aquí un catálogo femenino porque no se pulsa.

**Siguiente cambio:** Usar las capturas para completar nombres, miniaturas y poses del creador. Conservar la cabeza y el atlas de cabello de 0.8.6 tal como pidió el usuario.

**Límite de la evidencia:** A 11.011 FPS, este archivo no permite recuperar todas las poses intermedias originales. No se cambia automáticamente la cabeza aprobada por esta nueva referencia.

**Capturas:** [video3 00:32](reference_visual/nuevos_20261011/video3/game-0032.jpg), [video3 00:47](reference_visual/nuevos_20261011/video3/game-0047.jpg), [video3 00:59](reference_visual/nuevos_20261011/video3/game-0059.jpg), [video3 01:01](reference_visual/nuevos_20261011/video3/game-0061.jpg)

**Código contrastado:** [src/com/bh/ui/CharacterMakerScreen.as:242](src/com/bh/ui/CharacterMakerScreen.as)

## Prioridad de implementación propuesta

1. Metas HIT/RBI y tutorial persistente, con primera compra y misión final. Requiere migraciones que preserven premios y cuentas.
2. STRETCHING/LIFTING y fin de mastery, con relojes separados y premio de energía único.
3. MVP, rangos y tablas de recompensa por versión/liga, usando estas muestras como casos de contraste.
4. Post Season morado, asociación A/N correcta, victorias restantes y copas; todavía falta observar el cobro del premio.
5. Estadios nocturnos y cascos concretos. Mantener la cabeza y cabello aprobados.

## Qué ya existe y no debe presentarse como ausente

Series de tres victorias, cuadro de ocho equipos, draft de 25 casillas, cartas clase × grado, sustitución/orden por arrastre, Combo/MAX, efectos de hit, marcador, estadísticas, puntos por jugada, regalos y liga privada. Estos videos aportan detalles de fidelidad, no obligan a reescribir esa base.

## Preguntas que siguen abiertas

- Los videos no identifican su fecha/versión del juego.
- El segundo termina antes de ganar la serie o el campeonato mundial.
- No muestran ALL STAR, WORLD MATCH, fórmulas del servidor ni creación de cuentas web.
- Nombre y actividades del cuarto entrenador; desbloqueo del quinto; curva completa de mastery.
- Distribución de metas, reglas exactas de MVP y rangos intermedios, y tabla completa de premios por liga.
- El draft social no termina de cargar; no hay evidencia del cálculo de potencial.

La tabla histórica de Gamelytic documentada en ANALISIS_FUENTES_20261011.md corresponde a una fuente antigua. Estas capturas muestran discrepancias; la 0.10.4 conserva todavía esa implementación. No se identifica la fecha del original grabado, por lo que deben conservarse ambas evidencias sin mezclarlas.
