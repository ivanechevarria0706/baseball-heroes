# Baseball Heroes — primera revisión visual local

**Actualización:** la versión actual es 0.6.7. Comparte `Baseball_Heroes_para_amigos_Windows_v067.zip`, extrae todo y abre `BaseballHeroesRemake.exe`: incluye el runtime de Windows x64. Se verificaron un amistoso completo por HTTPS, recuperación tras reiniciar Railway y clasificación de liga compartida. Hay una copia externa de la base descargada y verificada. Abre `CONEXION_AMIGOS.html` para crear tu primera cuenta y seguir los pasos para invitar al grupo. El servidor de internet es el predeterminado para sesiones nuevas; el modo local y el guardado v21 se conservan. Falta la primera prueba en otra PC Windows. El resto de este documento es historial.

## Abrir el juego

Haz doble clic en **JUGAR.bat**. Utiliza la compilación incluida y el SDK AIR que ya tienes en `C:\Users\ivane\Downloads\FlexSDK`. No necesita conectarse a Facebook ni recompilar para jugar. Si lo llevas a otra computadora, necesitarás un SDK AIR compatible y configurar `FLEX_HOME`.

El ZIP original de Descargas permanece intacto. Esta copia se trabajó en Documentos/Baseball Heroes. El identificador de la aplicación se conserva; el guardado se migra al formato actual. Las pruebas utilizan otra identidad de aplicación; sus monedas, partidos y cambios de estadio no afectan a tu partida.

## Decisión

Conviene conservar la base de ActionScript/AIR y reconstruir su presentación por escenas. Ya existen cartas, alineaciones, entrenamiento, equipamiento, simulación, bateo, temporadas y persistencia. Reescribir todo ahora perdería ese trabajo sin resolver la principal distancia con el original: ilustraciones, proporciones, animación y composición de pantalla.

Esta entrega es una primera corrección comprobable, no una recreación completa ni una recuperación del código de Syntasia.

## Cambios realizados

- HOME: campo despejado, recursos compactos, retratos del roster, héroe de cuerpo completo, navegación sin el solapamiento de NAME/MODES/ROADMAP y próximos rivales con escudos.
- Estadio compartido entre HOME y partido. Los fondos que ya contiene el proyecto también se muestran en HOME al estar seleccionados. El estadio Rookie se reconstruye con dibujo nativo a partir de la composición de las referencias; sigue siendo arte provisional.
- Las decoraciones colocadas en BUILD se dibujan también en HOME, usando la misma posición que en el partido. Se conservan los colores seleccionados de césped, gradas, muro, valla, anuncios, luces y marcador en el campo nativo.
- Simulación: se retira el campo independiente que tapaba el estadio seleccionado y se evita dibujar al mismo tiempo el HUD de bateo y el de simulación.
- Cámara de bateo: posición y escala de bateador, lanzador y zona de strike ajustadas al campo compartido; las fórmulas de timing se conservan.
- Insignias: se recorta su visualización para excluir fragmentos de otra insignia presentes en las tiras de imágenes. Los archivos de arte originales no se alteran.
- Personajes: se separan los rellenos de cuello, cabeza y casco para evitar huecos transparentes en sus intersecciones. Corregido en bateador, lanzador y retrato vectorial.
- Entradas: el saldo cambia de inmediato al cobrar, el botón muestra el tiempo restante y no permite duplicar el cobro durante la espera.
- HUD de bateo: estadísticas y etiqueta SKILL separadas; nombre del próximo bateador con espacio para varias líneas.
- JUGAR.bat permite ejecutar el SWF incluido directamente.

## Verificación

Compilación con el Flex/AIR instalado en tu equipo. Pruebas de ejecución con una partida aislada:

- construcción y renderizado de HOME, LINEUP y partido;
- llamada a los callbacks de los 12 destinos del lobby;
- cobro de entradas, actualización visible del saldo y rechazo del segundo cobro;
- transición desde simulación a READY del héroe, restauración del HUD y entrada de SPACE para lanzar/batear;
- captura del lobby con el fondo Major ya incluido en los assets.

Resultados: `build/qa/smoke-after.txt`. Capturas antes/después: `build/qa/`. Código de la prueba: `tests/VisualSmoke.as`. Esto no es una prueba exhaustiva de todas las temporadas, cartas, equipos y combinaciones de guardado.

