# Web 0.7.7 · Calendario de temporada

El calendario sustituye el panel marrón y las siete tarjetas pequeñas por un fondo verde, un carrusel de cinco rivales y una barra inferior de treinta encuentros. Los números sobresalen de cada tarjeta; WIN/LOSE aparecen inclinados, con contorno, sobre los logos aportados. El siguiente partido conserva la tarjeta azul y sus marcadores vacíos. La cabecera comparte las fuentes incorporadas y los recursos de LINEUP. Es una interfaz funcional, no una captura de video usada como fondo.

Se puede recorrer el carrusel con las flechas o saltar a cualquiera de los treinta juegos desde la barra. Consultar un resultado muestra su marcador y rival guardados. Si una partida migrada carece de marcador, muestra SCORE -- y dos guiones, sin inventar un 0–0. NEXT MATCH vuelve al encuentro actual. LINE UP continúa siempre con el juego pendiente, aunque se haya consultado uno futuro. Los estados del juego 30 y de temporada terminada tienen etiquetas diferentes; NEXT SEASON conserva el flujo existente hacia la siguiente temporada.

El código anterior usaba el rival calculado para mostrar resultados históricos. Ahora los datos históricos del rival tienen preferencia cuando existen. Las consultas, flechas y cierre no guardan cambios ni gastan energía. Al cerrar o cambiar de página se liberan los logos y los eventos de los controles. El fondo y los rótulos son estáticos, sin procesamiento por cuadro.

## Referencia y límites

Referencia directa: gameplay «Vamos En Primer Lugar Y Explicando Algunas Cositas», 05:10, `reference_visual/explicando_20260924/frame-0310.jpg`. La comparación `COMPARACION_CALENDARIO_077.html` permite normalizar el fotograma de 640×360 al marco 960×720. La captura de la sexta temporada del remake usa resultados de prueba y no representa una partida del usuario.

El original incluye HOME/AWAY, clasificación de otros clubes e hitos de SPECIAL/RIVAL sobre la barra. Esos datos no están modelados en el calendario actual: la banda de las tarjetas muestra la ciudad existente y no se añaden etiquetas que prometan reglas ausentes. El fondo, la tipografía y los botones son reconstrucciones; faltan las texturas y fuentes exactas. Las clasificaciones siguen usando la aproximación existente de GameData. Los modos POST SEASON y otros pendientes no se activan en esta entrega.

La transición entre temporadas conserva una limitación previa: el motor reinicia el calendario al comenzar el partido, después de las pantallas de viaje/previa. Falta ajustar esas pantallas para anticipar el primer rival de la nueva temporada. La prueba de temporada completa comprueba las etiquetas y que consultar el historial no reinicie ni cobre energía; no demuestra que esa previa ya esté corregida.

No cambian el esquema 21, los precios, las recompensas, el timing, las probabilidades, los sonidos, la alineación ni el motor del partido. Las cuentas nuevas continúan en nivel 1 de ROOKIE. Las correcciones de rendimiento de 0.7.4 se conservan. Windows 0.6.7 conserva su compilación anterior.

## Verificación

- `smoke-season077.txt`: Chrome, cinco tarjetas, treinta juegos accesibles, extremos de paginación, nombres históricos, marcadores conocidos y migrados, estado inalterado al consultar, retorno al encuentro actual, viaje al partido pendiente, cierre/apertura repetidos, recarga en nube, juego 30 y temporada completa.
- `smoke-home077.txt`: trece rutas existentes, entrenamiento, recaudación única, fichas y compañeros, seis estadios, respaldo ante fallo y partido.
- `smoke-production-match077-local.txt`: ejecutable definitivo, calendario, compra/equipamiento, recarga de progreso, partido con teclado y muestra de veinte segundos del bucle del navegador. Esta muestra no mide los cuadros de ActionScript; la medición del motor de 0.7.4 se conserva.
- `smoke-web077-staging.txt`: arranque con base vacía, registro sin invitación, sesión privada y exclusión de ejecutables de diagnóstico.
- `smoke-cloud-match077.txt`: comprobación equivalente sobre Railway, seguida de limpieza de la cuenta QA y respaldos íntegros dentro del volumen.

Las pruebas usan identidades separadas. Solo la identidad QA recibe resultados artificiales y fondos para verificar compras. Los manifiestos se actualizan tras verificar la publicación.

La limitación de previa entre temporadas descrita arriba se corrigió posteriormente en web 0.7.8. Véase REVISION_TEMPORADA_078.md.
