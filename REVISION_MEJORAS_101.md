# Mejoras 0.10.1

11 de octubre de 2026. Mystery Boxes completas y comportamiento de Combo/Luck, a partir de la investigación histórica.

## Inventario y premios

- Cinco cofres: Rookie, A, AA, AAA y Major. Consumen respectivamente 2, 3, 4, 5 y 7 llaves.
- Sobres C, B, A y S almacenados por separado. Abrir consume un sobre; COLLECT entrega una carta independiente del catálogo actual.
- Los cofres pueden entregar monedas, energía, llaves, sobres, cartas, efectivo del juego o equipamiento. Bate, guante y gafas llegan al inventario y se pueden equipar. Si el equipo ya está comprado, se convierte en monedas con una cantidad fijada antes de la animación.
- SPECIAL y ROADMAP entregan el cofre de la liga correspondiente. Los premios y etapas ya cobrados permanecen cobrados.
- El sorteo se guarda antes de la animación. Recargar recupera el mismo premio; COLLECT no vuelve a entregarlo.
- Se corrige el dibujo de los bates de coleccionista en el premio: usan su propio atlas, no el recorte de zapatos de los accesorios.

## Combo y Luck

Los hits cargan el combo; Luck aumenta la carga. WALK deja de añadir carga de hit. MAX permanece preparado hasta conectar una pelota válida con el héroe: el resultado pasa a HOME RUN y se consume una sola vez. Strike, foul y walk conservan MAX. No garantiza acertar el swing.

## Corrección del guardado de cartas

La prueba del SWF final detectó que al ampliar el diccionario de cartas después de una recarga, la serialización podía omitir un ejemplar. Al añadir una carta se reconstruye ese diccionario conservando todos los ejemplares anteriores. La prueba ahora comprueba tanto el inventario en memoria como el guardado de la cuenta.

## Qué confirma la evidencia

- [Gamelytic: Mystery Boxes](https://gamelytic.com/baseball-heroes-mystery-box-information/) documenta los cinco costes de llaves y los premios 6.000 / 12.000 / 30.000 Coins del cofre A.
- [Gamelytic: estadísticas](https://gamelytic.com/baseball-heroes-skill-stats-guide/) describe la relación de Luck con la carga de combo y Lucky Hit.
- [WWGDB: reseña de 2015](https://www.wwgdb.com/games/baseball_heroes) describe el Home Run al llenar el combo, condicionado a conectar la siguiente pelota.
- Los fotogramas del gameplay aportado muestran el inventario, la confirmación, el sobre y COLLECT. La comparación enlaza esos fotogramas.

## Qué sigue siendo reconstrucción

La escala de diez unidades, los umbrales de Luck, bonos parciales, distribución de premios, selección de equipamiento, cantidades no documentadas y conversión de duplicados son balance local. Los sobres usan las clases y cartas existentes del remake. No se afirma que estas tablas sean las del servidor de Syntasia. No se aplican los porcentajes de Out/Hit/Home Run ni la curva de XP que no pudieron verificarse. Tampoco se cambia aquí la tabla de recompensas de partidos.

## Conservación y comprobaciones

- Carrera v21; subinventario Mystery v2 con migración aditiva. Cofres, llaves, sobres C, partidos registrados y el premio pendiente de la versión anterior conservan sus cantidades, incluido un premio antiguo de 2.000 Coins.
- Cabeza aprobada de 0.8.6 y atlas de cabello sin cambios. XP, temporización de bateo, precios existentes y resultado de los partidos conservan su base.
- Cuenta nueva sin código: nivel 1, ROOKIE, creador, llegada, objetivos, ROADMAP, viaje, alineación, primer partido y recuperación al iniciar sesión otra vez, en Chrome local y en Railway.
- 35 casos de premio, costes exactos, falta de llaves, límites, cuatro clases de sobre, recarga y entrega única, equipamiento y duplicados. Motor real: MAX con strike, foul, walk y contacto.
- Regresión de habilidades, catálogo, energía, estadísticas, clasificación y liquidación única; 30 pruebas de servidor aprobadas antes de publicar. El servidor no recibe cambios en esta versión.
- Paquete publicado comprobado por hashes, SQLite v3 íntegra, copia de seguridad en el volumen y cuentas de prueba retiradas preservando las cuentas existentes. La prueba física con el amigo en otra computadora sigue pendiente.

## Publicación

Railway confirmó SUCCESS para 0.10.1, build d64c1a9d0992f8f0, despliegue 7c35813c-cb4b-4dce-a86d-986b078e3a8c. Los informes detallados están en revision_manifest.json.
