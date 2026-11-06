# Mejoras 0.10.0

11 de octubre de 2026. Selección del usuario: 1, 2, 4, 8, 9, 10.

## 1 · Cuerpos y movimiento

El lanzador usa 24 cuerpos nuevos de tinta plana con la cabeza 0.8.6 como pieza separada. Preparación, elevación de pierna, zancada, suelta y recuperación tienen anclajes propios. Se conserva la cabeza del bateador. El corredor asienta los pies al llegar; los defensores tienen puntos medidos de guante y mano.

## 2 · Cinemáticas

DOUBLE y TRIPLE conservan el seguimiento, pasan a la celebración y terminan con palabras grandes e inclinadas sobre verde. OUT recibe la pelota en el guante y acerca los pies a la base. La pelota de HOME RUN impacta en el actor ilustrado. ENTER adelanta sin reiniciar la escena.

## 4 · Creador

La paleta de cabello pasa de 10 a 20 colores. Los diez identificadores anteriores conservan exactamente su color; Random incluye las opciones nuevas. El color elegido se guarda y llega al perfil compartido con amigos. Los ocho peinados y rasgos existentes se conservan.

## 8 · Acabado de pantallas

Selector de modos y Derby comparten cabeceras azules, marcos y tipografía incrustada con las otras pantallas. Los modos que todavía faltan siguen indicando su estado. Estas dos vistas son de la actualización; no son capturas del original.

## 9 · Contenido visible

El catálogo de decoraciones incorpora otros 19 emblemas y ofrece 27 ciudades. Se reutilizan los recortes completos de tu lámina. Pueden comprarse y colocarse con BUILD. Los ocho artículos anteriores mantienen sus IDs y precios. Los nuevos precios son valores del remake, no precios históricos recuperados.

## 10 · Calibración observable

Se midió un DOUBLE de 30).mp4: contacto alrededor de 101.86 s, celebración visible a 104.50 s, texto sobre verde a 107.50 s y salida alrededor de 109.51 s. El remake deja continuar a los 7.5 s; antes lo hacía a los 2.53 s. TRIPLE reutiliza esa cadencia como reconstrucción. No se alteran probabilidades, precios existentes, XP ni recompensas sin evidencia nueva.

## Conservación

- BatterHead086.as y assets/sprites/v083/hair-atlas.png conservan sus SHA256 aprobados. El bateador no recibe una cabeza nueva.
- GameData.as, BattingSystem.as y PitchCadence.as son idénticos a 0.9.9. Guardado v21, SQLite v3, registro abierto y nivel 1 ROOKIE conservados.
- Los colores nuevos se añaden al final. La selección por nombre de jugadores antiguos sin apariencia también conserva su paleta anterior de diez colores.
- El servidor solo amplía el límite del color compartido de 9 a 19. Se verifica con un perfil de amigo después de reiniciar el servicio.
- No se añade audio de gameplays. Se mantienen los cuatro efectos limpios del usuario.
- Respaldos locales en research/upgrade100-before y copia SQLite en el volumen de Railway. Esta copia no es externa al proveedor.

## Procedencia y alcance

- [PitcherBodySprite / prompt](assets/sprites/v100/README.md): ilustración generada, recortes completos medidos, cuello y pies por pose. Caché acotada por paleta; el guante conserva su marrón.
- [Cadencia y fotogramas](reference_visual/calibration100/README.md): observaciones separadas de inferencias. La fórmula histórica de probabilidades, XP, energía, precios y habilidades no se deduce de una sola jugada.
- 27 emblemas de ciudades no equivalen a todos los 30 logos de la lámina: esta incluye variantes de ciudad. Los 19 artículos añadidos son decoraciones nuevas del remake usando ese arte.
- El acabado se centra en las pantallas todavía discrepantes de modos y Derby; no se afirma haber rehecho todo el arte de todos los menús.
- El creador mantiene ocho peinados y ocho opciones por rasgo. No se añade aquí el personaje femenino pendiente.

## Pruebas de la versión

- WebMain, WebVisual100, WebUpgrade097 y WebPerformance compilados desde las fuentes finales.
- Galería de 64 cabezas/peinados, frente y giro, tres colores; paletas sin mutar el guardado. Ocho secuencias cinematográficas y cinco saltos a resultado.
- Carrera nueva y recarga reales en Chrome; color nuevo 16 persistente; energía cobrada una sola vez al entrar al primer partido.
- Motor: habilidades, catálogo, combo, recompensas, marcador y resultados con liquidación única.
- 30 pruebas de servidor. Las primeras conexiones locales fueron denegadas por el sandbox; la ejecución con red autorizada pasó las 30.
- Railway confirmó SUCCESS para 0.10.0, build b58bfd0ad1310cdc. Los 134 archivos comprobables del contenedor coinciden con el paquete probado; SQLite v3 pasó la comprobación de integridad.
- Chrome en la versión pública completó registro sin código, nivel 1 ROOKIE, creador con color nuevo 16, llegada, primer partido y recuperación de la carrera al iniciar sesión otra vez.
- El perfil aceptado de un amigo conservó el color nuevo 19; los perfiles sin aceptación permanecieron privados. El regalo se acreditó una sola vez después de dos recargas y se respetó el límite diario.
- Dos sesiones independientes completaron un reto y los dos partidos de una liga, y conservaron el mismo resultado tras recargar. Cerrar sesión en una no cerró la otra. No equivale a una prueba física desde dos computadoras.
- Se retiraron las dos cuentas temporales y sus tres partidos de prueba. Las cuentas que existían antes de la prueba se conservaron. Informes en revision_manifest.json.

## Rendimiento final local

La entrada inicial al partido tardó 7.8 s en esta muestra, frente a unos 3.3 s registrados en 0.9.9. La fluidez durante el partido se mantuvo cerca de 60 FPS, pero la carga inicial sigue siendo un punto a mejorar. Son muestras locales de Chrome, no una comparación controlada ni una garantía para todas las computadoras.

```json
{
  "frames": 2708,
  "pitches": 6,
  "over50": 1,
  "target": 60,
  "max": 110,
  "fps": 59.934045990748736,
  "elapsed": 45183,
  "game": {
    "phase": "SIMULATION",
    "batter": "Carlos",
    "advances": 16,
    "inning": 4,
    "advanceMax": 8
  },
  "p95": 17
}
```
