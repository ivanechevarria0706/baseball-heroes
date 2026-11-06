# Inicio original: revisión contra 1.0.10

Análisis visual de **videoplayback (4).mp4**, de 6:41, revisado el 15 de octubre de 2026. Se volvió a recorrer el muestreo completo cada 5 segundos y se extrajeron **96 capturas adicionales**, concentradas en creación, cartas, arrastres, MAX y cierre de la lección. Se contrastó con el código actual y 12 comprobaciones aisladas del modelo. No se modificó ni publicó el juego.

El informe del 12 de octubre comparaba con 0.10.4; este documento lo actualiza para 1.0.10 y distingue lo que ya se implementó. La grabación empieza en la selección de equipo, no en el login.

## Recorrido comprobado

| Tiempo | Etapa | Observación |
| --- | --- | --- |
| 00:00 | Selección de equipo | Comienza aquí, sin login visible. Se previsualizan varias ciudades; Chicago queda seleccionado en 00:17–00:18. |
| 00:20 | Creación de personaje | Se recorren las cinco pestañas. El casco desaparece únicamente al editar HAIR. |
| 01:05 | Llegada al equipo | Mapa, entrada a HOME y presentación del entrenador. |
| 01:44 | Metas de temporada | La ruleta termina en 70 HIT y 55 RBI; no prueba que sean metas universales. |
| 01:55 | Camino al primer partido | Roadmap y preparación de temporada antes del LINEUP. |
| 02:03 | Estado inicial del LINEUP | Kyle ya está en el banco. El héroe ocupa la fila 9. |
| 02:06 | Compra del C Pack | Se gastan los 6,000 Coins iniciales. |
| 02:15 | Revelado de Walker | C HERO, tres estrellas, AVG .277, 8th 100% 1B, Combo +1, 2/2. |
| 02:21 | Sustitución normal | Aaron pasa del banco a la fila 2. |
| 02:25 | Cambio de orden | El héroe se arrastra de la fila 9 a la 1. |
| 02:28 | AUTO SORT | Walker aparece en la fila 1 y el héroe en la 3; se habilita PLAY. |
| 02:36 | Primer partido | Listas de autojuego, primer turno manual, lecciones de bola/timing/combo. |
| 03:26 | MAX activo | Fuego en los pies. Los primeros strikes no lo apagan. |
| 03:48 | Combo reiniciado | Mensaje de vuelta a cero antes de STRIKE OUT en 03:51. |
| 05:44 | Resultado | Victoria 1–0 en 11 entradas, 16 hits, MVP del héroe y RANK D. |
| 05:52 | LEVEL UP | Nivel 2, +1 SKILL POINT, +2,000 Coins, +1 MAX ENERGY y anuncio de 30 nuevos objetos. |
| 06:09 | Invertir punto | Panel compacto sobre el héroe, atributos 1/1/1 y total 3; se pulsa +. |
| 06:26 | Draft de amigos | Tablero de 25 puestos y DRAFT 5 PLAYER. Ya se ven 42,479 Coins. |
| 06:31 | Misión completa | SIGUE LO BÁSICO, 40,000 Coins ya acreditados; SKIP/SHARE COINS. |
| 06:38 | HOME tras la lección | Nuevas misiones, flecha hacia NAME YOUR TEAM y recogida de taquilla. |

## Diferencias actuales

### F01. Opciones y distribución del creador

**Parcial · Prioridad Alta · 00:24**

**Original:** Cinco pestañas: SHAPE, HAIR, EYES, NOSE y MOUTH. En SHAPE: Round, Sharp, Chubby, Double Chin / Slim, Triangular, Edgy, Flat Chin. Ocho opciones por pestaña; FREE y EQUIPPED.

**1.0.10:** Hay seis pestañas, incluida ETC. El orden de SHAPE cambia; las etiquetas de ojos, narices y bocas son aproximaciones. Los ocho peinados sí conservan los nombres observados.

**Cambio que corresponde:** Usar un orden visual propio del creador y las etiquetas comprobadas. Reubicar ETC si se conserva como ampliación. Ajustar márgenes, tamaños y paletas a la referencia.

**Alcance:** El orden del creador no debe alterar los índices guardados de las caras ni la cabeza del bateador 0.8.6 aprobada.

[Captura original 00:24](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0024.jpg>)

Código: [CharacterMakerScreen.as:77](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/CharacterMakerScreen.as:77>), [CharacterMakerScreen.as:235](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/CharacterMakerScreen.as:235>)

### F02. Casco, uniforme y pelo en la vista previa

**Diferente · Prioridad Alta · 00:32**

