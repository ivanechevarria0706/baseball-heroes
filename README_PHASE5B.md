# Baseball Heroes Remake — Phase 5B

## SHOP + BUILD MODE / STADIUM

This phase continues directly from Phase 5A.

### New screens
- `ShopScreen.as`
- `BuildScreen.as`
- `ShopItemCard.as`

### Shop
HOME -> SHOP

Categories:
- EQUIPMENT
- STADIUM
- ENERGY

Purchases use the shared persistent currencies in `GameData`.

Items can have a league requirement:
- Rookie
- Single-A
- Double-A
- Triple-A
- Major

Advanced equipment is added to the player's persistent inventory.
Energy consumables can be bought repeatedly.

### Build Mode
HOME -> BUILD

Persistent stadium slots:
- SCOREBOARD
- BANNER
- LIGHTS
- WALL

Only purchased/owned stadium items can be applied.

The selected customization is saved through AIR `SharedObject`
and the HOME stadium changes visually to match the active build.

### Save migration
Save version:
- Phase 5A: v3
- Phase 5B: v4

Old saves are migrated. New stadium ownership fields are defaulted
without deleting roster, coins, training, equipment or season progress.

### Suggested test
1. Open HOME.
2. Open SHOP.
3. Buy a stadium item.
4. Open BUILD.
5. Select the purchased item and press APPLY TO STADIUM.
6. Return HOME and confirm the stadium color/detail changed.
7. Buy `Slugger X Bat` if unlocked and affordable.
8. Go TEAM -> EQUIP and confirm it appears in inventory.
9. Buy an Energy item and confirm Energy changes.
10. Close AIR completely and reopen.
11. Confirm purchases and stadium customization persist.

### Compile
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase5B"
.\play.bat
```

Or:
```powershell
.\build\build.bat
.\build\run-air.bat
```
