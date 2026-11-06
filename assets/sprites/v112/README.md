# Training art · 0.10.12

Generated reconstruction using the **built-in image_gen tool**, based on the supplied character sheet and the remake's existing runner atlas. These are not recovered original Flash sprites. Generated source pixels and alpha are preserved; the game crops and isolates connected actors in memory.

Saved project assets:

- [Stretching: 24 body poses](stretching-atlas.png)
- [Lifting: 24 body poses](lifting-atlas.png)
- [Three supporting coaches](coaches-atlas.png)
- [Empty training room](training-room.png)

The saved player head is attached by the game through the unchanged BatterHead086 renderer. No generated face replaces it.

The complete final prompt set is in [prompts.json](prompts.json) and [coach-prompt.json](coach-prompt.json). [provenance.json](provenance.json) records hashes and dimensions; [layout.json](layout.json) records sprite rectangles and neck mounts. Pixel analysis computes metadata only.
