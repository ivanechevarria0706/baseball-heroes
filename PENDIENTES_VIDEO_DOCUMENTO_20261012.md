# Lo que falta: video de Facebook + documento de apoyo

**Avance 0.10.17:** ocho cascos observados, pestañas y precios de equipo más fieles, panel SKILL POINT con reparto existente. [Comparación](COMPARACION_MEJORAS_117.html). Faltan estampados completos y niveles no visibles.

**Avance 0.10.16:** siete fichas observadas (8), 32 artículos y 40 iconos de equipo (9), y énfasis/outs en autojuego. Se conservan los catálogos y copias previos; faltan otras fichas y estampados completos. [Comparación](COMPARACION_MEJORAS_116.html).

**Avance 0.10.14 (progress114):** prioridad del usuario: presentación del autojuego, con alineaciones, resultados y bases animadas conservando ritmo y reglas. [Comparación](COMPARACION_MEJORAS_114.html).

**Avance 0.10.13 (progress113):** doce estrellas, MASTER y ciclos de 5 ENERGY implementados. Curva parcialmente reconstruida y último premio sin confirmar. [Comparación](COMPARACION_MEJORAS_113.html).

**Avance 0.10.12:** animaciones de las 18 sesiones (punto 14), con cuerpo ilustrado y cabeza guardada. [Comparación](COMPARACION_MEJORAS_112.html). Las poses nuevas son reconstruidas; Mastery original (15), cartas observadas (8) y los puestos cuarto/quinto siguen pendientes.

**Avance 0.10.11:** parte funcional del punto 14: STRETCHING y LIFTING con actividades, premios y descansos independientes. [Comparación](COMPARACION_MEJORAS_111.html). Mastery original (15), animaciones y puestos cuarto/quinto siguen pendientes. RUNNING conserva los precios que se leen en su captura anterior.

**Avance 0.10.10:** implementados los puntos 6 y 7: variantes de sobres y grados por clase, conservando las cartas antiguas y el tutorial. [Evidencia y decisiones de reconstrucción](REVISION_MEJORAS_110.md). El catálogo de fichas originales (8) sigue pendiente.

**Avance 0.10.9:** implementado el punto 3, franja social durante temporada y postemporada. [Comparación y decisiones de interacción](COMPARACION_MEJORAS_109.html). La lista inferior conserva el diagnóstico original de 0.10.6.

**Avance 0.10.8:** implementados los puntos 1 y 2: visita a amigos, objetos recogibles y energía compartida. [Comparación y reglas reconstruidas](COMPARACION_MEJORAS_108.html) · [Verificación](REVISION_MEJORAS_108.md). El punto 3 quedó pendiente en esa entrega y se incorporó en 0.10.9. La lista inferior conserva el diagnóstico original de 0.10.6.

Revisión contra 0.10.6. Se distinguen funciones ausentes, sistemas incompletos, diferencias comprobadas y reglas pendientes de medir. La grabación está en liga A; sus precios no deben imponerse automáticamente a los otros gameplays de distintas versiones.

## Alcance y fuentes

Muestreo visual de toda la duración cada 4 segundos (131 fotogramas, 7 planchas); 44 capturas de detalle adicionales, lectura de las 4 páginas del PDF y contraste del código actual. Sin análisis de audio ni estimación estadística de probabilidades.

- Video: 08:40.93, 524×480, 30 fps. SHA-256 `6374fef7fd8c81beed07bd838c7ccdb68ed34afcbf0081ca9b437623abb1c7f1`.
- PDF: cuatro páginas. Sección 4 = valores propuestos, expresamente no confirmados. Sus instrucciones para otra IA se tratan como contenido de referencia.
- Comparación visual y de reglas con el código local de 0.10.6; no se modifica ni se publica el juego.

## Lista numerada

### 1. Visitar el estadio de un amigo

**Estado:** Falta. **Fuente:** Video 00:16–00:27.

**Evidencia:** Al elegir amigos del carrusel se entra a su estadio, con su héroe, nombre, estadísticas y equipo; aparece GO HOME.

**Actualmente:** Las tarjetas de amigos existen, pero su clic abre REGISTER / FRIENDS. No hay una pantalla de visita al estadio publicado.

