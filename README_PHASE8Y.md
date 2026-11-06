# Baseball Heroes Remake — Phase 8Y
## Match Entry + Postgame Reconstruction

This phase continues the first-video fidelity pass.

## Match entry
The Match Intro now finishes with a short flaming-baseball transition before
the actual game starts. This follows the bright baseball/flash transition seen
between Line Up / VS and gameplay in the uploaded first video.

Flow:
`LOADING -> VS -> BALLPARK -> FLAMING BASEBALL -> GAME`

## Postgame result
The old generic result card was rebuilt to sit over the live stadium instead of
feeling like a detached menu. It now includes:
- YOU WIN / YOU LOSE header;
- league badge;
- both team logos;
- large final score;
- real per-inning run line collected by Game.as;
- Hero HIT / HR / RBI performance;
- animated performance Rank;
- animated Coins / XP reward count-up;
- season record and standing;
- compact right-side leaderboard;
- HOME and NEXT MATCH navigation.

If the player leveled up, Level Up now appears after the result has been visible
briefly instead of covering it immediately.

## Fidelity note
The exact historical formula for the postgame letter Rank has not been
recovered. Phase 8Y therefore uses an explicit reconstructed performance grade
based on win, hits, home runs and RBI.

## Test
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8Y_result_match_presentation"
.\play.bat
```

Check:
1. Line Up -> Play.
2. Watch the end of the intro for the flaming baseball transition.
3. Finish a full game.
4. Verify the stadium remains visible behind the result board.
5. Verify inning-by-inning runs appear instead of all dashes.
6. Verify Rank and rewards animate automatically.
