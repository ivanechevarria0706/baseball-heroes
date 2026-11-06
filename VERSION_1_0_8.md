# Baseball Heroes 1.0.8 — renovación visual de la interfaz

Actualización del 15 de octubre de 2026. Conserva tu progreso, equipamiento y cabeza 0.8.6.

1. **Marcos con relieve.** Una base visual compartida dibuja borde exterior oscuro, aro claro, bisel interior, sombra corta y reflejos. Los paneles azules conservan la composición del juego y añaden profundidad.

2. **Botones que se sienten físicos.** Acciones, pestañas y controles muestran brillo superior, borde plateado y base oscura. Los botones compartidos responden al pasar el mouse y al presionarlos sin cambiar su acción.

3. **Tipografía y textos ajustados.** Títulos compactos con una fuente Impact incrustada, contorno y sombra. Etiquetas ajustadas al espacio disponible, centrado de botones y comprobación de nombres largos y saldos grandes. La fuente es una sustituta; no se ha recuperado la original.

4. **Creador y HOME.** El creador usa marcos biselados, pestañas iluminadas y fichas con superficie clara. HOME mejora PLAY BALL, casillas de amigos, metas, rango y accesos del menú.

5. **LINEUP y tienda.** Filas de bateadores con bordes, selección dorada y reflejos; encabezados compactos y controles con relieve. Las fichas del equipo y la tienda, sus pestañas y botones usan el mismo acabado.

6. **Modos, misiones e inicio de sesión.** Fichas y marcos compartidos para modos y misiones. La página de acceso acompaña el estilo con campos hundidos, marco claro y botones brillantes. Se conservan las reglas y los datos de las cuentas.

Referencia: creador de personaje de onboarding_20261005/personaje.jpg y tienda de explicando_20260924/frame-0550.jpg. Los bordes, brillos, proporciones y jerarquía tipográfica se reconstruyen con gráficos nativos. No son sprites de interfaz recuperados. Las ilustraciones y el personaje aprobado no cambian.

Los relieves son geometría dibujada al crear o actualizar el control; no añaden animación continua ni superficies de desenfoque a los paneles. Se comprueban las vistas previas, los botones, el cobro único de premios y la ruta de entrada a un partido. Guardado v23, SQLite v4, modelo y servidor sin cambios; sin migración ni reinicio. Menús en inglés; tutoriales y consejos en español.

Publicación verificada: build `bcab9d3cdfbb1ab5`. Tres suites locales y una en HTTPS aprobadas. Siete pantallas, 48 vistas del creador, categorías de equipo, botones normales/hover/presionados, nombres largos, saldos grandes, premios sin duplicados, recarga y entrada real a un partido. Se retiraron solamente las cuentas sintéticas reservadas; las cuentas existentes se conservaron. Copia SQLite íntegra verificada dentro del volumen del servidor.
