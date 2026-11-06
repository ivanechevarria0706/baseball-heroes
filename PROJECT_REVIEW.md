# Revisión técnica del proyecto

Fecha de revisión: 2026-09-01

## Hallazgos corregidos

### Error crítico: metadata dinámica en Sprite
`EquipmentScreen.as` todavía contenía:

```actionscript
card["itemData"] = item;
```

Esto causa:

```text
ReferenceError: Error #1056
Cannot create property itemData on flash.display.Sprite
```

Se sustituyó por `flash.utils.Dictionary`.

### Panel Equipment desactualizado
Después de equipar un objeto, los slots BAT/GLOVE/SHOES no se redibujaban hasta volver a entrar a la pantalla.

Ahora los campos e iconos se mantienen como referencias y se actualizan en el acto.

### Build/configuración antigua
`compile-config.xml` tenía rutas absolutas y pertenecía a los intentos iniciales de configuración del SDK. Ya no participa en la compilación estable del proyecto y fue retirado.

### SWFs antiguos
Los SWF incluidos podían hacer que se ejecutara código anterior aunque el source ya estuviera corregido. El paquete revisado no incluye binarios generados; hay que compilarlo una vez.

### Persistencia
`GameData` fue endurecido para:
- soportar saves versión 1;
- rellenar campos faltantes;
- reparar inventario;
- validar slots/stats;
- conservar Scout Counter.

### Gameplay y atributos
Antes, Equipment y Training podían cambiar números mostrados, pero el sistema de timing seguía usando ventanas fijas.

Ahora:
- `CONTACT` modifica `PERFECT / GOOD / FOUL`;
- `POWER` modifica el vuelo del batazo.

## Validación realizada aquí

Se revisaron:
- estructura del ZIP;
- todos los `.as`;
- descriptor AIR;
- scripts `.bat`;
- referencias entre clases;
- balance de `{}`, `()` y `[]`;
- patrones conocidos de propiedades dinámicas sobre `Sprite`;
- `return` partidos en líneas que habían provocado errores anteriores;
- referencias a métodos modificados.

No se ejecutó `amxmlc` dentro del entorno de revisión porque Apache Flex/AIR no está instalado en este contenedor. La compilación final debe hacerse en el Windows del proyecto, donde el toolchain ya está funcionando.


### Integración Scout -> Team
TEAM solo renderizaba los primeros 12 elementos del roster. Un jugador 13–30 firmado desde Scout existía en `GameData`, pero no podía seleccionarse.

Se añadió paginación de 12 jugadores por página.

### Limpieza de listeners
Se añadieron `dispose()` a Ball, Batter, Pitcher, BattingCursor y ContactEffect, y `Game.dispose()` los libera al regresar al HOME.

También se corrigieron botones locales de Lobby/Team que no se limpiaban explícitamente.


## Build fix v2
- `build.bat` now uses single-line compiler/copy commands.
- All `.bat` files use Windows CRLF line endings.
- The copied SWF is explicitly verified before the build is considered successful.


## Phase 5A
- Save version increased to 3 with backward-compatible season fields.
- Added persistent 30-game season progression.
- Added Rookie -> Single-A -> Double-A -> Triple-A -> Major league model.
- Added 3-inning game completion and extra innings.
- Added opponent run simulation and post-game rewards.
- Added `GameResultPanel`.
- HOME now renders current league, record, rank, season history and goals.


## Phase 5B
- Save version increased from 3 to 4.
- Added persistent Shop catalog and purchasing.
- Added league-gated equipment, stadium and energy items.
- Added persistent Build Mode with scoreboard/banner/lights/wall slots.
- HOME stadium now reads active stadium customization.
- Added `ShopScreen`, `BuildScreen`, and `ShopItemCard`.


## Phase 5C
- Save version increased from 4 to 5.
- Added placeable stadium decorations.
- Build Mode now supports drag/drop placement, remove and scale controls.
- Maximum 8 placed decorations.
- Decoration position/scale persist in SharedObject.
- HOME renders placed stadium decorations.
- SHOP detail panel adjusted upward to avoid bottom clipping.


## Phase 6A
- Save version increased from 5 to 6.
- Added persistent four-skill player system with Skill Points and active skill selection.
- Player level-ups now award Skill Points.
- Added `SkillScreen`.
- Replaced inactive TEAM `RELEASE` control with functional `SKILLS`.
- Upgraded roster card rarity visuals.
- Added opponent team/pitcher profiles.
- Added league-dependent pitch repertoires.
- Added Slider, Sinker and Cutter movement.
- Opponent OVR now influences pitch velocity and command.
- Active skills now affect batting timing, power, GOOD-contact scoring and rival scoring pressure.
- Gameplay stadium now renders active stadium colors and placed Build Mode decorations.


