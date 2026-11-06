# Baseball Heroes 1.0.22 · misiones y trofeos

> Incluida en la 1.0.23 publicada. El estado pendiente que se conserva debajo corresponde a su preparación anterior. [Entrega publicada](VERSION_1_0_23.md).

**Preparada y probada localmente; no publicada.** La web sigue en 1.0.18, build `c1deade3203d0523`. Railway mantiene pendientes los despliegues para Free y Trial según su [estado oficial](https://status.railway.com/) de 22 octubre 2026, 19:42 UTC. El último rechazo de despliegue HTTP 400 corresponde a 1.0.19; no se hicieron nuevos envíos durante la misma pausa. La biblioteca 1.0.22 ya está verificada en el volumen y no está activada. Incluye las mejoras de 1.0.19–1.0.21.

## Cambios

- HALL OF FAME: copas de bronce, plata, oro y diamante con reflejos y una silueta oscura para los hitos bloqueados. Mantienen el centro y alto de las anteriores.
- Misiones: las cuatro categorías reutilizan ilustraciones existentes. Casco, fichaje y estadio proceden de los recortes de 1.0.18; el marcador reutiliza la reconstrucción de BUILD de 1.0.21.
- Premio de habilidad: estrella ilustrada con facetas.
- MISSION COMPLETE!: rótulo azul y dorado inspirado en el gameplay. Su altura y la del título dejan espacio al entrenador y a los objetivos. Se separó el icono del texto del premio después de la revisión visual.
- Siete etiquetas de objetivo se muestran en español, incluidos entrenamiento, nivel, pichadas, victorias por una carrera y tres singles. Los avisos de hito alcanzado y premio recibido del Hall también están en español. Los nombres de menús y los términos habituales del béisbol siguen en inglés.

## Arte, herramienta y prompts

Se utilizó **image_gen integrado**, sin CLI ni API de imágenes con clave. Son reconstrucciones, no originales recuperados. Referencias: `reference_visual/explicando_20260924/frame-0874.jpg` y `reference_visual/gameplays_20260924/primer_lugar-0660.jpg`. Se conservan los PNG generados completos y su transparencia; Python solo midió los límites de alfa, sin modificar los archivos de imagen.

Archivos finales:

- [achievement-atlas.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1022/achievement-atlas.png>)
- [mission-complete.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1022/mission-complete.png>)
- [Prompts completos, herramienta y referencias](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1022/provenance.json>)
- [Cuadros de los siete sprites](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1022/manifest.json>)

El juego prepara copias de píxeles compartidas, sin cargas por icono ni animación por cuadro. El rótulo ancho se divide en tiras de hasta 1024 píxeles. Siete cuadros, nueve fragmentos de textura y unos 9,004,812 bytes de caché. El SWF aumenta aproximadamente 2,33 MB; no se declara una mejora general de rendimiento.

## Pruebas

Chrome local con WebMain real y misma carrera QA para antes/después: registro sin código, nivel 1/Rookie/6,000 Coins/sin lentes, creación confirmada, cuatro categorías de misión, reclamo incompleto bloqueado, vista previa y LATER sin pagar, tres premios de Coins (800/750/820) una sola vez con dos clics rápidos, un punto de habilidad sin Coins, cuatro copas (2000/4000/8000/16000) cobradas una sola vez, bloqueo de hitos no alcanzados y ya cobrados, tres páginas del Hall, recarga y navegación a misiones/HOME. Se sembraron únicamente en esa cuenta QA los contadores necesarios para revisar las recompensas; no se añadieron hitos ni niveles a usuarios. Sin errores JavaScript o AVM2 detectados en el recorrido final.

Solo cambian cuatro clases visuales respecto a 1.0.21: MissionSkin, MissionCompleteOverlay, HallOfFameScreen y AchievementArtwork. GameData y CareerAchievements conservan sus hashes; también servidor, web, audio, guardado v24, cabeza 0.8.6, Rookie y BUILD. No se reiniciaron carreras. Las pruebas HTTPS de esta entrega aún no se ejecutaron.

## Recuperación de espacio

El primer intento de guardar la biblioteca falló por falta de espacio. Se confirmó que el volumen tenía cero bytes libres y una carga temporal incompleta de 27,131,904 bytes. Se eliminó exclusivamente ese archivo, comprobando su ruta dentro de la carpeta de la biblioteca nueva, su tamaño y su SHA256 parcial contra el ejecutable local.

Se verificaron 678 archivos de recursos y 565 copias byte a byte idénticas se reemplazaron por enlaces duros en el mismo volumen. Todos los hashes se revisaron de nuevo. No se eliminaron versiones completas, no se tocaron ejecutables existentes y no se modificaron bases de datos. La biblioteca nueva enlaza 113 recursos existentes en vez de copiarlos otra vez. Después de guardarla quedan aproximadamente 127.9 MiB libres. Los 114 archivos instalados de 1.0.18 coinciden con su manifiesto y SQLite conserva integridad correcta y esquema 4, comprobados en modo de solo lectura.

El helper de publicación de esta versión ya reutiliza recursos idénticos mediante enlaces duros. Esa modificación afecta a la preparación de bibliotecas, no a los archivos del servidor que están publicados.

## Paquete y publicación pendiente

Build `91c7fdc2bfe53aea`, SWF SHA256 `011eb12a52aa165678fe5aedf0133b3fbd4f86f77fc4f2235054a31d9e81b2b4`, 32,390,631 bytes. Biblioteca verificada: `/data/game-library/dbb168c7309760d4c73856ef03e1c7ba7379de372637f8f7c7acace3aee201ef`, con 114 archivos. El paquete sigue limitado a 147 archivos; solo cambian ejecutable, versión y manifiesto de biblioteca respecto al candidato anterior.

Cuando Railway habilite el plan: comprobar la sesión oficial existente, `cloud1022_admin.py prepare`, `backup-on-server`, un solo `upload_web1022.py`, `check_web_deploy1022.py` con el ID devuelto, `test_inventory1022.cjs --cloud`, `test_build1022.cjs --cloud`, `test_achievements1022.cjs --cloud`, `verify-package` y `cleanup`. Los recorridos usan cuentas QA distintas. Actualizar el manifiesto y estado público solo después de verificar HTTPS. No se crearon cuentas QA públicas en esta entrega.

[Comparación](COMPARACION_MEJORAS_1022.html). Sigue pendiente la prueba multijugador entre dos computadoras reales de amigos y otras diferencias con el original.
