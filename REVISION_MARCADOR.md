# Baseball Heroes — marcador clásico 0.5.1

Reconstrucción del HUD de bateo a partir de la pantalla del video F.A.F. alrededor de 383 s. Esta revisión adapta esa distribución al lienzo de 960×540 del remake; no convierte todas las pantallas a 4:3.

## Presentación

- Barra de recursos compacta con estrella de nivel, energía, moneda y billetes dibujados, distribuidos por la parte superior.
- Dos marcadores separados, entrada en el centro y tres bases que se iluminan según la ocupación. La fila B/S/O tiene puntos de mayor tamaño.
- Minimap con diamante y pequeños corredores genéricos con el color del equipo. Las ocho combinaciones de bases se reflejan también en el marcador.
- Panel inferior de 52 píxeles, antes 69, con habilidades, AVG/HR/RBI/HIT, metas de temporada y puntuación. El nombre del bateador aparece encima del panel.
- Retrato correspondiente al bateador activo, en lugar de mantener siempre al héroe principal.
- Indicador circular de combo basado en el valor existente del remake. Su límite visual corresponde al umbral MAX COMBO de 80; no cambia las bonificaciones ni afirma reproducir el combo histórico.
- Nombres largos ajustan tamaño y, si aún no caben, usan puntos suspensivos. Los nombres guardados permanecen completos. Las cifras grandes y entradas adicionales también se ajustan.
- Objetivo de bateo amarillo con borde turquesa suave, sin la cruz central dibujada. Su pulsación depende del progreso del lanzamiento. Se conservan los tiempos de aparición y las fórmulas de contacto.

## Datos en vivo

Las metas de HR/RBI y SCORE se refrescan con el estado actual. Durante el partido incluyen sus hits, home runs y carreras impulsadas pendientes de guardar. Al terminar, el HUD deja de añadir esos valores porque `completeSeasonGame` ya los incorpora a la temporada: así no se cuentan dos veces.

Esta es una actualización de presentación. El HUD no modifica los contadores guardados ni concede recompensas. SCORE conserva la fórmula previa del remake: hits × 125 + RBI × 250; las metas siguen siendo HR y RBI, según el modelo existente. Estos valores no se presentan como fórmulas recuperadas de Syntasia.

## Pruebas

- `HudSmoke`: ocho combinaciones de bases en marcador y minimapa; luces B/S/O; recursos y metas que se refrescan; progreso del partido sin modificar el guardado; ausencia de doble conteo tras guardar; cambio de retrato; nombres largos, monedas de nueve cifras y marcador de tres cifras; ordinales de entradas adicionales; historial limitado a siete jugadas; ciclo de visibilidad y pulsación del indicador de bateo.
- `ContactSmoke`: contacto real con SPACE, NICE visible, pausa de 1.2 s protegida contra entradas repetidas y continuación del resultado.
- `VisualSmoke`: HOME, LINEUP y secuencia de lanzamiento y swing en Rookie y Major.

Registros en `build/qa/smoke-hud.txt`, `smoke-contact.txt` y `smoke-classic.txt`. Capturas `build/qa/v051-*.png` y `classic-*.png`. La captura `v051-hud-stress.png` usa deliberadamente datos extremos de prueba.

Las pruebas usan otras identidades de aplicación. Se conservan el identificador del juego, el formato de guardado y el único audio F.A.F. seleccionado: «Out de simulación». Ejecuta `JUGAR.bat` para abrir la compilación incluida.

## Pendiente

El dibujo de retratos, la tipografía, las proporciones de algunos personajes y las otras pantallas todavía necesitan más trabajo. No hay clasificación en línea: LEADERBOARD/SCORE es la presentación local existente. Esta entrega no constituye una prueba completa de toda una temporada.
