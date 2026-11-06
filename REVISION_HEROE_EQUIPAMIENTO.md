# Héroe frontal y equipamiento — versión 0.6.1

HOME, EQUIPMENT y los retratos del héroe comparten ahora una ilustración frontal. Sustituye el cuerpo vectorial de HOME y el retrato con barras de color que usaba EQUIPMENT.

## Comportamiento

- Cuatro poses: espera, parpadeo, saludo y alegría. HOME saluda al entrar y parpadea periódicamente. Las poses están ancladas en los pies y la animación depende del tiempo transcurrido.
- Se adaptan los colores de uniforme, casco, bate, guante, cinturón, zapatos, pelo, ojos y piel. Las gafas se superponen por separado, con dos formas según el grado, para mantener visibles ojos y parpadeo. Se conserva el dorsal.
- Los retratos pequeños del héroe usan el mismo rostro, también en perfiles, alineación y HUD del partido.
- EQUIPMENT muestra el cuerpo entero. Seleccionar un objeto activa TRY ON y calcula el cambio de estadísticas respetando el límite de 99. La franja inferior sigue mostrando el equipo realmente aplicado.
- Probar un objeto no modifica equipo, monedas ni guardado. EQUIP aplica la selección. El botón queda inactivo cuando ese objeto ya está equipado. Al cambiar de categoría o volver a abrir la pantalla, se selecciona el objeto actualmente equipado en esa categoría.
- El cambio de pantalla libera los sprites de la vista previa. Los cuadros se comparten por colores y solo se conservan cuatro paletas inactivas en caché; destruir un retrato no borra las imágenes que utiliza otro.

## Arte y procedencia

`assets/sprites/v061/home-atlas.png` es una reconstrucción nueva creada con la herramienta integrada image_gen, usando el bateador de v0.6.0 como referencia de estilo. Tiene 1254 × 1254 píxeles, canal alfa y cuatro figuras. No es una recuperación de sprites originales de Syntasia. El prompt exacto está en `assets/sprites/v061/PROMPT.md`; los límites medidos, anclajes y hash están junto al PNG.

El PNG se conserva sin editar. El juego recorta y adapta colores en memoria. Las gafas y el número se dibujan como capas separadas. Las formas de casco, bate, guante y zapatos siguen siendo comunes entre objetos; aún no son un catálogo completo de siluetas. Las selecciones de rasgos y peinados del creador de personajes se conservan en los datos, pero este actor frontal todavía usa una forma de cara y pelo compartida; sí refleja sus colores.

Las láminas aportadas siguen archivadas y las 32 ilustraciones de cartas integradas en v0.6.0 se conservan. No se añadieron disfraces de `11_11.png` a esta entrega ni se presentan como ya disponibles.

## Validación

Pruebas AIR con identidades separadas de la partida real:

- Cuatro poses, reproducción a 15 y 60 fps, tres tamaños de retrato y variaciones de color. Cada una de las seis categorías de equipo cambia píxeles visibles.
- Probar, cerrar y volver a abrir sin equipar conserva el guardado. Aplicar las seis categorías y recargar mantiene la selección. La pulsación repetida de EQUIP es inocua y el cálculo de cambios respeta el máximo de 99.
- HOME, perfiles, alineación, sustituciones, arrastre, tienda, guardado de alineación y entrada a partido mediante Main. Los menús conservan escalado uniforme 4:3 y regreso mediante ESC.
- Partido en Rookie y Major, contacto real con SPACE, resultado y vuelta a simulación con el nuevo retrato del HUD.
- Comparación del código de modelo, motor de partido, timing, audio y sprites de bateo contra v0.6.0; sin cambios. Comprobación de los cuatro WAV originales y los MP3 instalados mediante hashes.

Los informes actuales figuran en `revision_manifest.json`; los restantes son historial. Algunas capturas muestran objetos QA creados exclusivamente en partidas aisladas para cubrir las seis categorías. No se agregan al inventario del jugador.

## Abrir

Ejecuta `JUGAR.bat` para usar el SWF incluido. `COMPARACION_EQUIPAMIENTO.html` permite revisar capturas, poses y retratos. Se conserva el identificador de la aplicación y el esquema de guardado v20. No se modifican recompensas, probabilidades, precios ni progreso de temporada.
