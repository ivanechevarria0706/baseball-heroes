# Baseball Heroes 1.0.24 · calendario ilustrado

**Publicada y comprobada por HTTPS.** Los recorridos de calendario y metas pasaron también en la web pública. Las dos cuentas QA temporales se retiraron; las cuentas anteriores se conservaron.

## Cambios

- Franja azul/dorada de enfrentamiento, inspirada en `reference_visual/initial_audit_20261015/frame-0115.jpg`: héroe confirmado, rival CPU, retratos, escudos, récord de temporada y número de partido o resultado conocido. No se inventa un récord del rival.
- Se reutilizan HeroSprite, HeroHead y TeamLogoView. El retrato CPU comparte la misma apariencia de su figura. El encuadre se calcula con los límites reales del actor y deja completos los peinados altos.
- Tarjetas con sombra, borde e indicadores de marcador encajados. Las de Rookie usan el fondo ámbar observado. Se mantienen cinco tarjetas, los treinta marcadores y los estados WIN/LOSE/NEXT MATCH/SPECIAL/RIVAL.
- Los botones se agrupan abajo para dejar espacio a la franja; LINE UP conserva su ubicación y su callback. El detalle se compacta y conserva ascenso, postemporada y aviso de que consultar otro encuentro no cambia el siguiente partido.

Solo cambian SeasonRoadmapScreen y la nueva SeasonMatchBanner respecto a 1.0.23. No se añaden PNG, catálogos ni fórmulas. Se conservan el modelo, servidor, web, audio, guardado v24, identidad confirmada y cabeza de bateo 0.8.6. Las imágenes y fuentes actuales siguen siendo una mezcla de material recuperado y reconstrucciones; no se afirma paridad exacta con el original.

## Pruebas

Dos recorridos locales en Chrome con WebMain real. El calendario recorre los treinta partidos y verifica su fondo al entrar por PLAY BALL, para evitar confundir el acceso directo a LINEUP con el calendario. Misma carrera antes/después, nivel 1/Rookie/6,000 Coins/sin lentes, límites de página, eventos 12/28/30, RECORD y HOME, recarga, historial WIN/LOSS con y sin marcador, fin de temporada y ascenso. Las situaciones de historial y ascenso se fijan solo en la cuenta QA.

Consultar el partido 30 no salta el encuentro 4 de esa cuenta. El viaje hasta LINEUP no descuenta energía; el partido real descuenta cinco y conserva identidad y Coins. La segunda prueba comprueba metas HIT/HR, una escritura tras tres clics rápidos, aceptación durante un giro, recarga y continuación al calendario. No se detectaron errores JavaScript o AVM2 en los recorridos finales.

Los dos recorridos también pasaron por HTTPS. Se verificaron los 143 archivos instalados, el audio permitido y SQLite; se retiraron las dos cuentas QA y se preservaron las anteriores.

## Paquete

Build `4d09e15ab5f4ef7a`, SHA256 `1203dd3b8184188cc63734d582dd529ffa8d9c665b0f85d384b03861329d14ad`, 33,351,427 bytes. Biblioteca `c9abd4eb5adb292fbeb0579c56d4149fd929490d2ed093afd1af9008966e715a` con 114 archivos verificados; 113 recursos idénticos enlazados en el mismo volumen. Paquete de 147 archivos. Copia SQLite previa comprobada, sin reinicios de cuentas.

El primer despliegue `bc82a97c-c9a1-4ccc-8d84-170faf41ac31` reportó SUCCESS pero el contenedor y HTTPS seguían en 1.0.23. No se consideró publicado. Se auditó por completo el tar enviado y se conservaron las fechas de origen de los archivos como hace el cargador oficial. La causa de la reutilización anterior no está confirmada. La compilación final se verifica por versión y hash, sin confiar únicamente en el estado de Railway.

[Comparación](COMPARACION_MEJORAS_1024.html). Sigue pendiente la prueba física de amigos en dos computadoras.
