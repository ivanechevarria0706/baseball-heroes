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
| HOME: distribución y franja inferior | Reconstruidas en 0.6.3; iconos, tipografía y arte todavía distintos |
| Inventario de bateadores, TRADE y ENHANCE | Distribución reconstruida en 0.6.3; faltan texturas/iconos exactos y correspondencia completa del catálogo |
| Héroe de HOME, bateador y lanzador | Siguen usando reconstrucciones previas; no son los sprites animados originales |
| Compañeros de HOME | Usan ilustraciones de las hojas aportadas; la asignación a nombres locales es aproximada |
| Estadios | Conservan los fondos disponibles y las reconstrucciones previas; no todos coinciden con el estadio del video |
| Equipamiento, tienda general, LINEUP, entrenamiento y selección de modos | Pendientes de la misma reconstrucción de composición |
| Partido, marcador, resultados y celebraciones | Pendiente de revisión visual completa contra secuencias concretas |
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
