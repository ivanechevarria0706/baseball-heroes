# Presentación del autojuego · 0.10.14

Se mejora la parte que ocupa la mayor parte del encuentro: las jugadas automáticas de compañeros y rival. No se aumenta la frecuencia de turnos del héroe ni se cambian las probabilidades, el orden, la energía o las recompensas.

## Cambios visibles

- Alineaciones con cabecera separada, marco blanco, degradados, logo y marcador grande: local a la derecha, rival a la izquierda. Números legibles, barra de nombre, AVG, indicador de condición y resultado anterior 1B/2B/3B/HR/OUT/BB.
- La fila de un Special Batter muestra su carta, nombre y retrato, en lugar de la identidad del jugador sustituido. El resto conserva a sus compañeros. Los amigos vinculados muestran su apariencia disponible en la caché social; no se consulta la red al avanzar bateadores.
- Resultados verdes/rojos grandes e inclinados sobre el jugador activo. La tipografía se incrusta para mantener el lettering en Chrome. Las etiquetas se reutilizan y cachean al mostrarse; no se dibujan TextFields sueltos a BitmapData, una operación que aborta la llamada AVM en Ruffle.
- Diamante compacto con bases, pelota y corredores. El motor entrega referencias del estado anterior y posterior ya resuelto; la presentación anima esos destinos. Un strike out no muestra pelota bateada ni carreras. Al terminar la animación se reconcilian las bases finales.
- Columnas R/H con los totales reales del partido, celda de entrada activa, círculo COMBO, aviso de carreras y detalle RBI, y LEADERBOARD con relieve.

## Ritmo y límites

Se mantienen las mismas funciones simulationDelay, resultDelay, nextBatterDelay, heroTransitionDuration y heroReveal. x4 usa 470 ms, x2 880 ms y x1 1650 ms como demora base; siguen respetando el audio y la carta especial. La animación de bases se ajusta a la espera ya existente. No añade una cinemática larga entre cada compañero. Entrada manual: 1600 ms, incluyendo intervalo de campo vacío, corte y revelado.

Las trayectorias de pelota son ilustrativas. Los corredores sí terminan en las bases que resolvió el motor, usando los mismos objetos de jugador. No se introduce una segunda simulación ni se invoca Math.random para dibujar jugadas. La condición local procede de la instantánea del encuentro; el rival usa una flecha neutral. Los diseños y fuentes son reconstrucciones guiadas por las referencias, no una recuperación idéntica de los recursos Flash.

## Conservación y verificación

Todos los archivos del modelo y servidor tienen los mismos hashes que 0.10.13. Game.as solo añade dos copias del estado anterior de bases, dos llamadas de presentación y el envío de hits al panel; al quitar esas líneas es idéntico al archivo anterior. HUD y cinemática manuales conservan sus hashes. La cabeza 0.8.6, cabello, bateo, pichadas Rookie, Mastery, precios, tutoriales y guardado v23 / SQLite v4 se conservan. No hay imágenes ni audios nuevos en el paquete.

Chrome: 27 comprobaciones del panel, siete resultados, nombres de carta, objeto de fila conservado, reutilización del lettering, botones reales x1/x2/x4, marcador por entrada y extras, bases finales, strike out sin pelota, carta especial legible, handoff, limpieza y ausencia de premios desde presentación. Se verifica el ejecutable público con cuenta nivel 1/Rookie, héroe cuarto en el orden, una sola carga de energía, velocidades, ausencia de consultas sociales durante el juego y reentrada a la misma fixture tras recargar e iniciar sesión.

Un diagnóstico del motor juega un encuentro completo a 30 FPS y comprueba nueve entradas, las nueve filas estadísticas, conciliación de hits/HR/RBI/at-bats, avance de temporada una vez y NEXT sin premio repetido. Las partidas antiguas v21/v22 se verifican por separado. Las cuentas temporales se retiran al terminar; no se declara una prueba física con dos computadoras.

Muestra local de diagnóstico: 4004 fotogramas; p95 34 ms y máximo 161 ms. Incluye cambios de fase y otras pruebas simultáneas; no garantiza el rendimiento de todas las computadoras.

Publicada y verificada en Railway. Build 5968177351296d90.
