# Baseball Heroes 1.0.34 · TEAM ilustrado

**Publicada y comprobada por HTTPS.** La cuenta temporal QA se retiró y se conservaron las cuentas anteriores.

## Alcance

Tres clases: TeamScreen, TeamRosterTile y TeamFieldArtwork. Nueva composición 4:3 con MatchResourceBar, ClassicChrome y ClassicActionButton. El roster usa doce fichas por página y conserva su orden. Cada ficha tiene retrato, nombre, posición, OVR y marca IN LINEUP/RESERVE obtenida del orden actual. Seleccionar solo pinta su borde; no reconstruye todos los retratos. La ficha lateral muestra nombre completo, posición, grado, nivel, OVR, estado FORM, Power/Contact/Luck y AVG/HR/RBI. Power y Contact conservan su bonus de equipo del héroe y Luck conserva su valor base anterior. Las barras se limitan visualmente a 0–100 y no limitan los números ni escriben estadísticas.

ROSTER POSITIONS toma la primera persona del roster con cada posición. Es un resumen de posiciones base, no un editor ni una asignación nueva de defensores. LINEUP sigue siendo la pantalla del orden al bate y las cartas especiales permanecen en CARDS/LINEUP. Una posición ausente muestra OPEN y no actúa. Seleccionar un retrato del campo busca la ficha original y cambia a su página si hace falta.

TRAIN y SKILLS reciben al seleccionado; EQUIP sigue gestionando al héroe y la ayuda lo explica. CARDS, LINEUP y HOME conservan sus callbacks. Las flechas quedan inactivas en los extremos. La consulta no guarda ni concede recursos, no vuelve a sortear forma ni llama a operaciones de entrenamiento. Se retiran listeners, retratos, cargas de imágenes y reloj al cerrar. No se añade un ENTER_FRAME propio a TEAM.

## Arte y límites

Un PNG nuevo: assets/reference/v1034/team-field.png. Se generó mediante la herramienta integrada image_gen y se copió con sus bytes intactos. Prompt completo en assets/reference/v1034/provenance.json; dimensiones y SHA256 en manifest.json. Se muestra la imagen completa con escala uniforme y píxeles compartidos. Es una reconstrucción del remake, no arte original recuperado ni una vista confirmada por el gameplay. Retratos y sprites de acciones/atributos se reutilizan; las cabezas y el arte anterior se conservan por hash. No se afirma paridad exacta ni mejora general de FPS.

## Verificación

WebMain de producción sin instrumentación en Chrome: registro sin código, nivel 1/Rookie/6,000 Coins/sin lentes, personaje creado y TEAM. Seleccionar fichas/campo conserva roster completo, apariencia, orden, equipo y recursos. Entrar en SKILLS con un compañero y pulsar LEARN modifica únicamente sus tres campos de habilidad; el héroe y los demás jugadores se conservan. CLOSE vuelve a TEAM. TRAIN, EQUIP, CARDS y LINEUP abren sus pantallas y Esc sale sin gasto. Una condición QA de treinta jugadores verifica páginas, nombre largo, selección del héroe desde el campo y aprendizaje del último suplente; al recargar conserva su progreso. La ampliación del roster solo afecta a la cuenta QA.

Diagnóstico privado fuera de web/src y de staging: páginas 12/12/6, ambos límites inactivos, nombres y textos dentro de sus cajas, callbacks TRAIN/SKILLS con el objeto correcto del suplente 29, selección desde el campo con salto de página, HOME/EQUIP/CARDS/LINEUP, estado completo sin mutaciones durante consulta, controles retirados sin efecto y posición de pitcher ausente con OPEN inerte. bhTeam34 no está en el SWF público. Sin errores JS/AVM2 en los recorridos finales.

La misma prueba de producción pasó por HTTPS. Se contrastaron los 143 archivos instalados y se retiró la cuenta QA preservando las cuentas anteriores.

## Publicación

Build 0bc4abd51373b722; SWF SHA256 2ea30e1a2b296c73e5645f0b461a2caa5cc7ed2d4606fd340d24755c834938e9; 44,060,708 bytes. Paquete de 147 archivos y biblioteca 8edf4856b1c84d2c4f14789b698812bba999334607dabe560eecae55d29197d1 con 114 archivos y 113 recursos reutilizados mediante enlaces duros. El campo está embebido en SWF; se conserva el digest de recursos externos. Guardado v24, SQLite v4 y resetEpoch conservados, sin reinicio de datos. Copia SQLite previa con integrity_check y SHA256 comprobados.

La biblioteca antigua 1.0.28 se archivó localmente y se verificaron sus 114 archivos antes de retirar su carpeta remota. Ejecutable y manifiesto en build/qa/release1034/archived1028-*. Las versiones 1.0.33 y 1.0.32 se mantienen en Railway. research/restore_archived_library1034.py 1028 restaura la biblioteca archivada sin activarla y exige espacio antes; restaurarla es necesario para reactivar esa versión antigua. Bases de datos y respaldos no se eliminan.

[Comparación visual](COMPARACION_MEJORAS_1034.html). La prueba entre dos computadoras físicas sigue pendiente.
