# First gameplay interface archaeology

Source analyzed again:
`Facebook - Baseball Heroes - No doy una.mp4`

Metadata observed locally:
- 640 x 480
- 30 fps
- approximately 19:03

This pass focused on interface and progression systems rather than the batting
or simulation sections already reconstructed in Phases 8A/8B.

## 0:00–0:40 — Team Selection
The original opens with a large bright-green USA map. A grid of team emblems
runs across the bottom. Selecting an emblem moves a blue map pin to the team's
city and changes the preview on the right.

Phase 8D adds `TeamSelectionScreen.as` with the same structure and persistent
city/accent selection.

## 0:40–2:05 — Character Making
The video shows a dedicated CHARACTER MAKING screen with:
- SHAPE
- HAIR
- EYES
- NOSE
- MOUTH
- 4x2 option grid
- small color palette above the preview
- large Hero preview on the right
- SELECT button

Phase 8D adds `CharacterMakerScreen.as`. Appearance selections are saved on
the Hero and the color choices feed CharacterPortrait/Batter rendering.

## 2:25–2:40 — Season Goal Setting
A large `Rookie Season GOAL SETTING` card appears. The tutorial starts with
values like HIT/RBI, the player spins the wheel, and the accepted goals in the
footage become `15 HR / 55 RBI`.

Phase 8D adds persistent HR/RBI season goals, a Spin The Wheel screen, and
real progress display in HOME and the batting HUD.

## 2:40–3:30 — Opponent/Lineup/Special Batter tutorial
The video moves from season matchup cards into a two-column lineup editor and
opens a small BATTER SHOP / Special Batter panel over the lineup.

Our existing Lineup and Special Batter systems already cover the mechanics,
but their exact visual reconstruction remains a later UI pass.

## 7:20–7:40 — THE NEW DRAFT BEGINS!
The draft screen is a large blue modal with:
- team mascot;
- EXPECTED POTENTIAL bar from Weak to Strong;
- 25 numbered player tiles;
- AUTO PICK;
- a bottom row of selected cards.

Phase 8D rewrites the old generic Scout screen into this draft-board layout,
while keeping the existing recruit/sign mechanics.

## 8:00–8:30 — Name Your Team
The original uses a white centered modal with:
- team logo;
- city/division label;
- team name input;
- uniform number input;
- CONFIRM.

Phase 8D adds `TeamNameScreen.as` and stores team name/uniform number.

## 8:50–9:10 — Missions
The original mission interface has three large category icons on the left and
a white content card with:
- mission title;
- NPC portrait/dialogue;
- reward;
- two objectives with numeric progress;
- contextual buttons such as GO TO SHOP.

Phase 8D adds `MissionsScreen.as` with three persistent mission chains.

## 9:20–11:30 — Stadium Shop / Inventory
The gameplay confirms Build Mode is not a generic decoration editor: the
field stays visible while SHOP and INVENTORY live in a blue bottom dock.
Purchased scenery immediately changes the stadium and affects gate income.

The remake already has Build/Shop functionality, but Phase 8D adds a daily
Gate Income button and a stadium-growth mission. A future Build UI pass should
replace the current full-screen editor with this bottom-dock layout.

## 12:30 — Invite Friends
A large `SIGN YOUR FRIENDS!` dialog is shown. The original Facebook social
feature cannot be reproduced faithfully offline without Facebook services.
The current friend-card carousel remains an offline visual substitute.

## 12:50–13:40 — Lineup / Special Batter Slot
The footage confirms:
- LINE UP left;
- SUBSTITUTE right;
- player rows with AVG;
- Special Batter Slot popup;
- BATTER SHOP;
- TRADE & ENHANCE;
- HOME / AUTO SORT / PLAY bottom buttons.

These are now the priority for the next exact UI reconstruction.

## HOME observations
The original HOME screen is bright and dense rather than dark/minimal:
- resource bar across top;
- league badge and trophy counters;
- small team players across the field;
- large Hero on the right;
- PLAY BALL at lower left;
- season opponent medallions;
- Team Rank and Season Goal along the bottom;
- vertical icons on the left;
- friend/team-help cards;
- stadium gate-income economy.

Phase 8D rewrites LobbyScreen around this hierarchy.

## Still missing after Phase 8D
1. Exact two-column lineup/substitute UI from the first gameplay.
2. BATTER SHOP popup embedded inside Lineup.
3. TRADE & ENHANCE screen.
4. Bottom-dock Build/Inventory UI matching 9:20–11:30.
5. Mission-complete celebration card matching the footage.
6. Level Up reward popup matching 6:30.
7. Friend signing panel as an offline simulation.
8. Exact first-season matchup card carousel.
9. More faithful logos/mascots/raster chibi art.