**Original:** El héroe lleva casco negro con logo en SHAPE, EYES, NOSE y MOUTH. En HAIR se quita el casco para mostrar el peinado y el color. El cuerpo mantiene su equipo inicial.

**1.0.10:** CreationArtwork construye el actor con un objeto de equipo vacío y la vista previa aparece sin casco. No cambia el equipo de la vista previa según la pestaña.

**Cambio que corresponde:** Mostrar el equipo inicial real y ocultar únicamente el casco al editar HAIR. Mantener la misma apariencia guardada entre creador, HOME y partido.

**Alcance:** Se pueden copiar colocación y visibilidad sin rehacer la cabeza aprobada. La captura actual usada es de 1.0.9; el componente continúa idéntico en 1.0.10.

[Captura original 00:32](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0032.jpg>)

Código: [CreationArtwork.as:8](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/visual/CreationArtwork.as:8>), [CharacterMakerScreen.as:243](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/CharacterMakerScreen.as:243>)

### F03. Control Female

**Diferente · Prioridad Media · 00:24**

**Original:** Hay un botón rosa Female junto a Random bajo el personaje.

**1.0.10:** Random está presente; no hay control equivalente de género en CharacterMakerScreen.

**Cambio que corresponde:** Registrar el control como pendiente y buscar una referencia donde se active antes de reproducir sus variantes.

**Alcance:** El video no lo pulsa: demuestra que existe el botón, pero no enseña el cuerpo femenino ni sus opciones.

[Captura original 00:24](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0024.jpg>)

Código: [CharacterMakerScreen.as:90](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/CharacterMakerScreen.as:90>)

### F04. Equipo inicial y carta gratuita en el banco

**Diferente · Prioridad Alta · 02:03**

**Original:** Antes de comprar hay Kyle C NORM, AVG .254, habilidad de 5.ª entrada y 2/2 entre los sustitutos. SPECIAL (1). El héroe empieza 9.º; los compañeros normales muestran AVG .200 y el héroe .000.

**1.0.10:** La auditoría de cuenta nueva encuentra Rookie Ace C/A, AVG .245, habilidad de 1.ª entrada, ya equipado. El héroe batea primero y todos los normales muestran .000.

**Cambio que corresponde:** Reconstruir el estado inicial de esta referencia: especial disponible en el banco, héroe al final y promedio base mostrado separado de estadísticas de carrera.

**Alcance:** No falta una carta gratuita: existe, pero difiere en identidad y ubicación. No fabricar hits históricos para mostrar .200 ni modificar carreras existentes. Kyle visible aquí no prueba un regalo idéntico en todas las versiones.

[Captura original 02:03](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0123.jpg>)

Código: [GameData.as:245](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/GameData.as:245>), [GameData.as:5728](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/GameData.as:5728>), [SpecialCardCatalog.as:16](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/SpecialCardCatalog.as:16>)

### F05. El sobre C admite una carta HERO

**Diferente · Prioridad Alta · 02:15**

**Original:** El C Pack inicial cuesta 6,000 Coins y entrega Walker P., clase C HERO, AVG .277, 8th 100% 1B, Combo +1 y 2/2.

**1.0.10:** El precio tutorial de 6,000 ya coincide. El primer C fuerza Lenard J. C/A; el catálogo de compra C excluye HERO y gradeAllowed también rechaza C/HERO, aunque existan cartas C HERO en el catálogo.

**Cambio que corresponde:** Separar perfiles de tienda/tutorial de las restricciones globales de clase y grado. Permitir reproducir la combinación C HERO observada; incorporar el perfil visible de Walker sin inventar sus atributos secundarios.

**Alcance:** Otro gameplay muestra una tienda con precios y rangos distintos. No fijar Walker como primer premio universal ni inventar probabilidades a partir de esta única apertura.

[Captura original 02:15](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0135.jpg>)

Código: [GameData.as:2040](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/GameData.as:2040>), [SpecialCardCatalog.as:84](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/SpecialCardCatalog.as:84>), [SpecialCardCatalog.as:63](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/SpecialCardCatalog.as:63>)

### F06. Insignia HERO de tres estrellas

**Diferente · Prioridad Media · 02:15**

**Original:** Walker P. muestra tres estrellas amarillas junto a HERO, tanto en la carta como en el banco.

**1.0.10:** Las insignias dibujadas por código usan cuatro estrellas para HERO. Algunas ilustraciones observadas conservan sus propios rótulos; el problema está en las insignias generadas y las filas.

**Cambio que corresponde:** Ajustar el perfil visual HERO observado en carta y LINEUP para que ambos coincidan.

