# Baseball Heroes Remake — Phase 6B

## PREGAME + REAL BATTING ORDER + BATTER ROTATION

Phase 6B turns the batting mode from a single-player batting loop into a team batting game.

### Pregame Matchup
HOME -> PLAY BALL no longer spends Energy immediately.

It opens GAME PREVIEW with:
- current season game / record;
- your team vs opponent;
- rival pitcher name and OVR;
- pitcher repertoire;
- current 1-9 batting order;
- active main-player skill;
- explicit `PLAY BALL! -1 E`.

Energy is consumed only when the user actually starts the game.

### Persistent batting order
New persistent `GameData.battingOrder`.

TEAM -> LINEUP opens a dedicated batting-order editor.

Features:
- select slots 1-9;
- click a roster player to swap them into that slot;
- MOVE UP;
- MOVE DOWN;
- AUTO OPTIMIZE;
- roster pagination.

Newly scouted players can therefore become actual starters.

### Real batter rotation
The batting game now cycles through the full 1-9 order.

A plate appearance ends on:
- PERFECT hit;
- GOOD hit;
- strikeout.

FOUL and non-third-strike MISS keep the same batter.

After an at-bat:
ENTER -> next hitter.

Each hitter uses their own:
- name;
- level;
- POWER;
- CONTACT;
- SPEED;
- equipment-effective stats;
- active skill;
- card accent / uniform color;
- career AVG / HR / RBI.

The HUD now shows:
- current hitter;
- active skill;
- next hitter;
- current hitter career stats;
- game hits for the current hitter.

### Per-player career stats
Game results are now distributed to the hitter who actually batted.

`GameData.recordPlateAppearance()` updates:
- career AB;
- career H;
- AVG;
- HR;
- RBI.

The old behavior that credited the entire game to Ivan has been removed.

### Save migration
Save version:
- Phase 6A: v6
- Phase 6B: v7

Existing saves automatically receive a valid nine-player batting order.
All previous roster, skills, equipment, stadium and season data remains compatible.

### Suggested test
1. HOME -> TEAM -> LINEUP.
2. Move Andrew to #1 and Ivan to #2.
3. BACK -> HOME -> PLAY BALL.
4. Confirm GAME PREVIEW displays the new order.
5. Start game.
6. Complete Andrew's plate appearance.
7. Press ENTER.
8. Confirm Ivan becomes the next batter.
9. Continue until several players rotate.
10. End the game and return TEAM.
11. Confirm player AVG/HR/RBI belong to the individual hitters.
12. Close AIR and reopen; confirm batting order persists.

### Compile
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase6B"
.\play.bat
```
