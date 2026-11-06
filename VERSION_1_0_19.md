# Baseball Heroes 1.0.19 · inventario y premios ilustrados

> Incluida en la 1.0.23 publicada. El estado pendiente que se conserva debajo corresponde a su preparación anterior. [Entrega publicada](VERSION_1_0_23.md).

Estado a 22 de octubre de 2026: **preparada, compilada y probada localmente; no publicada**. La web sigue en 1.0.18, build `c1deade3203d0523`. Railway devolvió HTTP 400: `Deploys have been paused temporarily`. La reconexión OAuth oficial confirmó acceso al proyecto existente. Su [página de estado](https://status.railway.com/) confirma una incidencia y la suspensión de despliegues para algunos planes. No se modificó temporalmente el contenedor para evitar esa restricción.

Candidato: build `605e5b0241e80302`, SHA256 `5f29dcf085fc1e20224daf84e7500a699f99ebf91eb1d09ba5119f7b5fe668a3`. La biblioteca de 114 archivos se verificó en el volumen; todavía no está activada por un despliegue.

## Cambios

- Maletín de INVENTORY, BATTER, Mystery y llave: recortes del gameplay original de 11:40–12:10. El cofre de entradas conserva su ilustración propia; ya no se reutiliza como icono de Mystery.
- Cofres Rookie y Single-A: recortes originales. Double-A, Triple-A y Major: sprites reconstruidos, con la misma estructura de estuche metálico y las franjas de color existentes. No se presentan como recursos originales recuperados.
- Sobres C/B/A/S: se reutiliza la ilustración de ClassPackArtwork de la tienda, en lugar del bloque con una letra. No se cambian los grados ni las probabilidades.
- Apertura: movimiento, pulso leve y brillo durante unos 1,05 segundos. Es una transición corta; no es una animación de tapa recuperada. No añade audio ni comentarios de gameplay.
- Premios: pictogramas para moneda, Coins, cartas, llaves, energía y equipo. Las vistas de sobres y cartas se liberan al cerrar o redibujar el inventario.
- Ficha de héroe y miniaturas genéricas de equipo: reutilizan accesorios ilustrados. Los artículos con recorte observado tienen prioridad; las imágenes de categoría no añaden equipo, no alteran sus atributos ni equipan lentes.

## Arte y prompt

Seis recortes proceden de `reference_visual/gameplays_20260924/primer_lugar-0700.jpg`, `primer_lugar-0710.jpg` y `primer_lugar-0730.jpg`. Los originales se conservan. La hoja tiene nueve cuadros, alfa real y 179,542 bytes. Se integra con caché compartida; no añade cargas externas ni trabajo por cuadro fuera de la transición de apertura.

Para los tres cofres reconstruidos se utilizó **la herramienta integrada image_gen**, con `rookie.png` y `single_a.png` como referencias. No se utilizó CLI ni una API de imágenes con clave. El prompt completo, herramienta y referencias están en [reconstructed-provenance.json](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1019/reconstructed-provenance.json>).

Archivos finales dentro del proyecto:

- [Hoja utilizada por el juego](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1019/inventory-atlas.png>)
- [Double-A](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1019/double_a.png>) · [Triple-A](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1019/triple_a.png>) · [Major](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1019/majors.png>)
- [Generación seleccionada conservada](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1019/reconstructed-chests-source.png>)
- [Ventanas y procedencia de los nueve cuadros](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1019/manifest.json>)

La resolución de algunas miniaturas recuperadas es limitada por la compresión del video. Se mantienen aproximaciones en otras pantallas; no se declara paridad visual completa.

## Verificación

Chrome local con WebMain real: registro, equipo confirmado, personaje sin lentes, cinco cofres y cuatro sobres. Previsualizar no consume. Dos clics rápidos gastan un solo cofre y exactamente sus llaves. El premio pendiente se conserva al cerrar y recargar; COLLECT entrega una vez. Los cuatro sobres dan una sola carta sin cobrar Coins y las llaves insuficientes bloquean la apertura. Se conservan la identidad, el equipamiento y las condiciones iniciales de nivel 1/ROOKIE.

El paquete se limita a seis clases visuales. El modelo, servidor, página web, audio, recursos externos, cabeza aprobada y bloqueo de identidad conservan sus hashes previos. Guardado v24 y SQLite v4 sin migración ni reset. Respaldo SQLite íntegro conservado en el servidor. Solo se reservaron identidades de prueba para HTTPS: no se crearon cuentas y la reserva ya fue retirada.

El ensayo HTTPS de la 1.0.19 permanece pendiente, ya que Railway no aceptó crear un despliegue. La comprobación pública actual corresponde únicamente a la 1.0.18.

## Continuación de la publicación

Cuando Railway permita desplegar: verificar la sesión existente, reservar de nuevo QA con `research/cloud1019_admin.py prepare`, repetir el respaldo si corresponde y ejecutar `research/upload_web1019.py` una vez. Verificar el ID devuelto con `research/check_web_deploy1019.py`, luego `research/test_inventory1019.cjs --cloud`, `research/cloud1019_admin.py verify-package` y `cleanup`. Solo después actualizar los manifiestos y el estado a PUBLICADA. El paquete preparado, preflight y biblioteca ya coinciden; no hace falta cambiar el juego para publicar.

[Comparación local](COMPARACION_MEJORAS_1019.html).
