# Baseball Heroes Remake — Phase 8T
## Game Modes + Home Run Derby

This phase continues after the Phase 8S v4 gameplay-flow fixes.

### New MODE HUB
HOME now has a red `MODES` button. The new screen uses the supplied original
mode artwork for:
- Regular Season
- Home Run Derby
- Post Season
- All Star
- World Match
- Special Match

Regular Season remains fully connected to the existing 30-game flow.
Home Run Derby is playable in this phase. The remaining historical modes are
visible but marked COMING SOON until their actual rules are implemented.

### Home Run Derby
- 10 pitches.
- The same READY behavior from Phase 8S v4 is used:
  - first CLICK / SPACE starts the pitch;
  - second CLICK / SPACE during flight swings.
- Timing + Hero POWER/CONTACT determine HR chance and distance.
- PERFECT contact increases distance.
- Automatic transition after every result; no ENTER required.
- Final result shows Home Runs, best distance, and a Coin reward.

### Test
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8T_modes_home_run_derby"
.\play.bat
```

Then:
`HOME -> MODES -> HOME RUN DERBY`
