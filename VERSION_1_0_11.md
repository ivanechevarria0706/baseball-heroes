# Baseball Heroes 1.0.11 — reconstrucción del inicio

Esta actualización aplica el análisis cuadro por cuadro de `videoplayback (4).mp4`. Conserva las cuentas y las temporadas existentes; el inicio reconstruido se aplica a carreras nuevas. Los tutoriales y consejos están en español; los controles conservan sus nombres en inglés.

## Cambios

- **Creador:** cinco pestañas como en el video, opciones de forma/ojos/nariz en el orden observado y botón Female/Male persistente. El personaje muestra su casco equipado y lo retira al previsualizar HAIR. Se conserva la cabeza aprobada del bateador 0.8.6. El casco inicial tiene orejeras y logo; la camiseta Rookie es negra. No hay lentes iniciales.
- **Primera alineación:** héroe noveno, nombres de los compañeros observados y AVG base .200 sin inventar hits en su historial. Kyle C NORMAL comienza en la banca. El héroe dispone de cero puntos sin gastar; obtiene el primero al subir de nivel.
- **Primer sobre:** la compra guiada de 6,000 Coins entrega Walker P., C HERO, AVG .277, 8th 100% 1B y Combo +1. HERO muestra tres estrellas. La ilustración de Walker es un dibujo reconstruido. El precio de compras C posteriores mantiene la regla de 5,000 del otro video.
- **Lección de LINEUP:** el entrenador señala BATTER SHOP, un sustituto normal, el arrastre del héroe y AUTO SORT. Cada paso requiere la acción correspondiente y se recupera tras recargar. AUTO SORT activa la carta comprada y coloca al héroe tercero. PLAY no omite esos pasos.
- **Consejos durante el partido:** aparecen en momentos de espera seguros para explicar el lanzamiento y el combo. MAX se pierde al completar un STRIKEOUT; un strike aislado o foul lo conserva. El encabezado rival del autojuego usa el rojo de la referencia.
- **Resultado:** MVP ya no exige tres RBI. La selección compara RBI, Home Runs y hits. Se corrige el caso observado de 16 hits/1 carrera a RANK D, manteniendo las demás muestras conocidas. Una calibración inicial permite llegar a nivel 2 con los 79 XP totales observados.
- **Puntos del héroe:** panel compacto junto a la cabeza, C/P/L inicialmente 1/1/1 y total 3; seis accesos al equipamiento. Un punto aumenta el atributo real y el contador mostrado. Los personajes antiguos conservan su escala previa.
- **DRAFT de amigos:** panel gratuito con 25 espacios, búsqueda, AUTO PICK y selección persistente de hasta cinco amigos aceptados. HOME los muestra primero. REGISTER FRIENDS abre el sistema real de amigos; no envía invitaciones por su cuenta. SCOUT de jugadores CPU sigue disponible desde TEAM.
- **Cierre del tutorial:** 40,000 Coins acreditados una sola vez antes del panel de misión, seguidos de NAME y TICKETS. Recargar, CONTINUE o SKIP no duplican el premio. TRADE & ENHANCE en LINEUP de temporada abre directamente la combinación de tres cartas especiales.

## Evidencia y límites

La comparación incluye los cuadros originales y capturas del remake con datos sintéticos de prueba. El partido de 16 hits/1 carrera y 79 XP es una reproducción controlada del ejemplo para verificar su liquidación; no se fuerza ese resultado a las partidas reales.

Los campos visibles de Kyle/Walker proceden del video. Sus atributos secundarios, las probabilidades y la curva completa de XP siguen siendo balance local. El umbral de 50 XP del primer nivel es una calibración para carreras nuevas; el video solo demuestra Lv2 con 79 XP, no el umbral exacto. Las cuentas existentes conservan su curva. Walker fijo en el primer sobre reproduce esta secuencia, sin afirmar que todos los usuarios del original recibieran esa carta.

El video no activa Female ni revela un cuerpo o animaciones alternativos: el control guarda la selección y utiliza por ahora el mismo actor uniformado. La apariencia y composición son una reconstrucción, no sprites originales recuperados. La barra EXPECTED POTENTIAL de DRAFT permanece neutral porque su fórmula original no se conoce; seleccionar amigos ordena sus fichas y conserva los bonos ya implementados de vínculos aceptados, sin inventar multiplicadores nuevos. El video tampoco abre TRADE para confirmar todas sus reglas.

Siguen pendientes la fidelidad completa de sprites/animaciones, contenido no mostrado, ALL STAR/WORLD MATCH y la prueba de amigos desde dos computadoras físicas. Se mantienen la energía y condición de cartas de 1.0.10, el motor de pichadas, el audio aprobado y los datos existentes.

## Verificación

44 pruebas del servidor y 34 comprobaciones compartidas del modelo. Cinco suites locales en Chrome: inicio y lección interactivos, recarga/condición, registro público y creador, LINEUP público con guardado/reentrada, y partido completo con pausa y liquidación única. Artefactos: `build/qa/release1011`.

Guardado v24 compatible con v21–v23; SQLite v4. No se cambia el identificador de reinicio ni se reinician cuentas. La publicación y las pruebas HTTPS se registran al finalizar en `deployment_status.json`.

Publicada y comprobada en HTTPS: build `3eb45f2989b660a4`. Dos suites con cuentas sintéticas nuevas: registro/creador/recarga y LINEUP/energía/partido pendiente. 138 archivos publicados coinciden con el paquete probado; las herramientas de prueba no están expuestas. Se verificó la copia SQLite en el volumen y se eliminaron únicamente las dos cuentas QA reservadas utilizadas, conservando las cuentas anteriores.
