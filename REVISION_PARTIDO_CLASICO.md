# Baseball Heroes — partido clásico 0.5.4

Reconstrucción visual de la escena completa del partido. La composición 4:3 procede del primer gameplay aportado (640×480); el campo y las poses se contrastaron también con F.A.F. alrededor de 382–384 s y 407.6 s. Las dos grabaciones tienen presentaciones diferentes: esta entrega adapta sus referencias a un marco común, no afirma reproducir exactamente una única versión histórica.

## Cambio visible

- El partido usa 960×720. La ventana lo ajusta con la misma escala horizontal y vertical, y vuelve al marco de los menús al salir. El tamaño inicial es 1024×800, con objetivo de 60 fps durante el partido y 30 fps en los menús; la velocidad efectiva depende del equipo.
- Nueva cámara de estadio: gradas inclinadas, montañas por capas, torres, marcador de fondo, muro, césped con profundidad, montículo, líneas y home ampliado. La ilustración nativa es específica del partido; HOME conserva su escena anterior.
- Los fondos seleccionados, incluido Major, siguen utilizándose. Un terreno de bateo común se superpone a su parte inferior para alinear montículo, home y personajes. Se conservan los colores configurados aplicables y las decoraciones colocadas.
- Bateador más dominante y desplazado hacia la izquierda. Casco redondeado con visor y brillo, bate más ancho, guantes, costuras y franjas de uniforme revisados. El swing ajusta su altura visual a la pelota dentro de un margen limitado; no modifica la evaluación del timing.
- Lanzador y defensores recolocados, con ojos, gorra y uniforme revisados. El lanzador queda sobre el montículo y su nombre aparece encima. La salida de la pelota continúa tomando la posición real de su mano.
- Alineaciones de simulación ampliadas para el marco clásico. Se conservan selección, velocidad, resultados y retorno automático.
- Resultados reencuadrados: el single muestra al héroe, los outs al defensor y los otros hits conservan las ilustraciones locales existentes. Se limita el fondo de efectos al área central y el HUD mantiene visibles recursos, insignia y estadísticas sin fragmentos del marcador.

Los cuatro sonidos de Audacity de 0.5.3 siguen activos. No cambian las fórmulas de contacto, recompensas ni probabilidades de simulación. La zona visible de bateo y las posiciones de lanzamiento se adaptan al nuevo encuadre.

## Verificación

- `ClassicMatchSmoke`: marco 960×720, Rookie y Major, proporciones y límites del bateador, contacto mediante SPACE, resultados y retorno automático; máscara del HUD activa solo en resultados.
- `BatterPoseSmoke`: preparación, carga, contacto, continuación del swing y recuperación; pulsaciones repetidas y liberación de recursos.
- `PitchSceneSmoke`: salida de la pelota desde la mano bajo transformaciones, frames retrasados, trayectorias y efectos a 15/30/60 fps; siete tipos de resultado y avance con Enter.
- `ContactSmoke`: regresión del contacto y la pausa protegida de 1.2 s en el marco anterior de prueba 960×540.
- `InningFlowSmoke`: ciclo 4:3 con dos apariciones manuales, terceros outs, resultados sobre la fila activa y regreso al siguiente turno del héroe.
- `SimulationPanelSmoke`, `UserAudioSmoke` y `DerbySmoke`: estado de alineaciones, sonidos del usuario y secuencia del Derby.

Registros `build/qa/smoke-*.txt`; el manifiesto de esta entrega identifica los actuales. Capturas `build/qa/v054-*.png`. Las pruebas usan identidades de aplicación aisladas de tu partida.

Abre `COMPARACION_PARTIDO.html` para revisar capturas anteriores, actuales y fotogramas de referencia. Abre `JUGAR.bat` para jugar. ZIP completo: `Baseball_Heroes_partido_clasico_v054.zip` en la carpeta superior.

## Alcance pendiente

Este es un salto de composición y dibujo nativo. Aún faltan la fidelidad de las ilustraciones originales, detalles de tipografía y más poses. Los menús y el Derby no se han convertido a 4:3. La validación no equivale a una temporada completa ni a probar todas las combinaciones de equipo y estadio. Se conservan el identificador de aplicación y el formato de guardado.
