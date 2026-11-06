# Phase 7A Hotfix

Corregido error de compilación AS3:

`A conflict exists with inherited definition flash.display:DisplayObject.root`

Archivos corregidos:
- `src/com/bh/game/Batter.as`
- `src/com/bh/game/Pitcher.as`

La variable interna `root:Sprite` fue renombrada a `bodyRoot:Sprite`
en todas sus referencias. `root` ya existe en `DisplayObject`, por eso Flex
rechazaba la declaración privada en las clases que heredan de `Sprite`.
