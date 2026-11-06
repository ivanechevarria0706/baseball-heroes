# Baseball Heroes 1.0.3 — BUILD y estadio

Actualización del 15 de octubre de 2026. Conserva cuentas, progreso, cabeza 0.8.6, cabello, equipamiento y las reglas de partido.

1. **BUILD compacto.** El estadio ocupa la pantalla y SHOP, INVENTORY, TICKET SALES y las categorías quedan en un dock inferior. El catálogo se abre al elegir una categoría y se cierra al seleccionar una pieza, dejando visible la mejora antes de confirmar.

2. **Vista previa sin cobro.** Se pueden probar fondos, césped, gradas, marcador, luces, vallas, anuncios y muro. Elegir o cancelar una vista previa no modifica el estadio guardado, el inventario ni el saldo. BUY / USE confirma la operación; los artículos bloqueados no pueden comprarse y cambiar entre piezas propias sigue siendo gratuito.

3. **Mejoras visibles en Rookie.** Gradas con filas, paneles de anuncios, marcadores con reloj y torres de luces reemplazan los anteriores tintes planos. Las piezas se ajustan a las posiciones del fondo Rookie. El césped usa una máscara que protege el montículo, el plato, la tierra y las líneas.

4. **Decoraciones coherentes.** BUILD, HOME, partido y visitas comparten la misma transformación de posiciones y tamaño. Se conservan las coordenadas guardadas existentes y su colocación de HOME/partido; BUILD se ajusta a ellas. El arrastre queda limitado al área disponible. Siguen funcionando tamaño, retirada y máximo de ocho decoraciones.

5. **Recaudación y guardado.** TICKET SALES conserva el ingreso existente y su espera de seis horas. Los clics repetidos no entregan una segunda recaudación. Las compras, la pieza activa, las decoraciones y sus tamaños se mantienen después de recargar.

Referencias: capturas previamente archivadas de «Facebook - Baseball Heroes - No doy una», 09:50 y 11:20. El MP4 original no sigue en su antigua ruta de Downloads; no se han inventado fotogramas nuevos. Los iconos y estructuras son reconstrucciones nativas. La composición del dock se apoya en lo visible; el panel de confirmación es una adaptación usable. Las geometrías específicas de otros fondos y las texturas exactas del original siguen pendientes de calibración.

No se cambian precios, desbloqueos, ingresos, fórmulas, pichadas, estadísticas, cartas ni servidor. Guardado v23 / SQLite v4; no requiere migrar coordenadas ni reiniciar partidas. Los consejos y explicaciones siguen en español. Los recursos opcionales que no cargan conservan el estadio nativo de respaldo.

Capturas y comprobaciones: `build/qa/release1003`. Comparación: `COMPARACION_MEJORAS_1003.html`.

Publicación verificada: build `1874d2f886861add`. Cinco suites locales y dos en HTTPS aprobadas. Partido completo con siete estructuras mejoradas, pausa y reanudación, compras y recarga, arrastre y tamaño, protección del montículo/tierra, cámaras HOME/partido/visita, otro fondo y respaldo ante un recurso ausente. Se retiraron solamente las cuentas sintéticas reservadas; las cuentas existentes se conservaron. Copia SQLite íntegra verificada dentro del volumen del servidor.
