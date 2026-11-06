# Tres disciplinas de entrenamiento · 0.10.11

Se añade la parte funcional del punto 14: STRETCHING y LIFTING, con seis sesiones cada una, entrenadores propios, ilustraciones observadas y descansos independientes. RUNNING mantiene sus seis sesiones y precios anteriores, que sí se leen en su captura original.

## Comportamiento

- Las tres barras muestran progreso y estado READY / ON BREAK. Al empezar aparece el letrero con reloj del entrenador correspondiente. Se puede consultar su catálogo durante el descanso.
- El premio se entrega al empezar. Se valida disciplina, sesión, descanso y saldo antes de cobrar o premiar. Un segundo clic durante el descanso no repite ninguna operación.
- Entrenar RUNNING permite utilizar STRETCHING o LIFTING sin esperar a ese entrenador. Una sesión de 48 h respeta 48 horas reales aunque se cierre el navegador.
- Menús y ejercicios en inglés; diálogos, errores y consejos en español. ATTRIBUTES continúa accesible.

## Sesiones observadas

| Duración | STRETCHING | LIFTING | Coins | Mastery | XP |
|---|---|---|---:|---:|---:|
| 1 h | Trunk Twist | Push-Up | 120 | 60 | 16 |
| 4 h | Knee Hug | Pull-Up | 350 | 150 | 40 |
| 8 h | Leg Stretch | Barbell Lunge | 600 | 225 | 60 |
| 12 h | Knee Bend | Bench Press | 800 | 300 | 80 |
| 24 h | Side Lunge | Leg Press | 1,500 | 480 | 128 |
| 48 h | Walking Lunge | Butterfly Machine | 1,800 | 600 | 160 |

Fuente: `baseball heroes eliminatorias final de la liga.mp4`, cuadros 00:12 y 00:33. Las ilustraciones se extraen en memoria de las capturas existentes; se conservan sin repintar los archivos originales. No se recuperan animaciones nuevas del héroe.

## Guardado y compatibilidad

Guardado v23 / SQLite v4, sin cambios de servidor. RUNNING conserva sus campos mastery, availableAt, activity y lastReward. Los registros nuevos quedan en runningTraining.disciplines.stretching y .lifting. Las carreras anteriores comienzan ambas disciplinas en cero y conservan el progreso y descanso de RUNNING. No se recalculan ni se vuelven a entregar premios antiguos. Los tiempos UTC siguen como texto para evitar el truncamiento de enteros en Ruffle.

La cabeza 0.8.6, cabello, bateo, pichadas, energía, cartas, sobres, tutorial, estadísticas y progresión ajena a entrenamiento permanecen iguales a 0.10.10.

## Pruebas

149 comprobaciones del modelo: las 18 sesiones, importes y premios exactos, duraciones UTC, doble inicio, tres descansos simultáneos, expiración independiente, falta de saldo, entradas inválidas, estado mal formado, carga antigua y cobro único del punto de STEP. Chrome local comprueba entradas reales, texto visible, apertura/cierre repetido, ATTRIBUTES y recarga de los tres relojes.

El ejecutable público se comprueba localmente y en Railway: registro nivel 1 / Rookie, RUNNING antiguo intacto, Walking Lunge 48 h por 1,800, Push-Up 1 h por 120, clic repetido y persistencia tras recargar y cerrar/iniciar sesión. También se comprueba la carga de partidas v21 y v22. Las cuentas temporales se eliminan al finalizar. No se declara una prueba física entre dos computadoras.

## Sigue pendiente

Mastery / estrellas / MASTER y sus premios de 5 ENERGY (punto 15). Se conserva por ahora el balance de STEP de 1,350 y 2 puntos del remake, también para las nuevas disciplinas. No se presenta esa curva como original. El video ya muestra MASTER antes de entrenar; no basta para afirmar que los 5 ENERGY se cobran una sola vez de por vida. También faltan las animaciones de ejercicios y la identificación de los puestos cuarto y quinto. No se mezclan automáticamente precios de versiones distintas.

Publicada y verificada en Railway. Build b35ce9e03caf8a2b.
