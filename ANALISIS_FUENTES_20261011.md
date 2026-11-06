# Investigación de reglas y balance del original

Revisión: 11 de octubre de 2026. Base comparada: remake 0.10.0.

Esta revisión incorpora información al proyecto; no cambia fórmulas, partidas guardadas ni el despliegue. Las guías describen observaciones de jugadores. No equivalen al código ni a las tablas del servidor. Además, pueden corresponder a actualizaciones distintas del juego.

## Qué respalda la investigación enviada

| Afirmación | Resultado de la comprobación |
| --- | --- |
| Contact, Power y Luck afectan los resultados | Documentado cualitativamente. No se recuperaron coeficientes. |
| Un punto de estadística por nivel | Documentado. El remake ya lo concede. |
| Tabla GAME / WINNER / MVP / RANK S / BONUS | Aparece con esas cantidades en Gamelytic. Falta comprobar su vigencia en los videos tardíos. |
| Out 35–45 % con buen timing; 90 % con mal timing | No se encontraron esos porcentajes en las fuentes citadas. |
| Hit 50–60 %; Home Run inicial menor de 5 % | No verificado. Faltan muestra, condiciones y versión del juego. |
| Home Run 80–90 % con Combo máximo | No verificado. Una reseña de 2015 describe otra regla: Home Run automático al conectar con la barra llena. |
| Combo máximo después de 3–4 hits | No se recuperó un número universal; Luck modifica la ganancia de Combo. |
| Curva completa de XP y tramos de +150 | No verificado. El documento de Scribd no identifica Baseball Heroes. |
| Equipamiento de 5.000–50.000 y bates de 150.000–1.000.000 Coins | No se encontraron esos intervalos generales en las páginas citadas. Conviene registrar precios por artículo y versión a partir de capturas. |
| Cierre oficial en agosto de 2017 | Mes y anuncio oficial sin confirmar. Hay un testimonio de 2018 que recuerda un cierre en 2017. |
| Fórmulas reconstruidas por ingenieros inversos | No se localizó un estudio identificable con código, método, muestra o tablas que sustente los porcentajes enviados. |

“No verificado” significa que todavía no hay evidencia suficiente para usarlo como regla histórica, no que se haya demostrado falso.

## Estadísticas y Combo

