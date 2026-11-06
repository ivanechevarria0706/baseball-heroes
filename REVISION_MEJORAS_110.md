# Sobres especiales y grados · 0.10.10

Entrega de los puntos 6 y 7 de la revisión del video y documento. Se adopta el catálogo visible a 03:40–03:48 en `[FACEBOOK GAME]BASEBALL HEROES play video.mp4`. El PDF describe precios de otra referencia; no se combinan esas tablas con esta tienda. El tutorial inicial conserva expresamente su contrato anterior.

## Cambios

- Siete sobres en dos filas, en el orden observado: C, B++, B, B+, A, A+ y A++. B+ / A+ dejan de ser alias del sobre básico. Se muestran sus precios, rangos de grado y candados. Sobres C verdes, B azules y A dorados. Las ilustraciones de los paquetes reutilizan personajes disponibles; no son texturas recuperadas del original.
- Cada compra pasa por la misma definición que muestra la tienda. Los candados se comprueban en el modelo antes de gastar; un intento bloqueado, inválido o sin saldo no entrega una carta ni descuenta recursos.
- Cada sobre entrega una instancia. El modo de apertura bloquea otra compra; un segundo clic puede abrir el sobre ya pagado, pero no lo vuelve a comprar.
- Las nuevas cartas HERO solo salen en clases A y S. Se aplica a sobres especiales, sobres mixtos, TRADE, sobres de Mystery y premios CARD de las cajas. Las cartas C/B HERO ya poseídas, equipadas o pendientes de reclamar se conservan con sus estadísticas y mejoras. No se cambia la habilidad de esas cartas.
- La tienda explica los grados y las probabilidades en español. Los porcentajes se identifican como reconstrucción. Se mantienen los menús en inglés.

## Precios y evidencia

| Sobre | Precio de carrera | Grados nuevos | Candado / evidencia |
|---|---|---|---|
| C | 5,000 Coins | NORMAL / RARE | Sin candado visible |
| B++ | 45 Credits | RARE / ELITE | Disponible en la liga A del video; límite inferior desconocido |
| B | 10,000 Coins | NORMAL / RARE | DOUBLE-A |
| B+ | 15,000 Coins | NORMAL / RARE / ELITE | DOUBLE-A |
| A | 30,000 Coins | NORMAL / RARE / ELITE | TRIPLE-A |
| A+ | 45,000 Coins | NORMAL / RARE / ELITE / HERO | TRIPLE-A |
| A++ | 80 Credits | ELITE / HERO | DOUBLE-A |

El primer C Pack del tutorial sigue costando **6,000** y entregando Lenard J., para conservar el onboarding probado y los sobres ya pagados. Durante el tutorial se muestra esa cotización. Terminada o saltada la guía, el C Pack cuesta **5,000**. Esta excepción de compatibilidad es una decisión del remake, no una regla confirmada en el video más reciente. No se modifica el saldo inicial ni el premio de 40,000 monedas.

Los candados de B / B+ / A / A+ / A++ corresponden a los rótulos visibles. B++ está disponible en la liga A de la grabación; no demuestra cuándo se desbloqueaba antes. Se mantiene disponible en Rookie mientras ese dato siga desconocido. La llamada antigua al S Pack conserva su precio de 72 créditos, pero no se añade un octavo sobre sin referencia visual.

## Probabilidades

La grabación confirma rangos de grado, no sus probabilidades. Se reutilizan los pesos anteriores NORMAL 60, RARE 25, ELITE 12 y HERO 3, normalizados dentro de los grados permitidos por cada variante. Por ejemplo, A++ usa ELITE 80% / HERO 20%; esos porcentajes son balance reconstruido. Fuera de estos sobres, un sorteo que antes proponía HERO para B/C pasa a ELITE. Un premio ya guardado no se vuelve a sortear al abrirlo.

## Conservación y pruebas

Guardado v23 y SQLite v4. Los 33 IDs del catálogo y todos sus atributos conservan su definición anterior. El código de almacenamiento de instancias, las mejoras, migraciones y energía de cartas no cambia. La cabeza 0.8.6, cabello, ClassicBatter, PitchCadence, BattingSystem, StarterTutorial, SkillCatalog, MatchScoring y SpecialCardEconomy mantienen sus hashes. Partido y franja social permanecen iguales a 0.10.9. No se añade audio ni se modifican las reglas del servidor.

Modelo y Chrome local: rangos y pesos, siete variantes, límites de grado, pagos exactos, candados, saldo insuficiente, sobre inicial, sobres mixtos, Mystery y conservación de una HERO C. También se vuelven a comprobar las 39 cotizaciones y operaciones de TRADE / ENHANCE de 0.10.7. La prueba del ejecutable público usa entradas reales para B++ y A+, doble clic, recarga y cartas HERO C/B con todos sus campos y casilla conservados.

Tutorial completo local, desde nivel 1 / Rookie hasta el primer punto y premio único; registro e inicio público; partidas antiguas v21/v22 e importación. Las cuentas de prueba se eliminan al finalizar. No se declara una prueba física entre dos computadoras.

## Pendientes

El punto 8 continúa abierto: fichas originales como Marvin K., Howard D. o Benny C. con todos sus datos e ilustraciones legibles. También quedan disciplinas / Mastery, personaje femenino, más animaciones, calibración y modos restantes. Esta entrega no recupera las probabilidades del servidor ni todas las texturas originales.

Publicada y verificada en Railway. Build 5ceff6f7b4152955.