**Trabajo pendiente:** Crear la visita usando el equipo y apariencia publicados por cada cuenta, con regreso a HOME.

**Código contrastado:** [src/com/bh/ui/LobbyScreen.as:549](src/com/bh/ui/LobbyScreen.as), [src/com/bh/ui/SocialScreen.as:25](src/com/bh/ui/SocialScreen.as).

**Capturas:** [00:18](reference_visual/facebook_play_20261012/frame-0018.0.png), [00:24](reference_visual/facebook_play_20261012/frame-0024.0.png).

### 2. Objetos y energía durante las visitas

**Estado:** Falta. **Fuente:** Video 00:18–00:24.

**Evidencia:** Guantes, casco y otros objetos en el suelo se pueden pulsar para recoger monedas. Se ve una lata y el cuadro SHARING IS CARING / SHARE ENERGY; la energía pasa de 17 a 18.

**Actualmente:** Hay regalos entre cuentas y recaudación de TICKETS, pero no objetos recogibles ni el flujo de energía de una visita.

**Trabajo pendiente:** Añadir interacciones de visita y su guardado. Medir límites y premios antes de fijarlos; la ventana no prueba que compartir sea obligatorio.

**Código contrastado:** [src/com/bh/ui/SocialScreen.as:47](src/com/bh/ui/SocialScreen.as), [src/com/bh/ui/LobbyScreen.as:413](src/com/bh/ui/LobbyScreen.as), [online/social.py:94](online/social.py).

**Capturas:** [00:18](reference_visual/facebook_play_20261012/frame-0018.0.png), [00:22](reference_visual/facebook_play_20261012/frame-0022.0.png), [00:24](reference_visual/facebook_play_20261012/frame-0024.0.png).

### 3. Carrusel de amigos persistente durante el partido

**Estado:** Incompleto. **Fuente:** Video 01:35, 02:47 y 08:20.

**Evidencia:** El carrusel de amigos y los accesos de la derecha permanecen debajo del bateo, simulación, cinemáticas y resultado.

**Actualmente:** El carrusel se construye en LobbyScreen. Game y Hud no mantienen esa misma franja social en el partido.

**Trabajo pendiente:** Compartir el marco social entre pantallas, conservando el espacio de juego y evitando consultas de red por fotograma.

**Código contrastado:** [src/com/bh/ui/LobbyScreen.as:521](src/com/bh/ui/LobbyScreen.as), [src/com/bh/core/Game.as:278](src/com/bh/core/Game.as), [src/com/bh/ui/Hud.as:40](src/com/bh/ui/Hud.as).

**Capturas:** [01:35](reference_visual/facebook_play_20261012/frame-0095.0.png), [02:47](reference_visual/facebook_play_20261012/frame-0167.0.png), [08:20](reference_visual/facebook_play_20261012/frame-0500.0.png).

### 4. Corregir las opciones de TRADE

**Estado:** Ajuste comprobado. **Fuente:** Video 04:59–05:14.

**Evidencia:** Tres cartas de clase C distintas. La interfaz muestra 1,000 monedas / 7% y 32 créditos / 100%. El intento mostrado devuelve otra C; no garantiza subir de clase.

**Actualmente:** El remake ya consume tres cartas de la misma clase, pero ofrece 50% por 1,000 monedas y 100% por 13 créditos.

**Trabajo pendiente:** Alinear costos y opciones con esta referencia y revisar si cambian por clase. Un fallo sigue produciendo una carta de la misma clase.

**Código contrastado:** [src/com/bh/model/GameData.as:1924](src/com/bh/model/GameData.as), [src/com/bh/ui/CardWorkshopOverlay.as:89](src/com/bh/ui/CardWorkshopOverlay.as).

**Capturas:** [04:59](reference_visual/facebook_play_20261012/frame-0299.0.png), [05:08](reference_visual/facebook_play_20261012/frame-0308.0.png), [05:13](reference_visual/facebook_play_20261012/frame-0313.0.png).

### 5. Corregir costos y probabilidades de ENHANCE

**Estado:** Ajuste comprobado. **Fuente:** Video 05:40–06:12.

