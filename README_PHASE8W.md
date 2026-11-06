# Baseball Heroes Remake — Phase 8W
## THE ROADMAP TO MAJOR

New:
- dedicated `HOME -> ROADMAP` button;
- five-stage Rookie -> Single-A -> Double-A -> Triple-A -> Major path;
- supplied original league badges used on the route;
- three persistent objectives per league;
- account-level career Roadmap counters that survive season resets;
- progress bars and completion states;
- Mystery Box reward for each completed stage;
- older saves seeded from their current-season statistics;
- Save v19 migration.

Roadmap rewards are functional reconstructions because the exact original
server reward table has not been recovered.

Promotion is NOT bypassed by the Roadmap. The existing season promotion logic
still determines when the team actually moves to the next league.

Run:

```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8W_roadmap_to_major"
.\play.bat
```

Test:
1. HOME -> ROADMAP.
2. Click Rookie / A / AA / AAA / Major badges.
3. Verify current objectives and progress.
4. If a stage is complete, open its Mystery Box.
5. Return HOME and confirm Coins/Cash/Energy/Skill Point persisted.
6. Play another regular-season game and reopen ROADMAP to verify career
   Games/Wins/HR/RBI progress increased.
