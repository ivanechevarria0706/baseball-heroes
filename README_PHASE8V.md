# Baseball Heroes Remake — Phase 8V
## Season Timeline + Travel Reconstruction

Phase 8V continues the first-gameplay reconstruction after Phase 8U.
The focus is the regular-season carousel seen after completed games and before
traveling to the next opponent.

## Season schedule reconstruction

The old generic upcoming-opponents panel has been replaced with a horizontal
season road containing seven visible game cards.

Each card can now be:
- `WIN` — completed victory, with score when available;
- `LOSS` — completed defeat, with score when available;
- `NEXT MATCH` — the current playable matchup;
- `LOCKED` — a future matchup.

Completed cards remain visible after returning from a game, so the season now
has the visual history seen in the first gameplay instead of replacing every
match with a fresh generic card row.

The `<` and `>` buttons browse the 30-game regular season without changing the
actual current matchup.

## Persistent season results

Save format is now version 18.

A new `seasonResults` array stores:
- game number;
- win/loss;
- home score;
- away score;
- opponent city/team/accent.

Old saves are migrated. Because Phase 8U and earlier only stored a short W/L
history, older games may appear as `WIN`/`LOSS` with `SCORE --`; the most recent
result keeps its real score when it was available in `lastGameSummary`.
New games always save the complete score.

## Travel presentation

The travel screen keeps the league-specific vehicle system from Phase 8U and
adds:
- both team logos;
- current game number;
- opponent OVR and pitcher;
- travel percentage;
- automatic arrival into Line Up.

League transports remain:
- Rookie -> small bus;
- Single-A -> bus;
- Double-A -> coach;
- Triple-A -> plane;
- Major -> large airliner.

## Test

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8V_season_timeline"
.\play.bat
```

Recommended:
1. HOME -> PLAY BALL.
2. Browse the season cards using `<` and `>`.
3. Click an old WIN/LOSS card and inspect its detail line.
4. Play the current game and finish it.
5. Return to the season schedule: the game just completed should now remain as
   a persistent WIN or LOSS with its score.
6. Select LINE UP / continue the match flow and inspect the upgraded travel
   screen.
