# Phase 8E Hotfix 2

Compiler error fixed:

```
LineupScreen.as(...): Error: Attempted access of inaccessible method
seasonNumber through a reference with static type Class.

GameData.seasonNumber()
```

Cause:
`seasonNumber` in `GameData` is declared as:

```actionscript
public static var seasonNumber:int = 1;
```

It is a variable, not a function. Phase 8E accidentally called it using
parentheses.

Fix:
Both occurrences were changed from:

```actionscript
GameData.seasonNumber()
```

to:

```actionscript
GameData.seasonNumber
```

The previous `onBatterShop` callback/function collision fix is also preserved.

Additional validation:
- no remaining `GameData.seasonNumber()` calls;
- scanned class members for var/function name collisions;
- checked braces, parentheses and brackets;
- checked local `com.bh.*` imports;
- checked common DisplayObject inherited-name conflicts;
- removed stale `Main.swf`.