## Lo que sigue lejos del original

1. **Personajes y animaciones.** El héroe y el pitcher siguen siendo figuras vectoriales provisionales. Es el mayor problema de fidelidad. Los retratos existentes no equivalen a un conjunto completo de sprites animados y personalizables.
2. **Proporciones.** La interfaz original del primer video es esencialmente 4:3; el remake usa 960×540. Una fase específica debe convertir el diseño a un marco clásico coherente, con adaptación de todas las pantallas.
3. **Cartas.** Falta revisar, carta por carta, marcos, rarezas, habilidades, efectos, energía, sobres y trade/enhance contra imágenes legibles. No se deben inventar fórmulas y presentarlas como históricas.
4. **Partido.** Las probabilidades, tiempos de lanzamiento, trayectorias y simulación actuales son una aproximación. Se necesita comparación por secuencias, no solamente por capturas.
5. **Transiciones y audio.** Las entradas al campo, reacciones, celebración del hit, recompensas y sincronización musical requieren trabajo específico.

La prioridad recomendada para continuar es preparar una sola escena de bateo fiel (arte y animación) y contrastarla con una secuencia concreta del video antes de extender ese sistema al resto del juego.

Los README_PHASE anteriores se conservan como historial del proyecto; algunas de sus listas de pendientes están desactualizadas. No son instrucciones nuevas del usuario.

## Fuentes encontradas

- [Presentación de Syntasia, diciembre de 2011](https://d21buns5ku92am.cloudfront.net/26496/documents/16099-1324368348-BaseballHeroes_%EA%B2%8C%EC%9E%84%EC%86%8C%EA%B0%9C%EC%84%9C_ENG.pdf): documenta personalización, bateo de acción, cartas de bateadores, equipo y progresión de ligas. Es material temprano y no demuestra por sí solo cómo era la versión de 2016.
- [Facebook — Baseball Heroes — No doy una](https://www.youtube.com/watch?v=MevH2YYIEng), iMigbo Monsters, publicado el 2 de mayo de 2013. Es el primer video aportado: 640×480, 30 fps, 19:03.07. Referencias clave: selección y creación inicial, HOME alrededor de 2:15 y 7:10, simulación alrededor de 3:40, bateo alrededor de 4:30, resultado 6:20, edición de estadio 9:50 y 11:20.
- [Kediri City World Championship 54th season](https://www.youtube.com/watch?v=tC4fauu0eOg), iPomsky, publicado el 22 de julio de 2014. Es el segundo video aportado: 1276×720, 25 fps, 5:11.52. Sirve para partido avanzado, presentación de hits y celebración alrededor de 5:00.
- [Baseball Heroes Trailer](https://www.youtube.com/watch?v=pDJEZF4T1uY), localizado desde el [catálogo Browser Craft](https://browsercraft.com/game/baseball-heroes--1). Enlace localizado; la reproducción no se verificó.
- [Baseball Heroes Game Art / Syntasia](https://www.behance.net/gallery/61575435/Baseball-Heroes-Game-Art-Syntasia): galería de referencia para el lenguaje visual. El ZIP aportado ya incluye fondos y retratos que se pueden aprovechar.
- [SYNTASIA/BASEBALL HEROES, Kevin Lee](https://soundcloud.com/ti7sound/sets/syntasia-baseball-heroes): colección identificada con temas del juego, vestuario y tienda. Se localizó la fuente; no se descargó música ni se validó su sincronización en esta revisión.
- [Facebook: Top Rated Social Games of 2012](https://about.fb.com/news/2012/12/top-rated-social-games-of-2012/amp/): confirma Baseball Heroes de Syntasia en la selección de ese año.

Se extrajeron y examinaron 29 fotogramas distribuidos por ambos videos, además de comparar renders del programa. No se afirma haber reproducido íntegramente ambos videos ni conocer los algoritmos internos originales. Las referencias aportadas son de 2013 y 2014: habrá que distinguir sus cambios respecto a tu recuerdo de 2016.

Todos los cambios y capturas quedan localmente; el proyecto no se publicó ni se subió a un servicio de alojamiento.
