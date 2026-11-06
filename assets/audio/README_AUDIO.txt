BASEBALL HEROES REMAKE - AUDIO 0.9.3

ACTIVE EFFECTS: only the four user-isolated Audacity recordings:
user_hero_hit.mp3, user_sim_hit.mp3, user_sim_out.mp3, user_strike.mp3.
Their bytes are unchanged. Game contact, simulated hits/outs and strikes use
these embedded effects, with existing synchronization and channel cleanup.

REJECTED: the user confirmed that FAF SINGLE and DOUBLE contain the gameplay
narrator. They are removed from the active bank and web package. All other
unverified gameplay SFX cuts are inactive too, including pitch/swing and legacy
result/UI clips. Automatic speech recognition was not evidence of clean game
audio. No replacement SINGLE/DOUBLE/TRIPLE announcement is claimed in this build.

The three existing music tracks remain: baseball_heroes.mp3, locker_room.mp3,
shop.mp3. The original full soundtrack and missing verified SFX are pending.
Unverified source cuts remain only as historical research references.

HISTORICAL NOTES BELOW (superseded by 0.9.3):

BASEBALL HEROES REMAKE - AUDIO

Revision 0.4.8: the user selected ONLY faf_sim_out.mp3 from the F.A.F. bank.
SimulationAudio preloads and reuses this clip for simulation outs.
Pitch, swing and contact clips are no longer active. They remain in reference_audio/faf.
See REVISION_CONTACTO_Y_OUT.md. Legacy notes follow.

This build includes the three MP3 files supplied by the user in this chat:

  baseball_heroes.mp3
  locker_room.mp3
  shop.mp3

Screen mapping:
  HOME / PREGAME -> baseball_heroes.mp3
  TEAM / TRAINING / SCOUT / SKILLS / EQUIPMENT / BUILD / CARDS
      -> locker_room.mp3
  SHOP -> shop.mp3
  BATTING -> music stops for now

The files are copied automatically into build/assets/audio by build.bat.


Simulation SFX extracted from the user's uploaded gameplay video:
  sim_combo.mp3
  sim_transition.mp3
  sim_hero_in.mp3

These short clips are used only during the original-style simulation screen.

Phase 8C no-commentary gameplay SFX:
  sim_hit.mp3
  sim_out.mp3
  sim_combo.mp3
  sim_transition.mp3
  sim_hero_in.mp3
  sim_special.mp3
  bases_loaded.mp3
  lucky_hit.mp3
  power_hit.mp3
  grand_slam.mp3
  home_run.mp3
  world_champion.mp3

These short clips were isolated from the World Championship gameplay video
provided by the user.
