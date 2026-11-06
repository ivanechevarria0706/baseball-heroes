# Web 0.9.2 — Partido, condición y animaciones

WALK-OFF, puntuación por jugada, cinco premios, energía individual, equipo 30/50/70 y +400, tres historias HR, FACE ETC y cuatro efectos adicionales. Arte, catálogo y audio aún tienen partes pendientes. Cabeza 0.8.6 intacta. [Comparación](COMPARACION_MEJORAS_092.html) · [Cambios y pruebas](REVISION_MEJORAS_092.md).

# Web 0.9.1 — Mystery Boxes y llaves

Inventario guardado, apertura con dos/tres llaves, premios pendientes que sobreviven a recarga y sobres ganados. SPECIAL/RIVAL y roadmap conectados a los premios. Cabeza 0.8.6 intacta. [Comparación](COMPARACION_MYSTERY_091.html) · [Cambios y pruebas](REVISION_MYSTERY_091.md).

# Web 0.9.0 — Hall of Fame y misiones de rendimiento

Ocho logros de carrera con cuatro niveles, premios reclamables una vez, contadores permanentes y dos misiones observadas en los gameplays. Cabeza del bateador 0.8.6 intacta. [Comparación](COMPARACION_HALL_OF_FAME_090.html) · [Cambios, pruebas y límites](REVISION_HALL_OF_FAME_090.md).

# Web 0.8.9 — cabeza 0.8.6 y postemporada jugable

Cabeza del bateador restaurada y fijada por preferencia del usuario. POST SEASON con cuadro de ocho clubes CPU, series de tres victorias, progresión hasta el campeonato e historial guardado. [Comparación](COMPARACION_POSTEMPORADA_089.html) · [Cambios, pruebas y límites](REVISION_POSTEMPORADA_089.md).

# Web 0.8.8 — swing y cuerpos intermedios

Ocho poses ilustradas nuevas para avance, remate detrás de los hombros y regreso. Cabeza personalizada intacta; dorsal sobre la camiseta y unido a la inclinación; contacto y duración del swing comprobados. [Comparación](COMPARACION_SWING_088.html) · [Pruebas y origen del arte](REVISION_SWING_088.md).

# Web 0.8.7 — perfil y giro al batear

Trece vistas de la misma cabeza acompañan preparación, contacto y reacción; casco y orejera conservan volumen entre vistas. Giro progresivo sobre el cuello, rasgos guardados intactos y contacto/tiempos de swing comprobados. [Comparación](COMPARACION_GIROS_087.html) · [Pruebas y límites](REVISION_GIROS_087.md).

# Web 0.8.6 — rostro y expresiones

Iris de color con pupilas negras, párpados y cejas definidos; ocho narices y bocas diferenciadas; parpadeo, frustración y celebración coordinados. Publicado y probado con la identidad guardada intacta y una muestra de partido cercana a 60 FPS. [Comparación](COMPARACION_ROSTRO_086.html) · [Pruebas y límites](REVISION_ROSTRO_086.md).

# Web 0.8.5 — ocho formas de cabeza

Contornos ajustados a la nueva captura del original: coronilla ovalada, mejillas y barbilla diferenciadas. SHAPE muestra cabezas sin cabello y nombres originales; los peinados encajan sobre el nuevo ancho. Publicado y probado desde el registro hasta el primer partido, conservando la identidad guardada. [Comparación](COMPARACION_FORMAS_085.html) · [Pruebas y límites](REVISION_FORMAS_085.md).

# Web 0.8.4 — cabeza y cuerpo

Cara más ancha y baja, cuello sin duplicación y piel coherente entre cabeza y cuerpo. Corrección publicada y probada desde el registro hasta el primer partido. Archivo parcial de 38 imágenes oficiales del visor y 330 recursos de galería, con procedencia y calidad diferenciadas. [Comparación](COMPARACION_CABEZA_084.html) · [Fotos recuperadas](CATALOGO_FOTOS_OFICIALES_084.html) · [Pruebas y límites](REVISION_CABEZA_084.md).

# Web 0.8.3 — personaje compartido e ilustrado

