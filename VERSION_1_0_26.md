# Baseball Heroes 1.0.26 · LEVEL UP ilustrado

**Publicada y comprobada por HTTPS.** El partido completo y la subida de nivel también pasaron en la web pública. La cuenta QA se retiró y las cuentas anteriores se conservaron.

## Cambios

Cabecera con estrella azul de facetas, rótulo dorado inclinado y número dinámico. Insignia SKILL como pelota ilustrada, Coins y energía con sprites existentes; una moneda ilustrada acompaña también el total del resultado. La entrada de la cabecera dura 340 ms y retira su listener al terminar, cerrar o quitar la ventana del escenario. Los objetos se centran si solo hay uno o dos, y los nombres admiten dos líneas. Se conservan CONTINUE, las cantidades acreditadas y el comportamiento de navegación.

Referencias: `reference_visual/initial_audit_20261015/frame-0352.jpg` (nivel 2, 05:52) y `reference_visual/facebook_play_20261012/frame-0000.0.png` (nivel 12). Cabecera y SKILL son reconstrucciones. Los recortes de monedas, energía y los objetos observados ya existían. No se cambian tablas de desbloqueo o premios; cuando el resumen no trae objetos nuevos, se muestra CAREER PROGRESS.

Solo cambian LevelUpOverlay, ResultPaperSkin, GameResultPanel y la nueva LevelUpArtwork. GameData, probabilidades, progresión, reservas, servidor, web, audio, guardado v24 y cabeza aprobada 0.8.6 se conservan por hash.

## Herramienta, archivos y prompts

Se usó **image_gen integrado**, sin CLI de imágenes. Ambos PNG se copiaron sin editar y conservan alfa 0–255. El código obtiene cuatro fragmentos de hasta 1024 px; SKILL usa el recuadro medido 209/208/833/837, que evita que el alfa tenue de sus márgenes reduzca el icono. No se modifica el PNG ni se redibuja por cuadro. Caché compartida: 9,078,996 bytes de píxeles (8,66 MiB).

- [Cabecera PNG](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1026/level-up-header.png>) · [prompt completo y referencia](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1026/provenance.json>)
- [SKILL PNG](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1026/skill-badge.png>) · [prompt completo y referencia](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1026/skill-provenance.json>)

## Pruebas

Dos recorridos locales en Chrome. El diagnóstico local reproduce niveles 2/12/100, resúmenes antiguos con nombres largos, cero/uno/dos/tres premios, disposición de vistas previas, cierre durante la animación, navegación bloqueada por la ventana y ocho ciclos de apertura/cierre. Las capturas comparativas del nivel 12 usan un fixture; no se modifican cuentas reales. El diagnóstico se excluye de producción.

El segundo recorrido usa WebMain real sin hooks: registro de nivel 1/Rookie/6,000 Coins/sin lentes, confirmación del personaje, cuenta QA colocada a un XP de nivel 2, partido completo, 2,000 Coins de nivel y un punto acreditados una sola vez. CONTINUE se pulsa a la escala real de 590 px del partido y se verifica visualmente su desaparición. HOME y recargar conservan premios, XP y apariencia. Sin errores JS/AVM2 en los recorridos finales.

El mismo partido completo pasó por HTTPS. Los 143 archivos instalados coinciden, SQLite está íntegro y se retiró exclusivamente la cuenta QA conservando las anteriores.

## Publicación y conservación

Build `ec8b191f4999e3ef`, SHA256 `3888e9670aa93db39888cdbae830c808439e199121588a1a55c41e8c720e79b3`, 36,484,741 bytes de SWF. Aumento de unos 2 MB respecto a 1.0.25; no se afirma una mejora general de FPS. Paquete de 147 archivos, biblioteca `b9f640013beba9ab931478854d58e761096855f79027c63aad9c958c94e6d488` de 114 archivos y 113 recursos sin cambios enlazados en el volumen. Copia SQLite previa con integridad comprobada.

Para disponer de espacio se archivó localmente el candidato 1.0.19 que nunca se activó, biblioteca `5a3a0d3e04c54e98e406f08cf32299764a8d8ae4988755923bbac660ff187e52`, SHA256 `5f29dcf085fc1e20224daf84e7500a699f99ebf91eb1d09ba5119f7b5fe668a3`. Se comprobaron sus 114 hashes y los 113 recursos locales antes de retirar únicamente su carpeta. Se verificaron de nuevo los 114 archivos instalados; las bibliotecas publicadas y bases de datos se conservaron. Evidencia: `build/qa/release1026/storage-maintenance.json`.

[Comparación](COMPARACION_MEJORAS_1026.html). Sigue pendiente la prueba de amigos en dos computadoras físicas.
