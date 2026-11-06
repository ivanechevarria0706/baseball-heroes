# Tienda clásica y cascos observados · 0.10.17

Se continúa el bloque de equipamiento de 0.10.16: ocho cascos visibles, pestañas azules, tarjetas plateadas, precios por moneda y el panel lateral de SKILL POINT. No se modifican el motor de partido, el autojuego ni sus tiempos.

## Cascos

Fuente: [FACEBOOK GAME]BASEBALL HEROES play video.mp4, 04:18. Black Bomber (P20/L9), Red Lightning (P20/C9), Sky Love (L20/C9) y Green Star (L9/C20) cuestan 45 de moneda premium. White Star (P9/L6), Beige Star (L6/C10), Yellow Star (P5/C10) y Aqua Star (P5/C10) cuestan 24,000 Coins. Se añaden ocho IDs classic117_helmet_0–7. Las definiciones y compras anteriores se conservan.

Los ocho iconos se extraen del MP4 sin incluir nombres, precios ni el letrero PREVIEW de la captura. Sus ventanas y hashes quedan en reference_docs/equipment117.json. Se conserva la resolución limitada de la grabación; no son sprites Flash recuperados. Se reutilizan la caché y la búsqueda por nombre/casilla de 0.10.16, también después de comprar y recargar cuando la instancia no contiene ID.

La captura los muestra disponibles en nivel 12, pero no revela su nivel exacto de desbloqueo. Se deja cero, siguiendo la colección anterior; el grado NORMAL y el color base son decisiones del remake. Al equipar cambia el color y los bonos con el renderer existente. Los estampados exactos del casco sobre el héroe todavía están incompletos. No se modifica la forma de cabeza ni el cabello.

## Presentación de SHOP / INVENTORY

Se añaden componentes exclusivos de esta pantalla: EquipmentChromeButton y EquipmentPriceTag. Las seis categorías y las pestañas SHOP/INVENTORY usan azules con selección cian; X es rojo. Las tarjetas tienen cuerpo plateado y precio separado: naranja para Coins, verde para moneda premium. Se muestran el icono de moneda y el importe, sin cambiar el valor que cotiza GameData. OWNED / SELECT / EQUIPPED continúan diferenciados. Las piezas bloqueadas siguen mostrando su precio y un aviso LEVEL; BUY permanece deshabilitado.

Los botones conservan sus rutas y posiciones. La selección activa se mantiene al pasar el mouse; la pulsación mueve piel y texto juntos. Los dibujos se reconstruyen con código y las fuentes siguen siendo sustitutas. LineupButton y ClassicInventorySkin compartidos no se cambian, para conservar las demás pantallas.

## SKILL POINT

El panel muestra puntos disponibles, círculo con suma C/P/L base, valores base y valores efectivos o de preview. Contact, Power y Luck tienen botones + que llaman a GameData.allocateHeroStat, la misma operación ya existente. Gastan un punto para sumar uno al atributo; no conceden puntos nuevos ni gastan Coins/Cash. Se conservan el máximo base de 99 y las restricciones del tutorial. Con cero puntos, los botones quedan deshabilitados y un segundo clic no añade otro atributo.

Este acceso se deshabilita mientras hay un partido pendiente, para mantener coherencia con la instantánea del encuentro. Es una regla de esta interfaz, no una afirmación sobre el original. SPEED permanece en una línea secundaria para consultar el atributo existente. El círculo es una presentación de la suma base, no una fórmula nueva del motor. Mensajes y consejos en español; títulos y etiquetas en inglés.

## Conservación y verificación

Todos los modelos salvo la ampliación aditiva de EquipmentCatalog mantienen sus hashes de 0.10.16. Game, TeamSimulationPanel, pichadas, HeroSprite, HomeSprite, cabeza 0.8.6, cabello, cartas, tutorial, Mastery, economía y servidor son idénticos. Los 47 recortes previos mantienen sus hashes. Guardado v23 / SQLite v4. Las cuentas nuevas siguen en nivel 1 / Rookie. No se reinicia progreso ni se entregan premios retroactivos.

Diagnóstico Chrome: 67 comprobaciones nuevas de perfiles, compras con ambas monedas, importes exactos, doble compra, equipamiento y arte de copias sin ID, saldo insuficiente y candado anterior de nivel 17. Se repiten las 271 de contenido de 0.10.16 y las 100 de autojuego/retratos/pausa. Se revisan visualmente los ocho cascos y las seis categorías con entradas de mouse.

Ejecutable público local y Railway: cuenta nueva nivel 1/Rookie; preparación de nivel 12 para prueba; un punto de Contact aplicado, segundo clic sin efecto y dinero intacto; compras de equipo previo y de dos cascos, con Coins y moneda premium; equipar, recargar, conservar cinco piezas compradas y apariencia personalizada; mejora de Benny una sola vez. Otra cuenta comprueba autojuego, pausa, x1/x2/x4, cobro único de energía y cierre/inicio de sesión. Las partidas v21 y v22 se conservan. Se retiran cuatro cuentas temporales al terminar, manteniendo las anteriores.

Se guarda una copia SQLite íntegra antes de publicar y se comparan los hashes del paquete desplegado. La copia reside en el volumen del servidor, no fuera de él. No se declara una prueba física con dos computadoras.

Publicada y verificada en Railway. Build 240815d08f405d98.
