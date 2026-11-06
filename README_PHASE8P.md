# Baseball Heroes Remake — Phase 8P
## Lineup Drag Fix + Gameplay Callout Polish

This phase fixes the lineup drag/drop problem reported after Phase 8O and
continues the in-game presentation polish.

## Lineup fix

The previous drag code calculated the drop position indirectly from
`LineupScreen.mouseX/mouseY` and the child layer offsets. After the responsive
window/root scaling introduced in Phase 8H, that path could visually drag the
row while failing to resolve the intended lineup slot reliably.

Phase 8P now resolves the drop from the actual Stage coordinates:

`MouseEvent.stageX/stageY -> lineupLayer.globalToLocal(...)`

That means the destination is calculated in the exact coordinate system of the
LINE UP rows, even when the AIR window is resized or the whole game is scaled.

### New lineup behavior
- Drag a SUBSTITUTE directly onto any non-Hero LINE UP row to substitute him.
- The replaced starter automatically becomes a SUBSTITUTE.
- Drag a LINE UP row onto another LINE UP row to reorder the batting order.
- A bright yellow target rectangle shows exactly which row will receive the
  player.
- Clicking a substitute still works on the currently selected batting slot.
- Dragging no longer triggers a second accidental click/swap on mouse release.
- The Hero is protected from being benched because the gameplay loop depends on
  the Hero remaining in the active batting order.
- The Hero CAN still be moved to another batting-order position by dragging the
  Hero row inside LINE UP.
- If you try to replace the Hero with a substitute, the screen now explains what
  to do instead of silently appearing to ignore the change.
- The SUBSTITUTE panel now shows 5 players per page, closer to the original
  gameplay reference around 13:30.

## Gameplay presentation

The existing `GameplayCallout` was redesigned into a slanted arcade-style
banner. It is now used for:
- YOUR TURN
- NICE!
- FOUL
- STRIKE!
- BALL
- WALK / WALK + RBI
- existing POWER HIT / LUCKY HIT / BASES LOADED messages

The batting mechanics from Phase 8J remain unchanged.

## Test

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8P_lineup_gameplay_polish"
.\play.bat
```

Recommended lineup test:
1. HOME -> PLAY BALL -> LINE UP.
2. Drag a SUBSTITUTE onto batting slot #4 or #5.
3. Confirm that the substitute appears in LINE UP and the old starter appears
   in SUBSTITUTE.
4. Drag a LINE UP player from #4 to #2 and confirm the batting order swaps.
5. Drag a SUBSTITUTE onto the Hero row. It should show the Hero-protection
   message rather than silently failing.
6. Resize the AIR window and repeat the drag test.
