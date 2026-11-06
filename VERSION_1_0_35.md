# Baseball Heroes 1.0.35 · Colección 2026

Publicada y comprobada en Railway.

Doce cartas nuevas y cuerpos modulares propios. Acceso HOME → TEAM → CARDS → 2026. Investigación: 1512 registros de temporada en research/mlb2026/players-2026.csv; los 12 bateadores de prueba usan un snapshot oficial fechado 2026-10-24. Clases de bateo mediante percentiles OPS (407 jugadores con PA ≥150), grado NORMAL independiente. Power/Contact/Speed se convierten por las fórmulas de assets/reference/v1035/players-2026.json, Luck neutral 60. Son ratings locales; no fórmulas oficiales ni valoración defensiva.

Caras ilustradas a partir de referencias privadas, tres atlas. Cuerpo original con mangas cerradas y cuatro poses. Las poses se ajustan completas al cuadro y se reflejan para zurdos. Se utilizan en colección y presentación de cartas de autojuego; no sustituyen las animaciones del héroe creado. Sprites también integrados en CARDS, retratos de LINEUP y filas de autojuego. PNG originales conservados; prompts y referencias en assets/reference/v1035/provenance.json. Las fotografías no se publican.

Reclutamiento directo con confirmación/cancelación, coste por clase y liga, protección del tutorial y partido pendiente. Un ejemplar directo por jugador; sobres existentes pueden entregar duplicados. Entrega mediante finishSpecialDraw y SpecialCardInventory, con dos cargas y recuperación de una cada tres horas. Se amplía el pool NORMAL de cada clase, preservando los pesos de grados y cartas anteriores. Se conserva el guardado v24, resetEpoch, SQLite v4, cuentas, personaje y equipo elegido.

Pruebas: build/qa/release1035/mlb-local.json y catalog-local.json. WebMain real sin hooks privados; diagnóstico externo para todos los bloqueos, poses, callbacks retirados, ciclo de energía y presentación de autojuego. La inicialización existente de condición y de habilidades rank0 al cargar se comprueba por separado de los atributos del héroe. Preflight verifica las nueve fuentes modificadas/agregadas y los archivos publicados, sin cambios a los sprites aprobados de cabeza, web, servidor, audio o recursos externos.

Publicación: 3202ff7b553bf7c0 / SWF SHA256 eaf6e3d6196af34692ecb2c15b0e4a88a9e1fb2e3fe88051aafc7523b4dfb668. Se verificó copia de SQLite y se archivó la biblioteca antigua 1.0.29 con hashes, preservando 1.0.34/1.0.33/1.0.32. No se reinician datos. La prueba entre dos computadoras físicas sigue pendiente.

Limitaciones: piloto de 12 bateadores, sin todos los jugadores del CSV, sin lanzadores integrados, sin animación completa de 12–16 cuadros, sin actualización automática de plantillas ni valoración de defensa. Marcas y licencias de jugadores no se conceden por crear arte propio.
