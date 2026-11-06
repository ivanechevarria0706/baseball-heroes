# Baseball Heroes Remake — Phase 5C

## FREE BUILD MODE / PLACEABLE STADIUM DECORATIONS

Phase 5C expands the slot-based stadium system from Phase 5B.

### New Shop stadium decorations
- Heroes Flag
- Victory Star
- Giant Baseball
- League Trophy
- Fireworks Tower

These are purchased in:
HOME -> SHOP -> STADIUM

### Build Mode
Purchased placeable decorations can now be added to the stadium.

Flow:
SHOP -> buy decoration -> BUILD -> select owned decoration ->
APPLY TO STADIUM

Then:
- click a placed decoration;
- drag it around the stadium preview;
- `+ SIZE` / `- SIZE`;
- `REMOVE`.

Maximum placed decorations: 8.

### Persistence
Save version:
- Phase 5B: v4
- Phase 5C: v5

The game now saves:
- decoration id;
- x/y position;
- scale;
- all previous season/team/shop/build data.

### HOME integration
Placed decorations are also rendered on the HOME stadium screen.

### Suggested test
1. SHOP -> STADIUM.
2. Buy `Heroes Flag`.
3. BUILD.
4. Select Heroes Flag and APPLY TO STADIUM.
5. Click the placed flag and drag it somewhere else.
6. Resize it.
7. HOME.
8. Confirm the decoration appears in the stadium.
9. Close AIR and reopen.
10. Confirm its position and size remain saved.

### Compile
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase5C"
.\play.bat
```
