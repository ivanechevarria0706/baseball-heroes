# Simulation-between-turns analysis

Source:
`Facebook - Baseball Heroes - No doy una.mp4`

The simulation portion was inspected at 30 fps, especially the sequence
around 4:19–4:27.

## Layout observations

The original simulation does not use a generic modal.

It retains a full baseball-field background and places:

- a 1–9 inning line score across the top;
- the player's nine-man lineup on the left;
- the opponent's nine-man lineup on the right;
- large blue/gray team headers and total scores;
- row numbers, position/grade badges, portraits, names and AVG;
- a center diamond with inning/out state;
- a x4 / x2 / x1 simulation speed rail on the right;
- a Combo/Max gauge at lower left;
- Leaderboard Score at lower right.

Results are stamped directly over the active row with colorful text such as
OUT, STRIKE OUT, or BASE HIT.

The active batting row is highlighted while the simulation advances rapidly.

## Flow observations

At x4, a plate appearance resolves roughly every 0.45–0.55 seconds.

The simulation includes both teams, not only the player's teammates.

After the player's manual plate appearance:
1. remaining teammates are simulated;
2. the opposing half-inning is simulated player-by-player;
3. the next home half-inning continues;
4. the game stops again when the Hero's batting slot is reached.

The original line-score display contains all nine regulation innings.
Phase 8B therefore changes the remake from its old three-inning shortcut to
nine innings plus extras.

## Transition back to batting

Near the end of the inspected sequence:
- lineup panels disappear;
- the empty field is visible briefly;
- the batter returns to the batting camera.

The new TeamSimulationPanel fades its UI layer before the Hero batting screen
is revealed.

## Small sounds

Four short SFX were isolated from the USER-SUPPLIED gameplay recording:

- `sim_result.mp3`
- `sim_combo.mp3`
- `sim_transition.mp3`
- `sim_hero_in.mp3`

The extraction uses transient/percussive separation to reduce the background
music in the capture. These are sourced from the gameplay file provided by
the user, not downloaded from SoundCloud.
