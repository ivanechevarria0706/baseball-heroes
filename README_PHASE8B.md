# Baseball Heroes Remake — Phase 8B
## Simulation screen reference reconstruction

This build focuses on making the simulation between Hero turns much closer
to the uploaded original gameplay.

Changes:
- reference-layout simulation board based on a 640x480 logical canvas;
- field/stadium backdrop;
- 1–9 inning line score;
- left and right 9-player lineup panels;
- row number, position/grade badge, portrait, AVG and result status;
- active batter row highlight;
- direct OUT / STRIKE OUT / 1 BASE HIT / 2 BASE HIT / 3 BASE HIT / HOME RUN stamps;
- center diamond and occupied-base markers;
- functional x4 / x2 / x1 simulation speeds;
- Combo +1/+2 pop animation;
- Leaderboard area;
- both teams now simulate plate appearances player-by-player;
- full 9-inning game flow plus extra innings;
- simulation UI fades out before returning to the Hero;
- four small SFX extracted from the gameplay video supplied by the user.

Compile:
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8B_simulation_reference"
.\play.bat
```

Recommended test:
1. Start a match.
2. The opposing top half should simulate before your Hero reaches the plate.
3. Watch the active row move in each lineup.
4. Click x1/x2/x4 on the right rail and confirm the simulation speed changes.
5. Watch hits/outs stamp directly on player rows.
6. Confirm runners appear on the center diamond.
7. Confirm the 1–9 line score updates.
8. After your Hero turn, confirm both teams continue to simulate until your
   batting slot returns.
9. Listen for result/combo/transition SFX.
