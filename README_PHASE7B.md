# Baseball Heroes Remake — Phase 7B

## FIDELITY CORRECTION + AUDIO HOOKS

This phase changes the match flow to better match surviving descriptions of
the original Baseball Heroes gameplay.

## Major gameplay correction

The user no longer manually controls every hitter in the 1–9 batting order.

The batting order still matters, but:

- teammates are simulated quickly;
- their hits, walks, outs, runners and RBI still use the game engine;
- when the user's Hero reaches the plate, the simulation stops;
- a `YOUR TURN` transition appears;
- only the Hero is controlled manually;
- after the Hero's plate appearance, teammate simulation resumes.

This preserves the lineup/team systems we built while making the actual
playing loop much closer to Baseball Heroes.

## LUCK

The original game is historically described around:
- POWER
- CONTACT
- LUCK

Phase 7B adds persistent `luck` to players.

The UI now surfaces:
- POWER
- CONTACT
- LUCK

SPEED remains internally available for runner simulation and defense.

LUCK affects:
- teammate simulation;
- walk probability;
- favorable hit outcomes;
- some extra-base / home-run probability.

Training now exposes LUCK instead of SPEED.

Save version:
- Phase 7A: v8
- Phase 7B: v9

Legacy players receive a migrated LUCK value derived from CONTACT and SPEED.

## Audio architecture

The game now contains `AudioManager.as`.

IMPORTANT:
The original Baseball Heroes tracks are NOT bundled in this project.

The Kevin Lee SoundCloud playlist is marked `all rights reserved`.
The project therefore only provides optional local audio hooks.

If you lawfully obtain / have permission to use the files, place:

- `assets/audio/baseball_heroes.mp3`
- `assets/audio/locker_room.mp3`
- `assets/audio/shop.mp3`

The build script copies `assets` into the AIR build directory automatically.

Missing music files are safe: the game simply stays silent.

## Screen music mapping

- HOME / PREGAME -> `baseball_heroes.mp3`
- TEAM / TRAINING / SCOUT / SKILLS / EQUIPMENT / BUILD -> `locker_room.mp3`
- SHOP -> `shop.mp3`
- BATTING -> music stops for now

## Suggested test

1. TEAM -> LINEUP.
2. Put Ivan somewhere other than #1.
3. HOME -> PLAY BALL.
4. Start the game.
5. Confirm the game displays `TEAM AT BAT`.
6. Watch teammates get simulated results.
7. Confirm runners / score / outs change.
8. When Ivan's position arrives, confirm `YOUR TURN`.
9. Bat manually only as Ivan.
10. End Ivan's plate appearance.
11. Press ENTER.
12. Confirm simulation resumes until Ivan bats again.
13. TRAINING -> confirm POWER / CONTACT / LUCK are shown.
14. Close/reopen and confirm LUCK persists.

## Compile

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase7B"
.\play.bat
```