**Evidencia:** Benny C., B ELITE, muestra 500 monedas / 7%, +1 por 5 créditos / 100% y MAX por 12 créditos / 100%. Se ven fallos y luego +1 con AVG .339 → .349.

**Actualmente:** El remake usa 2,500 monedas, probabilidad inicial 80%, +1 por 3 créditos y MAX calculado a 3 por nivel restante. El aumento de .010 por +1 ya existe.

**Trabajo pendiente:** Reconstruir la tabla por clase, grado y mejora. No generalizar el precio MAX de esta única carta a todas.

**Código contrastado:** [src/com/bh/model/GameData.as:1904](src/com/bh/model/GameData.as), [src/com/bh/model/SpecialCardInventory.as:54](src/com/bh/model/SpecialCardInventory.as), [src/com/bh/ui/CardWorkshopOverlay.as:105](src/com/bh/ui/CardWorkshopOverlay.as).

**Capturas:** [05:40](reference_visual/facebook_play_20261012/frame-0340.0.png), [05:44](reference_visual/facebook_play_20261012/frame-0344.0.png), [06:04](reference_visual/facebook_play_20261012/frame-0364.0.png).

### 6. Completar los sobres originales y sus variantes

**Estado:** Incompleto. **Fuente:** Video 03:40–03:48; PDF p. 2.

**Evidencia:** El video muestra C, B++, B, B+, A, A+ y A++; C cuesta 5,000 monedas. El PDF registra otro gameplay con C a 6,000 y B+ / A+ a 12 / 32 créditos.

**Actualmente:** El catálogo especial ofrece C, B, A y S; C a 6,000, los otros a 25 / 56 / 72 créditos.

**Trabajo pendiente:** Añadir las variantes observadas y decidir una versión de referencia coherente. No mezclar precios de épocas distintas ni cambiar automáticamente el C Pack inicial.

**Código contrastado:** [src/com/bh/model/SpecialCardCatalog.as:65](src/com/bh/model/SpecialCardCatalog.as), [src/com/bh/ui/BatterShopOverlay.as:357](src/com/bh/ui/BatterShopOverlay.as).

**Capturas:** [03:40](reference_visual/facebook_play_20261012/frame-0220.0.png), [03:44](reference_visual/facebook_play_20261012/frame-0224.0.png), [03:48](reference_visual/facebook_play_20261012/frame-0228.0.png).

### 7. Revisar qué grados admite cada clase

**Estado:** Ajuste comprobado / conflicto. **Fuente:** Video 03:40; PDF pp. 1–2.

**Evidencia:** La ayuda de la tienda dice: Hero Grade exists only in S and A Class. El PDF describe cuatro grados para todas las clases.

**Actualmente:** El remake contiene cartas C HERO y B HERO y permite obtener HERO en cualquier sobre de clase.

**Trabajo pendiente:** Resolver la diferencia entre versiones y limitar los nuevos sorteos según la referencia elegida, conservando las cartas que ya posee el usuario.

**Código contrastado:** [src/com/bh/model/SpecialCardCatalog.as:7](src/com/bh/model/SpecialCardCatalog.as), [src/com/bh/model/SpecialCardCatalog.as:73](src/com/bh/model/SpecialCardCatalog.as).

**Capturas:** [03:40](reference_visual/facebook_play_20261012/frame-0220.0.png).

### 8. Sustituir el catálogo de cartas reconstruidas por fichas observadas

**Estado:** Incompleto. **Fuente:** Video 02:48, 03:44, 04:59 y 06:04.

**Evidencia:** Se leen Howard D., Billie K., Marvin K., Garret D., John G., Darren S. y Benny C., con retratos, AVG, Combo, entrada y porcentaje de activación.

**Actualmente:** Clases, grados, copias y disparadores ya funcionan. Gran parte del catálogo usa nombres y atributos creados para el remake; esas siete fichas no están en SpecialCardCatalog.

**Trabajo pendiente:** Registrar e integrar las fichas visibles con sus propios datos e ilustraciones. Lo ilegible debe quedar pendiente, sin inventarlo como original.

