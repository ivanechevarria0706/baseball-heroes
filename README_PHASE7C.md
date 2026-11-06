# Baseball Heroes Remake — Phase 7C

## SPECIAL BATTER CARDS + COMBO

Phase 7C implements the card system that surviving contemporary reviews
describe as one of Baseball Heroes' key team-building mechanics.

Historical basis:
- up to five Special Batter cards could be included in the lineup;
- three additional slots were associated with Coins and two with Credits;
- Special Batters had grades and better batting averages;
- they added to the team's Combo meter;
- some could guarantee a hit when batting in a specific inning;
- some cards could be improved;
- three cards could be combined to create/improve a better hitter.

Exact Syntasia server formulas, card names and prices have not been recovered.
The card names, pack probabilities, prices and combine formula in this remake
are therefore reconstruction approximations.

## New screen

TEAM -> CARDS

The Special Batter screen includes:
- 5 lineup slots;
- owned card collection;
- card grades;
- AVG;
- Combo value;
- inning trigger;
- guaranteed hit type;
- level;
- duplicate copy count;
- EQUIP / UNEQUIP;
- COMBINE;
- Coin Pack;
- Premium Pack.

## Slot progression

The remake models the historical slot split as:

- Slot 1: starter slot
- Slot 2: C 15,000
- Slot 3: C 30,000
- Slot 4: $5
- Slot 5: $10

These exact costs are provisional.

## Packs

COIN PACK:
- C 20,000
- mainly NORMAL / RARE
- smaller ELITE / HERO chance

PREMIUM PACK:
- $5
- RARE / ELITE / HERO

Duplicates become copies.

3 copies:
COMBINE -> card level +1

Max card level currently: 3.

## Combo

Every equipped Special Batter adds Combo.

Thresholds:
- 20: Bronze Combo
- 40: Silver Combo
- 60: Gold Combo
- 80: Max Combo

Combo currently improves:
- simulated teammate hit probability;
- Hero effective CONTACT;
- Hero effective LUCK.

## Actual match integration

Special Batter cards occupy up to five of the simulated teammate positions.

Example:

Batting order:
1 Andrew
2 Julia
3 Kevin
4 Ivan (Hero)
5 Michael
...

Special cards:
1 Mio Flash
2 Rex Slugger
3 Hana Clutch

Simulation may show:

★ MIO FLASH    SINGLE
★ REX SLUGGER  GROUND OUT
★ HANA CLUTCH  DOUBLE
YOUR TURN      IVAN

The underlying regular lineup still controls batting order and roster
structure, while Special Batters overlay the first available non-Hero spots.

## Inning trigger

If a card reaches its configured inning and has not triggered yet that game:

SPECIAL BATTER!
HANA CLUTCH
INNING 3 GUARANTEED SINGLE ACTIVATED!

The trigger is used once per card/inning per game.

## Save

Phase 7B: v9
Phase 7C: v10

Saved:
- owned Special Batter cards;
- card levels;
- duplicate copies;
- card stats;
- equipped card slots;
- number of unlocked card slots.

## Suggested test

1. TEAM -> CARDS.
2. Equip Rookie Ace.
3. Unlock Slot 2.
4. Equip Mio Flash.
5. Open a Coin Pack.
6. If you draw a duplicate, verify the copy count rises.
7. Return HOME -> PLAY BALL.
8. Confirm Pregame shows SPECIAL count and COMBO.
9. Start the game.
10. Watch TEAM AT BAT.
11. Confirm Special Batters appear with ★ in simulation.
12. Reach a trigger inning and look for CARD TRIGGER.
13. Confirm YOUR TURN still stops simulation for Ivan.
14. Close AIR and reopen; verify collection/equipped cards persist.

## Compile

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase7C"
.\play.bat
```

## Next direction

Phase 7D is planned around the historically documented equipment slots:
BAT / GLOVE / BELT / HELMET / SHOES / GOGGLES,
plus a stronger visual inventory/equipment treatment.
