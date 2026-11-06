# Baseball Heroes Remake — Phase 8R
## Character Art + Card Pack + Celebration Integration

Phase 8R continues using the original visual reference sheets supplied by the
user in this conversation.

## Roster characters

Eleven non-Hero players in the default roster now have supplied Baseball
Heroes-style character art instead of only the generic vector portrait:

- Andrew
- Benjamin
- Julia
- Kevin
- Michelle
- Michael
- Carlos
- Ryan
- Sam
- Noah
- Leo

The user's custom Hero remains generated/customizable so Character Making,
equipment colors and the user's personal player are not replaced by a fixed
original character.

The supplied portraits automatically appear anywhere `CharacterPortrait` is
used, including Team, Line Up, Trade & Enhance and roster cards. If an asset
cannot be found, the vector fallback remains active.

## Special Batter card packs

The user-supplied card-pack sheet has been separated into individual PNGs:

- Single-A
- Double-A
- Triple-A
- Major
- Special Match
- National League
- American League
- Heroes

`TEAM -> CARDS` now displays original pack artwork on the pack buttons.

The Coin pack uses artwork that follows the current league progression.
The premium pack uses the Heroes pack artwork. The underlying draw odds and
prices are still the functional reconstruction from Phase 7C.

## Season mode badge

The Regular Season roadmap now displays a supplied mode badge:
- OPENING on the first game;
- RIVAL during later regular-season games.

The remaining supplied mode badges are prepared for later use:
Post Season, All Star, Special Match, World Match and Home Run Derby.

## Hit celebrations

Original comic-strip panels supplied by the user now appear inside the hit
cinematic:
- Double -> high-five panel
- Triple -> running celebration panel
- Home Run -> crowd celebration
- Grand Slam -> trophy celebration

The vector comic burst remains behind them as a fallback.

## Save compatibility

No new persistent gameplay data was required in 8R, so the Save format remains
compatible with Phase 8Q (version 16).

## Test

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8R_character_asset_integration"
.\play.bat
```

Recommended:
1. HOME -> TEAM and inspect Andrew/Benjamin/Julia/etc.
2. TEAM -> LINEUP and confirm the same art appears in lineup portraits.
3. TEAM -> CARDS and inspect the small original pack artwork.
4. HOME -> PLAY BALL and inspect the OPENING/RIVAL badge.
5. During gameplay, get a Double, Triple or Home Run and inspect the supplied
   comic-art insert.
