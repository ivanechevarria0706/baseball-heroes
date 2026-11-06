# Baseball Heroes 1.0.18 · sprites en HOME, LINEUP y equipamiento

Publicada y comprobada el 20 de octubre de 2026. Build `c1deade3203d0523`; SHA256 del ejecutable `5a7e295d7294fbde920674917cc5268ab2325c97efb5bd8ad604ca029b4af392`.

## Cambios

- HOME usa recortes ilustrados para PLAY BALL, el cofre de entradas, SCOUT y los accesos SHOP, LINEUP, BUILD y MODES. Recursos y pestañas compartidas usan sprites de energía, Coins, moneda premium interna, casco, cartas y cofre.
- Los compañeros que caían al rostro vectorial genérico usan ahora uno de 32 recortes de la hoja original. Se conserva la asignación de nombre a ilustración utilizada en HOME. Los once retratos existentes, las cartas especiales y el héroe creado conservan sus rutas propias.
- Los seis iconos de categorías de equipamiento usan accesorios originales. Son símbolos de categoría, no nuevos objetos equipados; la previsualización, propiedad, estadísticas y compras no se modifican.
- Una hoja RGBA de 692,204 bytes contiene 49 cuadros: 32 retratos, seis categorías y once iconos de interfaz, con reutilizaciones. Se incrusta en el SWF; los recortes se cachean y comparten sin loaders ni trabajo por cuadro.

## Procedencia y límites

HOME: `reference_visual/gameplays_20260924/primer_lugar-0020.jpg`. Energía y billetes: `reference_visual/initial_audit_20261015/frame-0078.jpg`. Retratos: `assets/sprites/v060/characters-atlas.png`, procedente de la hoja de personajes aportada. Equipo y cartas: los recortes originales ya disponibles en v116/v117. MODES reutiliza el emblema OPENING de la hoja original. No es un emblema nuevo recuperado del menú de modos.

Los recortes de video se separan del fondo mediante siluetas trazadas y refinamiento de color; las imágenes originales se conservan. El abanico de cartas compone tres caras existentes. No se usa generación de imágenes en esta tanda. Ventanas, fuentes y uso de cada cuadro están en `assets/reference/v1018/manifest.json`; extracción reproducible en `../research/sprites1018.py`.

Persisten el maletín nativo de inventario y otros elementos sin ilustración propia. La resolución pequeña del video limita algunos iconos; no se declara una copia visual exacta ni un juego completamente convertido a sprites.

## Verificación y conservación

Compilación WebMain aprobada. Recorridos con el ejecutable real en Chrome local y HTTPS: registro, selección confirmada, personaje, HOME, SHOP, LINEUP, BUILD, MODES, SCOUT, MISSIONS y HERO. Se verifican recursos e identidad después de cada consulta y recarga. La comparación anterior usa la misma carrera QA bajo el ejecutable 1.0.17.

La revisión del paquete limita los cambios de código a cuatro clases visuales y una clase de sprites nueva. Modelo, reglas, servidor, página web, cabeza 0.8.6, audio y recursos externos existentes conservan sus hashes anteriores. Se mantienen guardado v24, SQLite v4 y resetEpoch. Las carreras nuevas siguen empezando en nivel 1, ROOKIE, sin lentes.

143 archivos instalados coinciden con el paquete; integridad SQLite comprobada. Respaldo íntegro conservado en el volumen antes de publicar. Solo se retiró la cuenta QA utilizada, preservando las cuentas existentes. La prueba física entre dos PC de amigos continúa pendiente; esta entrega visual no modifica el multijugador.

[Comparación](COMPARACION_MEJORAS_1018.html). Guarda y usa SAVE & UPDATE o recarga para cargar el ejecutable nuevo.
