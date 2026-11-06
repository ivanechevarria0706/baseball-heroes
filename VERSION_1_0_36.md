# Baseball Heroes 1.0.36 · Estilo de personajes corregido

Publicada y comprobada en Railway.

Ohtani y Judge usan el PNG aprobado por el usuario, copiado byte a byte en assets/reference/v1036/approved-ohtani-judge.png. Sin generación, retoque, recolor, espejo o recomposición. Se muestran ventanas nativas del mismo dibujo, tanto completas como para retratos.

Otros diez personajes completos creados con la herramienta integrada image_gen a partir de las dos referencias del usuario. Tres atlas nuevos con contornos gruesos, ojos grandes, cuerpo compacto y sombreado sencillo. Prompts y procedencia en assets/reference/v1036/provenance.json, orden y ventanas en manifest.json. Se midieron recortes independientes de la cuadrícula para conservar zapatos, gorras y bates completos. Los PNG conservan sus bytes originales.

Se reemplazan los atlas semirrealistas/cuerpo de 1.0.35 en MLBPlayerArtwork. Una imagen completa por jugador; sin pegar cabezas a cuerpos ni alternar poses. La colección sustituye controles de poses por habilidad, Combo y Luck. Autojuego conserva la aparición/desvanecimiento con una ilustración estática que se retira al finalizar. Retratos de CARDS, LINEUP y simulación reutilizan la misma fuente.

Solo tres fuentes cambiadas: MLBPlayerArtwork, MLB2026Collection, TeamSimulationPanel. Catálogo, clases, precios, estadísticas, energía, motores, personaje creado, cabeza aprobada 0.8.6, web/servidor, audio y assets externos conservados.

Dos suites locales: mlb-local.json (WebMain real, registro, creación, confirmación/cancelación, entrega, activación, LINEUP y persistencia) y art-local.json (doce ilustraciones completas, texto, píxeles nativos de PNG aprobado y generados, callbacks retirados y presentación en autojuego). El diagnóstico no se publica. Se comprobó copia SQLite y se archivó la biblioteca antigua 1.0.30 con hashes, preservando las recientes. Sin reinicios de datos.

Build 67fdb11b154d1a04; SWF SHA256 c328ccb0979c2b63f3a5d7f772331304309fcd7d0c002446fab28dc4c938c48f. Guardado v24, SQLite v4. Son doce poses de presentación estáticas, no una nueva animación completa de bateo.
