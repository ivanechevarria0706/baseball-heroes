# Baseball Heroes 1.0.59

Se preservan ilustraciones, sprites, audio, modelos, economía, tiempos de swing y PitchCadence. Se modifican siete clases de presentación/integración y se añade StadiumAtmosphere. El héroe aprobado se conserva.

Pitcher usa sólo poses de carrera durante el desplazamiento, preparación de defensa, recuperación de 680 ms sin modificar la liberación ni el calendario de lanzamientos, y fija la transformación en releasePosition para que el origen no dependa del último fotograma renderizado. HitCinematic ya no reinicializa la posición al atrapar. ClassicBatter evita la pose READY entre follow-through y reacción. RunnerSprite añade balanceo conjunto, sombra y siete puffs retenidos para la llegada. HitFlightBackdrop enlaza las cámaras durante 240 ms con el reloj de la cinemática.

StadiumAtmosphere vive fuera de la caché del fondo y se crea al recibir un estado de partido. Sin listeners propios. Público y banderines reutilizan poses; sólo se actualizan cada 100 ms visibles. Se pausa su reloj cuando la vista está oculta o el autojuego está pausado. El tablero básico muestra score, entrada y bateador; se respeta el tablero comprado en BUILD. HOME y menús no cargan el nuevo módulo.

Referencia: Baseball Heroes.mp4 00:54–01:00 y reference_visual/v054/faf-ready.png. Público, banderines y marcador vivo son añadidos reconstruidos, no arte original recuperado.

Pruebas: escenas en Chrome, invariancia del punto de liberación, disposición de actores; Game completo de nueve entradas con resumen reconciliado y avance único; WebMain final local y publicado con registro Rookie, compra, sustitución, persistencia y entrada al partido. Sin errores de navegador. La prueba completa registró p95 de 42 ms en esta máquina; no demuestra 60 fps constantes ni equivale a una medición en la computadora del usuario.

No se reinician datos. Save24, SQLite4 y reset38 conservados. Paquete y datos previos cotejados al publicar. Biblioteca58 retenida para recuperación;57 archivada localmente con hashes verificados.

Build 53fcf749dd631643; SWF 597c8033291b6ed4a4f63156939f2c0f0d229f77b83bfad61c20d0d8383af268.
