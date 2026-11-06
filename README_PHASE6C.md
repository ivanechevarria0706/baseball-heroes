# Baseball Heroes Remake — Phase 6C

## BASE RUNNERS + BALLS/WALKS + REAL HIT OUTCOMES

Phase 6C is the final major gameplay-foundation pass before the visual reconstruction begins.

### Balls and called strikes
You can now TAKE a pitch.

If the ball reaches the plate without a swing:
- inside the strike zone -> CALLED STRIKE;
- outside -> BALL.

Counts are now real:
- 4 BALLS -> WALK;
- 3 STRIKES -> STRIKE OUT.

The B/S/O lights in the HUD update from the actual count.

### Base runners
The mini diamond now lights occupied bases.

The offensive state tracks:
- runner on first;
- runner on second;
- runner on third.

The bases clear after the third out.

### Hit outcomes
PERFECT and GOOD contact no longer mean one generic hit.

Possible outcomes:
- SINGLE
- DOUBLE
- TRIPLE
- HOME RUN

GOOD contact can also become:
- FLY OUT
- GROUND OUT

POWER affects HR probability.
SPEED affects triples and aggressive runner advancement.
CONTACT and opposing pitcher OVR affect the chance of a GOOD ball becoming an out.

### Runner advancement
- Singles can score runners from second depending on SPEED.
- Doubles can score runners from first depending on SPEED.
- Triples score all existing runners.
- Home runs clear the bases.
- Walks force runners forward and can produce an RBI with bases loaded.

### Individual career stats
Save version:
- Phase 6B: v7
- Phase 6C: v8

Players now persist:
- Doubles
- Triples
- Walks
- existing AVG / HR / RBI / H / AB

### Recommended test
1. Start a game.
2. Do not swing at several pitches.
3. Confirm BALL / CALLED STRIKE and B/S count.
4. Try to draw a WALK.
5. Confirm first base lights up.
6. Get another hit/walk and watch the mini diamond.
7. Get SINGLE / DOUBLE / TRIPLE / HOME RUN outcomes.
8. Confirm runs only score when runners reach home.
9. Get three outs and confirm all bases clear.
10. Close AIR and reopen to verify career stats remain saved.

### Next visual milestone
Phase 7A begins the visual reconstruction layer:
- original-inspired sprite atlas architecture;
- replacement of vector placeholder batter/pitcher art;
- animation state sheets;
- historical UI/layout art pass.

This is deliberately after the gameplay core so we do not have to redraw/reanimate systems that are still changing.

### Compile
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase6C"
.\play.bat
```
