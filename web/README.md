# Versión web 0.7.9

Se reconstruyen 60 recortes desde las láminas originales: cinco vehículos completos y correctamente asignados, cinco emblemas de liga, doce íconos de modos, treinta logos y ocho sobres con su contorno negro intacto. Las actualizaciones de arte externo también se incluyen en el identificador de versión. Detalles y límites: `../REVISION_RECORTES_079.md` y `../COMPARACION_RECORTES_079.html`.

NEXT SEASON prepara el juego 1 antes de las metas, el viaje y la alineación. Conserva la carrera y los resúmenes anteriores; la recarga de cartas mantiene su fecha completa y no regala energía al recargar. La ventana de metas indica la liga actual y usa el entrenador ilustrado de la hoja aportada. Detalles en `REVISION_TEMPORADA_078.md` y `COMPARACION_TEMPORADA_078.html`.

EQUIP recupera la composición del inventario de los videos: panel azul con cuatro columnas a la izquierda, héroe sobre el campo y barras de atributos a la derecha. Las seis categorías tienen páginas de ocho objetos; probar, cancelar y aplicar conservan la partida, y SHOP abre la tienda existente. Detalles, evidencia y límites: `../REVISION_EQUIPAMIENTO_075.md`.

Se eliminan las pausas de preparación de bateadores durante la simulación: el actor del héroe se conserva entre turnos, se evita preparar el HUD oculto y el estadio utiliza una caché estática. Medición en Chrome: 37,47 → 59,98 FPS medios; cambios de bateador 2.512 → 1 ms. Son datos de una prueba local, no una garantía por equipo. Detalles: `../REVISION_RENDIMIENTO_074.md`.

HOME incorpora iconos, fuentes incorporadas, ocho compañeros y tarjetas paginadas para los nueve titulares. TRAIN abre directamente el entrenamiento del héroe. Se corrigen el fondo ilustrado tapado por el campo nativo y el cobro de entradas repetido al recargar por truncamiento de marcas UTC. Detalles y recursos pendientes: `../REVISION_HOME_073.md`.

LINE UP sigue ahora la composición del gameplay con estadio de fondo, paneles azul/blanco, nueve filas compactas, gráfico de atributos y botones ovalados. Incorpora fuentes sustitutas al SWF para conservar el grosor en Ruffle. Se corrigen el clic de suplentes y el filtro SPECIAL. Detalles: `../REVISION_ALINEACION_072.md`.

TRAIN incluye ahora la sala ilustrada y las seis actividades RUNNING, con premio inmediato, Mastery y descanso persistente. ATRIBUTOS conserva el entrenamiento anterior. El guardado web corrige el bucle de comparación con números en notación científica. Detalles y límites de fidelidad: `../REVISION_ENTRENAMIENTO_071.md`.

La página permite crear una cuenta con usuario, contraseña y nombre visible, sin invitación. RIVAL → ENLACE muestra la dirección para compartir y no genera códigos. Las cuentas nuevas conservan el inicio en nivel 1 de ROOKIE. Detalles: `../REVISION_WEB_070.md`.

El navegador ejecuta la base ActionScript mediante Ruffle 0.6.0 autoalojado. La temporada, las cartas, la alineación y los recursos existentes se conservan. Esta entrega cambia la plataforma de acceso y guardado; no supone que el arte ya sea idéntico al original.

Las nuevas carreras empiezan en nivel 1 de ROOKIE. La versión 0.6.9 sustituye los valores iniciales de demostración y corrige el inventario y el aviso de subida de nivel. El botón NUEVA CARRERA descarga un respaldo antes de reiniciar; los retos y ligas del servidor permanecen. Detalles y pruebas: `../REVISION_CARRERA_069.md`.

## Construcción

Desde la carpeta superior `Baseball Heroes`, ejecutar `research/hosting-venv/Scripts/python.exe research/build_web068.py`. Requiere el Flex/AIR SDK y Java configurados en ese script, además de las fuentes locales `C:/Windows/Fonts/arialbd.ttf` y `ariblk.ttf` para la alineación. El proceso de compilación genera `generated-src` a partir de `src`, los adaptadores de `web/src` y las transformaciones de `build_web068.py`. El ejecutable Windows 0.6.7 conserva su compilación anterior.

El manifiesto `public/version.json` identifica la compilación de SWF, HTML, JavaScript y CSS. Ruffle está fijado a la versión 0.6.0; actualizarlo requiere repetir las pruebas de compatibilidad. Los rótulos de simulación y resultado usan texto animado directamente en el navegador porque `BitmapData.draw(TextField)` detenía la ejecución en esa versión de Ruffle. Windows conserva su implementación anterior.

## Servidor y guardado

`online/web_app.py` añade la página y las rutas `/web/*` al servidor existente. `online/production.py` activa esa capa cuando encuentra `web/index.html` junto al servidor. La API del ejecutable sigue disponible. La base de datos y las copias diarias permanecen en el volumen de Railway, sin cambiar las variables ni montar otro volumen.

El inicio de sesión utiliza una cookie Secure, HttpOnly y SameSite=Strict. El navegador carga solamente desde el mismo origen; no recibe el token de la API en JavaScript. Los recursos del juego requieren sesión. La cuenta creada en la web comparte identidad con RIVAL. La ruta `/web/register` habilita el registro sin código mediante un parámetro interno del servidor; un campo JSON no puede cambiar la política de la antigua API Windows. La edición web también puede arrancar con una base vacía sin `BH_BOOTSTRAP_INVITE`.

Cada cuenta tiene una partida de esquema 21 en `web_saves`. La revisión evita que una pestaña atrasada sobrescriba otra; el identificador de petición permite recuperar una respuesta perdida sin duplicar el guardado. Los cambios pendientes se conservan en el almacenamiento local de esa cuenta. Si hay conflicto, se pausa el juego y se ofrece descargar la copia local. No usar dos pestañas simultáneamente para avanzar la misma partida.

El guardado ocurre en los puntos existentes de GameData. La temporada local no guarda cada lanzamiento; los retos del servidor sí persisten cada turno. Un aviso permite guardar y cargar una nueva versión sin recargar automáticamente durante un partido.

La importación valida esquema y tamaño, pide confirmar el equipo, descarga el progreso anterior y guarda la nueva partida con control de revisión. La copia personal exportada de Windows queda fuera del servidor y del paquete de despliegue hasta que su dueño decida importarla.

## Publicación y pruebas

`research/prepare_railway_web078.py` prepara exclusivamente los archivos permitidos en `research/railway-web078-source`. Excluye partidas, invitaciones, claves, credenciales y los ejecutables de prueba. Publicar únicamente esa carpeta en el servicio existente.

Pruebas de esta entrega: `research/test_transition078.cjs`, `test_season078.cjs`, `test_home078.cjs`, `test_cloud_transition078.cjs` (local y Railway) y `test_web_staging078.py`. Verifican transición, conservación de carrera, metas, cobro único, precisión de recarga de cartas, treinta juegos, rutas y guardado. Los datos de ascenso son sintéticos y pertenecen exclusivamente a cuentas QA. Todos los ejecutables de diagnóstico, incluido WebSeasonTransition, se excluyen del despliegue. Los informes anteriores conservan las pruebas de inventario/tienda y el rendimiento del motor de 0.7.4.

El cliente envía su alineación y su progreso; esto es una reconstrucción para un grupo privado, no un sistema competitivo con protección contra alteración de estadísticas locales. No hay multijugador simultáneo: cada local juega contra la simulación del equipo publicado de su amigo. La paridad visual y los demás modos siguen siendo trabajo posterior.