**Código contrastado:** [src/com/bh/model/SpecialCardCatalog.as:7](src/com/bh/model/SpecialCardCatalog.as), [src/com/bh/game/SpecialAbilityResolver.as:1](src/com/bh/game/SpecialAbilityResolver.as).

**Capturas:** [03:44](reference_visual/facebook_play_20261012/frame-0224.0.png), [04:59](reference_visual/facebook_play_20261012/frame-0299.0.png), [05:13](reference_visual/facebook_play_20261012/frame-0313.0.png), [06:04](reference_visual/facebook_play_20261012/frame-0364.0.png).

### 9. Completar familias, bonos y precios del equipamiento

**Estado:** Incompleto. **Fuente:** Video 04:04–04:24.

**Evidencia:** Se ven Sleepy Bear, Spider, Purple Star, Blue Lightning, Blue Bomber, Camo, Pink Love y Panda. Hay guantes de 10,000; accesorios de 6,280 o 35 créditos; bates Breaker de 31,000 y otros de 59 créditos. Cada ficha muestra dos bonos.

**Actualmente:** Las seis categorías y el preview existen, pero EquipmentCatalog contiene familias y estadísticas reconstruidas. Ejemplo: sus colecciones suelen potenciar un solo atributo.

**Trabajo pendiente:** Transcribir artículo por artículo, incluidos requisitos, dos bonos, moneda y apariencia al equipar. No basta con añadir más objetos genéricos.

**Código contrastado:** [src/com/bh/model/EquipmentCatalog.as:4](src/com/bh/model/EquipmentCatalog.as), [src/com/bh/ui/EquipmentScreen.as:34](src/com/bh/ui/EquipmentScreen.as).

**Capturas:** [04:04](reference_visual/facebook_play_20261012/frame-0244.0.png), [04:12](reference_visual/facebook_play_20261012/frame-0252.0.png), [04:20](reference_visual/facebook_play_20261012/frame-0260.0.png), [04:24](reference_visual/facebook_play_20261012/frame-0264.0.png).

### 10. Recompensas y desbloqueos reales de LEVEL UP

**Estado:** Ajuste comprobado. **Fuente:** Video 00:00.

**Evidencia:** Al llegar a nivel 12 aparecen 1 SKILL POINT, 3,000 COINS y 8 NEW GEARS UNLOCKED; se ilustran Panda, Pink Love y Camo.

**Actualmente:** Hay ventana y desbloqueos, pero applyLevelProgress entrega 2,000 monedas y aumenta la capacidad de energía en uno por cada nivel. El catálogo no reproduce esos ocho desbloqueos.

**Trabajo pendiente:** Reconstruir premios y desbloqueos por nivel. Esta captura confirma nivel 12, no una recompensa universal ni el tope de energía.

**Código contrastado:** [src/com/bh/model/GameData.as:2750](src/com/bh/model/GameData.as), [src/com/bh/model/GameData.as:2785](src/com/bh/model/GameData.as), [src/com/bh/ui/LevelUpOverlay.as:50](src/com/bh/ui/LevelUpOverlay.as).

**Capturas:** [00:00](reference_visual/facebook_play_20261012/frame-0000.0.png).

### 11. Corregir el cálculo de RANK

**Estado:** Ajuste comprobado. **Fuente:** Video 03:20 y 08:36; PDF pp. 1–3.

**Evidencia:** Victoria 6–0, 17 hits de equipo: RANK A. Victoria 3–0, 15 hits: RANK B. El PDF propone otros umbrales y reconoce desconocer B/C.

**Actualmente:** MatchScoring.grade(17,6) devuelve B; grade(15,3) devuelve C.

**Trabajo pendiente:** Registrar más partidos y ajustar una regla compatible con ambos ejemplos y con las demás grabaciones. Estos dos casos no revelan toda la tabla.

**Código contrastado:** [src/com/bh/model/MatchScoring.as:24](src/com/bh/model/MatchScoring.as).

**Capturas:** [03:20](reference_visual/facebook_play_20261012/frame-0200.0.png), [08:36](reference_visual/facebook_play_20261012/frame-0516.0.png).

### 12. MVP del equipo y premio correspondiente

**Estado:** Ajuste comprobado. **Fuente:** Video 03:16–03:20.

