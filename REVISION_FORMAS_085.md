# Web 0.8.5 · Ocho formas de cabeza según la nueva referencia

Publicado en Railway: 07359501-2566-4245-a2ec-d59c85190ca5, build 9524d0c52912b60a. [Comparación visual](COMPARACION_FORMAS_085.html).

La captura aportada muestra el menú SHAPE de la tienda del original: Chubby, Double Chin, Edgy, Flat Chin, Round, Sharp, Slim y Triangular. La revisión 084 había dejado una cara demasiado ancha y una mandíbula muy horizontal; las miniaturas de formas además conservaban el cabello, ocultando las diferencias.

HeroHead reconstruye ahora la bóveda redondeada, las mejillas más estrechas y ocho bases de mandíbula: continua, con leve pliegue, con esquinas pequeñas, plana, redonda, afilada, estrecha y triangular. Dos curvas por lado forman la parte superior ovalada. La cara usa la misma escala y contorno en creación, HOME y retratos, incluyendo las vistas frontales del bateador. Las miniaturas SHAPE muestran piel y orejas sin cabello ni rasgos. CharacterMakerScreen toma los nombres originales de la misma lista usada por los contornos.

Los índices guardados 0–7 mantienen su orden. No se migran ni reemplazan los datos de apariencia de carreras existentes. Se modifica el dibujo que corresponde a cada forma, como parte de la corrección visual. Los ocho campos de identidad, color de piel, montaje de cuello de 084, cuerpo, casco posterior, punto de contacto, tiempos de swing y cálculo de resultados se conservan. La escala de los ocho peinados se ajusta al nuevo ancho; Crew Cut se eleva para cubrir la coronilla. No se recorre la textura en cada cuadro ni se añaden cachés.

## Referencia y límites

Se guardó la captura completa de 687×592 sin modificar sus bytes: [reference.png](reference_visual/head_shapes_20261006/reference.png), SHA-256 5759164a234570ff119f243ee04859a06960849ce00618b95a340abc14690e44. Se midió el relleno rosado central por filas para distinguir la forma de las orejas, conservando los resultados en [measurements.json](reference_visual/head_shapes_20261006/measurements.json). Las miniaturas tienen poca resolución; PREVIEW tapa la parte inferior de Round. Las curvas son una reconstrucción visual aproximada, no vectores originales extraídos.

No se generaron ni editaron PNG de sprites en esta revisión. Las hojas de cabello y cuerpo siguen siendo reconstrucciones de 083 con hashes intactos. Las expresiones, los ojos, los perfiles y los giros completos todavía difieren del original. La nueva referencia mejora los contornos; no permite afirmar paridad visual exacta.

## Pruebas y publicación

Identidad deliberada de los ocho campos: selección y recarga conservan shape, hair, eyes, nose, mouth y los tres colores; las cabezas construidas en HOME y retrato coinciden. Ocho cabellos, ocho formas con cuerpo, ocho siluetas desnudas y dieciséis estados del bateador revisados. Las galerías no modifican la apariencia guardada ni el nivel o liga.

Chrome local y publicado: registro sin invitación, nivel 1 ROOKIE, equipo, borrador/cancelación y selección de personaje, llegada, HOME, nombre/dorsal, metas, calendario, viaje, alineación, introducción, primer partido, salida y reentrada. Una sola carga de energía. Sin errores del navegador. Se mantuvieron las pruebas de acceso privado al SWF y se excluyeron los SWF de diagnóstico del paquete.

131 archivos permitidos verificados y nueve hashes publicados coincidentes. Respaldo previo dentro del volumen Railway: external-v085-1791319097.sqlite3, integridad OK. Se eliminó únicamente la cuenta QA propia y se comprobaron las cuentas preexistentes. Guardado 21, registro sin invitación y comienzo en nivel 1 / ROOKIE sin cambios. Los 60 recortes de 079, las siete celebraciones de 080 y el paquete Windows histórico 067 conservan sus hashes.

La primera subida falló al crear la copia de código en Railway; el segundo intento se confirmó SUCCESS antes de validar la web. Se renovó la sesión oficial de Railway con la intervención del usuario. No se cambiaron el alojamiento, los permisos de acceso ni las reglas de juego.

No se repitió el perfil de rendimiento de 084 porque esta revisión modifica trazados y miniaturas. La medición anterior permanece archivada; no se presenta como una nueva medición de 085.
