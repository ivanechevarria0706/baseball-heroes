# Baseball Heroes — sonidos del usuario 0.5.3

Integración de los cuatro archivos de Audacity proporcionados por el usuario. Esta selección reemplaza la anterior del out F.A.F.

| Archivo original | Uso en el juego | Duración del WAV |
| --- | --- | --- |
| batzo del heroe.wav | Contacto del bate con la pelota, incluidos fouls y pelotas que terminan en out. También contacto válido en Derby. | 1.860 s |
| hit autoplay.wav | Single, doble, triple y home run de simulación. | 0.711 s |
| out en autoplay.wav | Out de simulación, en lugar del recorte F.A.F. previo. | 0.358 s |
| strike.wav | Swing fallado o strike cantado, incluido el tercer strike, una vez al resolver el lanzamiento. | 0.847 s |

No se reproduce el hit de autoplay al recibir una base por bolas. El batazo no se reproduce en un swing sin contacto. Derby conserva sus avisos de timing; usa el batazo cuando se produce contacto, sin añadir un anuncio de strike a ese modo.

## Mejoras de sincronización

- Los cuatro efectos están incluidos en el SWF y se preparan al construir la escena, evitando solicitar un archivo del disco justo al batear.
- La pausa de cada resultado simulado es, como mínimo, la duración del efecto decodificado más 40 ms. La pausa normal de la velocidad seleccionada y la pausa de carta especial se mantienen si son mayores. En x4, por tanto, algunas jugadas duran más que antes para que los efectos de resultados consecutivos no se pisen.
- Cambiar el volumen de efectos actualiza también los canales que ya suenan, conservando la ganancia individual. Ponerlo en cero silencia inmediatamente los efectos activos.
- La introducción PLAY BALL utiliza el efecto de transición existente; ya no depende del antiguo archivo de hit eliminado de la carpeta activa.

Los sonidos de celebraciones, combo y transiciones que ya tenía el proyecto se conservan. No se han añadido otros recortes F.A.F.

## Archivos y verificación

Los cuatro WAV originales se copiaron sin modificar a `reference_audio/user_v053/`. Se convirtieron a MP3 estéreo de 44.1 kHz y 192 kbps, sin recortar, normalizar, eliminar ruido ni aplicar fundidos. El manifiesto de esa carpeta contiene las duraciones y hashes de originales y conversiones. Los efectos reemplazados se conservaron como referencia; los originales de Audacity permanecen intactos.

- `UserAudioSmoke`: duración decodificada de cada clip, ocho reproducciones completas, volumen y silencio en vivo con ganancia individual, clasificación de hits/outs y exclusión de WALK.
- `SimulationPanelSmoke`: pausas suficientes para los nuevos hits/outs, WALK sin pausa heredada de audio y regresión de las alineaciones, marcador, velocidades y transiciones.
- `ContactSmoke`: SPACE, contacto, NICE y pausa de cámara protegida frente a pulsaciones repetidas.
- `InningFlowSmoke`: apariciones manuales, retorno automático, terceros outs y siguiente turno del héroe.
- `DerbySmoke`: secuencia de diez lanzamientos, swings, final y recompensa con una identidad de prueba separada.

Registros actuales en `build/qa/smoke-user-audio.txt`, `smoke-user-audio-assets.txt`, `smoke-simulation-panel.txt`, `smoke-contact.txt`, `smoke-inning-flow.txt` y `smoke-derby.txt`. Las comprobaciones de audio son técnicas; no constituyen una evaluación auditiva de la limpieza de las grabaciones.

Se mantiene la identidad de aplicación y el formato de guardado de tu partida. Abre `JUGAR.bat`; la copia completa está en `Baseball_Heroes_sonidos_v053.zip`, en la carpeta superior. El arte y las reglas siguen siendo una reconstrucción, no una recuperación del juego original.