**Evidencia:** El resultado concede MVP y señala un compañero, aunque la fila YOU muestra 2 HIT, 0 HR y 1 RBI.

**Actualmente:** El remake solo activa el premio cuando el héroe tiene al menos 3 RBI; puede mostrar otro mvpName sin conceder ese premio.

**Trabajo pendiente:** Separar la elección del MVP del equipo y la condición del premio, y contrastar más resultados. El PDF también simplifica el criterio a 3+ RBI.

**Código contrastado:** [src/com/bh/model/MatchScoring.as:26](src/com/bh/model/MatchScoring.as).

**Capturas:** [03:16](reference_visual/facebook_play_20261012/frame-0196.0.png), [03:20](reference_visual/facebook_play_20261012/frame-0200.0.png).

### 13. Más variantes de las cinemáticas y movimientos

**Estado:** Fidelidad incompleta. **Fuente:** Video 03:00–03:04, 07:00, 07:20, 08:00 y 08:20.

**Evidencia:** Distintas poses del defensor, acercamiento al guante, panel diagonal defensor / llegada a base y fondos con flechas, dianas y manchas; no todos los hits usan exactamente el mismo cuadro.

**Actualmente:** Ya tenemos fildeo, corredor, panel diagonal, palabras y celebraciones. Varias poses, proporciones, fondos y transiciones siguen siendo reconstrucciones; la elección de celebración usa índices fijos por resultado.

**Trabajo pendiente:** Ampliar variantes y ajustar composición y duración por acción. Conservar la cabeza 0.8.6 aprobada por el usuario.

**Código contrastado:** [src/com/bh/game/HitCinematic.as:374](src/com/bh/game/HitCinematic.as), [src/com/bh/visual/OutSplitScene.as:1](src/com/bh/visual/OutSplitScene.as), [src/com/bh/visual/FieldingSprite.as:1](src/com/bh/visual/FieldingSprite.as).

**Capturas:** [03:00](reference_visual/facebook_play_20261012/frame-0180.0.png), [03:04](reference_visual/facebook_play_20261012/frame-0184.0.png), [07:00](reference_visual/facebook_play_20261012/frame-0420.0.png), [07:20](reference_visual/facebook_play_20261012/frame-0440.0.png), [08:00](reference_visual/facebook_play_20261012/frame-0480.0.png), [08:20](reference_visual/facebook_play_20261012/frame-0500.0.png).

### 14. STRETCHING y LIFTING con sus propios entrenadores

**Estado:** Falta. **Fuente:** Documento y grabaciones de apoyo: final 00:12–00:39.

**Evidencia:** El nuevo video no entra a entrenamiento. El PDF describe RUNNING; las capturas ya archivadas del otro gameplay muestran STRETCHING y LIFTING y descansos simultáneos.

**Actualmente:** RunningTrainingRoom permite RUNNING y ATTRIBUTES, sin catálogos ni relojes independientes para esas otras dos disciplinas.

**Trabajo pendiente:** Implementar actividades, progreso, recompensas y descansos separados. Los puestos cuarto y quinto todavía no están identificados.

**Código contrastado:** [src/com/bh/ui/RunningTrainingRoom.as:27](src/com/bh/ui/RunningTrainingRoom.as), [src/com/bh/model/GameData.as:960](src/com/bh/model/GameData.as).

### 15. Mastery: estrellas, límite MASTER y premio de 5 ENERGY

**Estado:** Falta completar. **Fuente:** Grabaciones de apoyo: final 00:13–00:30; PDF p. 2.

**Evidencia:** En las referencias previas hay tramos Beginner / Expert / Pro, cuatro estrellas por tramo y una recompensa final de 5 ENERGY. MASTER no impide seguir entrenando ni elimina el descanso.

**Actualmente:** El remake usa pasos ilimitados de 1,350 de mastery y entrega 2 SKILL POINTS por paso; no tiene ese cierre y premio final.

**Trabajo pendiente:** Reconstruir las etapas observadas y cobro único por disciplina, conservando progreso existente. No conocemos aún toda la curva.

**Código contrastado:** [src/com/bh/ui/RunningTrainingRoom.as:108](src/com/bh/ui/RunningTrainingRoom.as), [src/com/bh/model/GameData.as:988](src/com/bh/model/GameData.as).

