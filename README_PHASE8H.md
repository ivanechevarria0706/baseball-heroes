# Baseball Heroes Remake — Phase 8H
## Window / Cropping Fix

This phase fixes the problem where the AIR window looked cut off and some
buttons near the bottom could not be clicked.

## Fixes
- Added a centered root container with automatic scale-to-fit.
- If the visible AIR client area is smaller than 960x540, the whole game now
  scales down slightly instead of being cropped.
- If the window is larger, the game remains centered.
- Added black background fill outside the game area.
- Increased default AIR window size to 1024x640.
- Enabled window resizing.

## Result
Screens like Regular Season, Line Up, Result, Build, Shop and other views
should no longer lose their bottom buttons due to the window chrome / DPI issue.

## Run
```powershell
cd "C:\Users\ivane\Downloads\baseball_heroes_remake_phase8H_window_fix"
.\play.bat
```
