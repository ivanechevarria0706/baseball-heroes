# Web 0.9.4 · Bates consumibles y BAT EXPIRED

[Comparación de cinco vistas](COMPARACION_MEJORAS_094.html) · [Juego](https://baseball-heroes-api-production.up.railway.app/).

## Cambio jugable

SHOP e INVENTORY incorporan el filtro BATS x5. Contact 400, Power 400 y Luck 400 se compran en paquetes de cinco por 12 de moneda premium del juego. Seleccionar un artículo prueba su apariencia y atributos gratuitamente; BUY añade existencias y EQUIP las aplica desde INVENTORY. Las compras repetidas se acumulan en una sola pila. El límite de existencias es 9.999; un paquete que lo exceda no cobra nada.

HOME e INVENTORY muestran LEFT. Al iniciar un partido de temporada regular o postemporada, se reserva un bate junto con la energía y las cartas. Salir, recargar o volver a entrar reutiliza esa reserva. El último bate conserva su bonificación durante todo ese encuentro, aunque las existencias disponibles sean cero. El bate reservado no se puede cambiar mientras el encuentro esté pendiente. Un inicio rechazado por energía o alineación no consume unidades.

Al terminar el encuentro con la última unidad, vuelve a equiparse el último bate permanente utilizado; si ese objeto no está disponible, se usa Rookie Bat. La ventana YOUR BAT HAS EXPIRED! ofrece los tres paquetes y permite continuar gratis con OKAY. El aviso queda guardado hasta cerrarlo y se recupera en HOME después de una recarga. Un cierre de partido repetido no consume otra unidad. Las compras de la ventana añaden cinco bates y los equipan; su selección PREVIEW no cobra ni equipa.

## Evidencia y límites

En `primer_lugar-0470.jpg` (07:50) aparecen la ventana EXPIRED, el texto de consumible, las tres bonificaciones +400, x5 y el precio 12. En el gameplay explicando se observa el contador 5 LEFT y la prueba de equipo. Las imágenes de los bates proceden de la lámina 11_11 que aportó el usuario: se usan las siluetas Contact, Power y Lucky ya disponibles, sin generar otro dibujo ni modificar el original.

La duración histórica de cada unidad no está confirmada por los videos. **Una unidad por partido de carrera iniciado es una regla local**, que incluye empates de postemporada. Derby y retos conservan su comportamiento anterior y no gastan bates. La reserva no conserva el marcador de un partido interrumpido: sigue el comportamiento existente de reabrir el mismo encuentro pagado. No se ha reconstruido el servidor de balance original. El atributo visible +400 usa la normalización del motor actual para calcular estadísticas de partido en su escala de 1–99.

Los bates permanentes anteriores conservan identificadores, propiedad y atributos. No se convierten en consumibles ni pierden usos. El nuevo estado `consumableBats` es opcional en el esquema 21 y se inicializa vacío en partidas anteriores. El guardado de un partido incorpora `batSnapshot`; los encuentros pagados en versiones anteriores siguen siendo compatibles aunque ese campo no exista. No cambia el servidor ni el esquema SQLite 3.

La cabeza `BatterHead086.as` mantiene el hash aprobado `c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f`. Siguen activos solamente los cuatro efectos aislados por el usuario; SINGLE/DOUBLE con narración y los demás efectos en cuarentena continúan excluidos del paquete. Las cuentas nuevas conservan nivel 1 / ROOKIE y registro sin invitación.

## Comprobaciones

- Modelo en Ruffle: fondos insuficientes, paquetes repetidos, una sola pila, +400 visible y escala del partido, rechazo de inicio sin cobro, reserva/reentrada/recarga, última unidad, retorno al bate permanente, aviso persistente, acuse de cierre y límite de existencias sin cobro.
- Controles reales de SHOP/INVENTORY: vista previa gratuita, compra x5/x10, equipamiento y persistencia.
- Partido real: última unidad reservada, salida/reentrada y WALK-OFF por SINGLE; retorno al bate permanente y aviso sobre el resultado. Si también sube de nivel, LEVEL UP se muestra primero y BAT EXPIRED después de CONTINUE, sin superponerse.
- Postemporada: reserva única, recarga, empate, clasificación, viaje, reanudación sin energía extra, avance, eliminación, título y compatibilidad de temporadas antiguas.
- Regresión de partido: cierres WALK-OFF por HR, hit, walk, simulación y extra; octava entrada continúa; recompensas sin duplicación; compras permanentes +400, equipo y condiciones de compañeros.
- Versión normal: importación de un guardado sin el campo nuevo conserva inventario/equipo, compra por nivel 1, fondos insuficientes, última reserva y reentrada, recuperación del aviso en HOME, compra/equipamiento y cierre persistente. Los datos de prueba pertenecen solo a cuentas sintéticas.
- Comparación: cinco parejas de imágenes verificadas en escritorio y ventana estrecha.

Los informes están en `build/qa/*094*`. La publicación, el respaldo y la limpieza de cuentas de prueba se registran en `deployment_status.json`. Esta entrega actualiza la versión web; no genera otro paquete portable de Windows.

## Rendimiento

Muestra local Chrome/Ruffle de 45,135 segundos: 2.708 cuadros, 59,998 FPS, p95 25 ms, un cuadro por encima de 50 ms y máximo 103 ms. La entrada al partido tardó 5,952 segundos. El avance de bateador tuvo máximo de 2 ms. Esta muestra corresponde a un partido normal con equipamiento permanente y no garantiza el rendimiento en otras computadoras.

## Publicación

Railway: despliegue `4470e60c-85ed-44b1-88f3-d851c61ee538`, estado SUCCESS. Build `8634e4250ab46020`. SHA256 de WebMain `3738d4cafe4011662483419f395bc63222129780875172beca75d0036ac79aa4`. Paquete permitido de 132 archivos; 128 archivos del contenedor verificados por hash. Respaldo previo `external-v094-1791678970.sqlite3`, integridad OK. Servidor y SQLite 3 sin cambios.

Windows bloqueó el ejecutable local de Railway con WinError 225. Se usaron la API oficial de despliegue y OpenSSH con la llave ya registrada, según [la documentación de Railway](https://docs.railway.com/cli/ssh). No se ejecutó el archivo bloqueado ni se cambió la protección de Windows.

Registro y creación de personaje verificados en la web publicada sin invitación: nivel 1 / ROOKIE, alineación, primera reserva de energía, salida de sesión y reentrada. Las compras, equipamiento, reserva de última unidad, recarga/reanudación y aviso/renovación se verificaron también en la compilación normal publicada. En la prueba de nube se sembró el aviso de agotamiento únicamente en la cuenta sintética; el cierre auténtico con la última unidad se comprobó aparte en el motor local mediante WALK-OFF. La carrera sintética original se restauró antes de limpiar. Se eliminó una cuenta de prueba y se comprobó que siguen presentes todas las cuentas anteriores.
