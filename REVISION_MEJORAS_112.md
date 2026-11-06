# Animaciones de entrenamiento · 0.10.12

Se implementa el primer avance propuesto: al pulsar START en cualquiera de las 18 sesiones, el héroe realiza el ejercicio elegido junto a su entrenador. Se mantienen los sistemas de 0.10.11; no se implementan todavía Mastery original ni las cartas originales, que son los siguientes dos bloques.

## Presentación

- 48 poses ilustradas nuevas para STRETCHING y LIFTING: cuatro por sesión. RUNNING reutiliza el cuerpo del corredor, con distintas cadencias, sliding y accesorios para la sesión elegida.
- El héroe lleva su forma de cabeza, pelo, colores, ojos, nariz, boca y detalles guardados. Se adjunta el mismo BatterHead086 aprobado, sin casco durante el ejercicio. No se altera el bateador ni la cabeza del partido.
- Entrenador correspondiente, sala vacía, progreso visual y rótulos de Mastery / XP. STRETCHING sitúa al héroe a la izquierda de su entrenadora, como el cuadro de referencia.
- La presentación dura 4.8 s y vuelve automáticamente a la sala con el descanso activo. CONTINUE permite salir antes. Los consejos están en español y los títulos de ejercicio en inglés.
- Los recortes se aíslan en memoria para quitar fragmentos de celdas vecinas. Los archivos generados conservan sus píxeles y transparencia. Los cuadros del cuerpo se almacenan en caché; cada fotograma de animación no vuelve a tintar imágenes ni consulta la red.

## Pago, guardado y salida

GameData.startDisciplineTraining sigue siendo el único propietario de compra, premio y descanso. La escena solo recibe el resultado ya pagado; no llama a save(), no da XP y no modifica relojes. Un doble clic, saltar o cerrar la escena no repite el pago ni el premio. Si se recarga durante el ejercicio, permanecen el resultado pagado y su descanso; no se vuelve a reproducir la escena automáticamente. Abrir un catálogo en descanso no reproduce otra sesión.

Todos los archivos del modelo, servidor, puente de guardado, cartas, sobres, tutorial, pichadas y partido mantienen sus hashes de 0.10.11. Guardado v23 / SQLite v4. Las cuentas nuevas continúan en nivel 1 / Rookie y las carreras antiguas conservan RUNNING y las dos disciplinas añadidas en 0.10.11. No se resetea el progreso.

## Evidencia y límites

La grabación `baseball heroes eliminatorias final de la liga.mp4` muestra las escenas de RUNNING y STRETCHING y el catálogo de LIFTING. Las nuevas poses, máquinas y sala son reconstrucciones con image_gen basadas en ese material y en la hoja 11_08, no una recuperación de los sprites originales. Las distintas grabaciones no proporcionan todos los cuadros intermedios ni las secuencias de las 18 sesiones. Tampoco recuperan una curva completa de Mastery ni la condición exacta del premio de energía.

Los cuatro archivos de arte, los prompts completos y la procedencia se documentan en [assets/sprites/v112/README.md](assets/sprites/v112/README.md). Se utilizó la herramienta integrada image_gen; no se usó el CLI alternativo.

## Pruebas

Chrome local: las 18 compras y secuencias con entradas reales, movimiento de los cuadros, identidad de cabeza, texto sin recorte, salida automática, CONTINUE, cierre de pantalla, clic repetido y carga posterior sin premios extra. Se renderizan 72 estados de cuerpo/cabeza, incluidas las 48 poses nuevas, y se vuelven a ejecutar las 149 comprobaciones del modelo de entrenamiento anterior.

El ejecutable público se prueba localmente y en Railway con una cuenta temporal: registro nivel 1 / Rookie, apariencia personalizada, recarga durante Walking Lunge, fin automático de Push-Up, pagos exactos, clic repetido, RUNNING antiguo intacto, tres relojes y cierre/inicio de sesión. También se comprueba carga de partidas v21/v22. Las cuentas temporales se retiran al finalizar. No se declara una prueba física entre dos computadoras.

Muestra local de la versión de diagnóstico: 765 fotogramas, p95 43 ms y máximo 308 ms (incluye cambios de sesión y calentamiento de caché; no es una medición de todas las computadoras).

Publicada y verificada en Railway. Build f480c65536f9aa2d.
