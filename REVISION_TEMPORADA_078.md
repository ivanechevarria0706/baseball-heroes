# Web 0.7.8 · Cambio de temporada y recarga de cartas

La nueva temporada se prepara al pulsar NEXT SEASON en el calendario terminado. Antes, el motor cambiaba de temporada al iniciar el partido, después de mostrar el viaje y la alineación del último rival anterior. Ahora el calendario abre el juego 1 antes de fijar metas, viajar, ordenar la alineación y mostrar la introducción. Todas esas pantallas consultan el mismo rival de la temporada nueva.

El cierre muestra el balance de victorias/derrotas, posición y ascenso cuando existe. Consultar juegos anteriores, HOME y abrir LINEUP en una temporada terminada no la reinicia: LINEUP conduce al calendario de cierre. NEXT SEASON cambia una sola vez el número de temporada; mantiene nivel, liga conseguida, XP, monedas, plantilla, inventario, cartas y los resúmenes del último partido y temporada. Se limpian únicamente los contadores e historial de la temporada que comienza. No cambia la regla aproximada de ascenso.

La preparación funciona también sin energía. El cargo del partido y de sus cartas sigue ocurriendo al comenzar el encuentro. Volver desde la introducción es gratuito; retomar el encuentro ya pagado reutiliza su clave de temporada/juego y no cobra de nuevo. Los resúmenes anteriores permanecen guardados después de abrir la temporada siguiente.

Si se recarga o se sale con ESC antes de aceptar las metas, PLAY/LINEUP vuelven a la configuración pendiente. La ventana de metas muestra la liga y temporada actuales, en lugar de ROOKIE en todos los casos. Su entrenador usa el personaje azul recortado de la hoja 11_08 aportada, con las fuentes incorporadas de la interfaz. La distribución del diálogo continúa siendo una reconstrucción; no se afirma que sea el diálogo original exacto.

## Error adicional encontrado y corregido

Una prueba con una carta consumida detectó que al recargar se recuperaban sus cargas antes de transcurrir tres horas. Ruffle truncaba la fecha de recuperación al leer un entero grande desde JSON. El modelo ahora guarda esos milisegundos como texto decimal, y la entrada del navegador convierte las fechas numéricas de partidas anteriores antes de entregarlas al parser de ActionScript. El contador y la fecha futura se conservan sin regalar cargas. Las comparaciones y el cálculo de recuperación siguen usando números; la regla de tres horas no cambia. El esquema sigue en v21 y admite ambos formatos previos.

## Verificación

- `smoke-transition078.txt`: se completa el juego 30 mediante GameData, con victoria y ascenso; conservación de la carrera y premios; transición repetida inocua; preparación con energía cero; metas pendientes tras ESC/recarga; marcador/historial; rival del juego 1 y lanzador real; introducción BACK gratuita; una energía y una carga por partido incluso al reabrirlo. Comprueba también las fronteras de recuperación a tres y seis horas y la importación de una fecha numérica antigua sin perder precisión.
- `smoke-season078.txt`: todos los treinta encuentros accesibles, extremos del carrusel, resultados conocidos/migrados, consulta sin cambios y cierre de temporada.
- `smoke-home078.txt`: rutas existentes, compañeros, estadios y recaudación única en el cliente actualizado.
- `smoke-production-transition078-local.txt`: mismo ejecutable final, sin callbacks de diagnóstico; registro nuevo en nivel 1 ROOKIE, partida QA de temporada terminada, guardado/recarga, viaje, alineación, introducción, partido con teclado y reanudación sin segundo cobro.
- `smoke-web078-staging.txt`: paquete con lista permitida, arranque con base vacía, registro sin invitación y exclusión de diagnósticos.
- `smoke-cloud-transition078.txt`: comprobación del cliente publicado sobre Railway con una cuenta temporal propia; posterior limpieza y respaldos íntegros dentro del volumen.

Las pruebas de ascenso usan datos sintéticos en cuentas QA y no avanzan ni modifican partidas personales. Las muestras de veinte segundos comprueban el bucle del navegador, no los FPS internos de ActionScript. Las mediciones del motor de 0.7.4 se conservan.

No se añaden modos POST SEASON/ALL STAR ni se inventan fórmulas del servidor original. La composición del calendario procede de la referencia 05:10 del gameplay «Explicando Algunas Cositas» usada en 0.7.7; el entrenador procede de 11_08. Continúan pendientes el mapa ilustrado exacto, las texturas del diálogo, los eventos especiales y los demás recursos originales. Windows 0.6.7 conserva su compilación anterior; esta entrega se publica para la versión web.
