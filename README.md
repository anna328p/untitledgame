# game

written in Ruby with SDL2. very little here right now, just some rendering code and prototype assets.

plans:
- roguelite RPG hybrid
- fluid combat mechanics (no clicking through dialogs)
  - the combat has real-time, interactive elements
    - possibility for finesse/well-executed actions without being annoyingly long/difficult
    - magic system uses patterns of chained runes to perform spells, more complex spells are longer
  - element synergy system
    - using the correct element against an enemy gives your attack a bonus and (?) gives you another turn
    - this needs to have balance considerations because it may make combat boring
- set in abandoned structure/complex
  - each stage corresponds to a floor and has its own feeling/aesthetic
  	- first stage: ground floor at night
  	- last stage: crumbling rooftop at sunset
  - stages have a procedurally generated layout but their order is scripted
  - the game has a story
- one character. as you progress throughout the game, you gain more skills/knowledge and specialize implicitly
- pixel art graphics, dimetric view (1:3, 18.435 deg)
