# Baseball Heroes Remake — Phase 8D
## Interface Archaeology Pass

This build returns to the first 19-minute gameplay video and reconstructs the
large interface/progression systems that were still missing.

New:
- HOME/stadium interface rebuilt toward the original bright layout;
- TEAM SELECTION USA-map screen;
- CHARACTER MAKING with Shape/Hair/Eyes/Nose/Mouth tabs and palettes;
- persistent team city, team name and uniform number;
- Rookie Season GOAL SETTING with Spin The Wheel;
- persistent season HR/RBI goals and progress;
- SCOUT replaced by THE NEW DRAFT BEGINS! 25-player board;
- MISSIONS screen with three mission categories and claimable rewards;
- daily Gate Income collection tied to stadium growth;
- Hero appearance color choices now propagate into portraits/batting model;
- existing World54 clean SFX, batting, simulation, Special Batter Cards,
  stadium, music and 9-inning flow preserved.

Run:
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8D_interface_archaeology"
.\play.bat
```

On the first launch of v11, the old save is migrated and the new Season Goal
Setting screen appears once. Spin/accept the goal, then HOME opens.

Recommended checks:
1. Goal Setting -> SPIN -> ACCEPT.
2. HOME -> inspect bright stadium layout and season-goal progress.
3. Left LEAGUE icon -> Team Selection map -> choose a city.
4. Left HERO icon -> Character Making -> change hair/eye/skin color -> SELECT.
5. NAME -> rename team and change uniform number.
6. DRAFT -> reveal numbered cards -> SIGN one player.
7. MISSIONS -> verify Draft mission progress updates.
8. COLLECT Gate Income -> verify Coins rise and stadium mission progress.
9. Start a game and confirm prior Phase 8C gameplay/simulation still works.

See `FIRST_GAMEPLAY_INTERFACE_ANALYSIS.md` for the video-derived gap analysis.
