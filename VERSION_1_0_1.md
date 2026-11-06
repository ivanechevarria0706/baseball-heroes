# Baseball Heroes 1.0.1 — anotaciones de la prueba

Actualización del 14 de octubre de 2026. Conserva las cuentas y partidas de 1.0, el inicio en nivel 1 / Rookie y los tutoriales y consejos en español.

1. **Cabello.** Ajustado el encaje de la raíz y las sienes a la cabeza elegida. Revisadas las 64 combinaciones de ocho cabezas y ocho peinados. La cabeza del bateador de 0.8.6 se conserva.

2. **Sin lentes iniciales.** El personaje nuevo y la vista del creador empiezan sin lentes. Un slot de lentes vacío sigue vacío después de recargar. Los lentes que ya estaban equipados se conservan.

3. **Ruleta de metas.** Los objetivos ruedan en dos ventanas, frenan por separado y terminan en las metas guardadas. Pulsaciones repetidas durante el giro no generan nuevas tiradas; ACCEPT termina la presentación y acepta los objetivos.

4. **Apertura de cartas.** El sobre entra con movimiento; al abrirse tiembla, destella y presenta la carta con giro, rayos y partículas. OKAY aparece al terminar la revelación.

5. **Cartas en SUBSTITUTE.** Las cartas compradas aparecen en ALL y SPECIAL con su ilustración y energía. Un clic activa la copia elegida en un slot especial libre. Si todos están ocupados, la carta permanece en la banca y se indica cómo cambiar un slot. La compra persiste al recargar; no cobra de nuevo al activarla.

6. **Entrada al partido.** Los equipos entran desde ambos lados, VS aparece con un golpe visual, el estadio se revela con un acercamiento y la pelota termina la transición. Se muestra el mismo lanzador ilustrado del partido; BACK y SKIP siguen disponibles.

7. **Impacto del Home Run.** Batazo reforzado a partir del sonido limpio aportado por el usuario. La pelota y la pose de contacto se mantienen 130 ms en el bat y después continúa el vuelo. Los hits normales y fouls conservan su impacto habitual.

8. **Fuego de MAX COMBO.** Llamas naranjas, centro amarillo, brasas y un rótulo pulsante bajo los pies. El fuego desaparece al consumir el combo. No cambia las reglas de carga ni la velocidad de los lanzamientos.

9. **Victoria y derrota.** Dos señales instrumentales originales, de 3.2 segundos, diferentes para ganar y perder. Respetan el volumen de efectos y se detienen al salir del resultado. No contienen voces de los gameplays.

Validación: compras en el juego público con recarga, tutorial completo, un partido completo y contenido existente; pruebas específicas de las nueve anotaciones. Los informes están en `build/qa/release1001`. La guía visual es `COMPARACION_MEJORAS_1001.html`.

Los audios nuevos son reconstrucciones instrumentales; no se presentan como archivos recuperados del juego original.

Publicación verificada: build `5e4d58efb1290cf0`, seis suites locales y tres suites en HTTPS. Se eliminaron únicamente las cuentas sintéticas de verificación; se conservaron las cuentas existentes. Copia de seguridad verificada en el volumen del servidor.
