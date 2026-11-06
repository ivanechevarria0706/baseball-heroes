# Baseball Heroes — First Video Final Audit
Reference: `Facebook - Baseball Heroes - No doy una.mp4`
Duration reviewed: ~19:03

This audit was made from the actual uploaded gameplay, using a 5-second contact
sheet plus targeted high-resolution frames around important flows.

## 0:00–2:05 — onboarding

### Team Selection
Observed:
- USA map with location pin;
- dense grid of team logos below;
- selected club crest / mascot on the right;
- confirmation before continuing.

Remake:
- implemented in Phase 8U with supplied team logos.
- still worth polishing typography and exact map proportions later.

### Character Making
Observed:
- Shape / Hair / Eyes / Nose / Mouth tabs;
- item grid on left;
- large Hero preview on right;
- small color palette popup for editable parts;
- green confirm button.

Remake:
- functional but still less visually exact than the video.
- this remains one of the larger visual gaps.

### Arrival / first HOME tutorial
Observed:
- short loading transition;
- HOME appears with Coach callout pointing at PLAY BALL.

Remake:
- first-game sequence reconstructed in 8U.

## 2:20–2:50 — season setup

Observed:
- ROOKIE GOAL SETTING modal;
- goal choice is confirmed;
- horizontal five-card regular-season route;
- NEXT is tutorial-highlighted;
- travel map appears before Line Up.

Remake:
- goal system exists;
- season timeline rebuilt in 8V;
- transport-by-league rebuilt in 8U/8V.

## 2:55–3:30 — Batter Shop / card pack tutorial

This sequence is now considered fully analyzed.

Observed exact shop structure:
- BATTER SHOP is a modal over Line Up;
- two tabs: SPECIAL and REGULAR;
- SPECIAL shows three visible packs:
  - C Pack — 6,000 Coins;
  - B+ Pack — 25 premium currency;
  - A+ Pack — 56 premium currency.
- tutorial explicitly buys the C Pack;
- after purchase, a large `BASEBALL HEROES Class C Card Pack` appears;
- one click opens it;
- the revealed batter is `Lenard J.`;
- visible card details include:
  - Class C;
  - AVG .253;
  - 4th-inning / 1B ability text;
  - Combo +1;
- result modal has SHARE and OKAY;
- SHARE belongs to the old Facebook layer and is intentionally omitted here;
- closing the shop returns to the same Line Up screen;
- the newly obtained special batter becomes part of the team-management flow;
- tutorial then demonstrates changing batting order / AUTO SORT.

Phase 8X reconstruction:
- Batter Shop is once again an overlay on Line Up instead of a separate page;
- C / B+ / A+ pack prices match the video;
- first Class C purchase guarantees Lenard J. if not already owned;
- pack requires CLICK / SPACE to open;
- reveal screen requires OKAY / SPACE / ENTER;
- supplied league pack artwork is used on the REGULAR tab;
- Team -> Cards opens the same Batter Shop overlay.

Remaining difference:
- the remake's Special Batter system is card-centric, while the original UI
  also presents recruited special batters very directly inside team/bench
  management. Further Line Up integration can still be improved.

## 3:35–6:20 — first match

Observed:
- VS splash;
- automatic 1–9 simulation panel;
- simulation stops on the user's Hero turn;
- pitching view waits on the batter;
- early / late / strike / ball instructional callouts;
- hit camera cuts:
  - ball against sky;
  - fielding / running cutaways;
  - comic overlays such as ONE BASE HIT;
- HOME RUN has its own bold comic splash;
- after the Hero's result, game returns to simulation automatically.

Remake:
- core flow now matches substantially after 8J + 8S v4;
- READY input before every pitch was corrected;
- hit overlays now auto-clear before simulation;
- supplied comic panels are integrated.
Remaining:
- individual fielding camera cuts are still simplified;
- HOME RUN splash can be made closer to the exact original composition.

## 6:20–7:10 — result / Level Up / Skill Point tutorial

Observed:
- result card is over the stadium, not a separate disconnected page;
- scoreboard, Hero stats and Rank are compact;
- Level Up modal awards items / Coins / Skill Point / Max Energy;
- immediately afterward, Coach points to the Hero and teaches spending a
  Skill Point from HOME.

Remake:
- Level Up exists;
- Skill screen exists;
- exact post-Level-Up guided Skill Point tutorial is still missing;
- result UI still needs one more fidelity pass.

## 7:10–8:40 — Draft + naming

Observed:
- THE NEW DRAFT BEGINS;
- 5x5 draft board;
- progressive reveal / selection;
- tutorial completion;
- NAME YOUR TEAM modal.

Remake:
- both flows implemented.
Remaining:
- draft reveal animation and exact card treatment can be polished.

## 8:45–12:20 — Missions / Build / Shop / Roadmap

Observed:
- manager/mission dialogue;
- Mission panel;
- BUILD keeps the stadium visible while Shop/Inventory stays at bottom;
- repeated instant stadium visual changes;
- Shop / Inventory equipment progression;
- Mission Complete overlays;
- THE ROADMAP TO MAJOR is separate from Missions.

Remake:
- Missions / Build / Shop implemented;
- Roadmap to Major implemented in 8W.
Remaining:
- Mission Complete presentation is still less exact;
- Build lower inventory strip can be visually closer.

## 12:20–13:50 — second match preparation

Observed:
- old Facebook friend signing screen (intentionally omitted);
- season timeline returns with completed match card;
- Special Batter Slot modal;
- Line Up / Substitute management;
- special player order changes;
- AUTO SORT;
- VS transition into next game.

Remake:
- Friends intentionally omitted;
- timeline implemented in 8V;
- Special Batter slots exist;
- drag/drop Line Up fixed in 8P.

## 13:50–18:40 — second match

Observed:
- automatic simulation and Hero turns repeat;
- a bright flash / baseball transition appears around game entry;
- more explicit EARLY SWING / LATE SWING tutorial feedback;
- ONE BASE HIT comic panels have multiple variants;
- fly-ball presentation uses a sky/ball shot before returning to simulation;
- no ENTER is required between normal result beats.

Remake:
- automatic cadence fixed;
- no ENTER requirement;
- missing major presentation piece: exact flaming/baseball transition before
  the match;
- fielding cutaways still simplified.

## 18:40–19:03 — postgame

Observed:
- YOU WIN;
- inning line score;
- Hero performance;
- Rank grade;
- Coins/score reward;
- right-side leaderboard;
- Coach points to the postgame navigation;
- no gameplay input is required to clear normal hit overlays.

Remake:
- functional result/leaderboard exists;
- exact compact layout and reward animation still need a final visual rebuild.

# Remaining first-video priorities after Phase 8X

1. Character Making visual fidelity.
2. Post-Level-Up Skill Point tutorial.
3. Exact fielding / sky-ball cutaways.
4. Flaming baseball match transition.
5. Final result / Rank / leaderboard reconstruction.
6. Build lower inventory strip / Mission Complete fidelity.

Cards + Packs are no longer in the major-missing list after 8X.
