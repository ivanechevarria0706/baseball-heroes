# Baseball Heroes 1.0.9 — inicio y gestión de toda la plantilla

Actualización del 15 de octubre de 2026. Conserva progreso, equipamiento y cabeza 0.8.6.

1. **Selección de equipo.** Paneles claros con bisel, fichas de los 27 equipos y título ajustado. El panel se dibuja encima del mapa para que conserve su fondo. El equipo elegido se guarda únicamente al pulsar SELECT.

2. **Nombre y número.** Ventana con papel claro, estrellas discretas como en la referencia y campos hundidos. Título legible, cierre y confirmación identificables. Ayudas y validaciones en español; etiquetas en inglés. Al cerrar sin confirmar se conservan los datos.

3. **Desarrollo con el mismo acabado.** TRADE & ENHANCE usa el estadio, marcos clásicos, retrato, indicadores y barras con relieve. Las mejoras muestran el atributo y su precio completo, separados de la acción de intercambio.

4. **Toda la plantilla accesible.** El límite anterior de 12 jugadores visibles se sustituye por páginas de 12. Consultar o cambiar de página no gasta Coins. El jugador seleccionado siempre corresponde a la página visible.

5. **Operaciones claras y guardadas.** Los precios, +1 al atributo, 25 XP, cambio de nivel y valor de intercambio proceden del modelo existente. Se comprueban Coins y límite del atributo antes de mejorar. El héroe y el mínimo de nueve jugadores siguen protegidos. Al vaciar la última página se vuelve a una página válida.

Selección y nombre del equipo comparados con `reference_visual/onboarding_20261005/equipo.jpg` y `nombre.jpg`. El panel de desarrollo de jugadores regulares es una adaptación al marco clásico, no una pantalla exacta recuperada. No se cambian fórmulas, precios, premios, catálogo ni reglas de temporada.

Solo cambian TeamSelectionScreen, TeamNameScreen y TradeEnhanceScreen. Guardado v23 / SQLite v4, servidor y sprites sin cambios. Sin migración ni reinicio. Pruebas privadas con 29 jugadores y prueba real del jugador 13 con cuentas sintéticas. Se conservan las ilustraciones aprobadas.

Publicación verificada: build `4b22b9f99946a738`. Dos suites locales y una en HTTPS aprobadas. 27 equipos sin gasto en vistas previas, formulario de nombre y número, flujo real equipo-creador-llegada, 29 jugadores en tres páginas, entrenamiento del jugador 13, cambio de nivel y punto, intercambio con ajuste de página, héroe y mínimo de nueve protegidos, guardado y recarga. Se retiraron solamente las cuentas sintéticas reservadas; las cuentas existentes se conservaron. Copia SQLite íntegra verificada dentro del volumen del servidor.
