# Baseball Heroes Remake — Phase 8I
## Original Equipment Categories Reconstruction

Historical reviews of Baseball Heroes explicitly describe six wearable / gear
categories:

- BAT
- GLOVE
- BELT
- HELMET
- SHOES
- GOGGLES

Earlier remake phases only implemented Bat / Glove / Shoes. Phase 8I completes
all six categories and migrates older saves automatically.

## Changes
- Save v14.
- Six persistent equipped slots.
- New starter Belt, Helmet and Goggles gear.
- New Rare / Elite / Hero variants.
- Shop now sells Belt / Helmet / Goggles upgrades.
- Equipment bonuses can affect Power, Contact, Speed and Luck.
- Hero equipment screen redesigned around six category tabs.
- Equipped gear is visible in the Hero preview.
- Gameplay Batter now reflects equipped:
  - Bat color;
  - Helmet color;
  - Belt color;
  - Shoes color;
  - Goggles.
- CharacterPortrait also reflects Hero Helmet and Goggles.

## Test
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8I_equipment_reconstruction"
.\play.bat
```

Then:
1. TEAM -> EQUIPMENT.
2. Visit each of the six tabs.
3. Equip different Belt / Helmet / Goggles variants.
4. Check POW / CON / SPD / LCK totals.
5. Enter a match and verify the batter's visible equipment changes.
6. SHOP -> EQUIPMENT to find additional gear.