**Alcance:** Este video no permite reconstruir toda la tabla de estrellas de los demás grados.

[Captura original 02:15](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0135.jpg>)

Código: [SpecialBatterCardView.as:47](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/SpecialBatterCardView.as:47>), [LineupScreen.as:538](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/LineupScreen.as:538>)

### F07. Lección de sustitución y orden mediante arrastre

**Parcial · Prioridad Alta · 02:21**

**Original:** 02:21: Aaron va del banco a la fila 2. 02:25: el héroe se arrastra de la fila 9 a la 1. 02:27: el entrenador ofrece AUTO SORT. 02:28: Walker queda activo en la fila 1 y el héroe en la 3.

**1.0.10:** El arrastre de jugadores normales y AUTO SORT ya existen. La etapa SUBSTITUTE enseña un botón extra que equipa la carta recién comprada, en vez de guiar el arrastre normal. Los especiales ocupan las primeras posiciones no heroicas.

**Cambio que corresponde:** Guiar las acciones sobre las filas reales: sustituir un compañero, mover al héroe y ofrecer AUTO SORT. Avanzar al completar cada acción, sin sustituir la lección por un botón auxiliar.

**Alcance:** La secuencia no muestra arrastrar una carta especial a una posición arbitraria. No deducir esa función de este video.

[Captura original 02:21](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0141.jpg>)

Código: [LineupScreen.as:135](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/LineupScreen.as:135>), [StarterTutorial.as:21](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/StarterTutorial.as:21>)

### F08. Tutorial contextual y presentación del primer partido

**Parcial · Prioridad Alta · 02:44**

**Original:** El entrenador aparece en varios momentos: una bola que no conviene batear, el timing, el indicador de combo y MAX. La interfaz se oscurece, apunta al elemento y espera un clic. En autojuego dominan las dos listas compactas sobre el campo.

**1.0.10:** Ya existen guía de llegada, tutorial persistente, carteles de resultados y listas de autojuego. El tutorial del partido condensa las explicaciones en dos burbujas antes de jugar; las lecciones posteriores no siguen los eventos de la referencia. El autojuego aún difiere en escala, cabeceras y marcador.

**Cambio que corresponde:** Añadir pasos ligados a eventos reales y puntos de foco, conservando el arranque ya guiado. Reducir la diferencia de composición entre las listas, el marcador, el minimapa y el campo.

**Alcance:** No copiar las pantallas negras ni las esperas de red de la grabación como animaciones obligatorias. Los 11 FPS del MP4 no son la velocidad del motor original.

[Captura original 02:44](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0164.jpg>)

Código: [Game.as:1962](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/core/Game.as:1962>), [StarterCoach.as:14](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/StarterCoach.as:14>)

### F09. MAX se pierde al terminar en strikeout

**Diferente · Prioridad Alta · 03:48**

**Original:** El fuego permanece después de strikes individuales. En 03:48 el entrenador dice que el indicador volvió a cero; en 03:51 aparece STRIKE OUT. En la siguiente aparición del héroe ya no hay fuego de MAX.

**1.0.10:** La prueba de MatchMomentum deja la carga en 10/MAX al recibir STRIKE OUT. completeStrikeout llama a scorePlay; esa ruta solo consume MAX cuando hay HOME RUN. El tip actual afirma que los fallos conservan la carga sin distinguir el strikeout.

**Cambio que corresponde:** Distinguir un swing fallido de un turno terminado en strikeout y reproducir el reinicio comprobado. Actualizar el tutorial con la misma regla.

**Alcance:** No reiniciar por cada strike: el propio video conserva el fuego tras los primeros fallos. La curva de carga y el efecto numérico de Luck siguen sin recuperarse.

[Captura original 03:48](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0228.jpg>)

Código: [Game.as:3348](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/core/Game.as:3348>), [Game.as:3548](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/core/Game.as:3548>), [MatchMomentum.as:8](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/MatchMomentum.as:8>)

### F10. MVP y RANK del primer resultado

**Diferente · Prioridad Alta · 05:48**

**Original:** Chicago gana 1–0 a Minnesota en 11 entradas, con 16 hits de equipo. El héroe tiene 5 hits, 0 HR y 1 RBI; recibe la corona MVP. El resultado muestra RANK D.

**1.0.10:** Con 16 hits y una carrera, MatchScoring.grade devuelve C. mvpIndex exige al menos 3 RBI y devuelve -1 en ese escenario de una sola carrera.

**Cambio que corresponde:** Usar este partido como caso comprobado al recalibrar MVP y RANK, junto a los demás videos. Separar elección del MVP y condiciones de bonos si la evidencia lo requiere.

