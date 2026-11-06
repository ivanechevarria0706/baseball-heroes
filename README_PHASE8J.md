# Baseball Heroes Remake — Phase 8J
## Batting Authenticity / Pitch Reading

This phase returns to the manual Hero at-bat and addresses the biggest
remaining difference in feel: the batter should not feel static or automatic.

The control scheme remains the historically supported one-button mechanic:
CLICK ANYWHERE or SPACE to swing. There is no modern mouse-aim cursor.

## Changes
- Hero visibly loads his stance while the pitch approaches:
  - front-foot load;
  - torso coil;
  - head tracking;
  - bat cocks backward instead of staying fixed.
- Mouse click and SPACE now use the exact same timing path.
  - The old 85 ms mouse-only delay was removed.
- The yellow/cyan timing reticle no longer reveals the final pitch location
  immediately after release.
  - It fades in during the second half of the flight.
  - Better Contact helps recognition slightly.
  - better pitchers / higher leagues reveal it later.
- Pitch type and MPH are hidden during flight.
  - You must read the ball visually.
  - Type/speed are shown only after the pitch resolves.
- Timing windows now scale with:
  - Hero Contact;
  - opposing pitcher OVR;
  - league difficulty.
- PERFECT / GOOD / FOUL / MISS windows were tightened.
- Pitch movement was corrected so breaking pitches still finish at the actual
  yellow target / strike-zone endpoint.
  - Previous sinker/curve math could visibly finish dozens of pixels away from
    the target while the rules judged the hidden endpoint.
- Pitch selection reacts to the count:
  - 3-ball counts attack the zone more often;
  - 2-strike counts favor breaking pitches when available.
- Hit power now also considers how close the swing was to ideal contact,
  reducing easy extra-base hits on marginal GOOD swings.
- Save v15 migration.

## Test
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8J_batting_authenticity"
.\play.bat
```

Recommended checks:
1. Enter a Hero at-bat and do not swing on the first pitch.
2. Notice that pitch type/MPH are not shown until the pitch finishes.
3. Watch the Hero: bat/legs/torso should load as the ball approaches.
4. Compare click and SPACE — neither should have a hidden timing advantage.
5. Try swinging well before the cyan ring converges: EARLY SWING.
6. Try waiting too long: LATE SWING / strike.
7. Observe Curveball / Slider / Sinker paths: the ball should finish on the
   same target point the reticle marks.
8. Higher-level pitchers should feel harder without adding manual aiming.