### 16. Alinear los precios de las seis sesiones de RUNNING

**Estado:** Ajuste documental por contrastar. **Fuente:** PDF p. 2.

**Evidencia:** El documento registra costos 120 / 350 / 600 / 800 / 1,500 / 1,800, con duraciones 1 / 4 / 8 / 12 / 24 / 48 h.

**Actualmente:** El remake usa 90 / 250 / 400 / 550 / 1,000 / 1,250; las duraciones y pares de recompensas coinciden con lo transcrito.

**Trabajo pendiente:** Revisar los cuadros originales que sustentan el PDF y aplicar los precios de la versión elegida. El video nuevo no muestra estas actividades.

**Código contrastado:** [src/com/bh/model/GameData.as:960](src/com/bh/model/GameData.as).

### 17. Opción de personaje femenino

**Estado:** Falta; referencia fuera del video nuevo. **Fuente:** PDF p. 2 y referencia del creador enviada anteriormente.

**Evidencia:** El documento incluye selección de sexo; la captura anterior de CHARACTER MAKING tiene botón Female. Este video no entra al creador.

**Actualmente:** CharacterMakerScreen guarda forma, pelo, ojos, nariz, boca, colores y ETC; no tiene selección de sexo ni un cuerpo femenino jugable.

**Trabajo pendiente:** Añadir apariencia y animaciones coherentes en creación, HOME y partido, sin modificar la cabeza masculina ya aprobada.

**Código contrastado:** [src/com/bh/ui/CharacterMakerScreen.as:49](src/com/bh/ui/CharacterMakerScreen.as), [src/com/bh/ui/CharacterMakerScreen.as:77](src/com/bh/ui/CharacterMakerScreen.as).

### 18. Terminar de calibrar las pichadas por liga

**Estado:** Por medir. **Fuente:** Video 01:35–03:00 y 06:28–08:20; PDF pp. 2–3.

**Evidencia:** Esta cuenta juega en A, nivel 12: aporta una liga distinta de Rookie y AAA. Se ven nombres, velocidades, trayectoria y EARLY / VERY LATE SWING.

**Actualmente:** Hay tipos, movimiento y cadencia por liga, pero parte del repertorio y las ventanas son aproximaciones.

**Trabajo pendiente:** Medir salida de mano → plato y registrar tipo / mph / zona / swing. No acelerar Rookie ni sustituir mediciones por la fórmula propuesta 90300/mph.

**Código contrastado:** [src/com/bh/game/PitchCadence.as:1](src/com/bh/game/PitchCadence.as), [src/com/bh/game/BattingSystem.as:1](src/com/bh/game/BattingSystem.as).

**Capturas:** [01:35](reference_visual/facebook_play_20261012/frame-0095.0.png), [02:36](reference_visual/facebook_play_20261012/frame-0156.0.png), [07:36](reference_visual/facebook_play_20261012/frame-0456.0.png), [07:48](reference_visual/facebook_play_20261012/frame-0468.0.png).

### 19. Calibrar CONTACT, POWER, LUCK, COMBO y simulación

**Estado:** Por medir. **Fuente:** Video: partidos completos; PDF pp. 1 y 3.

**Evidencia:** La grabación permite distinguir turnos propios y de compañeros, estados de COMBO y activaciones de cartas; el PDF identifica el efecto cualitativo de los atributos.

**Actualmente:** Estos sistemas existen; sus multiplicadores y probabilidades no son tablas recuperadas del servidor original.

**Trabajo pendiente:** Contabilizar resultados por timing, zona, atributo, combo y tipo de turno. Los porcentajes de la sección 4 del PDF son propuestas, no datos originales.

**Código contrastado:** [src/com/bh/model/MatchMomentum.as:1](src/com/bh/model/MatchMomentum.as), [src/com/bh/game/BattingSystem.as:1](src/com/bh/game/BattingSystem.as), [src/com/bh/core/Game.as:732](src/com/bh/core/Game.as).

### 20. Curva de XP, energía y requisitos de ascenso

**Estado:** Por confirmar. **Fuente:** PDF pp. 2–3 y HUD del video.

