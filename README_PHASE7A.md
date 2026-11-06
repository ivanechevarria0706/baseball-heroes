# Baseball Heroes Remake — Phase 7A

## FIRST VISUAL RECONSTRUCTION PASS

Phase 7A is the first phase whose main goal is visual identity instead of adding another gameplay subsystem.

The direction comes from surviving Baseball Heroes screenshots/game art: oversized chibi heads, compact athletic bodies, strong helmet/uniform silhouettes, colorful player cards and exaggerated arcade contact effects.

The drawings in this remake are new vector redraws inspired by those references. They are not recovered original Syntasia assets.

## New visual architecture

### `src/com/bh/visual/VisualProfile.as`
Creates a deterministic appearance from the player/pitcher name:
- skin palette;
- hair palette;
- eye color;
- light/dark versions of the team accent.

Different roster players therefore no longer need to share exactly the same face palette.

### `src/com/bh/visual/CharacterPortrait.as`
Reusable chibi portrait renderer used by:
- roster cards;
- TEAM selected-player panel;
- future Scout/Training/Skills/Pregame art passes.

## Batter redraw

`Batter.as` has been rebuilt as layered art:
- shadow;
- front/back legs;
- torso;
- sleeves;
- belt/buckle;
- front/back arms;
- batting gloves;
- oversized face;
- hair;
- helmet + brim + ear protector;
- jersey number;
- cleats;
- highlighted wood bat;
- bat trail.

### Swing animation
The swing now has four visual stages:
1. LOAD / ANTICIPATION
2. EXPLOSIVE SWING
3. FOLLOW THROUGH
4. RECOVERY

The strongest part of the swing draws an arcade bat trail.

### Batter reactions
- SINGLE / DOUBLE / TRIPLE / HOME RUN -> positive reaction
- OUT / STRIKEOUT -> disappointed reaction
- WALK -> small movement reaction

## Pitcher redraw

`Pitcher.as` now has:
- larger chibi head;
- individual face palette;
- team-color cap/sleeves;
- glove detail;
- uniform/belt/cleats;
- stronger silhouette.

### Pitch animation
1. SET
2. LEG LIFT / COIL
3. STRIDE / RELEASE
4. FOLLOW THROUGH

The pitcher also reacts to hits and successful outs/strikeouts.

## Contact effects

`ContactEffect.as` now uses:
- central white flash;
- colored impact disc;
- two shock rings;
- 20 arcade rays;
- diamond shards;
- glow and rapid expansion.

PERFECT, GOOD and FOUL still use different palettes.

## Cards / TEAM

`PlayerCard.as` now uses the same chibi portrait renderer.
The large portrait in TEAM also changes when another player card is selected.

## Stadium

The batting stadium receives an extra art pass with:
- active scoreboard color face;
- active side billboard blocks;
- all existing Build Mode wall/scoreboard/banner colors preserved.

## Save compatibility

This phase is visual-only, so the save remains version 8.
No season, roster, skills, lineup, equipment, shop or stadium progression is intentionally reset.

## Recommended test

1. TEAM -> inspect multiple cards and selected-player portraits.
2. HOME -> PLAY BALL.
3. Watch the batter idle pose.
4. Swing and look for load -> acceleration -> follow-through -> recovery.
5. Get a SINGLE/DOUBLE/HR and compare the batter reaction.
6. Strike out or make an out and compare the negative reaction.
7. Watch the pitcher's leg lift and follow-through.
8. Compare PERFECT / GOOD / FOUL contact effects.

## Compile

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase7A"
.\play.bat
```

## Next visual pass

Phase 7B is intended to continue with:
- home-run camera / ball-flight presentation;
- player entrance animations;
- larger result typography and arcade transitions;
- historical-inspired HUD treatment;
- CharacterPortrait adoption in Scout, Training, Skills and Pregame;
- first external sprite-atlas loading hooks so raster artwork can later replace vector redraws without changing gameplay code.
