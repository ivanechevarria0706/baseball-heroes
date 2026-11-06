# Baseball Heroes 1.0.21 · BUILD con sprites

> Incluida en la 1.0.23 publicada. El estado pendiente que se conserva debajo corresponde a su preparación anterior. [Entrega publicada](VERSION_1_0_23.md).

**Preparada, compilada y probada localmente; no publicada.** La web continúa en 1.0.18, build `c1deade3203d0523`. El [estado oficial de Railway](https://status.railway.com/) del 22 octubre de 2026 a las 19:06 UTC sigue indicando que Free y Trial no están habilitados para desplegar. El último rechazo HTTP 400 corresponde a 1.0.19; no se hicieron nuevos envíos durante la misma pausa. La biblioteca 1.0.21 se verificó en una carpeta nueva del volumen, sin activarla ni modificar datos de usuarios.

## Cambios

- Nueve categorías de BUILD: fondo, campo, marcador, gradas, valla, luces, decoración, pancarta y muro. Se sustituyen los símbolos geométricos por sprites ilustrados.
- Cinco decoraciones: bandera, estrella, pelota, trofeo y torre de fuegos artificiales. La tienda, HOME, BUILD y el partido comparten las vistas. Las mascotas de equipos conservan sus logos.
- TICKET SALES reutiliza el cofre ilustrado de HOME. Mantiene la zona de clic, recaudación y espera existentes.
- El estadio inicial tiene una miniatura de Rookie en su ficha de fondo. Las otras miniaturas conservan sus imágenes.
- Esta versión contiene las mejoras preparadas de 1.0.19 y 1.0.20. No es necesario publicarlas por separado.

## Arte y prompts

Se usó **la herramienta integrada image_gen**, sin CLI ni API de imágenes con clave. Son reconstrucciones apoyadas en `reference_visual/build_20261014/frame-590.jpg` (09:50 del video No doy una); no son originales recuperados. Los archivos generados completos se copiaron sin alterar al proyecto, con transparencia real. Los límites de los cuadros se midieron sobre alfa, con margen exterior; no se modificaron los PNG con Python.

Archivos finales:

- [build-categories.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1021/build-categories.png>)
- [stadium-decorations.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1021/stadium-decorations.png>)
- [Prompts completos, herramienta y referencias](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1021/provenance.json>)
- [Ventanas de los catorce cuadros](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1021/manifest.json>)

En ejecución se copian los cuadros con `BitmapData.copyPixels`, se liberan los atlas decodificados y se comparten los cuadros resultantes entre vistas. Caché aproximada: 7,239,984 bytes. Esto corrige una pantalla negra detectada en Chrome con la preparación inicial basada en `BitmapData.draw`; las pruebas finales se hicieron después de sustituirla. No se añaden animaciones ni asignaciones por cuadro para estos sprites. El SWF crece unos 2,75 MB; no se declara una mejora general de rendimiento.

## Pruebas y conservación

Recorrido con WebMain real en Chrome local: registro sin código, nivel 1/Rookie/6,000 Coins/sin lentes, creación confirmada, nueve categorías y cinco objetos, vistas previas y cancelación, compra de bandera por 12,000 Coins y dos clics rápidos, colocación y arrastre de las cinco decoraciones, tamaño, recarga, recaudación única de 700 Coins con cinco objetos, espera, retirada solo de la estrella conservando su propiedad e inicio de un partido real. Sin errores de JavaScript o AVM2 detectados en el recorrido final. Las comparaciones usan la misma carrera QA en ambas versiones. Se sembraron 80,000 Coins y artículos avanzados únicamente en esa carrera desechable para cubrir los cinco sprites; no es el inventario inicial de un jugador.

Cambian cuatro clases visuales: BuildCategoryIcon, BuildScreen, StadiumDecorationView y BuildArtwork. Los hashes de reglas, servidor, web, audio, guardado, cabeza 0.8.6 y estadio Rookie permanecen iguales a 1.0.20. No se reinician carreras. Las pruebas HTTPS de la nueva entrega aún no se han ejecutado.

Candidato: build `5ccbd6adc53fa1e3`, SWF SHA256 `eeaab69b3d3f25c1a95eebe12c8199b73eeb8d1d5635b5be823d3b87d7664940`, 30,064,789 bytes. Biblioteca verificada: `/data/game-library/fabccabf4fc37d885c299be27dee72b0f0bac206e1c543e434b6e09b9abc2a70` (114 archivos). El paquete permitido conserva 147 archivos; solo cambian ejecutable, versión y hashes de biblioteca respecto al candidato anterior.

## Publicación pendiente

Cuando Railway habilite el plan: comprobar la sesión oficial existente, ejecutar `cloud1021_admin.py prepare`, `backup-on-server`, un solo `upload_web1021.py`, `check_web_deploy1021.py` con el ID devuelto, `test_inventory1021.cjs --cloud`, `test_build1021.cjs --cloud`, `verify-package` y `cleanup`. Los dos recorridos usan identidades QA distintas. Solo después actualizar manifiesto y estado público. No se crearon cuentas QA públicas en esta entrega.

[Comparación](COMPARACION_MEJORAS_1021.html). Continúa pendiente la prueba multijugador entre dos computadoras reales de amigos y otras diferencias visuales del original.
