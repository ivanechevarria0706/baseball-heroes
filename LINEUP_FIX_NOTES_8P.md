# Lineup Drag/Drop fix — technical notes

Reported symptom:
- the row could be dragged visually;
- releasing it over LINE UP appeared to do nothing.

Changes:
1. Drop hit-testing now uses `stageX/stageY` and `globalToLocal`.
2. New `GameData.substituteBattingOrder(slot, player)` performs an explicit,
   validated bench-to-lineup replacement and saves immediately.
3. New LINE UP -> LINE UP drag uses the existing persistent
   `GameData.moveBattingOrder(from, to)` swap.
4. Added drop-target highlight.
5. Added short click suppression after a real drag so the following CLICK event
   does not undo or duplicate the drag action.
6. Added clear result messages for OK / HERO / ALREADY / FAILED.
7. Kept Hero active-lineup protection because `Game` identifies manual batting
   turns by matching the current batting-order player to `GameData.mainPlayer()`.