**Alcance:** La contradicción es segura; el video no revela todos los umbrales, desempates ni fórmulas de puntos. No arreglarla con una excepción al nombre del rival o una nueva tabla inventada.

[Captura original 05:48](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0348.jpg>)

Código: [MatchScoring.as:24](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/MatchScoring.as:24>), [MatchScoring.as:33](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/MatchScoring.as:33>)

### F11. Subida temprana a nivel 2

**Diferente · Prioridad Alta · 05:48**

**Original:** Al entrar al resultado el HUD tiene 34 XP; termina en nivel 2 con 79 XP. Se anuncian +45 XP y +370 Coins, además de los 2,000 Coins de LEVEL UP.

**1.0.10:** La auditoría confirma que levelXpTarget exige 180 XP en nivel 1. Con 79 XP, nuestra curva no alcanza nivel 2. Las recompensas de jugadas y objetivos son todavía una reconstrucción.

**Cambio que corresponde:** Revisar la progresión de la primera partida con esta secuencia como límite comprobado y rastrear el crédito de cada premio una sola vez.

**Alcance:** 79 XP demuestra que la primera subida ocurre a más tardar ahí, no que el umbral sea exactamente 79. Tampoco recupera la curva 1–100. No se ha demostrado un doble cobro en el remake.

[Captura original 05:48](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0348.jpg>)

Código: [GameData.as:2827](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/GameData.as:2827>), [MatchScoring.as:54](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/MatchScoring.as:54>)

### F12. Panel compacto de SKILL POINT

**Diferente · Prioridad Alta · 06:09**

**Original:** Al pulsar al héroe aparece un panel pequeño sobre él y sus casillas de equipo alrededor. Contact/Power/Luck empiezan mostrando 1/1/1, total 3, y hay un punto disponible. Al invertirlo el total pasa a 4.

**1.0.10:** HeroStatPanel es un modal central de 540×385 con retrato y atributos internos 60/50/55. El modelo concede un punto inicial y otro por subida; la secuencia de puntos disponibles requiere ajuste.

**Cambio que corresponde:** Crear la presentación compacta junto al héroe y separar los valores visuales de inversión de los atributos internos usados para simular. Guiar + y X sobre sus controles reales.

**Alcance:** No reemplazar los atributos internos por 1: son escalas distintas. Antes del primer partido no se abre este panel en el video; solo se confirma un punto disponible después de subir.

[Captura original 06:09](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0369.jpg>)

Código: [HeroStatPanel.as:20](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/HeroStatPanel.as:20>), [GameData.as:375](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/GameData.as:375>)

### F13. Draft de amigos al terminar la lección

**Diferente · Prioridad Alta · 06:26**

**Original:** Después de cerrar SKILL POINT aparece THE NEW DRAFT BEGINS: tablero de 25 puestos, barra WEAK/GOOD/STRONG, DRAFT 5 PLAYER, AUTO PICK, Search y una lista inferior de amigos.

**1.0.10:** ScoutScreen tiene 25 cartas y el título, pero es scouting CPU pagado: 5,000 Coins por selección y 20,000 por Auto Pick. No se abre automáticamente al terminar la lección y no cumple el mismo papel que reclutar amigos.

**Cambio que corresponde:** Construir el paso de draft/reclutamiento de amigos conectado a las cuentas privadas, con una alternativa CPU identificada cuando no haya amigos. Mantener separado el scouting pagado.

**Alcance:** El video no completa una selección: no permite confirmar qué se cobra, qué potencial asigna cada amigo ni cómo afecta exactamente al compañero.

[Captura original 06:26](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0386.jpg>)

Código: [ScoutScreen.as:173](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/ScoutScreen.as:173>), [LobbyScreen.as:396](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/LobbyScreen.as:396>), [Main.as:899](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/Main.as:899>)

### F14. Cierre del tutorial, misión, nombre y taquilla

**Parcial · Prioridad Alta · 06:31**

**Original:** El balance pasa de 2,479 a 42,479 durante la apertura del draft. Después aparece MISIÓN COMPLETA / SIGUE LO BÁSICO con 40,000 Coins y SKIP / SHARE COINS. Luego se apunta NAME YOUR TEAM y la taquilla muestra 450 Coins.

**1.0.10:** El premio de 40,000 ya existe y se cobra una sola vez. El recorrido termina en un botón auxiliar COBRAR 40,000 COINS; no encadena draft, panel de misión y señal hacia el nombre. Hay nombre y taquilla, pero el orden guiado difiere.