La [guía de estadísticas de Gamelytic](https://gamelytic.com/baseball-heroes-skill-stats-guide/) relaciona Contact con los hits y Contact Hit; Power con distancia y Power Hit; Luck con más puntos de Combo por hit y mayor aparición de Lucky Hit. También indica un punto de estadística por nivel y bonificaciones del equipo. No publica porcentajes, límites ni ventanas de timing.

La [reseña de WWGDB, del 4 de abril de 2015](https://www.wwgdb.com/games/baseball_heroes), describe contribuciones de los hits del equipo a la barra y un Home Run automático cuando está llena, condicionado a conectar el siguiente lanzamiento del héroe. Es una observación contemporánea útil, pendiente de contrastar con secuencias completas de los videos. No justifica asignar arbitrariamente 80–90 % ni garantizar un swing fallado.

La [reseña original de Gamezebo](https://www.gamezebo.com/reviews/baseball-heroes-review/) describe cartas especiales que aportan Combo y habilidades de hit garantizado en una entrada concreta. Las reglas de las cartas y las de la barra deben comprobarse por separado.

## Recompensas históricas recuperadas

La [guía de puntuación de Gamelytic](https://gamelytic.com/baseball-heroes-scoring-and-ranking-guide/) contiene esta tabla:

| Condición | XP | Coins |
| --- | ---: | ---: |
| GAME: terminar el partido | 20 | 100 |
| WINNER: ganar | 10 | 50 |
| MVP: al menos 3 RBI | 15 | 100 |
| RANK S: 20 hits y 10 carreras del equipo | 25 | 150 |
| BONUS: cumplir las cuatro anteriores | 30 | 500 |

La suma de los cinco conceptos es **100 XP y 900 Coins**. Es una suma de esta tabla, no una recompensa universal demostrada para todas las ligas, eventos o versiones. La página deja vacíos los requisitos de los rangos B y C; no permite reconstruir una escala completa.

La [guía de HubPages](https://discover.hubpages.com/games-hobbies/facebook-game-baseball-heroes-tips-and-strategies) también recoge los primeros cuatro conceptos y explica Luck/Combo cualitativamente. Sus recomendaciones de cómo repartir estadísticas no son probabilidades de resultado.

## Curva de XP y economía: lo que sigue abierto

El [documento de Scribd enlazado](https://www.scribd.com/document/935798548/Exp-Curve-Lv1-100) plantea una curva con objetivo de unas 200 horas y una tasa de 10 EXP/minuto. Sus primeras transiciones son 50, 51 y 53 EXP; de nivel 9 a 10 indica 78. No identifica Baseball Heroes ni explica una extracción del juego. No se debe convertir en la curva del remake atribuyéndola al original.

La [reseña de Techulator](https://www.techulator.com/resources/6707-facebook-game-baseball-heroes-review-walkthrough-how-play-tips) confirma timing, estadísticas y compras con Coins/Créditos, pero no aporta los intervalos de precios ni una curva de XP. El [sitio de WordPress](https://baseballheroeshere.wordpress.com/) reproduce reseñas; sus textos repetidos no constituyen confirmaciones independientes de fórmulas.

## Nueva información aprovechable: Mystery Boxes

La [guía de Mystery Boxes](https://gamelytic.com/baseball-heroes-mystery-box-information/) enumera:

| Caja | Llaves |
| --- | ---: |
| Rookie | 2 |
| Green A | 3 |
| Blue AA | 4 |
| AAA | 5 |
| Majors | 7 |

Describe llaves solicitadas a amigos y premios de Coins, energía, bates, gafas, guantes y cartas superiores. Para Green A menciona premios de 6.000, 12.000 y 30.000 Coins. **No publica tasas de aparición**: no permite deducir porcentajes para cada premio.

## Nueva referencia visual: WORLD MATCH

Localizado y comprobado en el navegador: [Baseball Heroes Masters Random World Match gameplay #1 — sean893](https://www.youtube.com/watch?v=qyGlYWeMtEM), publicado el **24 de enero de 2017**, duración 10:29.

Inspección puntual del inicio y de 9:26: interfaz WORLD MATCH, simulación con alineaciones enfrentadas, barras de Combo para ambos lados, activación visual de carta y turno de bateo con CONTACT HIT. No se ha medido todavía el video completo ni se deducen de estos dos puntos sus reglas de acceso, recompensas o emparejamiento.

El [perfil empresarial de Syntasia en GameJob](https://www.gamejob.co.kr/Company/Detail?M=11532683) identifica Baseball Heroes Masters como juego para Facebook. Se conserva la etiqueta Masters para no mezclar automáticamente reglas de distintas etapas.

## Fuentes oficiales e historia

El [anuncio de la beta de 2011](https://www.prlog.org/11752744-baseball-heroes-free-to-play-baseball-game-on-facebook-commencing-its-closed-beta-test.html) y la [ficha promocional de Syntasia](https://d21buns5ku92am.cloudfront.net/26496/documents/16099-1324368348-BaseballHeroes_%EA%B2%8C%EC%9E%84%EC%86%8C%EA%B0%9C%EC%84%9C_ENG.pdf) son referencias tempranas del producto. La ficha enumera 30 equipos regionales, cinco ligas, personalización, hits/outs/errores y desbloqueos de equipamiento, transporte, cartas y tipos de lanzamiento. No contiene matemáticas del servidor ni describe todas las actualizaciones posteriores.

El [video histórico citado por el usuario](https://www.youtube.com/watch?v=VMqKJo5UgFM), publicado el 5 de abril de 2026, no es un análisis de código: se comprobaron su descripción y subtítulos. Hay una discrepancia entre la descripción, que alude a 2020, y la narración, que sitúa el cierre en 2017. Ninguna de esas referencias confirma agosto mediante un anuncio oficial. Un [testimonio comunitario de mayo de 2018](https://steamcommunity.com/discussions/forum/12/1696046976474953340/) también recuerda 2017. El perfil oficial de Facebook redirigió al acceso y no permitió verificar aquí el anuncio de cierre.

La [colección del compositor Kevin Lee](https://soundcloud.com/ti7sound/sets/syntasia-baseball-heroes) conserva referencias de música del juego. Esta fuente ya estaba en RESEARCH_NOTES.md; no constituye audio nuevo integrado. El proyecto ya incluye tres pistas aportadas por el usuario y cuatro efectos aislados. No se verificó equivalencia de las pistas actuales con esos archivos publicados.

## Diferencias comprobadas en nuestro código

Inspección de la carpeta src, sin modificarla:

- `MatchMomentum.as`: barra de 10 unidades; ganancia fija por resultado; consume carga desde el primer umbral al empezar el turno. La función de ganancia no recibe Luck. Esto requiere revisión frente al comportamiento observado.
- `MatchScoring.as`: calcula rango por puntos y MVP mediante comparación de filas individuales. Las cinco etiquetas ya existen, pero distribuyen el presupuesto local de monedas; no aplican la tabla histórica anterior.
- `GameData.as`: objetivo de nivel `180 + 20 × (nivel − 1)`; recompensas de partido dependientes de victoria, liga e hits. Son reglas del remake. El punto de estadística por nivel ya coincide con la guía.
- `MysteryInventory.as`: solo Rookie y Single-A, con 2 y 3 llaves. Faltan AA, AAA y Majors, además de premios de equipamiento. Las probabilidades actuales están declaradas como reconstrucción local.

## Prioridad propuesta para la siguiente implementación

1. Medir secuencias de barra vacía → llena → golpe → consumo; registrar Luck, resultado y carta activa. Corregir la relación Luck/Combo y el disparador MAX con evidencia, manteniendo coeficientes desconocidos identificados como aproximaciones.
2. Contrastar la pantalla de resultados de los videos tardíos con la tabla recuperada. Separar puntos de presentación, requisitos de rango y pagos reales antes de cambiar economía; conservar recompensas ya cobradas.
3. Completar las tres Mystery Boxes superiores y su catálogo de premios, distinguiendo costos documentados de tasas de aparición aún desconocidas.
4. Analizar la nueva referencia WORLD MATCH completa para composición, flujo y ritmo. Medir XP entre niveles consecutivos y precios de artículos visibles en los videos, sin extrapolar una curva completa desde capturas aisladas.

No se han recuperado las fórmulas originales del servidor. Sí hay más reglas observables concretas con las que sustituir aproximaciones del remake.

## Evidencia posterior: dos gameplays adicionales, 12 de octubre

El [nuevo análisis contra 0.10.4](ANALISIS_NUEVOS_VIDEOS_20261012.md) registra discrepancias con la tabla histórica. En el primer partido ROOKIE (video3, 5:43–5:51), el héroe recibe MVP con 5 hits y 1 RBI; el equipo tiene 16 hits y 1 carrera, RANK D. No se sostiene un requisito universal de 3 RBI para esa versión. En el video de eliminatorias, 20 hits / 12 carreras dan S y 11 hits / 7 carreras dan C.

Los cambios de barra al liquidar resultados son +45 XP en el primer partido, +200 XP / +2340 Coins en la victoria TRIPLE-A y +70 XP / +500 Coins en la derrota TRIPLE-A. El primer partido muestra además +370 Coins de resultado; el saldo total sube 2370 al coincidir con el nivel 2. No se deduce de estos casos la tabla completa de las cinco categorías. Es necesario separar versión/liga, ganancias por jugada y level up antes de reemplazar el balance actual.

Estos archivos también muestran metas HIT/RBI, una misión de tutorial de 40000 Coins, mastery de entrenadores con premio de 5 ENERGY y un tooltip de copa TRIPLE-A que ofrece 60000 Coins. El cobro de esa copa y el campeonato mundial no aparecen. Las recomendaciones anteriores describían el estado 0.10.0; varias ya fueron implementadas y deben contrastarse con la versión actual.
