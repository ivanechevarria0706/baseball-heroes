# Baseball Heroes Remake — Phase 8X
## Cards + Packs / Batter Shop Reconstruction

Built after completing a new full review of the first uploaded gameplay.

## BATTER SHOP

`LINE UP -> BATTER SHOP` now opens as a modal over the Line Up screen, matching
the first-game tutorial more closely.

SPECIAL tab:
- C Pack — C 6,000
- B+ Pack — $25
- A+ Pack — $56

These three prices are taken directly from the uploaded first gameplay.

### Opening flow

1. Click a pack to purchase it.
2. A large pack appears.
3. CLICK or SPACE opens it.
4. The recruited Special Batter card is revealed.
5. OKAY / SPACE / ENTER returns to the pack shelf.

There is no Facebook SHARE button in the remake.

### Lenard J.

The first Class C pack opened by a save that does not own Lenard J. guarantees:
- Lenard J.
- Class C presentation
- AVG .253
- Combo +1
- 4th-inning single trigger in the reconstructed gameplay system.

This reproduces the first gameplay tutorial reveal while remaining compatible
with the remake's existing Special Batter mechanics.

## REGULAR tab

Uses the cleaner pack sheet supplied by the user in this conversation.

Currently functional:
- current League Pack;
- Heroes Pack.

Special Match artwork is visible but intentionally locked until that mode is
implemented rather than pretending the pack is functional.

## TEAM -> CARDS

The Special Batter collection remains the management screen for:
- owned cards;
- equipped Special slots;
- Combo;
- duplicates / Combine.

Its old two-button pack footer was replaced with `OPEN BATTER SHOP`, so both
Line Up and Team now use the same pack-opening flow.

## Save

Save version: v20.

No old card ownership is deleted. The new Lenard J. catalog entry becomes
available to existing saves automatically.

## Test

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8X_cards_packs"
.\play.bat
```

Recommended:
1. HOME -> PLAY BALL -> LINE UP -> BATTER SHOP.
2. Verify C / B+ / A+ prices.
3. Buy C Pack.
4. CLICK or SPACE on the large pack.
5. Verify the card reveal.
6. Press OKAY.
7. Close the shop and confirm Line Up is still behind it.
8. TEAM -> CARDS -> OPEN BATTER SHOP.
9. Open REGULAR and inspect the supplied League / Heroes pack artwork.