**Cambio que corresponde:** Recrear la secuencia visual sin volver a pagar el premio al mostrar la misión o pulsar Share. Guiar el nombre y la primera recogida de taquilla cuando corresponda.

**Alcance:** Se ve que el premio ya está acreditado antes de la ventana final; el evento exacto que lo acredita no se ve. No obligar a compartir en Facebook. El delta posterior de monedas también incluye otras animaciones: no atribuirlo entero a la taquilla.

[Captura original 06:31](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/reference_visual/initial_audit_20261015/frame-0391.jpg>)

Código: [LobbyScreen.as:396](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/ui/LobbyScreen.as:396>), [GameData.as:574](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/src/com/bh/model/GameData.as:574>)

## Base que ya existe

- **Nivel 1, Rookie, 6,000 Coins, 20 de energía disponible.** Coincide en la base; la capacidad máxima no se deduce del 20 del video.
- **Héroe sin lentes iniciales.** La auditoría confirma goggles = null.
- **Apariencia compartida y ocho peinados.** Ya están implementados; faltan equipo de vista previa, etiquetas y distribución.
- **Ruleta HIT + RBI.** Ya existe; 70/55 es el resultado de esta cuenta.
- **Roadmap, viaje y alineación antes de jugar.** El recorrido base existe; falta ajustar pasos guiados y composición.
- **Energía especial 2/2, condición con flechas y fila del héroe amarilla.** Se mejoraron en 1.0.10. Este video no demuestra el ciclo completo de recarga.
- **Solo batea manualmente el héroe; entradas extra.** Ambos existen. No es necesario convertir el juego en batear por todo el equipo.
- **Recompensas de subida y misión inicial.** Ya existen +2,000 Coins / +1 punto / +1 MAX ENERGY y misión de 40,000 cobrada una vez; difieren el momento, la curva y la presentación.

## Lo que este video no permite afirmar

- No se ve la pantalla de login: el video empieza en TEAM SELECTION. No sirve para validar el formulario de cuenta de nuestra web.
- No se abre TRADE & ENHANCE. Este video no prueba la receta ni las probabilidades de combinar tres cartas. Esa función sí existe en el remake en HOME → TEAM → CARDS → TRADE; el acceso desde LINEUP todavía lleva al intercambio de jugadores normales.
- Female está visible pero no se activa. No hay referencia del resultado de ese control en esta grabación.
- No se agota una carta durante dos partidos ni se abre CHARGE. La duración de recarga, su precio y las transiciones exactas de condición deben contrastarse con los otros videos.
- No se recuperan fórmulas completas de XP, RANK, MVP, carga de combo, probabilidades de sobres ni efectos del draft. Sí se recuperan casos concretos que el remake debe poder reproducir.
- No se transcribió ni integró audio. La voz del narrador no se incorpora como un efecto del juego.

## Orden de trabajo recomendado

1. Reconstruir la primera lección sobre los controles reales: estado del banco, sobre, arrastres, AUTO SORT, panel compacto de puntos y draft. Conservar el progreso de cuentas existentes.
2. Corregir las contradicciones comprobadas de MAX/strikeout, clase C HERO, MVP/RANK y progresión inicial. Validarlas con estos casos y los otros videos, sin presentar las fórmulas locales como recuperadas.
3. Pulir la presentación del creador y autojuego: casco por pestaña, nombres, orden de opciones, escalas, cabeceras, flechas y focos. Conservar la cabeza del bateador 0.8.6.

## Verificación y procedencia

El modelo aislado reprodujo 12 observaciones de la versión actual. PASS significa que se reprodujo el comportamiento actual, **no que ya exista paridad con el original**. Se usó una identidad AIR separada, sin sesión web ni cuentas de producción. El MVP se contrastó con datos sintéticos que conservan las propiedades comprobadas del resultado: 16 hits, una carrera y una RBI del héroe.

Fuente: `C:\Users\ivane\Downloads\videoplayback (4).mp4` · SHA-256 `5e68f67bc3683da1f09dee2b13e3767fa44e25b33b2b1d6ef6143aa2adae3a20`.
Versión contrastada: **1.0.10**, build `0d7c8f757f0a6fb8`. La captura del creador procede de QA 1.0.9; sus componentes están comprobados como idénticos en 1.0.10. La captura de autojuego es de QA 1.0.10 con datos de prueba, no una cuenta nueva.
Los tiempos son aproximados al segundo. Los 11.011 FPS pertenecen al archivo grabado; no prueban los FPS del juego. La capacidad máxima inicial, las tablas de servidor y los tiempos de red no se deducen de este archivo.
