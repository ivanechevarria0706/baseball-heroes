# Baseball Heroes Remake — Phase 6A

## CARDS + PLAYER SKILLS + ADVANCED PITCHERS

Phase 6A is a larger gameplay/progression pass built on Phase 5C.

### Player cards
Roster cards now have clearer rarity identities:
- NORMAL: 1 star
- RARE: 2 stars
- ELITE: 3 stars
- HERO: 4 stars
- PITCHER: special purple frame

The selected card also gets a stronger glow.

### Skill system
TEAM -> select player -> SKILLS

Four reconstructed skills are available:

#### Power Hitter
- adds effective POWER;
- raises scoring chance on GOOD contact.

#### Batting Eye
- adds effective CONTACT;
- widens PERFECT / GOOD / FOUL timing windows.

#### Clutch
- activates in inning 3+ when tied or behind;
- boosts POWER and CONTACT.

#### Speedster
- lowers rival scoring pressure.

Skills have Levels 0-3.
Training player levels now grants:
- +1 Skill Point each time the player levels up.

A player can own several skills but only one is ACTIVE.

### Pitcher progression by league
Opponent pitchers now have:
- team identity;
- pitcher name;
- OVR;
- league-dependent repertoire.

Pitch types:
- Rookie: FASTBALL, CHANGEUP
- Single-A: + CURVEBALL
- Double-A: + SLIDER
- Triple-A: + SINKER
- Major: + CUTTER

Pitcher OVR affects:
- velocity;
- command / location spread;
- difficulty.

### Ball physics
Pitch movement now supports:
- horizontal break;
- vertical late break.

Sinkers visibly drop more.
Sliders move harder laterally.
Cutters are faster with a shorter horizontal break.

### Gameplay stadium
The batting stadium now also reads:
- active wall color;
- active lights;
- active scoreboard;
- placed Build Mode decorations.

### Save
Save version:
- Phase 5C: v5
- Phase 6A: v6

Legacy players are migrated automatically with:
- Skill Points;
- active skill;
- skill levels.

No roster, season, shop, equipment or stadium data should be removed.

### Suggested test
1. TEAM -> select Ivan -> SKILLS.
2. Upgrade Power Hitter or Batting Eye.
3. ACTIVATE it.
4. Return HOME -> PLAY BALL.
5. Confirm the HUD shows the active skill.
6. Play multiple pitches and confirm the opposing pitcher name/OVR appears.
7. Advance leagues later to unlock Slider/Sinker/Cutter repertoires.
8. Confirm your Build Mode stadium customizations also appear during batting.
9. Close AIR and reopen to confirm skill data persists.

### Compile
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase6A"
.\play.bat
```
