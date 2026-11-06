# Baseball Heroes Remake — Phase 8L
## UI Overhaul: Shop + Match HUD + Lineup polish

This phase continues the visual cleanup after 8K. The goal is to make the
project feel less like a functional prototype and more like the surviving
Baseball Heroes footage.

## What changed

### Match HUD
- Reworked the top resource strip to follow the surviving gameplay layout:
  league badge -> LV/XP -> Energy -> Coins -> premium currency.
- Reworked the central scoreboard and B/S/O indicators.
- Reworked the mini diamond on the upper right.
- Reworked the complete lower batting HUD:
  - circular Combo meter;
  - Hero portrait area;
  - blue name/skill strip;
  - AVG / HR / RBI / HIT boxes;
  - Season Goal box;
  - compact blue Leaderboard / Score panel.
- Energy now displays current/max during gameplay.

### Shop
- Removed the dark generic menu look.
- Added a bright stadium/clubhouse background.
- Added white catalog and item-detail cards with blue/yellow headers.
- Reworked the resource bar.
- Reworked category buttons and item cards.
- Shop cards now have clearer ownership, league-lock, grade and slot states.
- Pagination from 8F remains intact.

### Line Up
- Increased contrast between LINE UP and SUBSTITUTE.
- Added brighter panel headers and subtle highlights.
- Improved the bottom team-comparison card.
- Fixed an old visual data bug where the rival name could render as
  `undefined`; it now uses `opponent.teamName`.

### Global buttons
The improved 8K `UIButton` remains active across the project, with gradient,
inner highlight, border, hover and pressed states.

## Gameplay
All batting changes from Phase 8J remain included. This phase primarily
changes presentation and does not revert the harder pitch-reading mechanic.

## Run
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8L_ui_overhaul"
.\play.bat
```

## Recommended checks
1. HOME -> PLAY BALL -> LINE UP.
2. Confirm both lineup columns are readable and the rival team name is valid.
3. Start a game and compare the top/bottom HUD to the original gameplay.
4. HOME -> SHOP and inspect Equipment, Stadium and Energy categories.
5. Test PREV/NEXT in SHOP -> STADIUM.
6. Hover and press buttons throughout the game.