Creador, HOME, retratos y bateador conservan los ocho rasgos del mismo héroe. Ocho peinados y cuerpos modulares ilustrados nuevos; recortes, anclajes y márgenes corregidos. Publicado y probado en Chrome, sin reiniciar carreras. [Comparación](COMPARACION_PERSONAJE_083.html) · [Pruebas y límites](REVISION_PERSONAJE_083.md).

# Fidelidad visual — revisión completa en curso

## Objetivo del usuario

Que **todo Baseball Heroes** se vea como el original: HOME, menús, inventario, jugadores y partido. Tener los sistemas implementados no demuestra semejanza visual. Cada escena debe contrastarse con una referencia original, no únicamente con la versión anterior del remake.

## Cambio de criterio en 0.6.3

Se reconstruye la distribución de HOME y del inventario tomando como referencia directa los gameplays aportados. El código de temporada, cartas, guardado, economía y partido de 0.6.2 se mantiene. No se añaden modos ni fórmulas en esta entrega.

En el inventario, la pantalla oscura anterior se sustituye por el estadio de fondo, el marco azul, SHOP/INVENTORY arriba, una cuadrícula de tres columnas y dos filas y el panel gris lateral de TRADE/ENHANCE. Los tres ejemplares del intercambio ocupan las posiciones del video; sus huecos muestran SELECTED CARD. ENHANCE recupera la máquina central y sus tres botones de coste. Confirmar, cancelar, comprar, recargar y desbloquear slots siguen funcionando.

Las cartas recuperan el color por **clase**, el grado y sus estrellas arriba, AVG/habilidad/combo dentro del retrato y energía en el pie. El grado local A se rotula NORM como en estos videos. Esto solo cambia el rótulo, no el catálogo ni sus probabilidades.

HOME vuelve a colocar los jugadores como personajes pequeños sobre el campo, el héroe a la derecha, PLAY BALL y el avance de temporada sobre la franja inferior de tarjetas. La cámara de HOME/inventario se adapta para que el plato y los jugadores estén a las alturas observadas. Las trece rutas previas permanecen accesibles.

## Estado real de la revisión completa

| Zona | Estado |
|---|---|
| HOME: distribución y franja inferior | Composición revisada en web 0.7.3: iconos, fuentes incorporadas, seis tarjetas por página y TRAIN; faltan recursos exactos |
| Inventario de bateadores, TRADE y ENHANCE | Distribución reconstruida en 0.6.3; faltan texturas/iconos exactos y correspondencia completa del catálogo |
| Héroe de HOME, bateador y lanzador | Siguen usando reconstrucciones previas; no son los sprites animados originales |
| Compañeros de HOME | Ocho compañeros con ilustraciones de las hojas aportadas; correspondencia con retratos iniciales corregida en 0.7.3; otros nombres conservan asignación aproximada |
| Estadios | Seis fondos ilustrados visibles completos desde 0.7.3, con campo de respaldo ante errores; falta el arte exacto de ROOKIE |
| Entrenamiento | Sala ilustrada y panel RUNNING de seis actividades reconstruidos en web 0.7.1; faltan otras disciplinas, animaciones y fuentes exactas |
| LINEUP | Composición reconstruida contra el gameplay en web 0.7.2; fuentes incorporadas como sustitutos; faltan avatares originales y energía individual |
| Equipamiento | Composición reconstruida en web 0.7.5: inventario azul, cuadrícula paginada, héroe sobre el estadio, barras y vista previa; faltan las siluetas exactas |
| Tienda de equipamiento | Composición reconstruida en web 0.7.6; vista previa del héroe y atributos, filtros, compra e INVENTORY; faltan arte/catalogación/requisitos exactos |
| Calendario de temporada | Composición reconstruida en web 0.7.7: cinco tarjetas, historial, barra de treinta juegos y regreso al próximo partido; faltan texturas, HOME/AWAY y eventos originales |
| Metas y cambio de temporada | Flujo corregido en web 0.7.8: cierre/ascenso, calendario nuevo antes de previa y metas de la liga actual con entrenador ilustrado; diálogo y mapa exactos pendientes |
| Tienda de estadio/energía y selección de modos | Pendientes de la misma reconstrucción de composición |
| Partido, marcador, resultados y celebraciones | Siete ilustraciones completas recuperadas en web 0.8.0; cuatro integradas según el resultado. Encuadre/ritmo y animaciones originales aún pendientes |
| Fuentes, iconos y animaciones pequeñas | Aún no se han recuperado los recursos originales completos |

