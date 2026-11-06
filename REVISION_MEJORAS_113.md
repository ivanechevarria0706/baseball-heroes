# Mastery de entrenamiento · 0.10.13

RUNNING, STRETCHING y LIFTING muestran doce estrellas: cuatro Beginner, cuatro Expert y cuatro Pro. Después de la última estrella permanecen en MASTER; el entrenamiento continúa y cada barra de 1125 añade 5 ENERGY. No aparecen STEP 14, 15, etc. Los descansos independientes siguen activos.

## Evidencia y reconstrucción

En «Seguimos En Primer Lugar», 00:28 muestra cuatro estrellas, 1245/1350 y premio 2 Skill Points. Después de LONG RUN aparecen cinco estrellas, STEP 6 y el popup de 2 SKILL POINTS. En «eliminatorias final de la liga», STRETCHING ya es MASTER con 615/1125 antes de entrenar; sus 600 Mastery llevan energía de 17 a 22. RUNNING ya es MASTER con 870/1125 y lleva energía de 22 a 27. Ambos muestran 5 ENERGY y descanso. Esto respalda ciclos de energía después de MASTER. LIFTING muestra nueve estrellas y 3090/3600 en STEP 10.

La curva usada por STEP 1–12 es 1350, 1350, 1350, 1350, 1350, 1800, 2250, 2700, 3150, 3600, 4050 y 4500. Solo STEP 5 y STEP 10 están confirmados. Los cuatro primeros conservan el balance anterior; los restantes interpolan +450. No se presenta esta tabla como fórmula original recuperada. La regla de dos puntos por estrella se conserva; el premio exacto por entrar en MASTER no aparece en las fuentes. Aquí la última estrella da dos puntos y la siguiente barra completa da energía.

## Guardado y premios

El total histórico de mastery se conserva. Un registro aditivo progression v1 guarda estrellas, avance, ciclos y ancla al total. En carreras antiguas se conservan las estrellas ya ganadas (máximo doce) y la fracción de avance hacia la siguiente meta; no se retiran puntos ya otorgados ni se entregan premios retroactivos. Los descansos, compras y último premio antiguo permanecen. Una sustitución del total por un cliente anterior vuelve a aplicar esa conversión sin pagar recompensas.

La compra acredita XP, puntos o energía y su descanso en un único guardado. La energía de Mastery admite exceder la capacidad, como los premios observados; por debajo de la capacidad mantiene recuperación normal. Subir de nivel conserva su propia reposición de energía. La animación y el popup no otorgan premios: solo muestran el resultado acreditado.

Cada nuevo premio de estrellas/energía tiene un recibo y confirmación de lectura. Cerrar la pantalla o recargar antes de CONTINUE permite volver a verlo sin cobrarlo de nuevo. CONTINUE reconoce solo el recibo correspondiente; repetirlo o usar uno viejo no da premios. Los premios antiguos no producen popups nuevos. No se simula una publicación en Facebook.

La ventana usa el atlas de entrenadores de 0.10.12 mediante un recorte en memoria; no se modifica ningún PNG. Los títulos permanecen en inglés y las explicaciones y consejos, en español. La cabeza aprobada, el cabello, pichadas, partido, cartas, servidores, precios y sesiones se conservan. Guardado v23 / SQLite v4.

## Verificación

44 comprobaciones nuevas del modelo: umbrales observados, dos ejemplos de MASTER, ciclos repetidos, restos, doce estrellas como límite, migración sin premios, reloj de energía, overflow a 27, recibos y descansos. Se repiten las 149 comprobaciones previas de las 18 sesiones.

Chrome con entradas reales: STEP 5→6, popup de puntos, salida sin confirmar, carga y confirmación persistente, dos ciclos MASTER observados, fin automático y CONTINUE, botón bloqueado durante descanso, textos y vistas de la sala. El ejecutable público se comprueba localmente y en Railway: cuenta nueva nivel 1 / Rookie, recarga durante un entrenamiento de MASTER, ventana pendiente al volver, energía acreditada una vez, otra disciplina disponible, tres descansos, apariencia guardada y cierre/inicio de sesión. También se verifican migraciones v21 y v22. Las cuentas temporales se retiran al terminar. No se declara prueba entre dos computadoras físicas.

Publicada y verificada en Railway. Build a1534d61c76aa596.
