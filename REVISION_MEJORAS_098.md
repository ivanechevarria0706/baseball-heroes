# Mejoras 0.9.8

11 de octubre de 2026.

## Acceso y juego en inglés

El acceso web, las acciones, las habilidades, los logros, los avisos, el guardado y los errores de red están en inglés. Se conservan STRIKE, OUT, BALL, HIT, HOME RUN y las demás expresiones del béisbol.

## Cabello ajustado a cada cabeza

El ancho se calcula con las mismas medidas de sienes que usa la cabeza elegida. Cada peinado conserva su volumen y tiene un ajuste de altura para sus raíces. El creador, HOME y los retratos comparten este ajuste.

## 64 combinaciones revisadas

Ocho formas × ocho peinados, comprobados de frente y girados, con colores oscuro, rubio y blanco. La vista previa no cambia el guardado. La cabeza del bateador 0.8.6 se conserva intacta, incluido su casco.

## Mensajes y descripciones coherentes

Las descripciones, requisitos, confirmaciones y estados de habilidades se presentan en inglés. También se traducen las misiones, recompensas, objetos y avisos durante los partidos. No cambia el balance.

## Entrenamiento y contadores de logros

Las seis actividades, el acceso a atributos, los costos y los contadores de los 18 logros también están en inglés. Sus identificadores, tiempos y progreso guardado no cambian.

## Amigos y ligas privadas en inglés

RIVAL, publicación de equipos, retos, solicitudes, regalos, clasificación y calendario usan el mismo idioma. Se conservan los nombres escritos por los jugadores. La guía pública coincide con los botones del juego.

## Recuperación de una carga fallida

Si el juego no llega a arrancar, la página deja de esperar indefinidamente y muestra cómo volver a cargarlo. La prueba forzó un archivo ausente y comprobó que el guardado se conserva y vuelve a abrirse.

## Conservación y límites

- Mismo esquema de guardado v21 y base de datos v3; no se reinician carreras.
- La cabeza del bateador 0.8.6 conserva SHA256 c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f.
- Se usa el cabello ilustrado existente con transformaciones del renderizador; no se presenta como arte recuperado del original.
- El ajuste nuevo se aplica a HeroHead (creador, HOME y retratos); el bateador conserva su renderizador aprobado y casco.
- Se mantienen los cuatro sonidos aislados del usuario. No se añaden voces de narradores.
- Los nombres elegidos por jugadores se conservan en el idioma en que los escribieron.
- Prueba física con un amigo pendiente; las sesiones automáticas independientes no la sustituyen.
- Copia de base de datos en el volumen de Railway; no es una copia externa al proveedor.

## Pruebas

- 29 pruebas del servidor; 7 pruebas de la web repetidas con los mensajes finales.
- Registro completo en Chrome sin invitación, nivel 1 y liga ROOKIE, creación, cancelación/guardado del borrador, recarga y primera partida.
- Las 64 combinaciones de cabeza y peinado, giros, tres colores y vistas previas que no mutan el guardado.
- Habilidades, bloqueos, recompensas, resultados y postemporada completa.
- Carga fallida simulada: aviso en inglés, misma partida antes/después y recuperación mediante recarga.
- Auditoría de literales de fuentes; es una búsqueda de restos de español, no prueba de traducción humana perfecta.

Muestra de rendimiento local (no representa todas las computadoras):

```json
{
  "frames": 2707,
  "pitches": 6,
  "over50": 1,
  "target": 60,
  "max": 123,
  "fps": 59.926503143540245,
  "elapsed": 45172,
  "game": {
    "phase": "SIMULATION",
    "batter": "Carlos",
    "advances": 16,
    "inning": 4,
    "advanceMax": 2
  },
  "p95": 25
}
```
