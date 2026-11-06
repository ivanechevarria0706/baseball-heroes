# Mejoras 0.9.6 basadas en los dos videos nuevos

La referencia sigue disponible en `COMPARACION_NUEVOS_VIDEOS_20261010.html`. Esta revisión no incorpora audio de los videos. Mantiene las cuatro grabaciones aisladas del usuario, el guardado v21 y el comienzo nivel 1 / ROOKIE.

## 1. Combo que se acumula durante el partido
Combo con carga propia de 0 a 10. Hits/bases por bolas suman 1; HR suma 2. El héroe consume el impulso al comenzar su turno. El bonus de las cartas sigue separado.

Límite: Umbrales 4/7/10 y bonus de contacto/poder son reconstrucción local.

## 2. COMEBACK CHANCE y efectos del golpe
COMEBACK CHANCE aparece desde la quinta entrada si vas perdiendo y tienes corredores. Incluye asistente e impulso visual.

Límite: Es una oportunidad de remontada; no garantiza hit ni home run.

## 3. SPECIAL MATCH dentro de la temporada
SPECIAL en los partidos 12 y 28: victoria da cofre; derrota suma 500 monedas. Panel WIN/LOSE antes de LEVEL UP y expiración del bate.

Límite: El partido 12 y las 500 monedas se ven en el video. Repetirlo en el 28 es el calendario local previo.

## 4. Energía general: coste y recarga por tiempo
5 de energía por partido nuevo; recuperación de 1 cada 5 minutos, también al cerrar el navegador. Reloj en HOME, viaje, alineación, partido y simulación.

Límite: La cadencia se infiere del reloj del video. Se conserva la capacidad de cada partida anterior; no se inventa una curva histórica.

## 5. Subida de nivel: desbloqueos concretos y llenado
Subir de nivel repone la energía. Nivel 4 abre seis artículos Basic, con tres cinturones en el panel y los seis disponibles en la tienda.

Límite: Los tres cinturones son visibles en el video. Los tres guantes restantes, precios y estadísticas son contenido local.

## 6. LEADERBOARD semanal e histórico con marcas
WEEKLY y ALL TIME, MY BEST, puntuación del partido y reloj semanal. El servidor guarda tu mejor resultado y el de tus amigos aceptados. Premios semanales reclamables una vez.

Límite: Los hitos altos del primer video se usan como tabla local; no se recuperó la regla que elige tablas por nivel/liga. No es un sistema antitrampas competitivo.

## 7. Rachas y multiplicador observado ×3
Dos hits consecutivos del héroe muestran ×3; tres o más, ×5. Los outs simulados de compañeros no rompen la racha del héroe.

Límite: El ×3 está observado. La continuación y el alcance del multiplicador son reconstrucción local.

## 8. Monedas y XP visibles durante las jugadas
Las monedas y XP provisionales aparecen durante el partido. Se añaden al único cierre del encuentro y no se suman de nuevo al refrescar la pantalla.

Límite: Las cantidades por jugada son locales; los cambios de balance sí se ven en los videos.

## 9. Repertorio de ROOKIE y nombres de lanzamiento
ROOKIE incorpora recta de cuatro costuras, dos costuras, curva y cambio. Etiquetas 4-Seam FB / 2-Seam FB y velocidades de rectas en el rango observado.

Límite: SINKER permanece como identificador interno compatible de dos costuras; física, mezcla y probabilidades siguen aproximadas.

## 10. Defensa y carrera en viñetas de OUT
La secuencia defensiva termina con corte diagonal: defensor arriba, llegada a la base y piernas abajo, seguido de OUT. Reutiliza los ocho sprites defensivos.

Límite: No se añadió SAFE: no se observó esa resolución en estos dos clips.

## 11. Logros en vivo y consejos de la asistente
Avisos no bloqueantes de logros conocidos, incluido MR. SINGLE con su contador provisional sobre 150, rachas y ayuda de la asistente. No detienen el lanzamiento ni hacen llamadas de red durante cada jugada.

Límite: Las metas exactas de Hardworking Hitter y Lucky Hitter no están demostradas. No se añaden como logros con criterios inventados.

## 12. Proporciones, cámara, traje y home run
Brillo de impulso bajo el héroe, cámara de aproximación e impacto en las tres escenas de home run, minimapa visible durante las cinemáticas.

Límite: La cabeza aprobada 0.8.6 se conserva. Arte corporal y animaciones aún tienen diferencias con los originales.

## Verificación

- 28 pruebas del servidor: API, cuentas, ligas, privacidad social, ranking, resultados guardados y premios idempotentes.
- Cuenta nueva en Chrome: registro sin invitación, nivel 1 / ROOKIE, personaje, llegada, metas, viaje, alineación, primer partido y recuperación al volver a iniciar sesión.
- Prueba del partido: combo, remontada, premios SPECIAL, subida al nivel 4 con seis desbloqueos, contabilidad provisional/final, ranking y reclamaciones que sobreviven a recarga.
- Postemporada: empates sin premio, reanudación a energía cero de un partido pagado, series, eliminación, campeonato y cierre sin premios duplicados.
- Fluidez local: 45 segundos, aproximadamente 59.9 FPS, percentil 95 de 24–25 ms. Hubo una pausa de 109 ms; esta muestra no garantiza el mismo rendimiento en otras computadoras.
- La cabeza aprobada conserva su SHA256; el paquete contiene únicamente las cuatro grabaciones del usuario para efectos de partido. No incorpora audio de los dos videos nuevos.
- Comparación: doce apartados, 24 imágenes cargadas y revisión sin desbordamiento a 390 px.

Los datos de partida siguen en formato v21. El servidor mantiene SQLite v3 y añade tablas de puntuaciones; se verificó una copia en el mismo volumen de Railway antes del despliegue. No es una copia externa al proveedor.

## Publicación verificada

Versión 0.9.6 · build `250a05f3f267bd9a` · despliegue `c6f8eb52-b5bd-43b5-926b-9f4dbee3a651` activo. Se verificaron 133 archivos en el contenedor, registro sin código, inicio nivel 1 / ROOKIE, equipo, reserva/reentrada, perfiles aceptados, regalos y ranking privado con premios únicos. Se eliminaron únicamente las dos cuentas de prueba y se conservaron todas las cuentas anteriores. Los dos últimos cambios del build ajustan textos de LUCKY HIT y el tamaño del aviso SPECIAL; no modifican las reglas probadas.
