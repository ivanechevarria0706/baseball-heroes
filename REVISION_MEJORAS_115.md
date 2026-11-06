# Retratos y pausa del autojuego · 0.10.15

Se continúa la mejora del autojuego: caras más legibles, pausa y activación de la copia correcta de la carta. No se aumenta la frecuencia de bateo del héroe.

## Retratos

LineupPortrait mide 32 ventanas de cabeza en la hoja 11_09 proporcionada. Reutiliza IllustratedSprite y su caché; el recorte y la escala ocurren en memoria y el PNG mantiene su hash. Las caras de compañeros y rivales llenan mejor la fila. Las cartas especiales usan su encuadre de cabeza; Lenard conserva su ilustración propia.

El héroe y otros jugadores con apariencia personalizada conservan su retrato anterior. La cabeza aprobada 0.8.6 y el cabello no cambian. Las asignaciones de nombres CPU al atlas siguen el registro determinista existente; no se presentan como identidad original confirmada. La comparación incluye una hoja de revisión de los 32 encuadres.

## Pausa del autojuego

El botón || / triángulo detiene el autojuego. Congela resultados, cartas, corredores y el reloj de presentación. Game desplaza solo simulationNextAt y simulationResultUntil por la pausa acumulada. Por tanto, al continuar se conserva el tiempo que quedaba, sin resolver otra jugada ni repetir la anterior.

Se permite elegir x1/x2/x4 estando en pausa; la selección se aplica al ritmo posterior sin reanudar por sí sola. No permite pausar el handoff ni el turno manual. Al ocultar o disponer del panel se retira el estado visual de pausa. No se persiste en el guardado. Los temporizadores de cuenta mantienen tiempo real; un efecto breve ya iniciado puede terminar y no se reproduce de nuevo al continuar. El vídeo demuestra el icono de pausa, no sus reglas completas: este comportamiento concreto se reconstruye para el autojuego.

## Carta equipada

La activación anterior buscaba una carta del catálogo por nombre. Una copia con id propio podía mostrar NOT OWNED y perder su mejora visible. Game ahora entrega directamente el objeto specialCard que está usando. La ventana conserva id de instancia, clase, grado, mejora y cargas. Mostrarla no compra, consume ni premia nada. Se añade una breve escala de entrada, conservando la espera existente de 1250 ms.

La reproducción de este error en diagnóstico compara una Golden Ken mejorada con id special_qa115 frente a la búsqueda anterior por nombre. La ruta antigua indica NOT OWNED; la nueva muestra la copia propia y mejora +2. No es una compra realizada en una cuenta del usuario.

## Verificación y conservación

Los modelos y servidor tienen los mismos hashes que 0.10.14. Game.as solo añade la contabilización de pausas de simulación y sustituye el argumento de la activación; al retirar esas modificaciones vuelve a ser idéntico al archivo anterior. Permanecen los tiempos x1/x2/x4, cartas, probabilidades, economía, pichadas y guardado v23 / SQLite v4.

Chrome: 73 comprobaciones nuevas de encuadres y reloj; 27 del panel anterior. Botones reales, popup de una instancia propia mejorada, reloj y escala detenidos a la vez, velocidad durante pausa y handoff sin pausa. El motor se pausa tanto durante un resultado como entre bateadores: quedan estables entrada, carreras, jugadores, economía y estado pendiente; los plazos conservan la espera restante.

La versión pública se prueba localmente y en Railway con una cuenta temporal nivel 1/Rookie: héroe noveno para observar el autojuego, región visual idéntica durante la pausa, cobro único de energía, recarga y reentrada a la misma fixture, apariencia y cierre/inicio de sesión. Se comprueba también carga de partidas v21/v22. Las cuentas temporales se retiran al acabar.

Partido completo tras las pausas: PASS: full live match of 12 innings and 18 manual pitches (home halves: 12); all nine score rows reconcile hits, HR, RBI and at-bats with game totals; saved result reload; season advanced once; HUD isolation; NEXT callback once with no duplicate reward.

Muestra local: 5049 fotogramas, p95 35 ms y máximo 161 ms; incluye otras pruebas simultáneas. No se declara una prueba física entre dos computadoras.

Publicada y verificada en Railway. Build eb80ec34a6a0e93e.
