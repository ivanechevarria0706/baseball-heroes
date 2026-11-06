# Baseball Heroes 1.0.5 — Home Run Derby

Actualización del 15 de octubre de 2026. Conserva cuentas, progreso y la cabeza aprobada.

1. **Tu estadio durante el Derby.** El modo usa la misma cámara y composición del partido, con el fondo, césped, estructuras y decoraciones que tienes guardados. El héroe conserva apariencia, equipo, número y color de uniforme; la cabeza 0.8.6 no se modifica.

2. **Contacto visible.** La trayectoria cruza la posición real del bat en el instante que ya evalúa el timing del Derby. Un Home Run utiliza el sonido fuerte y una retención de 130 ms en el contacto, seguida por el vuelo y el destello. Los otros resultados muestran su propio aviso y consejo.

3. **Pausa sin perder la pichada.** Botón de pausa o P; RESUME, P o ESPACIO reanudan. Preparación, vuelo y resultado comparten un reloj detenido para actores, pelota y efectos. Perder el foco durante una jugada pausa el modo. Mantener una tecla no encadena swings ni alterna la pausa.

4. **Las diez pichadas a la vista.** Franja inferior con el resultado de cada lanzamiento, Home Runs, mejor distancia y distancia total. El cierre muestra el premio aplicado y permite PLAY AGAIN o MODES. Repetir una ronda limpia el marcador y conserva los premios anteriores.

5. **Guardado y controles.** El premio se entrega una sola vez al terminar las diez pichadas. Regresar al menú, pulsar más teclas o recargar no repite el pago. Salir de una ronda incompleta no da un premio nuevo. Los controles y animaciones se retiran al abandonar el modo.

Se conservan las reglas locales previas: diez pichadas; vuelo de 900–1,230 ms, blanco de timing .84, ventanas basadas en Contact y posibilidad de HR por Power; distancia previa con máximo de 520 FT y 300 Coins por HR. El Derby continúa sin consumir energía. No se cambian las reglas de temporada ni sus lanzamientos.

La apariencia se adapta de la cámara del partido y de los recursos ya existentes del juego. No hay una grabación completa del Derby original que permita afirmar paridad histórica en distribución, fórmulas o premios. La captura anterior procede de la compilación real 1.0.4, cargada únicamente en el servidor local de pruebas con el mismo perfil sintético. Los binarios de comparación y diagnóstico se excluyen de la publicación.

Guardado v23 / SQLite v4. Sin cambio de modelo o servidor, sin migración y sin reiniciar cuentas. Los consejos siguen en español; menús y resultados, en inglés. Capturas: `build/qa/release1005`. Comparación: `COMPARACION_MEJORAS_1005.html`.

Publicación verificada: build `d53301a734e7ded6`. Dos suites locales y una en HTTPS aprobadas. Ronda completa de diez pichadas con resultados diversos y otra sin Home Runs, contacto medido, pausa en preparación/vuelo/resultado, pérdida de foco, teclas mantenidas, premio único, repetición, salida, guardado, recarga y navegación repetida. Se retiraron solamente las cuentas sintéticas reservadas; las cuentas existentes se conservaron. Copia SQLite íntegra verificada dentro del volumen del servidor.