**Evidencia:** El PDF reconoce que faltan curva completa, capacidad / recuperación de energía y temporadas para ascender. Propone tres temporadas y ocho minutos, sin confirmación.

**Actualmente:** El remake usa XP 180 + 20 por nivel, +1 de capacidad por nivel, recuperación cada 5 minutos y ascenso con top 4 y 18 victorias.

**Trabajo pendiente:** Medir y documentar las curvas antes de cambiar cuentas. No aplicar automáticamente las hipótesis del PDF.

**Código contrastado:** [src/com/bh/model/GameData.as:2750](src/com/bh/model/GameData.as), [src/com/bh/model/GameData.as:4675](src/com/bh/model/GameData.as), [src/com/bh/model/AccountEnergy.as:6](src/com/bh/model/AccountEnergy.as).

### 21. Energía y sorteos de cartas / cajas por versión

**Estado:** Por confirmar. **Fuente:** Video 03:44 y 06:04; PDF pp. 1–3.

**Evidencia:** Aquí las cartas muestran 2/2 y 0/2. El PDF también registra 4/4 en otras grabaciones, y no conoce las probabilidades completas de sobres / cajas.

**Actualmente:** Todas nuestras cartas tienen capacidad 2, recuperación de 3 h y pesos de sorteo reconstruidos. Las cajas y llaves ya existen.

**Trabajo pendiente:** Determinar cuándo cambia la capacidad y medir las tablas. No deducir C=1, B=2, A=3, S=4: el propio PDF lo marca como propuesta.

**Código contrastado:** [src/com/bh/model/SpecialCardInventory.as:4](src/com/bh/model/SpecialCardInventory.as), [src/com/bh/model/SpecialCardCatalog.as:73](src/com/bh/model/SpecialCardCatalog.as), [src/com/bh/model/MysteryCatalog.as:1](src/com/bh/model/MysteryCatalog.as).

**Capturas:** [03:44](reference_visual/facebook_play_20261012/frame-0224.0.png), [06:04](reference_visual/facebook_play_20261012/frame-0364.0.png).

### 22. ALL STAR y WORLD MATCH

**Estado:** Falta; no documentado en estas dos fuentes. **Fuente:** Inventario de 0.10.6; sin evidencia nueva en el video / PDF.

**Evidencia:** No se abren en este video y el documento no describe sus reglas. Son pendientes conocidos del inventario actual, no un descubrimiento de esta grabación.

**Actualmente:** ModeSelectScreen muestra ambos deshabilitados.

**Trabajo pendiente:** Mantenerlos en el inventario, pero buscar una referencia de su funcionamiento antes de afirmar que una implementación reproduce el original.

**Código contrastado:** [src/com/bh/ui/ModeSelectScreen.as:112](src/com/bh/ui/ModeSelectScreen.as).

## Lo que ya existe y no se debe volver a contar como ausente

Inicio en nivel 1 y ROOKIE; equipo y creador; metas HIT/RBI para carreras nuevas; C Pack y tutorial persistentes; reparto C/P/L; misión de 40,000; temporada de 30 partidos; postemporada; RIVAL y liga privada; cartas clase × grado; cinco slots; trade/enhance; seis categorías de equipo y preview; BUILD e ingresos; cajas y llaves; COMBO; resultados y estadísticas; fildeo y panel diagonal. Lo pendiente es completar o alinear estos sistemas, según la lista.

Los tutoriales y consejos en español se mantienen. También se conserva la cabeza 0.8.6 aprobada.

## Orden recomendado

Primero 4, 5, 10, 11 y 12 (diferencias pequeñas, visibles y con evidencia directa); después 1, 2 y 3 (un bloque social significativo); luego 6–9 y 14–16. Las mediciones 18–21 deben preceder cualquier rebalanceo amplio.

## Límites

La lista no afirma recuperar el código original. Las dos fuentes se contradicen en grados y economía; un caso observado no revela todas las probabilidades. La disciplina de los puestos cuarto/quinto, la tabla completa de ascensos, los topes de energía y las reglas de ALL STAR / WORLD MATCH siguen sin confirmarse. No se ha analizado la pista de audio de este MP4.
