# Revisión 0.4.7 — audio del gameplay F.A.F.

Fuente: `Baseball Heroes - Facebook - Juegos F.A.F..mp4`, aportado por el usuario. Duración medida 603,04 s, 1280×720, 25 fps. El archivo original no se modifica ni se sube a ningún servicio. No se ha determinado la fecha histórica de esta grabación.

## Entrega

`reference_audio/faf/ESCUCHAR.html` permite escuchar individualmente 13 recortes. Cada uno incluye MP3 para reproducción, WAV estéreo para edición y tiempos de origen en `manifest.json`. El manifiesto registra también hash del original, hash de cada MP3, duración y niveles de pico/RMS.

Tres efectos cortos están integrados en el partido:

| Acción | Origen | Uso |
|---|---|---|
| Lanzamiento | 382,89–383,16 s | Al soltar la pelota |
| Swing fallado | 376,27–376,62 s | Al resolver un swing que no resulta GOOD/PERFECT; también usado provisionalmente en foul |
| Contacto / NICE | 383,34–384,02 s | Al resolver GOOD/PERFECT, sin duplicar el swing anterior |

Se precargan una vez al entrar al partido y se reutilizan para evitar cargar un MP3 desde disco en cada lanzamiento. Utilizan el volumen de efectos del mezclador existente. Si un recurso falta o todavía no está listo, el juego continúa sin bloquearse. No se disparan al ignorar una tecla fuera de la fase de vuelo. Un lanzamiento dejado pasar solo reproduce la salida de pelota. El recorte de contacto puede contener el acento de NICE: no se presenta como un golpe de bate aislado.

Los otros diez recortes permanecen fuera de la reproducción automática del partido. Ocho son candidatos para strike, single, double, transiciones, simulación y fly out. Dos —home run y victoria— contienen comentario evidente del autor y sirven como referencia. No se han sustituido las pistas anteriores por estas mezclas.

## Calidad y límites

La revisión combina fotogramas, forma de onda y detección automática de voz. El entorno no permitió una escucha directa del asistente; la revisión auditiva humana está pendiente. Una pausa de transcripción no demuestra ausencia de voz. Se encontró comentario durante buena parte del video, y el segundo análisis de los tramos aparentemente silenciosos dio resultados inciertos. Por eso no se declara que todos estos archivos sean efectos limpios.

El tratamiento es solo recorte, conversión a 44,1 kHz estéreo y fades de 3/12 ms para suavizar los bordes. No se aplicó separación de fuentes, eliminación de voz ni normalización que amplifique el ruido. Algunos candidatos largos alcanzan 0 dBFS en la grabación original; una reducción de volumen no restauraría esa información. La intro y la despedida del canal no se incorporan.

No es un banco completo del juego: esta partida no ofrece todos los avisos y algunos están mezclados con voz. Faltan muestras verificadas de foul, ball, ponche, triple, habilidades, tienda y otros resultados. La página de escucha conserva la distinción entre integrado, candidato y mezclado.

## Observaciones visuales útiles

- 02:20: la ventana de ranuras muestra 1.000 monedas para la segunda, apoyando el precio aplicado en 0.4.6.
- 02:40: aparece UNSTARTABLE BATTER con SKIP/AUTO SORT cuando hay un jugador que no puede participar. No basta con representar siempre una alineación válida.
- 06:15–06:18: la salida de pelota, el swing adelantado y el aviso STRIKE son momentos separados. Las capturas a intervalos de 160 ms sirven para afinar su sincronización.
- 06:23,6: NICE aparece todavía sobre el campo; la cámara de seguimiento entra después, alrededor de 06:24,8. El remake aún debe reproducir mejor esa pausa.
- 06:27 y 06:53: TWO BASE HIT y ONE BASE HIT usan una composición de dianas, flechas y salpicaduras. Los rótulos actuales del remake siguen siendo aproximados.
- 04:02: el home run pasa por una secuencia de aves antes de la celebración. No se ha añadido como una animación genérica a todos los hits.
- 04:40: YOU WIN se superpone a la tarjeta de resultados mientras se entregan recompensas y caen confetis.
- 08:20: visitar otro equipo permite recoger recursos; también se ve un estadio distinto. Falta verificar las reglas completas de visita y energía.

Las observaciones proceden de un muestreo general cada 20 segundos y secuencias detalladas de bateo, simulación y resultados. No se afirma haber visionado y escuchado íntegramente el video.

## Verificación

- Compilación de Main, AudioSmoke y VisualSmoke.
- `tests/AudioSmoke.as`: seis reproducciones de los sonidos precargados crean canal, respetan silencio y emiten SOUND_COMPLETE; se comprueba la reutilización del efecto de lanzamiento.
- `tests/VisualSmoke.as`: ejecución de partido, salida de pelota, swing y transición a bateo en dos estadios, con identidad de guardado separada.
- Decodificación de los 13 MP3, verificación de duración y comparación de copias integradas.

Los informes están en `build/qa/`. El identificador y formato de guardado del juego se conservan.
