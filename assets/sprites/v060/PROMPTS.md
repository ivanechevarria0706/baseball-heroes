# Prompts originales de generación — v0.6.0

Modo: herramienta integrada image_gen, dos generaciones nuevas. No se usó CLI/API.

Resolución solicitada: 2048 × 2048; resolución recibida y conservada: 1254 × 1254 con alfa. Son reconstrucciones ilustradas, no sprites recuperados del juego. Los recortes reales y anclajes están en frame-layout.json; la cuadrícula solicitada no se siguió literalmente.

## Batter

```text
Use case: stylized-concept. Asset: a production transparent 2D baseball BATTER sprite sheet for a private nostalgic Flash baseball game remake.
Create exactly 16 full-body poses of one IDENTICAL chibi baseball hero in a precise 4 by 4 uniform grid on a square 2048 x 2048 canvas. Each of the 16 cells is 512 x 512 pixels; no grid lines, lettering, numbers, shadow, background or scenery. ACTUAL transparent alpha PNG, never a painted checkerboard.
Style: illustrated Korean casual sports Flash game circa 2012, bold crisp black ink outlines, simple flat cel shading and a few glossy highlights, exaggerated huge helmeted head about 45% of body height, skinny angular torso and short angular legs. Not baby proportions, not 3D, not realistic, not pixel art. Hero is viewed from behind and three-quarter LEFT SIDE, facing screen RIGHT toward an offscreen pitcher, back of helmet dominant, only a thin sliver of tan cheek visible at helmet's right edge. Same identity, direction and camera in every cell.
Appearance: large shiny BLUE helmet with cyan highlight and circular right ear guard; blank white jersey with blue sleeve panels, white pants, black belt, big black cleats with white soles, white batting gloves with blue wristbands. Oversized HONEY-GOLD wooden baseball bat: comically wide barrel tapering sharply to thin grip, like the large bats in 2010s casual baseball. No writing. Both hands together on grip during normal swing.
Technical layout: planted soles at cell-local y=465; center of hips at cell-local x=240. Helmet top around y=125, body height 340px. Bat may extend up to y=36 or out to x=488; all art must remain within its own cell, at least 20px from cell boundaries. Never crop feet or bat. Consistent character scale and foot baseline across all 16 cells.
Frame order left to right, top to bottom:
1 READY, feet planted shoulder width, bat upright raised behind left shoulder.
2 READY BREATH, same pose, slight elbow adjustment.
3 LOAD START, front knee begins rising, bat cocked backward.
4 FULL LOAD, front knee raised high, weight on back leg.
5 STRIDE, front leg stepping screen-right toward pitcher, hips begin turning, bat still back.
6 SWING START, hips rotate, hands drive forward right, bat still diagonally above hands.
7 CONTACT, both hands extend screen-right, bat exactly horizontal pointing right, feet planted.
8 EARLY FOLLOW, bat rises up and right after contact, rear heel pivots.
9 FULL FOLLOW, body more back-facing, arms and bat wrapped high around left shoulder, rear heel up.
10 FOLLOW SETTLE, same follow-through slightly relaxed.
11 RECOVER, bat lowered across body, torso returning to original side/back view.
12 READY RETURN, matching frame1 stance.
13 MISS DISAPPOINTMENT, head down slightly, lowered bat, shoulders droop.
14 MISS RECOVER, head rises, bat halfway back to ready.
15 SUCCESS, small one-handed bat raise and free fist, still facing right.
16 SUCCESS SETTLE, restrained cheer easing toward ready.
Draw all 16 frames with coherent motion and consistent proportions, clean separated silhouettes. No motion streaks, ball, text, numerals, logos, watermarks. Preserve real alpha transparency.
```

## Pitcher

```text
Use case: stylized-concept. Asset: a production transparent 2D baseball PITCHER sprite sheet for a private nostalgic Flash baseball game remake.
Exactly 16 full-body animation poses of ONE identical cartoon pitcher on a precisely aligned 4-column x 4-row uniform square sprite atlas, 2048 x 2048 requested. NO grid lines, text, frame labels, balls, shadows, scenery or backgrounds. Actual transparent alpha, not painted checkerboard.
Style: Korean casual sports Flash game around 2012, clean bold black ink outline, flat cel shadows, glossy small highlights, expressive angular eyes, huge chibi head (45 percent of body height), small skinny torso with short slim legs. Not realistic, not 3D, not baby character. Consistent character and body scale in all 16 poses.
Appearance: very large PURPLE baseball cap, dark near-black hair visible beneath its visor, warm light tan skin, purple short-sleeve buttoned jersey with blank chest, white pants with a narrow purple side stripe, black belt and dark black cleats with white soles. A LARGE BROWN baseball glove on his LEFT hand (screen RIGHT in the front view). Right-handed pitching: RIGHT throwing hand appears on screen LEFT before rotation. No baseball painted in any frame; the game will render the ball separately.
Camera: front view with slight three-quarter turn toward screen left; looking toward camera and slightly left toward the batter. Keep this camera in every pose. Do not turn back toward the viewer.
Technical grid: each cell 512x512, invisible boundaries. Planted shoes at cell-local y=465, hips centered x=256; body from cap top to soles ~340px. All fingers, glove and feet completely within their own cell with at least 24px transparent gutter. Same baseline and scale for all poses.
Frames row-major:
1 relaxed SET, feet planted, glove at chest and throwing hand touching glove.
2 SET BREATH, slight elbow shift, same standing pose.
3 WINDUP START, front knee begins to rise, hands together at chest.
4 KNEE RISE, front LEFT knee raised (screen RIGHT), right leg supports body.
5 HIGH KNEE, knee toward chest, glove near face, weight on back leg.
6 HAND SEPARATION, left glove reaches toward screen left/front; right throwing arm draws backward.
7 STRIDE, left foot stepping toward camera, right arm cocked high behind head.
8 ARM COCK, wider stride, elbow up, throwing forearm backward, planted left foot.
9 ACCELERATION, torso forward, throwing arm drives forward over shoulder.
10 RELEASE, torso leans toward camera, RIGHT throwing arm extends forward/down at lower chest level toward screen LEFT, open bare throwing hand clearly visible away from body at cell-local approximately x=174 y=330, glove tucked on screen RIGHT. No ball.
11 EARLY FOLLOW, right throwing hand passes down across body toward screen RIGHT, back heel lifted.
12 FULL FOLLOW, upper body bowed forward, throwing hand lower, rear leg raised.
13 RECOVERY, rear leg lands, torso rises, glove returns to chest.
14 READY TO FIELD, both feet wide, knees bent, glove low in front.
15 SUCCESS REACTION, head up and free fist raised subtly, glove held by hip.
16 HIT REACTION, concerned look following ball to upper right, glove ready.
Consistent face, glove hand, limb anatomy and scale. No extra limbs, lettering, numbers, logo, watermark, ball, motion streaks or environment. Crisp clean transparent silhouettes.
```

