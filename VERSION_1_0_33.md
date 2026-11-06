# Baseball Heroes 1.0.33 · habilidades ilustradas

**Publicada y comprobada por HTTPS.** La cuenta QA se retiró y se conservaron las cuentas anteriores.

## Alcance

Dos clases: SkillScreen y la nueva SkillArtwork. Doce sprites sustituyen las letras P/C/T/L. Fichas con ClassicChrome, estrellas de rango, emblema ampliado, efecto actual/siguiente, franja de habilidad activa, MatchResourceBar y botones con estados reales. Consejos y requisitos en español; nombres y controles en inglés. El código del héroe y la cabeza aprobada 0.8.6 no cambian.

Solo GameData.upgradeSkill y setActiveSkill modifican puntos, rangos o selección activa. Costes del catálogo conservados: 1/1/2 para los tres rangos. Las compras se desactivan con requisitos o puntos insuficientes y al máximo. ACTIVATE solo se habilita para habilidades aprendidas distintas de la activa. Un guard de 300 ms evita repetir una mutación por doble clic mientras se reconstruyen los controles. Seleccionar una ficha es una consulta. Las imágenes propias y listeners se liberan al renovar o cerrar; el medallón compartido de AchievementArtwork usa su caché existente y se retira del árbol sin invocar métodos que no posee.

## Arte y procedencia

Un PNG nuevo: assets/reference/v1033/skills.png, generado con la herramienta integrada image_gen, transparencia real y doce ventanas. Prompt completo: assets/reference/v1033/provenance.json. Hash y coordenadas: assets/reference/v1033/manifest.json. El PNG se copió sin editar sus bytes. Es arte reconstruido para el remake; no se afirma que los iconos ni las doce habilidades sean una recuperación del árbol del original. El catálogo ya existente contiene reconstrucciones del remake y no se modifica.

SkillArtwork copia las doce ventanas una vez, conserva sus bitmaps compartidos y descarta el atlas expandido. Cada variante gris se prepara con dos copyChannel nativos desde GREEN a RED/BLUE y conserva su alpha; evita filtros GPU y operaciones de píxeles por fotograma. No se edita el PNG para crear esos estados. No se afirma una mejora general de FPS.

## Verificación

Dos suites locales de Chrome. WebMain de producción sin instrumentación: registro, personaje y libro desde TEAM. La cuenta nueva conserva nivel 1/Rookie/6,000 Coins/cero puntos/sin lentes y Batting Eye rango 1. Tras ese recorrido se añade un punto solo a la cuenta QA para comprobar LEARN, doble clic y coste único. Se comprueba activación, bloqueo por nivel, falta de puntos, CLOSE, Esc y persistencia. Otra condición QA de nivel 12 comprueba coste de dos puntos al subir de rango 2 a 3, MAX RANK y desbloqueo de Lucky Swing. Se compara roster, equipo, apariencia y recursos completos antes/después, excluyendo únicamente los tres campos de habilidad que la acción modifica. Las condiciones QA avanzadas no se aplican a otras cuentas.

El ejecutable diagnóstico está fuera de web/src y de staging. Comprueba las doce fichas, texto dentro de sus cajas, bloqueos y requisitos previos, rango máximo, muestras RGB grises de los ocho sprites bloqueados en Rookie, primera activación al aprender y controles obsoletos sin efecto después de dispose. bhSkills33 está ausente del ejecutable público. Los recorridos finales no registran errores JS/AVM2.

El mismo recorrido de producción pasó en HTTPS. Los 143 archivos instalados coinciden con el manifiesto; se retiró la cuenta QA y se conservaron todas las cuentas anteriores.

## Publicación y conservación

Build 058f698a6a7619d4; SWF SHA256 3efde5f8955abfd0255d6807f388cb11156580ab4ca017b3aefe52e741a8bc5c; 41,063,324 bytes. Paquete de 147 archivos; biblioteca e24e285cfe6c9c08680351f6ba2941851fc8af35cd85033f9baf8a1ec9ea9730 con 114 archivos y 113 recursos reutilizados mediante enlaces duros. El atlas está embebido en SWF; el digest de recursos externos se conserva. GameData, SkillCatalog, modelos, servidor, web, arte anterior y audio se verifican por hash. Guardado v24, SQLite v4 y resetEpoch conservados, sin reinicio de datos. Copia SQLite previa con integrity_check y SHA256.

Las bibliotecas antiguas 1.0.26 y 1.0.27 se archivaron localmente después de verificar sus 114 archivos locales/remotos. Ejecutables y manifiestos en build/qa/release1033/archived1026-* y archived1027-*. Las versiones 1.0.32 y 1.0.31 se mantienen en Railway. research/restore_archived_library1033.py VERSION reconstruye una biblioteca archivada sin activarla y exige espacio disponible; restaurarla es requisito para reactivar esas versiones antiguas. Bases de datos y respaldos no se eliminan.

[Comparación visual](COMPARACION_MEJORAS_1033.html). La prueba de amigos desde dos computadoras físicas sigue pendiente.
