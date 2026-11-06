# Web 0.7.1 · RUNNING y sala de entrenadores

TRAIN abre la sala ilustrada de la hoja 11_08 aportada por el usuario. RUNNING presenta seis actividades en dos filas, usando recortes de las ilustraciones del gameplay, con controles reales para iniciar y cerrar. ATRIBUTOS mantiene el entrenamiento de POWER, CONTACT y LUCK del remake, con retratos ilustrados en lugar de los círculos anteriores.

## Datos observados en el video

Fuente: «Seguimos En Primer Lugar», fotogramas `reference_visual/gameplays_20260924/primer_lugar-0030.jpg` y `primer_lugar-0061.jpg`.

| Actividad | Descanso | Monedas | Mastery | XP |
|---|---:|---:|---:|---:|
| 30 yardas | 1 h | 90 | 60 | 16 |
| 100 metros | 4 h | 250 | 150 | 40 |
| Carrera de 1 milla | 8 h | 400 | 225 | 60 |
| Sliding | 12 h | 550 | 300 | 80 |
| Máquina de correr | 24 h | 1.000 | 480 | 128 |
| A correr mucho | 48 h | 1.250 | 600 | 160 |

El premio se entrega al empezar; después aparece ON BREAK y su contador. Recargar o cerrar el navegador no vuelve a concederlo. El fin del descanso habilita otra actividad, sin un segundo premio ni una recogida pendiente. No se puede iniciar otra actividad del mismo entrenador mientras descansa.

El gameplay muestra un umbral de 1.350 y un premio de 2 SKILL POINTS al completar un paso. **Aplicar 1.350 a todos los pasos y dividir Beginner/Expert/Pro cada cinco pasos son reglas de reconstrucción**, no tablas originales recuperadas. Los puntos se entregan al héroe; la XP usa la progresión de cuenta existente. Estas actividades no suben directamente SPEED ni sustituyen la mejora de atributos. Las otras disciplinas del salón aún no tienen actividades propias.

## Guardado y correcciones

`runningTraining` añade Mastery, actividad, último premio y fin del descanso al esquema 21. Un guardado anterior sin ese campo carga con el entrenador disponible; no altera las monedas, el nivel ni el progreso ganado. NUEVA CARRERA reinicia también este entrenamiento.

Ruffle 0.6.0 recortaba a 32 bits las fechas largas leídas como enteros JSON; se conservan los milisegundos UTC como texto y se convierten a Number únicamente para calcular el contador. El cliente web normaliza el JSON antes de compararlo con la petición pendiente, corrigiendo un bucle de guardado con números escritos en notación científica.

La espera HTTP pasa de 14 a 30 segundos y el puente RIVAL permite 40 segundos para recibir su respuesta. Si se pierde una respuesta de registro, se comprueba la cuenta mediante inicio de sesión con las mismas credenciales; no se envía un segundo registro. Los errores de validación o usuario duplicado siguen mostrándose normalmente. Los errores de conexión se explican en español.

El reloj y el avance de la carrera permanecen en el cliente, como los demás sistemas actuales del remake. La nube conserva el guardado por cuenta y sus revisiones; esta entrega no transforma la carrera en un sistema competitivo validado por el servidor.

## Pruebas

- `build/qa/smoke-running071.txt`: seis costes y premios, cobro inmediato, descansos, rechazo de doble pulsación/saldo insuficiente/actividad inválida, STEP, XP, recarga sin repetir premios, expiración en pantalla, partidas anteriores y ATRIBUTOS.
- `build/qa/smoke-web071-staging.txt`: paquete de producción, registro sin código, recursos autenticados, esquema compatible y exclusión de los SWF de prueba.
- `build/qa/smoke-cloud071-running.txt` y `smoke-registration071-cloud.txt`: controles del WebMain publicado, actividad real, descanso tras recarga, dos cuentas nuevas, sesiones y guardado; se generan al verificar el despliegue.
- `build/qa/smoke-cloud071-cleanup.json`: retirada de las dos cuentas sintéticas y conservación de las existentes.
- `build/qa/smoke-registration-recovery071.txt`: respuesta de registro descartada deliberadamente, recuperación mediante credenciales y rechazo normal de duplicados sin autenticar automáticamente.

La comparación visual está en `COMPARACION_ENTRENAMIENTO.html`. El salón y las ilustraciones de las actividades proceden de los materiales aportados; aún faltan las animaciones, fuentes e iconos exactos del original. No se declara paridad completa.
