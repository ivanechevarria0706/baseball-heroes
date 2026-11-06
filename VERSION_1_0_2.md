# Baseball Heroes 1.0.2 — equipo, movimiento y autojuego

Actualización del 14 de octubre de 2026. Mantiene las cuentas, el progreso y la cabeza aprobada de 0.8.6.

1. **Equipamiento visible.** Ocho cascos y ocho lentes incorporan sus motivos observados: estrellas, corazones, rayos y otros detalles. Los ocho bates, ocho guantes y ocho pares de zapatos reciben materiales y marcas que siguen la pose. Los diseños aparecen en el personaje y al batear; los precios y atributos se conservan.

2. **Movimiento de jugadores.** El bateador carga el cuerpo y completa el swing con una estela breve. El lanzador acompaña el lanzamiento con una inclinación; los defensores alternan pasos, se plantan para un rodado y alcanzan la pelota en elevados. La posición real de la mano sigue guiando la salida de la pelota.

3. **Autoplay.** La alineación que está bateando aparece más grande y alta. El diamante central usa una base circular verde, la pelota sigue un arco en elevados y las cartas especiales muestran la entrada y el tipo de hit de su habilidad. Los controles de velocidad y pausa siguen disponibles.

Las ilustraciones y movimientos son reconstrucciones a partir de las referencias locales. No son sprites originales recuperados: aún faltan letras y detalles finos de algunos bates y variantes que no aparecen completas en los videos. Los cinturones conservan su representación anterior. Se reutilizan las poses existentes con nuevas transiciones; no se añadieron cuadros originales que no tenemos.

Se conservan el contacto de Home Run de 130 ms, la carga de combo, las probabilidades y la velocidad de lanzamiento. Los tutoriales y consejos siguen en español.

Se comprueba una vez por pose qué equipo necesita materiales especiales. Esto evita repetir esas comprobaciones de compatibilidad por cada píxel y corrige el bloqueo encontrado al preparar un partido sin imágenes precargadas.

Comprobaciones y capturas: `build/qa/release1002`. Comparación: `COMPARACION_MEJORAS_1002.html`.

Publicación verificada: build `7a4567cfe35f8a7c`. Ocho suites locales y tres suites en HTTPS aprobadas, incluidas compras y recarga. Partido completo con entradas extra, pausa y reanudación, contacto y seguimiento de pelota, y rendimiento en el equipo de prueba. Se retiraron únicamente las cuentas sintéticas de verificación; se preservaron las cuentas existentes. Copia de seguridad verificada dentro del servidor.
