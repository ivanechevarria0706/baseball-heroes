# Baseball Heroes 1.0.47

Se retira completamente la vista encuadrada de autojuego de TeamSimulationPanel. El enlazador excluye AutoplayFieldScene y AutoplayFieldArtwork del SWF público. Se conservan los archivos históricos para las comparaciones anteriores. Las tablas recuperan sus posiciones y tamaño; los cambios de lado interpolan durante 320 ms.

Baseball Heroes.mp4 aporta el ritmo: regreso 01:06.5–01:09.4 y héroe 01:18.5–01:21.4, revisados en cuadros cada 125 ms. El regreso usa cue a 240 ms, revelado del estadio a 280–540 ms y entrada de tablas a 620–940 ms. El héroe usa cue a 420 ms, negro completo y revelado a 660–940 ms. La duración de entrada permite la grabación completa; Game espera entryRemaining antes de resolver el primer resultado. La introducción del emblema comienza con el audio a 1720 ms, después de la confirmación.

El sonido de vuelo se programa en Game durante el seguimiento del bat y no se vuelve a disparar al cambiar de cámara. Double y Triple muestran el primer rótulo tras completar el vuelo; Grand Slam extiende su historia antes de la fanfarria. HitCinematic conserva resultSoundUntil y aplica un fundido de salida de 320 ms antes de continuar. El fade se coloca sobre los rótulos agregados dinámicamente. ENTER no duplica efectos ni avanza dos turnos.

AudioCueSequence posee sus canales y colas. Pause guarda SoundChannel.position y reanuda mediante el nuevo argumento opcional offsetMs de AudioManager/GameplayAudio. Se aplica el mismo reloj de escena a los trabajos pendientes; stopAll/dispose también cancelan los suspendidos. Mute, volumen y selección del banco nativo permanecen comprobados. No se modifican los MP3/WAV ni se agregan grabaciones de narrador.

Tres suites locales y recorrido con WebMain final en Railway. Partido completo de nueve entradas, estadísticas conciliadas y avance único; paquete de 242 archivos auditado, 238 hashes publicados comprobados. Servidor, esquema, marcador de reinicio, perfiles y guardados conservados. Sólo se retira la cuenta QA. Se archiva localmente la compilación inicial inactiva de 1.0.46, manteniendo la 1.0.46 final como rollback.

Build 04f98e66679705c3; SWF 9d1acc27a84a6cdb44adf5dcba3de6f7660d496d5cdcaee1daf41deb005ee32c.
