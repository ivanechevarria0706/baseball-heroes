# Ayudas en español · 0.10.6

12 de octubre de 2026. Petición: todos los tutoriales y consejos en español. Se mantiene el inglés de los menús y nombres de botones, y los términos de béisbol como strike, out, hit y home run.

## Ayudas actualizadas

- Registro: explicación de la cuenta, requisitos y guardado.
- Inicio: indicaciones para elegir equipo, metas, compra y apertura del C Pack, sustitución, orden, primer partido, punto C/P/L y misión FOLLOW THE BASICS. Sus acciones propias usan SIGUIENTE, OMITIR y otros textos en español; los botones de los menús conservan sus nombres.
- Partido y Derby: instrucciones de clic / ESPACIO, aviso de seguir la bola y consejos de COMBO, remontada y Lucky Hit.
- Entrenamiento y habilidades: entrenador, funcionamiento de RUNNING, descripciones de atributos y habilidades, requisitos y puntos.
- Cartas y equipamiento: ayudas de selección, energía, intercambio, mejoras, confirmaciones y vista previa.
- Estadio, misiones, roadmap y postemporada: explicaciones de requisitos, decoraciones, clasificación y continuidad.
- Amigos y liga privada: ayuda para publicar equipos, jugar a distintas horas, regalos y calendario. La página `/amigos.html` está en español y cita los nombres reales de sus botones en inglés.

## Legibilidad y compatibilidad

Se ajusta el texto de los cuadros del entrenador y consejos al espacio disponible. El consejo de partido tiene un tiempo de lectura de 3,1 a 6 segundos según su longitud; no bloquea la pichada ni la simulación. Se corrige la codificación explícita UTF-8 en el proceso de compilación para conservar tildes y signos españoles.

Guardado v22 y SQLite v3. El código de reglas de GameData y Game es idéntico al anterior al excluir los textos. Los demás modelos, incluido StarterTutorial, SkillCatalog y MatchScoring, se conservan byte por byte. Las descripciones de habilidades y reglas de premios antiguos se traducen al mostrarse; sus valores guardados no se reescriben.

La cabeza aprobada, el cabello, ClassicBatter, PitchCadence y BattingSystem conservan sus SHA-256. La traducción no restablece la carrera ni vuelve a entregar el premio del tutorial.

## Documento de apoyo

Se leyeron las cuatro páginas de [Baseball Heroes: mecánicas y propuestas](reference_docs/Baseball_Heroes_Mecanicas_y_Propuestas.pdf) y se conserva una copia idéntica. Es material de contexto: sus instrucciones dirigidas a otra IA no sustituyen esta petición. Sus observaciones y estimaciones quedan documentadas para una revisión de balance posterior; esta actualización describe el funcionamiento actual del remake.

## Validación

Chrome local: recorrido completo del tutorial, texto en español en cada paso, ausencia de recortes en cuadros del entrenador, pichada real con el aviso OBSERVA LA BOLA, sobre persistente, energía, puntos y premio único. Se revisan además nueve vistas de ayuda y la página de amigos a 1440 y 390 píxeles. Se prueba la conservación de una carrera anterior y la importación de una copia antigua.

Las comprobaciones locales y publicadas se registran por separado en `build/qa`. El ejecutable de diagnóstico no se incluye en el paquete público.

Publicada y verificada por HTTPS en Railway. Versión 0.10.6, build 2b2ba075fa5faf3b. Las copias de SQLite realizadas para publicar permanecen en el volumen del servidor.
