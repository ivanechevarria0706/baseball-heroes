# Phase 8E Hotfix

Compiler error fixed:

```
LineupScreen.as(...): Error: Incompatible override.
LineupScreen.as(...): Error: Duplicate function definition.
private function onBatterShop():void
```

Cause:
`LineupScreen` declared both:

- `private var onBatterShop:Function`
- `private function onBatterShop():void`

ActionScript 3 places these members in the same class namespace, so this is a
duplicate definition.

Fix:
The callback property was renamed to:

`private var batterShopCallback:Function`

The method remains:

`private function onBatterShop():void`

All references were updated.

Additional validation:
- scanned all ActionScript files for property/function name collisions;
- balanced braces, parentheses and brackets;
- checked local `com.bh.*` imports;
- checked inherited DisplayObject property conflicts;
- removed stale `Main.swf`.
