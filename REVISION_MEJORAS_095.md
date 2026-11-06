# Web 0.9.5 · Los puntos 1, 2, 3, 6, 9, 11 y 12

[Comparación visual](COMPARACION_MEJORAS_095.html) · [Juego](https://baseball-heroes-api-production.up.railway.app/).

## Qué cambia

1. **Equipo visible.** Doce colecciones con casco, gafas, zapatos, guantes y cinturón. Los cascos usan arte de tu lámina 11_11; se colocan sobre la identidad guardada. El casco de colección también selecciona un uniforme temático; los demás accesorios conservan su equipamiento individual. Las poses de HOME, vista previa, bateo y corredores usan materiales compartidos. Cabello oculto bajo los cascos, tallo y astas completos, cachés separados por material para evitar mostrar el equipo anterior. El catálogo ampliado contiene 87 artículos permanentes, incluidos los bates anteriores; se mantienen seis slots. Son adaptaciones de uniformes, no una recuperación exacta de todas las armaduras, prendas y accesorios animados del original.
2. **Animación.** Nuevo lanzador con 24 poses ilustradas: preparación, guante elevado, pierna, zancada, brazo, salida de pelota, seguimiento y recuperación. El cuadro de liberación tiene mano vacía y un punto de salida medido en la hoja. La pelota del motor y la pose comparten reloj; una llamada repetida no mueve el punto de liberación. Los corredores cambian de pose cada 90 ms y su pequeña oscilación vertical es absoluta: ya no acumula desplazamiento cuando se repite un cuadro. La cabeza `BatterHead086.as` no cambia.
3. **Roadmap.** Se añade el cuarto requisito observado de SINGLE-A: completar una temporada de esa liga. Los pasos anteriores y premios ya recogidos conservan su progreso. Los puntos superiores permiten recorrer los pasos. Se muestran los dos objetivos opcionales documentados: siete recomendaciones de Double-A y campeón, con 4,000 monedas reclamables una sola vez. Las recomendaciones llegan por AA LETTER entre amigos aceptados, se reclaman en INBOX y se reconcilian mediante totales acumulados. Abrir ASK FRIENDS no manda regalos. Hay un regalo por amigo y día UTC, como en el sistema anterior. La interpretación del campeonato usa el título de la postemporada local de esa liga; la procedencia y reglas históricas de esos opcionales no están confirmadas. Los opcionales no bloquean el ascenso. El Roadmap no reemplaza la regla existente de ascenso de temporada.
6. **Amigos en HOME.** La tira inferior ahora contiene cuentas aceptadas, su rostro y su nivel/AVG/HR/RBI. Si no hay amigos se indica REGISTER; no se rellenan espacios con la alineación CPU. Se conserva paginación de seis. El perfil público excluye monedas, inventario, guardado y credenciales; los rasgos/estadísticas solo se incluyen para uno mismo y amigos aceptados. Los datos proceden del guardado privado publicado como perfil, no son estadísticas competitivas validadas por servidor. Guardados antiguos o malformados tienen valores seguros. Eliminar el vínculo retira el perfil de las respuestas futuras.
9. **Acabado.** Roadmap con panel azul, requisito y opcionales diferenciados, progreso y navegación por pasos. Draft se dibuja sobre el estadio y mantiene selección/reclutamiento/precios. REGISTER ocupa el acceso de la tira; SCOUT continúa en la barra lateral. Escape regresa desde los regalos del Roadmap y los callbacks se cancelan al salir de HOME. Se corrigieron siete separadores/estrella con caracteres dañados en los textos del partido. Este alcance no equivale a rehacer cada menú original.
11. **Contenido.** Rookie Mountain Park y Civic Single-A Park se compran y equipan como fondos. Precio local 1,800/6,500 monedas; el municipal exige Clase A. Se conservan los fondos anteriores, las decoraciones y las mejoras. Los nuevos usan el campo medido del motor en primer plano para no desplazar montículo/plato respecto a los actores.
12. **Ritmo.** Medición de dos fragmentos conservados, más abajo. Los vuelos se aproximan a 0.34–0.625 s según familia/rating, preparación de 0.96 s. El motor pasa la duración real a evaluación, calidad y etiqueta de timing. Los márgenes de acierto se expresan en segundos reales y no se estrechan al reducir el tiempo de vuelo. Probabilidades de resultados, recompensas, XP y reglas de ascenso conservan su fórmula local; no se afirma haber recuperado el balance del servidor original.

## Qué muestran las referencias

`reference_visual/explicando_20260924/frame-0854.jpg` (14:14): GET TO DOUBLE-A, paso 4 de 4, completar una temporada de Clase A, Mystery Box, siete cartas de recomendación, ASK FRIENDS, campeón y recompensa 4,000. No se deducen de esa imagen los tres pasos anteriores ni una obligación de pagar para avanzar. Se conservan los objetivos existentes por compatibilidad.

| Fragmento conservado | FPS | Primera pelota claramente visible | Contacto | Diferencia visible |
|---|---:|---:|---:|---:|
| `reference_visual/v057/original.mp4` | 25 | cuadro 26 · 1.04 s | cuadro 34 · 1.36 s | ≈0.320 s |
| `reference_visual/explicando_20260924/clip-walkoff.mp4` | 30 | cuadro 10 · 0.333 s | cuadro 18 · 0.600 s | ≈0.267 s |

Las láminas de cuadros se incluyen en la comparación. Hay incertidumbre de uno o dos cuadros: son tiempos desde primera pelota visible, no una medida exacta de toda la trayectoria desde que sale de la mano. No se conoce con certeza la familia de esos dos lanzamientos. Los tiempos elegidos para otras familias son una calibración aproximada del remake. Dos ejemplos no permiten estimar porcentajes de home run, hit o out.

## Compatibilidad y pruebas

Registro sin invitación, carrera nueva nivel 1 / ROOKIE y esquema de guardado 21. El campo `roadmapJourney` es opcional y se migra sin inventar recomendaciones ni cobrar premios retroactivos. La SQLite permanece en versión 3; `letter` utiliza el campo de tipo de regalo existente. Los identificadores y propiedad de equipo, consumibles y partidos pagados anteriores se mantienen. Una recarga guarda el progreso de carrera y reservas según el comportamiento previo; no añade guardado del marcador interrumpido.

24 pruebas de servidor pasan: sesiones, cookies, CSRF, aislamiento, guardados, migración, ligas, privacidad del perfil, aceptación/retirada de amigos, regalo diario, repetición de solicitudes y reclamaciones, ownership y reapertura de SQLite. Se actualizó el test antiguo de migración para esperar versión vigente 3 y rechazar una futura 4.

Modelo/UI en Chrome y Ruffle: recompensa opcional una vez y persistente, siete cartas sin duplicación, temporada completada solo en fixture final, misma tolerancia para errores de 0/10/30/55/100 ms con cuatro duraciones, corredor sin deriva y liberación estable del lanzador. Dos cuentas locales reales muestran nombre/rostro/estadísticas del amigo y carta reclamada en HOME. Compra/equipamiento/recarga del estadio y su puerta de liga comprobados. Se revisaron visualmente las doce combinaciones, recortes individuales, 24 poses, Draft y Roadmap.

Regresiones: WALK-OFF por HR, SINGLE, walk, simulación y extra; octava entrada continúa; recompensas sin duplicación; condiciones de compañeros; postemporada completa; bates consumibles, última reserva, reentrada y renovación. Compilación normal local: registro → personaje → llegada → metas → viaje → alineación → primer partido, logout/reentrada; compras/equipamiento y restauración del guardado. Comparación con siete vistas, imágenes decodificadas y ventana estrecha. Los informes concretos están en `build/qa/*095*`; el manifiesto distingue verificaciones actuales de documentos históricos.

La cabeza aprobada mantiene SHA256 `c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f`. Solo están activos tus cuatro efectos aislados. SINGLE/DOUBLE narrados y otros efectos no verificados continúan excluidos del paquete publicado.

Medición local Chrome/Ruffle: 45.086 s, 2,705 cuadros, 60.00 FPS, p95 25 ms, máximo 53 ms, 1 cuadro por encima de 50 ms. Entrada al partido 3.875 s; avance de bateador máximo 1 ms. Muestra de una computadora con equipo permanente normal; no garantiza otras máquinas ni todos los conjuntos.

## Arte generado y archivos

Se usó la herramienta integrada **image_gen**, conservando los PNG generados y su alpha. Las direcciones finales del conjunto de prompts están registradas en [provenance.json](assets/sprites/v095/provenance.json): estadio de montaña con gradas laterales y marcador; parque municipal con edificio cívico y gradas azules; atlas transparente 6×4 de un mismo lanzador, desde preparación hasta recuperación. Son reconstrucciones inspiradas en las referencias, no sprites recuperados del juego.

- [rookie_mountain095.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/stadiums/rookie_mountain095.png>)
- [civic_park095.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/stadiums/civic_park095.png>)
- [pitcher-atlas.png](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/sprites/v095/pitcher-atlas.png>)

## Publicación

Publicada en Railway: despliegue `88f33c09-a97b-4fc7-a51b-e19d19f89d6d`, estado SUCCESS. Build `fde4ccdb2fbc3f76`. SHA256 de WebMain `dece68e5de17723612059d686f3b4158fa3eaa54c1cd38c3fad93052a2c715f9`. Paquete permitido de 136 archivos; solo WebMain se publica, sin herramientas de prueba. Respaldo anterior `external-v095-1791690436.sqlite3`, integridad OK, almacenado en el volumen del servidor. No se presenta como respaldo fuera del proveedor. Las comprobaciones finales de HTTPS y limpieza se registran en `deployment_status.json`.

La compilación normal publicada pasó el recorrido completo de registro/personaje/primer partido y la compra/equipamiento/reserva/renovación de bates, con recarga y conservación de carrera. Dos cuentas sintéticas verificaron perfil privado antes de aceptar, rostro con color de cabello 8, AVG/HR/RBI, franja real en HOME, una carta reclamada dos veces sin duplicación tras recargas y límite diario de regalos. La captura de amigos de la comparación corresponde a esa compilación publicada, sin herramientas de diagnóstico. Se retiraron las dos cuentas sintéticas con sus vínculos/regalo; se comprobó que permanecen todas las cuentas previas. Esto no sustituye una prueba con amigos en otra computadora.
