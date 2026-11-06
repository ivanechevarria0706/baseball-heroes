# Baseball Heroes — cartas, versión 0.4.5

Ejecuta **JUGAR.bat**. Esta revisión conserva el identificador y el formato de tu partida. La versión 0.4.4 permanece en su ZIP separado.

## Presentación

Las cartas ahora tienen marco vertical, nombre arriba, categoría en una esquina, personaje grande y estadísticas debajo, tomando como referencia la carta de Lenard J. que aparece aproximadamente en 03:12 del primer video aportado. La escala mantiene las proporciones y contiene todos los textos dentro de la carta.

Lenard tiene un dibujo vectorial nuevo con cabello rizado, ojos cerrados, sonrisa y uniforme amarillo. Es una reconstrucción del fotograma, no el sprite original recuperado. Los demás personajes todavía usan los retratos provisionales del proyecto.

La colección muestra cinco cartas por página y permite recorrer todo el catálogo. Al obtener o seleccionar una carta, su página y su selección quedan sincronizadas. La apertura presenta la carta mediante una animación breve antes de habilitar OKAY.

## Correcciones comprobadas

- Espacio abre el sobre y Enter confirma el resultado. Antes, la confirmación por teclado pasaba un evento nulo a un manejador que lo utilizaba sin comprobarlo.
- Durante la apertura no se puede cobrar otro sobre por una entrada repetida.
- Sin monedas suficientes no se modifica ni el saldo ni el inventario.
- Las cartas de todas las páginas son accesibles y pueden equiparse.
- Los retratos y las cartas se liberan al cerrar o reconstruir las pantallas.
- Se retiran textos de desarrollo de la interfaz de colección y tienda.

La prueba `tests/CardSmoke.as` usa una identidad AIR independiente: `com.personal.baseballheroes.cardqa`. Su dinero e inventario son ficticios. Registro: `build/qa/smoke-cards.txt`. Capturas: `build/qa/cards-*.png`.

## Distancias que siguen abiertas

No se han cambiado las probabilidades, habilidades ni la economía del catálogo. En particular, la referencia de Lenard muestra **4th 50% 1B** y **2/2**, mientras que la base actual modela un hit garantizado en la cuarta entrada y no reproduce ese contador de energía. La interfaz muestra los datos que realmente utiliza el remake; no añade un contador decorativo que prometa una mecánica inexistente.

Quedan por reconstruir las ilustraciones de las demás cartas y verificar las reglas de activación, energía y combinación. Los documentos de las versiones anteriores se conservan como historial.
