# Baseball Heroes Remake — Phase 8Q
## User-Supplied Original Visual Asset Integration

This phase starts using the reference images supplied directly by the user in
this conversation. Until now, the remake reconstructed almost everything with
vectors and approximations. Phase 8Q introduces a reusable AIR asset-loading
layer so high-quality supplied artwork can appear inside the game without
removing the vector fallbacks.

## New runtime asset system

New classes:
- `com.bh.visual.AssetImage`
- `com.bh.visual.VisualAssetRegistry`
- `com.bh.visual.TeamLogoView`
- `com.bh.visual.LeagueBadgeView`

The loader reads PNGs from `assets/reference/...` at runtime. If an optional
asset cannot be loaded, the existing vector fallback remains usable.

## Team logos

The user-supplied team-logo sheet was separated into 30 transparent PNGs.
Logos are now used in:
- Regular Season matchup cards;
- Line Up team comparison;
- pre-match VS presentation;
- in-game scoreboard HUD;
- post-game result screen.

Cities currently recognized include St. Louis, Colorado, Arizona, Houston,
Chicago, New York, Seattle, Miami, Texas, Boston, Atlanta, Toronto and many
others from the supplied sheet.

Custom cities still work. They automatically fall back to the old generated
team emblem when no matching supplied logo exists.

## League badges

The supplied Rookie / Single-A / Double-A / Triple-A / Major artwork is now
used in the HOME top bar, Season Roadmap and gameplay HUD.

## Stadium artwork

Six supplied stadium images were converted to 960x540 PNGs for AIR:
- Treasure Island
- Holiday Ballpark
- Triple-A Liberty
- Devil Castle
- Major City
- Major Night

Existing `stadium_background_ocean` now represents Treasure Island and
`stadium_background_city` represents Major City. New Build/Shop backgrounds:
- Triple-A Liberty
- Holiday Ballpark
- Devil Castle
- Major Night

When one of these backgrounds is active, the supplied stadium artwork appears
in:
- BUILD preview;
- pre-match ballpark reveal;
- actual batting gameplay.

The default Mountain Classic remains vector-based so Rookie saves do not
suddenly display Triple-A/Major branding.

## Shop improvement

Stadium background cards now show real miniature previews whenever a supplied
stadium image exists instead of only the generic stadium icon.

## Save

Save version: **16**.
Older saves remain compatible.

## Test

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8Q_asset_integration"
.\play.bat
```

Recommended checks:
1. HOME: verify the league badge is now graphical.
2. PLAY BALL: verify real rival logos appear in the Season Roadmap.
3. LINE UP: verify the home/rival logos in the lower comparison card.
4. Start a match: verify the VS presentation and gameplay scoreboard logos.
5. SHOP -> STADIUM: locate Treasure Island / Major City / Triple-A Liberty /
   Holiday Ballpark / Devil Castle / Major Night and check the preview art.
6. BUILD: equip one of those backgrounds and verify the stadium image changes.
7. Play again and verify the selected stadium is carried into the actual game.

## Source handling

The source images used here were provided by the user. No external download or
asset scraping was performed for this phase.
