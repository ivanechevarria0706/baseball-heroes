# Baseball Heroes 1.0.20 · estadio Rookie y textos

> Incluida en la 1.0.23 publicada. El estado pendiente que se conserva debajo corresponde a su preparación anterior. [Entrega publicada](VERSION_1_0_23.md).

**Preparada y probada localmente; no publicada.** La web sigue en 1.0.18, build `c1deade3203d0523`. El [estado oficial de Railway](https://status.railway.com/) sigue indicando pausa para Free y Trial en su actualización de 22 octubre 2026, 17:43 UTC. El último rechazo HTTP 400 corresponde al intento de 1.0.19. No se intentó enviar 1.0.20 durante la misma pausa ni se modificó el contenedor en ejecución para evitarla.

## Cambios

- Rookie: público más definido, filas de gradas sombreadas, luces con relieve, marcador más oscuro, nubes menos repetitivas, montañas y césped retocados contra el gameplay inicial. El fondo nuevo es una reconstrucción, no un original recuperado.
- El fondo Rookie está integrado en el SWF. Comparte una sola imagen decodificada entre instancias de HOME, partido, colección y BUILD; ya no depende de un Loader externo para ese estadio. Los estadios alternativos conservan su carga y su geometría anteriores.
- Botones: las leyendas sin salto explícito, como LINEUP, se ajustan a una línea. Se respetan los saltos explícitos. El texto sigue como primer hijo para los consumidores existentes.
- Incluye los sprites, cofres y aperturas ya preparados en la 1.0.19; no necesita publicar esa versión por separado.

## Arte, herramienta y prompt

Se utilizó **image_gen integrado**, no CLI ni una API con clave. Se retocó la placa anterior con el fotograma `reference_visual/initial_audit_20261015/frame-0250.jpg` como referencia. Archivo final: [rookie-stadium.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1020/rookie-stadium.png>). Herramienta, referencias y prompt completo: [provenance.json](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1020/provenance.json>). Tamaño: 1448 × 1086, 1,656,842 bytes; los píxeles decodificados ocupan aproximadamente 6 MiB compartidos.

La medición de color en regiones del plato y montículo sitúa la diferencia máxima de los bordes en 1,32 píxeles sobre 960 × 720. También se revisaron las capturas de bateo con actores reales. No es una prueba de igualdad de cada píxel con el original; la referencia contiene HUD y personajes y no proporciona la placa limpia.

## Verificación

Chrome local con WebMain real: registro desde nivel 1/Rookie/sin lentes, cámara de bateo antes y después, mismo partido pagado sin cobro adicional, vistas HOME y BUILD, compra real de Emerald Field y cancelación de vista previa, recarga, componentes de estadio y mascota, dos fondos alternativos. Regresión de cinco cofres y cuatro sobres: gasto y entrega únicos, premio pendiente persistente y bloqueo sin llaves. Sin errores de AVM2 o JavaScript detectados.

Tres clases visuales cambian respecto a 1.0.19: ClassicActionButton, MatchStadium y RookieStadiumArtwork. Se conservan los hashes del modelo, servidor, web, audio, cabeza 0.8.6 y bloqueo de identidad. Guardado v24 y resetEpoch sin cambios. No se reiniciaron carreras ni se crearon cuentas QA públicas en esta entrega.

Candidato build `371da1905bd1c382`; SWF SHA256 `13ea9954f464d443c84c5cab82630c4f1404db0f1eaa24c0dbc9a74dd03bd86c`; 27,310,035 bytes. La ilustración aumenta el SWF en unos 2,1 MB; no se promete una mejora general de FPS. La biblioteca de 114 archivos está verificada en `/data/game-library/31b5fedab7f3792b9e821942a0a5b783a95654140a4f16b4bfdb219763ddfe7b`, sin activar. El paquete de despliegue sigue con 147 archivos permitidos; su envío pequeño omite los archivos de juego y recupera sus hashes desde esa biblioteca.

## Pendiente de publicación

Cuando Railway habilite el plan: comprobar la sesión oficial existente, ejecutar `cloud1020_admin.py prepare`, respaldo `backup-on-server`, un solo `upload_web1020.py`, verificar el ID con `check_web_deploy1020.py`, recorridos `test_inventory1020.cjs --cloud` y `test_stadium1020.cjs --cloud`, `verify-package` y `cleanup`. Las reservas QA anteriores fueron retiradas; se requiere preparar las nuevas. Actualizar estado público y manifiesto solo después de verificar HTTPS. No se requiere publicar antes 1.0.19.

La prueba entre las computadoras reales de dos amigos sigue pendiente; las pruebas actuales de esta entrega son locales. [Comparación](COMPARACION_MEJORAS_1020.html).
