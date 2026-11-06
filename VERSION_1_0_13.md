# Baseball Heroes 1.0.13 — BATTER SHOP y apertura de cartas

La presentación de la tienda, sus sobres y la colección se acerca a las referencias del inicio y de la tienda avanzada. Se conservan las cuentas y las reglas actuales.

- **Escaparate:** marco azul con biseles, cabecera compacta, siete fichas con borde plateado y precios dorados/verdes. La colección utiliza los mismos relieves y huecos de cartas. Los precios, bloqueos y clases ofrecidas se conservan.
- **Sobres impresos:** retratos grises, título, insignia de clase y grados posibles visibles. Las letras utilizan fuentes incrustadas para mantenerse al girar o escalar. Se reutilizan ilustraciones existentes; no son nuevas imágenes originales recuperadas. Hasta cuatro texturas grises se preparan una vez y se comparten sin modificar las texturas de los personajes.
- **Apertura por pliegue:** el papel descubre la carta en diagonal, con un borde blanco que avanza hasta abrirla. Desaparece el giro que la reducía a una línea. La tienda queda visible detrás y las pestañas se ocultan durante la apertura para no cruzarse con el texto. La animación termina y deja de actualizarse; OKAY aparece al completarse.
- **Compra protegida:** X queda desactivado durante la apertura. Clic, Space y Enter conservan sus acciones; las pulsaciones repetidas durante el pliegue no vuelven a comprar ni a revelar. Escape cierra la tienda antes de comprar. El sobre guiado ya pagado puede reabrirse después de recargar sin volver a pagar.
- **Información coherente:** se retira la frase «HERO solo existe en A y S», incompatible con el C HERO observado en el primer tutorial. Cada sobre muestra su propio rango de grados; clase y grado se explican por separado. Los consejos siguen en español.

Las compras siguen acreditando la copia en el inventario antes de reproducir su apertura. La animación no concede cartas ni monedas. Se preservan las dos unidades de energía, la combinación de tres copias de la misma clase y las confirmaciones de TRADE/ENHANCE.

## Referencias y límites

`videoplayback (4).mp4`, aproximadamente 02:06–02:15: tienda sobre LINEUP, pliegue blanco y Walker P. C HERO. `[FACEBOOK GAME]BASEBALL HEROES play video.mp4`, aproximadamente 03:40: siete variantes y fichas claras sobre marco azul. Son presentaciones de versiones distintas; se mantiene el catálogo de siete variantes ya implementado, el primer C guiado de 6,000 Coins y el C posterior de 5,000.

Las caras impresas se reconstruyen con el arte disponible y el pliegue es una animación nueva basada en esa referencia. Los precios y probabilidades no recuperados continúan siendo balance local documentado. Se conserva OKAY sin añadir un botón de compartir que requiera Facebook.

## Verificación

Tres suites locales de Chrome: tutorial inicial completo y 34 comprobaciones del modelo; escaparate, teclado, pliegue, colección, fondos/bloqueos, cancelación y doble clic en TRADE; compra desde WebMain público, recarga del sobre pagado y entrega en la banca. Los informes y capturas están en `build/qa/release1013`.

Guardado v24 y SQLite v4. Servidor, modelo, motor del partido, pichadas, sonidos, equipo y cabeza aprobada 0.8.6 intactos. No se cambia el identificador de reinicio. La publicación y las verificaciones HTTPS se registran al terminar en `deployment_status.json`.

Publicada y comprobada en HTTPS: build `ebfa4576bd656d34`. Dos suites con cuentas sintéticas nuevas: compra guiada, recarga del sobre pagado, revelado y entrega en banca; LINEUP, energía, confirmaciones y partido pendiente. Los 138 archivos publicados coinciden con el paquete probado; los diagnósticos no están expuestos. Copia SQLite íntegra en el volumen; solo se retiraron las dos identidades QA utilizadas. Esta entrega no repite la prueba completa de nueve entradas de la 1.0.12.
