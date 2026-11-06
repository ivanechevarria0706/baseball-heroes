# Animation audit — Phase 8S

Audited runtime hooks:

- `Game.as` creates one `HitCinematic` and calls it for:
  - FLY OUT / GROUND OUT;
  - SINGLE;
  - DOUBLE;
  - TRIPLE;
  - HOME RUN;
  - STRIKE OUT.
- Double is mapped to celebration panel 02.
- Triple is mapped to celebration panel 03.
- Home Run is mapped to celebration panel 04.
- Grand Slam is mapped to celebration panel 01.
- Build script copies the entire `assets/` tree to `build/assets/`.
- Phase 8S adds explicit build checks for the celebration and portrait files.
- `HitCinematic` is raised to the top of the gameplay display list while
  playing so HUD and simulation UI cannot obscure the full-screen result.

The exact original Syntasia timing for these animations is not claimed; the
visual assets are user-supplied references/resources and the timing/state
machine is the remake's functional reconstruction.
