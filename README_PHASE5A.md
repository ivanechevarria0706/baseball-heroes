# Baseball Heroes Remake — Phase 5A

## Season / League Progression

This phase extends the reviewed v2 project with a persistent season loop.

### Historical basis
Recovered Baseball Heroes material describes:
- five league levels: Rookie, Single-A, Double-A, Triple-A, Major;
- 30-game seasons;
- playoffs for high-ranking teams;
- progression toward Major League.

The exact original server-side promotion formula has not been recovered.
This remake currently uses an approximation:
- top-four finish;
- at least 18 wins;
- promotion by one league level.

That rule is intentionally isolated in `GameData.completeSeasonGame()` so it
can be replaced later if the original formula is recovered.

## New systems

- 30-game regular seasons.
- Persistent W-L record.
- Persistent league level.
- Dynamic team rank.
- Last-six W/L history in the HOME season strip.
- Energy cost: 1 per season game.
- Three-inning playable games plus extra innings on a tie.
- Simulated rival scoring.
- Post-game Victory / Defeat result panel.
- Coin + account XP rewards.
- Season HIT / RBI objectives update from played games.
- Main player career AVG / HR / RBI updates.
- Save migration from v2 to v3.
- Season state persists through AIR `SharedObject`.

## Flow

HOME
-> PLAY BALL
-> 3-inning batting game
-> extra inning if tied
-> VICTORY / DEFEAT
-> rewards
-> RETURN HOME
-> next regular season game

## Compile

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase5A"
.\play.bat
```

Or:

```powershell
.\build\build.bat
.\build\run-air.bat
```

## Recommended test

1. Start from HOME.
2. Note Energy and `Regular Season (1 of 30)`.
3. Click PLAY BALL.
4. Play until three innings complete.
5. Verify the result screen.
6. Return HOME.
7. Confirm:
   - Energy decreased by 1.
   - Season game advanced.
   - W-L updated.
   - Rank updated.
   - HIT/RBI goals updated.
   - Coins/XP increased.
8. Close AIR and reopen it.
9. Confirm season progress is still present.
