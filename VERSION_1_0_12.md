# Baseball Heroes 1.0.12 — marco del partido y autojuego

La presentación del autojuego se ajusta a los cuadros de `videoplayback (4).mp4` de 03:20: tablero visitante rojo arriba, local azul abajo, cabecera rival gris y nombres sobre placas con relieve. Se conserva el ritmo y las reglas de partido.

- **Recursos compartidos:** bateo y autojuego utilizan el mismo componente, con estrella de nivel, barra de XP, rayo y energía, moneda Coins y Hero Coins. Los valores de jugadas pendientes se muestran sin cobrarlos otra vez. El formato separa miles y ajusta cifras largas.
- **Barras reales:** el relleno azul refleja el progreso dentro del nivel; el verde, la energía disponible. La energía actualiza su texto y relleno cada segundo mediante el reloj existente. Los indicadores se dibujan al construirlos y no agregan cálculos por fotograma. El componente detiene su reloj y libera el logo al salir.
- **Marcador:** visitante encima del local, con sus carreras y hits conservados. El foco de entrada sigue a la fila correcta, también en entradas extra. Las letras R/H y el color amarillo del total local se mantienen.
- **Alineación del autojuego:** cabecera local azul y rival gris, como en la referencia. Placas con degradado; el bateador activo recibe la placa azul y el héroe conserva el nombre dorado cuando le toca esperar. Se conservan retratos y filas al cambiar de bateador.
- **Resultados:** 1 BASE HIT, 2 BASE HIT y OUT utilizan letras más condensadas, contornos y el mismo movimiento. No se cambia cuánto dura el turno ni se añade audio del narrador.
- **Clase de cartas:** las cartas generadas muestran C/B/A/S sobre una insignia de contraste con tipografía incrustada, tanto en la colección como al activarse durante el partido. Las imágenes observadas que ya contienen su insignia la conservan.

Es una reconstrucción visual, no una recuperación de las fuentes ni de los sprites originales. La barra azul usa la curva local ya existente. No se han cambiado fórmulas, costos, probabilidades, pichadas, consumo de energía, datos guardados ni el servidor. Se mantienen guardado v24, SQLite v4, la cabeza aprobada 0.8.6 y las cuentas existentes.

## Verificación

Tres suites locales de Chrome: valores y geometría del marco compartido, marcador/entradas extra, nombres y tamaños, reconfiguración/liberación, clase de cartas y saldos largos; WebMain público con LINEUP, CHARGE, energía y reentrada; partido completo con pausa, resultados y liquidación única. Capturas e informes en `build/qa/release1012`. La publicación y las comprobaciones HTTPS se registran al terminar en `deployment_status.json`.

Publicada y comprobada en HTTPS: build `d4a02e1d31a4f12a`. Dos suites con cuentas sintéticas nuevas: registro/creador/guardado y LINEUP/energía/partido pendiente. 138 archivos publicados coinciden con el paquete probado; las herramientas de prueba no están expuestas. Copia SQLite íntegra en el volumen; solo se retiraron las dos identidades QA utilizadas.
