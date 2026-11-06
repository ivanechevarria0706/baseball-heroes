# World Championship 54th Season gameplay analysis

Source analyzed:
`Baseball Heroes Kediri City World Championship 54th season.mp4`

Metadata observed from the uploaded file:
- 1276 x 720
- 25 fps
- approximately 5:11
- no spoken commentary

This recording is much better as a reference because the original game music,
UI sounds, transitions and batting sounds are not covered by a narrator.

## HOME / Stadium lobby
The video opens on the original-style stadium home screen. Visible systems:
- large Hero at home plate;
- teammates lined across the field;
- LV / XP / energy / Coins / premium currency;
- trophy counters;
- World Championship series panel;
- friend/player card carousel;
- SHOP / RANKING / BUILD / HALL OF FAME;
- ticket/event objects and NPC/event portrait.

Our current HOME contains several of these concepts but still needs a dedicated
visual reconstruction pass to match this layout.

## World Championship
The recording gives a very clear missing high-level mode:
1. postseason / World Championship bracket;
2. best-of-series status;
3. U.S. travel-map animation;
4. lineup setup;
5. Baseball Heroes loading emblem;
6. team-versus-team intro;
7. full game;
8. WORLD CHAMPION celebration;
9. detailed YOU WIN / rewards / rank / MVP / bonus screen.

This should become a real mode rather than being approximated by the current
season-promotion summary.

## Pregame / Lineup
The original shows both complete lineups before PLAY:
- nine batting positions;
- team and opponent columns;
- bench/reserve area;
- position / player information;
- large PLAY control.

Our Lineup/Pregame screens are functionally useful but are still visually far
from this reference.

## Simulation between Hero turns
The clean video confirms the phase 8B discoveries and adds more detail:
- both teams are simulated player-by-player;
- active batter row is highlighted;
- results are stamped directly over rows;
- central bases update during simulation;
- full 1–9 inning line score;
- x4 / x2 / x1 speed controls;
- Combo gain popups at lower-left;
- Special Batter cards can flash in the center with a white burst and large
  result text (especially HOME RUN);
- the lineup interface disappears before returning to the batting camera.

Phase 8C adds the large Special Batter popup and cleaner event-specific SFX.

## Hero batting view
The recording clearly shows:
- league crest and LV/XP;
- energy with recharge timer;
- Coins and premium currency;
- center scoreboard with team logos, record, inning, bases and B/S/O;
- upper-right field/base display;
- large foreground batter and distant pitcher;
- small strike rectangle;
- bottom Combo gauge;
- Hero portrait/name;
- C / P / L values;
- AVG / HR / RBI / HIT;
- Season Goal HIT/RBI progress;
- Leaderboard score;
- a vertical history of successful hits at the right during a long streak.

Phase 8C adds a live Hero hit-history list.

## Batting callouts seen in the video
The footage includes:
- BASES LOADED!
- POWER HIT
- LUCKY HIT
- ONE BASE HIT
- THREE BASE HIT
- HOME RUN
- GRAND SLAM
- +1 RUN / +2 RUN / +4 RUN
- confetti after large scoring events.

Phase 8C adds BASES LOADED, POWER HIT, LUCKY HIT and GRAND SLAM presentation.

## Hit cinematics
The original does not use one generic hit animation. The video shows several
stages/variants:
- giant ball close-up;
- stadium rise / camera tilt;
- blue-sky or night-sky flight;
- radial speed lines;
- fielder/catch comedy animation;
- comic ONE/THREE BASE HIT graphics;
- HOME RUN burst;
- GRAND SLAM emblem;
- bonus/target graphics after some extra-base hits;
- run-count overlay after returning to the field.

Our HitCinematic has the overall multi-stage structure, but the exact art,
bonus targets and comedy fielder panels still need their own animation pass.

## Special Batter cards inside simulation
Several frames show a large card appearing over the lineup with a white flash
and HOME RUN banner. This is distinct from the small row stamp.

Phase 8C adds a vector replacement for that card-flash behavior.

## End of game
The recording finishes with:
- WORLD CHAMPION! banner;
- team celebration illustration;
- championship trophy;
- detailed score card;
- YOU WIN;
- Rank;
- MVP tile;
- BONUS tile;
- several reward counters;
- confetti.

Phase 8C redesigns the ordinary GameResultPanel toward this visual hierarchy.
The dedicated championship celebration is still missing and should be tied to
a future World Championship mode.

## Clean SFX extracted from the new uploaded video
The previous SFX came from a gameplay recording containing spoken commentary.
They have been replaced by clips isolated from this no-commentary recording.

Included in phase 8C:
- sim_hit.mp3
- sim_out.mp3
- sim_combo.mp3
- sim_transition.mp3
- sim_hero_in.mp3
- sim_special.mp3
- bases_loaded.mp3
- lucky_hit.mp3
- power_hit.mp3
- grand_slam.mp3
- home_run.mp3
- world_champion.mp3

The extraction uses the adjacent music bed as a noise profile, transient/
percussive separation, high-pass filtering and short fades. Because this is a
finished gameplay mix rather than original isolated audio stems, a faint trace
of the background music can remain, but it is substantially cleaner than the
commentary recording.

## Highest-priority gaps after phase 8C
1. Full World Championship bracket / best-of series / postseason state.
2. U.S. travel-map transition.
3. Faithful pregame Lineup vs Lineup screen.
4. Baseball Heroes loading emblem + animated team VS intro.
5. WORLD CHAMPION celebration sequence.
6. HOME stadium/lobby visual reconstruction including Ranking, Hall of Fame,
   ticket/event elements and friend-card carousel.
7. More faithful raster/chibi character art and animation.
8. Exact hit cinematics including bonus targets and fielder comedy panels.
9. More UI and gameplay SFX isolated from this clean video.
