# Gameplay analysis from the uploaded Baseball Heroes video

Source: `Facebook - Baseball Heroes - No doy una.mp4`

Metadata observed locally:
- 640x480
- 30 fps
- ~19:03 duration

## Batting mechanic

The uploaded video resolves the main ambiguity in our previous recreation.

### The circular element is a timing reticle, not a mouse-aim cursor

The batting tutorial shows:
- a small translucent 3x3 strike grid;
- a yellow target circle/cross at the projected pitch location;
- a much larger cyan ring around it;
- the cyan ring shrinks toward the yellow target as the ball approaches;
- the tutorial explicitly displays `CLICK ANYWHERE!`.

Therefore Phase 8A removes the experimental mouse-aim mechanic. The user does
not drag the target onto the ball. The difficulty comes from reading pitch
location/break and timing the swing as the shrinking rings converge.

### Pitch location must be independent

An important error in our earlier versions was generating pitch endpoints
around the batting reticle. This made contact too easy.

The pitcher now selects an independent target:
- strikes at different locations in the grid;
- balls outside the grid;
- pitch break is layered over that target.

### Timing

Frame-by-frame inspection at 30 fps shows the timing ring becomes prominent
in roughly the second half of the pitch and converges very near plate arrival.
The remake now uses an ideal contact point around 92.5% of pitch travel and
significantly tighter windows.

### Ball perspective

The incoming ball grows dramatically in the last third of its flight. The
remake now uses nonlinear scale growth instead of a mild linear scale.

### Feedback

The uploaded video visibly uses feedback such as:
- NICE!
- STRIKE + EARLY SWING
- STRIKE + LATE SWING
- STRIKE OUT
- TWO BASE HIT
- THREE BASE HIT
- HOME RUN
- FLY OUT

Phase 8A changes the presentation to this vocabulary and style.

## Between Hero at-bats

The original does not use a small generic simulation dialog. It displays a
large matchup board with:
- the user's 1-9 lineup at left;
- rival lineup at right;
- batting averages;
- central baseball diamond;
- inning/out state;
- top line score;
- x4/x2/x1 simulation-speed controls at the right.

`TeamSimulationPanel` has been redesigned around that structure.

## HUD

The batting HUD in the video is bright and compact rather than a dark modern
HUD. It contains:
- Rookie/league badge;
- LV/XP;
- energy;
- Coins and premium currency;
- center scoreboard and B/S/O;
- mini field at upper-right;
- Combo gauge at bottom-left;
- Hero portrait/name;
- Skill / stats;
- AVG / HR / RBI / HIT;
- Season Goal;
- Leaderboard Score.

Phase 8A redraws the batting HUD around this hierarchy.

## Hit presentation

Balls in play often cut away from the batting camera:
1. sky view with a huge spinning baseball and speed lines;
2. outfield/fielder shot;
3. comic-style result splash.

`HitCinematic.as` adds an original replacement version of that sequence.

## Character scale / camera

The original batting view uses a very large batter in the left foreground and
a much smaller distant pitcher. Phase 8A adjusts both scales/positions to
better match that framing.
