# Baseball Heroes 1.0.48

MenuEntrance anima recursos retenidos con un único reloj que empieza al primer cuadro en escena. El sonido no se dispara durante la construcción/carga del menú. Permite terminar la animación mediante interacción y conserva coordenadas finales; dispose/REMOVED_FROM_STAGE cancelan sus pistas y eventos.

SeasonRoadmapScreen recibe el calendario medido a 00:24.6–00:27.6 del video aportado: revelado del fondo, progreso, cinco tarjetas escalonadas, información y VS final. SeasonMatchBanner organiza el arte existente en dos mitades y un título; no cambia datos ni personajes. Navegar el calendario termina la entrada antes de recrear sus tarjetas.

LineupScreen separa el chrome superior del cuerpo y mueve el panel, filas y controles juntos con el sonido estadio/alineación. Conserva coordenadas e interacción final. TravelMapScreen comienza el avión en su primer frame visible y usa el mismo reloj del trayecto; Rookie no recibe audio de avión. Llegada inicial utiliza el mismo acabado de entrada. Main instala una entrada breve en los restantes menús y cancela la anterior al navegar. Game y las pantallas con secuencia propia quedan excluidos de la entrada general.

Prueba de quince rutas de Main, reloj del calendario/VS, salida temprana, primera aparición y LINE UP/viaje. Recorrido con WebMain final en local y Railway, registro, compra, colocación de normales/especiales, persistencia y entrada al partido. No cambia ningún archivo de core/game/model/audio/visual; el partido de nueve entradas validado en 1.0.47 continúa como referencia y no se presenta como repetido en esta entrega. Paquete explícito de 242 archivos; 238 hashes remotos verificados; perfiles y progreso comparados dentro del servidor. Sin reinicio. Biblioteca 1.0.47 retenida para rollback.

calendar-opening.mp4 es una demostración con reloj controlado, a 20fps, de 67 cuadros de la interfaz real y su recorte original. No mide rendimiento. Los MP3/WAV y sprites fuente se conservan sin cambios.

Build 2306027396d08f8c; SWF 27d95707fed348f406ee11908e4056d85c89f2d1404b0ac992d8abd7d96441a8.
