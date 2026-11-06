# Baseball Heroes Remake — Phase 8M
## Core UI Polish: Missions / Draft / Team / Trade & Enhance

Phase 8M continues the interface overhaul started in 8K/8L. The gameplay and
batting changes from 8J remain unchanged; this pass focuses on screens that
still looked like dark development menus.

## Missions
- Bright stadium backdrop instead of a flat dark overlay.
- Historical-style blue modal with three large mission-category tabs.
- Dedicated Coach block.
- Reward strip with clearer hierarchy.
- Objective rows now have progress bars and completion markers.
- Mission state is shown as ACTIVE / COMPLETE / CLAIMED.
- Overall completed-mission count is visible in the header.
- `GO TO SHOP` remains functional for Local Stadium Growth.

## Draft
- Rebuilt around the original `THE NEW DRAFT BEGINS!` hierarchy.
- Blue modal, mascot, Expected Potential meter and 5x5 hidden prospect board.
- Cleaner Bronze Pick cost presentation.
- Dedicated Prospect panel on the right.
- Revealed prospects now show portrait, grade, position, OVR and PWR/CON/LCK
  bars before signing.
- Bottom selected-prospect strip was simplified and polished.
- `AUTO PICK`, `SIGN`, `TEAM` and `HOME` remain functional.

## Team
- Replaced the dark menu background with a bright stadium context.
- ROSTER, STARTING LINEUP and PLAYER panels are now white/blue/yellow game
  cards instead of black development panels.
- Defensive field remains functional but uses brighter player tokens.
- Top bar now displays team/league information and current/max Energy.
- Bottom Team navigation uses the same blue arcade UI language as Home/Lineup.

## Trade & Enhance
- Reworked into two clean game-card panels.
- Blue PLAYER LIST header and yellow PLAYER DEVELOPMENT header.
- Selected-player highlight is more obvious.
- Portrait and stat controls have more room and better contrast.
- Enhancement and trade behavior is unchanged.

## Facebook-specific features
No Facebook friends/sign/share functionality was reintroduced.

## Run
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8M_core_ui_polish"
.\play.bat
```

## Recommended checks
1. HOME -> MISSIONS.
2. Switch all three mission categories and claim a completed mission if one is
   available.
3. HOME -> DRAFT, reveal a Bronze prospect, use Auto Pick, inspect and SIGN.
4. Open TEAM and inspect roster, defensive field and player details.
5. TEAM -> LINEUP -> TRADE & ENHANCE and train a stat.
6. Confirm the 8L Match HUD and 8J batting remain unchanged.
