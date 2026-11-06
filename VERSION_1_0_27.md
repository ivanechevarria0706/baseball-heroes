# Baseball Heroes 1.0.27 · draft de amigos

**Publicada y comprobada por HTTPS.** La prueba pública con dos cuentas QA pasó. Sus datos se retiraron y se conservaron las cuentas anteriores.

## Cambios

FriendDraftScreen comparte ahora MatchStadium, con el fondo y objetos activos. La composición sigue la referencia `reference_visual/initial_audit_20261015/frame-0386.jpg`, 06:26: cabecera blanca, escudo del club, franja de introducción, escala, tablero y AUTO PICK dorado en forma de flecha. Se conservan los 25 puestos en la organización 5×5 del remake, que difiere del encuadre del video. No se inventa una fórmula para EXPECTED POTENTIAL.

Las fichas elegidas y los candidatos muestran HeroHead con la apariencia publicada por cada amigo aceptado, encajada por sus límites reales para conservar peinados. Los puestos vacíos usan InterfaceSprite/batter. No se añaden PNG ni imágenes generadas; se reutilizan los recursos existentes. La flecha y el marco usan gráficos nativos.

Se corrige Search para que reciba foco e input físico. Se añaden páginas de cinco candidatos, retirada pulsando la ficha elegida y aviso del límite de cinco. AUTO PICK sigue eligiendo los primeros cinco aceptados. CONTINUE conserva el orden para HOME y los bonos de amistad existentes. Una actualización social fallida no borra los IDs guardados; una respuesta válida limpia la selección visible de vínculos que ya no están aceptados al confirmar.

Solo cambian FriendDraftScreen y las nuevas DraftAutoPickButton/FriendDraftPortrait. El snapshot de fuentes se tomó justo después de crear esas dos clases todavía sin referencias; la comparación de fuentes las trata explícitamente como nuevas, comprobando que no aparecen en el FriendDraftScreen anterior y conservando el SWF 1.0.26 por hash. GameData, web, servidor, fórmulas, cabeza 0.8.6, audio y guardado v24 se conservan. La selección no crea amistades ni envía regalos.

## Pruebas

Chrome con WebMain real, sin hooks de diagnóstico. Una cuenta dueña y siete amigos QA locales se registran y aceptan sus vínculos mediante la API normal; sus apariencias publicadas se cotejan contra los datos guardados. Carrera nueva de nivel 1/Rookie/6,000 Coins/sin lentes. Se verifican draft sin amigos, búsqueda con teclado y selección del ID exacto, segunda página, límite de cinco, retirada de una ficha, AUTO PICK, orden después de recargar, cuatro reaperturas y fallo de actualización social. Cambiar de ficha o buscar no consulta el servidor por cuadro ni envía operaciones sociales. Coins, energía, cartas, aspecto y bonos se conservan. Sin errores JS/AVM2 detectados.

El recorrido público también pasó con dos cuentas QA y una amistad aceptada; no se usaron perfiles humanos para la prueba. Se verificaron los 143 archivos instalados y SQLite. Las dos cuentas QA y sus relaciones se retiraron, conservando las cuentas anteriores.

## Paquete y conservación

Build `1a60f1726bd4b880`, SWF SHA256 `e3f93d91ed6b218ae8e14d77c644b8697ef5b0ff15e5df88779f318cd8e27443`, 36,486,719 bytes. Solo 1,978 bytes más que 1.0.26. Paquete de 147 archivos y biblioteca `ef64556082fa42796f07496ab690c5f3cd719b7f31bcead8ee164158c0a602cb` con 114 archivos verificados; los 113 recursos existentes se enlazan sin duplicarlos. No se afirma una mejora general de FPS.

Se archivó el candidato 1.0.22 nunca activado, biblioteca `dbb168c7309760d4c73856ef03e1c7ba7379de372637f8f7c7acace3aee201ef`, y se retiró únicamente su carpeta del volumen después de comprobar sus 114 hashes y los recursos locales. El SWF y el manifiesto quedan en `build/qa/release1027/unactivated1022-*`. Se cotejaron de nuevo los 114 archivos instalados; las versiones publicadas y las bases de datos se conservaron. Copia SQLite previa comprobada. Sigue pendiente la prueba física de amigos en dos computadoras.

[Comparación](COMPARACION_MEJORAS_1027.html).