## Phase 6B
- Save version increased from 6 to 7.
- Added persistent nine-player batting order.
- Added `LineupScreen` with player assignment, reordering, pagination and auto optimization.
- Added `PregameScreen`; Energy is now spent only when the game actually starts.
- Added opponent/pitcher matchup preview before games.
- Batting mode now rotates through the actual 1-9 batting order.
- Each hitter uses personal attributes, active skill and visual accent.
- Career AVG/HR/RBI are now recorded per hitter instead of all game stats being credited to Ivan.
- HUD now shows opponent name and next batter context.


## Phase 6C
- Save version increased from 7 to 8.
- Added real balls/called strikes and walks.
- Added persistent career doubles, triples and walks.
- Added offensive base-runner state.
- Mini diamond now displays occupied bases.
- Added Single, Double, Triple and Home Run outcomes.
- GOOD contact can produce fly/ground outs.
- POWER, CONTACT, SPEED and opposing pitcher OVR now affect batted-ball outcomes.
- Added forced advancement on walks and runner advancement/scoring logic.
- Three outs clear the bases.
- This completes the main gameplay-foundation pass before Phase 7 visual reconstruction.

## Phase 7A
- First dedicated visual reconstruction phase.
- Added `VisualProfile` and reusable `CharacterPortrait`.
- Rebuilt Batter art and four-stage swing animation.
- Added bat trail and batter result reactions.
- Rebuilt Pitcher art and multi-stage windup/release animation.
- Added pitcher success/hit reactions.
- Rebuilt ContactEffect with stronger arcade VFX.
- PlayerCard and TEAM detail panel now use reusable chibi portraits.
- Added first visual stadium signage pass.
- Save remains v8; progression data is unchanged.


## Phase 7B
- Save version increased from v8 to v9.
- Added LUCK as a persistent player attribute.
- Training/TEAM/HUD now surface POWER / CONTACT / LUCK.
- SPEED remains an internal runner/defense attribute.
- Added historical-fidelity match flow: teammates simulate automatically and only the user's Hero is manually controlled.
- Added `TeamSimulationPanel` with TEAM AT BAT / YOUR TURN transitions.
- Preserved actual runners, hits, walks, outs and career stats during teammate simulation.
- Added `AudioManager` with optional local MP3 hooks.
- Original Kevin Lee/Syntasia audio is intentionally not bundled.
- Build script now copies optional `assets` into `build`.


## Phase 7C
- Save version increased from v9 to v10.
- Added persistent Special Batter Card collection.
- Added five Special Batter lineup slots.
- Added Coin/Credit-style slot unlocking approximation.
- Added Coin Pack and Premium Pack draws.
- Added NORMAL / RARE / ELITE / HERO Special Batter grades.
- Added duplicate copy counts and 3-copy COMBINE leveling.
- Added persistent Combo meter and Combo tiers.
- Combo affects simulated team offense plus Hero CONTACT/LUCK.
- Special Batters now replace up to five simulated teammate appearances.
- Added once-per-game inning-specific guaranteed-hit card triggers.
- Pregame displays equipped Special Batter count and Combo.

## Phase 8A — Uploaded Gameplay Reference Pass
- Directly analyzed the user-supplied 640x480 / 30 fps Baseball Heroes gameplay recording.
- Corrected the batting interpretation: the cyan/yellow circular element is a shrinking timing reticle at the pitch target, not a freely moved mouse-aim cursor.
- Implemented `CLICK ANYWHERE` behavior with a small click-input delay; SPACE remains immediate.
- Added independent strike/ball pitch targeting and a small translucent 3x3 strike grid.
- Tightened timing around late plate arrival and added NICE / EARLY SWING / LATE SWING feedback.
- Increased incoming-ball perspective scaling to match the dramatic original ball growth.
- Added `HitCinematic` for sky flight, outfield/fielder view and comic-style hit/out result cards.
- Rebuilt teammate simulation into an original-inspired two-lineup matchup board with line score, center diamond and x4/x2/x1 speed rail visuals.
- Rebuilt batting HUD hierarchy around the uploaded original: league badge, XP, energy, currencies, scoreboard, mini-field, Combo, player stats, Season Goal and Leaderboard.
- Adjusted batter/pitcher framing to better match the large foreground batter / small distant pitcher camera.

## Phase 8C — World Championship clean-video polish
- Re-analyzed the user-supplied no-commentary World Championship gameplay (1276x720, 25 fps, ~5:11).
- Replaced commentary-contaminated simulation SFX with cleaner transient-isolated clips from the new recording.
- Added event-specific simulation HIT / OUT / HOME RUN / Combo / transition SFX.
- Added large Special Batter card flash/popup during simulation.
- Added BASES LOADED!, POWER HIT and LUCKY HIT callouts.
- Added GRAND SLAM labeling and dedicated SFX.
- Added right-side Hero successful-hit history, matching the long-streak display visible in the reference gameplay.
- Redesigned normal postgame panel toward the original YOU WIN / MVP / BONUS card layout.
- Added WORLD54_VIDEO_ANALYSIS.md with a full gap analysis and next priorities.
