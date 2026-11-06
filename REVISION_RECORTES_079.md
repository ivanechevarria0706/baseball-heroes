# Recortes de arte — web 0.7.9

El camión del viaje tenía el frente cortado y varios recortes incluían parte del vehículo de al lado. TRIPLE A cargaba un autobús rojo y MAJOR el avión de TRIPLE A. Los íconos de modos recortaban letras y contornos; algunos logos incluían restos del vecino; el procesamiento de los sobres había eliminado trazos negros internos al confundirlos con el fondo.

Se reconstruyen 60 archivos desde las láminas originales aportadas: 5 vehículos, 5 emblemas de liga, 12 íconos de modos, 30 logos y 8 sobres. Cada archivo conserva la proporción, los colores y la transparencia del original. La extracción usa regiones medidas, elimina únicamente el margen transparente y añade cuatro píxeles transparentes de seguridad. No estira ni resamplea las ilustraciones, ni elimina colores por una regla de “fondo negro”.

Orden: ROOKIE → autobús verde; SINGLE A → azul; DOUBLE A → rojo; TRIPLE A → avión rojo; MAJOR → avión azul. ArrivalMapScreen y TravelMapScreen comparten estos recursos. LeagueBadgeView deja de forzar un recorte cuadrado: ahora muestra el emblema entero, incluido MAJOR. La versión web incluye un hash de los archivos externos de arte para detectar también las actualizaciones que solo cambien imágenes.

Las 60 imágenes pasan de 4,253,311 a 1,569,343 bytes (2,683,968 bytes menos). La reducción viene de conservar la resolución de las láminas y retirar ampliaciones/relleno innecesarios. No equivale a una medición nueva de FPS.

## Auditoría y límites

Se inspeccionaron las nueve carpetas de assets/reference. Los 11 retratos de roster son recortes de busto intencionales para fichas; no incluyen fragmentos de vecinos. Los seis fondos de estadio ocupan todo el marco por diseño. La lámina de entrenamiento se conserva intacta y se recorta en memoria. Los atlas de actores mantienen sus coordenadas y anclas medidas; no se han sustituido las animaciones ni cambiado sus cachés.

Las siete bandas antiguas de celebración siguen siendo recortes parciales; en las últimas dos se ve además una franja de otro panel. No se conserva aquí su lámina completa para rehacerlas como los 60 recursos anteriores. Esta revisión las identifica como pendientes, no afirma que se hayan restaurado ilustraciones que faltan. El mapa de viaje conserva su geografía aproximada y los actores siguen siendo reconstrucciones. Esta entrega no demuestra que todo el juego sea ya idéntico.

Las fuentes originales 11_05.png, 11_06.png y 11_07.png se verifican por hash y no se modifican. Los recortes anteriores quedan en build/qa/assets079-backup; el paquete de publicación no incluye esa carpeta ni los ejecutables de diagnóstico. Coordenadas, dimensiones, número de píxeles y hashes: assets/reference/RECUT_MANIFEST_079.json.

## Validación

- La extracción rechaza regiones que corten píxeles en el límite y comprueba que conserva todos los píxeles RGBA de cada región.
- Chrome/Ruffle muestra las cinco familias de arte dentro de 960×720; los 60 PNG pasan por rutas autenticadas y coinciden con los hashes esperados.
- Los cinco viajes usan su vehículo correcto y llegan a LINEUP sin cobrar energía ni alterar la carrera. Los seis íconos de MODES se cargan completos.
- HOME conserva sus trece rutas, el ingreso de entradas no se duplica al recargar y los seis fondos conservan su respaldo ante errores de carga.
- Cambio de temporada, metas, tarjeta equipada, introducción, partido y reanudación conservan el progreso y cobran una sola vez. Las cuentas nuevas siguen en nivel 1 de ROOKIE y sin invitación.

Los informes vigentes de publicación quedan registrados en revision_manifest.json al finalizar la verificación en Railway. El esquema del guardado continúa en 21; el paquete Windows 0.6.7 no se actualiza en esta entrega web.
