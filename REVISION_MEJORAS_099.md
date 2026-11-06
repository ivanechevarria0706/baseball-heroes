# Cabello y creador · 0.9.9

11 de octubre de 2026.

## El flequillo cae sobre el rostro

La referencia muestra un volumen redondo y un flequillo que cubre la frente y parte de un ojo. Se reconstruyó Volume como un sprite separado, con laterales más largos y una caída más profunda. Las gafas ahora se dibujan detrás del pelo; los cascos siguen por delante.

## Caída y ajuste en las ocho cabezas

Shaggy, Devilock, Messy y Slick conservan sus ilustraciones y ajustan la profundidad del flequillo. Las raíces siguen el ancho de sienes de cada cabeza. Crew Cut, Cornrows y Slicked-Back conservan la frente descubierta. Solo Volume tiene un sprite nuevo.

## Selección y continuidad del personaje

La paleta de color se coloca sobre el personaje, Random pasa debajo de la vista previa, los recuadros tienen fondo gris y EQUIPPED aparece en una insignia azul. BACK descarta el borrador; SELECT lo guarda. El peinado elegido se conserva en HOME y después de recargar.

## Conservación y procedencia

- Arte nuevo generado con la herramienta integrada; [sprite y prompt](assets/sprites/v099/README.md). La primera propuesta de atlas no se integró porque repetía el peinado demasiado alto.
- Se conserva el atlas v083 usado por el bateador y el código exacto de BatterHead086 (SHA256 c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f).
- El ajuste se aplica a HeroHead: creador, HOME, retratos y actores que usan ese renderizador. Se conserva la excepción del bateador aprobada por el usuario.
- No cambian el modelo, las reglas, el esquema v21, las cuentas, la base v3 ni las fórmulas de los partidos.
- Interfaz del juego en inglés y nombres de jugadores conservados. No se añaden audios con narrador.
- El sprite se normaliza una sola vez a 400×392 antes de recolorear; el caché mantiene un máximo de 24 estilos/colores. No se recolorea la imagen grande en cada cuadro.
- Copia de seguridad antes de publicar en /data/backups, en el mismo volumen de Railway; no es copia externa al proveedor.

## Pruebas de esta actualización

- Compilación final de WebMain, WebAppearance099 y WebPerformance.
- 64 combinaciones de cabeza/peinado, frente y giro de 60°, tres colores; presencia de píxeles opacos y flequillo sobre el párpado en Volume.
- Las seis pestañas del creador; 5 colores de piel, 10 de pelo y 8 de ojos; vista previa sin mutar el guardado.
- Flujo completo real en Chrome: cuenta nueva sin invitación, nivel 1 ROOKIE, equipo, borrador cancelado, peinado guardado, llegada, HOME, metas, viaje, alineación y primer partido. Recarga y nuevo inicio de sesión conservan la carrera.
- La lógica del servidor y del guardado es idéntica a 0.9.8; las pruebas anteriores no se presentan como pruebas repetidas en esta versión.

## Diferencias visibles que aún quedan

- Selector femenino con cuerpo, cabeza y poses coherentes; no basta añadir un botón.
- Más colores en la paleta; se conservan los identificadores guardados actuales.
- Más cuadros de animación y más fidelidad del arte general. La ilustración reconstruida no es idéntica al recurso original.
- Prueba de amigos en dos computadoras físicas pendiente.

## Muestra final de rendimiento local

```json
{
  "frames": 2706,
  "pitches": 6,
  "over50": 1,
  "target": 60,
  "max": 51,
  "fps": 59.99733936410802,
  "elapsed": 45102,
  "game": {
    "phase": "SIMULATION",
    "batter": "Julia",
    "advances": 12,
    "inning": 4,
    "advanceMax": 1
  },
  "p95": 25
}
```
