# Mejoras 0.10.3 — ROOKIE, estadio y sprites

11 de octubre de 2026. Puntos solicitados 1, 2, 3, 7, 8, 9 y 11, más la velocidad de las pichadas en ROOKIE.

## Pichadas y balance inicial

La duración del vuelo anterior prácticamente no distinguía las ligas. Ahora utiliza factores locales 2.25 / 1.85 / 1.50 / 1.20 / 1.00 para ROOKIE / SINGLE-A / DOUBLE-A / TRIPLE-A / MAJORS. Con rating 65 y variación central, una recta dura 0.7875 / 0.6475 / 0.525 / 0.42 / 0.35 segundos. En ROOKIE un sinker dura 0.8775, una curva 1.1025 y un cambio 1.215 segundos. La habilidad del lanzador y una variación acotada siguen influyendo.

El timing de ROOKIE también es más tolerante; un error de 60 ms con Contact 64 y rating 65 puede ser GOOD. Las ligas avanzadas conservan sus ventanas exigentes. La recta tarda más en llegar, en lugar de mostrar únicamente menos MPH. La preparación mantiene 0.96 s y la pelota usa tiempo real, independiente de la velocidad de la simulación. Se midieron vuelos completos con x1, x2 y x4 en Chrome; la diferencia entre duración esperada y observada quedó dentro de la tolerancia de uno o dos cuadros.

Son decisiones de balance para aprender en nivel 1. Los videos observados no permiten recuperar una tabla original completa por liga. No se afirma que estos factores, ventanas, precios, probabilidades, curva de XP o rangos sean las fórmulas del servidor de Syntasia. Los rangos S de 17 H / 9 R y C de 9 H / 2 R siguen siendo los dos puntos de referencia; no se cambiaron precios ni saldos históricos sin evidencia.

## XP durante las jugadas

Se corrige la eliminación introducida en 0.10.2. El gameplay muestra XP subiendo antes del resultado y después otros 100 XP por los cinco objetivos. El remake vuelve a mostrar XP provisional en el HUD y en la simulación: hit 2 XP, Home Run 5 XP, walk 1 XP, out 0 XP. Estos importes por jugada son una calibración local; los incrementos exactos del original no se recuperaron.

El ledger v4 conserva ese subtotal. Al liquidar el fixture se suman una vez XP por jugadas y XP por objetivos; el resultado presenta ambos subtotales. La prueba de 39 XP por jugadas más 100 de objetivos paga 139, sin duplicarlo al repetir la liquidación o recargar. Los empates de postemporada no pagan XP. Los ledgers v3 y los resultados antiguos no reciben premios retroactivos. Carrera v21, inventario, equipo, dinero y progresión existentes se conservan.

## Estadio y menús

Nuevo fondo ilustrado de ROOKIE, usado en HOME, menús y partido: montañas, gradas, luces, vegetación y césped más luminoso. Mantiene el marco 4:3 y las posiciones actuales del montículo y del plato. Los fondos adquiridos conservan prioridad; los colores de mejoras y las decoraciones siguen apareciendo. Se corrigió la colocación de las capas de BUILD sobre la cámara de 960×720.

Los botones compartidos centran su texto según la altura real de sus letras. La pulsación desplaza piel y texto juntos; los botones no se agrandan fuera de su área. Se guarda su composición estática y se elimina un filtro de sombra redundante. Es un ajuste de coherencia y legibilidad; no una reconstrucción completa de todos los menús o fuentes originales.

La imagen se creó con la herramienta integrada image_gen.imagegen, usando el estadio original y la cámara del remake como referencias. Recurso final: [rookie-stadium.png](build/assets/visual/v103/rookie-stadium.png). Prompt completo y procedencia: [stadium103-generation.json](../research/stadium103-generation.json). La imagen es una reconstrucción nueva, no un asset original recuperado.

## Animación, equipamiento y rendimiento

- El follow-through ya no mantiene una única pose entre 200 y 1040 ms: pasa por posiciones a 390, 660 y 980 ms, conservando el contacto a 45–110 ms y los 1340 ms totales.
- Un límite de alcance antes de asin impide una rotación NaN al apuntar muy alto o bajo. Se ejercitan tres alturas y once momentos del swing real.
- Las rayas de los bates se calculan sobre el eje grip/barrel de cada pose. Los guantes Collector se colorean dentro de sus manos ilustradas, sin pintar cuello o pantalón. Cascos, anteojos y colores de ropa siguen al personaje; no se rediseñó cada silueta de accesorio del original.
- Se reutiliza la silueta limpia de cada pose antes de aplicar la paleta. Se procesan vectores de píxeles en bloques en el bateador y los corredores. En los corredores se clasifican los materiales una vez por pose y se recolorean solo sus píxeles, con tablas de paleta acotadas, evitando repetir el análisis para cada compañero.
- La comparación de las doce poses sin equipamiento especial revisa 1,062,394 píxeles: cero diferencias superiores a cuatro unidades por canal, máximo una unidad por redondeo. Los corredores añaden otras 36 combinaciones de pose y paleta, con 2,642,961 píxeles comparados y el mismo máximo de una unidad.
- Los dos atlas de cuerpo antiguos dejan de formar parte de HeroSprite. WebMain pasa de 19,443,689 a 17,516,247 bytes. El nuevo fondo es un recurso externo de aproximadamente 1.6 MB.
- Cabeza aprobada de 0.8.6 y atlas de cabello intactos, verificados con SHA-256.

Medición aislada en Chrome, mismo equipo: entrada al partido 7020 → 3044 ms; muestra de 45 s 59.98 → 59.98 FPS; p95 32 → 17 ms. Son observaciones locales, no una garantía para todos los equipos o redes. La caché autenticada de SWF/WASM sigue revalidando; cuentas y guardados permanecen no-store.

## Validación y publicación

32 pruebas del servidor; registro real sin código, personaje, viaje y primer partido; Mystery, sobres, premios, equipamiento y persistencia; ledger y liquidación única; animación extrema; pichadas reales x1/x2/x4; caché y sesión; perfil de rendimiento; comprobación del paquete publicado y limpieza limitada a las dos cuentas QA reservadas.

Railway: 2b9cd4e4-710f-469d-9434-f21c0ff02417. Versión 0.10.3, build 022932742fe1257f. La copia de seguridad reside en el volumen /data/backups, no fuera del servidor. Sigue pendiente la prueba física entre dos computadoras con un amigo.
