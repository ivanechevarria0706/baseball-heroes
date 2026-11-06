# Baseball Heroes Remake — Phase 8N
## Gameplay Visual Reconstruction

This phase focuses on the actual batting view. The previous phases improved the
mechanics and menu UI, but the match itself still looked too dark and generic.

The batting camera was compared against the surviving gameplay reference frame
where the Hero is large in the left foreground, the pitcher is distant at the
center, the stadium is bright and resort-like, the scoreboard sits above center
field, and the top/bottom HUD is compact and colorful.

## Stadium / batting camera

- Replaced the old dark indoor-looking stadium with a bright outdoor park.
- Added blue sky and layered clouds.
- Added distant mountains and a cream center-field clubhouse / hotel silhouette.
- Added center dome, windows and arch details.
- Added palm trees around center field.
- Added white side grandstand structures and colorful crowd dots.
- Added a central scoreboard in front of the clubhouse.
- Added flood-light banks.
- Added sponsor panels on the outfield wall.
- Added brighter grass, mowing bands, dirt perspective, foul lines and batter boxes.
- Added four static rival fielders so the world no longer feels empty between the
  foreground batter and pitcher.
- Existing stadium customization colors are still respected for background,
  field, stand, fence, banner, lights and scoreboard slots.

## Gameplay HUD

- Reworked the top ribbon toward the bright original hierarchy.
- League badge is larger and cream/blue rather than floating on a dark field.
- LV/XP and Energy use clearer arcade-style capsules.
- Coins and premium currency are lighter and easier to read.
- Added small offline decorative action pills instead of monetization controls.
- Rebuilt the center scoreboard with team emblems, records, score digits,
  inning and B/S/O.
- Reworked the upper-right mini field/base diamond.
- Added an original-inspired settings square.
- Rebuilt the lower player card on a light gray panel.
- Replaced the placeholder bottom portrait with the project's CharacterPortrait.
- Combo, AVG/HR/RBI/HIT, Season Goal and Leaderboard remain visible.

## Hit cinematics

- Reworked the ball-flight cutaway with a larger perspective baseball.
- Added stronger radial speed lines.
- Added a stadium/sky transition before the result.
- Added a chibi outfielder/comedy catch panel for outs.
- Reworked ONE BASE HIT / TWO BASE HIT / THREE BASE HIT / HOME RUN /
  GRAND SLAM result splashes with comic radial bursts.
- HOME RUN can now display both distance and runs in the cinematic.

## Not changed

The Phase 8J batting timing and pitch-reading mechanic is preserved. This is a
visual reconstruction pass; it does not make batting easier again.

## Run

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8N_gameplay_visual_reconstruction"
.\play.bat
```

Recommended checks:
1. Enter a game and compare the bright stadium composition to the gameplay.
2. Let several pitches pass and verify the reticle/timing behavior is unchanged.
3. Get a single, double/triple, home run and an out to inspect the new cutaways.
4. Verify the top scoreboard and lower player card remain fully visible with the
   Phase 8H scale-to-fit fix.
