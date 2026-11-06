# Baseball Heroes Remake — Phase 8S
## Animation + Visual Integration Audit

This phase is a corrective audit of Phase 8R rather than a feature dump.
The user reported that some announced animations (especially Double / Triple)
were not actually being seen and supplied a Team-screen screenshot showing
visual problems in the new roster portraits.

## Confirmed issue 1 — Double / Triple cinematics could be skipped before appearing

The gameplay enters `PHASE_RESULT` immediately after contact. The comic result
for a hit was not drawn until frame 43 of `HitCinematic`, but ENTER was already
accepted during `PHASE_RESULT`.

That meant a normal fast ENTER press could call the next batter/pitch and
`startPitch()` would clear the cinematic before the `TWO BASE HIT` or
`THREE BASE HIT` panel ever became visible.

### Fix

- The first ENTER while the cinematic is still running now fast-forwards to
  the comic/result beat instead of leaving the result screen.
- A short hold remains after the fast-forward so a double-tap cannot erase the
  result immediately.
- ENTER is accepted normally only after the cinematic reaches its continue
  window.
- An `ENTER TO CONTINUE` prompt appears when it is safe to continue.
- Hit cinematics are moved above HUD/callout layers while playing.
- Supplied celebration panels now fade/scale into place instead of appearing
  as a single static frame.

Expected sequence for a Double:

```
CONTACT
  -> ball flight
  -> outfield cutaway
  -> supplied celebration panel animates in
  -> TWO BASE HIT
  -> ENTER TO CONTINUE
```

Triple and Home Run use the same protected flow.

## Confirmed issue 2 — supplied roster art was layered over the old vector face

The Team screenshot showed doubled eyes, helmets and bodies on roster cards.
Phase 8R intentionally drew the vector fallback first and then loaded the PNG
over it. Because the supplied PNG has transparent areas, the old vector face
remained visible through/around it.

### Fix

For a non-Hero player with a packaged supplied portrait:
- the game checks that the asset exists;
- it draws a clean portrait frame/background;
- it loads the supplied character art;
- it does NOT draw the old vector face underneath.

If the PNG is genuinely missing, the vector portrait still works as fallback.

## Confirmed issue 3 — small vector Hero portraits overflowed their card bounds

The old vector face used hardcoded facial/helmet dimensions even when a
`CharacterPortrait` was only 42x35 pixels. This allowed the Hero portrait to
spill into the name/stat area of a PlayerCard.

### Fix

Vector portraits are now drawn at a stable 86x78 design size and the complete
portrait is scaled into the requested rectangle. This keeps the customizable
Hero inside small roster cards while preserving the larger Team/Equipment
portrait appearance.

## Build asset preflight

`build/build.bat` now verifies that key Phase 8R/8S assets were actually copied
into the AIR build directory. A build now fails with a clear message if roster
portraits, celebration panels or card-pack art are missing instead of silently
running without them.

## Save compatibility

No persistent data format change is required. Phase 8S remains compatible with
Save v16.

## Test

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8S_animation_visual_fix"
.\play.bat
```

Recommended checks:

1. HOME -> TEAM.
   - Andrew/Benjamin/Julia/etc. should show one clean supplied character image,
     not the supplied image over a second vector face.
   - Ivan/Hero should stay inside his card frame.
2. Play until a Double or Triple.
   - Do not press ENTER and verify the full cinematic appears.
   - Then test pressing ENTER early: the first press should reveal/fast-forward
     to the hit result, not skip it.
   - `ENTER TO CONTINUE` should appear before the second ENTER advances.
3. Verify Home Run / Grand Slam art uses the same protected flow.
