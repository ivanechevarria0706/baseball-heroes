# Baseball Heroes 0.6.2 — ciclo de cartas especiales

Cada copia es ahora un ejemplar independiente: conserva su mejora, energía, estadísticas y posición en la alineación. Se pueden equipar dos cartas del mismo personaje. El catálogo ilustrado existente permanece disponible.

## Cómo usarlo

Abre **JUGAR.bat** y entra en **SPECIAL BATTERS** desde LINEUP. **TRADE** abre el intercambio. Selecciona una carta y pulsa **MANAGE** para acceder a **ENHANCE** o **CHARGE**. Todas las operaciones muestran una revisión del coste antes de confirmar; BACK y CLOSE cancelan sin gastar.

- **TRADE:** selecciona tres ejemplares distintos de clase C, B o A. Pueden ser de personajes o grados diferentes. Los titulares quedan excluidos. Se consumen esas tres copias y se revela una carta nueva. Las cartas de clase S ya están en la clase máxima.
- **ENHANCE:** Elite y Hero admiten mejoras individuales hasta +5. Cada paso añade .010 al AVG mostrado y 3 a sus atributos, con el límite de 99; +5 añade 1 al combo base. Los fallos con monedas conservan la carta y su mejora. MAX calcula lo que falta para +5.
- **CHARGE:** cada carta tiene dos unidades y consume una al iniciar un partido. La recuperación continúa con el juego cerrado. Con 0/2, el siguiente partido utiliza al compañero regular de ese puesto. Un partido que ya pagó la carta mantiene su participación y su combo hasta terminar.
- **Interrupción:** cerrar el juego o volver al menú conserva el pago y las cartas reservadas. Al volver a PLAY, el partido empieza otra vez desde la primera entrada sin otro cargo de energía. No se guarda el estado de cada jugada. Mientras esté pendiente, la alineación especial y sus mejoras quedan reservadas hasta obtener el resultado. Las estadísticas de carrera ya anotadas durante intentos anteriores se conservan, como en la versión previa.

## Evidencia y balance local

Los gameplays confirman copias con mejoras diferentes, tres cartas de la misma clase para TRADE, exclusión de titulares, Elite/Hero en ENHANCE, +5 en las cartas Hero observadas, +.050 de AVG y una energía por juego. Referencias: tercer gameplay, 10:23–10:35, 11:17–11:30, 12:40–13:28 y 15:17–17:10. Consulta `COMPARACION_CICLO_CARTAS.html` para ver los fragmentos junto a la implementación.

Las siguientes cifras completan lo que el servidor original no permite comprobar. Son balance local, no probabilidades recuperadas:

| Operación | Regla de esta versión |
|---|---|
| TRADE con monedas | 1.000; 50% clase siguiente, 50% misma clase; siempre entrega una carta |
| TRADE premium | 13 de moneda del juego; siguiente clase garantizada |
| Grado del resultado | A 60%, Rare 25%, Elite 12%, Hero 3%; conserva la distribución local de sobres |
| ENHANCE con monedas | 2.500 por intento; éxito 80/70/60/50/40% para pasar de +0/+1/+2/+3/+4 |
| ENHANCE premium | 3 por paso, 100%; MAX = 3 × pasos restantes |
| Recarga natural | Una unidad cada tres horas, máximo dos |
| Recarga inmediata | Una unidad de moneda premium del juego por energía faltante |

El precio de MAX visto en video depende del estado; no se usa 12 como precio universal. La extensión de +5 a todas las Elite/Hero y el aumento de atributos conservan reglas locales. No hay pagos ni conexión a un servidor.

## Conservación de la partida

El identificador de la aplicación sigue siendo `com.personal.baseballheroesremake`. El guardado pasa de v20 a v21. Antes de migrar se conserva una copia completa separada, `baseballHeroesRemakeSave_before_v21`, dentro del almacenamiento local de AIR.

Cada carta antigua genera su ejemplar principal y tantas copias sin mejora como indicaba su contador de duplicados. El principal conserva su identificador, estadísticas, campos adicionales y nivel equivalente (+0/+1/+2 para los antiguos niveles 1/2/3). También conserva como mínimo el combo que ya había ganado; esto incluye cartas antiguas de grado normal o Rare que ya tenían mejoras. No se generan cartas iniciales otra vez al intercambiarlas. Se mantienen monedas, temporada, héroe, equipamiento y los cuatro efectos de audio del usuario.

Las bases por bolas nuevas de cartas especiales se registran separadas de los turnos oficiales al bate. Las estadísticas antiguas se conservan tal como estaban.

## Verificación

Compilación AIR; migración en procesos separados de una colección de 33 principales y 48 duplicados; segunda carga sin duplicación; copia previa intacta; transacciones, fondos insuficientes, copia equipada, selección repetida, fallo y máximo de mejora; consumo de energía, recarga por tiempo y reinicio del partido pagado. Prueba de botones reales con capturas a 960×720, cancelación y doble confirmación. Partido completo con dos ejemplares del mismo personaje empezando con una energía cada uno y estadísticas separadas reconciliadas con el resultado.

Los informes vigentes figuran en `revision_manifest.json`. Todas las pruebas utilizan identidades AIR de prueba; no abren ni alteran la partida real. Los informes de otras versiones son históricos.

Esta entrega completa el ciclo de cartas. La celebración y el cierre inmediato de WALK-OFF, Roadmap ampliado y Hall of Fame observados en los videos quedan para próximas revisiones.
