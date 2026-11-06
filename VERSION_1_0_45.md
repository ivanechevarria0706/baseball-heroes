# Baseball Heroes 1.0.45

Publicado y comprobado en Railway. 21 WAV del ZIP aportado se conservan sin modificar en reference_audio/v1045. Se generan 28 fragmentos activos, con dos extracciones adicionales del video proporcionado (atrapada y Base on Balls). Los silencios previos de hasta 12 segundos se eliminan antes del ajuste de ganancia y de los fades; cada recorte indica fuente, SHA256 y tiempos en assets/audio/v1045/manifest.json. Ningún WAV fuente se sobrescribe.

OriginalAudioBank incorpora los MP3 en el SWF para evitar cargas de disco al impactar. RebuiltAudioBank y GameplayAudio resuelven primero los originales conocidos y conservan fallbacks explícitos. Single/Triple/derrota no se reclasifican como recuperados. Hit/Out automáticos previos siguen activos; las viejas grabaciones con narrador continúan bloqueadas.

AudioCueSequence.stopAll cancela cola y canales de escena. Calendario, viaje aéreo, LINE UP, selección, introducción, equipos, turno del héroe, bases llenas, pichada, swing, impactos, vuelo, rebotes, Out, Double, Home Run/Grand Slam y victoria usan sus eventos correspondientes. La entrada de partido se sincroniza con la fanfarria (3,9s). Ball/Strike se separan del pop de atrapada; Home Run/Grand Slam esperan el rótulo del resultado. Saltar no duplica la fanfarria y dispose libera los sonidos. Clic de botón con límite de duplicados de 65ms. Mute y ganancia global se aplican a los clips nuevos.

Tres suites locales con Chrome y recorrido de la compilación pública. 28 decodificaciones con límites de pico/RMS y silencio inicial, selección de banco original, colas/cancelación, fases de cine y escenas, compra/guardado/alineación/entrada, partido completo de nueve entradas y estadísticas conciliadas. Sin cambios en fórmulas, velocidad de pichada Rookie, ventanas de contacto, sprites, identidad ni formato de guardado. Servidor y perfiles conservados; respaldo SQLite consistente y comparación dentro del servidor. Sólo se elimina la cuenta QA. Paquete de 242 archivos auditado y diagnósticos privados excluidos. Biblioteca 1.0.44 disponible para rollback.

Build 046ab49dd7d3f7eb; SWF c533439588a272fd1bc78ddaae469bedfd8b742c2b8a1c68406bae2eb1c60e88.
