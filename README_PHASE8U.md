# Baseball Heroes Remake — Phase 8U
## First Game Experience Reconstruction

This phase follows the first gameplay more closely before the first regular-season match.

## Fresh-save flow

A brand-new save now begins with:

TEAM SELECTION
-> CHARACTER MAKING
-> ROOKIE ARRIVAL MAP
-> HOME tutorial callout
-> ROOKIE SEASON GOAL
-> SEASON ROADMAP
-> TRAVEL TO OPPONENT
-> LINE UP first-game hint
-> MATCH INTRO
-> GAME

Older saves from Phase 8T and earlier are migrated directly to onboarding COMPLETE, so an active career is not interrupted.

## Team Selection

The old 16 generic circles have been replaced with 27 city choices using the user-supplied Baseball Heroes team-logo sheet.

The selected team logo is shown in the right preview and the map pin follows the chosen city.

## Character Making

Character Making remains fully editable and is now part of the actual first-game sequence rather than a disconnected HOME menu option.

## Rookie transport / travel

The vehicle/NPC reference sheet supplied by the user has been separated into five travel assets:

- Rookie bus
- Single-A bus
- Double-A coach
- Triple-A plane
- Major airliner

The first arrival uses the Rookie bus.

Regular Season travel now uses the transport that matches the player's current league. Travel also continues automatically after arrival, matching the quick transitions in the gameplay. `SKIP` remains available for testing.

## HOME tutorial

The first arrival lands on HOME. A Coach callout points toward PLAY BALL and explains that the next step is the Rookie Season Goal.

## Season Roadmap / travel order

The normal regular-season flow is now:

PLAY BALL -> ROADMAP -> TRAVEL -> LINE UP

instead of ROADMAP -> LINE UP directly.

## First Line Up hint

During the onboarding lineup screen, BATTER SHOP, AUTO SORT and PLAY are highlighted and the coach text explains the expected first-game actions.

The underlying drag/drop and special-batter systems remain unchanged.

## Replay without deleting your save

Because existing saves intentionally skip the new onboarding, use:

HOME -> MODES -> REPLAY FIRST GAME

This restarts only the onboarding state. It does not erase season statistics, roster, equipment, Coins or stadium progress.

Selecting another club or appearance during replay will, naturally, update those choices.

## Save

Save format: v17

## Run

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8U_first_game_experience"
.\play.bat
```
