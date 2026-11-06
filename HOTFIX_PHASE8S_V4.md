# Phase 8S v4 — Simulation overlay + manual pitch start

This hotfix follows another frame-by-frame review of the uploaded gameplay.

## Fixed: hit image remained over the between-turn simulation

Cause:
The result cinematic was cleared by `startPitch()`, but not by every transition
into TeamSimulationPanel. A third out was an especially bad path because
`endPlayerInning()` could start rival simulation immediately while the hit/out
cinematic was still visible.

Fix:
- all simulation entry points clear the hit result layer first;
- result flow clears the cinematic before changing batter/state;
- third-out inning transitions are deferred until the cinematic has finished.

Expected:
`DOUBLE / TRIPLE / HOME RUN / OUT -> result -> clean simulation board`.
The comic/result image must never remain on top of the between-turn simulation.

## Fixed: pitcher should wait for the player's ready input

The gameplay shows a ready batting view between pitches. The pitcher does not
immediately chain another pitch.

New flow:
1. Previous pitch result ends automatically.
2. Batter/pitcher return to the ready view.
3. Game waits indefinitely.
4. One CLICK anywhere or one SPACE starts the pitcher's windup.
5. Once the ball is in flight, CLICK / SPACE performs the swing as before.

A new internal `READY` phase separates:
- READY input = start pitch
- FLIGHT input = swing

The first pitch after `YOUR TURN` follows the same rule.

ENTER is not required. It remains only as an optional cinematic skip.
