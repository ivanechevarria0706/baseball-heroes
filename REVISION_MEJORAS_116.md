# Autojuego, cartas observadas y equipo · 0.10.16

Se continúa con los tres bloques elegidos: presentación del autojuego, fichas de cartas observadas y equipo visible. La incorporación es aditiva: se conservan las 33 cartas anteriores, todas las definiciones de equipo y las copias compradas. No se reinicia ninguna carrera.

## Cartas

Se añaden Howard D., Billie K., Marvin K., Garret D., John G., Darren S. y Benny C. La referencia confirma clase, grado, AVG, Combo, entrada, tipo de hit y porcentaje. El catálogo pasa de 33 a 40 definiciones; los sobres y TRADE pueden entregar las nuevas según su clase y grado. El primer sobre del tutorial mantiene su regla anterior. Las instancias guardadas siguen teniendo su mejora, cargas y disparador propios.

Las cuatro estadísticas secundarias no aparecen en esas fichas. Se usan perfiles del balance local, identificados como reconstrucción; no se presentan como datos del original. Las tasas por grado existentes coinciden con los porcentajes observados (50/65/80%). No se cambian las probabilidades generales ni el consumo de cargas. Benny parte de AVG .339; +1 produce .349, como la captura. El cuerpo de la carta utiliza la región original de la grabación, conservando su distintivo de clase/grado; los rótulos dinámicos se dibujan aparte, sin duplicar el AVG viejo.

## Equipamiento

32 artículos nuevos: ocho pares de zapatos, ocho cinturones, ocho bates y ocho gafas. Precios y bonos se transcriben de las capturas 04:12, 04:16, 04:20 y 04:24. Se añaden iconos del vídeo a esos artículos y a los ocho guantes existentes. La tienda presenta la colección observada primero y los bonos en cada tarjeta. INVENTORY y las casillas equipadas conservan esos dibujos después de comprar y recargar.

La compra antigua guarda nombre, categoría, grado, color y bonos, pero omite el ID del catálogo. ObservedArtwork resuelve el dibujo por nombre + casilla cuando no hay ID; no modifica el formato del guardado ni la operación de compra. También funciona con los guantes ya comprados. La selección del preview no compra ni equipa; se conservan las confirmaciones, límites y pago único.

Camo/Spider Goggles mantienen el candado visible LEVEL 17. Las demás capturas prueban que están disponibles en nivel 12, pero no revelan su nivel exacto de desbloqueo: se deja cero en los artículos nuevos para no inventar un candado. El grado NORMAL y los colores base son decisiones del remake. En el héroe se conservan las formas y colores del renderer existente; faltan algunos estampados y formas exactas del equipo original.

## Arte y procedencia

Se extraen 47 ventanas directamente del MP4 suministrado: siete cartas y 40 iconos. No se incorporan audio ni narración. El SHA del video y los tiempos, coordenadas y hashes de cada PNG quedan en reference_docs/observed116.json. No se publican el MP4 completo ni las capturas de pantalla completas. La resolución de la grabación es limitada; estos recortes no son sprites Flash recuperados ni ilustraciones de alta resolución.

Los iconos aíslan en memoria el fondo claro conectado al borde, conservando la tinta que encierra las partes blancas. Se cachean una vez por artículo, junto con la búsqueda de identidad. Los PNG extraídos no se retocan. Los recortes de cartas conservan el fondo y distintivos que se ven en la referencia.

## Autojuego

Nombres y AVG más legibles; fila activa con fondo suave y marco dorado animado; mayor diferencia de tamaño entre el equipo activo y el otro; tres indicadores de outs ligados al contador real. La pausa congela también el énfasis de fila. El aviso en español identifica el triángulo que permite continuar.

Game.as es idéntico a 0.10.15. Se conservan el orden, frecuencia de bateo, retrasos x1/x2/x4, reloj de pausa, resultados, XP, energía, economía y transición al turno manual. Permanecen la cabeza 0.8.6, cabello y pichadas Rookie. Tutoriales y consejos en español; menús en inglés. Guardado v23 / SQLite v4, servidor sin cambios.

## Verificación

Diagnóstico Chrome: perfiles observados, activación en su entrada y un solo intento, mejora de copias, 32 compras con costos exactos, doble compra, equipamiento, identidad del arte sin ID, candados y falta de saldo. Se repiten 100 comprobaciones de autojuego, retratos y pausa de las versiones anteriores. Revisión visual de las siete cartas, los 40 iconos y las cinco categorías.

Ejecutable público local y Railway: cuenta nueva nivel 1/Rookie; preparación temporal de nivel 12 para probar equipo observado; preview sin gasto, compras con Coins y moneda premium, equipar tres artículos, doble clic, mejora de Benny, recarga y apariencia conservada. Autojuego público con entradas de mouse, pausa visual estable, x1/x2/x4, carga única de energía, recarga y nuevo inicio de sesión. Partidas antiguas v21 y v22 preservadas. Las cuentas temporales se retiran al acabar.

El partido completo de 12 entradas fue comprobado en 0.10.15; el código de motor actual es idéntico y esta entrega comprueba de nuevo la presentación pública. No se afirma haber realizado otra prueba física entre dos computadoras.

Comprobaciones de modelo nuevas: 271.

Publicada y verificada en Railway. Build 38f183a2b21315da.
