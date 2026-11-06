# Baseball Heroes 1.0.7 — misiones y entrega de premios

Actualización del 15 de octubre de 2026. Conserva cuentas, progreso y cabeza 0.8.6.

1. **Misiones como una ventana clásica.** Cuatro pestañas con iconos: RECORDS, HERO, TEAM y STADIUM. Panel compacto sobre el estadio, entrenador junto a un globo de explicación y recompensa en la parte superior.

2. **Siete misiones accesibles.** Las flechas recorren las misiones de cada categoría. Se muestran el nombre, objetivos, contadores, barras y marcas de cumplimiento. El tutorial permanece en HERO cuando corresponde a esa carrera.

3. **El premio de cada misión.** MISSION COMPLETE toma el nombre, objetivos y recompensa reales del catálogo. Presenta Coins, el punto de habilidad del estadio y la misión de 40,000 Coins del tutorial sin reutilizar el texto fijo de otra misión.

4. **Cobro explícito y una sola vez.** Consultar y usar LATER no cobra. CLAIM vuelve a comprobar los objetivos y el estado de cobro; después indica RECEIVED y permite continuar. Doble clic y recarga no vuelven a pagar.

5. **Progreso conservado.** Se mantienen reglas, importes, guardados y cuentas. El aviso del estadio en BUILD usa la misma presentación y conserva su escala. Menús en inglés y explicaciones en español.

Referencia visual: gameplay explicando_20260924, 14:10 (ventana de misiones) y 18:50 (MISSION COMPLETE). Se reconstruye la composición con el entrenador existente de la hoja del usuario y cuatro iconos nativos; no se presenta como arte recuperado. El botón premium observado de 39 créditos y SHARE COINS no se reproducen: no hay reglas verificadas para completar misiones con moneda premium ni publicación en Facebook.

Guardado v23 / SQLite v4. Modelo, servidor, personajes, audio y motor del partido sin cambios. No hay migración ni reinicio. Capturas: `build/qa/release1007`. Comparación: `COMPARACION_MEJORAS_1007.html`.

Publicación verificada: build `515ac369cd0e249f`. Dos suites locales y una en HTTPS aprobadas. Siete misiones en cuatro categorías, consultas y LATER sin gasto, objetivos y premios correctos, doble clic sin duplicados, punto de habilidad y tutorial, recarga con cobros conservados y aviso real de BUILD con entradas sin repetición. Se retiraron solamente las cuentas sintéticas reservadas; las cuentas existentes se conservaron. Copia SQLite íntegra verificada dentro del volumen del servidor.
