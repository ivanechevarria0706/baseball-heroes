# Phase 8S v2 — CharacterPortrait compile hotfix

Compiler error fixed:

`CharacterPortrait.as(136): Error: Function does not return a value.`

Cause:
`assetExists(...):Boolean` returned from the `try` and `catch`, but the
Flex/ActionScript compiler still considered a possible path reaching the end
of the function.

Fix:
An explicit final `return false;` was added after the try/catch block.

No gameplay or visual behavior was changed by this hotfix.
