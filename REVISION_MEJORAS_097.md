# Mejoras 0.9.7

Fecha de revisión: 11 de octubre de 2026. Puntos solicitados: 1, 2, 3, 4, 7, 8, 9, 10 y 12.

## 1. Cuerpo y movimiento del héroe

Doce cuerpos ilustrados: cuatro poses de HOME y ocho poses del swing, anclados por cuello y pies. Se recolorean y se almacenan en caché.

Límite: La cabeza aprobada 0.8.6 conserva exactamente su código. El arte corporal es reconstruido y todavía difiere del original.

## 2. Defensa y corredores

Dieciséis poses defensivas para recoger, lanzar, atrapar elevado y recibir en base; doce de carrera, frenada, deslizamiento y celebración. Secuencias integradas en las viñetas de OUT.

Límite: Las poses son nuevas reconstrucciones. No se inventa una resolución SAFE que no se haya observado.

## 3. Cinemáticas de hit y home run

Llegada suave a base, frenada y slide para batazos largos. Tres ambientes de HR con aproximación, trayectoria de pelota, reacción e impacto; las escenas espaciales tienen ventana y consola.

Límite: Se reutilizan y animan los personajes disponibles; siguen faltando cuadros originales intermedios.

## 4. Acabado de pantallas

Tipografía embebida compartida en marcos y botones; panel de colores del creador reubicado para no tapar controles. Libro de habilidades rediseñado en 4:3.

Límite: Las fuentes son sustitutas. Este pase no acredita paridad de todas las pantallas.

## 7. Libro con doce habilidades

Ocho habilidades nuevas, tres rangos, requisitos de nivel y habilidad previa, coste en puntos y una activa. Los efectos se aplican a poder, contacto, tolerancia de foul, combo, hits largos, suerte y defensa.

Límite: Árbol, nombres nuevos, efectos y requisitos son diseño local donde no existe evidencia suficiente del árbol original. No se regalan puntos a partidas antiguas.

## 8. Doce bates de colección

BOSS, TIGER, ALL STAR, ARCTIC, PUMPKIN, SKELETON, ZOMBIE, MUMMY, RUDOLPH, STEAM, ROBOT y MECHA completan los conjuntos existentes. Catálogo EquipmentCatalog: 105 entradas frente a 93.

Límite: Precios, niveles y estadísticas son locales; ilustraciones nuevas. En animación se aplica el material al bate de la pose, sin garantizar una silueta histórica exacta.

## 9. Hardworking Hitter y Lucky Hitter

Se añaden los dos logros, sus contadores y avisos de progreso durante el encuentro. Se consolidan al cerrar el partido y los premios se reclaman una vez. Las primeras metas visibles son 500 y 25 en los cuadros de 01:44 y 01:46.

Límite: Criterios y niveles superiores son reconstruidos: turnos completados del héroe y efectos Lucky. Las partidas antiguas empiezan estos contadores en cero; no se inventa historial.

## 10. Calibración y premios medidos

Estudio cuadro por cuadro del vuelo visible; rectas más rápidas y menos variación aleatoria. Corrección de nueve premios legibles del ranking, incluidos los de un millón y superiores.

Límite: Tres muestras no bastan para recuperar probabilidades ni la tabla física completa. Los recibos antiguos no se vuelven a pagar.

## 12. Prueba de cuentas, retos y liga

Registro, carrera y partidas desde sesiones de Chrome separadas, resultados compartidos y persistentes. Guía publicada para la prueba con tu amigo.

Límite: La prueba entre dos computadoras físicas queda pendiente de ustedes; dos sesiones automáticas no la sustituyen.

## Evidencia y conservación

- Cabeza 0.8.6 SHA256: c75b0548634b2d2d5c28cd795dc663b4aa9e36b6af4339c869c17f60028e9e2f.
- Guardado v21, SQLite v3; sin reiniciar cuentas. Registro sin invitación; nivel 1 / ROOKIE.
- 29 pruebas del servidor, incluida conservación de recibos antiguos y premio superior reclamable una vez.
- Chrome: creación completa, cancelación del borrador, recarga, primer partido; habilidades con requisitos y coste; compra/equipamiento de bate nuevo; SPECIAL, combo, ranking, reentrada y postemporada.
- Rendimiento local: 45.165 s, 2708 cuadros, 59.96 FPS, P95 18–25 ms, una pausa de 116 ms; entrada a partido 6.6 s en esta muestra. No se promete el mismo rendimiento en otras máquinas.
- Solo cuatro efectos aislados del usuario en el paquete. No se agrega audio narrado de SINGLE/DOUBLE ni efectos FAF.
- Arte nuevo: assets/sprites/v097/provenance.json y prompts.json. Poses derivadas por generación, no originales recuperados. Las dos primeras instrucciones se conservan como especificación, no transcripción literal del prompt perdido.
- Calibración y sus límites: reference_visual/calibration097/README.md.
- La copia de seguridad verificada está en el mismo volumen de Railway; no se presenta como copia externa al proveedor.

## Multijugador

La guía pública /amigos.html describe publicar equipos, retos, reanudar, liga privada y comprobación desde dos computadoras. El usuario confirmó que puede probar con un amigo después de publicar. No se afirma que esa prueba humana ya ocurrió.

Las últimas correcciones del despliegue afectan solo al acceso público a la guía y a la navegación a la portada/guía desde enlaces externos. No cambian WebMain, el motor, los perfiles ni las rutas privadas. Tras las 29 pruebas completas, se repitieron las siete BrowserTests con la corrección final; pasan y mantienen protegidas la sesión y los archivos de juego.

## Publicación

{
  "deployment": "3647475a-247d-405c-bfe8-88dd868418b4",
  "status": "SUCCESS",
  "release": {
    "version": "0.9.7",
    "build": "c0265183cd9f5d06",
    "assets": "d746016df279f436352fc4bf42784f334b445f892af00d06e190b7db17f5f6cd",
    "game": "/game/WebMain.swf",
    "runtime": "Ruffle 0.6.0",
    "saveSchema": 21
  },
  "health": {
    "name": "Baseball Heroes Private",
    "protocol": 1,
    "rules": "private-exhibition-1",
    "development": false,
    "features": [
      "private-leagues-v1",
      "private-social-v1"
    ]
  }
}

Prueba de sesiones separadas:

{
  "status": "PASS",
  "separateBrowserContexts": 2,
  "friendlyCompleted": true,
  "leagueCompletedFixtures": 2,
  "sharedResultAfterReload": true,
  "sessionIsolation": true,
  "physicalComputersTested": false,
  "errors": []
}

Limpieza de cuentas sintéticas:

{
  "removed_qa_accounts": 2,
  "removed_qa_matches": 6,
  "preserved_existing_accounts": true
}