**No es todavía una copia visual exacta.** Los cambios de distribución son comprobables, pero no sustituyen las ilustraciones, la tipografía y los cuadros de animación que faltan. No se presenta un porcentaje inventado de fidelidad.

## Referencias y recursos

- Gameplay «Vamos En Primer Lugar Y Explicando Algunas Cositas»: HOME 00:10; inventario/TRADE 10:00–10:35; ENHANCE 12:40–13:28.
- Gameplay «Seguimos En Primer Lugar»: ENHANCE en 12:40, captura de 1280 × 720.
- Hojas 11_05, 11_06, 11_07, 11_08, 11_09 y 11_11 aportadas por el usuario; los atlas y recortes existentes se conservan.
- [Portafolio público de Jaein Park, Baseball Heroes Game Art / Syntasia](https://www.behance.net/gallery/61575435/Baseball-Heroes-Game-Art-Syntasia): se confirmó como referencia de arte y capturas. No contiene un cliente completo recuperado en esta revisión.
- [Comunicado original de Syntasia](https://www.prlog.org/11752744-baseball-heroes-free-to-play-baseball-game-on-facebook-commencing-its-closed-beta-test.html): referencia histórica del juego y su material de prensa. La búsqueda pública realizada no ha proporcionado un cliente Flash completo verificable; esto no demuestra que no exista otra copia.

La comparación permite ver los fotogramas con su proporción de video o ajustados al lienzo 4:3 del remake. No se ha pegado una captura como fondo de la interfaz: tarjetas, textos, recursos, botones y resultados son controles reales de AIR.

## Pruebas

- Rutas reales desde Main: trece callbacks de HOME, doce pantallas, retorno con ESC, escalado 4:3, fichas de jugador, reordenación de LINEUP y entrada al partido.
- Inventario: seis cartas por página, acceso a los 33 tipos, filtros por clase/grado, última página, equipar, selección individual, TRADE, ENHANCE, recarga, confirmaciones repetidas y desbloqueo/cancelación de slot.
- Tienda: fondos, compra de un sobre, doble pulsación, revelado por teclado, actualización del ejemplar comprado y cierre.
- Compatibilidad: los modelos, el motor del partido, el esquema v21 y los cuatro sonidos del usuario se comparan con el ZIP 0.6.2. Las pruebas usan identidades AIR separadas y no abren el guardado real.

Los informes vigentes están en revision_manifest.json; los de otras versiones son históricos. El archivo COMPARACION_FIDELIDAD.html muestra original, versión anterior y versión actual, además de lo que continúa pendiente.

HOME web 0.7.3: comparación en `COMPARACION_HOME_073.html` y límites/pruebas en `REVISION_HOME_073.md`.

Recortes web 0.7.9: 60 recursos reconstruidos desde las láminas originales; vehículos completos y correctamente asignados, emblemas sin recorte cuadrado, modos/logos sin fragmentos vecinos y sobres con tinta/transparencia originales. Las bandas de celebración antiguas siguen pendientes de recuperar su fuente completa. Comparación en `COMPARACION_RECORTES_079.html`; auditoría y límites en `REVISION_RECORTES_079.md`.

Celebraciones web 0.8.0: resuelve las bandas pendientes señaladas en 0.7.9 con la fuente completa del artista. Comparación en `COMPARACION_CELEBRACIONES_080.html`; fuentes, medidas y límites en `REVISION_CELEBRACIONES_080.md`.

Viaje web 0.8.1: mapa compartido con relieve y divisiones reconstruidos desde el gameplay; ciudades/rutas coherentes, reloj independiente de FPS y cancelación única. Comparación en `COMPARACION_VIAJE_081.html`; límites y pruebas en `REVISION_VIAJE_081.md`. El mapa fuente exacto sigue pendiente.

Inicio 082: acceso, selección, creador, entrenador y nombre revisados. Comparación en COMPARACION_INICIO_082.html; límites en REVISION_INICIO_082.md. CreationArtwork sigue siendo una reconstrucción nativa; faltan los cuadros y variantes originales.
