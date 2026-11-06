# Baseball Heroes 1.0.6 — selector de competiciones

Actualización del 15 de octubre de 2026. Conserva cuentas, progreso, cabeza 0.8.6 y Derby.

1. **Siete competiciones reconocibles.** MODES reúne temporada, Derby, postemporada, SPECIAL, amigos, ALL STAR y WORLD MATCH. Usa los iconos existentes y paneles del mismo estilo que la tienda clásica, con recursos arriba y detalles a la derecha.

2. **Fichas sin gasto.** Seleccionar una ficha muestra estado, requisitos y funcionamiento sin reservar un partido, gastar energía o cartas, avanzar de temporada ni crear el cuadro. Flechas cambian de ficha y ENTER usa la acción disponible; mantener una tecla no repite la entrada.

3. **SPECIAL correcto.** Solo puede abrirse cuando el encuentro actual del calendario es SPECIAL: juegos 12 y 28 del modelo existente. Fuera de esos días indica el próximo evento y mantiene el botón bloqueado. Si cambia el día mientras una ficha está abierta, la disponibilidad se comprueba de nuevo antes de entrar.

4. **Postemporada con progreso.** Se distingue entre requisito pendiente, clasificación obtenida, serie en curso, partido pagado y cuadro completado. La ficha muestra ronda y victorias. Una postemporada pendiente bloquea el avance a otra temporada regular; consultar la clasificación no crea el cuadro por anticipado.

5. **Entradas y progreso conservados.** Derby y amigos mantienen sus rutas. Los encuentros pagados indican que reabrirlos no cobra de nuevo. Una temporada terminada sin clasificación conserva su ruta a las metas de la siguiente. ALL STAR y WORLD MATCH siguen bloqueados con una explicación clara.

Se corrige el acceso anterior de SPECIAL, que enviaba siempre a la temporada regular aunque no correspondiera un evento. También se evita ofrecer otra temporada mientras existe una postemporada pendiente. No se cambian las fechas, clasificación, probabilidades, premios ni reglas existentes. RIVAL / FRIENDS abre retos y liga privada asíncronos; el encuentro RIVAL del calendario sigue siendo el evento CPU previo.

El selector es una reconstrucción con los iconos originales ya disponibles y el marco visual de los menús actuales. No se presenta como una captura recuperada del selector original. SPECIAL 12 y los 500 Coins por derrota están observados en el gameplay; la repetición en el juego 28 sigue la reconstrucción existente. ALL STAR y WORLD MATCH requieren evidencia suficiente y no se habilitan con reglas inventadas.

Guardado v23 / SQLite v4. Modelo, servidor, personajes, audio, Derby y partido regular sin cambios. No hay migración ni reinicio de cuentas. Consejos en español; nombres, estados y botones en inglés. Capturas: `build/qa/release1006`. Comparación: `COMPARACION_MEJORAS_1006.html`.

Publicación verificada: build `f19d836a91701f61`. Dos suites locales y una en HTTPS aprobadas. Matriz de los 30 partidos, siete vistas previas sin gasto, clics y ENTER bloqueados, estados pagados, ruta real de SPECIAL a su partido, reanudación con cero energía, clasificación y creación explícita del cuadro, siguiente temporada con metas, guardado y recarga. Se retiraron solamente las cuentas sintéticas reservadas; las cuentas existentes se conservaron. Copia SQLite íntegra verificada dentro del volumen del servidor.
