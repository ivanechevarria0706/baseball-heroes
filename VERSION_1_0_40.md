# Baseball Heroes 1.0.40
Publicado en Railway y comprobado en Chrome.

Ocho sprites propios creados con image_gen: dos poses del scout y seis objetos. PNG originales y prompts en assets/sprites/v1040/provenance.json. Ventanas medidas por silueta completa, incluyendo bordes que atraviesan la cuadrícula. Recortes nativos compartidos; entrenador como copia bitmap propia, sin draw adicional.

Oficina de scouting con 25 dosieres Bronze, giro de revelación, candidato ilustrado con nombre completo y atributos, cuatro hallazgos recientes y estados de fichaje. Bronze 5,000 / Gold 20,000 sin cambios de economía. Firma sin segundo cobro, controles desactivados durante la revelación y tras fichar; guardas de plantilla llena, Coins y pantalla descartada.

Acceso HOME > SCOUT > SCOUT PLAYERS; vuelve mediante FRIEND DRAFT. Conserva Draft gratuito de amigos y tutorial. Iconos propios en HOME, Draft, social y barra del partido; entrenador en tutoriales/misiones.

Se corrige lastScouted: serialización y carga del último candidato normal pagado y pendiente. No añade historial persistente de todos los hallazgos. Comprobación real de recarga antes de fichar. No hay cambio de esquema ni reset; cargas anteriores sin este campo continúan con null.

Dos suites locales y un recorrido público: cuentas nuevas nivel 1/Rookie, héroe, compras, EQUIP, LINEUP, navegación, candidato pendiente, fichaje y entrada al partido. Protecciones de doble cobro, saldo, plantilla y listeners descartados. No se repitió partido completo ni todas las pruebas del servidor, cuyo código no cambia. Se mantiene la verificación completa de partido de la 1.0.39 como antecedente, no como prueba nueva.

Sin reinicio de datos. Copia SQLite consistente privada dentro del servidor y comparación de perfiles/guardados/reset dentro de SQLite. Se elimina exclusivamente la identidad sintética de esta verificación. Biblioteca activa anterior conservada para rollback; biblioteca inactiva 1.0.38 archivada y verificada localmente. Paquete de 242 archivos excluye diagnósticos e investigación.

Build 90c15ca3084850ff; SWF fa00a13925d66350ea3529b0c89925ad9cb3d0c2a55fd893d96666a9e64a592a.
