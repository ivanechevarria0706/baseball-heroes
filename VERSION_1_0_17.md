# Baseball Heroes 1.0.17 · Elección inicial fija

Fecha: 19 de octubre de 2026.

El equipo elegido y la apariencia del personaje quedan confirmados durante la creación inicial. La ciudad y los colores del club dejan de modificarse tras seleccionar el equipo; el creador no ofrece volver al selector. La apariencia base deja de admitir cambios tras confirmar el personaje.

En HOME, LEAGUE abre la progresión de ligas y HERO muestra los atributos del héroe. Ambos conservan sus iconos y dejan de abrir el selector de equipo o el creador. Las rutas antiguas de edición se retiraron del controlador principal.

REPLAY FIRST GAME retoma la guía desde HOME cuando la identidad ya está creada. NEW CAREER conserva el club y el personaje y comienza la nueva carrera desde HOME, como corresponde a la descripción existente de ese botón. Una creación sin terminar se reanuda en su paso pendiente.

La regla también se comprueba en los métodos que aplican la selección de equipo y la apariencia. Las partidas existentes usan su paso de creación guardado; no necesitan otra selección ni una migración de esquema.

NAME mantiene su función original del tutorial: editar el nombre del club y el dorsal. Esa acción conserva la ciudad y los colores elegidos. El equipamiento, los atributos, los entrenamientos y el resto de la progresión siguen disponibles.

Guardado v24 y SQLite v4. No se reinician datos reales. Se conservan el arte, los sonidos y el código de la cabeza aprobada 0.8.6. El ejecutable cambia y su nuevo SHA-256 identifica también la copia local usada por el cargador.

Publicada y comprobada en HTTPS: build `8b562f37ff528638`. Quince comprobaciones de identidad y 34 de progresión inicial aprobadas; recorridos locales y HTTPS con el ejecutable real. Los 143 archivos publicados coinciden con el paquete verificado. Copia SQLite íntegra conservada en el volumen; solo se retiró la cuenta QA usada.
