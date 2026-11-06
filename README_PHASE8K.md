# Baseball Heroes Remake — Phase 8K
## Interface Polish / Visual Cleanup

This phase focuses on the biggest remaining complaint after the gameplay fixes:
the interface still felt too rough, dark, and placeholder-like.

## Main goals
- make the UI brighter and closer to the visual spirit of the original game;
- reduce the feeling of generic placeholder panels;
- keep the current playable systems intact;
- stop emphasizing the old Facebook-friends area, since that feature is no
  longer needed for this offline remake.

## Changes
- Reworked `UIButton` to look more like a game UI button instead of a flat test
  button.
  - gradient fill;
  - inner highlight;
  - better border and shadow;
  - cleaner sizing for large and small labels.
- Reworked `LobbyScreen`:
  - cleaner stadium backdrop;
  - better top resource bar;
  - more structured left navigation rail;
  - cleaner Hero panel on the right;
  - the old `FRIENDS / TEAM HELP` area is now a `SEASON TRACK` strip that fits
    the offline remake better.
- Reworked `SeasonRoadmapScreen`:
  - large central content panel;
  - clearer matchup cards;
  - larger current-match detail area;
  - cleaner coach/help panel;
  - footer buttons stay visible and less cramped.
- Reworked `LineupScreen`:
  - cleaner stadium + panel contrast;
  - stronger visual split between `LINE UP` and `SUBSTITUTE`;
  - clearer bottom comparison card;
  - better instruction copy.
- Reworked `EquipmentScreen`:
  - cleaner panel headers;
  - more arcade-like category tabs;
  - clearer inventory / preview / details separation.

## Scope
This phase is mainly visual.
It does **not** replace the underlying gameplay flow introduced in Phase 8J.
All batting-authenticity changes remain included.

## Test
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8K_interface_polish"
.\play.bat
```

Recommended checks:
1. Open HOME and verify the new `SEASON TRACK` area.
2. Enter `1ST REGULAR SEASON` and verify cards/details/buttons are all visible.
3. Open `LINE UP` and verify left/right panels are easier to read.
4. Open `EQUIPMENT` and verify each category tab is readable.
5. Hover buttons throughout the UI and verify the updated button look.
