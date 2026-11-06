# Baseball Heroes 1.0.4 — tienda de energía clásica

Actualización del 15 de octubre de 2026. Conserva cuentas, progreso, cabeza 0.8.6, cabello y equipamiento.

1. **Tienda coherente.** ENERGY comparte los paneles azules, pestañas y proporciones de la tienda clásica de equipamiento. El estadio y el héroe guardado permanecen visibles, con su apariencia, equipo y color de uniforme. Las latas y la caja son ilustraciones nativas reconstruidas, sin añadir imágenes pesadas.

2. **Vista previa y confirmación.** Elegir una recarga permite ver el precio, la cantidad y la energía final. CANCEL no cobra; BUY aplica la compra confirmada. Se distinguen Coins y Hero Coins y los avisos y consejos siguen en español.

3. **Compras protegidas.** La recuperación natural se comprueba de nuevo al pagar. Con energía llena o por encima de la capacidad no se cobra. Un saldo insuficiente tampoco cambia los recursos. Cuando compras por debajo de la capacidad, se conserva íntegro el contenido aunque la recarga la supere; se guarda después de recargar la página.

4. **Energía visible.** Barra de energía y tiempos de recuperación actualizados una vez por segundo. La compra tiene un aviso breve de +ENERGY y una reacción del héroe. Las animaciones y controles se retiran al cambiar de pantalla.

5. **STADIUM con vista previa real.** La pestaña STADIUM lleva directamente a BUILD, que ya permite ver las piezas antes de comprarlas. GEAR, INVENTORY y el regreso a HOME conservan sus funciones.

Referencia de composición: video de Facebook archivado, 04:20, panel SHOP / INVENTORY y héroe a la derecha. No hay una captura equivalente de la tienda ENERGY original: su distribución interna y sus ilustraciones son una adaptación, no una recuperación exacta. Se mantienen los dos recursos del catálogo actual, sus precios (7,000 Coins / 5 Hero Coins) y cantidades (+5 / +20); no se presentan como valores originales verificados.

Único cambio del modelo: comprobación de energía llena y recargas inválidas antes de cobrar. La energía de pago que supera el límite conserva la regla previa; el límite solo controla la recuperación natural. No se cambian estadísticas, pichadas, reglas del partido, cartas, XP ni servidor. Guardado v23 / SQLite v4, sin reiniciar cuentas.

Capturas y comprobaciones: `build/qa/release1004`. Comparación: `COMPARACION_MEJORAS_1004.html`.

Publicación verificada: build `e5c0682841cdd393`. Cuatro suites locales y dos en HTTPS aprobadas. Partido completo de nueve entradas y doce pichadas manuales, tutorial desde nivel 1/Rookie, compras en ambas monedas, cancelación, saldo insuficiente, recuperación natural durante la confirmación, energía pagada por encima del límite, guardado, recarga y navegación repetida. Se retiraron solamente las cuentas sintéticas reservadas; las cuentas existentes se conservaron. Copia SQLite íntegra verificada dentro del volumen del servidor.
