# Web 0.9.3 · Estadio, animación, amigos y logros

[Comparación de 13 vistas](COMPARACION_MEJORAS_093.html) · [Juego](https://baseball-heroes-api-production.up.railway.app/).

## Puntos elegidos de la última lista

| Punto | Cambio jugable | Límite de fidelidad |
|---|---|---|
| 1 · BUILD | Estadio completo en 960×720, dock inferior SHOP/INVENTORY/TICKET SALES, nueve categorías, compra/activación, decoraciones arrastrables con tamaño y retirada; recaudación cada seis horas. | Reutiliza los seis fondos disponibles y el estadio Rookie reconstruido. Los controles y las variantes aún difieren del arte original. |
| 3 · Partido | Ocho poses ilustradas de defensa para carrera, recogida, salto, recepción y tiro; corredor visible en los hits y devolución de pelota antes del resultado. | Los cuadros son nuevos, generados usando referencias; no son sprites recuperados. La cámara y la física siguen siendo aproximaciones. |
| 4 · Celebraciones | Llegada panorámica del héroe a seis compañeros, celebración de campeón con primer plano/copa/confeti y cuatro poses para cada una de las tres historias de HR. | Las historias y sus transiciones no reproducen todos los cuadros ni la selección del servidor original. |
| 8 · Amigos | REGISTER con cuentas reales del juego, aceptación/rechazo, vínculo a un bateador regular, beneficios, regalos de energía/llaves e INBOX con cobro único. | Sustituye Facebook por las cuentas de esta instalación. No importa fotos, rankings ni amigos de Facebook. Los retos y la liga privada existentes se conservan. |
| 10 · Logros/misiones | Hall of Fame pasa de ocho a 16 objetivos con cuatro grados; misión MÁXIMO BATEADOR de tres hits contra cada una de tres familias y premio único de 800 monedas. Navegación de misiones y objetivos sin solapamiento. | Se transcriben los umbrales visibles en las capturas; no se afirma recuperar los 35 objetivos completos. Las recompensas de medallas sin evidencia usan el balance anterior. |
| 11 · Catálogo | 36 accesorios nuevos de casco/gafas/zapatos y 24 artículos de estadio: ocho figuras de emblemas y 16 variantes de césped/gradas/marcador/luces. | Nombres, precios, niveles y bonus son locales. Los accesorios usan recortes de la lámina 11_11; el héroe aplica colores/atributos, todavía no viste cada disfraz completo. No se añaden nuevos fondos históricos. |
| 12 · Audio | Retirados SINGLE y DOUBLE con voz del comentarista; desactivados todos los demás cortes de efectos sin verificar. Solo quedan activos los cuatro efectos aislados por el usuario. | No se añaden nuevos avisos limpios ni se declara recuperado el banco completo. La música existente se conserva. |

## Reglas y guardado

Se conserva el esquema de carrera 21, el progreso, la alineación, las compras y las medallas reclamadas. `socialState` y los contadores adicionales son opcionales al cargar partidas anteriores. Las cuentas nuevas siguen empezando en nivel 1 / ROOKIE, sin código de invitación. `BatterHead086.as` conserva exactamente el hash aprobado: `c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f`.

REGISTER enlaza un identificador estable de bateador regular con otra cuenta que haya publicado su equipo. El destinatario debe aceptar. Se añade el 5% de su AVG publicado a la probabilidad de hit del compañero en la simulación de carrera; por ejemplo, AVG .320 aporta .016. El texto del beneficio se ve en el original; esta traducción concreta a probabilidad es local. Teamwork tiene límite 10 sin vínculo y 15 con vínculo. Los regulares que participaron ganan 10 + 4×HIT de XP al completar un encuentro, con un 25% adicional si están vinculados; cada 100 XP suben un nivel y un punto de contacto. Estos límites y esta curva no se conocen del servidor histórico y son reglas del remake. Un encuentro completado no vuelve a entregar crecimiento al repetirse su cierre.

Los regalos son +1 energía o +1 llave, gratis: uno por destinatario y día UTC, hasta diez por remitente/día y 100 sin reclamar por bandeja. No se envía nada por abrir una pestaña. Solo se puede regalar tras aceptar un vínculo. Las acciones conservan el identificador de reintento y el servidor guarda recibos transaccionales. Los premios reclamados se concilian mediante totales acumulados; actualizar o recargar no los concede de nuevo. Las llaves por encima del límite de 40 se conservan como crédito y se incorporan al liberar espacio. La energía recibida puede superar el máximo, como otros premios existentes. Estas cantidades y restricciones son locales.

El servidor añade `friend_links` y `social_gifts` con esquema SQLite 3. Antes de migrar una base v2 conserva `private.before-social-v3.sqlite3`; el cambio es aditivo. Solo se comparten perfiles y equipos publicados. Las partidas de carrera siguen siendo guardados privados del cliente; no se añade un sistema antitrampas autoritativo.

Hall añade amigos, victorias, victorias en entradas extra, sencillos, dobles, bases por bola y regalos enviados/recibidos. Los contadores de bateo y victorias se consolidan al completar el partido. MÁXIMO BATEADOR agrupa CURVEBALL/SLIDER como quebradas, FASTBALL como cuatro costuras y SINKER como dos; CHANGEUP no cuenta en esas tres familias. Esta equivalencia adapta los nombres observados al motor actual.

## Arte, audio y rendimiento

Tres hojas nuevas transparentes: 12 poses de historias, ocho de defensa y seis cuerpos modulares de carrera/celebración. Las referencias, los prompts y la procedencia están en `assets/reference/art093-provenance.json` y `assets/reference/runners093/provenance.json`. Se conservan los originales generados y la lámina de equipamiento aportada. Las cabezas se montan con la geometría aprobada de 0.8.6. Los compañeros usan su propia apariencia y color. Las texturas se almacenan en cachés con límite; las poses de corredor y del equipo se preparan al entrar al partido para evitar procesamiento de píxeles durante el batazo.

Los cuatro MP3 del usuario mantienen los mismos bytes que `reference_audio/user_v053`. SINGLE/DOUBLE se descartaron por la corrección del usuario; la revisión automática de habla previa no acreditaba limpieza. El paquete web excluye esos cortes y los demás efectos antiguos en cuarentena. No se realizó ni se afirma una nueva escucha humana o separación fiable de voces. Quedan las tres pistas de música existentes y los cuatro efectos del usuario.

Muestra local Chrome/Ruffle de 45,151 segundos: 2.709 cuadros, 59,999 FPS, p95 25 ms, un cuadro por encima de 50 ms y máximo 103 ms. Antes de preparar los cuadros del corredor, la muestra de esta entrega tenía máximo 226 ms. La preparación inicial del partido tardó aproximadamente seis segundos en esta máquina de prueba. Son muestras locales, no una garantía en otros equipos ni prueba de ausencia total de pausas.

## Comprobaciones

- BUILD: seleccionar sin cobro, comprar/activar una vez, arrastrar/cambiar tamaño, inventario, recaudación con espera y persistencia tras recarga.
- Equipo: catálogo de 63 entradas adicionales en total, bloqueos por nivel, prueba gratuita, compra y equipamiento. Se preservan los identificadores anteriores `gear092_*`.
- Amigos: dos sesiones independientes, publicación, solicitud/aceptación, regalos en ambos sentidos, cobro único, actualización y recarga. El servidor prueba además permisos, reintentos concurrentes y retirada de vínculo.
- Carrera: medallas anteriores, conteo por familia de lanzamiento, pago único de 800 monedas y crédito de llaves que excede la capacidad.
- Partido: WALK-OFF en HR/hit/walk/simulación/extra, resultado reconciliado y sin doble pago; escena visible antes del resultado; postemporada, empate, clasificación, eliminación, título e historial.
- Migración: base v2 poblada, copia automática verificable y todas las filas de sus diez tablas anteriores idénticas tras pasar a v3.
- Producción: registro sin invitación, creación de personaje, recorrido inicial, primer partido, una sola reserva de energía, salida/reentrada, compras/equipo y regalos; ejecutables de diagnóstico excluidos del despliegue.
- Comparación: las 13 parejas de imágenes y cuatro audios del usuario cargan sin errores.

Los resultados concretos están en `build/qa/*093*`. Los datos y cuentas de las pruebas son sintéticos. No se restablece la carrera de ningún usuario real. La publicación y la limpieza remota se registran en `deployment_status.json`.

## Publicación

Railway: despliegue `f47448ad-9888-490f-8836-e11a93aa01de`, build `efc2da1073428d22`. SHA256 de `web/public/game/WebMain.swf`: `0a6794b3688d76c3eb3c2e5284c4ff0d50444b3d7f5ed2636cd4f3e5576b27bf`. Paquete permitido de 132 archivos; 128 archivos que Docker copia al contenedor verificados por hash. Respaldo previo: `external-v093-1791620257.sqlite3`, integridad OK. El paquete no contiene videos, partidas exportadas, cuentas de prueba ni secretos. Esta entrega actualiza la versión web; no genera otro paquete portable de Windows.
