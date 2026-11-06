# Web 0.8.7 · Giros del héroe al batear

Publicado el 8 de octubre de 2026 en Railway: 79c148aa-0dfa-493c-8bab-12c4814f485f, build dceed5a34572c488. [Comparación visual](COMPARACION_GIROS_087.html).

La cabeza anterior alternaba entre una cara frontal y un casco posterior prácticamente idéntico en casi todas las poses. La altura del casco cambiaba al pasar de espalda a frente. Se contrastó el perfil con el partido original aportado y las poses oficiales recuperadas, manteniendo la vista frontal del creador.

HeroHead prepara trece orientaciones cada 15 grados, de 0 a 180. La mejilla y la nariz usan contornos propios; los ojos próximo y lejano se proyectan por separado, el segundo se estrecha y se oculta al pasar a perfil. El iris mira hacia el lanzador. Nariz y boca conservan las variantes seleccionadas y las expresiones temporales. Casco, visera, brillo, orejera y gafas acompañan la orientación; el cabello de la nuca queda detrás de la piel para no parecer una barba. Se conserva el origen de mandíbula/nuca sobre el cuello del cuerpo.

HeroSprite asigna direcciones a preparación, contacto, seguimiento, regreso y reacción. ClassicBatter avanza el giro a 420 grados/segundo, limitado a 100 ms de avance visual por cuadro. Las vistas se reutilizan; la selección cambia solo la visibilidad anterior y nueva. Se preparan los ángulos de las tres expresiones empleadas en partido durante warmAll. No se procesan ni recolorean píxeles por cuadro. El cuerpo, contacto del bate, rotación al apuntar y tiempos de swing/reacción permanecen iguales.

No se cambian GameData, timing, probabilidades, recompensas, guardado 21, progreso inicial ni servidor de cuentas. No se generan ni editan imágenes de los atlas; cuerpo y pelo son las reconstrucciones de 083. Las fotos originales se preservan.

## Pruebas

La identidad deliberada de ocho campos se conserva tras SELECT y recarga, en HOME/retrato, ocho peinados, ocho ojos/narices/bocas, ocho contornos, cuatro expresiones, dieciséis poses y trece orientaciones. Las galerías no escriben apariencia ni nivel ni liga.

El diagnóstico usa el ClassicBatter real con reloj controlado. A 64 ms del swing, el punto transformado del bate coincide a menos de 1.5 píxeles con las tres alturas probadas (-100, -80 y -48 respecto a los pies), dentro del límite de inclinación existente de ±18°. Se verifican los cuadros a 120, 220, 400, 1050, 1200, 1340, 1400, 2200 y 2600 ms, incluyendo vuelta a espera y celebración. El límite existente de inclinación no se amplía. Los SWF de diagnóstico se excluyen del despliegue.

Chrome local y publicado: registro sin invitación, nivel 1 / ROOKIE, equipo y vuelta atrás, cancelación/confirmación del borrador, llegada tras recargar, HOME, nombre/dorsal, metas, viaje, alineación, introducción, primer partido y reentrada. Energía cobrada una vez; apariencia y carrera conservadas. Sin errores del navegador.

Muestra ENTER_FRAME de 45.100 s: 2706 cuadros, 60.00 FPS, p95 25 ms, máximo 48 ms y 0 intervalos mayores de 50 ms. 15 cambios de bateador, máximo 1 ms en esta muestra. No se garantiza ese rendimiento en otras computadoras ni ausencia total de pausas.

Paquete permitido de 131 archivos, nueve hashes publicados coincidentes y respaldo Railway external-v087-1791440917.sqlite3 verificado dentro del volumen. Se eliminó únicamente la cuenta QA propia y se comprobaron las cuentas preexistentes. Atlas de 083, referencias oficiales, 60 recortes de 079, siete celebraciones de 080 y paquete Windows histórico 067 conservan hashes.

## Límites

Las orientaciones y su correspondencia con las poses son reconstruidas; no son cuadros originales recuperados. La cara y el casco son trazados nativos. El cuerpo mantiene sus poses ilustradas actuales, por lo que aún faltan cuadros intermedios del cuerpo y del pelo sin casco. Las vistas muy posteriores muestran nuca y casco, con poca cara visible, como en la referencia de partido. No se afirma paridad exacta.
