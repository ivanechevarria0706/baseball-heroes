# Revisión 0.4.6 — habilidades y ranuras

Esta revisión conecta lo que muestran las cartas con lo que ocurre en el partido. Conserva el identificador de la aplicación y el formato de guardado. Abre `JUGAR.bat` para jugar la compilación incluida.

## Referencia y cambios

El video aportado **Facebook - Baseball Heroes - No doy una** muestra a Lenard J. alrededor de 03:12 con `4th 50% 1B`. En 13:10, el tooltip TYPES indica probabilidades de habilidad NORM 50%, RARE 65%, ELITE 80% y HERO 100%. Ahora el remake utiliza esos porcentajes, tanto en el texto de la carta como en la resolución del turno de simulación.

Antes, alcanzar la entrada indicada garantizaba el hit especial. Ahora se sortea la habilidad; si falla, el bateador continúa con la simulación ordinaria. Por tanto, 50% describe la activación del efecto, no la probabilidad total de conseguir cualquier hit. Se conserva la regla del prototipo de un intento por carta en su entrada indicada, incluso cuando falla; esa frecuencia no está confirmada por el video. Cada partido crea un registro nuevo de intentos.

La ventana SPECIAL BATTER SLOT de LINE UP permite comprar la próxima ranura y actualiza el saldo y los espacios de la alineación inmediatamente. Los precios son 1.000 monedas para la segunda ranura, 2.000 para la tercera, 56 cash para la cuarta y 72 para la quinta. El primer precio se deduce de la caída de saldo 21.418 → 20.418 entre 13:00 y 13:05; los otros aparecen en los controles entre 13:05 y 13:15. Las ranuras ya compradas permanecen desbloqueadas. No se recalculan compras anteriores.

La pestaña TYPES comparte los porcentajes con la lógica del partido. La colección y las cartas muestran entrada, porcentaje y resultado —por ejemplo `4th 50% 1B`— sin prometer un efecto garantizado. Se ajustó la altura de las estadísticas para evitar que COMBO quede cortado.

## Verificación

- Compilación del juego y de las tres pruebas AIR.
- `tests/AbilitySmoke.as`: 1.000 valores uniformemente espaciados por categoría producen exactamente 500/650/800/1.000 activaciones; entrada incorrecta no sortea; un intento agotado no se repite; otro partido reinicia la elegibilidad. Prueba los cuatro precios, fondos insuficientes, límite de cinco ranuras y actualización visible desde LINE UP.
- `tests/CardSmoke.as`: compra y apertura de sobres, rechazo por fondos insuficientes, protección frente a clics y teclas repetidos, paginación y equipamiento desde la última página.
- `tests/VisualSmoke.as`: HOME, LINE UP y partido, transición a bateo, lanzamiento y swing en dos estadios.
- Informes y capturas en `build/qa/`; cada prueba utiliza un identificador AIR distinto del juego personal.

Estas pruebas verifican la implementación local, no demuestran que toda la simulación sea idéntica al original.

## Pendientes de fidelidad

La energía `2/2`, las reglas completas de mejora, el catálogo histórico y la frecuencia exacta de activación necesitan más evidencia. Los nombres internos de los resultados (`guaranteedHit`) se conservan por compatibilidad de código; el efecto ya está condicionado a su probabilidad. El arte de personajes, las proporciones de pantalla, el audio y las animaciones siguen siendo aproximaciones. Esta entrega no recupera el código ni todos los recursos de Syntasia.
