# Phase 8S v3 — auto-advance gameplay flow hotfix

User-reported issue:
- the hit result card stayed superimposed on the gameplay;
- the flow felt wrong because it suggested pressing ENTER, while the original
  Baseball Heroes cadence should continue automatically after the result beat;
- Double / Triple celebrations needed to remain visible without being blocked
  or waiting for manual confirmation.

Changes:
- `Game.as` now updates `PHASE_RESULT` every frame and automatically continues
  after the result beat finishes;
- cinematic results wait until `HitCinematic.canContinue()` and then hold
  briefly before advancing automatically;
- walk / non-cinematic result states also auto-advance after a short delay;
- ENTER still works as an optional skip / fast-continue input;
- `HitCinematic.as` no longer shows the misleading `ENTER TO CONTINUE` prompt.

Expected behavior:
1. Hit or out occurs.
2. Result animation/cinematic plays completely.
3. Double / Triple / HR celebration art remains visible long enough to read.
4. The game automatically returns to the next batter/pitch.
