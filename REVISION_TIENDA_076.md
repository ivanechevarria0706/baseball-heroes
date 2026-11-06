# Web 0.7.6 · Tienda con vista previa del héroe

SHOP → GEAR usa ahora la composición del inventario: panel azul a la izquierda, categorías GLOVE/BELT/HELMET/SHOES/BAT/GOGGLES y cuadrícula de ocho posiciones. El héroe permanece sobre el estadio a la derecha, con sus atributos encima. Se reutiliza EquipmentScreen para que tienda e inventario compartan distribución, paginación y cálculo de la vista previa.

Seleccionar un producto cambia el objeto visible del héroe y sus barras antes de comprar. CANCEL PREVIEW vuelve al equipo aplicado. BUY cobra el precio del catálogo y añade el objeto al inventario, sin equiparlo automáticamente. INVENTORY abre el inventario real, donde EQUIP aplica lo comprado. Un objeto poseído muestra OWNED; los bloqueados muestran la liga requerida. Los botones se desactivan cuando no procede comprar, y la operación existente de GameData también valida propiedad, desbloqueo y recursos.

STADIUM y ENERGY mantienen sus secciones anteriores. Sus recursos se actualizan al regresar desde GEAR. Sus botones antiguos quedan ocultos mientras está abierto el nuevo panel, para que no reciban clics a través del fondo. Cerrar o cambiar de sección libera el actor y sus eventos. La cámara sigue usando la caché de estadio de 0.7.4.

Los avisos de vista previa y de cambios tienen un fondo azul para conservar la legibilidad sobre el campo. La tienda no recalcula ni colorea personajes durante el partido. El motor, timing, simulación, sonidos, precios, catálogo, probabilidades y esquema 21 no cambian. Las nuevas cuentas siguen en nivel 1 de ROOKIE.

## Referencia y diferencias pendientes

Se contrastó la pantalla con el gameplay «Vamos En Primer Lugar Y Explicando Algunas Cositas», 09:22 y 09:34, fotogramas `reference_visual/explicando_20260924/frame-0562.jpg` y `frame-0574.jpg`. Comparación en `COMPARACION_TIENDA_076.html`. La interfaz usa controles reales; no contiene una captura como fondo de los botones.

El original muestra un catálogo de bates más grande, siluetas ilustradas distintas y bloqueos por niveles 30/50/70. El remake conserva su catálogo reconstruido y sus requisitos por liga; no se presentan como tablas originales. No se extrapola de esos tres niveles una regla universal para todos los objetos. El héroe, los símbolos de productos y las fuentes todavía no son los recursos exactos del original. El volumen del catálogo, la franja social, STADIUM y ENERGY necesitan nuevas revisiones visuales.

## Verificaciones

- `smoke-shop076.txt`: Chrome con controles reales, seis filtros y todos los objetos del catálogo; vista previa/cancelación sin alterar el modelo, bloqueos, falta de monedas y moneda premium; gasto exacto de compras en ambas monedas, repetición inocua, compra sin equipamiento automático, INVENTORY → EQUIP, retorno a STADIUM/ENERGY y recarga del guardado.
- `smoke-equipment076.txt`: regresión del inventario de seis categorías, 126 objetos QA y páginas sin desbordamiento, límite de atributos, cancelación/aplicación y guardado.
- `smoke-home076.txt`: rutas de HOME, TRAIN, compañeros y fichas, cobro único, seis fondos ilustrados, respaldo ante fallo y entrada al partido.
- `smoke-production-match076-local.txt`: ejecutable real sin callbacks de diagnóstico; compra, equipo, recarga, partido con teclado y muestra del bucle de renderizado sin pausa larga.
- `smoke-web076-staging.txt`: paquete completo permitido, arranque sobre base vacía, registro sin invitación y rutas privadas; targets de pruebas excluidos.
- `smoke-cloud-match076.txt`: compra y recarga repetidas en Railway, seguido del partido y guardado; cuenta QA retirada y respaldos verificados dentro del volumen.

Las pruebas de compra financian y desbloquean únicamente una identidad QA. Después restauran ROOKIE para comprobar el inicio del partido; no cambian recursos, liga ni equipo de otras cuentas. Los manifiestos se actualizan al finalizar la validación publicada. Windows 0.6.7 conserva su compilación anterior.
