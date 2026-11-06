# Baseball Heroes 1.0.49

MatchIntroScreen añade vuelo con estela, aparición de BASEBALL, emblema orbital y salida de pelota hacia cámara con barrido blanco. Conserva el emblema y las grabaciones. La confirmación y el audio de introducción arrancan desde el primer frame en escena. SKIP, Enter, BACK y retirada cancelan canales y trabajos pendientes; el callback sólo puede ocurrir una vez.

GameResultPanel espera al primer frame para su fanfarria. Hoja lateral de 650–1070 ms; rótulo desde 1380 ms; premios activos escalonados desde 2800 ms; conteo final y confeti acompasados con la grabación completa de victoria. Los premios no ganados permanecen grises. Los avisos especiales, nivel y bate agotado esperan al final y siguen su orden. La navegación intencional completa los contadores visuales sin volver a otorgar recompensas. Empates sin sonido falso de derrota. El sonido de derrota continúa siendo una recreación; la referencia no contiene una muestra aislada.

Dos archivos de producción modificados. Sin cambios en arte o audio fuente, core, game, model, servidor, esquema o reinicio. Tres suites locales: presentación, recorrido público y partido de nueve entradas; una suite pública en Railway. Verificados 238 hashes remotos, respaldo íntegro, perfiles y guardados preservados. Sólo se retiró la cuenta sintética. Biblioteca 1.0.48 retenida para rollback; biblioteca inactiva 1.0.47 archivada localmente con hashes verificados.

result-opening.mp4 es una captura de 140 cuadros reales con reloj controlado a 20 fps y la fanfarria original. Es una demostración, no una medición de rendimiento.

Build 3d8d50c0c5bd12a3; SWF 4664a893412e442f662f8fce022e5635f437fbe19eb405007b84ba9fb2b59a89.
