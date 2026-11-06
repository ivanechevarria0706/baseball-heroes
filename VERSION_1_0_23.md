# Baseball Heroes 1.0.23 · metas de temporada

**Publicada y comprobada por HTTPS.** La 1.0.23 ya está disponible. Incluye las mejoras de sprites que habían quedado pendientes de 1.0.19 a 1.0.22. Railway reactivó los despliegues y se renovó automáticamente la sesión oficial.

## Cambios y referencia

Reconstrucción de la composición de `reference_visual/initial_audit_20261015/frame-0104.jpg` y `frame-0107.jpg`: marco de papel claro, encabezado inclinado, insignia de la liga actual, entrenador señalando, globo en español y rodillos de metal con luces. Los textos usan fuentes sustitutas incrustadas. Se mantiene SPIN AGAIN como función existente del remake.

Solo cambian SeasonGoalScreen y la nueva SeasonGoalArtwork respecto a 1.0.22. El modelo GameData, las tablas de metas y de recompensas, web, servidor, audio, guardado v24 y cabeza 0.8.6 se conservan. Los cuatro fragmentos de textura del entrenador suman 6,294,240 bytes y se comparten entre entradas de pantalla. No queda un listener de animación al acabar el giro.

## Arte, herramienta y prompt

Se usó image_gen integrado. Es una reconstrucción de la pose, no un sprite original recuperado. El archivo generado se copió sin cambios y conserva transparencia alfa. Python solo comprobó tamaño y alfa.

- [Sprite final](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1023/goal-coach.png>)
- [Prompt completo, herramienta y referencias](<C:/Users/ivane/Documents/Baseball Heroes/baseball_heroes_remake_phase8Y_result_match_presentation/assets/reference/v1023/provenance.json>)

## Pruebas

Chrome con WebMain real: registro sin invitación, nivel 1, Rookie, 6,000 Coins y sin lentes; confirmación de equipo y personaje; misma carrera antes/después; entrada y recarga sin sortear nuevas metas; tres clics rápidos provocan una sola escritura; rangos HIT/HR/RBI preservados; ACCEPT y recarga conservan el resultado y continúan al calendario; aceptación durante un giro; misma identidad y recursos. Sin errores JavaScript o AVM2 detectados. Se fijaron 70 HIT/55 RBI solo en la cuenta QA para la comparación.

Build `f32fbd765fa865e4`, SHA256 `80a475096297b35b7df895dc4848a9f669ea7481696dc6ab4b91450195db08c3`, 33,349,797 bytes. Paquete de 147 archivos y biblioteca `976669b537299c2c43da5a8a6a1638b1b36f389c705aea3cd5f289654f609159`, 114 archivos verificados. Los 113 recursos idénticos se enlazan con la biblioteca existente en el mismo volumen, conservando versiones anteriores.

## Publicación

Railway anunció el 22 de octubre a las 22:49 UTC la reactivación de todos los planes. El primer envío devolvió HTTP 401; la sesión oficial se renovó con su refresh token sin imprimir credenciales. El segundo envío fue aceptado como despliegue `b4ebaa21-3163-4b5c-96e7-03fa89b1df73`. La copia SQLite previa tiene integridad correcta. No se borran cuentas ni partidas.

Cuatro recorridos HTTPS aprobados: metas, inventario, BUILD y misiones/trofeos. Los 143 archivos instalados coinciden con el paquete. Las cuatro cuentas QA se retiraron y las cuentas anteriores se conservaron.

Incluye las mejoras pendientes de 1.0.19–1.0.22. La prueba física entre dos computadoras de amigos sigue sin realizarse. [Comparación](COMPARACION_MEJORAS_1023.html).
