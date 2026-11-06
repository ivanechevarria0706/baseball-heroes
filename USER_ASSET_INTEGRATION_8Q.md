# Phase 8Q — supplied-image processing notes

The following processing was applied to the user-supplied images:

- Team logo sheet:
  - separated into a 6 x 5 grid;
  - outer navy sheet background removed from edge-connected pixels;
  - exported as transparent PNGs.

- League/mode sheet:
  - the first row was split into Rookie, Single-A, Double-A, Triple-A and Major;
  - navy background removed;
  - exported as transparent PNGs.

- Stadium images:
  - converted from the supplied WebP references to PNG;
  - center/bottom-biased crop to 16:9;
  - resized to 960 x 540, matching the logical game resolution.

All derived files are listed in:
`assets/reference/ASSET_MANIFEST.json`

Other supplied sheets (characters, equipment costumes, mode badges, card
packs, NPCs, celebration scenes and UI collages) are intentionally reserved
for later phases so each integration can be tested without changing too many
systems at once.
