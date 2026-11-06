# Web 0.8.4 · Forma de la cabeza y unión con el cuerpo

Publicado en Railway: a37cb8de-03af-49f1-b1dd-487c1ed73fab, build b72027bec30d418b. [Comparación visual](COMPARACION_CABEZA_084.html) · [Archivo de fotos oficiales](CATALOGO_FOTOS_OFICIALES_084.html).

La revisión 083 dibujaba una cara estrecha y alta y añadía un cuello nativo encima del cuello que ya existía en la ilustración del cuerpo. Eso alargaba la silueta y creaba una unión poco natural. La clasificación de tonos tampoco reconocía parte de la piel clara del atlas: al seleccionar piel oscura, el cuello seguía claro.

HeroHead ahora usa una cara más ancha y baja, una mandíbula más plana y el origen de montaje en mandíbula/nuca. Se elimina su cuello adicional. La vista posterior tiene casco y perfil más compactos y se ajustó por separado para evitar dejarla flotando. HeroSprite reduce el cuerpo de 160 a 140 unidades de altura y de .82 a .76 de escala horizontal; el punto de contacto del bate utiliza esas mismas medidas. CharacterPortrait deja margen para el contorno más ancho; se recolocan los dorsales de HOME y bateo.

La piel del cuello recibe el color guardado del personaje. La textura se prepara y reutiliza con las cachés existentes; no se añade procesamiento de píxeles por cuadro. Creador, HOME, retratos y bateador mantienen los ocho rasgos de identidad. Los PNG de cuerpos y cabello de 083 no fueron modificados: siguen siendo reconstrucciones generadas en aquella revisión, no sprites recuperados de Syntasia. En 084 no se generaron hojas raster nuevas.

## Referencias oficiales recuperadas

Se revisó la galería pública suministrada por el usuario y se preservaron los bytes de 38 imágenes abiertas en el visor y 330 recursos de galería. Incluyen equipo, vestuario, entrenadores, estadios, cartas, transportes, pantallas y bocetos de animación. Las [cinco poses del héroe](https://www.facebook.com/photo.php?fbid=718692498174947) y el [boceto de secuencia](https://www.facebook.com/photo.php?fbid=718692278174969) ayudan a contrastar cabeza grande, cuerpo corto y mandíbula próxima al uniforme.

El catálogo separa imágenes del visor de vistas previas de galería. Las miniaturas suelen ser recortes cuadrados de baja resolución y algunas representan publicaciones ya guardadas desde el visor. Por eso los números no son un conteo de fotos únicas. Las fotos del visor conservan el encuadre entregado por Facebook, sin prometer resolución de producción. Todos los archivos declarados (368) se decodificaron y verificaron por SHA-256, con origen y dimensiones en el manifiesto.

La recuperación es parcial. Hubo 456 nombres de recursos con intentos fallidos; 162 no tienen recuperación correspondiente en el archivo. No se recuperaron todos los sprites, las capas editables, el cliente Flash ni las animaciones completas. No se ampliaron miniaturas para presentarlas como originales ni se incorporaron fotografías promocionales al paquete del juego.

## Validación

Pruebas locales y publicadas: registro sin invitación, nivel 1 ROOKIE, selección/borrador de personaje, llegada, HOME, nombre/dorsal, metas, calendario, viaje, alineación, introducción y primer partido, salida y reentrada. Identidad deliberada de los ocho campos, SELECT y recarga; ocho peinados y dieciséis poses. Galería adicional de ocho contornos y revisión visual de cuello/casco. Las ocho vistas de comparación decodifican las referencias y capturas; el catálogo filtra por tipo y busca por ID.

Chrome local, ENTER_FRAME durante 45.201 segundos: 2710 cuadros, 59.95 FPS, p95 25 ms, máximo 118 ms y 1 intervalo por encima de 50 ms. Catorce cambios de bateador, máximo 1 ms. Existe una pausa breve en esta muestra; no se garantiza ese rendimiento en otras computadoras.

131 archivos permitidos del paquete verificados y nueve hashes publicados coincidentes. Respaldo previo dentro del volumen Railway: external-v084-1791313399.sqlite3, integridad OK. Se eliminó únicamente la cuenta QA propia, conservando las cuentas preexistentes. Las partidas reales no se descargaron ni se reiniciaron. Guardado 21, reglas, curva de progresión y comienzo en nivel 1 / ROOKIE conservados. Los 60 recortes de 079, las siete celebraciones de 080 y el paquete Windows histórico 067 mantienen sus hashes.

## Límites visuales

El montaje y las proporciones mejoran, pero aún no es una reproducción exacta. La cara y el casco son trazados nativos; los cuerpos/peinados son reconstrucciones. Faltan perfiles más fieles, giros del cabello y rostro, expresiones y cuadros intermedios. Las fotografías oficiales son nuevas referencias verificables para seguir corrigiendo esas diferencias.
